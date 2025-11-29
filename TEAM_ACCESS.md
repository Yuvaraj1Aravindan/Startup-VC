# 👥 Team Access Guide

## 🔗 Repository Information

**Repository**: [Startup-VC](https://github.com/Yuvaraj1Aravindan/Startup-VC)  
**Owner**: Yuvaraj1Aravindan  
**Access Type**: Public (Read-Only)  
**Live Application**: http://4.213.154.131

---

## 📋 Quick Start for Team Members

### 1. **View the Code Online**
Simply visit: https://github.com/Yuvaraj1Aravindan/Startup-VC

### 2. **Clone the Repository**
```bash
git clone https://github.com/Yuvaraj1Aravindan/Startup-VC.git
cd Startup-VC
```

### 3. **Access the Live Application**
- **Main App**: http://4.213.154.131
- **API Docs**: http://4.213.154.131/docs
- **Health Check**: http://4.213.154.131/api/health

### 4. **Demo Credentials**
- **VC Account**: 
  - Email: `vc@demo.com`
  - Password: `Demo@123`
- **Startup Account**: 
  - Email: `startup@demo.com`
  - Password: `Demo@123`

---

## 🚀 Running Locally

### Prerequisites
- Docker & Docker Compose
- Node.js 18+ (for frontend development)
- Python 3.9+ (for backend development)

### Quick Start (Docker)
```bash
# Clone the repository
git clone https://github.com/Yuvaraj1Aravindan/Startup-VC.git
cd Startup-VC

# Start all services
./start.sh
```

Access at: http://localhost

### Development Mode

**Backend**:
```bash
cd backend
python -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate
pip install -r requirements.txt
uvicorn app.main:app --reload
```

**Frontend**:
```bash
cd frontend
npm install
npm run dev
```

---

## 📚 Documentation

- **Getting Started**: See [GETTING_STARTED.md](./GETTING_STARTED.md)
- **Deployment Guide**: See [DEPLOYMENT_GUIDE.md](./DEPLOYMENT_GUIDE.md)
- **Project Summary**: See [PROJECT_SUMMARY.md](./PROJECT_SUMMARY.md)
- **API Documentation**: http://4.213.154.131/docs (when running)

---

## 🤝 Contributing

This is a **read-only public repository**. If you want to contribute:

### Option 1: Fork and Pull Request
1. **Fork** this repository on GitHub
2. **Clone** your fork:
   ```bash
   git clone https://github.com/YOUR-USERNAME/Startup-VC.git
   ```
3. Create a **feature branch**:
   ```bash
   git checkout -b feature/your-feature-name
   ```
4. Make your changes and **commit**:
   ```bash
   git add .
   git commit -m "Description of changes"
   ```
5. **Push** to your fork:
   ```bash
   git push origin feature/your-feature-name
   ```
6. Create a **Pull Request** on GitHub

### Option 2: Request Write Access
Contact the repository owner (Yuvaraj1Aravindan) to request collaborator access with write permissions.

---

## 🔐 Access Levels

### Current Setup
- **Public Repository**: Anyone can view and clone
- **Read-Only**: Public users cannot push changes
- **Collaborators**: Invited members can have write access

### To Get Write Access
1. Contact repository owner with your GitHub username
2. Owner will invite you as a collaborator
3. You'll receive an email invitation
4. Accept the invitation to get write permissions

---

## 🛠️ Project Structure

```
Startup-VC/
├── backend/              # FastAPI backend application
│   ├── app/             # Application code
│   ├── tests/           # Backend tests
│   └── requirements.txt # Python dependencies
├── frontend/            # React frontend application
│   ├── src/            # Source code
│   └── package.json    # Node dependencies
├── scripts/            # Utility scripts
├── tests/              # E2E tests (Playwright)
├── docker-compose.yml  # Development docker setup
└── deploy-*.sh        # Deployment scripts
```

---

## 📊 Features

- **VC Use Case Management**: Create and manage investment criteria
- **Startup Idea Submission**: Submit and track startup ideas
- **Matching Algorithm**: AI-powered matching between VCs and startups
- **Scoring System**: Multi-criteria evaluation and scoring
- **Analytics Dashboard**: Comprehensive reports and insights
- **Role-Based Access**: Separate interfaces for VCs and Startups

---

## 🐛 Reporting Issues

Found a bug or have a suggestion?

1. Check [existing issues](https://github.com/Yuvaraj1Aravindan/Startup-VC/issues)
2. If not found, [create a new issue](https://github.com/Yuvaraj1Aravindan/Startup-VC/issues/new)
3. Provide detailed description and steps to reproduce

---

## 📞 Contact

**Repository Owner**: Yuvaraj1Aravindan  
**GitHub Profile**: https://github.com/Yuvaraj1Aravindan

---

## 📄 License

This project is for educational and demonstration purposes.

---

## 🎯 Key Commands Reference

```bash
# View repository info
gh repo view Yuvaraj1Aravindan/Startup-VC

# Clone repository
git clone https://github.com/Yuvaraj1Aravindan/Startup-VC.git

# Fork repository (creates your own copy)
gh repo fork Yuvaraj1Aravindan/Startup-VC --clone

# Check your access level
gh repo view Yuvaraj1Aravindan/Startup-VC --json viewerPermission

# Watch repository for updates
gh repo watch Yuvaraj1Aravindan/Startup-VC

# Star repository
gh repo star Yuvaraj1Aravindan/Startup-VC
```

---

**Last Updated**: October 21, 2025  
**Version**: 1.0.0
