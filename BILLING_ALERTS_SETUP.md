# Azure Billing Alerts & Auto-Shutdown Setup Guide

This guide walks you through setting up cost controls for your Azure for Students subscription.

## 🎯 Quick Setup

Run the interactive setup script:

```bash
cd ~/Projects/Claude\ Code\ VS\ Code\ Extension/vc-usecase-scoring
./setup-cost-controls.sh
```

Then select:
- **Option 7**: Setup All (Recommended for first-time setup)
- **Option 1**: Just enable auto-shutdown
- **Option 4**: Just setup billing alerts

---

## 🔔 Part 1: Auto-Shutdown Schedule

### What It Does
- Automatically stops your VM at 6:00 PM IST every day
- Sends email notification 15 minutes before shutdown
- Saves ~$0.017/hour = ~$12/month when VM is off
- You can still manually start/stop VM anytime

### Setup via Script

```bash
./setup-cost-controls.sh
# Select option 1 - Enable Auto-Shutdown
# Enter your email when prompted
```

### Setup via Azure Portal

1. **Open Azure Portal**
   - Go to: https://portal.azure.com
   - Search for "Virtual machines"

2. **Select Your VM**
   - Click on `ubuntu-cheapvm`

3. **Configure Auto-Shutdown**
   - In left menu, click **"Auto-shutdown"**
   - Toggle **"Enabled"** to ON
   - Set time: **18:00** (6:00 PM)
   - Select timezone: **India Standard Time (IST)**
   - Enter your email for notifications
   - Click **"Save"**

4. **Verify Setup**
   ```bash
   ./setup-cost-controls.sh
   # Select option 2 - View Current Auto-Shutdown Settings
   ```

### How It Works

```
Every Day at 5:45 PM IST → You receive email notification
Every Day at 6:00 PM IST → VM automatically stops
                         → Compute billing stops
                         → All data preserved
                         
Next Morning           → You manually start VM when needed
                         → Takes 2-3 minutes to start
                         → Docker containers auto-restart
```

### Manual Override

**Start VM Before Auto-Shutdown:**
```bash
./vm-management.sh start
```

**Temporarily Disable Auto-Shutdown:**
```bash
./setup-cost-controls.sh
# Select option 3 - Disable Auto-Shutdown
```

---

## 💰 Part 2: Billing Alerts Setup

### What It Does
- Sends email alerts when you reach spending thresholds
- Helps you track credit consumption
- Prevents surprise credit exhaustion

### Recommended Alert Thresholds

For $100 Azure for Students credits:

| Alert Level | Amount | % of Budget | Purpose |
|-------------|--------|-------------|---------|
| **Warning** | $50 | 50% | Early awareness |
| **Caution** | $75 | 75% | Time to optimize |
| **Critical** | $90 | 90% | Almost out of credits |

### Step-by-Step Setup in Azure Portal

#### Step 1: Navigate to Cost Management

1. Open: https://portal.azure.com
2. In search bar, type: **"Cost Management + Billing"**
3. Click on the result
4. Select your **"Azure for Students"** subscription

#### Step 2: Create a Budget

1. In left menu, click **"Budgets"**
2. Click **"+ Add"** button at the top
3. Fill in Budget Details:

   ```
   Scope: Your subscription (auto-selected)
   Name: Monthly Credit Alert
   Reset period: Monthly
   Creation date: (current month)
   Expiration date: (12 months from now)
   Amount: 100
   ```

4. Click **"Next"**

#### Step 3: Set Alert Conditions

**Alert 1 - 50% Warning:**
```
Type: Actual
% of budget: 50
Alert recipients (emails): your-email@example.com
Alert language: English
```
Click **"Add"** to add another alert

**Alert 2 - 75% Caution:**
```
Type: Actual
% of budget: 75
Alert recipients (emails): your-email@example.com
Alert language: English
```
Click **"Add"** to add another alert

**Alert 3 - 90% Critical:**
```
Type: Actual
% of budget: 90
Alert recipients (emails): your-email@example.com
Alert language: English
```

#### Step 4: Review and Create

1. Review all settings
2. Click **"Create"**
3. Wait for "Deployment succeeded" notification

#### Step 5: Verify Setup

Within a few minutes, you should receive a confirmation email from:
- **From:** Azure Subscriptions
- **Subject:** "You've been added as a recipient for budget alerts"

### What to Expect

**When You Reach $50 (50%):**
```
Subject: Budget alert: Monthly Credit Alert
Content: Your budget has reached 50% ($50 of $100)
Action: Review your usage, consider optimization
```

**When You Reach $75 (75%):**
```
Subject: Budget alert: Monthly Credit Alert
Content: Your budget has reached 75% ($75 of $100)
Action: Plan to stop VM or reduce usage
```

**When You Reach $90 (90%):**
```
Subject: Budget alert: Monthly Credit Alert
Content: Your budget has reached 90% ($90 of $100)
Action: Critical - Stop VM immediately or monitor closely
```

---

## 📊 Part 3: Cost Monitoring

### Check Your Credit Balance

**Method 1: Azure Portal (Recommended)**

1. Go to: https://portal.azure.com
2. Click **"Subscriptions"** in left menu (or search for it)
3. Click on **"Azure for Students"**
4. In left menu, click **"Credits"**
5. You'll see:
   - Total credits: $100
   - Remaining balance: $XX
   - Expiry date: XX/XX/XXXX
   - Daily/monthly usage graph

**Method 2: Command Line**

```bash
# Check current month usage
./setup-cost-controls.sh
# Select option 5 - Check Current Credit Balance
```

**Method 3: Cost Analysis**

1. Portal → Cost Management + Billing
2. Click **"Cost analysis"**
3. View detailed breakdown:
   - By service (Virtual Machines, Storage, Network)
   - By resource (ubuntu-cheapvm)
   - Daily/weekly/monthly trends
   - Forecasted spend

### Daily Usage Check Script

Create a daily habit:

```bash
# Check daily costs
cat > ~/check-vm-costs.sh << 'EOF'
#!/bin/bash
echo "🔍 Checking Azure VM costs..."
cd ~/Projects/Claude\ Code\ VS\ Code\ Extension/vc-usecase-scoring
./vm-management.sh status
echo ""
./setup-cost-controls.sh
# This will show current status and forecast
EOF

chmod +x ~/check-vm-costs.sh

# Add to your daily routine
echo "alias checkcost='~/check-vm-costs.sh'" >> ~/.bashrc
source ~/.bashrc
```

Now just run: `checkcost`

---

## 🎯 Complete Cost Control Strategy

### Recommended Setup

1. **Enable Auto-Shutdown** ✅
   - Stops VM at 6 PM daily
   - Saves $12/month automatically

2. **Setup Billing Alerts** ✅
   - Alerts at $50, $75, $90
   - Early warning system

3. **Use VM Management Script** ✅
   - Start only when needed
   - Stop after use

4. **Monitor Weekly** ✅
   - Check credit balance weekly
   - Review cost analysis monthly

### Expected Outcomes

With this setup:

```
📊 BEFORE Cost Controls:
   VM runs 24/7
   Cost: $15/month
   Credits last: 6-7 months
   Credits wasted: $0

📈 AFTER Cost Controls:
   VM runs 8 hours/day (auto-shutdown)
   Cost: $5/month
   Credits last: 20 months
   Credits saved: $70+ (over 6 months)
```

---

## 🚨 Emergency Procedures

### If You Receive 90% Alert

**Immediate Actions:**

1. **Stop VM Now**
   ```bash
   ./vm-management.sh stop
   ```

2. **Check What's Using Credits**
   - Portal → Cost Analysis
   - Look for unexpected resources
   - Delete unused resources

3. **Plan Your Remaining Usage**
   ```
   Remaining: $10
   Days in month: 10
   Budget: $1/day
   VM usage: 1 hour/day only
   ```

### If Credits Are Exhausted

**Options:**

1. **Wait for Monthly Reset**
   - Credits don't roll over
   - Next month you get full $100 again
   - This is a limitation of the subscription

2. **Upgrade Subscription**
   - Pay-as-you-go (requires credit card)
   - Only if absolutely necessary

3. **Use Alternative Free Tier**
   - Azure Container Instances (free tier)
   - Azure App Service (free tier)
   - Consider migration plan

---

## 📱 Mobile Monitoring

### Azure Mobile App

**Download:**
- iOS: https://apps.apple.com/app/microsoft-azure/id1219013620
- Android: https://play.google.com/store/apps/details?id=com.microsoft.azure

**Features:**
- Start/stop VM from phone
- View cost alerts
- Check credit balance
- Monitor resource usage
- Receive push notifications

**Setup:**
1. Download app
2. Sign in with Azure account
3. Enable notifications
4. Add widget to home screen for quick VM control

---

## ✅ Verification Checklist

After completing this guide, verify:

- [ ] Auto-shutdown is enabled (6 PM IST daily)
- [ ] You received auto-shutdown confirmation email
- [ ] Budget created with $100 limit
- [ ] Three alerts configured ($50, $75, $90)
- [ ] You received budget alert confirmation email
- [ ] VM management script works (`./vm-management.sh status`)
- [ ] Cost control script works (`./setup-cost-controls.sh`)
- [ ] You can view credit balance in portal
- [ ] Azure mobile app installed (optional)

---

## 🔗 Quick Commands Reference

```bash
# Interactive cost control setup
./setup-cost-controls.sh

# Check VM status and costs
./vm-management.sh status

# Stop VM to save credits
./vm-management.sh stop

# Start VM when needed
./vm-management.sh start

# View cost forecast
./vm-management.sh cost

# Check if auto-shutdown is active
./setup-cost-controls.sh
# Select option 2
```

---

## 📞 Support

**If You Need Help:**

1. **Azure Support for Students**
   - Email: azureforeducation@microsoft.com
   - Live Chat: Available in Azure Portal

2. **Documentation**
   - https://azure.microsoft.com/en-us/free/students/
   - https://docs.microsoft.com/azure/cost-management-billing/

3. **Community**
   - Microsoft Q&A: https://docs.microsoft.com/answers/
   - Stack Overflow: Tag [azure-students]

---

## 💡 Pro Tips

1. **Set Phone Reminders**
   - Daily 5:30 PM: "Check if VM needs to run past 6 PM"
   - Weekly Monday: "Review Azure credit balance"

2. **Create Email Rules**
   - Auto-label Azure alerts as important
   - Create folder for cost tracking

3. **Share Access**
   - If working in team, add team members to budget alerts
   - Everyone gets cost notifications

4. **Document Usage**
   - Keep log of when/why you start VM
   - Helps optimize future usage

5. **Plan Demos**
   - Schedule stakeholder demos in advance
   - Start VM 15 minutes before demo
   - Stop immediately after

---

**Remember:** Your $100 credits can last 6 months or 20+ months depending on how you manage the VM. Smart cost controls make a huge difference!

Start by running: `./setup-cost-controls.sh` and select option 7 (Setup All)
