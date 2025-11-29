#!/bin/bash

# VM Setup Script - Installs Docker and dependencies on Azure VM

set -e

echo "🔧 VM Setup Script"
echo "=================="

VM_IP="4.213.154.131"
VM_USER="azureuser"

echo "📡 Connecting to VM at $VM_IP..."

ssh -o StrictHostKeyChecking=no "$VM_USER@$VM_IP" << 'EOF'
    set -e
    
    echo "🔄 Updating system packages..."
    sudo apt-get update
    
    echo "📦 Installing required packages..."
    sudo apt-get install -y \
        apt-transport-https \
        ca-certificates \
        curl \
        gnupg \
        lsb-release
    
    echo "🐳 Installing Docker..."
    
    # Add Docker's official GPG key
    sudo mkdir -p /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    
    # Set up Docker repository
    echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
      $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    
    # Install Docker Engine
    sudo apt-get update
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    
    echo "👤 Adding user to docker group..."
    sudo usermod -aG docker $USER
    
    echo "✅ Docker installed successfully!"
    
    echo "🔍 Verifying Docker installation..."
    sudo docker --version
    sudo docker compose version
    
    echo "🎉 VM setup complete!"
    echo ""
    echo "⚠️  IMPORTANT: You may need to log out and log back in for docker group changes to take effect"
    echo "    Or run: newgrp docker"
EOF

echo ""
echo "✅ VM setup completed successfully!"
echo ""
echo "Next step: Run ./deploy-vm-start.sh to start the application"
