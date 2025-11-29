#!/bin/bash

# Quick Start Without Docker - For Testing
# This starts the backend and frontend locally for quick testing

set -e

echo "🚀 Quick Start (No Docker) - VC UseCase Scoring"
echo ""
echo "⚠️  Note: This uses SQLite instead of PostgreSQL"
echo "    For production, use Docker (./start.sh)"
echo ""

# Check Python
if ! command -v python3 &> /dev/null; then
    echo "❌ Python 3 is required"
    exit 1
fi

# Check Node
if ! command -v node &> /dev/null; then
    echo "❌ Node.js is required"
    exit 1
fi

echo "📦 Setting up backend..."
cd backend

# Create virtual environment if it doesn't exist
if [ ! -d "venv" ]; then
    python3 -m venv venv
fi

# Activate virtual environment
source venv/bin/activate

# Install dependencies
pip install -q --upgrade pip
pip install -q -r requirements.txt

# Download models
python -m spacy download en_core_web_sm
python -c "import nltk; nltk.download('punkt', quiet=True); nltk.download('stopwords', quiet=True); nltk.download('wordnet', quiet=True)"

# Create local .env
cat > .env << EOL
DATABASE_URL=sqlite:///./test.db
REDIS_URL=redis://localhost:6379/0
SECRET_KEY=dev-secret-key-for-testing-only
DEBUG=true
USE_LOCAL_MODEL=true
EOL

echo "✅ Backend ready!"
echo ""

# Start backend in background
echo "🔧 Starting backend..."
uvicorn app.main:app --host 0.0.0.0 --port 8000 &
BACKEND_PID=$!
echo "   Backend PID: $BACKEND_PID"

cd ../frontend

echo ""
echo "📦 Setting up frontend..."

# Install dependencies if needed
if [ ! -d "node_modules" ]; then
    npm install
fi

echo "✅ Frontend ready!"
echo ""
echo "🎨 Starting frontend..."
npm run dev &
FRONTEND_PID=$!
echo "   Frontend PID: $FRONTEND_PID"

echo ""
echo "═══════════════════════════════════════════════"
echo "✅ Services Started!"
echo ""
echo "Frontend: http://localhost:5173"
echo "Backend:  http://localhost:8000"
echo "API Docs: http://localhost:8000/docs"
echo ""
echo "Press Ctrl+C to stop all services"
echo "═══════════════════════════════════════════════"

# Wait for Ctrl+C
trap "echo ''; echo '🛑 Stopping services...'; kill $BACKEND_PID $FRONTEND_PID 2>/dev/null; exit" INT

wait
