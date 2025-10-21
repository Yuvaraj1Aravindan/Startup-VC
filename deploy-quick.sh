#!/bin/bash

# Quick deployment script - runs everything on VM
set -e

VM_IP="4.213.154.131"
VM_USER="azureuser"

echo "🚀 Quick Deployment to Azure VM"
echo "================================"
echo ""

ssh -o StrictHostKeyChecking=no "$VM_USER@$VM_IP" << 'EOF'
    set -e
    cd ~/vc-usecase-scoring
    
    echo "🏗️  Building and starting services (this may take 5-10 minutes)..."
    echo "⏳ Building backend with ML libraries..."
    
    # Build in stages to avoid timeout
    sudo docker compose -f docker-compose.prod.yml build --no-cache backend &
    BACKEND_PID=$!
    
    # Show progress
    while kill -0 $BACKEND_PID 2>/dev/null; do
        echo "... still building backend ..."
        sleep 30
    done
    wait $BACKEND_PID
    
    echo "✅ Backend built!"
    echo "🏗️  Building frontend..."
    
    sudo docker compose -f docker-compose.prod.yml build frontend nginx postgres redis
    
    echo "🚀 Starting all services..."
    sudo docker compose -f docker-compose.prod.yml up -d
    
    echo "⏳ Waiting for services to be healthy..."
    sleep 20
    
    echo "📊 Service status:"
    sudo docker compose -f docker-compose.prod.yml ps
    
    echo ""
    echo "✅ Deployment complete!"
    echo "🌐 Application URL: http://4.213.154.131"
EOF

echo ""
echo "🎉 Application is live at: http://4.213.154.131"
