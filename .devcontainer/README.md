# 🚀 Running in GitHub Codespaces

## Welcome to VC-Startup Platform Codespace! 🎉

Your development environment is ready with all dependencies installed and services running.

### ⚡ Quick Start (Fastest Way)

Open a terminal and run:

```bash
./start-all.sh
```

This will start both backend and frontend automatically!

### 🌐 Access Your Application

Once started, Codespaces will automatically forward ports:

- **Frontend**: Click on the "Ports" tab → Open port 5173
- **Backend API**: http://localhost:8000
- **API Documentation**: http://localhost:8000/docs
- **Interactive API**: http://localhost:8000/redoc

### 📂 Project Structure

```
/workspace/
├── backend/           # FastAPI backend
│   ├── app/
│   │   ├── main.py           # API entry point
│   │   ├── models.py         # Database models
│   │   ├── schemas.py        # Pydantic schemas
│   │   ├── scoring_engine.py # Scoring logic
│   │   └── database.py       # Database connection
│   └── requirements.txt
├── frontend/          # React frontend
│   ├── src/
│   │   ├── App.jsx
│   │   ├── pages/
│   │   └── components/
│   └── package.json
├── test-data/         # Sample data
└── .devcontainer/     # Codespaces config
```

### 🎯 Individual Service Commands

#### Start Backend Only

```bash
./start-backend.sh
```

Or manually:
```bash
cd backend
uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
```

#### Start Frontend Only

```bash
./start-frontend.sh
```

Or manually:
```bash
cd frontend
npm run dev -- --host 0.0.0.0
```

### 🗄️ Database Access

PostgreSQL is running and accessible:

```bash
# Connect to database
psql -h postgres -U vc_user -d vc_scoring_db
# Password: vc_password

# Check tables
psql -h postgres -U vc_user -d vc_scoring_db -c "\dt"

# View data
psql -h postgres -U vc_user -d vc_scoring_db -c "SELECT * FROM startups LIMIT 5;"
```

### 🔍 Redis Cache

Redis is running on port 6379:

```bash
# Connect to Redis
redis-cli -h redis

# Check connection
redis-cli -h redis ping
# Should return: PONG

# View keys
redis-cli -h redis KEYS '*'
```

### 🧪 Running Tests

#### Backend Tests

```bash
cd backend
pytest -v                    # Run all tests
pytest -v --cov=app         # With coverage
pytest tests/test_api.py    # Specific test file
```

#### Frontend Tests

```bash
cd frontend
npm test                    # Run tests
npm run lint               # Lint check
npx playwright test        # E2E tests
```

### 🔧 Common Tasks

#### View Backend Logs

```bash
tail -f /tmp/backend.log
```

#### Restart Services

```bash
# Kill processes
pkill -f uvicorn
pkill -f vite

# Restart
./start-all.sh
```

#### Check Service Health

```bash
# Backend health
curl http://localhost:8000/health

# Database connection
pg_isready -h postgres -U vc_user

# Redis connection
redis-cli -h redis ping
```

#### Install New Dependencies

```bash
# Python packages
cd backend
pip install <package-name>
pip freeze > requirements.txt

# Node packages
cd frontend
npm install <package-name>
```

### 🐛 Debugging

#### Backend Debugging

The backend runs with `--reload` flag, so changes are automatically reloaded.

To debug:
1. Set breakpoints in VS Code
2. Use the "Python: FastAPI" debug configuration
3. Or add `import pdb; pdb.set_trace()` in your code

#### Frontend Debugging

1. Open browser DevTools (F12)
2. Use React DevTools extension
3. Check console for errors
4. Hot reload is enabled - changes appear instantly

### 📊 Database Management

#### Reset Database

```bash
cd backend
python -c "from app.database import engine, Base; Base.metadata.drop_all(bind=engine); Base.metadata.create_all(bind=engine)"
```

#### Reload Sample Data

```bash
cd backend
python -c "
import sys, json
sys.path.insert(0, '/workspace/backend')
from app.database import SessionLocal
from app.models import Startup, Investor, MatchScore

db = SessionLocal()
# Add your data loading logic here
db.close()
"
```

### 🌟 Pro Tips

1. **Multiple Terminals**: Open multiple terminals in VS Code to run backend, frontend, and tests simultaneously
   - Click "+" in the terminal panel
   - Or use `Ctrl+Shift+` ` (backtick)

2. **Port Forwarding**: Codespaces automatically forwards ports and makes them accessible via HTTPS
   - Click "Ports" tab to see all forwarded ports
   - Click globe icon to open in browser
   - Ports are private by default (only accessible to you)

3. **Environment Variables**: Edit `.env` files in backend/frontend directories
   ```bash
   # Backend: /workspace/backend/.env
   DATABASE_URL=postgresql://vc_user:vc_password@postgres:5432/vc_scoring_db
   REDIS_URL=redis://redis:6379/0
   SECRET_KEY=your-secret-key
   ```

4. **VS Code Extensions**: Pre-installed extensions:
   - Python (linting, formatting, debugging)
   - ESLint (JavaScript linting)
   - Prettier (code formatting)
   - Tailwind CSS IntelliSense
   - Docker support
   - GitLens (Git supercharged)

5. **Auto-Save**: Enable auto-save for faster development
   - File → Auto Save
   - Or: `Ctrl+,` → search "auto save"

### 🚨 Troubleshooting

#### Backend won't start

```bash
# Check if port is already in use
lsof -i :8000

# Kill process if needed
pkill -f uvicorn

# Check logs
cat /tmp/backend.log

# Verify database connection
psql -h postgres -U vc_user -d vc_scoring_db
```

#### Frontend won't start

```bash
# Check node_modules
cd frontend
rm -rf node_modules package-lock.json
npm install

# Check port
lsof -i :5173

# Clear Vite cache
rm -rf frontend/.vite
```

#### Database connection issues

```bash
# Check if PostgreSQL is running
docker ps | grep postgres

# Wait for PostgreSQL to be ready
pg_isready -h postgres -U vc_user

# Restart database container (if needed)
docker restart vc_postgres_codespace
```

#### Port not forwarding

1. Check "Ports" tab in VS Code
2. Ensure service is running on 0.0.0.0 (not 127.0.0.1)
3. Try manually forwarding: "Ports" → "Forward a Port"

### 📖 API Documentation

Once backend is running, visit:

- **Swagger UI**: http://localhost:8000/docs
  - Interactive API documentation
  - Try API endpoints directly
  - View request/response schemas

- **ReDoc**: http://localhost:8000/redoc
  - Alternative documentation view
  - Better for reading

### 🔐 Sample Credentials

For testing authentication:

```
Test User:
Email: test@startup.com
Password: testpassword123
```

### 💾 Data Persistence

- **PostgreSQL data**: Persisted in Docker volume `postgres_data`
- **Redis data**: Persisted in Docker volume `redis_data`
- **Code changes**: Automatically saved to workspace
- **Codespace state**: Preserved between sessions

### 🛑 Stopping Services

To stop all services:

```bash
# Stop backend
pkill -f uvicorn

# Stop frontend
pkill -f vite

# Or simply close the terminals
```

Codespace automatically pauses after 30 minutes of inactivity to save resources.

### 📞 Need Help?

- Check logs: `/tmp/backend.log` or frontend terminal
- View API errors: http://localhost:8000/docs
- Check database: `psql -h postgres -U vc_user -d vc_scoring_db`
- Review documentation: `/workspace/CODESPACES_CICD_GUIDE.md`

---

## 🎊 Happy Coding!

Your VC-Startup Platform is ready to go. Start with `./start-all.sh` and begin building! 🚀
