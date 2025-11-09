# Epic Technical Specification: ANYON Integration & Conversion Funnel

Date: 2025-11-09
Author: JSup
Epic ID: 2
Status: Draft

---

## Overview

Epic 2 implements the core business objective of converting Vibecoding Community members into ANYON users through strategic CTA placement, project linking capabilities, and comprehensive conversion tracking. This epic creates a measurable community → ANYON trial funnel with full analytics to track ROI.

**Key Deliverables:**
- Strategically placed ANYON CTAs throughout the platform (header, sidebar, footer, post-signup)
- ANYON project linking in posts and user profiles with visual badges
- Comprehensive conversion tracking via Google Analytics 4 and custom events
- "Built with ANYON" post template to encourage high-quality project showcases
- UTM-tracked links for attribution across all touchpoints

**Business Impact:** Directly supports revenue generation by creating seamless pathways from community engagement to ANYON adoption. Provides visibility into community ROI through conversion metrics, enabling data-driven optimization of the funnel. This epic transforms the community from passive content platform to active ANYON growth engine.

## Objectives and Scope

### In-Scope

**Story 2.1: ANYON CTA Strategic Placement**
- Header "Try ANYON" button visible on all pages
- Sidebar "Build with ANYON" widget on post pages
- Footer "Powered by ANYON" branding with link
- Post-signup optional ANYON account linking prompt
- UTM tracking parameters on all CTAs
- Click event tracking in Google Analytics 4
- Non-intrusive design (no popups or modals)

**Story 2.2: ANYON Project Linking in Posts**
- Optional "ANYON Project URL" field in post editor
- URL format validation
- "ANYON Project" badge on posts with projects
- "View Project" link with UTM tracking
- Visual distinction for ANYON-powered posts
- Filterable by tag (#anyon shows all ANYON projects)
- Click tracking to ANYON projects

**Story 2.3: ANYON Project Linking in User Profiles**
- "ANYON Project Links" field supporting multiple URLs
- Profile displays list of linked projects with titles
- "Built with ANYON" indicator on profiles
- UTM tracking on profile project links
- Projects section prominently displayed

**Story 2.4: Conversion Tracking & Analytics Setup**
- Google Analytics 4 custom events for CTA clicks
- UTM parameter consistency across all links
- Conversion funnel definition in GA4
- Custom dashboards for community metrics
- Monthly reports on ANYON CTA clicks and conversion rates
- Top converting posts/authors analysis
- GDPR-compliant cookie consent for EU users

**Story 2.5: "Built with ANYON" Post Template**
- Structured template for ANYON project showcases
- Pre-populated sections (Problem, Why ANYON, The Build, Results, Lessons)
- Auto-suggests tags (#anyon, #project-showcase, #vibecoding)
- Inline help text and examples
- Integration with ANYON project URL field
- Visual highlighting for showcase posts

### Out-of-Scope

- ANYON OAuth single sign-on (deferred to post-MVP Phase 2)
- Embedded ANYON project viewer (live iframe embeds - Phase 2)
- "Import ANYON project" auto-create feature (Phase 2)
- ANYON API integration for project metadata/thumbnails (Phase 2)
- Video upload/hosting for tutorials (Epic 4 uses YouTube embeds)
- Advanced analytics dashboards beyond GA4 (Epic 5)
- A/B testing infrastructure (Epic 5.4)
- Referral program/gamification (Phase 2 Growth Features)

## System Architecture Alignment

### Architecture Constraints

**Brownfield Customization Strategy (ADR-001):**
- Extend Forem models using concerns (Pattern 1)
- Namespace all custom code under `anyon/` or `vibecoding/` (Pattern 2)
- Use Service Object pattern for business logic (Pattern 3)
- Preact components for frontend (Pattern 4)
- Commented database migrations (Pattern 5)

**Referenced Architecture Components:**

**Database Modifications (Architecture: Data Architecture):**
- Add `anyon_project_url` column to `articles` table (Story 2.2)
- Add `anyon_projects` JSONB column to `users` table (Story 2.3)
- Create `vibecoding_analytics` table for custom metrics (Story 2.4)

**Custom Services (Architecture: Epic 2 Mapping):**
- `Anyon::ConversionTracker` - Track ANYON conversion events
- `Anyon::ProjectLinker` - Validate and manage project links

**Frontend Components (Architecture: Pattern 4):**
- `AnyonCTA.jsx` - Reusable CTA button with tracking
- `AnyonProjectBadge.jsx` - Visual indicator for ANYON projects

**External Integrations (Architecture: Technology Stack):**
- Google Analytics 4 - Core analytics
- Google Tag Manager - Flexible event tracking

**Consistency Rules Applied:**
- File naming: `anyon/conversion_tracker.rb` (snake_case, namespaced)
- Database columns: `anyon_project_url` (prefixed, snake_case)
- Database tables: `vibecoding_analytics` (prefixed, plural)
- Git commits: `[VIBECODING]` prefix
- Logging: `Rails.logger.info("VIBECODING: ...")` format
- CSS classes: `.vibecoding-cta` or use Crayons classes

## Detailed Design

### Services and Modules

| Module/Service | Responsibility | Inputs | Outputs | Owner |
|----------------|----------------|--------|---------|-------|
| **Anyon::ConversionTracker** | Track ANYON conversion events (CTA clicks, project links, signups) | User, event_type, metadata | GA4 events, database records | Backend |
| **Anyon::ProjectLinker** | Validate and manage ANYON project URLs | URL string | Validated URL or error | Backend |
| **AnyonCTA Component (Preact)** | Render ANYON CTA buttons with tracking | location, className, ctaText | Tracked CTA button HTML | Frontend |
| **AnyonProjectBadge Component** | Display ANYON project indicator on posts | project_url, badge_style | Badge HTML with link | Frontend |
| **GA4 Tracker (JavaScript)** | Send custom events to Google Analytics | event_name, event_properties | GA4 event recorded | Frontend |
| **CTA Placement Service** | Inject CTAs into layout templates | location (header/sidebar/footer) | Rendered CTA in appropriate location | Frontend |
| **Post Template Service** | Provide structured ANYON showcase template | template_name | Pre-populated markdown template | Backend |
| **Analytics Dashboard Service** | Generate conversion reports from GA4 data | date_range, filters | Report with metrics (CTR, conversions) | Backend/Analytics |

**Implementation Notes:**
- All services follow Architecture Pattern 3 (Service Object pattern)
- Services inherit from `Anyon::BaseService` with standardized error handling
- Frontend components use Preact (not React) per Architecture Pattern 4
- All tracking respects user privacy settings and GDPR consent

### Data Models and Contracts

#### Database Schema Changes

**1. Articles Table Extension (Story 2.2)**

```sql
-- Migration: db/migrate/20250109_add_anyon_project_url_to_articles.rb
ALTER TABLE articles ADD COLUMN anyon_project_url VARCHAR(2048);
CREATE INDEX idx_articles_anyon_project_url ON articles(anyon_project_url) WHERE anyon_project_url IS NOT NULL;
COMMENT ON COLUMN articles.anyon_project_url IS 'VIBECODING: Optional ANYON project URL for showcase posts';
```

**Schema:**
- **Column:** `anyon_project_url`
- **Type:** `VARCHAR(2048)` (nullable)
- **Validation:** URI format, HTTPS only
- **Index:** Partial index (non-null values only)
- **Relationships:** N/A (self-contained column)

**2. Users Table Extension (Story 2.3)**

```sql
-- Migration: db/migrate/20250109_add_anyon_projects_to_users.rb
ALTER TABLE users ADD COLUMN anyon_projects JSONB DEFAULT '[]';
CREATE INDEX idx_users_anyon_projects ON users USING gin(anyon_projects);
COMMENT ON COLUMN users.anyon_projects IS 'VIBECODING: Array of ANYON project links with metadata';
```

**Schema:**
- **Column:** `anyon_projects`
- **Type:** `JSONB` (array of objects)
- **Default:** `[]` (empty array)
- **Index:** GIN index for JSONB queries
- **Structure:**
  ```json
  [
    {
      "title": "My SaaS Platform",
      "url": "https://anyon.app/projects/abc123",
      "added_at": "2025-01-09T12:00:00Z"
    }
  ]
  ```

**3. VibeCodingAnalytic Model (Story 2.4)**

```sql
-- Migration: db/migrate/20250109_create_vibecoding_analytics.rb
CREATE TABLE vibecoding_analytics (
  id BIGSERIAL PRIMARY KEY,
  user_id BIGINT REFERENCES users(id) ON DELETE CASCADE,
  event_type VARCHAR(255) NOT NULL,
  event_data JSONB,
  tracked_at TIMESTAMP NOT NULL DEFAULT NOW(),
  created_at TIMESTAMP NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_vibecoding_analytics_user_id ON vibecoding_analytics(user_id);
CREATE INDEX idx_vibecoding_analytics_event_type ON vibecoding_analytics(event_type);
CREATE INDEX idx_vibecoding_analytics_tracked_at ON vibecoding_analytics(tracked_at);
CREATE INDEX idx_vibecoding_analytics_event_data ON vibecoding_analytics USING gin(event_data);
```

**Entity: VibeCodingAnalytic**

| Field | Type | Constraints | Description |
|-------|------|-------------|-------------|
| id | BIGINT | PRIMARY KEY | Auto-incrementing ID |
| user_id | BIGINT | FOREIGN KEY (users), ON DELETE CASCADE, nullable | Associated user (null for anonymous) |
| event_type | VARCHAR(255) | NOT NULL | Event name (cta_click, project_linked, etc.) |
| event_data | JSONB | nullable | Additional event metadata |
| tracked_at | TIMESTAMP | NOT NULL, DEFAULT NOW() | When event occurred |
| created_at | TIMESTAMP | NOT NULL | Record creation timestamp |
| updated_at | TIMESTAMP | NOT NULL | Record update timestamp |

**Event Types:**
- `cta_click_header` - Header CTA clicked
- `cta_click_sidebar` - Sidebar CTA clicked
- `cta_click_footer` - Footer CTA clicked
- `project_linked_post` - ANYON project added to post
- `project_linked_profile` - ANYON project added to profile
- `project_view` - ANYON project link clicked

**Example event_data:**
```json
{
  "location": "header",
  "campaign": "launch",
  "post_id": 123,
  "referrer": "/tags/vibecoding"
}
```

#### Model Concerns (Forem Extension Pattern)

**app/models/concerns/anyon_trackable.rb**

```ruby
# VIBECODING CUSTOMIZATION
# Epic 2 - ANYON Integration
# Adds ANYON tracking behavior to Article and User models

module AnyonTrackable
  extend ActiveSupport::Concern

  included do
    # Validate ANYON project URL format
    validates :anyon_project_url,
              format: { with: URI::DEFAULT_PARSER.make_regexp(['https']), allow_blank: true },
              length: { maximum: 2048 }

    # Track when ANYON project is linked
    after_save :track_anyon_project_link, if: :anyon_project_url_changed?
  end

  def has_anyon_project?
    anyon_project_url.present?
  end

  def anyon_project_domain
    return nil unless has_anyon_project?
    URI.parse(anyon_project_url).host
  rescue URI::InvalidURIError
    nil
  end

  private

  def track_anyon_project_link
    Anyon::ConversionTracker.new(user, 'project_linked_post', {
      article_id: id,
      project_url: anyon_project_url
    }).track!
  end
end

# Initialize in config/initializers/vibecoding_customizations.rb
Article.include AnyonTrackable
```

#### Data Validation Rules

**ANYON Project URL Validation:**
- Must be HTTPS (security requirement)
- Maximum 2048 characters
- Must be valid URI format
- Should match ANYON domain pattern (optional - can link to deployed projects too)
- Empty/nil allowed (optional field)

**User ANYON Projects JSON Validation:**
- Must be valid JSON array
- Each element must have `title` (string, max 200 chars) and `url` (valid HTTPS URI)
- Maximum 10 projects per user (prevent abuse)
- `added_at` timestamp auto-generated if not provided

### APIs and Interfaces

#### Custom API Endpoints (Story 2.4)

**Endpoint 1: Track Conversion Event**

```
POST /api/custom/anyon/track_conversion
```

**Authentication:** Requires logged-in user (optional: allow anonymous with fingerprint)

**Request:**
```json
{
  "event_type": "cta_click_header",
  "metadata": {
    "location": "header",
    "campaign": "mvp_launch",
    "referrer": "/tags/vibecoding"
  }
}
```

**Response (Success - 201 Created):**
```json
{
  "success": true,
  "data": {
    "id": 12345,
    "event_type": "cta_click_header",
    "tracked_at": "2025-01-09T12:34:56Z"
  }
}
```

**Response (Error - 422 Unprocessable Entity):**
```json
{
  "success": false,
  "error": {
    "code": "invalid_event_type",
    "message": "Event type must be one of: cta_click_header, cta_click_sidebar, cta_click_footer, project_linked_post, project_linked_profile"
  }
}
```

**Rate Limiting:** 100 requests per hour per user (prevent spam)

---

**Endpoint 2: Validate ANYON Project URL**

```
POST /api/custom/anyon/validate_project_url
```

**Authentication:** Requires logged-in user

**Request:**
```json
{
  "url": "https://anyon.app/projects/abc123"
}
```

**Response (Valid - 200 OK):**
```json
{
  "valid": true,
  "url": "https://anyon.app/projects/abc123",
  "domain": "anyon.app"
}
```

**Response (Invalid - 422 Unprocessable Entity):**
```json
{
  "valid": false,
  "error": "URL must be HTTPS"
}
```

---

#### Forem Admin Panel Extensions (Story 2.5)

**Article Templates Section:**
- Path: `/admin/customization/article_templates`
- Action: Create "Built with ANYON" template
- UI: Admin form with template name, body (Markdown), auto-suggest tags

**Configuration Section:**
- Path: `/admin/customization/config`
- New Fields:
  - `anyon_signup_url` (string) - Base ANYON signup URL
  - `anyon_cta_enabled` (boolean) - Toggle CTAs on/off
  - `anyon_cta_text` (string) - Customize CTA button text (default: "Try ANYON")

#### Frontend Component Interfaces

**AnyonCTA Component**

```jsx
// app/javascript/custom/AnyonCTA.jsx
import { h } from 'preact';

/**
 * VIBECODING: ANYON CTA Button
 *
 * @param {string} location - CTA location (header, sidebar, footer)
 * @param {string} className - Additional CSS classes
 * @param {string} ctaText - Button text (default: "Try ANYON")
 * @returns Preact component
 */
export const AnyonCTA = ({ location, className = '', ctaText = 'Try ANYON' }) => {
  // Implementation in Detailed Design section
};
```

**AnyonProjectBadge Component**

```jsx
// app/javascript/custom/AnyonProjectBadge.jsx
import { h } from 'preact';

/**
 * VIBECODING: ANYON Project Badge
 *
 * @param {string} projectUrl - ANYON project URL
 * @param {string} badgeStyle - Badge style (small, medium, large)
 * @returns Preact component
 */
export const AnyonProjectBadge = ({ projectUrl, badgeStyle = 'medium' }) => {
  // Implementation in Detailed Design section
};
```

### Workflows and Sequencing

#### Workflow 1: User Clicks ANYON CTA (Story 2.1)

```
1. User visits any page
   └─> Page renders with AnyonCTA component

2. User hovers over "Try ANYON" button
   └─> Visual feedback (color change, cursor)

3. User clicks "Try ANYON"
   ├─> onClick handler triggered
   ├─> GTM dataLayer.push({ event: 'anyon_cta_click', location: 'header' })
   ├─> POST /api/custom/anyon/track_conversion (async, non-blocking)
   └─> Window opens new tab: https://anyon.app/signup?utm_source=community&utm_medium=cta&utm_campaign=header

4. GA4 receives event
   └─> Records event with timestamp, user_id (if logged in), location

5. Database records event (async)
   └─> VibeCodingAnalytic.create(user_id, event_type: 'cta_click_header', event_data: {...})
```

**Sequence Diagram:**
```
User -> Browser: Click "Try ANYON"
Browser -> GTM: dataLayer.push(event)
GTM -> GA4: Send custom event
Browser -> API: POST /api/custom/anyon/track_conversion
API -> VibeCodingAnalytic: Create record
API -> User: 201 Created (async)
Browser -> ANYON: Open https://anyon.app/signup?utm_...
ANYON -> User: Signup page
```

**Error Handling:**
- If API fails, still open ANYON signup (tracking is non-blocking)
- Log error to Sentry for investigation
- Retry tracking event once on failure

---

#### Workflow 2: Author Links ANYON Project in Post (Story 2.2)

```
1. Author creates/edits post
   └─> Navigate to /new or /articles/:id/edit

2. Author fills post content (title, body, tags)

3. Author expands "ANYON Project" section
   └─> Optional field labeled "ANYON Project URL"

4. Author enters project URL
   └─> Input: "https://anyon.app/projects/abc123"

5. Client-side validation (on blur)
   ├─> Check HTTPS protocol
   ├─> Check valid URI format
   └─> Show ✓ or ✗ indicator

6. Author clicks "Publish"
   ├─> POST /articles with anyon_project_url field
   └─> Server-side validation

7. Server validates URL
   ├─> Format validation (URI regex)
   ├─> Length check (< 2048 chars)
   └─> HTTPS enforcement

8. Save article
   ├─> Article.create(title, body, anyon_project_url, ...)
   └─> Trigger after_save callback

9. Track project link event
   └─> Anyon::ConversionTracker.track!(user, 'project_linked_post', { article_id, project_url })

10. Render published post
    ├─> Display "ANYON Project" badge
    ├─> Show "View Project" button with UTM tracking
    └─> Visual distinction (border, icon, or highlight)
```

**Sequence Diagram:**
```
Author -> PostEditor: Enter ANYON project URL
PostEditor -> Client: Validate URL format
Client -> PostEditor: ✓ Valid
Author -> PostEditor: Click "Publish"
PostEditor -> API: POST /articles { anyon_project_url: "..." }
API -> Article: Create/Update record
Article -> AnyonTrackable: Trigger after_save callback
AnyonTrackable -> ConversionTracker: Track event
ConversionTracker -> GA4: Send event
ConversionTracker -> DB: Store event
API -> Author: 201 Created, redirect to post
Author -> PostView: View published post
PostView -> Author: Display with ANYON badge
```

**Data Flow:**
```
Input: https://anyon.app/projects/abc123
  ↓
Validation: HTTPS? Valid URI? Length OK?
  ↓
Storage: articles.anyon_project_url = "https://anyon.app/projects/abc123"
  ↓
Rendering: <AnyonProjectBadge projectUrl="..." />
  ↓
Click: Open https://anyon.app/projects/abc123?utm_source=community&utm_medium=project_link
```

---

#### Workflow 3: User Adds ANYON Projects to Profile (Story 2.3)

```
1. User navigates to profile settings
   └─> /settings/profile

2. User scrolls to "ANYON Projects" section

3. User clicks "Add ANYON Project"
   └─> Expands input form with fields: Title, URL

4. User fills form
   ├─> Title: "My SaaS Platform"
   └─> URL: "https://anyon.app/projects/abc123"

5. User clicks "Add"
   ├─> Client validates: Title (non-empty), URL (HTTPS, valid)
   └─> POST /settings/profile with anyon_projects JSON

6. Server validates and saves
   ├─> Validate max 10 projects per user
   ├─> Validate each URL format
   ├─> Append to users.anyon_projects JSONB array
   └─> Track event: 'project_linked_profile'

7. Profile page displays projects
   ├─> "Built with ANYON" badge in profile header
   ├─> List of projects with titles and "View" links
   └─> UTM tracking on each project link
```

**Sequence Diagram:**
```
User -> ProfileSettings: Navigate to /settings/profile
ProfileSettings -> User: Display form
User -> ProfileSettings: Fill Title + URL, click "Add"
ProfileSettings -> API: POST /settings/profile { anyon_projects: [...] }
API -> User: Update anyon_projects JSONB
User -> ConversionTracker: Track 'project_linked_profile'
ConversionTracker -> GA4 + DB: Record event
API -> ProfileSettings: 200 OK
ProfileSettings -> User: Show success message
User -> PublicProfile: View own profile
PublicProfile -> User: Display projects with "Built with ANYON" badge
```

---

#### Workflow 4: Analytics Reporting (Story 2.4)

```
1. Admin/Analyst navigates to custom dashboard
   └─> /admin/analytics/anyon_funnel (custom page)

2. Dashboard loads metrics
   ├─> Query vibecoding_analytics table
   ├─> Aggregate by event_type, date
   └─> Calculate CTR, conversion rates

3. Display key metrics
   ├─> Total CTA clicks (by location: header, sidebar, footer)
   ├─> Total project links (posts + profiles)
   ├─> Top converting posts (articles with most clicks)
   ├─> Top authors (users driving most ANYON traffic)
   └─> Trend charts (daily/weekly clicks over time)

4. Export report
   └─> CSV download for further analysis

5. GA4 Integration
   ├─> View GA4 dashboard for real-time data
   ├─> Custom GA4 report: "ANYON Conversion Funnel"
   └─> Segments: Logged-in users, Anonymous visitors
```

**Data Flow:**
```
Admin Request → Dashboard Controller → VibeCodingAnalytic.where(event_type: 'cta_click_%')
                                                              ↓
                                                       Aggregate & Calculate
                                                              ↓
                                    ┌────────────────────────┴────────────────────┐
                                    ↓                                             ↓
                              Database Metrics                              GA4 API Metrics
                          (vibecoding_analytics)                    (Real-time events)
                                    ↓                                             ↓
                                    └────────────────────┬────────────────────────┘
                                                         ↓
                                                   JSON Response
                                                         ↓
                                               Render Dashboard View
```

## Non-Functional Requirements

### Performance

**Target Metrics (from PRD Section: Non-Functional Requirements):**

Epic 2 must not degrade overall platform performance. All ANYON integration features must be lightweight and non-blocking.

| Metric | Target | Measurement | Story Impact |
|--------|--------|-------------|--------------|
| **CTA Render Time** | < 50ms | Time to render AnyonCTA component | Story 2.1 |
| **CTA Click Response** | < 100ms | Time from click to new tab open | Story 2.1 |
| **Tracking API Response** | < 200ms p95 | POST /api/custom/anyon/track_conversion | Story 2.4 |
| **Post Editor Load Impact** | < 100ms additional load time | Adding ANYON project URL field | Story 2.2 |
| **Profile Load Impact** | < 150ms additional load time | Rendering ANYON projects section | Story 2.3 |
| **GA4 Event Latency** | < 500ms | GTM event → GA4 recording | Story 2.4 |
| **Page Load (with CTAs)** | No degradation from baseline | Lighthouse LCP < 2.5s maintained | All stories |

**Performance Optimization Strategies:**

**Story 2.1 - CTA Placement:**
- CTAs are pure Preact components (minimal JS)
- Use Crayons button classes (no custom CSS downloads)
- CTAs load with page (no lazy loading needed - they're critical)
- No external API calls on render (self-contained)

**Story 2.2 - Project Linking in Posts:**
- URL validation is client-side first (no server round-trip until publish)
- Server-side validation uses Rails built-in URI parser (fast)
- Badge rendering is conditional (only if `has_anyon_project?`)
- Partial index on `anyon_project_url` (only index non-null values)

**Story 2.3 - Profile Project Linking:**
- JSONB storage is efficient (single column, no joins)
- GIN index for fast JSONB queries
- Limit 10 projects per user (prevent profile bloat)
- Profile projects rendered server-side (no client fetch)

**Story 2.4 - Conversion Tracking:**
- Tracking is **asynchronous and non-blocking**
- If tracking fails, user experience continues unaffected
- Background job for batch analytics aggregation (avoid real-time queries)
- GA4 events sent via GTM (offloaded to Google infrastructure)
- Database writes use background jobs (Sidekiq)

**Caching Strategy:**
- Cache ANYON signup URL in Redis (avoid config lookup on every CTA render)
- Cache analytics dashboard queries for 5 minutes (admin view)
- No caching of user-specific data (privacy)

**Monitoring:**
- New Relic or Railway/Render APM for tracking API response times
- Lighthouse CI to ensure LCP/FCP targets maintained
- Custom performance metrics in GA4 (CTA render time, tracking latency)

---

### Security

**Epic 2 Security Requirements:**

**Authentication & Authorization:**

| Requirement | Implementation | Story |
|-------------|----------------|-------|
| **CTA Access** | Public (no auth required) | Story 2.1 |
| **Project Linking** | Requires authenticated user | Story 2.2, 2.3 |
| **Tracking API** | Authenticated preferred, anonymous allowed with rate limiting | Story 2.4 |
| **Admin Dashboard** | Requires admin role (Pundit policy) | Story 2.4 |

**Data Protection:**

**URL Validation & XSS Prevention (Story 2.2, 2.3):**
- **HTTPS Enforcement:** All ANYON project URLs must use HTTPS
- **URL Sanitization:** Use Rails `URI.parse` to validate and sanitize URLs
- **XSS Prevention:** URLs rendered with ERB auto-escaping or Preact (safe by default)
- **SQL Injection Prevention:** ActiveRecord parameterized queries (ORM protection)

```ruby
# app/models/concerns/anyon_trackable.rb
validates :anyon_project_url,
          format: { with: URI::DEFAULT_PARSER.make_regexp(['https']) },
          length: { maximum: 2048 }

# Safe rendering in views
<%= link_to "View Project", sanitize_url(@article.anyon_project_url), target: "_blank", rel: "noopener noreferrer" %>
```

**CSRF Protection:**
- All POST endpoints use Rails CSRF tokens (`protect_from_forgery with: :exception`)
- Tracking API endpoint respects CSRF tokens

**Rate Limiting (Story 2.4):**
- **Tracking API:** 100 requests/hour per user (prevent spam/abuse)
- **Project Linking:** 10 projects max per user (prevent profile spam)
- **CTA Clicks:** No rate limiting (tracking is informational, not transactional)

```ruby
# app/controllers/custom/anyon_integrations_controller.rb
class Custom::AnyonIntegrationsController < ApplicationController
  include RateLimitable

  rate_limit to: 100, within: 1.hour, only: [:track_conversion]
end
```

**GDPR Compliance (Story 2.4):**
- **Cookie Consent:** GA4 and GTM load only after user consent
- **User Data:** VibeCodingAnalytic tracks user_id but allows null for anonymous
- **Data Export:** Include `vibecoding_analytics` in user data export (Forem built-in)
- **Data Deletion:** Cascade delete analytics on user deletion (`ON DELETE CASCADE`)
- **Privacy Policy:** Update to mention ANYON conversion tracking

```javascript
// app/javascript/analytics/ga4_tracker.js
// Only initialize GA4 if consent given
if (getCookieConsent('analytics')) {
  initializeGA4();
}
```

**Secrets Management:**
- **ANYON Signup URL:** Store in environment variable `ANYON_SIGNUP_URL`
- **GA4 Measurement ID:** Store in `GA4_MEASUREMENT_ID` env var
- **GTM Container ID:** Store in `GTM_CONTAINER_ID` env var
- Never commit secrets to git

**UTM Parameter Security:**
- UTM parameters are informational only (no sensitive data)
- Sanitize referrer URLs to prevent leaking sensitive paths
- Use consistent UTM format across all links

**Admin Dashboard Security (Story 2.4):**
- Require admin role via Pundit policy
- No user PII displayed in analytics (only aggregated metrics)
- Export functionality rate-limited (prevent data scraping)

---

### Reliability/Availability

**Availability Impact:**

Epic 2 features are **non-critical enhancements**. If ANYON integration fails, core community functionality remains intact.

**Graceful Degradation Strategy:**

| Failure Scenario | Impact | Mitigation | User Experience |
|------------------|--------|------------|-----------------|
| **GA4 API Down** | Tracking events lost | Log to database, retry later | No impact - CTAs still work |
| **Tracking API Fails** | Events not recorded | Non-blocking async call, log error | No impact - user continues |
| **ANYON Signup URL Invalid** | CTAs lead to 404 | Health check, alert on failure | User sees error page, support notified |
| **Database Unavailable** | Tracking fails | Catch exception, log to Sentry | No impact - user continues |
| **GTM Script Blocked** | No analytics | Fallback to direct GA4 | Reduced tracking visibility |

**Reliability Measures:**

**Story 2.1 - CTA Placement:**
- CTAs are pure HTML/CSS (no external dependencies)
- If ANYON_SIGNUP_URL env var missing, disable CTAs gracefully
- Health check includes ANYON URL validation

**Story 2.2, 2.3 - Project Linking:**
- URL validation is defensive (handle malformed URLs gracefully)
- Database constraints prevent invalid data (HTTPS validation at DB level)
- If validation fails, show clear error message (don't silently fail)

**Story 2.4 - Conversion Tracking:**
- **Asynchronous Tracking:** Never block user actions waiting for tracking
- **Retry Logic:** Retry failed tracking events once (exponential backoff)
- **Circuit Breaker:** If GA4 API fails repeatedly, temporarily disable to prevent cascading failures
- **Database Fallback:** Always log to database even if GA4 fails

```ruby
# app/services/anyon/conversion_tracker.rb
def track!
  track_in_ga4
  store_in_database
rescue StandardError => e
  handle_error(e)
  # Don't re-raise - tracking failures should not break user flows
end
```

**Monitoring & Alerting:**

| Alert | Trigger | Action |
|-------|---------|--------|
| Tracking API Error Rate > 5% | Sentry threshold | Investigate, disable if critical |
| ANYON Signup URL 404 | Daily health check | Update env var, notify team |
| GA4 Events Drop to Zero | 1-hour window | Check GTM/GA4 integration |
| Database Analytics Table Growth > 1GB/day | Daily check | Review data retention policy |

**Data Retention:**
- `vibecoding_analytics` table: Retain 90 days, archive older (prevent unbounded growth)
- GA4: Standard retention (14 months)
- No automatic deletion (manual purge jobs)

---

### Observability

**Logging Strategy:**

**Structured Logging Format:**

All Epic 2 custom code uses structured logging with `"VIBECODING:"` prefix for easy filtering.

```ruby
# app/services/anyon/conversion_tracker.rb
Rails.logger.info(
  "VIBECODING: ANYON conversion tracked",
  user_id: @user&.id,
  event_type: @event_type,
  location: @metadata[:location],
  timestamp: Time.current.iso8601
)

Rails.logger.error(
  "VIBECODING: Tracking failed",
  user_id: @user&.id,
  event_type: @event_type,
  error: e.message,
  backtrace: e.backtrace.first(3)
)
```

**Key Logged Events:**

| Event | Log Level | Example |
|-------|-----------|---------|
| CTA clicked | info | `"VIBECODING: CTA clicked", location: "header", user_id: 123` |
| Project linked | info | `"VIBECODING: Project linked", article_id: 456, project_url: "..."` |
| Tracking API called | debug | `"VIBECODING: Tracking API called", event_type: "cta_click_header"` |
| Tracking failed | error | `"VIBECODING: Tracking failed", error: "GA4 API timeout"` |
| URL validation failed | warn | `"VIBECODING: Invalid URL", url: "http://...", reason: "Not HTTPS"` |
| Admin dashboard accessed | info | `"VIBECODING: Admin dashboard", admin_id: 789` |

**Metrics & Dashboards:**

**Application Metrics (Story 2.4):**

Track in `vibecoding_analytics` table + GA4:

- **CTA Click Rate:** Clicks per impression (calculate from pageviews)
- **Project Link Rate:** % of posts with ANYON projects
- **Conversion Funnel:** CTA Click → ANYON Signup (requires ANYON API integration - post-MVP)
- **Top Performing CTAs:** Header vs Sidebar vs Footer click rates
- **Top Converting Posts:** Articles that drive most ANYON traffic

**Custom GA4 Events:**

```javascript
// app/javascript/analytics/ga4_tracker.js
gtag('event', 'anyon_cta_click', {
  'event_category': 'ANYON Integration',
  'event_label': location, // header, sidebar, footer
  'value': 1
});

gtag('event', 'anyon_project_view', {
  'event_category': 'ANYON Integration',
  'event_label': 'project_link',
  'post_id': articleId
});
```

**Admin Dashboard Metrics (Story 2.4):**

Create custom admin page at `/admin/analytics/anyon_funnel`:

**Daily Metrics:**
- Total CTA clicks (broken down by location)
- Total project links added (posts + profiles)
- Unique users who clicked CTAs
- Click-through rate (CTR) by CTA location

**Weekly/Monthly Trends:**
- CTA click trend chart (line graph)
- Top 10 converting posts (table with article title, clicks, CTR)
- Top 10 authors driving ANYON traffic (leaderboard)

**Real-Time Metrics:**
- Last 100 CTA clicks (live feed)
- Recent project links (posts with ANYON projects)

**Error Tracking (Sentry):**

All Epic 2 errors tagged with `epic: 'anyon_integration'`:

```ruby
Sentry.capture_exception(error, extra: {
  epic: 'anyon_integration',
  story: '2.4',
  user_id: @user&.id,
  event_type: @event_type
})
```

**Alerts:**

| Alert | Trigger | Channel | Owner |
|-------|---------|---------|-------|
| Tracking API error rate > 10% | 5 errors in 10 minutes | Sentry → Slack | Backend |
| ANYON signup URL 404 | Health check failure | Email | DevOps |
| No GA4 events for 1 hour | Absence alert | Email | Analytics |
| Database analytics table > 10GB | Daily check | Email | DevOps |
| CTA click rate drop > 50% | Day-over-day comparison | Slack | Product |

**Monitoring Dashboards:**

**Railway/Render Dashboard:**
- Tracking API response time (p50, p95, p99)
- Tracking API error rate
- Background job queue depth (analytics aggregation)

**GA4 Dashboard:**
- Real-time ANYON conversion events
- Funnel visualization: Pageview → CTA Click → (ANYON Signup - post-MVP)
- User segments: Logged-in vs Anonymous

**Custom Admin Dashboard:**
- Conversion metrics (CTA clicks, project links)
- Top performing content
- Author leaderboard

## Dependencies and Integrations

### Ruby Dependencies (Gemfile)

**No New Gems Required for Epic 2**

All necessary Ruby dependencies already exist in Forem's Gemfile. Epic 2 leverages existing infrastructure:

**Existing Gems Used:**

| Gem | Version | Purpose in Epic 2 | Story |
|-----|---------|-------------------|-------|
| `rails` | ~> 7.0.8.4 | Web framework (controllers, models, migrations) | All |
| `pg` | ~> 1.4 | PostgreSQL adapter for database changes | 2.2, 2.3, 2.4 |
| `redis` | ~> 4.7.1 | Cache ANYON signup URL | 2.1 |
| `devise` | ~> 4.8 | User authentication for tracking API | 2.4 |
| `pundit` | ~> 2.2 | Authorization for admin dashboard | 2.4 |
| `rack-attack` | ~> 6.7.0 | Rate limiting on tracking API | 2.4 |
| `jbuilder` | ~> 2.11 | JSON API responses | 2.4 |

**No Additional Gems Needed:** Epic 2 uses pure Rails patterns (concerns, service objects, controllers) without external dependencies.

---

### JavaScript Dependencies (package.json)

**No New Packages Required for Epic 2**

All necessary JavaScript dependencies already exist in Forem's package.json.

**Existing Dependencies Used:**

| Package | Version | Purpose in Epic 2 | Story |
|---------|---------|-------------------|-------|
| `preact` | (existing) | Frontend components (AnyonCTA, AnyonProjectBadge) | 2.1, 2.2, 2.3 |
| `jest` | 28.1.3 | Unit testing for JavaScript components | All |
| `@testing-library/preact` | ^2.0.1 | Component testing | All |
| `cypress` | ^13.7.2 | E2E testing for CTA clicks, tracking | All |
| `eslint` | ^8.57.0 | JavaScript linting | All |

**External Scripts (CDN-loaded):**
- **Google Tag Manager:** Loaded via `<script>` tag in layout (no npm package)
- **Google Analytics 4:** Loaded via GTM (no npm package)

**Implementation Note:** GA4 and GTM are loaded via CDN scripts in the HTML `<head>`, not as npm dependencies. This is standard practice and aligns with Google's recommended integration.

---

### External Service Integrations

#### 1. Google Analytics 4 (GA4) - Story 2.4

**Purpose:** Track ANYON conversion events and user behavior

**Integration Type:** Client-side JavaScript via Google Tag Manager

**Configuration:**

| Setting | Value | Source |
|---------|-------|--------|
| **GA4 Measurement ID** | `G-XXXXXXXXXX` | Environment variable `GA4_MEASUREMENT_ID` |
| **Data Stream Name** | "Vibecoding Community" | GA4 Admin Console |
| **Event Tracking** | Custom events (anyon_cta_click, anyon_project_view) | GTM configuration |

**Setup Steps:**
1. Create GA4 property in Google Analytics
2. Create data stream for vibecoding community domain
3. Copy Measurement ID to `GA4_MEASUREMENT_ID` env var
4. Configure custom events in GA4 (or via GTM)
5. Set up conversion goals for ANYON CTA clicks

**API Usage:** None (client-side only via gtag.js)

**Cost:** Free (standard GA4 tier)

**Data Flow:**
```
User Action → GTM dataLayer.push() → GA4 gtag.js → Google Analytics
```

---

#### 2. Google Tag Manager (GTM) - Story 2.4

**Purpose:** Manage analytics tags and tracking events without code deploys

**Integration Type:** Client-side JavaScript container

**Configuration:**

| Setting | Value | Source |
|---------|-------|--------|
| **GTM Container ID** | `GTM-XXXXXXX` | Environment variable `GTM_CONTAINER_ID` |
| **Container Type** | Web | GTM Admin Console |
| **Workspace** | Default Workspace | GTM |

**Setup Steps:**
1. Create GTM container in Google Tag Manager
2. Copy Container ID to `GTM_CONTAINER_ID` env var
3. Add GTM snippet to `app/views/layouts/application.html.erb`
4. Configure GA4 tag in GTM (uses `GA4_MEASUREMENT_ID`)
5. Create custom event triggers for ANYON tracking

**Tags to Configure in GTM:**
- **GA4 Configuration Tag:** Base GA4 setup
- **ANYON CTA Click Event:** Trigger on `anyon_cta_click` dataLayer event
- **ANYON Project View Event:** Trigger on `anyon_project_view` dataLayer event

**API Usage:** None (client-side only)

**Cost:** Free

**Implementation:**
```html
<!-- app/views/layouts/application.html.erb -->
<head>
  <!-- Google Tag Manager -->
  <script>(function(w,d,s,l,i){w[l]=w[l]||[];w[l].push({'gtm.start':
  new Date().getTime(),event:'gtm.js'});var f=d.getElementsByTagName(s)[0],
  j=d.createElement(s),dl=l!='dataLayer'?'&l='+l:'';j.async=true;j.src=
  'https://www.googletagmanager.com/gtm.js?id='+i+dl;f.parentNode.insertBefore(j,f);
  })(window,document,'script','dataLayer','<%= ENV['GTM_CONTAINER_ID'] %>');</script>
  <!-- End Google Tag Manager -->
</head>
```

---

#### 3. ANYON Platform - Story 2.1, 2.2, 2.3

**Purpose:** Destination for CTA clicks and project links

**Integration Type:** External links with UTM tracking (no API integration in Epic 2)

**Configuration:**

| Setting | Value | Source |
|---------|-------|--------|
| **ANYON Signup URL** | `https://anyon.app/signup` | Environment variable `ANYON_SIGNUP_URL` |
| **UTM Source** | `community` | Hardcoded in CTA components |
| **UTM Medium** | `cta`, `project_link`, `profile_link` | Varies by location |
| **UTM Campaign** | `header`, `sidebar`, `footer` | Varies by CTA location |

**URL Format:**
```
https://anyon.app/signup?utm_source=community&utm_medium=cta&utm_campaign=header
```

**API Integration:** None in Epic 2 (Phase 2: ANYON API for signup attribution)

**Cost:** N/A (external service)

**Post-MVP Enhancement (Phase 2):**
- ANYON OAuth SSO (sign in with ANYON account)
- ANYON API for conversion attribution (track signups from community)
- ANYON project metadata API (fetch project details for embeds)

---

### Environment Variables

**New Environment Variables for Epic 2:**

| Variable | Description | Example | Required | Story |
|----------|-------------|---------|----------|-------|
| `ANYON_SIGNUP_URL` | Base URL for ANYON signup | `https://anyon.app/signup` | Yes | 2.1 |
| `GA4_MEASUREMENT_ID` | Google Analytics 4 Measurement ID | `G-XXXXXXXXXX` | Yes | 2.4 |
| `GTM_CONTAINER_ID` | Google Tag Manager Container ID | `GTM-XXXXXXX` | Yes | 2.4 |

**Configuration:**

```bash
# .env (local development)
ANYON_SIGNUP_URL=https://anyon.app/signup
GA4_MEASUREMENT_ID=G-XXXXXXXXXX
GTM_CONTAINER_ID=GTM-XXXXXXX

# Staging
ANYON_SIGNUP_URL=https://staging.anyon.app/signup
GA4_MEASUREMENT_ID=G-STAGING-XXXX
GTM_CONTAINER_ID=GTM-STAGING-XX

# Production
ANYON_SIGNUP_URL=https://anyon.app/signup
GA4_MEASUREMENT_ID=G-PRODUCTION-XX
GTM_CONTAINER_ID=GTM-PROD-XXXXX
```

**Secrets Management:**
- Local: `.env` file (not committed to git)
- Staging/Production: Railway/Render environment variables dashboard
- Never commit these values to version control

---

### Database Dependencies

**PostgreSQL Version:** 14+ (existing Forem requirement)

**New Database Objects:**

| Object | Type | Purpose | Story |
|--------|------|---------|-------|
| `articles.anyon_project_url` | Column (VARCHAR) | Store ANYON project URL in posts | 2.2 |
| `users.anyon_projects` | Column (JSONB) | Store ANYON project list in profiles | 2.3 |
| `vibecoding_analytics` | Table | Track ANYON conversion events | 2.4 |
| `idx_articles_anyon_project_url` | Index (partial) | Query posts with ANYON projects | 2.2 |
| `idx_users_anyon_projects` | Index (GIN) | Query users with ANYON projects | 2.3 |
| `idx_vibecoding_analytics_*` | Indexes (multiple) | Query analytics data efficiently | 2.4 |

**PostgreSQL Extensions Required:** None (uses existing `ltree`, `pg_trgm`, `pgcrypto` from Forem)

**Redis Usage:**
- Cache ANYON signup URL (5 minute TTL)
- Cache analytics dashboard queries (5 minute TTL)
- Session storage (existing Forem usage)

---

### Integration Points Summary

**Story 2.1 - CTA Placement:**
- **Dependencies:** Preact (existing), Redis (caching)
- **External Services:** ANYON platform (link destination)
- **Environment Variables:** `ANYON_SIGNUP_URL`

**Story 2.2 - Project Linking in Posts:**
- **Dependencies:** Rails, PostgreSQL
- **External Services:** ANYON platform (project links)
- **Database Changes:** `articles.anyon_project_url` column

**Story 2.3 - Profile Project Linking:**
- **Dependencies:** Rails, PostgreSQL (JSONB)
- **External Services:** ANYON platform (project links)
- **Database Changes:** `users.anyon_projects` column

**Story 2.4 - Conversion Tracking:**
- **Dependencies:** Rails, PostgreSQL, Redis
- **External Services:** Google Analytics 4, Google Tag Manager
- **Database Changes:** `vibecoding_analytics` table
- **Environment Variables:** `GA4_MEASUREMENT_ID`, `GTM_CONTAINER_ID`

**Story 2.5 - Post Template:**
- **Dependencies:** Forem article templates (existing)
- **External Services:** None
- **Database Changes:** Template stored in Forem's existing templates system

---

### Version Constraints

**Critical Version Requirements:**

| Dependency | Minimum Version | Notes |
|------------|----------------|-------|
| Ruby | 3.3.0 | Existing Forem requirement |
| Rails | 7.0.8.4 | Existing Forem requirement |
| PostgreSQL | 14+ | JSONB GIN index support |
| Redis | 4.7.1+ | Existing Forem requirement |
| Preact | 10.20.2 | Existing Forem frontend framework |
| Node.js | 20.x | Existing Forem requirement |

**No Version Upgrades Required:** Epic 2 works with existing Forem stack versions.

---

### Third-Party Service Limits

**Google Analytics 4 (Free Tier):**
- **Events:** 500 events/second (well above expected load)
- **Properties:** 1 property (sufficient)
- **Data Retention:** 14 months standard (adequate)
- **Cost:** $0

**Google Tag Manager (Free):**
- **Containers:** Unlimited
- **Tags:** Unlimited
- **Triggers:** Unlimited
- **Cost:** $0

**ANYON Platform:**
- **No API limits in Epic 2** (only link redirects)
- **Post-MVP:** API rate limits TBD when integrating ANYON API

---

### Testing Dependencies

**Already Included in Forem:**

| Tool | Purpose | Story Coverage |
|------|---------|----------------|
| **RSpec** | Backend unit tests (services, models, controllers) | All stories |
| **Jest** | Frontend unit tests (Preact components) | 2.1, 2.2, 2.3 |
| **Cypress** | E2E tests (CTA clicks, tracking workflows) | All stories |
| **Factory Bot** | Test data generation | All stories |
| **Webmock** | HTTP request stubbing (GA4, ANYON URL validation) | 2.4 |

**No New Testing Tools Required**

## Acceptance Criteria (Authoritative)

### AC-2.1: ANYON CTA Strategic Placement (Story 2.1)

**Given** the Vibecoding Community platform with Epic 1 foundation complete
**When** I implement ANYON CTA strategic placement
**Then** the following CTAs are visible and functional:

**Header CTA:**
- AC-2.1.1: "Try ANYON" button appears in site header on all pages
- AC-2.1.2: Button uses Crayons primary button styling (consistent with brand)
- AC-2.1.3: Button is visible on desktop (>768px), tablet (768-1024px), and mobile (<768px)
- AC-2.1.4: Clicking button opens ANYON signup URL in new tab with UTM parameters: `utm_source=community&utm_medium=cta&utm_campaign=header`
- AC-2.1.5: Click event is tracked in GA4 with event name `anyon_cta_click` and location `header`

**Sidebar CTA:**
- AC-2.1.6: "Build with ANYON" widget appears in right sidebar on article pages
- AC-2.1.7: Widget includes brief value proposition (1-2 sentences) and CTA button
- AC-2.1.8: Widget is visible on desktop and tablet, hidden on mobile (<768px)
- AC-2.1.9: Clicking button opens ANYON signup with UTM: `utm_source=community&utm_medium=cta&utm_campaign=sidebar`
- AC-2.1.10: Click event tracked in GA4 with location `sidebar`

**Footer CTA:**
- AC-2.1.11: Footer includes "Powered by ANYON" text with link
- AC-2.1.12: Link opens ANYON homepage (not signup) with UTM: `utm_source=community&utm_medium=footer&utm_campaign=branding`
- AC-2.1.13: Footer CTA is subtle (not as prominent as header/sidebar)
- AC-2.1.14: Click event tracked in GA4 with location `footer`

**Post-Signup CTA (Optional):**
- AC-2.1.15: After user signs up, show one-time prompt: "Link your ANYON account?" (dismissible)
- AC-2.1.16: Prompt includes "Link Account" button and "Skip" option
- AC-2.1.17: Clicking "Link Account" opens ANYON signup with UTM: `utm_source=community&utm_medium=post_signup&utm_campaign=onboarding`
- AC-2.1.18: User can permanently dismiss prompt (cookie/user preference)

**Technical Requirements:**
- AC-2.1.19: All CTAs are implemented as reusable `AnyonCTA` Preact component
- AC-2.1.20: Component accepts props: `location`, `ctaText`, `className`
- AC-2.1.21: UTM parameters are consistent and documented
- AC-2.1.22: ANYON signup URL is configured via `ANYON_SIGNUP_URL` env var
- AC-2.1.23: If env var is missing, CTAs are hidden gracefully (no errors)

**Non-Functional:**
- AC-2.1.24: CTA render time < 50ms (no performance impact)
- AC-2.1.25: CTAs work with JavaScript disabled (fallback to plain HTML links)

---

### AC-2.2: ANYON Project Linking in Posts (Story 2.2)

**Given** an authenticated user creating or editing a post
**When** I add ANYON project linking capability
**Then** the following functionality is available:

**Post Editor:**
- AC-2.2.1: Post editor includes optional "ANYON Project URL" field below main content area
- AC-2.2.2: Field is labeled clearly: "Link to ANYON Project (optional)"
- AC-2.2.3: Field includes placeholder: "https://anyon.app/projects/your-project"
- AC-2.2.4: Field accepts HTTPS URLs up to 2048 characters
- AC-2.2.5: Client-side validation checks HTTPS protocol and shows ✓ or ✗ indicator
- AC-2.2.6: Help text explains: "Showcase your ANYON project with this post"

**Server-Side Validation:**
- AC-2.2.7: URL must be HTTPS (reject HTTP, FTP, etc.)
- AC-2.2.8: URL must be valid URI format (use Rails `URI.parse`)
- AC-2.2.9: URL maximum length 2048 characters
- AC-2.2.10: Empty/nil URL is allowed (field is optional)
- AC-2.2.11: Invalid URLs show clear error message: "Project URL must be HTTPS and valid"

**Database Storage:**
- AC-2.2.12: `articles.anyon_project_url` column exists (VARCHAR 2048, nullable)
- AC-2.2.13: Partial index created on non-null values for performance
- AC-2.2.14: Column is commented: "VIBECODING: Optional ANYON project URL"

**Post Display:**
- AC-2.2.15: Posts with ANYON projects display "ANYON Project" badge below title
- AC-2.2.16: Badge includes ANYON icon/logo and "View Project" button
- AC-2.2.17: Clicking "View Project" opens project URL in new tab with UTM: `utm_source=community&utm_medium=project_link&utm_campaign=post`
- AC-2.2.18: Click event tracked in GA4 as `anyon_project_view` with `post_id`
- AC-2.2.19: Badge is visually distinct (border, background color, or icon)

**Filtering & Discovery:**
- AC-2.2.20: Posts with ANYON projects are tagged with `#anyon` (auto-suggested, not forced)
- AC-2.2.21: `/tags/anyon` page shows all ANYON-related posts (both tagged and with projects)
- AC-2.2.22: Article search includes ANYON project URL field

**Tracking:**
- AC-2.2.23: When project URL is saved, event `project_linked_post` is tracked in `vibecoding_analytics`
- AC-2.2.24: Event includes `article_id` and `project_url` in metadata

---

### AC-2.3: ANYON Project Linking in User Profiles (Story 2.3)

**Given** an authenticated user editing their profile
**When** I add ANYON project linking to profiles
**Then** the following functionality is available:

**Profile Editor:**
- AC-2.3.1: Profile settings include "ANYON Projects" section
- AC-2.3.2: Section includes "Add ANYON Project" button
- AC-2.3.3: Clicking "Add" reveals form with fields: "Project Title" and "Project URL"
- AC-2.3.4: Title field: max 200 characters, required
- AC-2.3.5: URL field: HTTPS only, max 2048 characters, required
- AC-2.3.6: User can add up to 10 projects (enforce limit with validation)
- AC-2.3.7: User can edit or delete existing projects

**Validation:**
- AC-2.3.8: Project title is required and non-empty
- AC-2.3.9: Project URL must be HTTPS and valid URI format
- AC-2.3.10: Maximum 10 projects per user (show error if limit exceeded)
- AC-2.3.11: Duplicate URLs within same profile not allowed

**Database Storage:**
- AC-2.3.12: `users.anyon_projects` column exists (JSONB, default `[]`)
- AC-2.3.13: GIN index created for JSONB queries
- AC-2.3.14: Column is commented: "VIBECODING: Array of ANYON project links"
- AC-2.3.15: JSONB structure: `[{ "title": "...", "url": "...", "added_at": "..." }]`
- AC-2.3.16: `added_at` timestamp auto-generated if not provided

**Profile Display:**
- AC-2.3.17: Public profile includes "ANYON Projects" section if user has projects
- AC-2.3.18: Section displays "Built with ANYON" badge/header
- AC-2.3.19: Projects are listed with title and "View" link
- AC-2.3.20: Clicking "View" opens project URL in new tab with UTM: `utm_source=community&utm_medium=profile_link&utm_campaign=author`
- AC-2.3.21: Click event tracked in GA4 as `anyon_project_view` with `user_id`
- AC-2.3.22: Projects section is prominently displayed (above bio or in sidebar)

**Discovery:**
- AC-2.3.23: User directory/search can filter for "Users with ANYON projects"
- AC-2.3.24: Profile badge indicator shows "ANYON Builder" or similar

**Tracking:**
- AC-2.3.25: When project is added, event `project_linked_profile` tracked in `vibecoding_analytics`
- AC-2.3.26: Event includes `user_id`, `project_title`, `project_url` in metadata

---

### AC-2.4: Conversion Tracking & Analytics Setup (Story 2.4)

**Given** ANYON CTAs and project linking are implemented
**When** I set up conversion tracking and analytics
**Then** the following tracking infrastructure is operational:

**Google Analytics 4 Setup:**
- AC-2.4.1: GA4 property created for Vibecoding Community
- AC-2.4.2: Data stream configured for production domain
- AC-2.4.3: `GA4_MEASUREMENT_ID` environment variable set (staging + production)
- AC-2.4.4: GA4 measurement code loads on all pages (via GTM)

**Google Tag Manager Setup:**
- AC-2.4.5: GTM container created and published
- AC-2.4.6: `GTM_CONTAINER_ID` environment variable set (staging + production)
- AC-2.4.7: GTM snippet added to `app/views/layouts/application.html.erb` in `<head>`
- AC-2.4.8: GTM noscript snippet added after `<body>` tag

**Custom Events Configured:**
- AC-2.4.9: `anyon_cta_click` event sends to GA4 with parameters: `location`, `timestamp`
- AC-2.4.10: `anyon_project_view` event sends to GA4 with parameters: `post_id` or `user_id`, `timestamp`
- AC-2.4.11: Events appear in GA4 real-time reports within 30 seconds

**Database Tracking:**
- AC-2.4.12: `vibecoding_analytics` table exists with all required columns
- AC-2.4.13: Indexes created on `user_id`, `event_type`, `tracked_at`, `event_data`
- AC-2.4.14: Table captures events: `cta_click_header`, `cta_click_sidebar`, `cta_click_footer`, `project_linked_post`, `project_linked_profile`, `project_view`

**Tracking API Endpoints:**
- AC-2.4.15: `POST /api/custom/anyon/track_conversion` endpoint functional
- AC-2.4.16: Endpoint requires authentication (logged-in user preferred, anonymous allowed)
- AC-2.4.17: Endpoint validates `event_type` against whitelist
- AC-2.4.18: Endpoint returns 201 Created on success with event details
- AC-2.4.19: Endpoint returns 422 Unprocessable Entity on invalid input
- AC-2.4.20: Endpoint respects rate limiting: 100 requests/hour per user
- AC-2.4.21: `POST /api/custom/anyon/validate_project_url` endpoint functional for URL validation

**Admin Dashboard:**
- AC-2.4.22: Custom admin page created at `/admin/analytics/anyon_funnel`
- AC-2.4.23: Dashboard requires admin role (Pundit policy enforces)
- AC-2.4.24: Dashboard displays daily metrics: Total CTA clicks (by location), Total project links, Unique users
- AC-2.4.25: Dashboard displays weekly/monthly trends (line chart)
- AC-2.4.26: Dashboard displays top 10 converting posts (table with title, clicks, CTR)
- AC-2.4.27: Dashboard displays top 10 authors driving ANYON traffic (leaderboard)
- AC-2.4.28: Dashboard includes CSV export functionality
- AC-2.4.29: Dashboard data refreshes every 5 minutes (cached)

**GDPR Compliance:**
- AC-2.4.30: Cookie consent banner implemented for EU users
- AC-2.4.31: GA4 and GTM load only after user grants analytics consent
- AC-2.4.32: Privacy policy updated to mention ANYON conversion tracking
- AC-2.4.33: User data export includes `vibecoding_analytics` records
- AC-2.4.34: User deletion cascades to `vibecoding_analytics` (ON DELETE CASCADE)

**Monitoring & Alerts:**
- AC-2.4.35: Sentry error tracking active for all Epic 2 code (tagged `epic: 'anyon_integration'`)
- AC-2.4.36: Alert configured for tracking API error rate > 10%
- AC-2.4.37: Alert configured for GA4 events dropping to zero (1-hour window)

---

### AC-2.5: "Built with ANYON" Post Template (Story 2.5)

**Given** the post editor and ANYON project linking are functional
**When** I create a "Built with ANYON" post template
**Then** the following template functionality is available:

**Template Creation:**
- AC-2.5.1: Admin can create article template at `/admin/customization/article_templates`
- AC-2.5.2: Template named "Built with ANYON Project Showcase"
- AC-2.5.3: Template is accessible to all authenticated users

**Template Structure:**
- AC-2.5.4: Template includes pre-populated sections:
  - **Title:** "Building [Project Name] with ANYON"
  - **Intro:** Brief overview placeholder
  - **The Problem:** What problem does your project solve?
  - **Why ANYON:** Why did you choose ANYON for this project?
  - **The Build:** Key implementation details and challenges
  - **Results:** What did you achieve? (metrics, screenshots, demo links)
  - **Lessons Learned:** What would you do differently?
  - **Conclusion:** Summary and call-to-action

**Template Features:**
- AC-2.5.5: Each section includes inline help text (light gray, italicized)
- AC-2.5.6: Example content provided in help text for guidance
- AC-2.5.7: Template auto-suggests tags: `#anyon`, `#project-showcase`, `#vibecoding`
- AC-2.5.8: Template includes ANYON Project URL field pre-expanded (not hidden)
- AC-2.5.9: Template includes reminder: "Add screenshots or demo video to boost engagement"

**User Experience:**
- AC-2.5.10: Template is selectable from "New Post" dropdown or button
- AC-2.5.11: Selecting template pre-fills editor with structured content
- AC-2.5.12: User can edit or remove any section (template is guidance, not enforced)
- AC-2.5.13: Template saves as draft by default (user must explicitly publish)

**Visual Highlighting:**
- AC-2.5.14: Posts using this template display "Project Showcase" badge
- AC-2.5.15: Badge is visually distinct from regular ANYON project badge
- AC-2.5.16: Template-based posts are featured in `/tags/project-showcase` feed

**Discoverability:**
- AC-2.5.17: Template is promoted on user dashboard: "Share your ANYON project!"
- AC-2.5.18: Template is suggested after user links ANYON project to profile
- AC-2.5.19: Template is documented in community guidelines or help docs

**Tracking:**
- AC-2.5.20: Posts created from template are tracked with `template_used: 'anyon_showcase'` metadata
- AC-2.5.21: Analytics dashboard shows "Posts created from ANYON template" metric

## Traceability Mapping

| AC ID | Epic Story | Spec Section | Components/Services | Test Approach |
|-------|-----------|--------------|---------------------|---------------|
| **Story 2.1 - ANYON CTA Strategic Placement** |
| AC-2.1.1-5 | Story 2.1 | Services (CTA Placement), APIs (AnyonCTA Component) | AnyonCTA.jsx, app/views/layouts/application.html.erb | E2E (Cypress): Verify CTA visible on all pages, click opens new tab |
| AC-2.1.6-10 | Story 2.1 | Services (CTA Placement), APIs (AnyonCTA Component) | AnyonCTA.jsx, app/views/articles/show.html.erb | E2E: Verify sidebar CTA on article pages, UTM tracking |
| AC-2.1.11-14 | Story 2.1 | Services (CTA Placement) | app/views/layouts/_footer.html.erb | E2E: Verify footer link, UTM parameters |
| AC-2.1.15-18 | Story 2.1 | Workflows (Post-Signup) | Post-signup modal/prompt | E2E: Test dismissible prompt after signup |
| AC-2.1.19-23 | Story 2.1 | APIs (AnyonCTA Component), Data Models (Environment Variables) | AnyonCTA.jsx, config/vibecoding.yml | Unit (Jest): Test component props, env var handling |
| AC-2.1.24-25 | Story 2.1 | NFR (Performance) | AnyonCTA.jsx | Performance test: Measure render time, fallback test |
| **Story 2.2 - ANYON Project Linking in Posts** |
| AC-2.2.1-6 | Story 2.2 | APIs (Post Editor), Workflows (Project Linking) | app/views/articles/_form.html.erb | E2E: Test field visibility, placeholder, help text |
| AC-2.2.7-11 | Story 2.2 | Data Models (Validation), Services (ProjectLinker) | app/models/concerns/anyon_trackable.rb | Unit (RSpec): Test URL validation, error messages |
| AC-2.2.12-14 | Story 2.2 | Data Models (Database Schema) | db/migrate/*_add_anyon_project_url_to_articles.rb | Migration test: Verify column, index, comment |
| AC-2.2.15-19 | Story 2.2 | Services (AnyonProjectBadge Component), Workflows (Post Display) | AnyonProjectBadge.jsx, app/views/articles/show.html.erb | E2E: Verify badge display, "View Project" click, UTM |
| AC-2.2.20-22 | Story 2.2 | APIs (Tag System), Workflows (Filtering) | Forem tag system (existing) | E2E: Test /tags/anyon page, search functionality |
| AC-2.2.23-24 | Story 2.2 | Services (ConversionTracker), Data Models (VibeCodingAnalytic) | app/services/anyon/conversion_tracker.rb | Unit (RSpec): Test event tracking on save |
| **Story 2.3 - ANYON Project Linking in User Profiles** |
| AC-2.3.1-7 | Story 2.3 | APIs (Profile Editor), Workflows (Profile Editing) | app/views/users/edit.html.erb | E2E: Test "Add ANYON Project" form, edit/delete |
| AC-2.3.8-11 | Story 2.3 | Data Models (Validation) | app/models/user.rb (concern) | Unit (RSpec): Test title/URL validation, 10 project limit |
| AC-2.3.12-16 | Story 2.3 | Data Models (Database Schema) | db/migrate/*_add_anyon_projects_to_users.rb | Migration test: Verify JSONB column, GIN index, structure |
| AC-2.3.17-22 | Story 2.3 | Workflows (Profile Display) | app/views/users/show.html.erb | E2E: Verify profile projects section, "View" links, UTM |
| AC-2.3.23-24 | Story 2.3 | APIs (User Directory) | User search/filter (Forem existing) | E2E: Test "Users with ANYON projects" filter |
| AC-2.3.25-26 | Story 2.3 | Services (ConversionTracker) | app/services/anyon/conversion_tracker.rb | Unit (RSpec): Test event tracking on profile update |
| **Story 2.4 - Conversion Tracking & Analytics Setup** |
| AC-2.4.1-4 | Story 2.4 | Dependencies (GA4) | Google Analytics 4 setup | Manual: Verify GA4 property, data stream, env var |
| AC-2.4.5-8 | Story 2.4 | Dependencies (GTM), APIs (GTM Integration) | app/views/layouts/application.html.erb | Manual: Verify GTM snippet in <head> and <body> |
| AC-2.4.9-11 | Story 2.4 | Services (GA4 Tracker), Workflows (Analytics) | app/javascript/analytics/ga4_tracker.js | E2E: Test event firing, GA4 real-time reports |
| AC-2.4.12-14 | Story 2.4 | Data Models (VibeCodingAnalytic) | db/migrate/*_create_vibecoding_analytics.rb | Migration test: Verify table, indexes, event types |
| AC-2.4.15-21 | Story 2.4 | APIs (Tracking API) | app/controllers/custom/anyon_integrations_controller.rb | Integration (RSpec): Test endpoints, auth, rate limiting |
| AC-2.4.22-29 | Story 2.4 | Services (Analytics Dashboard) | app/views/admin/analytics/anyon_funnel.html.erb | E2E: Test dashboard access, metrics display, CSV export |
| AC-2.4.30-34 | Story 2.4 | NFR (Security - GDPR) | Cookie consent, privacy policy | Manual: Review consent banner, data export, deletion |
| AC-2.4.35-37 | Story 2.4 | NFR (Observability - Monitoring) | Sentry, alerts | Manual: Verify Sentry tagging, alert configuration |
| **Story 2.5 - "Built with ANYON" Post Template** |
| AC-2.5.1-3 | Story 2.5 | APIs (Admin Panel), Services (Post Template) | /admin/customization/article_templates | Manual: Create template in admin panel |
| AC-2.5.4-9 | Story 2.5 | Services (Post Template), Workflows (Content Creation) | Forem article templates (existing) | Manual: Verify template structure, help text |
| AC-2.5.10-13 | Story 2.5 | Workflows (Template Selection) | app/views/articles/new.html.erb | E2E: Test template selection, pre-fill, editing |
| AC-2.5.14-16 | Story 2.5 | Services (Badge Rendering) | app/views/articles/show.html.erb | E2E: Verify "Project Showcase" badge display |
| AC-2.5.17-19 | Story 2.5 | Workflows (Discoverability) | User dashboard, profile suggestions | Manual: Review template promotion |
| AC-2.5.20-21 | Story 2.5 | Services (Analytics Dashboard) | Metadata tracking | Unit (RSpec): Test template_used metadata tracking |

### AC to PRD Requirements Mapping

| AC Story | PRD Requirement | PRD Section | Validation |
|----------|----------------|-------------|------------|
| Story 2.1 | ANYON CTA strategic placement for conversion funnel | Epic 2: ANYON Integration & Conversion Funnel | CTAs visible and tracked |
| Story 2.2 | Enable ANYON project showcasing in posts | Epic 2: Story 2.2 | Project linking functional |
| Story 2.3 | Enable ANYON project showcasing in profiles | Epic 2: Story 2.3 | Profile projects functional |
| Story 2.4 | Track community → ANYON trial conversion rate | Epic 2: Story 2.4, Success Metrics | GA4 + DB tracking operational |
| Story 2.5 | Encourage high-quality ANYON project posts | Epic 2: Story 2.5 | Template available and used |

### Component to Architecture Mapping

| Component/Service | Architecture Section | Implementation Pattern | File Location |
|-------------------|---------------------|------------------------|---------------|
| **AnyonCTA.jsx** | Pattern 4: Frontend Component | Preact component with tracking | app/javascript/custom/AnyonCTA.jsx |
| **AnyonProjectBadge.jsx** | Pattern 4: Frontend Component | Preact component | app/javascript/custom/AnyonProjectBadge.jsx |
| **Anyon::ConversionTracker** | Pattern 3: Service Object | Service with GA4 + DB tracking | app/services/anyon/conversion_tracker.rb |
| **Anyon::ProjectLinker** | Pattern 3: Service Object | URL validation service | app/services/anyon/project_linker.rb |
| **AnyonTrackable** | Pattern 1: Forem Extension | Model concern | app/models/concerns/anyon_trackable.rb |
| **VibeCodingAnalytic** | Data Models | ActiveRecord model | app/models/vibecoding_analytic.rb |
| **Custom::AnyonIntegrationsController** | APIs | Custom controller | app/controllers/custom/anyon_integrations_controller.rb |
| **GA4 Tracker** | External Integration | JavaScript tracker | app/javascript/analytics/ga4_tracker.js |

### Database Changes to Migration Files

| Database Change | Migration File | Story |
|-----------------|----------------|-------|
| `articles.anyon_project_url` column | `db/migrate/YYYYMMDD_add_anyon_project_url_to_articles.rb` | 2.2 |
| `users.anyon_projects` JSONB column | `db/migrate/YYYYMMDD_add_anyon_projects_to_users.rb` | 2.3 |
| `vibecoding_analytics` table | `db/migrate/YYYYMMDD_create_vibecoding_analytics.rb` | 2.4 |

### Test Coverage Matrix

| Story | Unit Tests | Integration Tests | E2E Tests | Manual Tests |
|-------|-----------|-------------------|-----------|--------------|
| 2.1 - CTA Placement | AnyonCTA component (Jest) | N/A | CTA visibility, click tracking (Cypress) | Visual QA |
| 2.2 - Project Linking Posts | AnyonTrackable validation (RSpec) | Article creation with URL (RSpec) | Post editor, badge display (Cypress) | URL validation edge cases |
| 2.3 - Project Linking Profiles | User validation (RSpec) | Profile update (RSpec) | Profile editor, display (Cypress) | JSONB edge cases |
| 2.4 - Conversion Tracking | ConversionTracker (RSpec), GA4Tracker (Jest) | Tracking API endpoints (RSpec) | GA4 event firing, dashboard (Cypress) | GA4 console verification, GDPR compliance |
| 2.5 - Post Template | Template metadata (RSpec) | N/A | Template selection, pre-fill (Cypress) | Content quality review |

### Risk Traceability

| Risk | Related ACs | Mitigation in Spec |
|------|-------------|-------------------|
| RISK-2.1: GA4 Tracking Failures | AC-2.4.9-11, AC-2.4.35-37 | NFR: Reliability - Graceful degradation, DB fallback, monitoring |
| RISK-2.2: Performance Degradation | AC-2.1.24, AC-2.2.5, NFR Performance | Async tracking, caching, partial indexes |
| RISK-2.3: URL Validation Bypass | AC-2.2.7-11, AC-2.3.8-11 | Client + Server validation, HTTPS enforcement |
| RISK-2.4: GDPR Non-Compliance | AC-2.4.30-34 | Cookie consent, data export/deletion, privacy policy |
| RISK-2.5: ANYON Signup URL Changes | AC-2.1.22-23 | Environment variable configuration, health checks |

## Risks, Assumptions, Open Questions

### Risks

**RISK-2.1: Google Analytics 4 Tracking Failures** (Medium Impact, Low Probability)
- **Description:** GA4 API or GTM script may fail, causing loss of conversion tracking data
- **Impact:** Cannot measure ANYON conversion funnel effectiveness, ROI visibility lost
- **Probability:** Low (GA4 is highly reliable, 99.9% uptime)
- **Mitigation:**
  - Dual tracking: Store all events in `vibecoding_analytics` table as backup
  - Async tracking: Failures don't block user experience
  - Monitoring: Alert if GA4 events drop to zero for 1 hour
  - Retry logic: Retry failed GA4 events once with exponential backoff
- **Contingency:** Use database analytics as primary source if GA4 unavailable long-term
- **Owner:** Backend Engineer (Story 2.4)

---

**RISK-2.2: Performance Degradation from Tracking** (Medium Impact, Medium Probability)
- **Description:** Heavy tracking (GA4 events, database writes) may slow down page load or CTA clicks
- **Impact:** Poor user experience, increased bounce rate, lower engagement
- **Probability:** Medium (tracking adds overhead)
- **Mitigation:**
  - Async tracking: All tracking calls are non-blocking (use background jobs)
  - Caching: Cache ANYON signup URL in Redis (avoid env var lookup on every render)
  - Partial indexes: Index only non-null `anyon_project_url` values (reduce index size)
  - Monitoring: Track CTA render time (target < 50ms), API response time (< 200ms p95)
- **Contingency:** If performance degrades > 10%, disable database tracking temporarily, keep GA4 only
- **Owner:** Backend Engineer, Performance Team

---

**RISK-2.3: URL Validation Bypass / XSS Attack** (High Impact, Low Probability)
- **Description:** Malicious users may inject JavaScript or malformed URLs in ANYON project fields
- **Impact:** XSS vulnerabilities, phishing attacks, damaged community trust
- **Probability:** Low (Rails and Preact have built-in XSS protection)
- **Mitigation:**
  - HTTPS-only validation: Reject all non-HTTPS URLs (HTTP, FTP, javascript:, data:)
  - Server-side validation: Always validate on backend, don't rely on client-side only
  - URL sanitization: Use Rails `URI.parse` and validate domain
  - ERB auto-escaping: All URLs rendered with ERB or Preact (safe by default)
  - Security audit: Run Brakeman scanner in CI/CD to detect XSS vulnerabilities
- **Contingency:** If attack detected, disable ANYON project linking temporarily, audit all existing URLs
- **Owner:** Backend Engineer (Story 2.2, 2.3), Security Team

---

**RISK-2.4: GDPR Non-Compliance** (High Impact, Medium Probability)
- **Description:** GA4 and GTM may track EU users without explicit consent, violating GDPR
- **Impact:** Legal liability, fines up to 4% of revenue (or €20M), brand damage
- **Probability:** Medium (easy to miss GDPR requirements)
- **Mitigation:**
  - Cookie consent banner: Implement for all users, require explicit opt-in for analytics
  - Conditional GTM loading: Load GTM/GA4 only after user grants consent
  - Privacy policy: Update to clearly state ANYON conversion tracking and data usage
  - Data export: Include `vibecoding_analytics` in user data export (GDPR right to access)
  - Data deletion: Cascade delete analytics on user deletion (GDPR right to erasure)
  - Anonymous tracking: Allow anonymous events (null user_id) for non-authenticated users
- **Contingency:** If GDPR violation reported, immediately disable GA4/GTM, legal review
- **Owner:** Legal Team, Backend Engineer (Story 2.4)

---

**RISK-2.5: ANYON Signup URL Changes** (Low Impact, Medium Probability)
- **Description:** ANYON team may change signup URL structure, breaking all CTAs
- **Impact:** CTAs lead to 404 pages, lost conversions, poor user experience
- **Probability:** Medium (external dependency on ANYON)
- **Mitigation:**
  - Environment variable: Store URL in `ANYON_SIGNUP_URL` env var (easy to update)
  - Health check: Daily automated check that ANYON signup URL returns 200 OK
  - Alert: Notify team if health check fails
  - Documentation: Maintain communication channel with ANYON team for changes
- **Contingency:** Update env var immediately, redeploy within 15 minutes
- **Owner:** DevOps, Product Manager (ANYON liaison)

---

**RISK-2.6: Low CTA Click-Through Rate** (Medium Impact, High Probability)
- **Description:** Users may ignore ANYON CTAs (banner blindness, low relevance)
- **Impact:** Low conversion rates, ANYON integration ROI not realized, wasted effort
- **Probability:** High (CTAs often have low CTR in communities)
- **Mitigation:**
  - A/B testing: Test CTA copy, placement, design (deferred to Epic 5)
  - Analytics: Track CTR by location (header, sidebar, footer) to optimize
  - Non-intrusive design: Avoid popups/modals (reduce annoyance)
  - Value proposition: Ensure CTA copy clearly communicates ANYON benefit
  - Template promotion: Encourage project showcases to drive organic ANYON awareness
- **Contingency:** If CTR < 0.5% after 1 month, redesign CTAs or adjust placement
- **Owner:** Product Manager, UX Designer

---

**RISK-2.7: Database Analytics Table Growth** (Medium Impact, Medium Probability)
- **Description:** `vibecoding_analytics` table may grow unbounded, causing storage/performance issues
- **Impact:** Slow queries, increased hosting costs, database bloat
- **Probability:** Medium (depends on traffic volume)
- **Mitigation:**
  - Data retention policy: Retain 90 days of analytics data, archive older records
  - Partitioning: Use PostgreSQL table partitioning by month (if table grows > 10GB)
  - Monitoring: Alert if table size > 10GB or growth > 1GB/day
  - Indexes: Ensure efficient indexes on `tracked_at` for time-range queries
- **Contingency:** Implement manual purge job, archive to cold storage (S3)
- **Owner:** DevOps, DBA

---

### Assumptions

**ASSUMPTION-2.1: ANYON Signup URL Stability**
- **Assumption:** ANYON signup URL (`https://anyon.app/signup`) will remain stable for MVP period (3-6 months)
- **Validation:** Confirm with ANYON team, request advance notice for URL changes
- **Impact if False:** All CTAs break, immediate hotfix required (see RISK-2.5)
- **Owner:** Product Manager

---

**ASSUMPTION-2.2: GA4 Free Tier Sufficiency**
- **Assumption:** GA4 free tier (500 events/second, 14-month retention) will suffice for MVP (100-1,000 users)
- **Validation:** GA4 free tier limits documented, calculate expected event volume (estimate: 10-50 events/second peak)
- **Impact if False:** May need to upgrade to GA4 360 ($150k/year) or switch to alternative (Plausible, Matomo)
- **Owner:** Product Manager, Analytics Team

---

**ASSUMPTION-2.3: UTM Parameter Consistency**
- **Assumption:** UTM parameters (`utm_source=community`, `utm_medium=cta/project_link`, `utm_campaign=header/sidebar/footer`) will be recognized by ANYON's analytics
- **Validation:** Confirm with ANYON team that they track UTM parameters in their signup flow
- **Impact if False:** Cannot attribute community conversions to ANYON signups, ROI measurement incomplete
- **Owner:** Product Manager (ANYON liaison)

---

**ASSUMPTION-2.4: User Willingness to Link ANYON Projects**
- **Assumption:** Vibecoding Community members will proactively link ANYON projects to posts and profiles
- **Validation:** User interviews, beta testing with early adopters
- **Impact if False:** Low adoption of project linking, minimal ANYON showcasing, reduced conversion funnel effectiveness
- **Contingency:** Increase incentives (featured posts, badges, gamification) in Epic 5 or Phase 2
- **Owner:** Product Manager, Community Manager

---

**ASSUMPTION-2.5: No ANYON API Available in Epic 2**
- **Assumption:** ANYON does not provide an API for project metadata (title, thumbnail, description) in MVP
- **Validation:** ANYON team confirmed no public API available yet
- **Impact if False:** Could enhance project badges with auto-fetched metadata, richer display
- **Opportunity:** If ANYON API becomes available, integrate in Phase 2 (see Out-of-Scope)
- **Owner:** Product Manager

---

**ASSUMPTION-2.6: PostgreSQL JSONB Performance**
- **Assumption:** PostgreSQL JSONB queries on `users.anyon_projects` will perform adequately for user profiles (max 10 projects per user)
- **Validation:** JSONB with GIN index is standard practice for this use case, proven performance
- **Impact if False:** Slow profile loading, need to normalize to separate table
- **Contingency:** Migrate to normalized `anyon_user_projects` table if performance issues arise
- **Owner:** Backend Engineer, DBA

---

**ASSUMPTION-2.7: Forem Article Templates Feature Exists**
- **Assumption:** Forem platform supports article templates feature for pre-populating post editor
- **Validation:** Review Forem documentation, check admin panel
- **Impact if False:** Need to build custom template system, increased development time (Story 2.5)
- **Contingency:** Use Forem liquid tags or custom editor extension
- **Owner:** Backend Engineer (Story 2.5)

---

### Open Questions

**QUESTION-2.1: ANYON Signup URL and UTM Parameters**
- **Question:** What is the exact ANYON signup URL? Does ANYON track UTM parameters for attribution?
- **Owner:** Product Manager (ANYON liaison)
- **Deadline:** Before Story 2.1 begins
- **Impact:** CTAs cannot be implemented without correct URL, conversion attribution depends on UTM tracking
- **Status:** PENDING

---

**QUESTION-2.2: ANYON Logo and Brand Assets**
- **Question:** Can we use ANYON logo in CTAs and badges? What are brand guidelines (colors, sizing, usage)?
- **Owner:** Designer, Product Manager
- **Deadline:** Before Story 2.1 UI implementation
- **Impact:** CTA and badge design, brand consistency
- **Status:** PENDING

---

**QUESTION-2.3: Cookie Consent Banner Implementation**
- **Question:** Does Forem have built-in GDPR cookie consent? Or do we need to integrate third-party solution (e.g., Cookiebot, OneTrust)?
- **Owner:** Backend Engineer, Legal Team
- **Deadline:** Before Story 2.4 GA4/GTM implementation
- **Impact:** GDPR compliance, user consent management
- **Status:** PENDING (check Forem documentation)

---

**QUESTION-2.4: GA4 Property Setup**
- **Question:** Who will create and manage the GA4 property? What email/Google account should own it?
- **Owner:** Product Manager, Analytics Team
- **Deadline:** Before Story 2.4 begins
- **Impact:** GA4 access, configuration ownership
- **Status:** PENDING

---

**QUESTION-2.5: ANYON Project URL Validation Strictness**
- **Question:** Should we restrict ANYON project URLs to `anyon.app` domain only? Or allow any HTTPS URL (deployed projects on custom domains)?
- **Owner:** Product Manager, Backend Engineer
- **Deadline:** Before Story 2.2 implementation
- **Impact:** User flexibility vs. security/consistency
- **Recommendation:** Allow any HTTPS URL (more flexible, users may deploy to custom domains)
- **Status:** PENDING DECISION

---

**QUESTION-2.6: Post-Signup ANYON Prompt Design**
- **Question:** Should post-signup ANYON prompt (AC-2.1.15-18) be a modal, banner, or inline message? How intrusive should it be?
- **Owner:** UX Designer, Product Manager
- **Deadline:** Before Story 2.1 UI design
- **Impact:** User experience, conversion rate vs. annoyance
- **Recommendation:** Non-modal dismissible banner (less intrusive)
- **Status:** PENDING DESIGN

---

**QUESTION-2.7: Analytics Dashboard Access Control**
- **Question:** Should analytics dashboard be admin-only, or accessible to moderators/trusted community members?
- **Owner:** Product Manager, Community Manager
- **Deadline:** Before Story 2.4 implementation
- **Impact:** Data privacy, decision-making transparency
- **Recommendation:** Admin-only for MVP, expand access in Epic 5 if needed
- **Status:** PENDING DECISION

---

**QUESTION-2.8: ANYON Project Showcase Incentives**
- **Question:** Should we offer incentives (featured posts, badges, prizes) for users who create ANYON project showcases?
- **Owner:** Product Manager, Community Manager
- **Deadline:** Before Epic 2 launch (can implement during Story 2.5)
- **Impact:** Adoption rate of post template, quality of project showcases
- **Recommendation:** Simple "Project Showcase" badge for MVP, gamification in Epic 5
- **Status:** PENDING DECISION

---

**QUESTION-2.9: Conversion Funnel Completion (ANYON API)**
- **Question:** Will ANYON provide an API endpoint to report back conversions (community users who signed up for ANYON)?
- **Owner:** Product Manager (ANYON liaison)
- **Deadline:** Post-MVP (Phase 2 feature)
- **Impact:** Full funnel visibility (CTA click → ANYON signup → trial → paid), ROI calculation
- **Status:** DEFERRED TO PHASE 2

---

**QUESTION-2.10: Data Retention Policy**
- **Question:** How long should we retain `vibecoding_analytics` data? 90 days, 1 year, indefinitely?
- **Owner:** Legal Team, Product Manager
- **Deadline:** Before Story 2.4 launch
- **Impact:** Storage costs, GDPR compliance (data minimization principle)
- **Recommendation:** 90 days active storage, archive older data to cold storage
- **Status:** PENDING DECISION

## Test Strategy Summary

### Test Levels

**Unit Tests (RSpec - Backend, Jest - Frontend):**
- **Target Coverage:** 80% minimum for all custom Epic 2 code
- **Focus Areas:**
  - Service objects: `Anyon::ConversionTracker`, `Anyon::ProjectLinker`
  - Model concerns: `AnyonTrackable` validation logic
  - Controllers: `Custom::AnyonIntegrationsController` API endpoints
  - Frontend components: `AnyonCTA.jsx`, `AnyonProjectBadge.jsx`
- **Execution:** `bin/rspec` (backend), `yarn test` (frontend) in CI pipeline
- **Responsibility:** Backend Engineers, Frontend Engineers

---

**Integration Tests (RSpec + Capybara):**
- **Target Coverage:** Critical user flows and API integrations
- **Focus Areas:**
  - Article creation with ANYON project URL (Story 2.2)
  - Profile update with ANYON projects (Story 2.3)
  - Tracking API endpoint authentication and rate limiting (Story 2.4)
  - Database migrations (column creation, index verification)
- **Execution:** `bin/rspec spec/features` in CI
- **Responsibility:** QA + Backend Engineers

---

**End-to-End Tests (Cypress):**
- **Target Coverage:** Complete user journeys across all stories
- **Focus Areas:**
  - CTA click tracking workflow (Story 2.1)
  - Post creation with ANYON project, badge display (Story 2.2)
  - Profile project management (Story 2.3)
  - GA4 event firing verification (Story 2.4)
  - Template selection and pre-fill (Story 2.5)
- **Execution:** `bin/e2e` manually before production deploy, subset in CI
- **Responsibility:** QA Team

---

**Manual Testing:**
- **Visual QA:** CTA placement, badge design, responsive layout
- **GA4 Verification:** Check GA4 real-time reports for event tracking
- **GDPR Compliance:** Verify cookie consent banner, data export/deletion
- **Cross-browser:** Chrome, Firefox, Safari, Edge
- **Cross-device:** Desktop, tablet, mobile
- **Accessibility:** Lighthouse accessibility audit (target score > 90)
- **Responsibility:** QA Team, Product Manager

---

### Test Scenarios by Story

#### Story 2.1: ANYON CTA Strategic Placement

**Unit Tests (Jest):**
- TS-2.1.1: `AnyonCTA` component renders with correct props (location, ctaText, className)
- TS-2.1.2: Component generates correct UTM parameters based on location
- TS-2.1.3: Component handles missing `ANYON_SIGNUP_URL` env var gracefully (doesn't render)
- TS-2.1.4: Click handler calls tracking function with correct event data

**E2E Tests (Cypress):**
- TS-2.1.5: Header CTA visible on all pages (home, article, profile, tags)
- TS-2.1.6: Clicking header CTA opens new tab with correct UTM parameters
- TS-2.1.7: Sidebar CTA visible on article pages, hidden on mobile
- TS-2.1.8: Footer CTA visible with "Powered by ANYON" text
- TS-2.1.9: Post-signup prompt appears after new user registration (dismissible)
- TS-2.1.10: GA4 event `anyon_cta_click` fires with correct location parameter

**Manual Tests:**
- TS-2.1.11: Visual QA of CTA design across desktop/tablet/mobile
- TS-2.1.12: Verify ANYON signup page opens correctly in new tab
- TS-2.1.13: Test with JavaScript disabled (fallback to plain links)

---

#### Story 2.2: ANYON Project Linking in Posts

**Unit Tests (RSpec):**
- TS-2.2.1: `AnyonTrackable` validates HTTPS-only URLs
- TS-2.2.2: Validation rejects HTTP, FTP, javascript:, data: protocols
- TS-2.2.3: Validation allows nil/empty URL (optional field)
- TS-2.2.4: Validation enforces 2048 character limit
- TS-2.2.5: `track_anyon_project_link` callback fires on URL save
- TS-2.2.6: `has_anyon_project?` returns true/false correctly

**Integration Tests (RSpec):**
- TS-2.2.7: Article creation with valid ANYON URL succeeds
- TS-2.2.8: Article creation with invalid URL shows error message
- TS-2.2.9: Migration adds `anyon_project_url` column and index
- TS-2.2.10: Database comment exists on column

**E2E Tests (Cypress):**
- TS-2.2.11: Post editor displays "ANYON Project URL" field
- TS-2.2.12: Client-side validation shows ✓ for valid HTTPS URL, ✗ for invalid
- TS-2.2.13: Publishing post with project URL succeeds
- TS-2.2.14: Published post displays "ANYON Project" badge
- TS-2.2.15: Clicking "View Project" button opens URL in new tab with UTM
- TS-2.2.16: `/tags/anyon` page shows posts with ANYON projects
- TS-2.2.17: GA4 event `anyon_project_view` fires when clicking project link

**Manual Tests:**
- TS-2.2.18: Test edge cases (very long URLs, special characters, IDN domains)
- TS-2.2.19: Visual QA of badge design and placement

---

#### Story 2.3: ANYON Project Linking in User Profiles

**Unit Tests (RSpec):**
- TS-2.3.1: User model validates JSONB structure for `anyon_projects`
- TS-2.3.2: Validation enforces max 10 projects per user
- TS-2.3.3: Validation requires title and URL for each project
- TS-2.3.4: Validation rejects duplicate URLs within same profile
- TS-2.3.5: `added_at` timestamp auto-generated if not provided

**Integration Tests (RSpec):**
- TS-2.3.6: Profile update with valid project succeeds
- TS-2.3.7: Profile update with 11 projects fails validation
- TS-2.3.8: Migration adds `anyon_projects` JSONB column and GIN index
- TS-2.3.9: Database comment exists on column

**E2E Tests (Cypress):**
- TS-2.3.10: Profile settings display "ANYON Projects" section
- TS-2.3.11: Clicking "Add ANYON Project" reveals form (Title, URL)
- TS-2.3.12: Submitting form adds project to list
- TS-2.3.13: User can edit/delete existing projects
- TS-2.3.14: Public profile displays "Built with ANYON" badge
- TS-2.3.15: Projects listed with titles and "View" links
- TS-2.3.16: Clicking "View" opens URL in new tab with UTM
- TS-2.3.17: User directory filters for "Users with ANYON projects"

**Manual Tests:**
- TS-2.3.18: Test JSONB edge cases (max projects, large titles, UTF-8 characters)
- TS-2.3.19: Visual QA of profile projects section

---

#### Story 2.4: Conversion Tracking & Analytics Setup

**Unit Tests (RSpec):**
- TS-2.4.1: `Anyon::ConversionTracker#track!` creates database record
- TS-2.4.2: Tracker handles GA4 failures gracefully (doesn't raise error)
- TS-2.4.3: Tracker logs error to Sentry on failure
- TS-2.4.4: Tracker respects user privacy (allows null user_id)
- TS-2.4.5: VibeCodingAnalytic model validates event_type whitelist

**Unit Tests (Jest):**
- TS-2.4.6: `ga4_tracker.js` pushes events to GTM dataLayer
- TS-2.4.7: Tracker formats event data correctly (event_name, parameters)
- TS-2.4.8: Tracker handles missing GTM gracefully (no errors)

**Integration Tests (RSpec):**
- TS-2.4.9: `POST /api/custom/anyon/track_conversion` returns 201 on success
- TS-2.4.10: Endpoint returns 422 on invalid event_type
- TS-2.4.11: Endpoint enforces rate limiting (100 req/hour)
- TS-2.4.12: Endpoint requires authentication (or allows anonymous with fingerprint)
- TS-2.4.13: `POST /api/custom/anyon/validate_project_url` validates URL format
- TS-2.4.14: Migration creates `vibecoding_analytics` table with all indexes

**E2E Tests (Cypress):**
- TS-2.4.15: CTA click fires `anyon_cta_click` event to GTM dataLayer
- TS-2.4.16: Event appears in GA4 real-time reports within 30 seconds
- TS-2.4.17: Admin dashboard accessible at `/admin/analytics/anyon_funnel`
- TS-2.4.18: Dashboard requires admin authentication (non-admin redirected)
- TS-2.4.19: Dashboard displays daily metrics (CTA clicks, project links)
- TS-2.4.20: Dashboard displays weekly/monthly trend chart
- TS-2.4.21: Dashboard CSV export downloads file
- TS-2.4.22: Cookie consent banner displays for EU users (check IP geolocation)
- TS-2.4.23: GA4/GTM loads only after consent granted

**Manual Tests:**
- TS-2.4.24: Verify GA4 property and data stream configuration in GA4 console
- TS-2.4.25: Verify GTM container has GA4 tag and triggers configured
- TS-2.4.26: Test GDPR compliance (data export includes analytics, deletion cascades)
- TS-2.4.27: Verify Sentry error tagging (`epic: 'anyon_integration'`)
- TS-2.4.28: Test alert configurations (Sentry, GA4 absence monitoring)

---

#### Story 2.5: "Built with ANYON" Post Template

**Unit Tests (RSpec):**
- TS-2.5.1: Template metadata includes `template_used: 'anyon_showcase'`
- TS-2.5.2: Template auto-suggests tags: `#anyon`, `#project-showcase`, `#vibecoding`

**E2E Tests (Cypress):**
- TS-2.5.3: Template selectable from "New Post" dropdown
- TS-2.5.4: Selecting template pre-fills editor with structured content
- TS-2.5.5: All sections present (Title, Intro, Problem, Why ANYON, Build, Results, Lessons, Conclusion)
- TS-2.5.6: Help text visible in each section (light gray, italicized)
- TS-2.5.7: ANYON Project URL field pre-expanded in template
- TS-2.5.8: User can edit/remove sections (template is guidance, not enforced)
- TS-2.5.9: Published post displays "Project Showcase" badge
- TS-2.5.10: Post appears in `/tags/project-showcase` feed

**Manual Tests:**
- TS-2.5.11: Admin creates template in `/admin/customization/article_templates`
- TS-2.5.12: Verify template content quality and help text clarity
- TS-2.5.13: Visual QA of "Project Showcase" badge
- TS-2.5.14: Test template promotion on user dashboard

---

### Test Data

**Seed Data for Testing:**

```ruby
# db/seeds/vibecoding_epic2_test.rb

# Test users
admin_user = User.create!(
  username: 'admin_vibecoding',
  email: 'admin@vibecoding.test',
  password: 'password123',
  admin: true
)

author_user = User.create!(
  username: 'anyon_author',
  email: 'author@vibecoding.test',
  password: 'password123'
)

# Test articles with ANYON projects
article_with_project = Article.create!(
  user: author_user,
  title: 'Building a SaaS Platform with ANYON',
  body: 'This is a test article showcasing an ANYON project...',
  anyon_project_url: 'https://anyon.app/projects/test-project-123',
  published: true
)

article_without_project = Article.create!(
  user: author_user,
  title: 'Regular Vibecoding Article',
  body: 'This article does not have an ANYON project linked...',
  published: true
)

# Test user with ANYON projects
author_user.update!(
  anyon_projects: [
    { title: 'My First SaaS', url: 'https://anyon.app/projects/saas-1', added_at: 1.month.ago.iso8601 },
    { title: 'AI Chatbot', url: 'https://anyon.app/projects/chatbot-ai', added_at: 2.weeks.ago.iso8601 }
  ]
)

# Test analytics events
VibeCodingAnalytic.create!(
  user: author_user,
  event_type: 'cta_click_header',
  event_data: { location: 'header', campaign: 'mvp_launch' },
  tracked_at: 1.hour.ago
)

VibeCodingAnalytic.create!(
  user: author_user,
  event_type: 'project_linked_post',
  event_data: { article_id: article_with_project.id, project_url: article_with_project.anyon_project_url },
  tracked_at: 30.minutes.ago
)
```

**Test Environment Variables:**

```bash
# .env.test
ANYON_SIGNUP_URL=https://staging.anyon.test/signup
GA4_MEASUREMENT_ID=G-TEST12345
GTM_CONTAINER_ID=GTM-TEST67
```

---

### Acceptance Testing

**Definition of Done for Epic 2:**

- ✅ All 5 stories (2.1 through 2.5) completed
- ✅ All acceptance criteria (AC-2.1 through AC-2.5) verified
- ✅ All automated tests passing (unit, integration, E2E)
- ✅ Manual testing completed:
  - Cross-browser (Chrome, Firefox, Safari, Edge)
  - Cross-device (desktop, tablet, mobile)
  - GA4 real-time event verification
  - GDPR compliance review
- ✅ Performance metrics met:
  - CTA render time < 50ms
  - Tracking API response time < 200ms p95
  - No degradation in page load times (LCP < 2.5s maintained)
- ✅ Security audit passed:
  - Brakeman scan (no critical vulnerabilities)
  - URL validation tested (HTTPS enforcement)
  - XSS prevention verified
- ✅ Staging environment validated:
  - All features functional on staging
  - GA4/GTM configured and tracking
  - Admin dashboard accessible
  - No P0/P1 bugs
- ✅ Production deployment checklist:
  - Environment variables set (`ANYON_SIGNUP_URL`, `GA4_MEASUREMENT_ID`, `GTM_CONTAINER_ID`)
  - Database migrations run successfully
  - Cookie consent banner active
  - Sentry error tracking configured
  - Monitoring alerts active

---

### Test Environment Requirements

**Local Development:**
- Ruby 3.3.0, Rails 7.0.8.4
- PostgreSQL 14+ with JSONB support
- Redis 4.7.1+
- Node.js 20.x, Yarn 1.22.18
- Test databases: `vibecoding_test`

**Staging:**
- Railway/Render staging environment
- Separate GA4 property (`G-STAGING-XXXX`)
- Separate GTM container (`GTM-STAGING-XX`)
- Same configuration as production (mirrored)
- Test data seeded (users, articles, projects, analytics)

**Production:**
- Railway/Render production environment
- Production GA4 property
- Production GTM container
- Monitoring active (Sentry, alerts, health checks)

---

### Test Execution Schedule

**Per Story (Development):**
- Developer writes unit tests alongside code (TDD)
- Integration tests written after feature completion
- E2E tests written for critical user flows
- All tests pass before PR merge

**Epic 2 Completion (QA):**
- Full regression test suite (all stories)
- Cross-browser/device testing
- Performance testing (Lighthouse CI)
- Security audit (Brakeman, manual review)
- GA4/GTM verification in staging

**Pre-Production (Final Validation):**
- Smoke tests on staging
- Admin dashboard validation
- GDPR compliance review
- Documentation review (tech spec, user docs)

**Post-Deployment (Production Monitoring):**
- Monitor GA4 events for 24 hours (ensure tracking works)
- Check Sentry for errors
- Review analytics dashboard for data accuracy
- User feedback collection (via community)

---

### Test Coverage Targets

| Test Type | Target Coverage | Epic 2 Actual |
|-----------|----------------|---------------|
| Unit (Backend) | 80% | To be measured post-implementation |
| Unit (Frontend) | 70% | To be measured post-implementation |
| Integration | Critical flows | 5 stories, ~15 scenarios |
| E2E | Happy paths + key error cases | ~30 Cypress tests |
| Manual | Full user journey | QA sign-off required |

---

### Defect Management

**Bug Severity Levels:**
- **P0 (Critical):** Blocks Epic 2 functionality (e.g., CTAs don't render, tracking completely broken, XSS vulnerability)
  - **Response:** Fix immediately, deploy hotfix
- **P1 (High):** Major feature degradation (e.g., GA4 events not firing, admin dashboard 500 error)
  - **Response:** Fix within 24 hours
- **P2 (Medium):** Minor issues (e.g., incorrect UTM parameter, badge styling off)
  - **Response:** Fix before production deployment
- **P3 (Low):** Nice-to-have improvements (e.g., help text wording, performance optimization)
  - **Response:** Backlog for future sprint

**Bug Tracking:**
- GitHub Issues with labels: `epic-2`, `bug`, `P0`/`P1`/`P2`/`P3`
- Daily standup review of open bugs
- Zero P0/P1 bugs before production deploy

---

_Generated by BMad Epic Tech Context Workflow v1.0_
_Date: 2025-11-09_
_For: JSup_
_Project: vibecoding-community_
_Epic: 2 - ANYON Integration & Conversion Funnel_
