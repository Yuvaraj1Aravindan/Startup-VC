#!/bin/bash

echo "╔════════════════════════════════════════════════════════════════╗"
echo "║  Setting up VC-Startup Platform Development Environment       ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo ""

# Install backend dependencies
echo "📦 Installing backend dependencies..."
cd /workspace/backend
pip install --upgrade pip
pip install -r requirements.txt
echo "✓ Backend dependencies installed"
echo ""

# Install frontend dependencies
echo "📦 Installing frontend dependencies..."
cd /workspace/frontend
npm install
echo "✓ Frontend dependencies installed"
echo ""

# Set up database
echo "🗄️  Setting up database..."
cd /workspace
# Wait for PostgreSQL to be ready
sleep 5
python -c "
from backend.database import engine, Base
from backend.models import VCUseCase, Idea, Evaluation
Base.metadata.create_all(bind=engine)
print('✓ Database tables created')
"
echo ""

# Load sample data if available
if [ -f "/workspace/test-data/sample-data.json" ]; then
    echo "📊 Loading sample data..."
    cd /workspace/scripts
    bash load-sample-data.sh
    echo "✓ Sample data loaded"
fi
echo ""

echo "╔════════════════════════════════════════════════════════════════╗"
echo "║  ✓ Development Environment Ready!                             ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo ""
echo "🚀 Quick Start Commands:"
echo ""
echo "Start backend:"
echo "  cd backend && uvicorn app.main:app --reload --host 0.0.0.0 --port 8000"
echo ""
echo "Start frontend:"
echo "  cd frontend && npm run dev"
echo ""
echo "Run tests:"
echo "  cd backend && pytest"
echo "  npx playwright test"
echo ""
echo "Access services:"
echo "  Backend API: http://localhost:8000"
echo "  Frontend: http://localhost:5173"
echo "  API Docs: http://localhost:8000/docs"
echo ""
