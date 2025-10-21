#!/bin/bash

# Azure Cost Control Setup Script
# This script helps you set up billing alerts and auto-shutdown

RESOURCE_GROUP="rg-cheapvm-india"
VM_NAME="ubuntu-cheapvm"
SUBSCRIPTION_NAME="Azure for Students"

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║   Azure Cost Control Setup for Students Subscription      ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════════════╝${NC}"
echo ""

# Get subscription ID
echo -e "${YELLOW}Getting subscription details...${NC}"
SUBSCRIPTION_ID=$(az account show --query id -o tsv)
echo -e "${GREEN}✓ Subscription ID: $SUBSCRIPTION_ID${NC}"
echo ""

# Menu
show_menu() {
    echo -e "${BLUE}Available Setup Options:${NC}"
    echo ""
    echo "1. Enable Auto-Shutdown (6:00 PM IST daily)"
    echo "2. View Current Auto-Shutdown Settings"
    echo "3. Disable Auto-Shutdown"
    echo "4. Setup Billing Alerts ($50, $75, $90 thresholds)"
    echo "5. Check Current Credit Balance"
    echo "6. View Monthly Cost Forecast"
    echo "7. Setup All (Auto-shutdown + Alerts)"
    echo "8. Exit"
    echo ""
}

enable_auto_shutdown() {
    echo -e "${YELLOW}Setting up Auto-Shutdown...${NC}"
    echo ""
    echo "Configuration:"
    echo "  • Shutdown Time: 18:00 (6:00 PM)"
    echo "  • Timezone: India Standard Time (IST)"
    echo "  • Status: Enabled"
    echo ""
    
    read -p "Enter your email for shutdown notifications: " EMAIL
    
    if [ -z "$EMAIL" ]; then
        echo -e "${RED}✗ Email is required for notifications${NC}"
        return 1
    fi
    
    echo ""
    echo -e "${YELLOW}Configuring auto-shutdown...${NC}"
    
    # Enable auto-shutdown
    az vm auto-shutdown \
        --resource-group "$RESOURCE_GROUP" \
        --name "$VM_NAME" \
        --time "1800" \
        --email "$EMAIL" \
        --location "centralindia"
    
    if [ $? -eq 0 ]; then
        echo ""
        echo -e "${GREEN}✓ Auto-shutdown enabled successfully!${NC}"
        echo ""
        echo "Details:"
        echo "  • VM will automatically stop at 6:00 PM IST every day"
        echo "  • You'll receive email notification 15 minutes before shutdown"
        echo "  • You can still manually start/stop VM anytime"
        echo "  • This saves ~$0.017/hour when VM is stopped"
        echo ""
    else
        echo -e "${RED}✗ Failed to enable auto-shutdown${NC}"
        echo "You can also set this up in Azure Portal:"
        echo "  1. Go to portal.azure.com"
        echo "  2. Navigate to Virtual Machines → $VM_NAME"
        echo "  3. Click 'Auto-shutdown' in left menu"
        echo "  4. Enable and configure schedule"
    fi
}

view_auto_shutdown() {
    echo -e "${YELLOW}Checking current auto-shutdown settings...${NC}"
    echo ""
    
    # Get VM resource ID
    VM_ID=$(az vm show --resource-group "$RESOURCE_GROUP" --name "$VM_NAME" --query id -o tsv)
    
    # Check auto-shutdown configuration
    az resource show \
        --ids "${VM_ID}/providers/microsoft.devtestlab/schedules/shutdown-computevm-${VM_NAME}" \
        --query "{Status:properties.status, Time:properties.dailyRecurrence.time, Timezone:properties.timeZoneId, Email:properties.notificationSettings.emailRecipient}" \
        -o table 2>/dev/null
    
    if [ $? -ne 0 ]; then
        echo -e "${YELLOW}⚠ Auto-shutdown is not configured${NC}"
        echo "Run option 1 to enable it."
    fi
}

disable_auto_shutdown() {
    echo -e "${YELLOW}Disabling auto-shutdown...${NC}"
    echo ""
    
    read -p "Are you sure you want to disable auto-shutdown? (y/n) " -n 1 -r
    echo ""
    
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        VM_ID=$(az vm show --resource-group "$RESOURCE_GROUP" --name "$VM_NAME" --query id -o tsv)
        
        az resource update \
            --ids "${VM_ID}/providers/microsoft.devtestlab/schedules/shutdown-computevm-${VM_NAME}" \
            --set properties.status=Disabled
        
        if [ $? -eq 0 ]; then
            echo -e "${GREEN}✓ Auto-shutdown disabled${NC}"
        else
            echo -e "${RED}✗ Failed to disable auto-shutdown${NC}"
        fi
    fi
}

setup_billing_alerts() {
    echo -e "${YELLOW}Setting up Billing Alerts...${NC}"
    echo ""
    echo "This will create cost alerts at:"
    echo "  • $50 (50% of your $100 credits)"
    echo "  • $75 (75% of your $100 credits)"
    echo "  • $90 (90% of your $100 credits)"
    echo ""
    
    read -p "Enter your email for cost alerts: " EMAIL
    
    if [ -z "$EMAIL" ]; then
        echo -e "${RED}✗ Email is required for alerts${NC}"
        return 1
    fi
    
    echo ""
    echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}"
    echo -e "${BLUE}  Manual Setup Required (Azure Portal)${NC}"
    echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}"
    echo ""
    echo "Cost alerts for Azure for Students require portal setup:"
    echo ""
    echo "Step 1: Open Azure Portal"
    echo "  → https://portal.azure.com"
    echo ""
    echo "Step 2: Navigate to Cost Management"
    echo "  → Search for 'Cost Management + Billing'"
    echo "  → Click on your 'Azure for Students' subscription"
    echo ""
    echo "Step 3: Create Budget"
    echo "  → Click 'Budgets' in left menu"
    echo "  → Click '+ Add'"
    echo "  → Name: 'Monthly Credit Alert'"
    echo "  → Amount: $100"
    echo "  → Reset period: Monthly"
    echo ""
    echo "Step 4: Set Alert Conditions"
    echo "  → Add Alert Condition 1:"
    echo "      Type: Actual"
    echo "      % of budget: 50%"
    echo "      Email: $EMAIL"
    echo ""
    echo "  → Add Alert Condition 2:"
    echo "      Type: Actual"
    echo "      % of budget: 75%"
    echo "      Email: $EMAIL"
    echo ""
    echo "  → Add Alert Condition 3:"
    echo "      Type: Actual"
    echo "      % of budget: 90%"
    echo "      Email: $EMAIL"
    echo ""
    echo "Step 5: Save Budget"
    echo "  → Click 'Create'"
    echo ""
    echo -e "${GREEN}You'll now receive email alerts when costs reach these thresholds!${NC}"
    echo ""
    
    read -p "Press Enter when you've completed the portal setup..."
}

check_credit_balance() {
    echo -e "${YELLOW}Checking credit balance and usage...${NC}"
    echo ""
    echo "To view your exact credit balance:"
    echo ""
    echo "Azure Portal Method:"
    echo "  1. Go to: https://portal.azure.com"
    echo "  2. Click: Subscriptions"
    echo "  3. Select: Azure for Students"
    echo "  4. Click: Credits (in left menu)"
    echo "  5. View: Remaining balance and expiry date"
    echo ""
    echo "Getting current month usage..."
    echo ""
    
    # Get current month usage
    START_DATE=$(date -d "$(date +%Y-%m-01)" +%Y-%m-%d)
    END_DATE=$(date +%Y-%m-%d)
    
    echo "Usage from $START_DATE to $END_DATE:"
    echo ""
    
    az consumption usage list \
        --start-date "$START_DATE" \
        --end-date "$END_DATE" \
        --query "[?contains(instanceName, 'cheapvm')].{Date:usageStart, Resource:instanceName, Cost:pretaxCost}" \
        -o table 2>/dev/null || echo "Run this in Azure Portal → Cost Management → Cost Analysis"
}

view_cost_forecast() {
    echo -e "${YELLOW}Monthly Cost Forecast${NC}"
    echo ""
    echo "Based on Standard_B1s VM in Central India:"
    echo ""
    echo "╔═══════════════════════════════════════════════════════════╗"
    echo "║  Usage Pattern           │  Cost/Month  │  Credits Last  ║"
    echo "╠═══════════════════════════════════════════════════════════╣"
    echo "║  24/7 (Always On)        │  $12-15      │  6-7 months    ║"
    echo "║  12 hours/day            │  $6-8        │  12-16 months  ║"
    echo "║  8 hours/day (business)  │  $4-5        │  20 months     ║"
    echo "║  Weekends only           │  $3-4        │  25 months     ║"
    echo "║  On-demand (as needed)   │  $1-3        │  33+ months    ║"
    echo "╚═══════════════════════════════════════════════════════════╝"
    echo ""
    echo "Current VM Status:"
    POWER_STATE=$(az vm get-instance-view --resource-group "$RESOURCE_GROUP" --name "$VM_NAME" --query instanceView.statuses[1].displayStatus -o tsv)
    echo "  Status: $POWER_STATE"
    
    if [[ $POWER_STATE == *"running"* ]]; then
        echo -e "  ${RED}⚠ Currently billing: ~$0.017/hour${NC}"
    else
        echo -e "  ${GREEN}✓ Not billing (deallocated)${NC}"
    fi
    echo ""
    
    echo "💡 Recommendation:"
    echo "  Use auto-shutdown + manual start for demos"
    echo "  Expected cost: $2-4/month"
    echo "  Your $100 credits would last: ~25-50 months!"
}

setup_all() {
    echo -e "${BLUE}Setting up all cost controls...${NC}"
    echo ""
    
    # Auto-shutdown
    enable_auto_shutdown
    echo ""
    echo "─────────────────────────────────────────────────────"
    echo ""
    
    # Billing alerts
    setup_billing_alerts
    echo ""
    
    echo -e "${GREEN}✓ Setup complete!${NC}"
    echo ""
    echo "Summary:"
    echo "  ✓ Auto-shutdown configured for 6:00 PM daily"
    echo "  ✓ Billing alerts ready (complete in portal)"
    echo "  ✓ VM management script available (./vm-management.sh)"
    echo ""
    echo "Next steps:"
    echo "  1. Complete billing alert setup in Azure Portal"
    echo "  2. Test: ./vm-management.sh status"
    echo "  3. Use: ./vm-management.sh stop (to save credits now)"
}

# Main menu loop
while true; do
    show_menu
    read -p "Select option (1-8): " choice
    echo ""
    
    case $choice in
        1)
            enable_auto_shutdown
            ;;
        2)
            view_auto_shutdown
            ;;
        3)
            disable_auto_shutdown
            ;;
        4)
            setup_billing_alerts
            ;;
        5)
            check_credit_balance
            ;;
        6)
            view_cost_forecast
            ;;
        7)
            setup_all
            ;;
        8)
            echo "Exiting..."
            exit 0
            ;;
        *)
            echo -e "${RED}Invalid option. Please select 1-8.${NC}"
            ;;
    esac
    
    echo ""
    echo "─────────────────────────────────────────────────────"
    echo ""
    read -p "Press Enter to continue..."
    clear
done
