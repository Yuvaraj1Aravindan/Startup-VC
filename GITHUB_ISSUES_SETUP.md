# 🗂️ GitHub Issues & Projects Setup Guide

**Project**: Startup-VC Platform  
**Story Management**: GitHub Issues + GitHub Projects (FREE)

---

## 📊 Why GitHub Issues?

✅ **$0/month** - Completely free  
✅ **Native integration** - Already using GitHub for code  
✅ **Mobile app** - iOS and Android  
✅ **Automation** - GitHub Actions integration  
✅ **Kanban boards** - Visual project management  
✅ **Markdown support** - Rich formatting  
✅ **@mentions** - Easy team collaboration  

**vs Atlassian Jira**: $6/month ($72/year) - Overkill for teams < 10

---

## 🚀 Quick Setup (5 Minutes)

### Step 1: Enable GitHub Issues (Already Done ✅)
GitHub Issues are enabled by default on your repository.

### Step 2: Create Issue Labels
Go to: https://github.com/Yuvaraj1Aravindan/Startup-VC/labels

**Recommended Labels:**

| Label | Color | Description |
|-------|-------|-------------|
| `bug` | #d73a4a | Something isn't working |
| `feature` | #0e8a16 | New feature or request |
| `enhancement` | #a2eeef | Improvement to existing feature |
| `story` | #1d76db | User story |
| `epic` | #5319e7 | Large body of work (multiple stories) |
| `task` | #fbca04 | Development task |
| `documentation` | #0075ca | Documentation improvements |
| `frontend` | #ff69b4 | Frontend (React) related |
| `backend` | #ffae42 | Backend (FastAPI) related |
| `database` | #8b4513 | Database changes |
| `deployment` | #006b75 | Deployment/DevOps |
| `priority: high` | #b60205 | High priority |
| `priority: medium` | #fbca04 | Medium priority |
| `priority: low` | #0e8a16 | Low priority |
| `good first issue` | #7057ff | Good for newcomers |
| `help wanted` | #008672 | Extra attention needed |

### Step 3: Create Milestones (Sprints)
Go to: https://github.com/Yuvaraj1Aravindan/Startup-VC/milestones

**Example Milestones:**
- Sprint 1 - MVP Features (Due: Nov 15, 2025)
- Sprint 2 - User Feedback Iteration (Due: Dec 1, 2025)
- Sprint 3 - Performance & Scale (Due: Dec 15, 2025)
- v1.0 Release (Due: Jan 1, 2026)

### Step 4: Create GitHub Project Board
Go to: https://github.com/Yuvaraj1Aravindan/Startup-VC/projects

**Click "New Project" → Choose Template:**
- **Team backlog** - For agile development
- **Kanban** - Simple task management
- **Roadmap** - For long-term planning

**Recommended Setup: Team Backlog**

**Columns:**
1. 📋 **Backlog** - All ideas and future work
2. 🔜 **To Do** - Ready for this sprint
3. 🏃 **In Progress** - Currently working on
4. 👀 **In Review** - Code review / testing
5. ✅ **Done** - Completed this sprint

### Step 5: Setup Issue Templates (Already Created ✅)
You now have 3 templates in `.github/ISSUE_TEMPLATE/`:
- `bug_report.md` - For reporting bugs
- `feature_request.md` - For requesting features
- `user_story.md` - For agile user stories

---

## 📝 Creating Your First Story

### Option 1: Via GitHub Web UI
1. Go to: https://github.com/Yuvaraj1Aravindan/Startup-VC/issues/new/choose
2. Select "User Story" template
3. Fill in the details
4. Add labels (e.g., `story`, `feature`, `backend`)
5. Set milestone (e.g., Sprint 1)
6. Assign to yourself or team member
7. Click "Submit new issue"

### Option 2: Via GitHub CLI
```bash
gh issue create \
  --title "[STORY] VC can view matched startups" \
  --body "As a VC, I want to view startups matched to my use case, so that I can evaluate potential investments." \
  --label "story,feature,backend" \
  --milestone "Sprint 1" \
  --assignee @me
```

### Option 3: Convert Existing Todos
Let's migrate your current todos to GitHub Issues!

**Current Todos:**
- [ ] Test and demo VC Agent
- [ ] Share VC app with stakeholders
- [ ] Setup cost controls (auto-shutdown & alerts)

**Convert to Issues:**
```bash
# Issue 1: Test VC Agent
gh issue create \
  --title "[STORY] Test and demo VC Agent with real data" \
  --body "**As a** developer
**I want** to test the VC Agent with real startup pitches
**So that** I can validate the scoring algorithm

**Acceptance Criteria:**
- [ ] Test with 10 real startup pitches
- [ ] Compare scores with human VC evaluations
- [ ] Document any discrepancies
- [ ] Share results with team" \
  --label "story,task,backend" \
  --milestone "Sprint 1"

# Issue 2: Share with stakeholders
gh issue create \
  --title "[TASK] Share VC app with stakeholders" \
  --body "Send stakeholders access to the live application

**Tasks:**
- [ ] Prepare demo credentials
- [ ] Write email using SHARING_TEMPLATE.md
- [ ] Send to stakeholder list
- [ ] Schedule demo meeting
- [ ] Collect feedback

**URLs to share:**
- Live: http://4.213.154.131
- API Docs: http://4.213.154.131/docs
- GitHub: https://github.com/Yuvaraj1Aravindan/Startup-VC" \
  --label "task,documentation" \
  --milestone "Sprint 1"

# Issue 3: Cost controls
gh issue create \
  --title "[TASK] Setup Azure cost controls and auto-shutdown" \
  --body "Configure cost optimization for Azure VM

**Tasks:**
- [ ] Run ./setup-cost-controls.sh
- [ ] Configure auto-shutdown at 6 PM IST
- [ ] Setup billing alerts ($50, $75, $90)
- [ ] Set monthly budget to $100
- [ ] Document cost-saving measures

**Goal:** Maximize $200 Azure for Students credit" \
  --label "task,deployment" \
  --milestone "Sprint 1"
```

---

## 🎯 Workflow: From Story to Production

### 1. Planning Phase
```
📋 Create Issue → Add to Backlog → Assign Story Points → Add to Sprint
```

### 2. Development Phase
```
🏃 Move to "In Progress" → Create Feature Branch → Code → Commit
```

### 3. Review Phase
```
👀 Create Pull Request → Link Issue → Code Review → CI/CD Tests
```

### 4. Deployment Phase
```
✅ Merge to Main → Auto-Deploy to Azure VM → Move to "Done"
```

### 5. Closing Phase
```
🎉 Close Issue → Update Sprint → Document Learnings
```

---

## 🔗 Linking Issues to Code

### In Commit Messages:
```bash
git commit -m "feat: Add startup matching algorithm

Implements the scoring algorithm for VC-startup matching.
Includes tests and documentation.

Fixes #3
Closes #5
Related to #7"
```

**Keywords that auto-close issues:**
- `Fixes #123`
- `Closes #123`
- `Resolves #123`

### In Pull Requests:
```markdown
## Description
Implements the VC-startup matching feature

## Related Issues
- Closes #3
- Addresses #5
- Part of epic #1

## Testing
- [x] Unit tests passing
- [x] Integration tests passing
- [x] Tested on local
- [x] Tested on staging
```

---

## 📊 Using GitHub Projects Board

### Add Issues to Project:
1. Open your project: https://github.com/Yuvaraj1Aravindan/Startup-VC/projects
2. Click "+ Add item"
3. Search for issue or create new
4. Drag to appropriate column

### Automate with GitHub Actions:
```yaml
# .github/workflows/project-automation.yml
name: Project Automation

on:
  issues:
    types: [opened, closed]
  pull_request:
    types: [opened, closed]

jobs:
  automate:
    runs-on: ubuntu-latest
    steps:
      - name: Move new issues to Backlog
        if: github.event.action == 'opened'
        uses: actions/add-to-project@v0.5.0
        with:
          project-url: https://github.com/users/Yuvaraj1Aravindan/projects/1
          github-token: ${{ secrets.GITHUB_TOKEN }}
```

---

## 📱 GitHub Mobile App

**iOS**: https://apps.apple.com/app/github/id1477376905  
**Android**: https://play.google.com/store/apps/details?id=com.github.android

**What you can do:**
- ✅ Create and comment on issues
- ✅ Review pull requests
- ✅ Merge PRs
- ✅ Get notifications
- ✅ Browse code
- ✅ Manage projects

---

## 🤖 Automation Ideas

### 1. Auto-assign issues
```yaml
# .github/workflows/auto-assign.yml
name: Auto Assign
on:
  issues:
    types: [opened]
jobs:
  assign:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/github-script@v6
        with:
          script: |
            github.rest.issues.addAssignees({
              owner: context.repo.owner,
              repo: context.repo.repo,
              issue_number: context.issue.number,
              assignees: [context.actor]
            });
```

### 2. Auto-label based on content
```yaml
# .github/workflows/auto-label.yml
name: Auto Label
on:
  issues:
    types: [opened]
jobs:
  label:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/labeler@v4
```

### 3. Stale issue management
```yaml
# .github/workflows/stale.yml
name: Close Stale Issues
on:
  schedule:
    - cron: '0 0 * * *'
jobs:
  stale:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/stale@v8
        with:
          days-before-stale: 30
          days-before-close: 7
```

---

## 📈 Reporting & Analytics

### View Project Insights:
1. Go to your project
2. Click "..." → "Settings"
3. Enable "Insights"

**Available Metrics:**
- 📊 Velocity (issues closed per sprint)
- 🔥 Burndown chart
- 📈 Cumulative flow diagram
- ⏱️ Cycle time
- 📅 Sprint progress

### Export Data:
```bash
# Export all issues to CSV
gh issue list --limit 1000 --json number,title,state,labels,assignees > issues.json

# Or use GitHub's export feature
# Settings → Export data
```

---

## 💡 Best Practices

### 1. Write Good Issue Titles
❌ Bad: "Fix bug"  
✅ Good: "[BUG] Login fails with invalid credentials"

### 2. Use Templates Consistently
Always use the provided templates (bug_report, feature_request, user_story)

### 3. Link Everything
- Link issues to PRs
- Link related issues
- Link to documentation

### 4. Keep Issues Small
- 1 issue = 1-3 days of work
- Break epics into smaller stories
- Use subtasks for complex issues

### 5. Update Status Regularly
- Move cards on project board as you progress
- Comment on blockers
- Close issues when done

### 6. Use Labels Effectively
- Multiple labels per issue are OK
- Use priority labels
- Use component labels (frontend, backend, etc.)

### 7. Document Decisions
- Add comments to issues with important decisions
- Link to relevant documentation
- Explain "why" not just "what"

---

## 🔄 Integration with Sync Workflow

### After making code changes:
```bash
# 1. Create issue for the feature
gh issue create --title "[FEATURE] Add export functionality"

# 2. Create branch referencing issue
git checkout -b feature/export-functionality-#15

# 3. Make changes and commit
git commit -m "feat: Add CSV export

Implements export functionality for startup data.

Implements #15"

# 4. Push and create PR
git push origin feature/export-functionality-#15
gh pr create --title "Add export functionality" --body "Closes #15"

# 5. After merge, sync to production
./sync-all.sh "feat: Add export functionality (#15)"
```

---

## 🎓 Learning Resources

### GitHub Issues & Projects:
- **GitHub Docs**: https://docs.github.com/en/issues
- **Projects Guide**: https://docs.github.com/en/issues/planning-and-tracking-with-projects
- **Automation**: https://docs.github.com/en/issues/planning-and-tracking-with-projects/automating-your-project

### Agile & Scrum:
- **User Stories**: https://www.mountaingoatsoftware.com/agile/user-stories
- **Story Points**: https://www.atlassian.com/agile/project-management/estimation
- **Sprint Planning**: https://www.scrum.org/resources/what-is-sprint-planning

---

## ✅ Setup Checklist

- [x] GitHub Issues enabled (default)
- [x] Issue templates created (bug, feature, story)
- [ ] Labels created (bug, feature, story, etc.)
- [ ] Milestones created (Sprint 1, Sprint 2, etc.)
- [ ] GitHub Project board created
- [ ] Project columns configured (Backlog, To Do, In Progress, Review, Done)
- [ ] First issue created
- [ ] Issue linked to project board
- [ ] GitHub mobile app installed
- [ ] Sync workflow documented
- [ ] Team members added (if applicable)

---

## 🎯 Next Steps

### Today:
1. **Create labels**: Go to repo → Issues → Labels
2. **Create milestone**: Sprint 1 (due in 2 weeks)
3. **Create project board**: Use "Team backlog" template
4. **Convert todos to issues**: Use the examples above
5. **Test the workflow**: Create issue → Make changes → Sync

### This Week:
1. Add your team members to the repo
2. Show them TEAM_ACCESS.md
3. Have them create their first issue
4. Start using the project board daily
5. Set up GitHub Actions automation

### This Month:
1. Complete Sprint 1
2. Review velocity and metrics
3. Adjust process as needed
4. Share learnings with team
5. Document best practices

---

**You now have a FREE, professional story management system!** 🎉

**Saved**: $72/year by not using Jira  
**Gained**: Native GitHub integration, automation, and simplicity
