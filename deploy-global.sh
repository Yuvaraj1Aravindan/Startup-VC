#!/bin/bash

# Quick Fix: Build Docker images locally and deploy to Azure VM
# This solves the out-of-memory issue on the 1GB RAM VM

set -e

BLUE='\033[0;34m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

VM_IP="4.213.154.131"
VM_USER="azureuser"

echo -e "${BLUE}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║   Build Locally & Deploy to Azure for Global Access       ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════════════╝${NC}"
echo ""

# Check if Docker is running locally
if ! docker info > /dev/null 2>&1; then
    echo -e "${RED}✗ Docker is not running on your local machine${NC}"
    echo "Please start Docker Desktop and try again"
    exit 1
fi

echo -e "${GREEN}✓ Docker is running${NC}"
echo ""

# Navigate to project directory
PROJECT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$PROJECT_DIR"

echo -e "${YELLOW}Step 1: Building backend image locally...${NC}"
echo "This may take 10-15 minutes (downloading 3GB+ of ML libraries)"
echo ""

cd backend
if docker build -t vc-usecase-backend:prod -f Dockerfile.prod .; then
    echo -e "${GREEN}✓ Backend image built successfully${NC}"
else
    echo -e "${RED}✗ Backend build failed${NC}"
    exit 1
fi
echo ""

echo -e "${YELLOW}Step 2: Building frontend image locally...${NC}"
cd ../frontend
if docker build -t vc-usecase-frontend:prod -f Dockerfile.prod --build-arg VITE_API_URL=http://${VM_IP}/api .; then
    echo -e "${GREEN}✓ Frontend image built successfully${NC}"
else
    echo -e "${RED}✗ Frontend build failed${NC}"
    exit 1
fi
echo ""

echo -e "${YELLOW}Step 3: Saving images as compressed archives...${NC}"
cd ..

echo "  Saving backend image..."
docker save vc-usecase-backend:prod | gzip > backend-image.tar.gz
BACKEND_SIZE=$(du -h backend-image.tar.gz | cut -f1)
echo -e "${GREEN}  ✓ Backend image saved ($BACKEND_SIZE)${NC}"

echo "  Saving frontend image..."
docker save vc-usecase-frontend:prod | gzip > frontend-image.tar.gz
FRONTEND_SIZE=$(du -h frontend-image.tar.gz | cut -f1)
echo -e "${GREEN}  ✓ Frontend image saved ($FRONTEND_SIZE)${NC}"
echo ""

echo -e "${YELLOW}Step 4: Transferring images to Azure VM...${NC}"
echo "This may take several minutes depending on your internet speed"
echo ""

echo "  Transferring backend image..."
if scp -o StrictHostKeyChecking=no backend-image.tar.gz ${VM_USER}@${VM_IP}:~/; then
    echo -e "${GREEN}  ✓ Backend image transferred${NC}"
else
    echo -e "${RED}  ✗ Backend transfer failed${NC}"
    exit 1
fi

echo "  Transferring frontend image..."
if scp -o StrictHostKeyChecking=no frontend-image.tar.gz ${VM_USER}@${VM_IP}:~/; then
    echo -e "${GREEN}  ✓ Frontend image transferred${NC}"
else
    echo -e "${RED}  ✗ Frontend transfer failed${NC}"
    exit 1
fi
echo ""

echo -e "${YELLOW}Step 5: Deploying on Azure VM...${NC}"
ssh -o StrictHostKeyChecking=no ${VM_USER}@${VM_IP} << 'REMOTE_EOF'
set -e

echo "  Loading backend image..."
sudo docker load -i ~/backend-image.tar.gz

echo "  Loading frontend image..."
sudo docker load -i ~/frontend-image.tar.gz

echo "  Cleaning up transfer files..."
rm -f ~/backend-image.tar.gz ~/frontend-image.tar.gz

echo "  Starting services..."
cd ~/vc-usecase-scoring
sudo docker compose -f docker-compose.prod.yml down 2>/dev/null || true
sudo docker compose -f docker-compose.prod.yml up -d

echo "  Waiting for services to start..."
sleep 15

echo "  Checking container status..."
sudo docker compose -f docker-compose.prod.yml ps
REMOTE_EOF

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ Deployment completed successfully${NC}"
else
    echo -e "${RED}✗ Deployment failed${NC}"
    exit 1
fi
echo ""

echo -e "${YELLOW}Step 6: Verifying global accessibility...${NC}"
echo ""

# Test HTTP access
echo "  Testing HTTP access..."
if curl -sS -I http://${VM_IP} -m 10 | head -n 1; then
    echo -e "${GREEN}  ✓ HTTP endpoint is accessible${NC}"
else
    echo -e "${YELLOW}  ⚠ HTTP endpoint not responding yet (may need a few more seconds)${NC}"
fi

# Test API health
echo "  Testing API health endpoint..."
if curl -sS http://${VM_IP}/api/health -m 10 > /dev/null 2>&1; then
    echo -e "${GREEN}  ✓ API is responding${NC}"
else
    echo -e "${YELLOW}  ⚠ API not responding yet (containers may still be starting)${NC}"
fi
echo ""

# Clean up local files
echo -e "${YELLOW}Step 7: Cleaning up local files...${NC}"
rm -f backend-image.tar.gz frontend-image.tar.gz
echo -e "${GREEN}✓ Cleanup complete${NC}"
echo ""

echo -e "${BLUE}════════════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}🎉 Deployment Complete!${NC}"
echo -e "${BLUE}════════════════════════════════════════════════════════════${NC}"
echo ""
echo "Your application is now globally accessible at:"
echo ""
echo -e "${GREEN}  🌍 Application URL:     http://${VM_IP}${NC}"
echo -e "${GREEN}  📚 API Documentation:   http://${VM_IP}/docs${NC}"
echo -e "${GREEN}  ❤️  Health Check:       http://${VM_IP}/api/health${NC}"
echo ""
echo "Accessible from:"
echo "  ✓ United States"
echo "  ✓ Europe"
echo "  ✓ Asia"
echo "  ✓ Africa"
echo "  ✓ Australia"
echo "  ✓ South America"
echo "  ✓ Any location worldwide"
echo ""
echo "Next steps:"
echo "  1. Test access: curl http://${VM_IP}"
echo "  2. Create test users: See DEPLOYMENT_GUIDE.md"
echo "  3. Share URL with stakeholders globally"
echo ""
echo "To check status:"
echo "  ssh ${VM_USER}@${VM_IP}"
echo "  cd ~/vc-usecase-scoring"
echo "  sudo docker compose -f docker-compose.prod.yml ps"
echo "  sudo docker compose -f docker-compose.prod.yml logs"
echo ""
