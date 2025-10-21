# ✅ GitHub Issues Setup Complete!

**Date**: October 21, 2025  
**Duration**: 3 minutes  
**Cost**: $0/year (saved $72 by not using Jira!)

---

## 🎉 What Was Completed

### ✅ 1. Custom Labels (20 total labels)

**Default Labels (9):**
- `bug` - Something isn't working
- `documentation` - Improvements or additions to documentation
- `duplicate` - This issue or pull request already exists
- `enhancement` - New feature or request
- `good first issue` - Good for newcomers
- `help wanted` - Extra attention is needed
- `invalid` - This doesn't seem right
- `question` - Further information is requested
- `wontfix` - This will not be worked on

**Custom Labels Added (11):**
- `story` - User story for agile development (blue)
- `epic` - Large body of work (purple)
- `task` - Development task (yellow)
- `feature` - New feature or functionality (green)
- `frontend` - Frontend (React) related (pink)
- `backend` - Backend (FastAPI) related (orange)
- `database` - Database schema or queries (brown)
- `deployment` - Deployment/DevOps/Infrastructure (teal)
- `priority: high` - High priority - urgent (red)
- `priority: medium` - Medium priority (yellow)
- `priority: low` - Low priority (green)

---

### ✅ 2. Milestones Created (3 sprints)

1. **Sprint 1 - MVP Features**
   - Due: November 15, 2025
   - Description: Complete remaining MVP features
   - Focus: VC Agent testing, stakeholder sharing, cost controls

2. **Sprint 2 - User Feedback**
   - Due: December 1, 2025
   - Description: Iterate based on user feedback and improve UX

3. **v1.0 Release**
   - Due: January 1, 2026
   - Description: Production-ready v1.0 release

---

### ✅ 3. Issues Created (3 from todos)

**Issue #1: [STORY] Test and demo VC Agent with real data**
- URL: https://github.com/Yuvaraj1Aravindan/Startup-VC/issues/1
- Labels: `story`, `task`, `backend`, `priority: high`
- Milestone: Sprint 1 - MVP Features
- Acceptance Criteria:
  - Test with 10 real startup pitches
  - Compare AI scores with human VC evaluations
  - Document discrepancies
  - Share results with team
  - Explore integration options

**Issue #2: [TASK] Share VC app with stakeholders**
- URL: https://github.com/Yuvaraj1Aravindan/Startup-VC/issues/2
- Labels: `task`, `documentation`, `priority: high`
- Milestone: Sprint 1 - MVP Features
- Tasks:
  - Prepare stakeholder list
  - Customize email template
  - Send demo credentials and URLs
  - Schedule demo meeting
  - Collect feedback

**Issue #3: [TASK] Setup Azure cost controls and auto-shutdown**
- URL: https://github.com/Yuvaraj1Aravindan/Startup-VC/issues/3
- Labels: `task`, `deployment`, `priority: medium`
- Milestone: Sprint 1 - MVP Features
- Tasks:
  - Run setup-cost-controls.sh
  - Configure auto-shutdown at 6 PM IST
  - Setup billing alerts ($50, $75, $90)
  - Set monthly budget cap
  - Test auto-shutdown

---

### ✅ 4. Issue Templates (Already in repo)

Located in `.github/ISSUE_TEMPLATE/`:

1. **bug_report.md** - For reporting bugs
   - Sections: Description, Steps to Reproduce, Expected/Actual Behavior, Screenshots, Environment

2. **feature_request.md** - For requesting features
   - Sections: Feature Description, Problem Statement, Proposed Solution, User Story, Impact

3. **user_story.md** - For agile user stories
   - Sections: User Story, Acceptance Criteria, Story Points, Business Value, Testing Scenarios

---

## ⚠️ One Manual Step Remaining

### GitHub Project Board (2 minutes to create)

**Why manual?**
- Requires additional GitHub CLI permissions (`project`, `read:project`)
- Easier to create via web UI with visual templates

**How to create:**

1. Go to: https://github.com/Yuvaraj1Aravindan/Startup-VC/projects

2. Click **"New Project"**

3. Choose template: **"Team backlog"** or **"Board"**

4. Name it: **"Startup-VC Development"**

5. Add your 3 issues (#1, #2, #3) to the board

6. Organize into columns:
   - 📋 **Backlog** - Future work
   - 🔜 **To Do** - Ready for this sprint
   - 🏃 **In Progress** - Currently working
   - 👀 **In Review** - Testing/review
   - ✅ **Done** - Completed

**Alternative (if you want CLI):**
```bash
gh auth refresh -s project,read:project
gh project create --owner "@me" --title "Startup-VC Development"
```

---

## 🔗 Quick Links

### Your GitHub Resources:
- **All Issues**: https://github.com/Yuvaraj1Aravindan/Startup-VC/issues
- **Projects** (create board here): https://github.com/Yuvaraj1Aravindan/Startup-VC/projects
- **Labels**: https://github.com/Yuvaraj1Aravindan/Startup-VC/labels
- **Milestones**: https://github.com/Yuvaraj1Aravindan/Startup-VC/milestones

### Your Application:
- **Live App**: http://4.213.154.131
- **API Docs**: http://4.213.154.131/docs
- **Health Check**: http://4.213.154.131/api/health

---

## 💡 How to Use GitHub Issues

### Viewing Issues

```bash
# List all open issues
gh issue list

# View specific issue
gh issue view 1

# View issue #1 in browser
gh issue view 1 --web
```

### Creating Issues

```bash
# Using template (recommended)
gh issue create --template user_story.md

# Quick create
gh issue create \
  --title "[STORY] Your story title" \
  --label "story,backend" \
  --milestone "Sprint 1 - MVP Features"

# Interactive mode
gh issue create
```

### Managing Issues

```bash
# Add label
gh issue edit 1 --add-label "priority: high"

# Remove label
gh issue edit 1 --remove-label "priority: low"

# Assign to yourself
gh issue edit 1 --add-assignee @me

# Change milestone
gh issue edit 1 --milestone "Sprint 2 - User Feedback"

# Close issue
gh issue close 1 --comment "Completed and tested!"

# Reopen issue
gh issue reopen 1
```

### Linking Issues to Code

**In commit messages:**
```bash
git commit -m "feat: Add startup matching algorithm

Implements the core matching logic with scoring.

Fixes #1
Closes #2
Related to #3"
```

**Keywords that auto-close issues:**
- `Fixes #123`
- `Closes #123`
- `Resolves #123`

**In Pull Requests:**
```markdown
## Related Issues
- Closes #1
- Addresses #2
- Part of epic #5
```

---

## 📱 GitHub Mobile App

Download the GitHub mobile app to manage issues on-the-go:

- **iOS**: https://apps.apple.com/app/github/id1477376905
- **Android**: https://play.google.com/store/apps/details?id=com.github.android

**What you can do:**
- ✅ Create and comment on issues
- ✅ Review pull requests
- ✅ Get notifications
- ✅ Browse code
- ✅ Manage projects
- ✅ Merge PRs

---

## 🎯 Workflow: From Issue to Production

### 1. Create Issue
```bash
gh issue create --template user_story.md
```

### 2. Start Work
```bash
# Create feature branch
git checkout -b feature/issue-1-vc-agent-testing

# Make changes
# Commit with issue reference
git commit -m "test: Add VC agent test suite (#1)"
```

### 3. Push & Create PR
```bash
git push origin feature/issue-1-vc-agent-testing
gh pr create --title "Test VC Agent" --body "Closes #1"
```

### 4. Deploy
```bash
# After PR merged
./sync-all.sh "feat: Add VC agent testing (#1)"
```

### 5. Close Issue
Issue automatically closes when PR merges (if you used "Closes #1" in PR)

Or manually:
```bash
gh issue close 1 --comment "Deployed to production!"
```

---

## 📊 Tracking Progress

### Sprint View (via Project Board)
1. Go to your project board
2. Drag issues between columns as work progresses
3. See sprint progress at a glance

### Milestone View
```bash
# View issues in Sprint 1
gh issue list --milestone "Sprint 1 - MVP Features"

# View all milestones
gh api repos/Yuvaraj1Aravindan/Startup-VC/milestones
```

### Label View
```bash
# View all high priority issues
gh issue list --label "priority: high"

# View all backend tasks
gh issue list --label "backend"
```

---

## 🔄 Integration with Your Workflow

### When making code changes:

1. **Before starting work:**
   ```bash
   # Check current sprint issues
   gh issue list --milestone "Sprint 1 - MVP Features"
   
   # Pick an issue and view details
   gh issue view 1
   ```

2. **During development:**
   ```bash
   # Create feature branch named after issue
   git checkout -b feature/issue-1-description
   
   # Make commits referencing issue
   git commit -m "feat: Add feature (#1)"
   ```

3. **After completing work:**
   ```bash
   # Sync to GitHub and Azure VM
   ./sync-all.sh "feat: Complete issue #1"
   
   # Close issue
   gh issue close 1 --comment "Completed and deployed!"
   ```

---

## 📈 Best Practices

### 1. Write Good Titles
- ❌ Bad: "Fix bug"
- ✅ Good: "[BUG] Login fails with invalid credentials"

### 2. Use Labels Consistently
- Add type label: `bug`, `feature`, `task`, `story`
- Add component label: `frontend`, `backend`, `database`
- Add priority: `priority: high`, `priority: medium`, `priority: low`

### 3. Keep Issues Small
- 1 issue = 1-3 days of work maximum
- Break large features into multiple issues
- Use epics for tracking related issues

### 4. Update Regularly
- Comment on blockers or questions
- Update progress on project board
- Close issues when truly done

### 5. Link Everything
- Link issues to PRs
- Reference related issues
- Link to documentation

---

## 💰 Cost Savings

### GitHub Issues vs Atlassian Jira

| Feature | GitHub Issues | Jira (Student) |
|---------|---------------|----------------|
| **Cost** | **$0/year** | **$72/year** |
| Issues & tracking | ✅ Unlimited | ✅ Unlimited |
| Projects/boards | ✅ Unlimited | ✅ Unlimited |
| Mobile app | ✅ Free | ✅ Free |
| Git integration | ✅ Native | ⚠️ Plugin |
| Team size | ✅ Unlimited | ✅ Up to 10 |
| Learning curve | ⭐ Easy | ⭐⭐⭐ Hard |

**Your Savings: $72/year**

**Better use of $72:**
- 2 months of Azure VM time
- 7 months of GitHub Copilot ($10/month student)
- Save for when $200 Azure credit expires
- Domain name for 6 years

---

## ✅ Setup Checklist

- [x] GitHub Issues enabled
- [x] Custom labels created (11 labels)
- [x] Milestones created (3 sprints)
- [x] Issue templates in repo (3 templates)
- [x] Todos converted to issues (3 issues)
- [ ] GitHub Project board created (2 minutes - manual step)
- [ ] First issue assigned to you
- [ ] GitHub mobile app installed (optional)

---

## 🎓 Learning Resources

### GitHub Issues & Projects:
- **Official Docs**: https://docs.github.com/en/issues
- **Projects Guide**: https://docs.github.com/en/issues/planning-and-tracking-with-projects
- **Best Practices**: https://docs.github.com/en/issues/tracking-your-work-with-issues/quickstart

### GitHub CLI:
- **Manual**: https://cli.github.com/manual/
- **Issue Commands**: https://cli.github.com/manual/gh_issue

---

## 🎉 Summary

### What You Have Now:
- ✅ **Free story management** with GitHub Issues
- ✅ **3 active issues** from your todos
- ✅ **3 milestones** for sprint planning
- ✅ **20 labels** for categorization
- ✅ **3 issue templates** for consistency
- ✅ **Mobile app** for on-the-go management
- ✅ **$72/year saved** by not using Jira

### Next Steps:
1. **Create Project Board** (2 minutes)
   - Go to: https://github.com/Yuvaraj1Aravindan/Startup-VC/projects
   - Click "New Project" → Choose "Team backlog"
   - Add issues #1, #2, #3

2. **Start Working on Issue #1**
   - Test and demo VC Agent
   - Update issue with progress

3. **Close Issues as You Complete Them**
   - Use `gh issue close 1` or via web UI
   - Add completion comments

4. **Create More Issues as Needed**
   - Use templates: `gh issue create --template user_story.md`
   - Break down large features into smaller tasks

---

**You're all set with GitHub Issues! 🚀**

**Total Setup Time**: 3 minutes  
**Total Cost**: $0/year  
**Total Savings**: $72/year vs Jira
