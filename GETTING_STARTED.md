# 🚀 Getting Started with VC UseCase Scoring

This guide will help you get the application up and running in minutes.

## Prerequisites

Before you begin, ensure you have:
- **Docker Desktop** installed ([Download](https://www.docker.com/products/docker-desktop))
- **Docker Compose** (included with Docker Desktop)
- At least **4GB RAM** available
- **Ports available**: 5173, 8000, 5432, 6379

## 🎯 Quick Start (Recommended)

### Option 1: Using the Start Script

**Linux/Mac:**
```bash
cd vc-usecase-scoring
./start.sh
```

**Windows:**
```cmd
cd vc-usecase-scoring
start.bat
```

This will:
1. Create `.env` file if it doesn't exist
2. Build Docker images
3. Start all services
4. Display access URLs

### Option 2: Using Docker Compose Directly

```bash
cd vc-usecase-scoring
cp .env.example .env
docker-compose up -d --build
```

## 📱 Access the Application

After starting, access:
- **Frontend UI**: http://localhost:5173
- **Backend API**: http://localhost:8000
- **API Documentation**: http://localhost:8000/docs
- **API Redoc**: http://localhost:8000/redoc

## 👤 Create Your First Account

1. Open http://localhost:5173
2. Click **"Sign up"**
3. Fill in:
   - Full Name: Your Name
   - Email: your.email@example.com
   - Password: (at least 6 characters)
   - Role: Choose **"Startup Aspirant"** or **"VC Representative"**
4. Click **"Sign Up"**
5. You'll be automatically logged in

## 🎨 User Journeys

### As a Startup Aspirant

1. **Submit an Idea**
   - Go to "Submit Idea" from the sidebar
   - Fill in your startup idea details:
     - Title: e.g., "AI-Powered Supply Chain Optimizer"
     - Short Pitch: One sentence description
     - Problem Statement: What problem you're solving
     - Proposed Solution: How you solve it
     - Differentiators: What makes you unique
     - Market Signals: Any traction/customers
   - Click "Submit Idea"

2. **Evaluate Your Idea**
   - Go to "Evaluate"
   - Select your idea from dropdown
   - Select a VC use case to match against
   - Click "Evaluate"
   - View your score (0-100%) with detailed explanation

3. **View Reports**
   - Go to "Reports"
   - Select your idea
   - View comprehensive evaluation report
   - See top matching use cases
   - Review recommendations

### As a VC Representative

1. **Create Use Cases**
   - Go to "Manage Use Cases"
   - Click "Add Use Case"
   - Fill in:
     - Title: e.g., "Supply Chain Automation"
     - Description: Detailed pain point description
     - Industry: e.g., "logistics"
     - Domain: e.g., "operations"
     - Tags: e.g., "automation, efficiency, IoT"
     - Importance Weight: 0-1 (higher = more important)
   - Click "Create Use Case"

2. **Review Idea Matches**
   - Go to "Evaluate"
   - Select ideas to evaluate against your use cases
   - View alignment scores
   - Read AI-generated explanations

## 🎓 Example Workflow

Let's walk through a complete example:

### Step 1: Register as Startup Aspirant
```
Email: startup@example.com
Password: demo123456
Role: Startup Aspirant
```

### Step 2: Submit a Sample Idea
```
Title: Warehouse Robot System
Short Pitch: Autonomous robots for warehouse picking and packing
Problem Statement: Manual warehouse operations are slow, error-prone, and costly
Target Industry: logistics
Proposed Solution: Computer vision + robotics for 24/7 autonomous picking
Differentiators: 30% faster than competitors, works with existing infrastructure
Market Signals: 3 pilot customers, $50K MRR
```

### Step 3: Register as VC (in incognito window)
```
Email: vc@example.com
Password: demo123456
Role: VC Representative
```

### Step 4: Create a Use Case
```
Title: Warehouse Automation Solutions
Description: Looking for solutions to automate warehouse operations, reduce labor costs, and improve accuracy
Industry: logistics
Tags: automation, robotics, efficiency
Importance Weight: 0.8
```

### Step 5: Evaluate
- Login as startup@example.com
- Go to "Evaluate"
- Select "Warehouse Robot System"
- Select "Warehouse Automation Solutions"
- Click "Evaluate"
- View your score! (Should be high due to good alignment)

## 🔧 Troubleshooting

### Services Won't Start

**Check if ports are in use:**
```bash
# Linux/Mac
lsof -i :5173
lsof -i :8000
lsof -i :5432

# Windows
netstat -ano | findstr :5173
netstat -ano | findstr :8000
```

**Solution:** Stop the conflicting service or change ports in `docker-compose.yml`

### Frontend Shows Connection Error

**Check backend is running:**
```bash
docker-compose ps
curl http://localhost:8000/health
```

**Solution:** Restart backend
```bash
docker-compose restart backend
```

### Database Connection Error

**Check PostgreSQL:**
```bash
docker-compose logs postgres
```

**Solution:** Recreate database
```bash
docker-compose down -v
docker-compose up -d
```

### "Authentication Failed"

**Solution:** Clear browser local storage
1. Open DevTools (F12)
2. Go to Application > Local Storage
3. Delete all items
4. Refresh page

## 📊 Viewing Logs

**All services:**
```bash
docker-compose logs -f
```

**Specific service:**
```bash
docker-compose logs -f backend
docker-compose logs -f frontend
docker-compose logs -f postgres
```

## 🛑 Stopping the Application

**Stop but keep data:**
```bash
docker-compose stop
```

**Stop and remove containers:**
```bash
docker-compose down
```

**Stop and remove everything (including database):**
```bash
docker-compose down -v
```

## 🔄 Updating the Application

```bash
git pull
docker-compose down
docker-compose up -d --build
```

## 💡 Tips & Best Practices

1. **Use meaningful titles** for ideas and use cases
2. **Be specific** in problem statements and descriptions
3. **Add market signals** to improve viability scores
4. **Set appropriate importance weights** for use cases
5. **Tag use cases well** for better matching
6. **Review explanations** to understand scoring

## 🎯 What to Try Next

- [ ] Submit 3-5 different ideas
- [ ] Create multiple use cases
- [ ] Run batch evaluations
- [ ] Compare scores across use cases
- [ ] Export reports (coming soon)
- [ ] Invite team members

## 📚 Learn More

- **Full Documentation**: See `README.md`
- **API Reference**: http://localhost:8000/docs
- **Architecture**: See `PROJECT_SUMMARY.md`
- **Contributing**: See `README.md` Contributing section

## 🆘 Need Help?

1. Check the troubleshooting section above
2. Review logs: `docker-compose logs`
3. Check GitHub Issues
4. Read API documentation at /docs

## 🎉 You're Ready!

The application is now running and you can:
✅ Create accounts
✅ Submit ideas
✅ Define use cases
✅ Get AI-powered evaluations
✅ View detailed reports

Enjoy using VC UseCase Scoring! 🚀
