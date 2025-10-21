#!/bin/bash

# Production deployment script for Azure VM
# This script deploys the VC UseCase Scoring application

set -e

echo "🚀 Starting deployment process..."

# Configuration
VM_IP="4.213.154.131"
VM_USER="azureuser"
APP_DIR="/home/azureuser/vc-usecase-scoring"

echo "📦 Creating deployment bundle..."

# Create a temporary directory for deployment
DEPLOY_DIR=$(mktemp -d)
echo "Using temporary directory: $DEPLOY_DIR"

# Copy necessary files
cp -r backend frontend docker-compose.prod.yml nginx.conf "$DEPLOY_DIR/"
cp .env.example "$DEPLOY_DIR/.env" 2>/dev/null || echo "# Production environment variables
POSTGRES_USER=vc_user
POSTGRES_PASSWORD=$(openssl rand -base64 32)
POSTGRES_DB=vc_scoring_db
SECRET_KEY=$(openssl rand -base64 32)
DEBUG=false" > "$DEPLOY_DIR/.env"

# Create deployment archive
cd "$DEPLOY_DIR"
tar -czf /tmp/vc-app-deploy.tar.gz .
cd -

echo "✅ Deployment bundle created: /tmp/vc-app-deploy.tar.gz"

# Test SSH connection
echo "🔐 Testing SSH connection to VM..."
if ssh -o ConnectTimeout=10 -o StrictHostKeyChecking=no "$VM_USER@$VM_IP" "echo 'SSH connection successful'"; then
    echo "✅ SSH connection verified"
else
    echo "❌ SSH connection failed. Please ensure:"
    echo "  1. VM is running"
    echo "  2. SSH keys are properly configured"
    echo "  3. Network security group allows SSH (port 22)"
    exit 1
fi

# Transfer the bundle to VM
echo "📤 Transferring application to VM..."
scp -o StrictHostKeyChecking=no /tmp/vc-app-deploy.tar.gz "$VM_USER@$VM_IP:/tmp/"

echo "🔧 Setting up application on VM..."
ssh -o StrictHostKeyChecking=no "$VM_USER@$VM_IP" << 'EOF'
    set -e
    
    # Create app directory
    mkdir -p ~/vc-usecase-scoring
    cd ~/vc-usecase-scoring
    
    # Extract the bundle
    tar -xzf /tmp/vc-app-deploy.tar.gz
    
    echo "✅ Application files extracted"
    
    # Clean up
    rm /tmp/vc-app-deploy.tar.gz
    
    echo "📋 Application is ready for Docker deployment"
EOF

echo "✅ Deployment bundle transferred successfully!"
echo ""
echo "Next steps:"
echo "1. Run: ./deploy-vm-setup.sh to install Docker and dependencies"
echo "2. Run: ./deploy-vm-start.sh to start the application"
echo ""

# Clean up local temp files
rm -rf "$DEPLOY_DIR"
rm /tmp/vc-app-deploy.tar.gz

echo "🎉 Deployment preparation complete!"
