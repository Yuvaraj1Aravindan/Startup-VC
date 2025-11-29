# 🎯 Quick Start: Code Sync & Story Management

**TL;DR**: Use GitHub Issues (FREE) instead of Jira ($72/year). Automate sync between Local → GitHub → Azure VM.

---

## ⚡ Quick Commands

### Sync Everything (Local → GitHub → Azure VM)
```bash
cd ~/Projects/Claude\ Code\ VS\ Code\ Extension/vc-usecase-scoring
./sync-all.sh "Your commit message"
```

### Push to GitHub Only (Skip VM deployment)
```bash
./sync-all.sh --local-only
```

### Deploy to VM Only (GitHub already updated)
```bash
./sync-all.sh --vm-only
```

### Create a Story/Issue
```bash
gh issue create \
  --title "[STORY] Your story title" \
  --label "story,feature" \
  --milestone "Sprint 1"
```

---

## 📚 Documentation Files Created

| File | Purpose |
|------|---------|
| **CODE_SYNC_STRATEGY.md** | Full comparison: GitHub vs Azure DevOps vs Jira |
| **STORY_TOOLS_COMPARISON.md** | Detailed feature comparison & cost analysis |
| **GITHUB_ISSUES_SETUP.md** | Step-by-step setup guide for GitHub Issues |
| **sync-all.sh** | Automated sync script (Local → GitHub → VM) |
| **setup-github-actions.sh** | Setup auto-deployment via GitHub Actions |
| **.github/ISSUE_TEMPLATE/** | Issue templates (bug, feature, story) |

---

## 💰 Cost Comparison

| Tool | Your Cost | Regular Cost | Features |
|------|-----------|--------------|----------|
| **GitHub Issues** | **$0/month** | $0/month | ✅ Unlimited, Native Git |
| Azure DevOps | $0/month (5 users) | $6/user/month | ✅ Advanced CI/CD |
| Atlassian Jira | $6/month | $24/month | ⚠️ Overkill for solo dev |

**Recommendation**: **GitHub Issues (FREE)** ✅  
**Save**: $72/year → Use for 2 more months of Azure VM

---

## 🔄 Workflow Overview

```
┌─────────────────┐
│  1. LOCAL DEV   │  → Make code changes in VS Code
└────────┬────────┘
         │
         │ ./sync-all.sh "commit message"
         ▼
┌─────────────────┐
│  2. GITHUB      │  → Code pushed, Actions triggered
└────────┬────────┘
         │
         │ Auto-deploy (or manual: sync-all.sh)
         ▼
┌─────────────────┐
│  3. AZURE VM    │  → Services restarted, live at 4.213.154.131
└─────────────────┘
```

---

## ✅ Setup Checklist

### Immediate (Today - 15 minutes)
- [x] Read CODE_SYNC_STRATEGY.md (recommendation: GitHub Issues)
- [x] sync-all.sh script created and executable
- [x] GitHub issue templates created
- [ ] Test sync-all.sh with a small change
- [ ] Create first GitHub issue
- [ ] Create GitHub Project board

### This Week (2 hours)
- [ ] Setup GitHub Actions for auto-deployment
- [ ] Create project labels and milestones
- [ ] Convert todos to GitHub Issues
- [ ] Share workflow with team (TEAM_ACCESS.md)
- [ ] Setup cost controls (Azure auto-shutdown)

### This Month (Ongoing)
- [ ] Use GitHub Issues for all new work
- [ ] Review sync process weekly
- [ ] Optimize Azure costs
- [ ] Collect team feedback
- [ ] Evaluate if Jira needed (likely no)

---

## 🚀 Getting Started

### Step 1: Test the Sync Script
```bash
cd ~/Projects/Claude\ Code\ VS\ Code\ Extension/vc-usecase-scoring

# Make a small change (update README)
echo "Last updated: $(date)" >> README.md

# Sync everything
./sync-all.sh "test: Verify sync workflow"

# Check if it worked
# - GitHub: https://github.com/Yuvaraj1Aravindan/Startup-VC
# - Azure VM: http://4.213.154.131
```

### Step 2: Setup GitHub Issues
```bash
# Create labels
gh label create "story" --color "1d76db" --description "User story"
gh label create "epic" --color "5319e7" --description "Large body of work"
gh label create "task" --color "fbca04" --description "Development task"

# Create milestone
gh milestone create "Sprint 1" --due-date "2025-11-15" --description "MVP features"

# Create first issue
gh issue create \
  --title "[STORY] Setup GitHub Issues workflow" \
  --body "Set up GitHub Issues and Projects for story management" \
  --label "story,task" \
  --milestone "Sprint 1"
```

### Step 3: Create Project Board
1. Go to: https://github.com/Yuvaraj1Aravindan/Startup-VC/projects
2. Click "New Project"
3. Choose "Team backlog" template
4. Name it "Startup-VC Development"
5. Add your first issue to the board

---

## 📖 Key Documents to Read

### Priority 1 (Read Today):
1. **CODE_SYNC_STRATEGY.md** - Why GitHub Issues over Jira
2. **sync-all.sh** - How to sync code
3. **GITHUB_ISSUES_SETUP.md** - How to setup issues

### Priority 2 (Read This Week):
1. **STORY_TOOLS_COMPARISON.md** - Detailed feature comparison
2. **TEAM_ACCESS.md** - How team members can contribute
3. **SHARING_TEMPLATE.md** - How to share the project

---

## 🎯 Decision Summary

### Story Management Tool: **GitHub Issues** ✅

**Why NOT Jira?**
- ❌ $72/year unnecessary cost
- ❌ Overkill for solo/small teams
- ❌ Complex learning curve
- ❌ Not integrated with GitHub

**Why YES to GitHub Issues?**
- ✅ $0/year - completely free
- ✅ Native GitHub integration
- ✅ Simple and fast
- ✅ Mobile app included
- ✅ Perfect for teams < 10

**When to reconsider Jira:**
- Team grows to 10+ people
- Need advanced reporting
- Corporate job requirement
- Want to learn industry-standard tools

---

## 💡 Pro Tips

### Sync Workflow
```bash
# Before starting work
git pull origin main

# After making changes
./sync-all.sh "feat: Your feature description"

# Emergency rollback
git revert HEAD
./sync-all.sh "revert: Emergency rollback"
```

### Issue Management
```bash
# List all open issues
gh issue list

# View specific issue
gh issue view 123

# Close issue
gh issue close 123 --comment "Fixed in commit abc123"

# Reopen issue
gh issue reopen 123
```

### Project Board
- Drag issues between columns
- Use filters (label:bug, assignee:@me)
- Set up automation (move to "Done" on close)

---

## 🔗 Important Links

### Your Project
- **GitHub Repo**: https://github.com/Yuvaraj1Aravindan/Startup-VC
- **Live App**: http://4.213.154.131
- **API Docs**: http://4.213.154.131/docs

### GitHub Resources
- **Issues**: https://github.com/Yuvaraj1Aravindan/Startup-VC/issues
- **Projects**: https://github.com/Yuvaraj1Aravindan/Startup-VC/projects
- **Actions**: https://github.com/Yuvaraj1Aravindan/Startup-VC/actions

### Documentation
- GitHub Issues Docs: https://docs.github.com/en/issues
- GitHub Projects Docs: https://docs.github.com/en/issues/planning-and-tracking-with-projects
- GitHub CLI Docs: https://cli.github.com/manual/

---

## 🆘 Troubleshooting

### Sync Script Fails
```bash
# Check git status
git status

# Check SSH to VM
ssh azureuser@4.213.154.131

# Check Docker on VM
ssh azureuser@4.213.154.131 "docker-compose ps"

# Manual sync
git push origin main
ssh azureuser@4.213.154.131 "cd vc-usecase-scoring && git pull && docker-compose restart"
```

### GitHub Issues Not Working
```bash
# Check GitHub CLI
gh auth status

# Login if needed
gh auth login

# Check repo access
gh repo view Yuvaraj1Aravindan/Startup-VC
```

---

## 📞 Next Steps

1. **Today**: Test sync-all.sh and create first GitHub issue
2. **Tomorrow**: Setup project board and convert todos to issues
3. **This Week**: Get team using the workflow
4. **This Month**: Evaluate and optimize

---

**You're all set! 🎉**

Your code will stay in sync across Local → GitHub → Azure VM, and you'll manage stories for FREE with GitHub Issues!

**Total saved**: $72/year by not using Jira  
**Total time**: ~1 hour setup, saves 5+ hours/month
