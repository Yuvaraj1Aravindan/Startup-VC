#!/bin/bash

################################################################################
# Sync Local Changes to GitHub and Azure VM
# 
# This script ensures your code stays in sync across:
#   Local Dev → GitHub → Azure VM (Production)
#
# Usage:
#   ./sync-all.sh                    # Full sync with auto-commit message
#   ./sync-all.sh "Custom message"   # Full sync with custom commit message
#   ./sync-all.sh --local-only       # Only push to GitHub, skip VM deployment
#   ./sync-all.sh --vm-only          # Only deploy to VM (assumes GitHub is up to date)
################################################################################

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
AZURE_VM_IP="4.213.154.131"
AZURE_VM_USER="azureuser"
AZURE_VM_PATH="/home/azureuser/vc-usecase-scoring"
GITHUB_REPO="https://github.com/Yuvaraj1Aravindan/Startup-VC.git"
COMMIT_MESSAGE="${1:-Auto-sync: $(date +'%Y-%m-%d %H:%M:%S')}"

# Mode flags
LOCAL_ONLY=false
VM_ONLY=false

# Parse arguments
if [[ "$1" == "--local-only" ]]; then
    LOCAL_ONLY=true
    COMMIT_MESSAGE="Auto-sync (local only): $(date +'%Y-%m-%d %H:%M:%S')"
elif [[ "$1" == "--vm-only" ]]; then
    VM_ONLY=true
fi

################################################################################
# Helper Functions
################################################################################

print_header() {
    echo -e "\n${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BLUE}  $1${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"
}

print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠ $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ $1${NC}"
}

################################################################################
# Step 1: Check Git Status
################################################################################

check_git_status() {
    print_header "Step 1: Checking Git Status"
    
    if ! git rev-parse --git-dir > /dev/null 2>&1; then
        print_error "Not a git repository!"
        exit 1
    fi
    
    # Check for uncommitted changes
    if [[ -n $(git status --porcelain) ]]; then
        print_info "Uncommitted changes detected:"
        git status --short
        return 0
    else
        print_success "Working directory is clean"
        return 1
    fi
}

################################################################################
# Step 2: Sync Local → GitHub
################################################################################

sync_to_github() {
    print_header "Step 2: Syncing Local → GitHub"
    
    # Add all changes
    print_info "Adding all changes..."
    git add .
    
    # Show what will be committed
    if [[ -n $(git diff --cached --name-only) ]]; then
        echo -e "\n${YELLOW}Files to be committed:${NC}"
        git diff --cached --name-only | sed 's/^/  /'
        echo ""
    fi
    
    # Commit changes
    print_info "Committing changes..."
    if git commit -m "$COMMIT_MESSAGE"; then
        print_success "Changes committed"
    else
        print_warning "No changes to commit (already up to date)"
    fi
    
    # Push to GitHub
    print_info "Pushing to GitHub..."
    if git push origin main; then
        print_success "Successfully pushed to GitHub"
        
        # Get latest commit info
        LATEST_COMMIT=$(git log -1 --oneline)
        print_info "Latest commit: $LATEST_COMMIT"
    else
        print_error "Failed to push to GitHub"
        exit 1
    fi
}

################################################################################
# Step 3: Sync GitHub → Azure VM
################################################################################

sync_to_vm() {
    print_header "Step 3: Syncing GitHub → Azure VM"
    
    # Check SSH connection
    print_info "Checking SSH connection to Azure VM..."
    if ! ssh -o ConnectTimeout=5 -o BatchMode=yes "$AZURE_VM_USER@$AZURE_VM_IP" exit 2>/dev/null; then
        print_error "Cannot connect to Azure VM via SSH"
        print_info "Please ensure:"
        print_info "  1. VM is running"
        print_info "  2. SSH key is configured (~/.ssh/id_rsa)"
        print_info "  3. Security group allows SSH (port 22)"
        exit 1
    fi
    print_success "SSH connection successful"
    
    # Pull latest changes on VM
    print_info "Pulling latest changes on Azure VM..."
    
    ssh "$AZURE_VM_USER@$AZURE_VM_IP" << 'ENDSSH'
        set -e
        
        # Navigate to project directory
        cd /home/azureuser/vc-usecase-scoring
        
        # Stash any local changes (in case VM was modified)
        if [[ -n $(git status --porcelain) ]]; then
            echo "  Stashing local changes on VM..."
            git stash
        fi
        
        # Pull latest from GitHub
        echo "  Pulling from GitHub..."
        git pull origin main
        
        # Show latest commit
        echo "  Latest commit on VM:"
        git log -1 --oneline
        
        # Restart services
        echo "  Restarting Docker services..."
        docker-compose down
        docker-compose up -d
        
        echo "  Waiting for services to start..."
        sleep 5
        
        # Check service status
        echo "  Service status:"
        docker-compose ps
ENDSSH
    
    if [ $? -eq 0 ]; then
        print_success "Successfully synced and restarted services on Azure VM"
        print_info "Application running at: http://$AZURE_VM_IP"
    else
        print_error "Failed to sync to Azure VM"
        exit 1
    fi
}

################################################################################
# Step 4: Verify Sync
################################################################################

verify_sync() {
    print_header "Step 4: Verifying Sync"
    
    # Get local commit hash
    LOCAL_COMMIT=$(git rev-parse HEAD)
    print_info "Local commit:  $LOCAL_COMMIT"
    
    # Get remote commit hash
    REMOTE_COMMIT=$(git rev-parse origin/main)
    print_info "GitHub commit: $REMOTE_COMMIT"
    
    # Get VM commit hash (if VM sync was done)
    if [ "$LOCAL_ONLY" = false ]; then
        VM_COMMIT=$(ssh "$AZURE_VM_USER@$AZURE_VM_IP" "cd $AZURE_VM_PATH && git rev-parse HEAD")
        print_info "VM commit:     $VM_COMMIT"
        
        # Compare all three
        if [[ "$LOCAL_COMMIT" == "$REMOTE_COMMIT" ]] && [[ "$REMOTE_COMMIT" == "$VM_COMMIT" ]]; then
            print_success "All environments are in sync! ✓"
        else
            print_warning "Commits don't match - there may be a sync issue"
        fi
    else
        # Compare local and remote only
        if [[ "$LOCAL_COMMIT" == "$REMOTE_COMMIT" ]]; then
            print_success "Local and GitHub are in sync! ✓"
        else
            print_warning "Local and GitHub commits don't match"
        fi
    fi
}

################################################################################
# Step 5: Health Check
################################################################################

health_check() {
    print_header "Step 5: Application Health Check"
    
    print_info "Checking application health..."
    
    # Wait a bit for services to fully start
    sleep 3
    
    # Check health endpoint
    if curl -s -o /dev/null -w "%{http_code}" "http://$AZURE_VM_IP/api/health" | grep -q "200"; then
        print_success "Application is healthy and responding"
        print_info "API Docs: http://$AZURE_VM_IP/docs"
        print_info "Frontend: http://$AZURE_VM_IP"
    else
        print_warning "Application health check failed - may still be starting"
        print_info "Check logs: ssh $AZURE_VM_USER@$AZURE_VM_IP 'cd $AZURE_VM_PATH && docker-compose logs'"
    fi
}

################################################################################
# Main Execution
################################################################################

main() {
    print_header "🔄 Code Synchronization Script"
    print_info "Mode: ${LOCAL_ONLY:+Local Only}${VM_ONLY:+VM Only}${LOCAL_ONLY:+${VM_ONLY:+}}${LOCAL_ONLY:-${VM_ONLY:-Full Sync}}"
    print_info "Commit message: $COMMIT_MESSAGE"
    
    # Step 1: Check git status
    HAS_CHANGES=false
    if check_git_status; then
        HAS_CHANGES=true
    fi
    
    # Step 2: Sync to GitHub (unless VM-only mode)
    if [ "$VM_ONLY" = false ]; then
        if [ "$HAS_CHANGES" = true ]; then
            sync_to_github
        else
            print_warning "No changes to sync to GitHub (working directory clean)"
            print_info "Skipping GitHub sync..."
        fi
    else
        print_info "Skipping GitHub sync (VM-only mode)"
    fi
    
    # Step 3: Sync to Azure VM (unless local-only mode)
    if [ "$LOCAL_ONLY" = false ]; then
        sync_to_vm
    else
        print_info "Skipping Azure VM sync (local-only mode)"
    fi
    
    # Step 4: Verify sync
    verify_sync
    
    # Step 5: Health check (only if VM was updated)
    if [ "$LOCAL_ONLY" = false ]; then
        health_check
    fi
    
    # Final summary
    print_header "✅ Sync Complete"
    echo -e "${GREEN}Your code is now synchronized across:${NC}"
    echo -e "  ${GREEN}✓${NC} Local development environment"
    if [ "$VM_ONLY" = false ]; then
        echo -e "  ${GREEN}✓${NC} GitHub repository: $GITHUB_REPO"
    fi
    if [ "$LOCAL_ONLY" = false ]; then
        echo -e "  ${GREEN}✓${NC} Azure VM: http://$AZURE_VM_IP"
    fi
    echo ""
}

# Run main function
main

################################################################################
# Usage Examples:
#
# 1. Full sync (all changes):
#    ./sync-all.sh
#
# 2. Full sync with custom message:
#    ./sync-all.sh "feat: Add new scoring algorithm"
#
# 3. Only push to GitHub (skip VM deployment):
#    ./sync-all.sh --local-only
#
# 4. Only deploy to VM (assumes GitHub is up to date):
#    ./sync-all.sh --vm-only
#
# 5. Quick test:
#    ./sync-all.sh "test: Quick fix"
################################################################################
