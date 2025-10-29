# GitHub Codespaces & CI/CD Setup Guide

## 🚀 GitHub Codespaces Configuration

### What's Been Set Up

Your repository is now configured with **GitHub Codespaces** for instant development environments!

### Features

✅ **One-Click Development Environment**
- Fully configured Python 3.10 + Node.js 20
- PostgreSQL 15 + Redis 7 services
- All dependencies pre-installed
- VS Code extensions pre-configured

✅ **Pre-configured Services**
- Backend API (Port 8000)
- VC Agent API (Port 8001)
- Frontend Dev Server (Port 5173)
- Nginx Proxy (Port 80)
- PostgreSQL Database (Port 5432)
- Redis Cache (Port 6379)

✅ **Developer Tools**
- Python linting (flake8, pylint)
- Code formatting (black)
- React/Tailwind support
- Docker integration
- GitLens for Git history

### How to Use GitHub Codespaces

#### Option 1: Via GitHub Web Interface

1. Go to your repository: https://github.com/Yuvaraj1Aravindan/Startup-VC
2. Click the green **"Code"** button
3. Select **"Codespaces"** tab
4. Click **"Create codespace on main"**
5. Wait ~2-3 minutes for environment setup
6. Start coding!

#### Option 2: Via VS Code Desktop

1. Install "GitHub Codespaces" extension in VS Code
2. Press `Ctrl+Shift+P` (or `Cmd+Shift+P` on Mac)
3. Type "Codespaces: Create New Codespace"
4. Select your repository
5. Codespace opens in VS Code

#### Option 3: Via CLI

```bash
# Install GitHub CLI
gh codespace create --repo Yuvaraj1Aravindan/Startup-VC

# Connect to codespace
gh codespace code
```

### Working in Codespaces

Once your Codespace is ready:

```bash
# Start backend (Terminal 1)
cd backend
uvicorn app.main:app --reload --host 0.0.0.0 --port 8000

# Start frontend (Terminal 2)
cd frontend
npm run dev

# Run tests (Terminal 3)
cd backend && pytest
cd frontend && npx playwright test
```

Access your application:
- **Frontend**: Codespace will auto-forward port 5173
- **Backend API**: Port 8000 auto-forwarded
- **API Docs**: Port 8000/docs

### Codespace Management

```bash
# List your codespaces
gh codespace list

# Stop a codespace
gh codespace stop

# Delete a codespace
gh codespace delete

# SSH into codespace
gh codespace ssh
```

### Cost Optimization

- **Free tier**: 120 hours/month for Pro accounts
- **Stop when not in use**: Codespaces auto-stop after 30 min of inactivity
- **Delete unused**: Remove old codespaces to save storage

---

## 🔄 CI/CD Pipeline with GitHub Actions

### Workflows Created

#### 1. **Main CI/CD Pipeline** (`.github/workflows/ci-cd.yml`)

Triggers on:
- Push to `main` or `develop` branch
- Pull requests to `main` or `develop`
- Manual trigger

**Jobs:**

**a. Test Backend**
- ✅ Python linting (flake8, black)
- ✅ Unit tests with pytest
- ✅ Code coverage reports
- ✅ PostgreSQL + Redis services

**b. Test Frontend**
- ✅ ESLint linting
- ✅ Build verification
- ✅ Playwright E2E tests

**c. Build & Push Docker Images** (main branch only)
- ✅ Build production Docker images
- ✅ Push to GitHub Container Registry (ghcr.io)
- ✅ Tag with branch name and SHA
- ✅ Automatic versioning

**d. Deploy to Azure VM** (main branch only)
- ✅ SSH to Azure VM
- ✅ Pull latest code
- ✅ Pull Docker images
- ✅ Restart services with docker-compose
- ✅ Health checks
- ✅ Automatic rollback on failure

**e. Security Scan**
- ✅ Trivy vulnerability scanner
- ✅ Python dependency security check
- ✅ SARIF upload to GitHub Security

#### 2. **PR Checks Workflow** (`.github/workflows/pr-checks.yml`)

Runs on every pull request:

- ✅ PR title validation (semantic commits)
- ✅ Large file detection
- ✅ Sensitive data scanning
- ✅ Code quality checks (pylint, flake8)
- ✅ Test coverage reports
- ✅ Coverage comments on PR

#### 3. **Nightly Backup Workflow** (`.github/workflows/backup.yml`)

Runs daily at 2 AM UTC:

- ✅ PostgreSQL database backup
- ✅ Compress and store backups
- ✅ Upload to GitHub Artifacts
- ✅ Retain for 30 days
- ✅ Auto-cleanup old backups (7+ days)

### Required Secrets

Set these in GitHub repository settings (Settings → Secrets and variables → Actions):

```bash
AZURE_VM_SSH_KEY      # SSH private key for Azure VM
AZURE_VM_IP           # Azure VM public IP (4.213.154.131)
```

#### How to Add SSH Key Secret:

1. On your local machine:
```bash
# Generate SSH key if you don't have one
ssh-keygen -t ed25519 -C "github-actions@startup-vc"

# Display private key
cat ~/.ssh/id_ed25519

# Copy the private key content (including BEGIN and END lines)
```

2. On Azure VM:
```bash
# Add public key to authorized_keys
ssh azureuser@4.213.154.131
echo "YOUR_PUBLIC_KEY" >> ~/.ssh/authorized_keys
```

3. On GitHub:
- Go to: https://github.com/Yuvaraj1Aravindan/Startup-VC/settings/secrets/actions
- Click "New repository secret"
- Name: `AZURE_VM_SSH_KEY`
- Value: Paste private key content
- Click "Add secret"

4. Add Azure VM IP:
- Name: `AZURE_VM_IP`
- Value: `4.213.154.131`
- Click "Add secret"

### GitHub Container Registry Setup

1. **Enable GitHub Packages**:
   - Go to repository Settings → Actions → General
   - Under "Workflow permissions"
   - Select "Read and write permissions"
   - Save

2. **Images will be published to**:
   - `ghcr.io/yuvaraj1aravindan/startup-vc/backend:latest`
   - `ghcr.io/yuvaraj1aravindan/startup-vc/frontend:latest`
   - `ghcr.io/yuvaraj1aravindan/startup-vc/vc-agent:latest`

### Viewing Workflow Runs

1. Go to: https://github.com/Yuvaraj1Aravindan/Startup-VC/actions
2. See all workflow runs
3. Click on any run to see details
4. View logs, artifacts, and deployment status

### Manual Deployment Trigger

To manually trigger deployment:

1. Go to Actions tab
2. Select "CI/CD Pipeline"
3. Click "Run workflow"
4. Select branch
5. Click "Run workflow"

### Workflow Status Badges

Add to your README.md:

```markdown
![CI/CD](https://github.com/Yuvaraj1Aravindan/Startup-VC/actions/workflows/ci-cd.yml/badge.svg)
![PR Checks](https://github.com/Yuvaraj1Aravindan/Startup-VC/actions/workflows/pr-checks.yml/badge.svg)
![Backup](https://github.com/Yuvaraj1Aravindan/Startup-VC/actions/workflows/backup.yml/badge.svg)
```

---

## 🔐 Security Best Practices

### Secrets Management

✅ **Never commit secrets to Git**
- Use GitHub Secrets for CI/CD
- Use environment variables
- Use `.env` files (excluded in `.gitignore`)

✅ **Rotate credentials regularly**
- SSH keys every 90 days
- PAT tokens every 90 days
- Database passwords quarterly

✅ **Security Scanning**
- Trivy scans on every push
- Dependency vulnerability checks
- Code quality gates in PRs

---

## 📊 Monitoring Deployments

### Deployment Logs

View in GitHub Actions:
1. Go to Actions → CI/CD Pipeline
2. Click on latest run
3. Expand "Deploy to Azure VM" job
4. See real-time deployment logs

### Health Checks

After deployment, workflow automatically checks:
- Backend API health endpoint
- Service availability
- Container status

### Rollback Strategy

If deployment fails:
1. Previous Docker containers remain running
2. Failed containers are removed
3. Check logs in Actions tab
4. Fix issue and push new commit
5. Automatic re-deployment

---

## 🚦 Development Workflow

### Feature Branch Workflow

```bash
# Create feature branch
git checkout -b feature/new-feature

# Make changes and commit
git add .
git commit -m "feat: add new feature"

# Push to GitHub
git push origin feature/new-feature

# Create PR on GitHub
# CI automatically runs tests

# After PR approval and merge
# Automatic deployment to Azure VM
```

### Semantic Commit Messages

Use conventional commits:
- `feat:` - New feature
- `fix:` - Bug fix
- `docs:` - Documentation
- `style:` - Code style changes
- `refactor:` - Code refactoring
- `test:` - Test additions
- `chore:` - Maintenance tasks

---

## 🎯 Quick Commands Summary

### GitHub Codespaces
```bash
# Create codespace
gh codespace create --repo Yuvaraj1Aravindan/Startup-VC

# List codespaces
gh codespace list

# Connect to codespace
gh codespace code

# Stop codespace
gh codespace stop

# Delete codespace
gh codespace delete
```

### Local Development
```bash
# Start all services
docker-compose up -d

# Start backend only
cd backend && uvicorn app.main:app --reload

# Start frontend only
cd frontend && npm run dev

# Run tests
cd backend && pytest
cd frontend && npx playwright test
```

### CI/CD
```bash
# View workflow runs
gh run list

# Watch specific run
gh run watch

# View run logs
gh run view <run-id>

# Re-run failed jobs
gh run rerun <run-id> --failed
```

---

## 📚 Additional Resources

### Documentation
- **GitHub Codespaces**: https://docs.github.com/codespaces
- **GitHub Actions**: https://docs.github.com/actions
- **Docker Compose**: https://docs.docker.com/compose/
- **FastAPI**: https://fastapi.tiangzhou.com/
- **React**: https://react.dev/

### Your Links
- **GitHub Repository**: https://github.com/Yuvaraj1Aravindan/Startup-VC
- **Azure DevOps**: https://dev.azure.com/24f2005387/Azure-Projects
- **Azure VM Application**: http://4.213.154.131

---

## 🎉 You're All Set!

Your repository now has:
- ✅ GitHub Codespaces for instant dev environments
- ✅ Automated CI/CD pipeline
- ✅ Pull request validation
- ✅ Nightly database backups
- ✅ Security scanning
- ✅ Automatic deployment to Azure VM

**Next Steps:**
1. Add GitHub Secrets (SSH key and VM IP)
2. Test Codespaces by creating one
3. Create a test PR to see CI in action
4. Monitor Actions tab for deployment status

Happy coding! 🚀
