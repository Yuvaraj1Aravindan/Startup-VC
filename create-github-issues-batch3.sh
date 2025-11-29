#!/bin/bash

# Create Remaining GitHub Issues (Batch 3 - Final)
# Repository: Yuvaraj1Aravindan/Startup-VC

set -e

REPO="Yuvaraj1Aravindan/Startup-VC"

echo "╔══════════════════════════════════════════════════════════╗"
echo "║   Creating Final GitHub Issues - Batch 3 (13 more)      ║"
echo "╚══════════════════════════════════════════════════════════╝"
echo ""

# ============================================================
# LOW PRIORITY ISSUES - Advanced & Future Features
# ============================================================

echo "🔵 Creating Low Priority Issues..."
echo ""

# Story 1.4: Social Login
gh issue create \
  --title "[FEATURE] Social Login Integration (Google, LinkedIn, Microsoft)" \
  --body "**Epic**: Core Platform Features

**As a** user  
**I want** to sign in using my Google/LinkedIn/Microsoft account  
**So that** I don't need to create another password

## Acceptance Criteria:
- [ ] Google OAuth 2.0 login
- [ ] LinkedIn OAuth login
- [ ] Microsoft Azure AD login
- [ ] Link social accounts to existing profile
- [ ] Unlink social accounts
- [ ] Show connected accounts in settings

## Technical Notes:
- Use authlib for OAuth implementation
- Add social_accounts table (user_id, provider, provider_id, access_token)
- Add OAuth callback endpoints
- Frontend: social login buttons
- Redirect after login to previous page

## Effort:
8 story points

## OAuth Providers:
- Google: OAuth 2.0 (https://console.cloud.google.com)
- LinkedIn: OAuth 2.0 (https://www.linkedin.com/developers)
- Microsoft: Azure AD (https://portal.azure.com)" \
  --label "feature,backend,frontend,priority: low" \
  --milestone "v1.0 Release"

echo "✓ Created: Social Login Integration"

# Story 2.2: Idea Templates
gh issue create \
  --title "[FEATURE] Idea Templates & Frameworks" \
  --body "**Epic**: Idea Submission & Management

**As a** startup aspirant  
**I want** to use pre-built templates for my pitch  
**So that** I don't start from scratch

## Acceptance Criteria:
- [ ] 5+ built-in templates: Lean Canvas, Business Model Canvas, YC Application, etc.
- [ ] Template categories: SaaS, Hardware, B2C, B2B
- [ ] Save custom templates
- [ ] Share templates with community
- [ ] Template preview before selection
- [ ] Auto-fill template fields from previous ideas

## Technical Notes:
- Create IdeaTemplate model
- Store templates as JSON schema
- Add GET /api/templates endpoint
- Frontend: template gallery, template editor
- Pre-populate templates during migration

## Effort:
5 story points

## Built-in Templates:
1. Lean Canvas (9 blocks)
2. Business Model Canvas (9 sections)
3. Y Combinator Application (10 questions)
4. Pitch Deck Outline (12 slides)
5. One-Pager Template (1 page format)" \
  --label "feature,backend,frontend,priority: low" \
  --milestone "v1.0 Release"

echo "✓ Created: Idea Templates"

# Story 3.2: Use Case Duplication
gh issue create \
  --title "[FEATURE] Use Case Duplication & Variants" \
  --body "**Epic**: VC Use Case Management

**As a** VC representative  
**I want** to duplicate existing use cases  
**So that** I can create variants without starting over

## Acceptance Criteria:
- [ ] \"Duplicate\" button on use case detail page
- [ ] Copy all criteria and metadata
- [ ] Optionally modify during duplication
- [ ] Track parent use case (relationship)
- [ ] Bulk duplication (select multiple)

## Technical Notes:
- Add POST /api/vc/usecases/{id}/duplicate endpoint
- Deep copy use case with new ID
- Add \`parent_id\` to VCUseCase model (optional)
- Frontend: duplication modal with options

## Effort:
2 story points" \
  --label "feature,backend,frontend,priority: low" \
  --milestone "Sprint 3 - Core Features"

echo "✓ Created: Use Case Duplication"

# Story 3.3: Advanced Criteria Builder
gh issue create \
  --title "[FEATURE] Advanced Criteria Builder with Weights" \
  --body "**Epic**: VC Use Case Management

**As a** VC representative  
**I want** to build complex evaluation criteria with custom weights  
**So that** scoring reflects my priorities

## Acceptance Criteria:
- [ ] Drag-and-drop criteria builder
- [ ] Assign weights to each criterion (0-100%)
- [ ] Nested criteria groups (AND/OR logic)
- [ ] Save criteria as reusable templates
- [ ] Preview scoring calculation
- [ ] Import/export criteria JSON

## Technical Notes:
- Extend VCUseCase model with \`criteria_json\` field
- Implement weighted scoring algorithm
- Add criteria builder component (React DnD)
- Validate total weights = 100%
- Add GET /api/vc/criteria-templates endpoint

## Effort:
13 story points

## Criteria JSON Schema:
\`\`\`json
{
  \"criteria\": [
    {
      \"id\": \"market_size\",
      \"name\": \"Market Size\",
      \"weight\": 30,
      \"type\": \"range\",
      \"min\": 0,
      \"max\": 100
    },
    {
      \"id\": \"team\",
      \"weight\": 25,
      \"subcriteria\": [...]
    }
  ]
}
\`\`\`" \
  --label "feature,backend,frontend,priority: low" \
  --milestone "Sprint 5 - Advanced Features"

echo "✓ Created: Advanced Criteria Builder"

# Story 4.4: AI Improvement Suggestions
gh issue create \
  --title "[FEATURE] AI-Powered Improvement Suggestions" \
  --body "**Epic**: VC Investment Agent Integration

**As a** startup aspirant  
**I want** AI to suggest improvements to my pitch  
**So that** I can increase my score

## Acceptance Criteria:
- [ ] Analyze idea content and identify weaknesses
- [ ] Suggest specific improvements (3-5 actionable items)
- [ ] Compare to top-performing ideas (anonymized)
- [ ] Industry-specific recommendations
- [ ] Re-score after applying suggestions (preview)

## Technical Notes:
- Use agent API: POST http://4.213.154.131:8001/api/improve
- Add GET /api/ideas/{id}/suggestions endpoint
- Frontend: suggestions panel with \"Apply\" buttons
- Store applied suggestions for tracking

## Effort:
8 story points

## Suggestion Types:
- Problem statement clarity
- Market size validation
- Competitive differentiation
- Team credentials
- Financial projections
- Traction metrics" \
  --label "feature,backend,ai,frontend,priority: low" \
  --milestone "Sprint 5 - Advanced Features"

echo "✓ Created: AI Improvement Suggestions"

# Story 5.4: Pitch Deck Analysis
gh issue create \
  --title "[FEATURE] Pitch Deck Analysis (PDF/PPT Upload)" \
  --body "**Epic**: VC Investment Agent Integration

**As a** startup aspirant  
**I want** to upload my pitch deck for AI analysis  
**So that** I get comprehensive feedback

## Acceptance Criteria:
- [ ] Upload PDF or PPTX files (max 10MB)
- [ ] Extract text and images from slides
- [ ] AI analysis of deck structure and content
- [ ] Slide-by-slide feedback
- [ ] Score each section (problem, solution, market, etc.)
- [ ] Download annotated deck with comments

## Technical Notes:
- Use PyPDF2 or pdfplumber for PDF parsing
- Use python-pptx for PowerPoint parsing
- Store files in Azure Blob Storage
- Add POST /api/ideas/{id}/deck endpoint
- AI analysis via agent API

## Effort:
13 story points

## Analysis Sections:
1. Problem & Solution (slides 1-3)
2. Market Opportunity (slides 4-6)
3. Product/Demo (slides 7-9)
4. Business Model (slides 10-11)
5. Team (slides 12-13)
6. Traction & Financials (slides 14-16)
7. Ask & Use of Funds (slides 17-18)" \
  --label "feature,backend,ai,priority: low" \
  --milestone "Sprint 5 - Advanced Features"

echo "✓ Created: Pitch Deck Analysis"

# Story 5.5: AI Chatbot
gh issue create \
  --title "[FEATURE] AI Chatbot for Q&A and Guidance" \
  --body "**Epic**: VC Investment Agent Integration

**As a** user  
**I want** to chat with an AI assistant  
**So that** I can get instant answers and guidance

## Acceptance Criteria:
- [ ] Chat interface (fixed bottom-right corner)
- [ ] Context-aware responses based on current page
- [ ] FAQs about platform usage
- [ ] Pitch advice and best practices
- [ ] VC industry insights
- [ ] Chat history saved per user
- [ ] Export chat transcript

## Technical Notes:
- Use agent API: POST http://4.213.154.131:8001/api/chat
- Create ChatMessage model
- Add WebSocket support for real-time chat
- Frontend: chat widget component
- Implement conversation memory (last 10 messages)

## Effort:
13 story points

## Chat Capabilities:
- Platform help and navigation
- Idea improvement suggestions
- VC matching advice
- Industry trends and insights
- Scoring explanation
- Best practices for pitching" \
  --label "feature,backend,ai,frontend,priority: low" \
  --milestone "Sprint 5 - Advanced Features"

echo "✓ Created: AI Chatbot"

# Story 6.4: Custom Report Builder
gh issue create \
  --title "[FEATURE] Custom Report Builder" \
  --body "**Epic**: Analytics & Reporting

**As a** VC representative  
**I want** to create custom reports with selected metrics  
**So that** I can share insights with my team

## Acceptance Criteria:
- [ ] Drag-and-drop report builder
- [ ] Choose metrics: ideas evaluated, avg scores, top industries, etc.
- [ ] Add charts: line, bar, pie, table
- [ ] Filter by date range, industry, score threshold
- [ ] Save report templates
- [ ] Schedule automated reports (weekly/monthly email)
- [ ] Export as PDF, Excel, or PowerPoint

## Technical Notes:
- Create Report and ReportTemplate models
- Add report builder component (React Grid Layout)
- Implement data aggregation queries
- Use Chart.js for visualizations
- PDF export with ReportLab
- Excel export with openpyxl

## Effort:
13 story points

## Available Metrics:
- Total ideas evaluated
- Average overall score
- Top 10 ideas by score
- Ideas by industry (distribution)
- Score trends over time
- Evaluation volume (daily/weekly)
- Conversion rate (views → contacts)" \
  --label "feature,backend,frontend,priority: low" \
  --milestone "Sprint 5 - Advanced Features"

echo "✓ Created: Custom Report Builder"

# Story 7.3: Direct Messaging
gh issue create \
  --title "[FEATURE] Direct Messaging Between Users" \
  --body "**Epic**: Notifications & Communication

**As a** startup founder  
**I want** to message VCs directly  
**So that** I can ask questions or follow up

## Acceptance Criteria:
- [ ] Send direct messages to other users
- [ ] Real-time message delivery (WebSocket)
- [ ] Message read receipts
- [ ] File attachments in messages (images, PDFs)
- [ ] Block/report users
- [ ] Message search and filtering
- [ ] Notification on new message

## Technical Notes:
- Create DirectMessage model
- Add WebSocket support for real-time messaging
- Add messaging endpoints: GET/POST /api/messages
- Frontend: messaging UI (sidebar + conversation view)
- Implement read receipts with timestamps

## Effort:
13 story points

## Database Schema:
\`\`\`sql
CREATE TABLE direct_messages (
    id SERIAL PRIMARY KEY,
    sender_id INTEGER REFERENCES users(id),
    recipient_id INTEGER REFERENCES users(id),
    content TEXT,
    attachment_url VARCHAR(500),
    is_read BOOLEAN DEFAULT FALSE,
    read_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT NOW()
);
\`\`\`" \
  --label "feature,backend,frontend,priority: low" \
  --milestone "v1.0 Release"

echo "✓ Created: Direct Messaging"

# Story 7.4: Activity Feed
gh issue create \
  --title "[FEATURE] Activity Feed & Timeline" \
  --body "**Epic**: Notifications & Communication

**As a** user  
**I want** to see a feed of recent activities  
**So that** I stay updated on platform happenings

## Acceptance Criteria:
- [ ] Chronological feed of user activities
- [ ] Activity types: idea created, evaluation completed, comment added, etc.
- [ ] Filter by activity type
- [ ] Mark as read/unread
- [ ] Aggregate similar activities (\"3 new evaluations\")
- [ ] Load more (infinite scroll)

## Technical Notes:
- Create ActivityFeed model
- Add activity tracking middleware
- Add GET /api/feed endpoint with pagination
- Frontend: feed component with filters
- Real-time updates via WebSocket (optional)

## Effort:
5 story points

## Activity Types:
- idea_created
- evaluation_completed
- comment_added
- vc_interested
- score_improved
- message_received" \
  --label "feature,backend,frontend,priority: low" \
  --milestone "v1.0 Release"

echo "✓ Created: Activity Feed"

# Story 8.3: Tag Management
gh issue create \
  --title "[FEATURE] Tag Management System" \
  --body "**Epic**: Search & Discovery

**As a** user  
**I want** to tag ideas with keywords  
**So that** they are easier to discover

## Acceptance Criteria:
- [ ] Add multiple tags to ideas (autocomplete)
- [ ] Create new tags or select from existing
- [ ] Tag suggestions based on idea content (AI)
- [ ] Filter ideas by tags
- [ ] Popular tags cloud on homepage
- [ ] Tag analytics (most used, trending)

## Technical Notes:
- Create Tag and IdeaTag models (many-to-many)
- Add tagging endpoints: GET/POST /api/tags
- Implement autocomplete with fuzzy search
- AI tag suggestions using NLP
- Frontend: tag input component (React Select)

## Effort:
3 story points

## Database Schema:
\`\`\`sql
CREATE TABLE tags (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) UNIQUE,
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE idea_tags (
    idea_id INTEGER REFERENCES ideas(id),
    tag_id INTEGER REFERENCES tags(id),
    PRIMARY KEY (idea_id, tag_id)
);
\`\`\`" \
  --label "feature,backend,frontend,priority: low" \
  --milestone "Sprint 3 - Core Features"

echo "✓ Created: Tag Management"

# Story 9.2: Following & Bookmarking
gh issue create \
  --title "[FEATURE] Following Users & Bookmarking Ideas" \
  --body "**Epic**: Collaboration & Social Features

**As a** user  
**I want** to follow interesting users and bookmark ideas  
**So that** I can track their activity and save favorites

## Acceptance Criteria:
- [ ] Follow/unfollow users (VCs, founders)
- [ ] See followers/following lists
- [ ] Bookmark ideas for later review
- [ ] Bookmarks organized in folders
- [ ] Activity feed from followed users
- [ ] Email digest of followed users' activity

## Technical Notes:
- Create Follow and Bookmark models
- Add follow/bookmark endpoints
- Frontend: follow button, bookmarks page
- Add follower count to user profiles
- Implement activity feed filtering

## Effort:
5 story points" \
  --label "feature,backend,frontend,priority: low" \
  --milestone "v1.0 Release"

echo "✓ Created: Following & Bookmarking"

# Story 9.3: Public Profiles
gh issue create \
  --title "[FEATURE] Public User Profiles" \
  --body "**Epic**: Collaboration & Social Features

**As a** user  
**I want** to have a public profile page  
**So that** others can learn about me and my work

## Acceptance Criteria:
- [ ] Public profile URL: /users/{username}
- [ ] Display: bio, avatar, organization, website
- [ ] Show public ideas (if opted in)
- [ ] Portfolio of scores and achievements
- [ ] Social links (LinkedIn, Twitter)
- [ ] Privacy settings (public/private profile)

## Technical Notes:
- Add \`username\` and \`is_public\` to User model
- Add GET /api/users/{username} endpoint
- Frontend: profile page component
- SEO optimization for public profiles
- Add og:meta tags for sharing

## Effort:
5 story points" \
  --label "feature,backend,frontend,priority: low" \
  --milestone "v1.0 Release"

echo "✓ Created: Public Profiles"

# Story 9.4: Team Management
gh issue create \
  --title "[FEATURE] Team Management & Organizations" \
  --body "**Epic**: Collaboration & Social Features

**As a** VC firm  
**I want** to create an organization account with team members  
**So that** we can collaborate on evaluations

## Acceptance Criteria:
- [ ] Create organization profile
- [ ] Invite team members via email
- [ ] Role-based permissions: admin, member, viewer
- [ ] Shared use cases and evaluations
- [ ] Team activity dashboard
- [ ] Billing at organization level

## Technical Notes:
- Create Organization and OrganizationMember models
- Add organization management endpoints
- Implement multi-tenancy (scope queries by org)
- Frontend: organization settings page
- Update billing to support organizations

## Effort:
13 story points

## Organization Roles:
- **Owner**: Full control, billing, delete org
- **Admin**: Manage members, create use cases
- **Member**: Create evaluations, view team data
- **Viewer**: Read-only access" \
  --label "feature,backend,frontend,priority: low" \
  --milestone "v1.0 Release"

echo "✓ Created: Team Management"

# Story 11.4: Horizontal Scaling
gh issue create \
  --title "[TASK] Horizontal Scaling Setup" \
  --body "**Epic**: Performance & Scalability

**As a** system admin  
**I want** the application to scale horizontally  
**So that** it can handle growth

## Acceptance Criteria:
- [ ] Load balancer configuration (Azure Load Balancer)
- [ ] Stateless application design (session in Redis)
- [ ] Database read replicas
- [ ] Auto-scaling rules (CPU > 70% → add instance)
- [ ] Health check endpoints
- [ ] Zero-downtime deployments

## Technical Notes:
- Configure Azure Load Balancer or Application Gateway
- Move sessions to Redis
- Setup PostgreSQL read replicas
- Configure Azure VM scale sets or App Service scaling
- Add health endpoint: GET /health

## Effort:
13 story points

## Scaling Strategy:
- **Web Tier**: 2-5 instances (auto-scale)
- **Database**: 1 primary + 2 read replicas
- **Cache**: Redis cluster (3 nodes)
- **Queue**: Celery workers (2-10 instances)" \
  --label "task,deployment,priority: low" \
  --milestone "v1.0 Release"

echo "✓ Created: Horizontal Scaling"

# Story 12.1: Progressive Web App
gh issue create \
  --title "[FEATURE] Progressive Web App (PWA)" \
  --body "**Epic**: Mobile & Accessibility

**As a** mobile user  
**I want** to install the app on my device  
**So that** I can use it like a native app

## Acceptance Criteria:
- [ ] Service worker for offline support
- [ ] App manifest for installation
- [ ] Push notifications support
- [ ] Offline mode (view cached ideas)
- [ ] \"Add to Home Screen\" prompt
- [ ] App icon and splash screen

## Technical Notes:
- Create service worker for caching
- Add manifest.json with app metadata
- Configure workbox for offline strategy
- Add push notification registration
- Test on Chrome, Safari, Firefox

## Effort:
8 story points

## Offline Strategy:
- **Cache First**: Static assets (CSS, JS, images)
- **Network First**: API calls (with fallback)
- **Cache Only**: Offline page

## manifest.json:
\`\`\`json
{
  \"name\": \"Startup VC Platform\",
  \"short_name\": \"VC Platform\",
  \"icons\": [{...}],
  \"start_url\": \"/\",
  \"display\": \"standalone\",
  \"theme_color\": \"#4f46e5\"
}
\`\`\`" \
  --label "feature,frontend,priority: low" \
  --milestone "v1.0 Release"

echo "✓ Created: Progressive Web App"

# Story 12.3: Internationalization
gh issue create \
  --title "[FEATURE] Internationalization (i18n)" \
  --body "**Epic**: Mobile & Accessibility

**As a** non-English user  
**I want** the platform in my language  
**So that** I can use it comfortably

## Acceptance Criteria:
- [ ] Support for 3+ languages: English, Spanish, French
- [ ] Language switcher in header
- [ ] Detect browser language (auto-select)
- [ ] Translate UI text (buttons, labels, messages)
- [ ] Date/time formatting per locale
- [ ] RTL support for Arabic (future)

## Technical Notes:
- Use react-i18next for translations
- Create translation files (JSON) per language
- Add language selection to user preferences
- Use i18next backend for loading translations
- Test with all supported languages

## Effort:
13 story points

## Translation Files:
- en.json (English)
- es.json (Spanish)
- fr.json (French)

## Usage:
\`\`\`javascript
import { useTranslation } from 'react-i18next';

const { t } = useTranslation();
<button>{t('submit_idea')}</button>
\`\`\`" \
  --label "feature,frontend,priority: low" \
  --milestone "v1.0 Release"

echo "✓ Created: Internationalization"

# Story 13.1: Subscription Plans
gh issue create \
  --title "[FEATURE] Subscription Plans & Pricing Tiers" \
  --body "**Epic**: Business & Monetization

**As a** platform owner  
**I want** to offer subscription plans  
**So that** I can monetize the platform

## Acceptance Criteria:
- [ ] 3 pricing tiers: Free, Pro, Enterprise
- [ ] Feature limitations per tier (evaluations/month, AI calls, etc.)
- [ ] Upgrade/downgrade flow
- [ ] Billing via Stripe Checkout
- [ ] Trial period (14 days Pro free)
- [ ] Subscription management dashboard

## Technical Notes:
- Create Subscription model
- Integrate Stripe Checkout and Customer Portal
- Implement feature gating middleware
- Add GET /api/plans and POST /api/subscribe endpoints
- Frontend: pricing page, billing dashboard

## Effort:
13 story points

## Pricing Tiers:
**Free**: 5 evaluations/month, basic features
**Pro ($29/mo)**: 100 evaluations/month, AI matching, analytics
**Enterprise ($199/mo)**: Unlimited, white-label, API access, priority support

## Stripe Integration:
\`\`\`python
import stripe

session = stripe.checkout.Session.create(
    mode='subscription',
    line_items=[{
        'price': price_id,
        'quantity': 1
    }],
    success_url='https://yoursite.com/success',
    cancel_url='https://yoursite.com/cancel'
)
\`\`\`" \
  --label "feature,backend,frontend,priority: low" \
  --milestone "v1.0 Release"

echo "✓ Created: Subscription Plans"

# Story 13.3: Referral Program
gh issue create \
  --title "[FEATURE] Referral Program" \
  --body "**Epic**: Business & Monetization

**As a** user  
**I want** to refer friends and earn rewards  
**So that** I benefit from growing the platform

## Acceptance Criteria:
- [ ] Unique referral code per user
- [ ] Track referrals (who signed up via code)
- [ ] Reward system: free month Pro, credits, etc.
- [ ] Referral dashboard showing stats
- [ ] Email template for invitations
- [ ] Social sharing (Twitter, LinkedIn)

## Technical Notes:
- Create Referral model
- Generate unique referral codes (8 characters)
- Add GET /api/referrals endpoint
- Track signups via referral code
- Implement reward mechanism (credits or discounts)

## Effort:
8 story points

## Reward Structure:
- Referrer gets 1 month Pro free per signup
- Referee gets 14-day trial extended to 30 days

## Database Schema:
\`\`\`sql
CREATE TABLE referrals (
    id SERIAL PRIMARY KEY,
    referrer_id INTEGER REFERENCES users(id),
    referee_id INTEGER REFERENCES users(id),
    code VARCHAR(8) UNIQUE,
    reward_claimed BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT NOW()
);
\`\`\`" \
  --label "feature,backend,frontend,priority: low" \
  --milestone "v1.0 Release"

echo "✓ Created: Referral Program"

# Story 14.3: SDK Libraries
gh issue create \
  --title "[FEATURE] SDK Libraries (Python, JavaScript)" \
  --body "**Epic**: Developer Experience

**As a** third-party developer  
**I want** official SDKs for easy integration  
**So that** I can build on the platform faster

## Acceptance Criteria:
- [ ] Python SDK with all API endpoints
- [ ] JavaScript/Node.js SDK
- [ ] TypeScript definitions
- [ ] Published to PyPI and npm
- [ ] Comprehensive documentation with examples
- [ ] Unit tests and CI/CD

## Technical Notes:
- Create Python package: startup-vc-sdk
- Create npm package: @startup-vc/sdk
- Auto-generate from OpenAPI spec (optional)
- Add authentication handling
- Publish to package registries

## Effort:
13 story points

## Python SDK Example:
\`\`\`python
from startup_vc import Client

client = Client(api_key='sk_live_...')
ideas = client.ideas.list()
evaluation = client.evaluations.create(idea_id=123, usecase_id=456)
\`\`\`

## JavaScript SDK Example:
\`\`\`javascript
import { StartupVC } from '@startup-vc/sdk';

const client = new StartupVC({ apiKey: 'sk_live_...' });
const ideas = await client.ideas.list();
\`\`\`" \
  --label "feature,backend,documentation,priority: low" \
  --milestone "v1.0 Release"

echo "✓ Created: SDK Libraries"

# Story 15.1: Competitor Analysis
gh issue create \
  --title "[FEATURE] Competitor Analysis Tool" \
  --body "**Epic**: Advanced Features

**As a** startup founder  
**I want** to analyze my competitors  
**So that** I can differentiate my idea

## Acceptance Criteria:
- [ ] Input competitor names/URLs
- [ ] AI-powered competitor research
- [ ] SWOT analysis generation
- [ ] Feature comparison matrix
- [ ] Market positioning chart
- [ ] Export as PDF report

## Technical Notes:
- Use web scraping or third-party APIs (Clearbit, Crunchbase)
- Add POST /api/ideas/{id}/competitors endpoint
- Store competitor data in database
- Frontend: competitor analysis page
- AI summarization of findings

## Effort:
13 story points" \
  --label "feature,backend,ai,priority: low" \
  --milestone "v1.0 Release"

echo "✓ Created: Competitor Analysis"

# Story 15.2: Market Research
gh issue create \
  --title "[FEATURE] Market Research Integration" \
  --body "**Epic**: Advanced Features

**As a** startup founder  
**I want** to access market research data  
**So that** I can validate my market opportunity

## Acceptance Criteria:
- [ ] Integrate market data APIs (Statista, IBISWorld, etc.)
- [ ] Industry trends and forecasts
- [ ] Market size estimates
- [ ] Target audience demographics
- [ ] Regulatory and compliance info
- [ ] Export research as PDF

## Technical Notes:
- Integrate third-party market research APIs
- Add GET /api/market-research endpoint
- Cache research data (1 week TTL)
- Frontend: market research dashboard
- AI summarization of reports

## Effort:
13 story points" \
  --label "feature,backend,ai,priority: low" \
  --milestone "v1.0 Release"

echo "✓ Created: Market Research Integration"

# Story 15.3: Video Pitch Analysis
gh issue create \
  --title "[FEATURE] Video Pitch Analysis" \
  --body "**Epic**: Advanced Features

**As a** startup founder  
**I want** to upload a video pitch for AI analysis  
**So that** I get feedback on presentation and content

## Acceptance Criteria:
- [ ] Upload video files (MP4, MOV, max 100MB)
- [ ] Speech-to-text transcription
- [ ] Analyze: tone, pace, filler words, confidence
- [ ] Content analysis (clarity, structure)
- [ ] Presentation tips and score
- [ ] Highlight best/worst moments

## Technical Notes:
- Use Azure Media Services for transcoding
- Speech-to-text with Azure Cognitive Services
- Sentiment analysis on transcript
- Store videos in Azure Blob Storage
- Add POST /api/ideas/{id}/video endpoint

## Effort:
13 story points

## Analysis Metrics:
- Speaking pace (words per minute)
- Filler words count (um, uh, like)
- Sentiment score (confidence)
- Content structure (intro, problem, solution, ask)
- Audience engagement prediction" \
  --label "feature,backend,ai,priority: low" \
  --milestone "v1.0 Release"

echo "✓ Created: Video Pitch Analysis"

echo ""
echo "════════════════════════════════════════════════════════════"
echo "✓ Created 13 Low Priority Issues (Final Batch)"
echo "════════════════════════════════════════════════════════════"
echo ""

gh issue list --repo $REPO --limit 60

echo ""
echo "📊 Total Issues Now: $(gh issue list --repo $REPO --json number --jq '. | length')"
echo ""
echo "🔗 View all issues: https://github.com/$REPO/issues"
echo ""
echo "╔══════════════════════════════════════════════════════════╗"
echo "║         🎉 ALL 41 USER STORIES CREATED! 🎉              ║"
echo "╚══════════════════════════════════════════════════════════╝"
