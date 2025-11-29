# VC UseCase Scoring - Azure VM Deployment Guide

## 🚀 Deployment Summary

Your VC UseCase Scoring application is being deployed to:
- **Public IP**: http://4.213.154.131
- **VM Name**: ubuntu-cheapvm
- **Region**: Central India
- **VM Size**: Standard_B1s (1 vCPU, 1 GB RAM) - Cheapest option

## 📋 What Has Been Done

### ✅ Infrastructure Setup
1. Created Ubuntu 22.04 VM in Azure (`ubuntu-cheapvm`)
2. Opened firewall ports: 80 (HTTP), 443 (HTTPS)
3. Installed Docker & Docker Compose on the VM
4. Transferred application code to VM

### ✅ Application Configuration
1. Created production Docker Compose (`docker-compose.prod.yml`)
2. Created production Dockerfiles for backend and frontend
3. Configured nginx as reverse proxy
4. Set up proper networking with internal bridge

## 🔧 Manual Deployment (If Automated Script Times Out)

If the automated deployment is taking too long, you can manually deploy:

```bash
# SSH to the VM
ssh azureuser@4.213.154.131

# Navigate to application directory
cd ~/vc-usecase-scoring

# Build services one by one (to avoid timeout)
sudo docker compose -f docker-compose.prod.yml build postgres redis nginx

# Build frontend (lighter, faster)
sudo docker compose -f docker-compose.prod.yml build frontend

# Build backend (heaviest - has ML libraries)
# This might take 10-15 minutes
sudo docker compose -f docker-compose.prod.yml build backend

# Start all services
sudo docker compose -f docker-compose.prod.yml up -d

# Check status
sudo docker compose -f docker-compose.prod.yml ps

# View logs
sudo docker compose -f docker-compose.prod.yml logs -f
```

## 🌐 Accessing the Application

Once deployment completes, access your application at:
**http://4.213.154.131**

### Available Endpoints:
- **Main App**: http://4.213.154.131
- **API Docs**: http://4.213.154.131/docs
- **Health Check**: http://4.213.154.131/api/health

## 📊 Application Architecture

```
Internet → Port 80 → Nginx (Reverse Proxy)
                       ├→ Frontend (React) - Port 80 internally
                       └→ Backend API (FastAPI) - Port 8000 internally
                            ├→ PostgreSQL (Port 5432)
                            └→ Redis (Port 6379)
```

## 🔍 Monitoring & Troubleshooting

### Check Service Status
```bash
ssh azureuser@4.213.154.131
sudo docker compose -f ~/vc-usecase-scoring/docker-compose.prod.yml ps
```

### View Logs
```bash
# All services
sudo docker compose -f ~/vc-usecase-scoring/docker-compose.prod.yml logs -f

# Specific service
sudo docker compose -f ~/vc-usecase-scoring/docker-compose.prod.yml logs -f backend
sudo docker compose -f ~/vc-usecase-scoring/docker-compose.prod.yml logs -f frontend
```

### Restart Services
```bash
sudo docker compose -f ~/vc-usecase-scoring/docker-compose.prod.yml restart
```

### Stop Services
```bash
sudo docker compose -f ~/vc-usecase-scoring/docker-compose.prod.yml down
```

## 👥 Test Users

Once deployed, you can create test users via the registration page or API.

### Example Registration (via curl):
```bash
curl -X POST http://4.213.154.131/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "email": "demo@vc.com",
    "password": "Demo@123",
    "full_name": "Demo User",
    "role": "startup_aspirant"
  }'
```

## 🔒 Security Notes

⚠️ **For Production Use**:
1. Change default passwords in `.env` file
2. Enable HTTPS with SSL certificate (Let's Encrypt)
3. Set up firewall rules to restrict access
4. Enable authentication and authorization
5. Regular security updates

## 💰 Cost Management

Your VM costs approximately:
- **Standard_B1s**: ~$10-15/month (varies by region and usage)
- Can be stopped when not in use to save costs

### Stop VM (to save costs):
```bash
az vm deallocate --resource-group rg-cheapvm-india --name ubuntu-cheapvm
```

### Start VM:
```bash
az vm start --resource-group rg-cheapvm-india --name ubuntu-cheapvm
```

## 🎯 Sharing with Stakeholders

Share this information with stakeholders:

```
Application URL: http://4.213.154.131

The VC UseCase Scoring platform is now live and accessible via the above URL.

Features:
- Startup idea submission and evaluation
- VC use case creation and management  
- AI-powered semantic matching and scoring
- Interactive reports and analytics

Please create an account to get started!
```

## 📞 Support

If you encounter issues:
1. Check logs: `sudo docker compose logs -f`
2. Verify services: `sudo docker compose ps`
3. Restart services: `sudo docker compose restart`
4. Check VM resources: `htop` or `docker stats`

## 🚀 Next Steps

1. ✅ Wait for deployment to complete (~10-15 minutes)
2. ✅ Test the application at http://4.213.154.131
3. ✅ Create test user accounts
4. ✅ Load sample data
5. ✅ Share with stakeholders
6. 🔄 Set up SSL certificate (optional but recommended)
7. 🔄 Configure custom domain (optional)
8. 🔄 Set up monitoring and alerts (optional)
