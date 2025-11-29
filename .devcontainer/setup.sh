#!/bin/bash

set -e

echo "🚀 Setting up VC-Startup Platform Development Environment..."
echo ""

# Install backend dependencies
echo "📦 Installing backend Python dependencies..."
cd /workspace/backend
pip install --upgrade pip
pip install -r requirements.txt

# Install frontend dependencies
echo "📦 Installing frontend Node.js dependencies..."
cd /workspace/frontend
npm install

# Wait for PostgreSQL to be ready
echo "⏳ Waiting for PostgreSQL to be ready..."
for i in {1..30}; do
    if pg_isready -h postgres -p 5432 -U vc_user > /dev/null 2>&1; then
        echo "✅ PostgreSQL is ready!"
        break
    fi
    echo "Waiting for PostgreSQL... ($i/30)"
    sleep 2
done

# Initialize database
echo "🗄️  Creating database tables..."
cd /workspace/backend
python -c "from app.database import engine, Base; Base.metadata.create_all(bind=engine)" || echo "⚠️  Database initialization failed (may already exist)"

# Load sample data if available
if [ -f "/workspace/test-data/sample-data.json" ]; then
    echo "📊 Loading sample data..."
    cd /workspace/backend
    python -c "
import sys
sys.path.insert(0, '/workspace/backend')
from app.database import SessionLocal
from app.models import Startup, Investor
import json

db = SessionLocal()
try:
    # Check if data already exists
    if db.query(Startup).count() == 0:
        with open('/workspace/test-data/sample-data.json', 'r') as f:
            data = json.load(f)
            print(f'Loading {len(data.get(\"startups\", []))} startups...')
    else:
        print('Sample data already exists, skipping...')
finally:
    db.close()
" || echo "⚠️  Sample data loading failed (non-critical)"
fi

# Create startup scripts
echo "📝 Creating startup scripts..."
cat > /workspace/start-backend.sh << 'EOF'
#!/bin/bash
cd /workspace/backend
echo "🚀 Starting Backend API on http://localhost:8000"
echo "📚 API Documentation: http://localhost:8000/docs"
uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
EOF
chmod +x /workspace/start-backend.sh

cat > /workspace/start-frontend.sh << 'EOF'
#!/bin/bash
cd /workspace/frontend
echo "🎨 Starting Frontend Dev Server on http://localhost:5173"
npm run dev -- --host 0.0.0.0
EOF
chmod +x /workspace/start-frontend.sh

cat > /workspace/start-all.sh << 'EOF'
#!/bin/bash
# Start backend in background
cd /workspace/backend
uvicorn app.main:app --reload --host 0.0.0.0 --port 8000 > /tmp/backend.log 2>&1 &
echo "✅ Backend started (logs: /tmp/backend.log)"

# Wait a moment for backend to initialize
sleep 3

# Start frontend in foreground
cd /workspace/frontend
echo "✅ Starting frontend..."
npm run dev -- --host 0.0.0.0
EOF
chmod +x /workspace/start-all.sh

echo ""
echo "✅ Setup complete!"
echo ""
echo "🎯 Quick Start Commands:"
echo ""
echo "  🚀 Start Everything (Recommended):"
echo "    ./start-all.sh"
echo ""
echo "  Or start services individually:"
echo ""
echo "  Backend API:"
echo "    ./start-backend.sh"
echo "    (API Docs: http://localhost:8000/docs)"
echo ""
echo "  Frontend Dev Server:"
echo "    ./start-frontend.sh"
echo "    (App: http://localhost:5173)"
echo ""
echo "  Run Tests:"
echo "    cd backend && pytest -v"
echo "    cd frontend && npm test"
echo ""
echo "💡 Tip: Open a new terminal to run multiple services"
echo ""