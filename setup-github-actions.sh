#!/bin/bash

################################################################################
# GitHub Actions Workflow for Auto-Deployment
# 
# This creates a GitHub Actions workflow that automatically deploys to Azure VM
# whenever you push to the main branch.
#
# Location: .github/workflows/deploy.yml
################################################################################

mkdir -p .github/workflows

cat > .github/workflows/deploy.yml << 'EOF'
name: Deploy to Azure VM

on:
  push:
    branches:
      - main
  workflow_dispatch:  # Allow manual trigger

jobs:
  deploy:
    name: Deploy to Production
    runs-on: ubuntu-latest
    
    steps:
      - name: Checkout code
        uses: actions/checkout@v3
      
      - name: Setup SSH
        env:
          SSH_PRIVATE_KEY: ${{ secrets.AZURE_VM_SSH_KEY }}
          SSH_HOST: ${{ secrets.AZURE_VM_IP }}
          SSH_USER: ${{ secrets.AZURE_VM_USER }}
        run: |
          mkdir -p ~/.ssh
          echo "$SSH_PRIVATE_KEY" > ~/.ssh/id_rsa
          chmod 600 ~/.ssh/id_rsa
          ssh-keyscan -H $SSH_HOST >> ~/.ssh/known_hosts
      
      - name: Deploy to Azure VM
        env:
          SSH_HOST: ${{ secrets.AZURE_VM_IP }}
          SSH_USER: ${{ secrets.AZURE_VM_USER }}
        run: |
          ssh ${SSH_USER}@${SSH_HOST} << 'ENDSSH'
            set -e
            
            echo "📦 Navigating to project directory..."
            cd /home/azureuser/vc-usecase-scoring
            
            echo "🔄 Pulling latest changes..."
            git pull origin main
            
            echo "🐳 Restarting Docker services..."
            docker-compose down
            docker-compose up -d
            
            echo "⏳ Waiting for services to start..."
            sleep 10
            
            echo "✅ Deployment complete!"
            docker-compose ps
          ENDSSH
      
      - name: Health Check
        env:
          HEALTH_URL: ${{ secrets.AZURE_VM_IP }}
        run: |
          echo "🏥 Checking application health..."
          sleep 5
          
          HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" http://${HEALTH_URL}/api/health)
          
          if [ "$HTTP_CODE" == "200" ]; then
            echo "✅ Application is healthy!"
          else
            echo "⚠️ Health check returned: $HTTP_CODE"
            exit 1
          fi
      
      - name: Notify on Success
        if: success()
        run: |
          echo "🎉 Deployment successful!"
          echo "🌐 Application: http://${{ secrets.AZURE_VM_IP }}"
          echo "📚 API Docs: http://${{ secrets.AZURE_VM_IP }}/docs"
      
      - name: Notify on Failure
        if: failure()
        run: |
          echo "❌ Deployment failed!"
          echo "Check the logs above for details"
EOF

echo "✅ GitHub Actions workflow created!"
echo ""
echo "📋 Next steps:"
echo "1. Go to your GitHub repo: https://github.com/Yuvaraj1Aravindan/Startup-VC"
echo "2. Go to Settings → Secrets and variables → Actions"
echo "3. Add these secrets:"
echo "   - AZURE_VM_IP: 4.213.154.131"
echo "   - AZURE_VM_USER: azureuser"
echo "   - AZURE_VM_SSH_KEY: (your private SSH key from ~/.ssh/id_rsa)"
echo ""
echo "To get your SSH private key:"
echo "  cat ~/.ssh/id_rsa"
echo ""
echo "After adding secrets, every push to main will auto-deploy to Azure VM!"
