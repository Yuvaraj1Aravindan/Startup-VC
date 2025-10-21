#!/bin/bash

# Azure VM Management Script for Cost Optimization
# This script helps you start/stop the VM to conserve Azure credits

RESOURCE_GROUP="rg-cheapvm-india"
VM_NAME="ubuntu-cheapvm"

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

show_usage() {
    echo "Usage: $0 {start|stop|status|cost}"
    echo ""
    echo "Commands:"
    echo "  start   - Start the VM (begins billing)"
    echo "  stop    - Stop and deallocate VM (stops billing)"
    echo "  status  - Check VM power state"
    echo "  cost    - Show estimated monthly cost"
    exit 1
}

start_vm() {
    echo -e "${YELLOW}Starting VM...${NC}"
    az vm start --resource-group "$RESOURCE_GROUP" --name "$VM_NAME"
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✓ VM started successfully!${NC}"
        echo ""
        echo "Getting public IP..."
        PUBLIC_IP=$(az vm show -d --resource-group "$RESOURCE_GROUP" --name "$VM_NAME" --query publicIps -o tsv)
        echo -e "${GREEN}Public IP: $PUBLIC_IP${NC}"
        echo -e "${GREEN}Application URL: http://$PUBLIC_IP${NC}"
        echo -e "${GREEN}SSH: ssh azureuser@$PUBLIC_IP${NC}"
    else
        echo -e "${RED}✗ Failed to start VM${NC}"
        exit 1
    fi
}

stop_vm() {
    echo -e "${YELLOW}Stopping and deallocating VM...${NC}"
    echo "This will stop compute charges."
    read -p "Are you sure? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        az vm deallocate --resource-group "$RESOURCE_GROUP" --name "$VM_NAME"
        
        if [ $? -eq 0 ]; then
            echo -e "${GREEN}✓ VM stopped and deallocated successfully!${NC}"
            echo -e "${GREEN}✓ Compute charges have stopped.${NC}"
            echo ""
            echo "Note: Storage charges (~$2/month) still apply."
        else
            echo -e "${RED}✗ Failed to stop VM${NC}"
            exit 1
        fi
    else
        echo "Cancelled."
    fi
}

check_status() {
    echo -e "${YELLOW}Checking VM status...${NC}"
    echo ""
    
    # Get VM power state
    POWER_STATE=$(az vm get-instance-view --resource-group "$RESOURCE_GROUP" --name "$VM_NAME" --query instanceView.statuses[1].displayStatus -o tsv)
    
    echo "VM Name: $VM_NAME"
    echo "Resource Group: $RESOURCE_GROUP"
    echo "Power State: $POWER_STATE"
    
    if [[ $POWER_STATE == *"running"* ]]; then
        echo -e "${GREEN}Status: Running (billing active)${NC}"
        PUBLIC_IP=$(az vm show -d --resource-group "$RESOURCE_GROUP" --name "$VM_NAME" --query publicIps -o tsv)
        echo "Public IP: $PUBLIC_IP"
        echo "Application URL: http://$PUBLIC_IP"
    elif [[ $POWER_STATE == *"deallocated"* ]]; then
        echo -e "${YELLOW}Status: Stopped/Deallocated (compute billing stopped)${NC}"
    else
        echo -e "${YELLOW}Status: $POWER_STATE${NC}"
    fi
    
    echo ""
    echo "To start: ./vm-management.sh start"
    echo "To stop: ./vm-management.sh stop"
}

show_cost() {
    echo -e "${YELLOW}Cost Information for Standard_B1s VM${NC}"
    echo ""
    echo "═══════════════════════════════════════════════════"
    echo "  Azure for Students Subscription"
    echo "═══════════════════════════════════════════════════"
    echo ""
    echo "Initial Credits: $100 USD (12 months validity)"
    echo ""
    echo "Monthly Costs (when VM is running 24/7):"
    echo "  • VM Compute (Standard_B1s):  ~$10-12/month"
    echo "  • Storage (30 GB HDD):         ~$2/month"
    echo "  • Public IP (Dynamic):         ~$0-3/month"
    echo "  ─────────────────────────────────────────"
    echo "  Total:                         ~$12-15/month"
    echo ""
    echo "Credits Remaining After:"
    echo "  • 1 month:  ~$85 remaining"
    echo "  • 3 months: ~$55 remaining"
    echo "  • 6 months: ~$10 remaining"
    echo ""
    echo "═══════════════════════════════════════════════════"
    echo "  Cost Optimization Tips"
    echo "═══════════════════════════════════════════════════"
    echo ""
    echo "1. Stop VM when not in use:"
    echo "   ./vm-management.sh stop"
    echo "   → Saves: ~$0.017/hour or ~$12/month"
    echo ""
    echo "2. Example usage pattern:"
    echo "   • Run VM only during business hours (8 hours/day)"
    echo "   • Monthly cost: ~$4-5 instead of $12-15"
    echo "   • Credits last: ~20 months instead of 6-7 months"
    echo ""
    echo "3. Check Azure Portal for actual usage:"
    echo "   Cost Management + Billing → Credits"
    echo ""
}

# Main script logic
case "${1:-}" in
    start)
        start_vm
        ;;
    stop)
        stop_vm
        ;;
    status)
        check_status
        ;;
    cost)
        show_cost
        ;;
    *)
        show_usage
        ;;
esac
