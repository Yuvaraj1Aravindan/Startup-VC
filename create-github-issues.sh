#!/bin/bash

# Create GitHub Issues from User Stories
# Repository: Yuvaraj1Aravindan/Startup-VC

set -e

REPO="Yuvaraj1Aravindan/Startup-VC"

echo "╔══════════════════════════════════════════════════════════╗"
echo "║     Creating GitHub Issues from User Stories            ║"
echo "╚══════════════════════════════════════════════════════════╝"
echo ""

# First, create additional milestones for the new epics
echo "📅 Creating Milestones..."

# Sprint 3 - Core Features
gh api repos/$REPO/milestones -X POST -f title="Sprint 3 - Core Features" \
  -f description="Enhanced platform features: user profiles, idea management, rich editing" \
  -f due_on="2025-12-15T08:00:00Z" || echo "Milestone may already exist"

# Sprint 4 - AI & Analytics
gh api repos/$REPO/milestones -X POST -f title="Sprint 4 - AI & Analytics" \
  -f description="AI integration, analytics dashboards, and reporting features" \
  -f due_on="2026-01-15T08:00:00Z" || echo "Milestone may already exist"

# Sprint 5 - Advanced Features
gh api repos/$REPO/milestones -X POST -f title="Sprint 5 - Advanced Features" \
  -f description="Search, collaboration, security, and performance enhancements" \
  -f due_on="2026-02-15T08:00:00Z" || echo "Milestone may already exist"

echo ""
echo "✓ Milestones created/verified"
echo ""
echo "🏷️  Creating High Priority Issues for Sprint 2..."
echo ""

# ============================================================
# HIGH PRIORITY ISSUES - Sprint 2 (Top 10)
# ============================================================

# Issue: One-Click AI Analysis Button
gh issue create \
  --title "[FEATURE] One-Click AI Analysis Button" \
  --body "**Epic**: VC Investment Agent Integration

**As a** user (VC or Startup)  
**I want** to get instant AI analysis of an idea with one click  
**So that** I can quickly understand its potential

## Acceptance Criteria:
- [ ] \"AI Analyze\" button on idea detail page
- [ ] Loading state with progress indicator
- [ ] Display AI analysis in modal or side panel
- [ ] Option to save analysis to idea notes
- [ ] Retry on failure

## Technical Notes:
- Integrate agent API: POST http://4.213.154.131:8001/api/quick-score
- Add GET /api/ideas/{id}/ai-analysis endpoint in backend
- Frontend AI analysis component

## Effort:
5 story points

## Dependencies:
- VC Agent API running (✅ already deployed)
- Issue #1 (VC Agent testing) should be completed first

## Resources:
- Agent API: http://4.213.154.131:8001/docs
- Current Agent endpoints already available" \
  --label "feature,backend,frontend,ai,priority: high" \
  --milestone "Sprint 1 - MVP Features"

echo "✓ Created: One-Click AI Analysis Button"

# Issue: Real-Time Scoring Preview
gh issue create \
  --title "[FEATURE] Real-Time Scoring Preview" \
  --body "**Epic**: Evaluation & Scoring

**As a** startup aspirant  
**I want** to see a live score preview as I type my idea  
**So that** I can optimize my pitch in real-time

## Acceptance Criteria:
- [ ] Debounced API calls during typing (500ms delay)
- [ ] Live score indicator (0-100)
- [ ] Dimension breakdown (alignment, novelty, viability)
- [ ] Suggestions for improvement
- [ ] Progress indicators for each section

## Technical Notes:
- Add POST /api/evaluate/preview endpoint (lightweight, fast)
- Frontend debouncing with React hooks
- Cache preview results in Redis (5 min TTL)
- Optimize scoring engine for speed

## Effort:
5 story points

## UI Mockup:
\`\`\`
┌─────────────────────────────────┐
│ [===== 67/100 =====] Good! 💡  │
├─────────────────────────────────┤
│ Alignment:  ████████░░ 80%      │
│ Novelty:    ██████░░░░ 60%      │
│ Viability:  ███████░░░ 72%      │
└─────────────────────────────────┘
\`\`\`" \
  --label "feature,backend,frontend,priority: high" \
  --milestone "Sprint 1 - MVP Features"

echo "✓ Created: Real-Time Scoring Preview"

# Issue: Detailed Scoring Explanation with Highlights
gh issue create \
  --title "[FEATURE] Detailed Scoring Explanation with Highlights" \
  --body "**Epic**: Evaluation & Scoring

**As a** startup aspirant  
**I want** to see which parts of my pitch matched VC criteria  
**So that** I understand why I got a particular score

## Acceptance Criteria:
- [ ] Text highlighting in idea review page
- [ ] Color-coded matches (green=strong, yellow=weak, red=missing)
- [ ] Tooltip explanations on hover
- [ ] Side-by-side comparison (idea vs use case)
- [ ] Download detailed report as PDF

## Technical Notes:
- Enhance matched_evidence field in Evaluation model
- Frontend text annotation component (react-highlight-words or custom)
- PDF generation with ReportLab or WeasyPrint
- Add evidence scoring to NLPScoringEngine

## Effort:
8 story points

## Example:
Your pitch mentions **\"AI-powered automation\"** which strongly aligns with VC use case focusing on \"artificial intelligence in enterprise workflows\" (95% match)" \
  --label "feature,backend,frontend,priority: high" \
  --milestone "Sprint 1 - MVP Features"

echo "✓ Created: Detailed Scoring Explanation"

# Issue: In-App Notifications
gh issue create \
  --title "[FEATURE] In-App Notifications System" \
  --body "**Epic**: Notifications & Communication

**As a** user  
**I want** to receive notifications for important events  
**So that** I stay updated on activity

## Acceptance Criteria:
- [ ] Notification bell icon with unread count in header
- [ ] Notifications for: evaluation complete, new comment, VC interest
- [ ] Mark as read/unread functionality
- [ ] Notification preferences page (enable/disable by type)
- [ ] Real-time updates using WebSocket or SSE

## Technical Notes:
- Create Notification model (user_id, type, title, message, read, created_at)
- Add POST /api/notifications/send endpoint
- WebSocket connection for real-time delivery (optional for v1)
- Frontend notification center component
- Polling fallback if WebSocket not available

## Effort:
8 story points

## Database Schema:
\`\`\`sql
CREATE TABLE notifications (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id),
    type VARCHAR(50),
    title VARCHAR(200),
    message TEXT,
    link VARCHAR(500),
    read BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT NOW()
);
\`\`\`" \
  --label "feature,backend,frontend,priority: high" \
  --milestone "Sprint 3 - Core Features"

echo "✓ Created: In-App Notifications"

# Issue: Idea Attachments
gh issue create \
  --title "[FEATURE] Idea Attachments (Pitch Deck Upload)" \
  --body "**Epic**: Idea Submission & Management

**As a** startup aspirant  
**I want** to attach documents (PDF, PPTX) to my idea  
**So that** VCs can review detailed materials

## Acceptance Criteria:
- [ ] Upload pitch decks, business plans (max 10MB per file, 5 files max)
- [ ] Support for PDF, PPTX, DOCX formats
- [ ] File preview in browser (PDF.js for PDFs)
- [ ] Download attachments
- [ ] Delete attachments (owner only)
- [ ] Virus scanning for uploads (optional for v1)

## Technical Notes:
- Add file storage (Azure Blob Storage recommended)
- Create IdeaAttachment model (idea_id, file_name, file_url, file_size, mime_type)
- Implement file upload/download endpoints
- Frontend file upload component with drag-and-drop
- File size and type validation

## Effort:
8 story points

## Security:
- Validate file types on backend
- Generate signed URLs for downloads (time-limited)
- Scan for malware (Azure Defender or ClamAV)

## Azure Blob Storage Setup:
\`\`\`bash
# Create storage account
az storage account create --name startupvcfiles --resource-group vc-app-rg

# Create container
az storage container create --name attachments --account-name startupvcfiles
\`\`\`" \
  --label "feature,backend,frontend,priority: high" \
  --milestone "Sprint 3 - Core Features"

echo "✓ Created: Idea Attachments"

# Issue: Advanced Search
gh issue create \
  --title "[FEATURE] Advanced Search with Filters" \
  --body "**Epic**: Search & Discovery

**As a** user  
**I want** to search ideas and use cases with advanced filters  
**So that** I can find exactly what I'm looking for

## Acceptance Criteria:
- [ ] Full-text search across title, description, tags
- [ ] Filters: industry, score range (0-100), date range, tags
- [ ] Sort by: relevance, score, date, popularity
- [ ] Save search queries for later
- [ ] Search suggestions and autocomplete

## Technical Notes:
- Implement PostgreSQL full-text search (ts_vector) or Elasticsearch
- Add GET /api/search endpoint with query params
- Frontend advanced search UI with filter chips
- Search result highlighting
- Pagination for large result sets

## Effort:
8 story points

## PostgreSQL FTS Example:
\`\`\`sql
ALTER TABLE ideas ADD COLUMN search_vector tsvector;
CREATE INDEX ideas_search_idx ON ideas USING GIN(search_vector);

-- Update trigger
CREATE TRIGGER ideas_search_update BEFORE INSERT OR UPDATE ON ideas
FOR EACH ROW EXECUTE FUNCTION 
tsvector_update_trigger(search_vector, 'pg_catalog.english', title, short_pitch, problem_statement);
\`\`\`" \
  --label "feature,backend,frontend,priority: high" \
  --milestone "Sprint 5 - Advanced Features"

echo "✓ Created: Advanced Search"

# Issue: Database Optimization
gh issue create \
  --title "[TASK] Database Query Optimization" \
  --body "**Epic**: Performance & Scalability

**As a** system admin  
**I want** optimized database queries  
**So that** the application remains fast as data grows

## Acceptance Criteria:
- [ ] Add indexes on frequently queried fields
- [ ] Optimize N+1 query problems in evaluations
- [ ] Implement database connection pooling (already done with SQLAlchemy)
- [ ] Add query performance monitoring
- [ ] Document slow query optimizations

## Technical Notes:
- Analyze queries with EXPLAIN ANALYZE
- Add indexes on foreign keys: ideas.aspirant_user_id, evaluations.idea_id, etc.
- Add indexes on search fields: ideas.title, ideas.target_industry
- Use SQLAlchemy relationship eager loading (joinedload, selectinload)
- Add database query logging in development

## Effort:
5 story points

## Key Indexes to Add:
\`\`\`sql
-- Foreign keys (if not already indexed)
CREATE INDEX idx_ideas_user ON ideas(aspirant_user_id);
CREATE INDEX idx_evaluations_idea ON evaluations(idea_id);
CREATE INDEX idx_evaluations_usecase ON evaluations(usecase_id);

-- Search and filtering
CREATE INDEX idx_ideas_industry ON ideas(target_industry);
CREATE INDEX idx_ideas_created ON ideas(created_at DESC);
CREATE INDEX idx_usecases_industry ON vc_usecases(industry);

-- Composite indexes for common queries
CREATE INDEX idx_evaluations_idea_score ON evaluations(idea_id, overall_score DESC);
\`\`\`

## Performance Testing:
- Benchmark queries before/after optimization
- Target: < 100ms for list queries, < 50ms for detail queries" \
  --label "task,backend,database,priority: high" \
  --milestone "Sprint 5 - Advanced Features"

echo "✓ Created: Database Optimization"

# Issue: Role-Based Dashboards
gh issue create \
  --title "[FEATURE] Role-Based Dashboard Customization" \
  --body "**Epic**: Core Platform Features

**As a** user with a specific role (VC/Startup/Admin)  
**I want** to see a customized dashboard relevant to my role  
**So that** I can quickly access features I need most

## Acceptance Criteria:
- [ ] VC dashboard shows: recent submissions, top-rated ideas, analytics chart
- [ ] Startup dashboard shows: my ideas, evaluation results, improvement recommendations
- [ ] Admin dashboard shows: system metrics, user activity, moderation queue
- [ ] Widgets are role-specific and configurable
- [ ] Responsive design for mobile

## Technical Notes:
- Create role-specific dashboard components (VCDashboard.jsx, StartupDashboard.jsx, AdminDashboard.jsx)
- Add GET /api/dashboard/{role} endpoint returning dashboard data
- Implement dashboard widget system
- Add dashboard preferences (show/hide widgets)

## Effort:
5 story points

## VC Dashboard Widgets:
- Recent idea submissions (last 7 days)
- Top 10 ideas by score
- Evaluation activity chart (line graph)
- My use cases summary

## Startup Dashboard Widgets:
- My ideas with scores
- Latest evaluation results
- Recommended actions
- Progress over time (chart)

## Admin Dashboard Widgets:
- Total users by role (pie chart)
- API usage metrics
- Evaluation activity
- System health indicators" \
  --label "feature,frontend,backend,priority: high" \
  --milestone "Sprint 3 - Core Features"

echo "✓ Created: Role-Based Dashboards"

# Issue: Batch Evaluation
gh issue create \
  --title "[FEATURE] Batch Evaluation with Ranking" \
  --body "**Epic**: Evaluation & Scoring

**As a** VC representative  
**I want** to evaluate multiple ideas at once and see them ranked  
**So that** I can prioritize which ones to review first

## Acceptance Criteria:
- [ ] Multi-select checkbox for ideas in list view
- [ ] \"Evaluate Selected\" button (up to 20 ideas at once)
- [ ] Progress indicator during batch processing (X/N completed)
- [ ] Results shown in ranked table (sortable)
- [ ] Export results to CSV/Excel
- [ ] Filter and sort results by score, industry, date

## Technical Notes:
- Optimize /api/evaluate/bulk endpoint for async processing
- Add job queue (Celery + Redis) for background processing
- Add GET /api/jobs/{job_id}/status endpoint for progress polling
- Frontend data table with sorting/filtering (react-table)
- CSV export functionality

## Effort:
8 story points

## Async Processing Flow:
\`\`\`
1. User selects ideas → POST /api/evaluate/bulk
2. Backend creates job → returns job_id
3. Frontend polls GET /api/jobs/{job_id}/status every 2 seconds
4. Job completes → display results
5. User exports to CSV
\`\`\`

## Celery Setup:
\`\`\`bash
# Install
pip install celery redis

# Start worker
celery -A app.tasks worker --loglevel=info
\`\`\`" \
  --label "feature,backend,frontend,priority: high" \
  --milestone "Sprint 3 - Core Features"

echo "✓ Created: Batch Evaluation"

# Issue: API Rate Limiting
gh issue create \
  --title "[FEATURE] API Rate Limiting" \
  --body "**Epic**: Security & Compliance

**As a** system admin  
**I want** to implement API rate limiting  
**So that** the system is protected from abuse

## Acceptance Criteria:
- [ ] Rate limit per user: 100 requests/minute (authenticated)
- [ ] Rate limit per IP: 20 requests/minute (anonymous)
- [ ] Different limits for different endpoint categories
- [ ] Rate limit headers in response (X-RateLimit-Limit, X-RateLimit-Remaining)
- [ ] 429 Too Many Requests error with Retry-After header
- [ ] Admin users bypass rate limits

## Technical Notes:
- Use slowapi or fastapi-limiter library
- Redis for rate limit tracking
- Add rate limit middleware to FastAPI
- Configure per-endpoint rate limits

## Effort:
3 story points

## Implementation:
\`\`\`python
from slowapi import Limiter, _rate_limit_exceeded_handler
from slowapi.util import get_remote_address
from slowapi.errors import RateLimitExceeded

limiter = Limiter(key_func=get_remote_address)
app.state.limiter = limiter
app.add_exception_handler(RateLimitExceeded, _rate_limit_exceeded_handler)

@app.get('/api/ideas')
@limiter.limit('100/minute')
async def get_ideas():
    ...
\`\`\`

## Rate Limits by Endpoint Type:
- Authentication: 5/minute
- Read operations: 100/minute
- Write operations: 20/minute
- AI operations: 10/minute
- Admin operations: unlimited" \
  --label "feature,security,backend,priority: high" \
  --milestone "Sprint 5 - Advanced Features"

echo "✓ Created: API Rate Limiting"

echo ""
echo "════════════════════════════════════════════════════════════"
echo "✓ Created 10 High-Priority Issues for Sprint 2"
echo "════════════════════════════════════════════════════════════"
echo ""
echo "🔗 View all issues:"
echo "   https://github.com/$REPO/issues"
echo ""
echo "📊 Next Steps:"
echo "   1. Review issues and adjust priorities if needed"
echo "   2. Create project board and add issues"
echo "   3. Start working on highest priority issues"
echo "   4. Run this script again to add more stories as needed"
echo ""
echo "💡 To create more issues from the COMPREHENSIVE_USER_STORIES.md:"
echo "   - Edit this script to add more gh issue create commands"
echo "   - Or create issues manually via GitHub web UI"
echo "   - Or use GitHub CLI: gh issue create --web"
echo ""
