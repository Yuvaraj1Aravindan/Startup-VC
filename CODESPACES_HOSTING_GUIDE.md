# 🚀 GitHub Codespaces Hosting Guide

## ✅ Application is Now Codespaces-Ready!

Your VC-Startup Platform is optimized for GitHub Codespaces with one-command startup!

---

## 🎯 How to Launch Your Application in Codespaces

### Method 1: Via GitHub Web Interface (Easiest) 🌐

1. **Go to your repository**: https://github.com/Yuvaraj1Aravindan/Startup-VC

2. **Click the green "Code" button**

3. **Select "Codespaces" tab**

4. **Click "Create codespace on main"**
   ```
   ┌─────────────────────────────────┐
   │  Code ▼                         │
   ├─────────────────────────────────┤
   │  Local  |  Codespaces  |  SSH   │
   ├─────────────────────────────────┤
   │  🚀 Create codespace on main    │
   │                                 │
   │  Or: Use this template          │
   └─────────────────────────────────┘
   ```

5. **Wait 2-3 minutes** ⏳
   - Codespace provisions container
   - Installs dependencies
   - Sets up PostgreSQL & Redis
   - Creates database tables
   - Loads sample data

6. **You'll see VS Code in your browser!** 🎉

---

### Method 2: Via VS Code Desktop 💻

1. **Install GitHub Codespaces Extension**
   - Open VS Code
   - Extensions → Search "GitHub Codespaces"
   - Install by GitHub

2. **Create Codespace**
   - Press `Ctrl+Shift+P` (or `Cmd+Shift+P` on Mac)
   - Type: "Codespaces: Create New Codespace"
   - Select: `Yuvaraj1Aravindan/Startup-VC`
   - Select branch: `main`

3. **Codespace opens in VS Code**

---

### Method 3: Via GitHub CLI 🛠️

```bash
# Install GitHub CLI (if not installed)
# https://cli.github.com/

# Create codespace
gh codespace create --repo Yuvaraj1Aravindan/Startup-VC

# Connect to codespace
gh codespace code

# Or SSH into codespace
gh codespace ssh
```

---

## 🎮 Using Your Codespace

### Once Your Codespace is Ready

You'll see this welcome message:

```
🚀 VC-Startup Platform Codespace is ready!

Quick start: ./start-all.sh
Documentation: cat .devcontainer/README.md
```

### 🚀 Starting the Application (One Command!)

Open the integrated terminal and run:

```bash
./start-all.sh
```

This single command:
- ✅ Starts the Backend API (FastAPI) on port 8000
- ✅ Starts the Frontend Dev Server (React) on port 5173
- ✅ Connects to PostgreSQL database
- ✅ Connects to Redis cache
- ✅ Auto-forwards ports to your browser

### 📊 What Happens Next

```
Terminal Output:
─────────────────────────────────────────
✅ Backend started (logs: /tmp/backend.log)
✅ Starting frontend...

  VITE v5.x.x  ready in xxx ms

  ➜  Local:   http://localhost:5173/
  ➜  Network: http://0.0.0.0:5173/
  ➜  Codespaces: https://xxx.githubpreview.dev/
─────────────────────────────────────────
```

### 🌐 Accessing Your Application

Codespaces automatically forwards ports and creates secure URLs:

1. **Look at the "PORTS" tab** (bottom panel in VS Code)

2. **You'll see forwarded ports:**
   ```
   PORT    LABEL                  FORWARDED ADDRESS
   5173    Frontend Dev Server    https://xxx-5173.githubpreview.dev
   8000    Backend API           https://xxx-8000.githubpreview.dev
   5432    PostgreSQL            (silent)
   6379    Redis                 (silent)
   ```

3. **Click the globe icon (🌐)** next to port 5173 to open your app!

4. **Or use the automatic popup** - Codespaces will show:
   ```
   ┌──────────────────────────────────────┐
   │  Your application is running on      │
   │  port 5173                           │
   │                                      │
   │  [Open in Browser]  [Ignore]        │
   └──────────────────────────────────────┘
   ```

---

## 🎯 Alternative Startup Methods

### Start Services Individually

If you need more control:

#### Backend Only
```bash
./start-backend.sh
# Or manually:
cd backend
uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
```

#### Frontend Only
```bash
./start-frontend.sh
# Or manually:
cd frontend
npm run dev -- --host 0.0.0.0
```

---

## 📱 Application URLs

Once running, access:

| Service | Port | URL Type |
|---------|------|----------|
| **Frontend** | 5173 | Public (Codespaces URL) |
| **Backend API** | 8000 | Public (Codespaces URL) |
| **API Docs** | 8000/docs | Public (Codespaces URL) |
| **PostgreSQL** | 5432 | Internal only |
| **Redis** | 6379 | Internal only |

### Example URLs (yours will be different):
```
Frontend:  https://redesigned-space-disco-5173.githubpreview.dev
Backend:   https://redesigned-space-disco-8000.githubpreview.dev
API Docs:  https://redesigned-space-disco-8000.githubpreview.dev/docs
```

---

## 🧪 Testing Your Application

### Run Backend Tests
```bash
cd backend
pytest -v                    # All tests
pytest -v --cov=app         # With coverage
pytest tests/test_api.py    # Specific test
```

### Run Frontend Tests
```bash
cd frontend
npm test                    # Run tests
npm run lint               # Lint check
npx playwright test        # E2E tests
```

---

## 🔍 Monitoring & Debugging

### View Backend Logs
```bash
tail -f /tmp/backend.log
```

### Check Service Status
```bash
# Backend health
curl http://localhost:8000/health

# Database connection
pg_isready -h postgres -U vc_user

# Redis connection
redis-cli -h redis ping
```

### Access Database
```bash
# Connect to PostgreSQL
psql -h postgres -U vc_user -d vc_scoring_db
# Password: vc_password

# View tables
psql -h postgres -U vc_user -d vc_scoring_db -c "\dt"

# Query data
psql -h postgres -U vc_user -d vc_scoring_db -c "SELECT * FROM startups LIMIT 5;"
```

---

## 💡 Pro Tips

### 1. Multiple Terminals
Open multiple terminals to run different services:
- Click **"+"** in terminal panel
- Or press **`Ctrl+Shift+` `** (backtick)

### 2. Port Visibility
Make ports public or private:
- Right-click on port in "PORTS" tab
- Select "Port Visibility"
- Choose "Public" or "Private"

### 3. Hot Reload
Both services support hot reload:
- **Backend**: Changes trigger automatic reload
- **Frontend**: Changes appear instantly in browser

### 4. Save Resources
Codespace auto-pauses after 30 minutes of inactivity:
- No manual stopping needed
- Resume instantly when you return

### 5. Persistent Storage
Your data persists:
- PostgreSQL data: Docker volume
- Redis data: Docker volume
- Code changes: Workspace
- Git commits: Synced to GitHub

---

## 🚨 Troubleshooting

### Issue: Ports Not Forwarding

**Solution:**
1. Check "PORTS" tab
2. Ensure services run on `0.0.0.0` (not `127.0.0.1`)
3. Manual forward: PORTS tab → "Forward a Port"

### Issue: Backend Won't Start

**Solution:**
```bash
# Check logs
cat /tmp/backend.log

# Kill existing process
pkill -f uvicorn

# Restart
./start-backend.sh
```

### Issue: Frontend Won't Start

**Solution:**
```bash
# Clear and reinstall
cd frontend
rm -rf node_modules package-lock.json
npm install

# Clear Vite cache
rm -rf .vite

# Restart
./start-frontend.sh
```

### Issue: Database Connection Failed

**Solution:**
```bash
# Check PostgreSQL status
docker ps | grep postgres

# Wait for PostgreSQL
pg_isready -h postgres -U vc_user

# Restart container if needed
docker restart vc_postgres_codespace

# Reinitialize database
cd backend
python -c "from app.database import engine, Base; Base.metadata.create_all(bind=engine)"
```

### Issue: Permission Denied on Scripts

**Solution:**
```bash
chmod +x start-all.sh start-backend.sh start-frontend.sh
```

---

## 📚 Complete Documentation

For detailed information, see:

- **Codespaces Guide**: `.devcontainer/README.md`
- **CI/CD Setup**: `CODESPACES_CICD_GUIDE.md`
- **Architecture**: `ARCHITECTURE_DIAGRAM.md`
- **Main README**: `README.md`

---

## 🎊 What You Get with Codespaces

### ✅ Instant Development Environment
- No local setup required
- Works on any device with a browser
- Consistent environment for all team members

### ✅ Pre-configured Services
- PostgreSQL 16 database
- Redis 7 cache
- Python 3.10 + FastAPI
- Node.js 20 + React + Vite

### ✅ Pre-installed Tools
- VS Code extensions
- Python linting (flake8, pylint)
- JavaScript linting (ESLint)
- Code formatting (black, prettier)
- Git integration
- Docker support

### ✅ Automatic Features
- Port forwarding with HTTPS
- Hot reload for code changes
- Database persistence
- Auto-pause when idle
- Secure environment

---

## 🚀 Next Steps

1. **Create your Codespace**: https://github.com/Yuvaraj1Aravindan/Startup-VC
2. **Run `./start-all.sh`** in the terminal
3. **Click the port 5173 link** to open your app
4. **Start coding!** Changes appear instantly

---

## 📞 Need Help?

- **Codespaces Docs**: https://docs.github.com/codespaces
- **Your Complete Guide**: `CODESPACES_CICD_GUIDE.md`
- **Troubleshooting**: `.devcontainer/README.md`

---

**Status**: ✅ Codespaces Hosting Ready!
**Commit**: `9021e0c` - feat: Optimize application for GitHub Codespaces hosting
**Repository**: https://github.com/Yuvaraj1Aravindan/Startup-VC

## 🎉 Happy Coding in the Cloud! ☁️
