import numpy as np
from typing import Dict, List, Any, Tuple
from sentence_transformers import SentenceTransformer
import spacy
import nltk
from nltk.tokenize import word_tokenize
from nltk.corpus import stopwords
from sklearn.metrics.pairwise import cosine_similarity
import re
import redis
import json
from app.config import settings


class NLPScoringEngine:
    def __init__(self):
        # Load models
        if settings.USE_LOCAL_MODEL:
            self.embedding_model = SentenceTransformer(settings.NLP_MODEL)
        else:
            self.embedding_model = None
        
        try:
            self.nlp = spacy.load("en_core_web_sm")
        except OSError:
            print("Downloading spaCy model...")
            import subprocess
            subprocess.run(["python", "-m", "spacy", "download", "en_core_web_sm"], check=True)
            self.nlp = spacy.load("en_core_web_sm")
        
        # Initialize NLTK
        try:
            self.stop_words = set(stopwords.words('english'))
        except:
            nltk.download('stopwords')
            self.stop_words = set(stopwords.words('english'))
        
        # Redis for caching
        try:
            self.redis_client = redis.from_url(settings.REDIS_URL)
        except:
            self.redis_client = None
    
    def extract_features(self, idea: Dict[str, str]) -> Dict[str, Any]:
        """Extract NLP features from startup idea"""
        cache_key = f"features:{hash(str(idea))}"
        
        # Check cache
        if self.redis_client:
            cached = self.redis_client.get(cache_key)
            if cached:
                return json.loads(cached)
        
        # Combine text fields
        combined_text = f"{idea.get('title', '')} {idea.get('short_pitch', '')} {idea.get('problem_statement', '')} {idea.get('proposed_solution', '')}"
        
        # Extract features
        features = {
            'keywords': self._extract_keywords(combined_text),
            'entities': self._extract_entities(combined_text),
            'topics': self._extract_topics(combined_text),
            'intent': self._detect_intent(idea),
            'innovation_signals': self._detect_innovation_signals(idea),
            'market_readiness': self._assess_market_readiness(idea),
            'embedding': self._get_embedding(combined_text).tolist() if self.embedding_model else []
        }
        
        # Cache features
        if self.redis_client:
            self.redis_client.setex(cache_key, 3600, json.dumps(features))
        
        return features
    
    def _extract_keywords(self, text: str) -> List[str]:
        """Extract important keywords using frequency and POS tagging"""
        doc = self.nlp(text.lower())
        keywords = []
        
        # Extract nouns and noun phrases
        for token in doc:
            if token.pos_ in ['NOUN', 'PROPN'] and token.text not in self.stop_words:
                keywords.append(token.text)
        
        # Extract noun chunks
        for chunk in doc.noun_chunks:
            if len(chunk.text.split()) > 1:
                keywords.append(chunk.text)
        
        return list(set(keywords))[:20]  # Top 20 keywords
    
    def _extract_entities(self, text: str) -> List[Dict[str, str]]:
        """Extract named entities"""
        doc = self.nlp(text)
        entities = []
        
        for ent in doc.ents:
            entities.append({
                'text': ent.text,
                'label': ent.label_
            })
        
        return entities
    
    def _extract_topics(self, text: str) -> List[str]:
        """Extract high-level topics (simplified implementation)"""
        # Domain-specific keywords mapping
        topic_keywords = {
            'fintech': ['payment', 'finance', 'banking', 'transaction', 'credit', 'loan'],
            'healthtech': ['health', 'medical', 'patient', 'diagnosis', 'treatment', 'clinical'],
            'edtech': ['education', 'learning', 'student', 'teaching', 'course', 'training'],
            'saas': ['software', 'platform', 'cloud', 'api', 'integration', 'automation'],
            'ecommerce': ['shopping', 'retail', 'product', 'marketplace', 'commerce', 'merchant'],
            'ai_ml': ['artificial intelligence', 'machine learning', 'neural network', 'prediction', 'model'],
            'blockchain': ['blockchain', 'crypto', 'decentralized', 'smart contract', 'token'],
            'iot': ['sensor', 'device', 'connected', 'iot', 'hardware', 'monitoring']
        }
        
        text_lower = text.lower()
        detected_topics = []
        
        for topic, keywords in topic_keywords.items():
            if any(keyword in text_lower for keyword in keywords):
                detected_topics.append(topic)
        
        return detected_topics
    
    def _detect_intent(self, idea: Dict[str, str]) -> str:
        """Detect primary intent/goal of the startup"""
        problem = idea.get('problem_statement', '').lower()
        solution = idea.get('proposed_solution', '').lower()
        
        if any(word in problem + solution for word in ['automate', 'efficiency', 'streamline']):
            return 'automation'
        elif any(word in problem + solution for word in ['connect', 'network', 'marketplace']):
            return 'marketplace'
        elif any(word in problem + solution for word in ['data', 'analytics', 'insights']):
            return 'data_intelligence'
        elif any(word in problem + solution for word in ['experience', 'user', 'interface']):
            return 'user_experience'
        else:
            return 'general_innovation'
    
    def _detect_innovation_signals(self, idea: Dict[str, str]) -> List[str]:
        """Detect signals of innovation"""
        signals = []
        differentiators = idea.get('differentiators', '').lower()
        solution = idea.get('proposed_solution', '').lower()
        
        innovation_patterns = {
            'novel_technology': ['ai', 'machine learning', 'blockchain', 'quantum'],
            'unique_approach': ['unique', 'novel', 'first', 'innovative', 'revolutionary'],
            'process_improvement': ['faster', 'efficient', 'optimize', 'improve'],
            'cost_reduction': ['cheaper', 'reduce cost', 'affordable', 'economical'],
            'scalability': ['scalable', 'scale', 'growth', 'expand']
        }
        
        for signal_type, keywords in innovation_patterns.items():
            if any(keyword in differentiators + solution for keyword in keywords):
                signals.append(signal_type)
        
        return signals
    
    def _assess_market_readiness(self, idea: Dict[str, str]) -> float:
        """Assess market readiness score (0-1)"""
        market_signals = idea.get('market_signals', '').lower()
        score = 0.5  # baseline
        
        # Positive indicators
        positive_indicators = [
            'customer', 'user', 'pilot', 'beta', 'revenue', 'traction',
            'partnership', 'commitment', 'demand', 'validated'
        ]
        
        for indicator in positive_indicators:
            if indicator in market_signals:
                score += 0.05
        
        return min(score, 1.0)
    
    def _get_embedding(self, text: str) -> np.ndarray:
        """Get sentence embedding"""
        if self.embedding_model:
            return self.embedding_model.encode(text)
        return np.zeros(384)  # Placeholder
    
    def compute_alignment_score(
        self,
        idea_features: Dict[str, Any],
        usecase: Dict[str, Any]
    ) -> Tuple[float, List[str]]:
        """Compute alignment between idea and VC use case"""
        # Get usecase embedding
        usecase_text = f"{usecase.get('title', '')} {usecase.get('description', '')}"
        usecase_embedding = self._get_embedding(usecase_text)
        
        # Semantic similarity
        if len(idea_features.get('embedding', [])) > 0:
            idea_embedding = np.array(idea_features['embedding'])
            semantic_score = cosine_similarity(
                idea_embedding.reshape(1, -1),
                usecase_embedding.reshape(1, -1)
            )[0][0]
        else:
            semantic_score = 0.5
        
        # Keyword overlap
        usecase_keywords = set(self._extract_keywords(usecase_text))
        idea_keywords = set(idea_features.get('keywords', []))
        keyword_overlap = len(usecase_keywords & idea_keywords) / max(len(usecase_keywords), 1)
        
        # Topic match
        usecase_topics = set(self._extract_topics(usecase_text))
        idea_topics = set(idea_features.get('topics', []))
        topic_match = len(usecase_topics & idea_topics) / max(len(usecase_topics), 1) if usecase_topics else 0
        
        # Industry match
        industry_match = 1.0 if usecase.get('industry', '').lower() in str(idea_features).lower() else 0.3
        
        # Weighted alignment
        alignment = (
            0.4 * semantic_score +
            0.3 * keyword_overlap +
            0.2 * topic_match +
            0.1 * industry_match
        )
        
        # Evidence
        matched_keywords = list(usecase_keywords & idea_keywords)[:5]
        evidence = [f"Matched keyword: {kw}" for kw in matched_keywords]
        
        return alignment, evidence
    
    def compute_novelty_score(self, idea_features: Dict[str, Any]) -> float:
        """Compute novelty/innovation score"""
        innovation_signals = idea_features.get('innovation_signals', [])
        
        # More innovation signals = higher novelty
        base_score = 0.5
        signal_bonus = min(len(innovation_signals) * 0.1, 0.4)
        
        return base_score + signal_bonus
    
    def compute_viability_score(self, idea_features: Dict[str, Any]) -> float:
        """Compute business viability score"""
        market_readiness = idea_features.get('market_readiness', 0.5)
        
        # Consider market readiness and other signals
        return market_readiness
    
    def generate_explanation(
        self,
        idea: Dict[str, Any],
        usecase: Dict[str, Any],
        scores: Dict[str, float],
        evidence: List[str]
    ) -> str:
        """Generate human-readable explanation"""
        overall = scores['overall']
        alignment = scores['alignment']
        novelty = scores['novelty']
        viability = scores['viability']
        
        explanation = f"## Evaluation Summary\n\n"
        explanation += f"The startup idea '{idea.get('title', 'Untitled')}' scores **{overall:.1f}%** "
        explanation += f"in alignment with the VC use case '{usecase.get('title', 'Untitled')}'.\n\n"
        
        explanation += f"### Score Breakdown\n"
        explanation += f"- **Alignment Score**: {alignment*100:.1f}% - "
        if alignment > 0.7:
            explanation += "Strong alignment with the pain point.\n"
        elif alignment > 0.5:
            explanation += "Moderate alignment with the pain point.\n"
        else:
            explanation += "Limited alignment with the pain point.\n"
        
        explanation += f"- **Novelty Score**: {novelty*100:.1f}% - "
        if novelty > 0.7:
            explanation += "Highly innovative approach.\n"
        elif novelty > 0.5:
            explanation += "Some innovative elements.\n"
        else:
            explanation += "Incremental innovation.\n"
        
        explanation += f"- **Viability Score**: {viability*100:.1f}% - "
        if viability > 0.7:
            explanation += "Strong market validation signals.\n"
        elif viability > 0.5:
            explanation += "Some market traction indicators.\n"
        else:
            explanation += "Early-stage with limited market validation.\n"
        
        if evidence:
            explanation += f"\n### Matched Evidence\n"
            for ev in evidence[:3]:
                explanation += f"- {ev}\n"
        
        return explanation
    
    def recommend_actions(self, scores: Dict[str, float]) -> List[str]:
        """Generate recommended next actions"""
        actions = []
        
        if scores['overall'] > 75:
            actions.append("Schedule a pitch meeting with the VC")
            actions.append("Prepare detailed financial projections")
        elif scores['overall'] > 50:
            actions.append("Refine the pitch to better address the pain point")
            actions.append("Gather more market validation data")
        else:
            actions.append("Consider pivoting to better align with VC priorities")
            actions.append("Conduct customer discovery interviews")
        
        if scores['novelty'] < 0.5:
            actions.append("Highlight unique differentiators more clearly")
        
        if scores['viability'] < 0.5:
            actions.append("Develop pilot programs to demonstrate traction")
        
        return actions
