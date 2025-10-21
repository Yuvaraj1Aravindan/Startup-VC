import pytest
from app.scoring_engine import NLPScoringEngine


@pytest.fixture
def engine():
    return NLPScoringEngine()


def test_extract_keywords(engine):
    text = "AI-powered warehouse automation for logistics optimization"
    keywords = engine._extract_keywords(text)
    assert len(keywords) > 0
    assert any('warehouse' in kw.lower() for kw in keywords)


def test_extract_topics(engine):
    text = "Healthcare diagnosis using machine learning and AI"
    topics = engine._extract_topics(text)
    assert 'healthtech' in topics or 'ai_ml' in topics


def test_detect_intent(engine):
    idea = {
        'problem_statement': 'Manual processes are slow',
        'proposed_solution': 'Automate with AI'
    }
    intent = engine._detect_intent(idea)
    assert intent == 'automation'


def test_compute_alignment_score(engine):
    idea_features = {
        'keywords': ['automation', 'warehouse', 'logistics'],
        'topics': ['logistics'],
        'embedding': [0.1] * 384
    }
    
    usecase = {
        'title': 'Warehouse Automation',
        'description': 'Automate warehouse operations',
        'industry': 'logistics'
    }
    
    score, evidence = engine.compute_alignment_score(idea_features, usecase)
    assert 0 <= score <= 1
    assert isinstance(evidence, list)


def test_compute_novelty_score(engine):
    idea_features = {
        'innovation_signals': ['novel_technology', 'unique_approach']
    }
    score = engine.compute_novelty_score(idea_features)
    assert 0 <= score <= 1
    assert score > 0.5  # Should be higher with innovation signals


def test_compute_viability_score(engine):
    idea_features = {
        'market_readiness': 0.75
    }
    score = engine.compute_viability_score(idea_features)
    assert score == 0.75


def test_generate_explanation(engine):
    idea = {'title': 'Test Idea'}
    usecase = {'title': 'Test UseCase'}
    scores = {
        'overall': 75.0,
        'alignment': 0.8,
        'novelty': 0.7,
        'viability': 0.6
    }
    evidence = ['keyword match']
    
    explanation = engine.generate_explanation(idea, usecase, scores, evidence)
    assert 'Test Idea' in explanation
    assert '75' in explanation
    assert len(explanation) > 50


def test_recommend_actions(engine):
    scores = {'overall': 80, 'novelty': 0.6, 'viability': 0.7}
    actions = engine.recommend_actions(scores)
    assert len(actions) > 0
    assert all(isinstance(action, str) for action in actions)
