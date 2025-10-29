# 🏗️ Codespaces Application Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                    GITHUB CODESPACES                             │
│                    (Cloud Container)                             │
└─────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────┐
│                                                                  │
│   Your Browser (Any Device)                                     │
│   ├── VS Code Web UI                                            │
│   ├── Terminal Access                                           │
│   └── Port Forwarding                                           │
│                                                                  │
└───────────────────┬─────────────────────────────────────────────┘
                    │
                    │ HTTPS (Secure Tunnel)
                    │
┌───────────────────▼─────────────────────────────────────────────┐
│                                                                  │
│              Codespace Container (Ubuntu)                        │
│              ┌──────────────────────────────┐                   │
│              │   Development Environment    │                   │
│              │   • Python 3.10              │                   │
│              │   • Node.js 20               │                   │
│              │   • Git, Docker CLI          │                   │
│              │   • VS Code Server           │                   │
│              └──────────────────────────────┘                   │
│                                                                  │
│   ┌──────────────────────────────────────────────────────┐     │
│   │  /workspace (Your Code)                              │     │
│   │  ├── backend/                                        │     │
│   │  │   ├── app/                                        │     │
│   │  │   │   ├── main.py        ← FastAPI app           │     │
│   │  │   │   ├── models.py      ← Database models       │     │
│   │  │   │   └── ...                                     │     │
│   │  │   └── requirements.txt                            │     │
│   │  ├── frontend/                                       │     │
│   │  │   ├── src/                                        │     │
│   │  │   │   ├── App.jsx        ← React app             │     │
│   │  │   │   └── ...                                     │     │
│   │  │   └── package.json                                │     │
│   │  └── .devcontainer/                                  │     │
│   │      ├── devcontainer.json  ← Codespaces config     │     │
│   │      ├── docker-compose.yml ← Services definition   │     │
│   │      └── setup.sh           ← Initialization script │     │
│   └──────────────────────────────────────────────────────┘     │
│                                                                  │
│   ┌──────────────────────────────────────────────────────┐     │
│   │  Running Processes                                   │     │
│   │                                                       │     │
│   │  🚀 Backend (uvicorn)                                │     │
│   │     ├── Port: 8000                                   │     │
│   │     ├── Auto-reload: ON                              │     │
│   │     ├── Host: 0.0.0.0                                │     │
│   │     └── Logs: /tmp/backend.log                       │     │
│   │                                                       │     │
│   │  🎨 Frontend (vite)                                  │     │
│   │     ├── Port: 5173                                   │     │
│   │     ├── HMR: ON                                      │     │
│   │     ├── Host: 0.0.0.0                                │     │
│   │     └── Output: Terminal                             │     │
│   └──────────────────────────────────────────────────────┘     │
│                                                                  │
└──────────────┬───────────────────────┬───────────────────────── │
               │                       │                           │
               ▼                       ▼                           │
┌──────────────────────┐   ┌──────────────────────┐             │
│  PostgreSQL 16       │   │  Redis 7             │             │
│  Container           │   │  Container           │             │
├──────────────────────┤   ├──────────────────────┤             │
│  Port: 5432          │   │  Port: 6379          │             │
│  Host: postgres      │   │  Host: redis         │             │
│  DB: vc_scoring_db   │   │  Cache: In-memory    │             │
│  User: vc_user       │   │  Persistence: Volume │             │
│  Volume: postgres_   │   │  Volume: redis_data  │             │
│          data        │   │                      │             │
└──────────────────────┘   └──────────────────────┘             │
                                                                  │
─────────────────────────────────────────────────────────────────┘


┌─────────────────────────────────────────────────────────────────┐
│                    PORT FORWARDING                               │
└─────────────────────────────────────────────────────────────────┘

Developer Browser                      Codespace Container
─────────────────                      ───────────────────

https://xxx-5173                   →   localhost:5173
  .githubpreview.dev                   (Frontend)
                                       
https://xxx-8000                   →   localhost:8000
  .githubpreview.dev                   (Backend API)

https://xxx-8000                   →   localhost:8000/docs
  .githubpreview.dev/docs              (API Docs)


┌─────────────────────────────────────────────────────────────────┐
│                 STARTUP FLOW                                     │
└─────────────────────────────────────────────────────────────────┘

1. Create Codespace
   └── GitHub provisions container

2. postCreateCommand runs
   ├── bash .devcontainer/setup.sh
   │   ├── Install Python dependencies (pip)
   │   ├── Install Node dependencies (npm)
   │   ├── Wait for PostgreSQL (pg_isready)
   │   ├── Create database tables (SQLAlchemy)
   │   ├── Load sample data (JSON)
   │   └── Create startup scripts
   │       ├── start-all.sh
   │       ├── start-backend.sh
   │       └── start-frontend.sh
   └── Setup complete! ✅

3. Developer runs: ./start-all.sh
   ├── Start backend (background)
   │   └── uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
   ├── Wait 3 seconds
   └── Start frontend (foreground)
       └── npm run dev -- --host 0.0.0.0

4. Codespaces auto-forwards ports
   ├── Port 5173 → Frontend URL (opens browser)
   └── Port 8000 → Backend URL (notification)

5. Application running! 🎉
   ├── Frontend accessible via HTTPS
   ├── Backend API accessible via HTTPS
   ├── Database connected
   └── Redis cache connected


┌─────────────────────────────────────────────────────────────────┐
│                 NETWORK FLOW                                     │
└─────────────────────────────────────────────────────────────────┘

Developer Request
       ↓
GitHub Codespaces Proxy (HTTPS)
       ↓
Port Forward to Container
       ↓
┌──────────────────────┐
│  Frontend (5173)     │  →  Makes API calls  →  ┌──────────────┐
│  React + Vite        │                          │ Backend      │
│  • Serves static     │  ←  Returns JSON     ←  │ (8000)       │
│  • Hot reload        │                          │ FastAPI      │
│  • Dev server        │                          │              │
└──────────────────────┘                          └──────┬───────┘
                                                         │
                                                         ▼
                                           ┌─────────────────────┐
                                           │ PostgreSQL (5432)   │
                                           │ • Stores data       │
                                           │ • Transactions      │
                                           └─────────────────────┘
                                                         │
                                                         ▼
                                           ┌─────────────────────┐
                                           │ Redis (6379)        │
                                           │ • Cache             │
                                           │ • Sessions          │
                                           └─────────────────────┘


┌─────────────────────────────────────────────────────────────────┐
│                 DATA PERSISTENCE                                 │
└─────────────────────────────────────────────────────────────────┘

┌─────────────────────┐
│  Docker Volumes     │
├─────────────────────┤
│  postgres_data      │  ← Survives container restarts
│  redis_data         │  ← Survives container restarts
└─────────────────────┘

┌─────────────────────┐
│  Workspace          │
├─────────────────────┤
│  /workspace/        │  ← Your code (Git synced)
│  • Persists         │  ← Survives Codespace pause
│  • Auto-saved       │  ← Changes committed to Git
└─────────────────────┘

┌─────────────────────┐
│  Codespace State    │
├─────────────────────┤
│  • Pauses after     │
│    30 min idle      │
│  • Resumes          │
│    instantly        │
│  • Data intact      │
└─────────────────────┘


┌─────────────────────────────────────────────────────────────────┐
│                 DEVELOPMENT WORKFLOW                             │
└─────────────────────────────────────────────────────────────────┘

1. Edit code in VS Code Web
       ↓
2. Save file (auto-save enabled)
       ↓
3. Backend/Frontend detects change
       ↓
4. Auto-reload triggered
       ↓
5. Changes visible in browser
       ↓
6. Test changes
       ↓
7. Git commit & push
       ↓
8. CI/CD pipeline triggers (if main branch)
       ↓
9. Automatic deployment to Azure VM


┌─────────────────────────────────────────────────────────────────┐
│                 SECURITY                                         │
└─────────────────────────────────────────────────────────────────┘

✅ Ports private by default
   • Only accessible to authenticated user
   • Can be made public if needed

✅ HTTPS encryption
   • All traffic encrypted
   • GitHub-managed certificates

✅ Isolated environment
   • Each Codespace is isolated
   • No interference between users

✅ Secure secrets
   • Environment variables
   • Never committed to Git


┌─────────────────────────────────────────────────────────────────┐
│                 RESOURCE MANAGEMENT                              │
└─────────────────────────────────────────────────────────────────┘

┌────────────────────┐
│  Auto-pause        │
│  • After 30 min    │
│    of inactivity   │
│  • Resume instant  │
│  • No data loss    │
└────────────────────┘

┌────────────────────┐
│  Auto-delete       │
│  • After 30 days   │
│    of inactivity   │
│  • Can configure   │
│  • Push to Git!    │
└────────────────────┘

┌────────────────────┐
│  Compute Usage     │
│  • Free tier:      │
│    120 hrs/month   │
│  • Paid plans      │
│    available       │
└────────────────────┘


┌─────────────────────────────────────────────────────────────────┐
│                 KEY BENEFITS                                     │
└─────────────────────────────────────────────────────────────────┘

🚀 Instant Setup
   • 2-3 minutes from zero to coding
   • No local installation needed
   • Works on any device

🔧 Consistent Environment
   • Same setup for all team members
   • No "works on my machine" issues
   • Pre-configured tools

💻 Cloud-powered
   • High-performance containers
   • Fast internet speeds
   • Automatic backups

🌐 Accessible Anywhere
   • Browser-based
   • Mobile friendly
   • Works on tablets

♻️ Disposable
   • Create new Codespaces anytime
   • Delete when done
   • Git keeps your code safe
```

---

**Architecture Version**: 1.0  
**Last Updated**: 2025-10-29  
**Status**: ✅ Production Ready
