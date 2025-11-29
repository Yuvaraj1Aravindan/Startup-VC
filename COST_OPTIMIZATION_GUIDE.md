# Azure VM Cost Optimization Guide

## Azure for Students Subscription

Your Azure for Students subscription includes:
- **$100 USD in free credits**
- **12 months validity**
- No credit card required
- Access to many Azure services

## Current VM Cost Breakdown

### Monthly Costs (VM running 24/7)

| Component | Cost per Month | Notes |
|-----------|---------------|-------|
| **VM Compute** (Standard_B1s) | $10-12 | 1 vCPU, 1 GB RAM |
| **Storage** (30 GB Standard HDD) | $2 | OS disk |
| **Public IP** (Dynamic) | $0-3 | Only if reserved as static |
| **Network Egress** | <$1 | Minimal for demo usage |
| **Total** | **$12-15** | Approximate monthly cost |

### Credit Consumption Timeline

If VM runs **24/7**:
```
Month 1:  $100 - $15 = $85 remaining
Month 2:  $85  - $15 = $70 remaining
Month 3:  $70  - $15 = $55 remaining
Month 4:  $55  - $15 = $40 remaining
Month 5:  $40  - $15 = $25 remaining
Month 6:  $25  - $15 = $10 remaining
Month 7:  Credits exhausted
```

## 💰 Cost Optimization Strategies

### Strategy 1: Stop VM When Not In Use

**Impact:** Save ~$12-15/month when stopped

Use the provided `vm-management.sh` script:

```bash
# Check VM status
./vm-management.sh status

# Stop VM (stops compute billing)
./vm-management.sh stop

# Start VM when needed
./vm-management.sh start

# View cost information
./vm-management.sh cost
```

**Important:** When VM is deallocated:
- ✅ Compute charges **STOP**
- ✅ All data is preserved
- ⚠️ Storage charges continue (~$2/month)
- ⚠️ Public IP may change (unless reserved as static)

### Strategy 2: Smart Usage Patterns

#### Pattern A: Business Hours Only (8 hours/day, 5 days/week)
```
Hours per month: ~160 hours
Cost: ~$4-5/month
Credits last: ~20 months
```

Commands:
```bash
# Morning (start of work)
./vm-management.sh start

# Evening (end of work)
./vm-management.sh stop
```

#### Pattern B: Demo/Presentation Days Only
```
Usage: 2-3 days per week
Cost: ~$2-3/month
Credits last: ~33 months (almost 3 years!)
```

#### Pattern C: Weekends Only
```
Usage: 48 hours/week
Cost: ~$3-4/month
Credits last: ~25 months
```

### Strategy 3: Azure CLI Quick Commands

```bash
# Stop VM (deallocate to stop billing)
az vm deallocate --resource-group rg-cheapvm-india --name ubuntu-cheapvm

# Start VM
az vm start --resource-group rg-cheapvm-india --name ubuntu-cheapvm

# Get VM status
az vm get-instance-view \
  --resource-group rg-cheapvm-india \
  --name ubuntu-cheapvm \
  --query instanceView.statuses[1].displayStatus

# Get public IP after starting
az vm show -d \
  --resource-group rg-cheapvm-india \
  --name ubuntu-cheapvm \
  --query publicIps -o tsv
```

### Strategy 4: Set Up Billing Alerts

1. **Go to Azure Portal** → Cost Management + Billing
2. **Navigate to:** Cost alerts → Add alert
3. **Create alerts at:**
   - $50 (50% of credits)
   - $75 (75% of credits)
   - $90 (90% of credits)
4. **Get email notifications** when thresholds are reached

### Strategy 5: Auto-Shutdown Schedule

Configure auto-shutdown in Azure Portal:

1. Go to your VM → **Auto-shutdown**
2. Enable auto-shutdown
3. Set time: e.g., 6:00 PM daily
4. Set timezone: IST (India Standard Time)
5. Get email notification before shutdown

This ensures you never accidentally leave the VM running overnight!

## 📊 Cost Monitoring

### Check Current Credit Balance

**Azure Portal Method:**
1. Go to https://portal.azure.com
2. Navigate to **Subscriptions**
3. Select **Azure for Students**
4. Click **Credits** in the left menu
5. View remaining balance

**Azure CLI Method:**
```bash
# List subscription details
az account show --subscription "Azure for Students"

# View cost to date (current month)
az consumption usage list \
  --start-date 2025-10-01 \
  --end-date 2025-10-19 \
  --query "[].{Date:usageStart, Cost:pretaxCost, Resource:instanceName}"
```

### Daily Cost Tracking

```bash
# Create a script to check daily
cat > check-daily-cost.sh << 'EOF'
#!/bin/bash
echo "Checking Azure costs for today..."
START_DATE=$(date -d "yesterday" +%Y-%m-%d)
END_DATE=$(date +%Y-%m-%d)

az consumption usage list \
  --start-date $START_DATE \
  --end-date $END_DATE \
  --query "[?contains(instanceName, 'ubuntu-cheapvm')].{Resource:instanceName, Cost:pretaxCost}" \
  -o table
EOF

chmod +x check-daily-cost.sh
```

## 🎯 Recommended Usage for Your Demo

Since you're deploying this for **stakeholder demonstration**:

### Week 1-2: Active Development & Demo
- Keep VM running during demo preparation
- Cost: ~$7-8 for 2 weeks
- Stop VM overnight if possible

### Week 3+: On-Demand Access
- Stop VM by default
- Start only when stakeholders need access
- Send stakeholders a heads-up: "Starting demo server..."
- Cost: ~$2-4/month

### Before Important Meetings
```bash
# 15 minutes before meeting
./vm-management.sh start
# Wait 2-3 minutes for services to start
# Test: curl http://4.213.154.131

# After meeting
./vm-management.sh stop
```

## 📝 VM Management Workflow

### Daily Operations

**Morning Startup:**
```bash
cd ~/Projects/Claude\ Code\ VS\ Code\ Extension/vc-usecase-scoring
./vm-management.sh start
# Wait ~2 minutes for services
curl http://4.213.154.131/api/health
```

**Evening Shutdown:**
```bash
./vm-management.sh stop
# Compute billing stops immediately
```

### Check Before Meetings

```bash
# Quick status check
./vm-management.sh status

# If stopped, start it
./vm-management.sh start

# Verify application is accessible
curl http://4.213.154.131
```

## 🚨 Important Notes

### What Happens When VM is Stopped?

✅ **Preserved:**
- All files and data
- Docker images and containers
- Database data
- Application configuration

⚠️ **May Change:**
- Public IP address (if dynamic)
- Need to update stakeholders with new IP

❌ **Stopped:**
- Application becomes inaccessible
- Compute billing stops

### When You Start VM Again

```bash
# 1. Start VM
./vm-management.sh start

# 2. SSH to VM (use new IP if changed)
ssh azureuser@<NEW_IP>

# 3. Restart Docker containers
cd ~/vc-usecase-scoring
sudo docker compose -f docker-compose.prod.yml up -d

# 4. Verify services
sudo docker compose -f docker-compose.prod.yml ps
```

## 💡 Pro Tips

1. **Use Azure Mobile App**
   - Start/stop VM from your phone
   - Monitor costs on the go
   - Get real-time alerts

2. **Create Aliases**
   ```bash
   # Add to ~/.bashrc
   alias vmstart='cd ~/Projects/Claude\ Code\ VS\ Code\ Extension/vc-usecase-scoring && ./vm-management.sh start'
   alias vmstop='cd ~/Projects/Claude\ Code\ VS\ Code\ Extension/vc-usecase-scoring && ./vm-management.sh stop'
   alias vmstatus='cd ~/Projects/Claude\ Code\ VS\ Code\ Extension/vc-usecase-scoring && ./vm-management.sh status'
   ```

3. **Calendar Reminders**
   - Set reminder to stop VM at end of day
   - Review monthly costs on 1st of each month

4. **Document for Stakeholders**
   - Let them know VM may not be 24/7
   - Provide your contact to request VM start
   - Typical startup time: 2-3 minutes

## 📈 Best Case Scenario

With smart usage (8 hours/day, 5 days/week):
```
Cost per month: ~$4-5
Total months: ~20 months
Savings: $80+ in credits
```

Your $100 credits could last almost **2 years** instead of just **6-7 months**!

## 🔗 Quick Reference

| Task | Command |
|------|---------|
| Check status | `./vm-management.sh status` |
| Start VM | `./vm-management.sh start` |
| Stop VM | `./vm-management.sh stop` |
| View costs | `./vm-management.sh cost` |
| Check IP | `az vm show -d -g rg-cheapvm-india -n ubuntu-cheapvm --query publicIps -o tsv` |
| SSH to VM | `ssh azureuser@$(az vm show -d -g rg-cheapvm-india -n ubuntu-cheapvm --query publicIps -o tsv)` |

---

**Remember:** Every hour the VM is stopped saves you money! Make it a habit to stop the VM when not actively using it.
