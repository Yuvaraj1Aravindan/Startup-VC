#!/bin/bash

# VM Start Script - Starts the application on Azure VM

set -e

echo "🚀 Starting Application on VM"
echo "=============================="

VM_IP="4.213.154.131"
VM_USER="azureuser"

echo "📡 Connecting to VM at $VM_IP..."

ssh -o StrictHostKeyChecking=no "$VM_USER@$VM_IP" << 'EOF'
    set -e
    
    cd ~/vc-usecase-scoring
    
    echo "🛑 Stopping any existing containers..."
    sudo docker compose -f docker-compose.prod.yml down 2>/dev/null || true
    
    echo "🏗️  Building Docker images..."
    sudo docker compose -f docker-compose.prod.yml build
    
    echo "🚀 Starting services..."
    sudo docker compose -f docker-compose.prod.yml up -d
    
    echo "⏳ Waiting for services to start..."
    sleep 10
    
    echo "📊 Checking service status..."
    sudo docker compose -f docker-compose.prod.yml ps
    
    echo ""
    echo "✅ Application started successfully!"
    echo ""
    echo "🌐 Access your application at:"
    echo "   http://4.213.154.131"
    echo ""
    echo "📊 API Documentation:"
    echo "   http://4.213.154.131/docs"
    echo ""
    echo "📝 View logs with:"
    echo "   sudo docker compose -f docker-compose.prod.yml logs -f"
EOF

echo ""
echo "🎉 Application deployment complete!"
echo ""
echo "🌐 Your application is now accessible at: http://4.213.154.131"
