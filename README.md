# VC UseCase Scoring Application

A complete application for evaluating startup ideas against VC use cases with AI-powered scoring and explanations.

> **👥 Team Members**: See [TEAM_ACCESS.md](./TEAM_ACCESS.md) for cloning, setup, and contribution guidelines.  
> **🌐 Live Demo**: http://4.213.154.131 | **📚 API Docs**: http://4.213.154.131/docs

## Features

- 🎯 **Smart Matching**: NLP-powered alignment scoring between startup ideas and VC pain points
- 📊 **Detailed Analysis**: 0-100% scoring with explainable breakdowns
- 🔐 **Role-based Access**: Separate interfaces for VCs, startup aspirants, and admins
- 🚀 **Batch Processing**: Evaluate multiple ideas against multiple use cases
- 📈 **Comprehensive Reports**: Detailed evaluation reports with recommendations
- 🔒 **Secure**: JWT authentication, encrypted data at rest

## Tech Stack

### Backend
- **Python 3.12** with **FastAPI**
- **PostgreSQL** for data storage
- **Redis** for caching
- **Sentence Transformers** for embeddings
- **spaCy** for NLP processing
- **SQLAlchemy** ORM

### Frontend
- **React 18** with **Vite**
- **Tailwind CSS** for styling
- **Axios** for API calls
- **React Router** for navigation

### Infrastructure
- **Docker** & **Docker Compose**
- **GitHub Actions** for CI/CD
- **pytest** for testing

## Quick Start

### Prerequisites
- Docker & Docker Compose
- Python 3.12+ (for local development)
- Node.js 18+ (for frontend development)

### Installation

1. **Clone the repository**
```bash
git clone <repository-url>
cd vc-usecase-scoring
```

2. **Set up environment variables**
```bash
cp .env.example .env
# Edit .env with your configuration
```

3. **Start with Docker Compose**
```bash
docker-compose up -d
```

This will start:
- PostgreSQL on port 5432
- Redis on port 6379
- Backend API on port 8000
- Frontend on port 5173

4. **Access the application**
- Frontend: http://localhost:5173
- API Docs: http://localhost:8000/docs
- API: http://localhost:8000

### Local Development

#### Backend Setup
```bash
cd backend
python -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate
pip install -r requirements.txt

# Download NLP models
python -m spacy download en_core_web_sm
python -c "import nltk; nltk.download('punkt'); nltk.download('stopwords')"

# Run migrations
alembic upgrade head

# Start server
uvicorn app.main:app --reload
```

#### Frontend Setup
```bash
cd frontend
npm install
npm run dev
```

## API Documentation

### Authentication

#### Register User
```http
POST /api/register
Content-Type: application/json

{
  "email": "user@example.com",
  "password": "securepassword",
  "full_name": "John Doe",
  "role": "startup_aspirant"  // or "vc_representative", "system_admin"
}
```

#### Login
```http
POST /api/token
Content-Type: application/x-www-form-urlencoded

username=user@example.com&password=securepassword
```

### VC Use Cases

#### Create Use Case
```http
POST /api/vc/usecases
Authorization: Bearer <token>
Content-Type: application/json

{
  "title": "Streamline Supply Chain Logistics",
  "description": "Looking for solutions to optimize warehouse operations...",
  "industry": "logistics",
  "domain": "operations",
  "tags": ["automation", "efficiency", "IoT"],
  "importance_weight": 0.8
}
```

#### Bulk Upload Use Cases
```http
POST /api/vc/usecases/bulk
Authorization: Bearer <token>
Content-Type: application/json

{
  "usecases": [...]
}
```

### Startup Ideas

#### Submit Idea
```http
POST /api/ideas
Authorization: Bearer <token>
Content-Type: application/json

{
  "title": "AI-Powered Warehouse Robot",
  "short_pitch": "Autonomous robots for warehouse picking",
  "problem_statement": "Manual picking is slow and error-prone",
  "target_industry": "logistics",
  "proposed_solution": "Computer vision + robotics for automation",
  "differentiators": "30% faster than competitors",
  "market_signals": "3 pilot customers committed"
}
```

### Evaluation

#### Evaluate Single Idea
```http
POST /api/evaluate
Authorization: Bearer <token>
Content-Type: application/json

{
  "idea_id": 1,
  "usecase_id": 1
}
```

#### Bulk Evaluation
```http
POST /api/evaluate/bulk
Authorization: Bearer <token>
Content-Type: application/json

{
  "idea_ids": [1, 2, 3],
  "usecase_ids": [1, 2]
}
```

#### Get Evaluation Report
```http
GET /api/ideas/{idea_id}/report
Authorization: Bearer <token>
```

## Scoring Algorithm

The scoring system uses multiple factors:

1. **Alignment Score (50%)**: Semantic similarity between idea and use case
   - Sentence embeddings cosine similarity (40%)
   - Keyword overlap (30%)
   - Topic matching (20%)
   - Industry alignment (10%)

2. **Novelty Score (30%)**: Innovation indicators
   - Novel technology usage
   - Unique approach signals
   - Process improvements

3. **Viability Score (20%)**: Market readiness
   - Customer traction
   - Revenue signals
   - Partnership indicators

### Example Evaluation Response
```json
{
  "idea": {...},
  "overall_score": 78.5,
  "per_usecase_scores": [{
    "usecase_id": 1,
    "usecase_title": "Supply Chain Optimization",
    "score": 78.5,
    "alignment_score": 0.82,
    "explanation": "Strong alignment with automation needs...",
    "matched_evidence": ["automation", "efficiency", "IoT"]
  }],
  "aggregated_explanation": "## Evaluation Summary...",
  "confidence": 0.85,
  "recommended_actions": [
    "Schedule a pitch meeting with the VC",
    "Prepare detailed financial projections"
  ]
}
```

## Testing

```bash
# Backend tests
cd backend
pytest tests/ -v --cov=app

# Frontend tests
cd frontend
npm test
```

## Deployment

### Production Checklist
- [ ] Change `SECRET_KEY` in `.env`
- [ ] Set `DEBUG=false`
- [ ] Configure production database
- [ ] Set up SSL/TLS certificates
- [ ] Configure CORS for production domains
- [ ] Set up monitoring and logging
- [ ] Enable database backups

### Docker Production Build
```bash
docker-compose -f docker-compose.prod.yml up -d
```

## Architecture

```
┌─────────────────┐
│  React Frontend │
│   (Port 5173)   │
└────────┬────────┘
         │
         ↓
┌─────────────────┐
│  FastAPI Backend│
│   (Port 8000)   │
└────┬─────┬──────┘
     │     │
     ↓     ↓
┌─────────┐ ┌──────┐
│PostgreSQL│ │Redis │
│ (5432)  │ │(6379)│
└─────────┘ └──────┘
```

## Project Structure

```
vc-usecase-scoring/
├── backend/
│   ├── app/
│   │   ├── main.py              # FastAPI app
│   │   ├── models.py            # SQLAlchemy models
│   │   ├── schemas.py           # Pydantic schemas
│   │   ├── database.py          # Database connection
│   │   ├── config.py            # Configuration
│   │   ├── auth.py              # Authentication
│   │   └── scoring_engine.py   # NLP scoring logic
│   ├── tests/
│   ├── requirements.txt
│   └── Dockerfile
├── frontend/
│   ├── src/
│   ├── package.json
│   └── Dockerfile
├── docker-compose.yml
├── .env.example
└── README.md
```

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License.

## Support

For issues and questions:
- GitHub Issues: [Create an issue]
- Email: support@example.com

## Roadmap

- [ ] Advanced ML models for scoring
- [ ] Real-time collaboration features
- [ ] Integration with pitch deck analyzers
- [ ] Mobile app
- [ ] Market trend analysis
- [ ] Automated feedback loops
