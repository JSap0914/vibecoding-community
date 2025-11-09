# Epic Technical Specification: Analytics & Growth Infrastructure

Date: 2025-11-09
Author: JSup
Epic ID: 5
Status: Draft

---

## Overview

Epic 5 establishes comprehensive analytics and growth measurement infrastructure for the Vibecoding Community platform. This epic implements tracking systems to measure community health, content performance, SEO effectiveness, and ANYON conversion funnel performance - enabling data-driven decision making and continuous optimization.

**Key Deliverables:**
- Google Analytics 4 (GA4) integration with custom event tracking across all user interactions
- Author-facing content performance dashboards showing views, engagement, and trending metrics
- Admin-facing community health dashboard tracking DAU/WAU/MAU, engagement rates, and conversion metrics
- A/B testing infrastructure for optimizing CTAs, headlines, and layouts
- SEO performance monitoring with keyword rankings, organic traffic tracking, and backlink analysis

**Business Impact:** Provides measurable ROI visibility for the community platform, quantifies ANYON conversion effectiveness (15% community → trial target), identifies content and growth optimization opportunities, and enables data-driven resource allocation decisions. Critical for demonstrating community value and justifying continued investment.

## Objectives and Scope

### In-Scope

**Story 5.1: Google Analytics 4 Integration**
- GA4 tracking code installation via Forem admin panel
- Core event tracking: page views, sessions, traffic sources, user demographics
- Custom events: post views, reactions, comments, signups, ANYON CTA clicks, searches
- GA4 property configuration with data streams, goals/conversions, user properties
- Privacy compliance: IP anonymization, GDPR cookie consent banner for EU users

**Story 5.2: Content Performance Dashboards**
- Author dashboard showing per-post metrics: views, unique visitors, reactions, comments, shares, read time
- Aggregate author statistics: total views, followers, trending posts, best performers
- Dashboard UI with date range filtering, comparison views, CSV export
- Cached metrics updated hourly for performance
- Chart.js visualizations for trend analysis

**Story 5.3: Community Health Metrics**
- Admin-only health dashboard with growth metrics (DAU/WAU/MAU)
- Engagement metrics: posts/day, comments/post, reaction rate
- Retention metrics: 7-day and 30-day return rates
- Conversion metrics: ANYON CTA clicks, estimated trial signups
- Traffic analysis: top posts, authors, referring sources, search keywords
- Alert system for unusual activity drops or spam surges

**Story 5.4: A/B Testing Infrastructure**
- A/B testing framework for CTA copy/placement, headlines, landing page layouts, email subject lines
- Traffic splitting capabilities (50/50 or custom ratios)
- Goal tracking and statistical significance calculation
- Test management via admin panel
- Integration with GA4 for event tracking

**Story 5.5: SEO Performance Monitoring**
- Google Search Console integration
- Keyword ranking tracking for target terms ("vibecoding", "ANYON", "AI app builder")
- Organic traffic monitoring and CTR analysis
- Backlink growth tracking and alerts
- Domain authority score monitoring
- Core Web Vitals monitoring
- Monthly SEO dashboard with competitor comparison

### Out-of-Scope

- Advanced business intelligence tools (Looker, Tableau) - use GA4 and Looker Studio for MVP
- Real-time analytics dashboards (hourly refresh is sufficient)
- User-level behavior tracking beyond GA4 standard capabilities
- Custom recommendation engine (use GA4 insights post-MVP)
- Social media analytics integration (track via UTM parameters only)
- Heatmaps and session recording (Hotjar post-MVP if needed)
- Custom data warehouse (database + GA4 sufficient for MVP)
- Advanced cohort analysis (GA4 basic cohorts sufficient initially)

## System Architecture Alignment

### Architecture Constraints

**Technology Stack (from Architecture):**
- **Analytics Platform:** Google Analytics 4 + Google Tag Manager (GTM) (ADR-005)
- **Backend:** Ruby on Rails 7.0.8.4 for dashboard APIs
- **Frontend:** Preact 10.20.2 for dashboard components
- **Database:** PostgreSQL 14+ for custom metrics storage (`vibecoding_analytics` table)
- **Caching:** Redis for dashboard metric caching (reduce database queries)
- **A/B Testing:** Google Optimize (free tier) or custom framework
- **SEO Tools:** Google Search Console, Ahrefs/SEMrush for ranking tracking

**Implementation Patterns (from Architecture):**
- Pattern 2: Namespaced Customizations (`app/javascript/analytics/`, `lib/vibecoding/analytics_tracker.rb`)
- Pattern 3: Service Object Pattern (`Vibecoding::AnalyticsTracker`, `Anyon::ConversionTracker`)
- Pattern 4: Frontend Component Pattern (Preact components for dashboards)
- Pattern 5: Database Migration Pattern (commented `vibecoding_analytics` table migration)

**Epic 2 Dependency:** Conversion tracking in Epic 5 builds on ANYON CTA and project linking implemented in Epic 2 (Stories 2.1-2.4).

### Referenced Architecture Components

**Epic to Architecture Mapping (from Architecture):**
- **Location:** `app/javascript/analytics/`, `lib/vibecoding/analytics_tracker.rb`, `app/views/admin/vibecoding/`
- **Database Impact:** `vibecoding_analytics` table for custom metrics
- **Services:** `Vibecoding::AnalyticsTracker`
- **Components:** Admin dashboard components
- **External Services:** GA4, GTM, Google Search Console

**Integration Points (from Architecture):**
```
Forem Platform
    ↓
┌───────────────────────────────────┐
│   Vibecoding Community (Rails)    │
│                                   │
│  ┌─────────────────────────────┐ │
│  │  Analytics Integration      │ │
│  │  - AnalyticsTracker         │ │
│  │  - Dashboard APIs           │ │
│  └─────────────────────────────┘ │
└───────────────────────────────────┘
    ↓           ↓           ↓
┌─────────┐ ┌─────────┐ ┌─────────┐
│   GA4   │ │   GTM   │ │Google SC│
└─────────┘ └─────────┘ └─────────┘
```

**Data Flow:**
1. User interactions → Frontend events → GTM → GA4 (for behavioral analytics)
2. Server-side events → `AnalyticsTracker` service → `vibecoding_analytics` table (for custom metrics)
3. Dashboard requests → Rails API → Cached metrics from database + GA4 API → JSON response
4. SEO monitoring → Google Search Console API → Database storage → Admin dashboard

**Consistency Rules:**
- Logging: `Rails.logger.info("VIBECODING: Analytics - ...")` format
- Git commits: `[VIBECODING]` prefix for all analytics code
- Event naming: `anyon_<action>` format (e.g., `anyon_cta_click`)
- Service pattern: All tracking logic in service objects, not controllers

## Detailed Design

### Services and Modules

| Module/Service | Responsibility | Inputs | Outputs | Owner |
|----------------|----------------|--------|---------|-------|
| **GA4 Tracking Service** | Install and configure GA4 tracking across platform | GA4 measurement ID, event definitions | Tracking code in page headers, custom events fired | Analytics |
| **Vibecoding::AnalyticsTracker** | Server-side custom event tracking to database | User, event_type, metadata hash | `vibecoding_analytics` record created | Backend |
| **Anyon::ConversionTracker** (from Epic 2) | Track ANYON-specific conversion events | User, conversion type (cta_click, project_link, etc.) | GA4 event + database record | Backend |
| **Analytics::DashboardAPI** | Provide analytics data to dashboard UIs | User/Admin auth, date range, filters | JSON metrics data | Backend |
| **Analytics::MetricsCacheService** | Cache computed metrics in Redis | Metric type, timeframe | Cached metric value with TTL | Backend |
| **GA4 Data Fetcher** | Fetch data from GA4 Reporting API | GA4 property ID, metric/dimension queries | Raw GA4 data (sessions, pageviews, etc.) | Backend |
| **ContentPerformanceDashboard (Preact)** | Author-facing dashboard UI | Current user, post IDs | Rendered dashboard with charts | Frontend |
| **CommunityHealthDashboard (Preact)** | Admin-facing health metrics UI | Admin auth | Rendered health dashboard | Frontend |
| **ABTestManager** | Manage A/B test lifecycle | Test config (variants, goals, traffic split) | Test running, results tracking | Backend |
| **SEOMonitoringService** | Fetch and track SEO metrics | Google Search Console API credentials | Keyword rankings, CTR data, backlinks | Backend |
| **AlertService** | Send alerts for anomalies | Threshold configs, current metrics | Email/Slack notifications | Backend |

**Key Implementation Notes:**
- `Vibecoding::AnalyticsTracker` inherits from `Anyon::BaseService` for standardized error handling (Architecture Pattern 3)
- GA4 tracking uses GTM for flexible event management without code deploys
- Dashboard APIs use Redis caching (1-hour TTL) to reduce database load
- SEO monitoring runs as daily Sidekiq background job
- A/B testing uses Google Optimize free tier OR custom Rails implementation (TBD based on requirements)

### Data Models and Contracts

**New Database Tables:**

```sql
-- vibecoding_analytics (custom metrics storage)
CREATE TABLE vibecoding_analytics (
  id BIGSERIAL PRIMARY KEY,
  user_id BIGINT REFERENCES users(id) ON DELETE CASCADE,
  event_type VARCHAR(255) NOT NULL,  -- 'page_view', 'post_view', 'anyon_cta_click', etc.
  event_data JSONB,                   -- Flexible metadata storage
  tracked_at TIMESTAMP NOT NULL DEFAULT NOW(),
  created_at TIMESTAMP NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_vibecoding_analytics_user_id ON vibecoding_analytics(user_id);
CREATE INDEX idx_vibecoding_analytics_event_type ON vibecoding_analytics(event_type);
CREATE INDEX idx_vibecoding_analytics_tracked_at ON vibecoding_analytics(tracked_at);
CREATE INDEX idx_vibecoding_analytics_event_type_tracked_at ON vibecoding_analytics(event_type, tracked_at);

COMMENT ON TABLE vibecoding_analytics IS 'VIBECODING: Custom analytics events for community metrics';
COMMENT ON COLUMN vibecoding_analytics.event_data IS 'JSONB field for flexible event metadata (e.g., post_id, cta_location)';
```

**Example event_data structures:**

```json
// Post view event
{
  "post_id": 12345,
  "author_id": 67890,
  "referrer": "https://google.com",
  "read_time_seconds": 120
}

// ANYON CTA click event
{
  "cta_location": "header",
  "destination_url": "https://anyon.app/signup?utm_source=community",
  "campaign": "launch"
}

// Search event
{
  "query": "vibecoding tutorial",
  "results_count": 42,
  "clicked_result_rank": 3
}
```

**Modified Forem Tables:**

```sql
-- articles (existing Forem table - no changes needed)
-- Forem already tracks view_count, reactions_count, comments_count

-- users (existing Forem table - no changes needed)
-- Forem already tracks profile views, followers
```

**Redis Cache Keys:**

```ruby
# Dashboard metrics cache (1-hour TTL)
"vibecoding:metrics:author:#{user_id}:#{date}:views"          # Total post views for author
"vibecoding:metrics:author:#{user_id}:#{date}:reactions"      # Total reactions
"vibecoding:metrics:community:#{date}:dau"                     # Daily active users
"vibecoding:metrics:community:#{date}:posts_count"            # Posts published today
"vibecoding:metrics:seo:#{date}:rankings"                      # Keyword rankings snapshot

# TTL: 3600 seconds (1 hour)
# Invalidation: Manual via admin action or automatic on significant events
```

**GA4 Event Schema:**

Following Google Analytics 4 event naming conventions:

```javascript
// Custom events sent to GA4 via GTM
{
  event: 'anyon_cta_click',
  user_id: '12345',              // GA4 user_id
  cta_location: 'header',         // Custom parameter
  timestamp: 1699564800
}

{
  event: 'post_view',
  user_id: '12345',
  post_id: '67890',
  author_id: '11111',
  post_category: 'tutorial'
}

{
  event: 'anyon_project_link_click',
  user_id: '12345',
  post_id: '67890',
  project_url: 'https://anyon.app/project/xyz'
}
```

### APIs and Interfaces

**Internal APIs (Rails Controllers)**

**1. Author Dashboard API**

```ruby
# GET /api/custom/analytics/author/dashboard
# Authentication: Requires logged-in user
# Returns: Author's content performance metrics

Request Headers:
  Authorization: Bearer <session_token>

Query Parameters:
  date_range: string (optional, default: '30d') - '7d', '30d', '90d', 'all_time'
  post_ids: array (optional) - Filter specific posts

Response (200 OK):
{
  "success": true,
  "data": {
    "summary": {
      "total_views": 12543,
      "total_reactions": 342,
      "total_comments": 89,
      "total_followers": 156,
      "trending_posts_count": 3
    },
    "posts": [
      {
        "post_id": 12345,
        "title": "Building SaaS with ANYON",
        "published_at": "2025-11-01T10:00:00Z",
        "metrics": {
          "views": 1234,
          "unique_visitors": 987,
          "reactions": 45,
          "comments": 12,
          "shares": 23,
          "avg_read_time_seconds": 240,
          "bounce_rate": 0.35
        }
      }
    ],
    "cache_timestamp": "2025-11-09T12:00:00Z"
  }
}
```

**2. Community Health Dashboard API**

```ruby
# GET /api/custom/analytics/community/health
# Authentication: Requires admin role
# Returns: Community-wide health metrics

Request Headers:
  Authorization: Bearer <admin_session_token>

Query Parameters:
  date_range: string (optional, default: '30d')

Response (200 OK):
{
  "success": true,
  "data": {
    "growth": {
      "dau": 245,
      "wau": 1234,
      "mau": 4567,
      "dau_trend": "+12%",
      "new_users_today": 23
    },
    "engagement": {
      "posts_per_day": 8.5,
      "comments_per_post": 3.2,
      "reaction_rate": 0.15,
      "avg_session_duration_seconds": 420
    },
    "retention": {
      "day_7_return_rate": 0.42,
      "day_30_return_rate": 0.28
    },
    "conversion": {
      "anyon_cta_clicks": 234,
      "anyon_project_links_clicked": 156,
      "estimated_trial_signups": 35
    },
    "traffic": {
      "top_posts": [...],
      "top_authors": [...],
      "top_referrers": [...],
      "top_search_keywords": [...]
    }
  }
}
```

**3. A/B Test Management API**

```ruby
# POST /api/custom/analytics/ab_tests
# Authentication: Requires admin role
# Creates a new A/B test

Request Body:
{
  "name": "Header CTA Copy Test",
  "variants": [
    {
      "name": "control",
      "description": "Try ANYON",
      "traffic_percentage": 50
    },
    {
      "name": "treatment",
      "description": "Build with ANYON",
      "traffic_percentage": 50
    }
  ],
  "goal_event": "anyon_cta_click",
  "duration_days": 14
}

Response (201 Created):
{
  "success": true,
  "data": {
    "test_id": "abc123",
    "status": "running",
    "started_at": "2025-11-09T12:00:00Z",
    "end_at": "2025-11-23T12:00:00Z"
  }
}

# GET /api/custom/analytics/ab_tests/:id/results
# Returns: Test results with statistical significance

Response (200 OK):
{
  "success": true,
  "data": {
    "test_id": "abc123",
    "status": "completed",
    "winner": "treatment",
    "confidence": 0.95,
    "variants": [
      {
        "name": "control",
        "impressions": 5000,
        "conversions": 75,
        "conversion_rate": 0.015
      },
      {
        "name": "treatment",
        "impressions": 5000,
        "conversions": 120,
        "conversion_rate": 0.024
      }
    ]
  }
}
```

**External API Integrations**

**1. Google Analytics 4 Reporting API**

```javascript
// Fetch pageview data
{
  "property": "properties/123456789",
  "dateRanges": [{ "startDate": "30daysAgo", "endDate": "today" }],
  "dimensions": [{ "name": "pagePath" }],
  "metrics": [
    { "name": "screenPageViews" },
    { "name": "activeUsers" }
  ]
}
```

**2. Google Search Console API**

```javascript
// Fetch keyword rankings and CTR
{
  "siteUrl": "https://vibecoding.community",
  "startDate": "2025-10-10",
  "endDate": "2025-11-09",
  "dimensions": ["query", "page"],
  "rowLimit": 100
}
```

**Frontend Event Tracking Interface**

```javascript
// GTM dataLayer.push() for custom events
window.dataLayer = window.dataLayer || [];
window.dataLayer.push({
  event: 'anyon_cta_click',
  cta_location: 'header',
  user_id: '12345'
});

// Direct GA4 event (alternative to GTM)
window.gtag('event', 'post_view', {
  post_id: '67890',
  author_id: '11111',
  post_category: 'tutorial'
});
```

### Workflows and Sequencing

**Workflow 1: Real-Time Event Tracking**

```
User Action (e.g., clicks ANYON CTA)
    ↓
Frontend Event Handler
    ↓
GTM dataLayer.push({event: 'anyon_cta_click', ...})
    ↓
    ├─→ GA4 (for behavioral analytics)
    │   └─→ Stored in GA4 cloud
    │
    └─→ Optional: Server-side tracking
        └─→ POST /api/custom/analytics/track
            └─→ Vibecoding::AnalyticsTracker.call(user, event_type, metadata)
                └─→ INSERT INTO vibecoding_analytics
                └─→ Rails.logger.info("VIBECODING: Analytics - ...")
```

**Workflow 2: Author Dashboard Load**

```
Author visits /dashboard/analytics
    ↓
ContentPerformanceDashboard (Preact component) renders
    ↓
GET /api/custom/analytics/author/dashboard?date_range=30d
    ↓
Analytics::DashboardAPI controller
    ↓
Check Redis cache: "vibecoding:metrics:author:#{user_id}:30d:*"
    ↓
    ├─→ Cache HIT
    │   └─→ Return cached data (fast path)
    │
    └─→ Cache MISS
        └─→ Analytics::MetricsCacheService.compute_author_metrics(user_id, date_range)
            ├─→ Query vibecoding_analytics table
            ├─→ Query Forem articles table (views, reactions)
            ├─→ Call GA4 Reporting API (avg read time, bounce rate)
            └─→ Aggregate results
            └─→ Cache in Redis (TTL: 1 hour)
            └─→ Return JSON response
    ↓
Dashboard renders charts with Chart.js
```

**Workflow 3: Community Health Monitoring (Background Job)**

```
Sidekiq Scheduler (runs every hour)
    ↓
CommunityHealthJob.perform_async
    ↓
    ├─→ Calculate DAU/WAU/MAU
    │   └─→ SELECT COUNT(DISTINCT user_id) FROM sessions WHERE ...
    │
    ├─→ Calculate engagement metrics
    │   └─→ Query articles, comments, reactions tables
    │
    ├─→ Fetch GA4 data
    │   └─→ GA4 Reporting API (traffic sources, top pages)
    │
    └─→ Check alert thresholds
        └─→ IF (dau_drop > 20%) THEN AlertService.send_alert("DAU dropped 20%")
    ↓
Store computed metrics in Redis cache
    ↓
Log completion: Rails.logger.info("VIBECODING: Analytics - Health metrics updated")
```

**Workflow 4: SEO Performance Monitoring (Daily Job)**

```
Sidekiq Scheduler (runs daily at 8:00 AM)
    ↓
SEOMonitoringJob.perform_async
    ↓
    ├─→ Fetch keyword rankings from Google Search Console API
    │   └─→ Target keywords: "vibecoding", "ANYON", "AI app builder"
    │   └─→ Store in vibecoding_analytics (event_type: 'seo_ranking')
    │
    ├─→ Fetch organic traffic data from GA4
    │   └─→ Query: organic search sessions, CTR
    │
    ├─→ Fetch backlink data (if Ahrefs/SEMrush API available)
    │   └─→ Store backlink count, domain authority
    │
    └─→ Compare to previous period
        └─→ IF (keyword_ranking improved > 5 positions) THEN
            └─→ Rails.logger.info("VIBECODING: Analytics - 'vibecoding' ranked up!")
    ↓
Cache results in Redis ("vibecoding:metrics:seo:#{date}:*")
    ↓
Send weekly email report to team (optional)
```

**Workflow 5: A/B Test Execution**

```
Admin creates A/B test via admin panel
    ↓
POST /api/custom/analytics/ab_tests
    ↓
ABTestManager.create_test(config)
    ↓
Store test config in database (ab_tests table)
    ↓
Frontend loads test assignment:
    ├─→ User visits page with A/B tested element
    │   └─→ JavaScript checks: ABTestService.getVariant(test_id, user_id)
    │       └─→ Hash user_id + test_id → assign variant (deterministic)
    │       └─→ Return "control" or "treatment"
    │
    └─→ Render appropriate variant (e.g., "Try ANYON" vs "Build with ANYON")
    ↓
User interacts with variant (e.g., clicks CTA)
    ↓
Track conversion event → GA4
    ↓
ABTestManager.record_conversion(test_id, user_id, variant)
    ↓
After test duration completes (14 days):
    ↓
ABTestManager.analyze_results(test_id)
    ├─→ Calculate conversion rates per variant
    ├─→ Run statistical significance test (Chi-square or Bayesian)
    └─→ Determine winner (if significant)
    ↓
Notify admin: "Test completed. Treatment won with 95% confidence."
```

**Sequence Diagram: End-to-End ANYON Conversion Tracking**

```
User                Frontend            GTM/GA4         Rails API          Database
 |                      |                  |               |                  |
 |--Click ANYON CTA---->|                  |               |                  |
 |                      |                  |               |                  |
 |                      |--dataLayer.push->|               |                  |
 |                      |                  |               |                  |
 |                      |                  |--GA4 event--->| (GA4 cloud)      |
 |                      |                  |               |                  |
 |                      |--POST /track---->|               |                  |
 |                      |                  |               |                  |
 |                      |                  |               |--AnalyticsTracker|
 |                      |                  |               |                  |
 |                      |                  |               |--INSERT--------->|
 |                      |                  |               |                  |
 |                      |<--200 OK---------|               |                  |
 |                      |                  |               |                  |
 |--Redirected to ANYON signup page (with UTM params)----->|                  |
 |                      |                  |               |                  |
 | (Later: Admin views dashboard)          |               |                  |
 |                      |                  |               |                  |
Admin                   Dashboard UI       |               Rails API          |
 |                      |                  |               |                  |
 |--View health dash--->|                  |               |                  |
 |                      |                  |               |                  |
 |                      |--GET /health---->|               |                  |
 |                      |                  |               |                  |
 |                      |                  |               |--Check Redis---->|
 |                      |                  |               |<--Cache MISS-----|
 |                      |                  |               |                  |
 |                      |                  |               |--Query DB------->|
 |                      |                  |               |<--Results--------|
 |                      |                  |               |                  |
 |                      |                  |               |--Cache Redis---->|
 |                      |                  |               |                  |
 |                      |<--JSON metrics---|               |                  |
 |                      |                  |               |                  |
 |<--Rendered charts----|                  |               |                  |
```

## Non-Functional Requirements

### Performance

**Dashboard Load Times:**
- Author dashboard: < 2 seconds for initial load (p95)
- Admin health dashboard: < 3 seconds for initial load (p95)
- Cached dashboard requests: < 500ms (p95)
- Dashboard API responses: < 1 second (p95)

**Tracking Performance:**
- GA4 event tracking: Non-blocking (async, no impact on page load)
- Server-side tracking: < 100ms overhead (p95)
- Background jobs: Process within 5 minutes of scheduled time

**Data Freshness:**
- Author dashboard metrics: Updated hourly (1-hour cache TTL)
- Community health metrics: Updated hourly via background job
- SEO metrics: Updated daily (24-hour refresh)
- Real-time events: Tracked immediately to GA4 and database

**Scalability Targets:**
- Support 10,000+ events per hour without degradation
- Dashboard queries optimized for 10,000+ posts
- Redis cache: Handle 1,000+ concurrent dashboard requests
- GA4 API rate limits: Respect 10 requests per second limit

**Implementation Approach:**
- Redis caching with 1-hour TTL reduces database load by 90%+
- Database indexes on `event_type`, `tracked_at`, composite indexes
- Sidekiq background jobs for expensive computations (DAU/WAU/MAU calculations)
- GA4 Reporting API batching for multiple metric requests
- Chart.js client-side rendering (keep server responses JSON-only)

### Security

**Authentication & Authorization:**
- Author dashboard: Requires authenticated user session
- Admin dashboards: Requires admin role (Pundit policy check)
- API endpoints: CSRF protection on all POST/PUT/DELETE requests
- GA4 API credentials: Stored as encrypted environment variables
- Google Search Console API: OAuth 2.0 service account credentials

**Data Privacy:**
- GA4 IP anonymization enabled (GDPR compliance)
- Cookie consent banner for EU users (load GTM only after consent)
- User-level analytics data: Access restricted to user's own data
- Admin access logging: All admin dashboard views logged for audit

**Sensitive Data Protection:**
- No PII (personally identifiable information) stored in `vibecoding_analytics`
- Event metadata sanitized (no email addresses, passwords, tokens)
- API keys and credentials: Never exposed in frontend code
- Redis cache: No sensitive user data cached (only aggregated metrics)

**Rate Limiting:**
- Dashboard API: 60 requests per minute per user
- Tracking API: 1000 events per hour per user (prevent abuse)
- Admin API: 120 requests per minute (higher limit for dashboards)

**Third-Party Security:**
- GA4: Google-managed, SOC 2 compliant
- Google Search Console: OAuth with minimal scope (readonly analytics)
- GTM: Container hosted on Google CDN, verified container ID

**Monitoring:**
- Failed authentication attempts logged and alerted
- Unusual API access patterns (admin endpoints from new IPs)
- GA4 API quota exhaustion alerts

### Reliability/Availability

**Availability Targets:**
- GA4 tracking: 99.9% availability (Google SLA)
- Dashboard APIs: 99.5% availability (tolerate occasional cache misses)
- Background jobs: 99% completion rate (retry on failure)

**Failure Modes & Graceful Degradation:**

1. **GA4 API Unavailable:**
   - Dashboard shows cached data with "Data may be delayed" notice
   - Tracking continues to database (GA4 events queued if needed)
   - Alert sent to team if GA4 unavailable > 1 hour

2. **Redis Cache Unavailable:**
   - Fall back to direct database queries (slower but functional)
   - Log warning: "VIBECODING: Analytics - Redis unavailable, using DB"
   - Dashboard load times increase to 3-5 seconds

3. **Database Unavailable:**
   - Dashboard returns error with retry prompt
   - Tracking events queued in Sidekiq for retry
   - Critical alert sent to on-call engineer

4. **Google Search Console API Failure:**
   - SEO dashboard shows last successful data with timestamp
   - Background job retries 3 times with exponential backoff
   - Manual refresh option available to admin

**Error Handling:**
- All service objects inherit from `Anyon::BaseService` with standardized error handling
- Sentry captures all exceptions with context (user_id, event_type, etc.)
- Errors logged with structured format: `Rails.logger.error("VIBECODING: Analytics - ...")`

**Retry Logic:**
- Background jobs: 3 retries with exponential backoff (1min, 10min, 1hour)
- GA4 API calls: 2 retries with 5-second delay
- Database queries: No retry (fail fast, alert)

**Data Integrity:**
- `vibecoding_analytics` table: Foreign key constraints with CASCADE delete
- Event deduplication: Check for duplicate events within 60-second window
- GA4 data validation: Verify event schema before sending

### Observability

**Logging:**

All analytics operations logged with structured format:

```ruby
Rails.logger.info(
  "VIBECODING: Analytics - Event tracked",
  user_id: user.id,
  event_type: "anyon_cta_click",
  metadata: { cta_location: "header" },
  timestamp: Time.current
)

Rails.logger.error(
  "VIBECODING: Analytics - GA4 API failed",
  error: e.message,
  ga4_property: ENV['GA4_PROPERTY_ID'],
  retry_attempt: 1
)
```

**Log Levels:**
- `debug`: Individual event tracking, cache hits/misses
- `info`: Dashboard loads, background job completion, successful API calls
- `warn`: Cache unavailable, API rate limit approaching, degraded mode
- `error`: API failures, database errors, tracking failures

**Metrics (via Sentry or APM):**

Key metrics tracked:
- `analytics.event.tracked` - Counter of events tracked per type
- `analytics.dashboard.load_time` - Histogram of dashboard load times
- `analytics.api.ga4.response_time` - GA4 API call duration
- `analytics.cache.hit_rate` - Redis cache hit percentage
- `analytics.background_job.duration` - Sidekiq job processing time

**Alerts:**

Critical alerts (PagerDuty/Slack):
- Database unavailable for analytics writes
- GA4 API quota exhausted
- Background jobs failing > 3 consecutive times
- Admin dashboard unavailable > 5 minutes

Warning alerts (Slack only):
- Cache hit rate < 80% (indicates cache issues)
- Dashboard load time > 3 seconds p95
- SEO monitoring job failed (daily job)
- DAU dropped > 20% from previous day

**Dashboards:**

Operational dashboards (Datadog/Grafana):
1. **Analytics Health Dashboard:**
   - Events tracked per hour (by type)
   - Dashboard API response times
   - Cache hit rate
   - Background job queue depth

2. **GA4 Integration Dashboard:**
   - GA4 API calls per hour
   - GA4 API error rate
   - GA4 quota usage

3. **User Engagement Dashboard:**
   - Real-time event stream (last 100 events)
   - Top events by type
   - User activity heatmap

## Dependencies and Integrations

{{dependencies_integrations}}

## Acceptance Criteria (Authoritative)

{{acceptance_criteria}}

## Traceability Mapping

{{traceability_mapping}}

## Risks, Assumptions, Open Questions

{{risks_assumptions_questions}}

## Test Strategy Summary

{{test_strategy}}
