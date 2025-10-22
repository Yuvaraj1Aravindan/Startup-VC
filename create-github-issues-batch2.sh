#!/bin/bash

# Create Remaining GitHub Issues (Batch 2)
# Repository: Yuvaraj1Aravindan/Startup-VC

set -e

REPO="Yuvaraj1Aravindan/Startup-VC"

echo "╔══════════════════════════════════════════════════════════╗"
echo "║   Creating Remaining GitHub Issues - Batch 2 (28 more)  ║"
echo "╚══════════════════════════════════════════════════════════╝"
echo ""

# ============================================================
# MEDIUM PRIORITY ISSUES - Core Platform Features
# ============================================================

echo "🟡 Creating Medium Priority Issues..."
echo ""

# Story 1.1: Enhanced User Profile Management
gh issue create \
  --title "[FEATURE] Enhanced User Profile Management" \
  --body "**Epic**: Core Platform Features

**As a** registered user  
**I want** to update my profile information (name, organization, avatar)  
**So that** my profile reflects current information

## Acceptance Criteria:
- [ ] Profile edit page with form validation
- [ ] Avatar upload functionality (max 2MB, jpg/png)
- [ ] Organization details for VC users
- [ ] Email verification for changes
- [ ] Update password feature with strength validation

## Technical Notes:
- Extend User model: \`avatar_url\`, \`organization\`, \`bio\`, \`website\`
- Add PUT /api/users/me endpoint
- Frontend profile page component
- Image upload to Azure Blob Storage
- Password validation: min 8 chars, uppercase, lowercase, number, special char

## Effort:
3 story points

## Database Migration:
\`\`\`sql
ALTER TABLE users ADD COLUMN avatar_url VARCHAR(500);
ALTER TABLE users ADD COLUMN organization VARCHAR(200);
ALTER TABLE users ADD COLUMN bio TEXT;
ALTER TABLE users ADD COLUMN website VARCHAR(200);
\`\`\`" \
  --label "feature,frontend,backend,priority: medium" \
  --milestone "Sprint 3 - Core Features"

echo "✓ Created: Enhanced User Profile Management"

# Story 1.3: Two-Factor Authentication
gh issue create \
  --title "[FEATURE] Two-Factor Authentication (2FA)" \
  --body "**Epic**: Security & Compliance

**As a** security-conscious user  
**I want** to enable two-factor authentication  
**So that** my account is more secure

## Acceptance Criteria:
- [ ] TOTP-based 2FA implementation
- [ ] QR code generation for authenticator apps (Google Authenticator, Authy)
- [ ] Generate 10 backup codes
- [ ] 2FA requirement toggle for admins
- [ ] Recovery mechanism with backup codes
- [ ] Disable 2FA option

## Technical Notes:
- Add pyotp library for TOTP
- Extend User model: \`totp_secret\`, \`totp_enabled\`, \`backup_codes\` (encrypted)
- Add 2FA verification step to login flow
- Frontend: QR code display, backup codes download
- Store backup codes encrypted (Fernet)

## Effort:
5 story points

## Security Implementation:
\`\`\`python
import pyotp
from cryptography.fernet import Fernet

# Generate TOTP secret
totp_secret = pyotp.random_base32()
totp = pyotp.TOTP(totp_secret)

# Verify code
totp.verify(user_input_code)
\`\`\`" \
  --label "feature,security,backend,frontend,priority: medium" \
  --milestone "Sprint 5 - Advanced Features"

echo "✓ Created: Two-Factor Authentication"

# Story 2.1: Rich Text Editor
gh issue create \
  --title "[FEATURE] Rich Text Editor for Idea Submission" \
  --body "**Epic**: Idea Submission & Management

**As a** startup aspirant  
**I want** to use a rich text editor when submitting my idea  
**So that** I can format my pitch with headings, bullets, and links

## Acceptance Criteria:
- [ ] Replace textarea with rich text editor (TipTap or Quill)
- [ ] Support: bold, italic, headings (h1-h3), lists, links, code blocks
- [ ] Character count and validation (min 100, max 5000 chars)
- [ ] Auto-save drafts every 30 seconds
- [ ] Preview mode (read-only view)
- [ ] Mobile responsive

## Technical Notes:
- Integrate TipTap (recommended) or React-Quill
- Store HTML in database (sanitize on backend with bleach)
- Add \`draft_data\` JSON field to Idea model
- Add \`last_autosave\` timestamp
- Frontend: debounced autosave, loading indicator

## Effort:
3 story points

## Libraries:
- Frontend: @tiptap/react, @tiptap/starter-kit
- Backend: bleach (HTML sanitization)" \
  --label "feature,frontend,priority: medium" \
  --milestone "Sprint 3 - Core Features"

echo "✓ Created: Rich Text Editor"

# Story 2.3: Idea Versioning
gh issue create \
  --title "[FEATURE] Idea Versioning & History" \
  --body "**Epic**: Idea Submission & Management

**As a** startup aspirant  
**I want** to track changes to my idea over time  
**So that** I can see how it evolved and revert if needed

## Acceptance Criteria:
- [ ] Automatic version saving on each update
- [ ] View version history with timestamps
- [ ] Restore previous version
- [ ] Add version notes/comments
- [ ] Compare two versions side-by-side (diff view)
- [ ] Limit to last 20 versions per idea

## Technical Notes:
- Create IdeaVersion model (idea_id, version_number, content_snapshot, created_at, notes)
- Implement versioning middleware (save before update)
- Frontend version history component
- Diff view using react-diff-viewer
- Add GET /api/ideas/{id}/versions endpoint

## Effort:
5 story points

## Database Schema:
\`\`\`sql
CREATE TABLE idea_versions (
    id SERIAL PRIMARY KEY,
    idea_id INTEGER REFERENCES ideas(id),
    version_number INTEGER,
    content_snapshot JSONB,
    notes TEXT,
    created_at TIMESTAMP DEFAULT NOW()
);
\`\`\`" \
  --label "feature,backend,frontend,priority: medium" \
  --milestone "Sprint 3 - Core Features"

echo "✓ Created: Idea Versioning"

# Story 2.4: Collaborative Editing
gh issue create \
  --title "[FEATURE] Collaborative Idea Editing" \
  --body "**Epic**: Collaboration & Social Features

**As a** startup team member  
**I want** to invite co-founders to collaborate on our idea  
**So that** we can work together on the pitch

## Acceptance Criteria:
- [ ] Invite collaborators via email
- [ ] Role-based permissions (owner, editor, viewer)
- [ ] Comment and suggestion mode
- [ ] Activity log for changes
- [ ] Remove collaborators (owner only)
- [ ] Email notifications for invitations

## Technical Notes:
- Create IdeaCollaborator model (idea_id, user_id, role, invited_by, invited_at)
- Add sharing endpoints: POST /api/ideas/{id}/collaborators
- Implement permission checks in idea endpoints
- Frontend: share modal, collaborator list
- Email invitations with accept/decline links

## Effort:
8 story points

## Roles:
- **Owner**: Full control, can delete, manage collaborators
- **Editor**: Can edit, add comments
- **Viewer**: Read-only access" \
  --label "feature,backend,frontend,priority: medium" \
  --milestone "Sprint 4 - AI & Analytics"

echo "✓ Created: Collaborative Editing"

# Story 3.1: Use Case Categories
gh issue create \
  --title "[FEATURE] Use Case Taxonomy & Categories" \
  --body "**Epic**: VC Use Case Management

**As a** VC representative  
**I want** to organize my use cases by category and sub-category  
**So that** I can manage them more efficiently

## Acceptance Criteria:
- [ ] Define use case categories: Industry, Stage, Geography, Focus Area
- [ ] Multi-level taxonomy support (parent-child categories)
- [ ] Bulk assign categories to existing use cases
- [ ] Filter and search by category
- [ ] Category analytics (ideas per category, avg scores)

## Technical Notes:
- Create UseCaseCategory model (name, parent_id, description, color)
- Add \`category_id\` to VCUseCase model
- Add GET /api/categories endpoint
- Frontend: category tree view, category filter chips
- Pre-populate with common categories

## Effort:
5 story points

## Common Categories:
- Industry: SaaS, FinTech, HealthTech, EdTech, E-commerce
- Stage: Pre-seed, Seed, Series A, Series B+
- Geography: North America, Europe, Asia, Global
- Focus: B2B, B2C, AI/ML, Blockchain, IoT" \
  --label "feature,backend,frontend,priority: medium" \
  --milestone "Sprint 4 - AI & Analytics"

echo "✓ Created: Use Case Categories"

# Story 4.3: Comparative Evaluation
gh issue create \
  --title "[FEATURE] Comparative Evaluation (Benchmark Mode)" \
  --body "**Epic**: Evaluation & Scoring

**As a** startup aspirant  
**I want** to see how my idea scores compared to similar ideas  
**So that** I can gauge my competitiveness

## Acceptance Criteria:
- [ ] Percentile ranking among all ideas
- [ ] Industry-specific benchmarks
- [ ] Anonymous comparison (privacy-preserved)
- [ ] Historical trend (how scores change over time)
- [ ] Opt-in leaderboard for top ideas

## Technical Notes:
- Add GET /api/ideas/{id}/benchmark endpoint
- Calculate percentiles using SQL window functions
- Frontend comparison charts (Chart.js or Recharts)
- Add \`is_public\` flag to Idea model for leaderboard opt-in
- Cache benchmark data (updated daily)

## Effort:
5 story points

## SQL Example:
\`\`\`sql
SELECT 
    PERCENT_RANK() OVER (ORDER BY score) as percentile,
    AVG(score) OVER (PARTITION BY target_industry) as industry_avg
FROM evaluations;
\`\`\`" \
  --label "feature,backend,frontend,priority: medium" \
  --milestone "Sprint 4 - AI & Analytics"

echo "✓ Created: Comparative Evaluation"

# Story 5.2: AI VC Matching
gh issue create \
  --title "[FEATURE] AI-Powered VC-Startup Matching" \
  --body "**Epic**: VC Investment Agent Integration

**As a** startup aspirant  
**I want** the AI to recommend which VCs are best fit for my idea  
**So that** I can target the right investors

## Acceptance Criteria:
- [ ] Match score for each VC use case (0-100)
- [ ] Top 5 recommended VCs shown with reasoning
- [ ] Explanation for each match
- [ ] Contact information (if available)
- [ ] Warm intro request feature (future)

## Technical Notes:
- Use agent API: POST http://4.213.154.131:8001/api/match
- Add GET /api/ideas/{id}/recommended-vcs endpoint
- Frontend match results component with cards
- Display match reasoning and key alignment points
- Cache recommendations (24 hours)

## Effort:
8 story points

## Agent API Integration:
\`\`\`python
import requests

response = requests.post(
    'http://4.213.154.131:8001/api/match',
    json={
        'startup_description': idea.short_pitch,
        'industry': idea.target_industry
    }
)
matches = response.json()['matches']
\`\`\`" \
  --label "feature,backend,ai,frontend,priority: medium" \
  --milestone "Sprint 4 - AI & Analytics"

echo "✓ Created: AI VC Matching"

# Story 5.3: Investment Memo Generation
gh issue create \
  --title "[FEATURE] Investment Memo Generation" \
  --body "**Epic**: VC Investment Agent Integration

**As a** VC representative  
**I want** the AI to generate an investment memo for promising ideas  
**So that** I can quickly share with my team

## Acceptance Criteria:
- [ ] Generate professional investment memo (2-3 pages)
- [ ] Sections: Executive Summary, Problem/Solution, Market, Team, Risks, Recommendation
- [ ] Export as PDF and DOCX
- [ ] Editable before finalizing
- [ ] Customizable template
- [ ] Attach to idea for future reference

## Technical Notes:
- Use agent API: POST http://4.213.154.131:8001/api/memo
- Add GET /api/ideas/{id}/investment-memo endpoint
- PDF generation with ReportLab or WeasyPrint
- DOCX generation with python-docx
- Store generated memos in database

## Effort:
8 story points

## Memo Template Sections:
1. Executive Summary (150 words)
2. Problem & Solution (300 words)
3. Market Opportunity (250 words)
4. Competitive Landscape (200 words)
5. Team Assessment (150 words)
6. Key Risks (200 words)
7. Investment Recommendation (100 words)" \
  --label "feature,backend,ai,priority: medium" \
  --milestone "Sprint 4 - AI & Analytics"

echo "✓ Created: Investment Memo Generation"

# Story 6.1: Personal Analytics
gh issue create \
  --title "[FEATURE] Personal Analytics Dashboard" \
  --body "**Epic**: Analytics & Reporting

**As a** startup aspirant  
**I want** to see analytics on my submitted ideas  
**So that** I can track my progress and learn

## Acceptance Criteria:
- [ ] Number of ideas submitted over time (line chart)
- [ ] Average scores and trends
- [ ] Most common feedback themes (word cloud)
- [ ] Time spent on platform
- [ ] Ideas performance leaderboard (opt-in)
- [ ] Export analytics as PDF report

## Technical Notes:
- Create Analytics model for tracking
- Add GET /api/analytics/personal endpoint
- Frontend charts using Chart.js or Recharts
- Track page views and time spent (frontend analytics)
- Generate insights using AI (optional)

## Effort:
5 story points

## Analytics Metrics:
- Total ideas submitted
- Average overall score
- Best performing idea
- Score improvement over time
- Most matched VC use cases" \
  --label "feature,backend,frontend,priority: medium" \
  --milestone "Sprint 4 - AI & Analytics"

echo "✓ Created: Personal Analytics"

# Story 6.2: VC Portfolio Analytics
gh issue create \
  --title "[FEATURE] VC Portfolio Analytics" \
  --body "**Epic**: Analytics & Reporting

**As a** VC representative  
**I want** to see analytics on ideas evaluated against my use cases  
**So that** I can identify trends and opportunities

## Acceptance Criteria:
- [ ] Total ideas evaluated over time
- [ ] Average scores by industry/category
- [ ] Top-performing ideas list (sortable)
- [ ] Conversion funnel (views → evaluations → contacts)
- [ ] Export analytics to CSV
- [ ] Custom date range filtering

## Technical Notes:
- Add GET /api/analytics/vc endpoint
- Aggregate queries on Evaluation table
- Frontend analytics dashboard with filters
- Charts: line (trend), bar (by industry), pie (score distribution)
- Cache analytics data (refresh hourly)

## Effort:
5 story points

## KPIs for VCs:
- Ideas evaluated per week
- Average evaluation score
- Top 3 industries by volume
- Ideas above threshold (e.g., score > 80)
- Response rate to startups" \
  --label "feature,backend,frontend,priority: medium" \
  --milestone "Sprint 4 - AI & Analytics"

echo "✓ Created: VC Portfolio Analytics"

# Story 6.3: System Admin Dashboard
gh issue create \
  --title "[FEATURE] System Admin Dashboard" \
  --body "**Epic**: Analytics & Reporting

**As a** system admin  
**I want** to monitor platform health and usage  
**So that** I can ensure optimal performance

## Acceptance Criteria:
- [ ] User registration and activity metrics
- [ ] API response times and error rates
- [ ] Database performance metrics (query times, connections)
- [ ] AI agent usage statistics
- [ ] Cost analysis (AI API calls, storage, compute)
- [ ] Real-time alerts for issues

## Technical Notes:
- Integrate with Azure Application Insights
- Add GET /api/admin/metrics endpoint
- Frontend admin dashboard with real-time updates
- WebSocket for live metrics (optional)
- Alert thresholds configuration

## Effort:
8 story points

## Metrics to Track:
- Total users by role
- Active users (DAU, MAU)
- API calls per endpoint
- Average response time
- Error rate (4xx, 5xx)
- Database query performance
- AI agent requests
- Storage usage
- Monthly costs" \
  --label "feature,backend,frontend,deployment,priority: medium" \
  --milestone "Sprint 5 - Advanced Features"

echo "✓ Created: System Admin Dashboard"

# Story 7.2: Email Notifications
gh issue create \
  --title "[FEATURE] Email Notifications & Digests" \
  --body "**Epic**: Notifications & Communication

**As a** user  
**I want** to receive email notifications for key events  
**So that** I don't miss important updates

## Acceptance Criteria:
- [ ] Transactional emails: signup, password reset, evaluation complete
- [ ] Daily/weekly digest options
- [ ] Email preferences page (choose notification types)
- [ ] Unsubscribe links in all emails
- [ ] HTML and plain text versions
- [ ] Email templates with branding

## Technical Notes:
- Integrate email service: SendGrid, AWS SES, or Azure Communication Services
- Create email templates using Jinja2
- Add background job queue (Celery) for async sending
- Add GET/PUT /api/users/me/email-preferences endpoint
- Track email delivery and opens (optional)

## Effort:
8 story points

## Email Types:
- Welcome email (on signup)
- Evaluation complete (with score)
- VC interest notification
- Weekly summary (ideas submitted, scores)
- System announcements" \
  --label "feature,backend,priority: medium" \
  --milestone "Sprint 5 - Advanced Features"

echo "✓ Created: Email Notifications"

# Story 8.2: Semantic Search
gh issue create \
  --title "[FEATURE] Semantic Search (AI-Powered)" \
  --body "**Epic**: Search & Discovery

**As a** user  
**I want** to search using natural language descriptions  
**So that** I can find similar ideas without exact keyword matches

## Acceptance Criteria:
- [ ] Natural language search queries
- [ ] Semantic similarity matching
- [ ] Related ideas suggestions (\"Find similar\" button)
- [ ] Explain why results were matched
- [ ] Filter by similarity threshold (e.g., >70%)

## Technical Notes:
- Use existing embedding_model in NLPScoringEngine
- Store embeddings in database (pgvector extension)
- Add POST /api/search/semantic endpoint
- Frontend: natural language search box
- Cosine similarity for matching

## Effort:
8 story points

## PostgreSQL pgvector Setup:
\`\`\`sql
CREATE EXTENSION vector;
ALTER TABLE ideas ADD COLUMN embedding vector(384);
CREATE INDEX ON ideas USING ivfflat (embedding vector_cosine_ops);
\`\`\`

## Query Example:
\`\`\`sql
SELECT *, 1 - (embedding <=> query_embedding) as similarity
FROM ideas
WHERE 1 - (embedding <=> query_embedding) > 0.7
ORDER BY similarity DESC LIMIT 10;
\`\`\`" \
  --label "feature,backend,ai,priority: medium" \
  --milestone "Sprint 5 - Advanced Features"

echo "✓ Created: Semantic Search"

# Story 8.4: Recommendation Engine
gh issue create \
  --title "[FEATURE] Recommendation Engine" \
  --body "**Epic**: Search & Discovery

**As a** startup aspirant  
**I want** to see recommended VCs and use cases for my idea  
**So that** I can discover relevant opportunities

## Acceptance Criteria:
- [ ] Personalized recommendations based on idea history
- [ ] \"VCs you might like\" section on dashboard
- [ ] \"Ideas like yours\" section
- [ ] Explain recommendations (why suggested)
- [ ] Feedback loop (like/dislike recommendations)
- [ ] Improve over time with user interaction

## Technical Notes:
- Implement collaborative filtering or content-based recommendation
- Add GET /api/recommendations endpoint
- Store user preferences and interactions
- Use embeddings for content similarity
- A/B test different recommendation algorithms

## Effort:
13 story points

## Recommendation Strategies:
1. **Content-based**: Similar ideas based on embeddings
2. **Collaborative**: Users with similar ideas also liked...
3. **Hybrid**: Combine both approaches

## Algorithm:
- Calculate similarity scores
- Filter by user preferences
- Diversify results (avoid echo chamber)
- Track click-through rate" \
  --label "feature,backend,ai,priority: medium" \
  --milestone "Sprint 5 - Advanced Features"

echo "✓ Created: Recommendation Engine"

# Story 9.1: Comments System
gh issue create \
  --title "[FEATURE] Comments & Discussions on Ideas" \
  --body "**Epic**: Collaboration & Social Features

**As a** VC representative  
**I want** to comment on startup ideas  
**So that** I can provide feedback or ask questions

## Acceptance Criteria:
- [ ] Threaded comments system (replies to comments)
- [ ] Rich text comments (markdown support)
- [ ] @mentions to notify users
- [ ] Like/upvote comments
- [ ] Comment moderation (report/hide inappropriate)
- [ ] Edit/delete own comments
- [ ] Sort comments (newest, oldest, top)

## Technical Notes:
- Create Comment model (idea_id, user_id, parent_id, content, likes, created_at)
- Add comment CRUD endpoints
- Frontend comment component with threading
- Markdown rendering (react-markdown)
- Real-time updates via WebSocket (optional)

## Effort:
5 story points

## Database Schema:
\`\`\`sql
CREATE TABLE comments (
    id SERIAL PRIMARY KEY,
    idea_id INTEGER REFERENCES ideas(id),
    user_id INTEGER REFERENCES users(id),
    parent_id INTEGER REFERENCES comments(id),
    content TEXT,
    likes INTEGER DEFAULT 0,
    is_hidden BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP
);
\`\`\`" \
  --label "feature,backend,frontend,priority: medium" \
  --milestone "Sprint 5 - Advanced Features"

echo "✓ Created: Comments System"

# Story 10.2: Audit Trail
gh issue create \
  --title "[FEATURE] Audit Trail for Sensitive Actions" \
  --body "**Epic**: Security & Compliance

**As a** compliance officer  
**I want** detailed audit logs for all sensitive actions  
**So that** we can track and review activity

## Acceptance Criteria:
- [ ] Log all CRUD operations on ideas, use cases, evaluations
- [ ] Log authentication events (login, logout, failed attempts)
- [ ] Log admin actions (user management, settings changes)
- [ ] Searchable audit log viewer (admin only)
- [ ] Export audit logs for compliance
- [ ] Retention policy (90 days minimum)

## Technical Notes:
- Enhance existing AuditLog model
- Add audit logging middleware to FastAPI
- Create GET /api/admin/audit-logs endpoint with filters
- Frontend: audit log viewer with search and filters
- Implement log rotation and archival

## Effort:
5 story points

## Audit Log Fields:
- timestamp
- user_id
- action (create, update, delete, login, etc.)
- resource_type (idea, usecase, user, etc.)
- resource_id
- changes (before/after JSON)
- ip_address
- user_agent" \
  --label "feature,security,backend,priority: medium" \
  --milestone "Sprint 5 - Advanced Features"

echo "✓ Created: Audit Trail"

# Story 10.3: GDPR Compliance
gh issue create \
  --title "[FEATURE] Data Privacy & GDPR Compliance" \
  --body "**Epic**: Security & Compliance

**As a** user  
**I want** to exercise my data privacy rights  
**So that** I comply with GDPR/CCPA regulations

## Acceptance Criteria:
- [ ] Download all personal data (JSON/CSV export)
- [ ] Request account deletion (soft delete with anonymization)
- [ ] Data anonymization after deletion (replace with \"[deleted]\")
- [ ] Cookie consent banner
- [ ] Privacy policy and terms acceptance on signup
- [ ] Data retention policy documentation

## Technical Notes:
- Add GET /api/users/me/export endpoint
- Add DELETE /api/users/me endpoint (soft delete)
- Implement data anonymization script
- Frontend: cookie consent banner, data management UI
- Generate privacy policy and terms pages

## Effort:
8 story points

## Data Export Format:
\`\`\`json
{
  \"user\": {\"id\": 1, \"email\": \"user@example.com\", ...},
  \"ideas\": [{...}, {...}],
  \"evaluations\": [{...}, {...}],
  \"comments\": [{...}],
  \"activity_log\": [{...}, {...}]
}
\`\`\`

## Anonymization:
- Set \`is_deleted = true\`
- Replace email with \"deleted_user_{id}@deleted.local\"
- Clear personal data (name, bio, etc.)
- Keep idea/comment content but mark as \"[deleted user]\"" \
  --label "feature,security,backend,frontend,priority: medium" \
  --milestone "Sprint 5 - Advanced Features"

echo "✓ Created: GDPR Compliance"

# Story 10.4: Content Moderation
gh issue create \
  --title "[FEATURE] Content Moderation & Spam Detection" \
  --body "**Epic**: Security & Compliance

**As a** system admin  
**I want** to detect and moderate spam or inappropriate content  
**So that** the platform maintains quality

## Acceptance Criteria:
- [ ] Automated spam detection for ideas and comments
- [ ] Profanity filter for comments
- [ ] Report content feature for users
- [ ] Admin moderation queue
- [ ] Auto-suspend repeat offenders (3 reports threshold)
- [ ] Appeal process for suspended users

## Technical Notes:
- Integrate spam detection: Akismet API or custom ML model
- Create ContentReport model
- Add moderation endpoints for admins
- Frontend: report button, moderation dashboard
- Implement profanity filter library

## Effort:
8 story points

## Spam Detection:
\`\`\`python
from akismet import Akismet

akismet = Akismet(api_key=AKISMET_KEY, blog_url=SITE_URL)
is_spam = akismet.check({
    'user_ip': request.client.host,
    'user_agent': request.headers['user-agent'],
    'comment_content': content,
    'comment_type': 'comment'
})
\`\`\`" \
  --label "feature,security,backend,priority: medium" \
  --milestone "Sprint 5 - Advanced Features"

echo "✓ Created: Content Moderation"

# Story 11.2: Caching Strategy
gh issue create \
  --title "[FEATURE] Caching Strategy Implementation" \
  --body "**Epic**: Performance & Scalability

**As a** system admin  
**I want** to implement multi-level caching  
**So that** frequent data is served faster

## Acceptance Criteria:
- [ ] Redis caching for API responses (use cases, ideas lists)
- [ ] Cache invalidation strategy (TTL + manual)
- [ ] CDN for static assets (Azure CDN)
- [ ] Browser caching headers
- [ ] Cache hit rate monitoring

## Technical Notes:
- Use fastapi-cache2 with Redis backend
- Implement cache decorators for expensive queries
- Configure Nginx caching for static files
- Set appropriate Cache-Control headers
- Monitor cache performance with metrics

## Effort:
5 story points

## Caching Strategy:
- **API Responses**: 5-15 minutes TTL
- **Static Assets**: 1 day (with versioning)
- **User Sessions**: Until logout
- **Analytics Data**: 1 hour
- **Search Results**: 10 minutes

## Implementation:
\`\`\`python
from fastapi_cache import FastAPICache
from fastapi_cache.backends.redis import RedisBackend
from fastapi_cache.decorator import cache

@cache(expire=300)  # 5 minutes
@app.get('/api/vc/usecases')
async def get_usecases():
    ...
\`\`\`" \
  --label "task,backend,deployment,priority: medium" \
  --milestone "Sprint 5 - Advanced Features"

echo "✓ Created: Caching Strategy"

# Story 11.3: Async Processing
gh issue create \
  --title "[FEATURE] Async Processing for Heavy Tasks" \
  --body "**Epic**: Performance & Scalability

**As a** system admin  
**I want** to process heavy tasks asynchronously  
**So that** API responses remain fast

## Acceptance Criteria:
- [ ] Background job queue for batch evaluations
- [ ] Async email sending
- [ ] Async AI agent calls
- [ ] Job status tracking and progress updates
- [ ] Failed job retry mechanism (3 retries with exponential backoff)
- [ ] Job history and logs

## Technical Notes:
- Implement Celery + Redis for task queue
- Create background task endpoints
- Add job status polling endpoint: GET /api/jobs/{job_id}
- Frontend: progress bars, job status updates
- Monitor queue health and worker status

## Effort:
8 story points

## Celery Setup:
\`\`\`python
# tasks.py
from celery import Celery

celery = Celery('tasks', broker='redis://localhost:6379/0')

@celery.task(bind=True, max_retries=3)
def evaluate_batch(self, idea_ids, usecase_ids):
    try:
        # Process evaluations
        ...
    except Exception as exc:
        raise self.retry(exc=exc, countdown=60 * (2 ** self.request.retries))
\`\`\`

## Task Types:
- Batch evaluations
- Email sending
- PDF generation
- AI agent calls
- Data export
- Analytics computation" \
  --label "feature,backend,deployment,priority: medium" \
  --milestone "Sprint 5 - Advanced Features"

echo "✓ Created: Async Processing"

# Story 12.2: Accessibility
gh issue create \
  --title "[FEATURE] Accessibility (WCAG 2.1 AA Compliance)" \
  --body "**Epic**: Mobile & Accessibility

**As a** user with disabilities  
**I want** the application to be accessible  
**So that** I can use it effectively

## Acceptance Criteria:
- [ ] Keyboard navigation for all features (Tab, Enter, Esc)
- [ ] Screen reader compatibility (NVDA, JAWS tested)
- [ ] ARIA labels and roles on interactive elements
- [ ] Sufficient color contrast (4.5:1 for text)
- [ ] Focus indicators visible (outline on focused elements)
- [ ] Accessible forms with error messages
- [ ] Skip to main content link
- [ ] Alt text for all images

## Technical Notes:
- Use React-Aria or Radix UI accessible components
- Run axe-core accessibility tests in CI/CD
- Add ARIA attributes to custom components
- Test with screen readers (NVDA, VoiceOver)
- Color contrast checker (WebAIM)

## Effort:
8 story points

## WCAG 2.1 AA Checklist:
- ✓ 1.1.1 Non-text Content (alt text)
- ✓ 1.4.3 Contrast (4.5:1 minimum)
- ✓ 2.1.1 Keyboard accessible
- ✓ 2.4.7 Focus Visible
- ✓ 3.3.2 Labels or Instructions
- ✓ 4.1.2 Name, Role, Value (ARIA)

## Testing Tools:
- axe DevTools
- WAVE browser extension
- Lighthouse accessibility audit" \
  --label "feature,frontend,priority: medium" \
  --milestone "Sprint 5 - Advanced Features"

echo "✓ Created: Accessibility"

# Story 13.2: Usage Analytics & Billing
gh issue create \
  --title "[FEATURE] Usage Analytics & Billing" \
  --body "**Epic**: Business & Monetization

**As a** platform owner  
**I want** to track usage and bill customers accurately  
**So that** revenue is maximized

## Acceptance Criteria:
- [ ] Track API calls, evaluations, AI usage per user
- [ ] Usage dashboard for customers (quota remaining)
- [ ] Automated billing based on usage (metered billing)
- [ ] Invoice generation and download
- [ ] Payment history
- [ ] Overage alerts (approaching quota limits)

## Technical Notes:
- Create UsageMetric model
- Add metering middleware to track API calls
- Integrate with Stripe metered billing
- Generate invoices monthly
- Frontend: usage dashboard with charts

## Effort:
8 story points

## Metering Points:
- API calls (per endpoint type)
- Evaluations run
- AI agent calls
- Storage used (MB)
- Ideas created
- Users invited

## Stripe Metered Billing:
\`\`\`python
stripe.SubscriptionItem.create_usage_record(
    subscription_item_id,
    quantity=100,  # Number of API calls
    timestamp=int(time.time())
)
\`\`\`" \
  --label "feature,backend,priority: medium" \
  --milestone "Sprint 5 - Advanced Features"

echo "✓ Created: Usage Analytics & Billing"

# Story 14.1: Public API
gh issue create \
  --title "[FEATURE] Public API with Documentation" \
  --body "**Epic**: Developer Experience

**As a** third-party developer  
**I want** to access the platform via API  
**So that** I can build integrations

## Acceptance Criteria:
- [ ] RESTful API with versioning (v1, v2 support)
- [ ] API key authentication (in addition to JWT)
- [ ] Comprehensive Swagger/OpenAPI documentation (expand existing)
- [ ] Rate limiting per API key
- [ ] API usage analytics for developers
- [ ] Example requests in multiple languages (curl, Python, JS)

## Technical Notes:
- Already have /docs ✅ - expand with more examples
- Add API key generation: POST /api/keys
- Add API key authentication middleware
- Implement rate limiting per key
- Add developer portal page

## Effort:
8 story points

## API Key Format:
\`\`\`
sk_live_abc123xyz789...  # Production
sk_test_abc123xyz789...  # Testing
\`\`\`

## Authentication:
\`\`\`bash
curl -H \"Authorization: Bearer sk_live_abc123...\" \\
     https://api.startup-vc.com/v1/ideas
\`\`\`" \
  --label "feature,backend,documentation,priority: medium" \
  --milestone "Sprint 5 - Advanced Features"

echo "✓ Created: Public API"

# Story 14.2: Webhooks
gh issue create \
  --title "[FEATURE] Webhooks for Events" \
  --body "**Epic**: Developer Experience

**As a** third-party developer  
**I want** to receive webhooks for platform events  
**So that** my integration stays in sync

## Acceptance Criteria:
- [ ] Webhook endpoint configuration (URL, secret)
- [ ] Events: idea.created, evaluation.completed, user.registered, comment.created
- [ ] Webhook signature verification (HMAC SHA-256)
- [ ] Retry failed webhooks (3 attempts with exp backoff)
- [ ] Webhook delivery logs and debugging
- [ ] Test webhook functionality

## Technical Notes:
- Create Webhook and WebhookDelivery models
- Implement webhook dispatcher (async with Celery)
- Add webhook management UI
- Sign payloads with HMAC-SHA256
- Store delivery attempts and responses

## Effort:
8 story points

## Webhook Payload Example:
\`\`\`json
{
  \"event\": \"idea.created\",
  \"timestamp\": \"2025-10-22T10:30:00Z\",
  \"data\": {
    \"id\": 123,
    \"title\": \"AI Startup Idea\",
    \"user_id\": 456
  }
}
\`\`\`

## Signature Header:
\`\`\`
X-Webhook-Signature: sha256=abc123...
\`\`\`" \
  --label "feature,backend,priority: medium" \
  --milestone "Sprint 5 - Advanced Features"

echo "✓ Created: Webhooks"

echo ""
echo "════════════════════════════════════════════════════════════"
echo "✓ Created 28 Medium Priority Issues"
echo "════════════════════════════════════════════════════════════"
echo ""

gh issue list --repo $REPO --limit 50

echo ""
echo "📊 Total Issues Now: $(gh issue list --repo $REPO --json number --jq '. | length')"
echo ""
echo "🔗 View all issues: https://github.com/$REPO/issues"
echo ""
