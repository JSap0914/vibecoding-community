# Story 2.4: Conversion Tracking & Analytics Setup

Status: drafted

## Story

As a **Growth Analyst**,
I want comprehensive tracking of the community → ANYON conversion funnel,
so that I can measure community ROI and optimize conversion rates.

## Acceptance Criteria

### Google Analytics 4 Setup
1. **AC-2.4.1**: GA4 property created for Vibecoding Community
2. **AC-2.4.2**: Data stream configured for production domain
3. **AC-2.4.3**: `GA4_MEASUREMENT_ID` environment variable set (staging + production)
4. **AC-2.4.4**: GA4 measurement code loads on all pages (via GTM)

### Google Tag Manager Setup
5. **AC-2.4.5**: GTM container created and published
6. **AC-2.4.6**: `GTM_CONTAINER_ID` environment variable set (staging + production)
7. **AC-2.4.7**: GTM snippet added to `app/views/layouts/application.html.erb` in `<head>`
8. **AC-2.4.8**: GTM noscript snippet added after `<body>` tag

### Custom Events Configured
9. **AC-2.4.9**: `anyon_cta_click` event sends to GA4 with parameters: `location`, `timestamp`
10. **AC-2.4.10**: `anyon_project_view` event sends to GA4 with parameters: `post_id` or `user_id`, `timestamp`
11. **AC-2.4.11**: Events appear in GA4 real-time reports within 30 seconds

### Database Tracking
12. **AC-2.4.12**: `vibecoding_analytics` table exists with all required columns
13. **AC-2.4.13**: Indexes created on `user_id`, `event_type`, `tracked_at`, `event_data`
14. **AC-2.4.14**: Table captures events: `cta_click_header`, `cta_click_sidebar`, `cta_click_footer`, `project_linked_post`, `project_linked_profile`, `project_view`

### Tracking API Endpoints
15. **AC-2.4.15**: `POST /api/custom/anyon/track_conversion` endpoint functional
16. **AC-2.4.16**: Endpoint requires authentication (logged-in user preferred, anonymous allowed)
17. **AC-2.4.17**: Endpoint validates `event_type` against whitelist
18. **AC-2.4.18**: Endpoint returns 201 Created on success with event details
19. **AC-2.4.19**: Endpoint returns 422 Unprocessable Entity on invalid input
20. **AC-2.4.20**: Endpoint respects rate limiting: 100 requests/hour per user
21. **AC-2.4.21**: `POST /api/custom/anyon/validate_project_url` endpoint functional for URL validation

### Admin Dashboard
22. **AC-2.4.22**: Custom admin page created at `/admin/analytics/anyon_funnel`
23. **AC-2.4.23**: Dashboard requires admin role (Pundit policy enforces)
24. **AC-2.4.24**: Dashboard displays daily metrics: Total CTA clicks (by location), Total project links, Unique users
25. **AC-2.4.25**: Dashboard displays weekly/monthly trends (line chart)
26. **AC-2.4.26**: Dashboard displays top 10 converting posts (table with title, clicks, CTR)
27. **AC-2.4.27**: Dashboard displays top 10 authors driving ANYON traffic (leaderboard)
28. **AC-2.4.28**: Dashboard includes CSV export functionality
29. **AC-2.4.29**: Dashboard data refreshes every 5 minutes (cached)

### GDPR Compliance
30. **AC-2.4.30**: Cookie consent banner implemented for EU users
31. **AC-2.4.31**: GA4 and GTM load only after user grants analytics consent
32. **AC-2.4.32**: Privacy policy updated to mention ANYON conversion tracking
33. **AC-2.4.33**: User data export includes `vibecoding_analytics` records
34. **AC-2.4.34**: User deletion cascades to `vibecoding_analytics` (ON DELETE CASCADE)

### Monitoring & Alerts
35. **AC-2.4.35**: Sentry error tracking active for all Epic 2 code (tagged `epic: 'anyon_integration'`)
36. **AC-2.4.36**: Alert configured for tracking API error rate > 10%
37. **AC-2.4.37**: Alert configured for GA4 events dropping to zero (1-hour window)

## Tasks / Subtasks

- [ ] Task 1: GA4 and GTM Infrastructure Setup (AC: #1-8)
  - [ ] 1.1: Create GA4 property in Google Analytics console for Vibecoding Community
  - [ ] 1.2: Configure data stream for production domain (vibecoding.community)
  - [ ] 1.3: Create staging data stream for testing environment
  - [ ] 1.4: Add `GA4_MEASUREMENT_ID` to `.env.staging` and production environment variables
  - [ ] 1.5: Create GTM container in Google Tag Manager console
  - [ ] 1.6: Add `GTM_CONTAINER_ID` to environment variables (staging + production)
  - [ ] 1.7: Insert GTM snippet in `app/views/layouts/application.html.erb` `<head>` section
  - [ ] 1.8: Insert GTM noscript snippet after `<body>` tag in application layout
  - [ ] 1.9: Test GTM loading in browser developer tools (Network tab)
  - [ ] 1.10: Verify GA4 pageview events appear in real-time reports

- [ ] Task 2: Database Schema - VibeCodingAnalytic Model (AC: #12-14)
  - [ ] 2.1: Create migration `db/migrate/YYYYMMDD_create_vibecoding_analytics.rb`
  - [ ] 2.2: Define table schema with columns: `id`, `user_id` (nullable), `event_type`, `event_data` (JSONB), `tracked_at`, `created_at`
  - [ ] 2.3: Add composite index on `user_id`, `event_type`, `tracked_at`
  - [ ] 2.4: Add GIN index on `event_data` for JSONB querying
  - [ ] 2.5: Add database comment documenting VIBECODING customization
  - [ ] 2.6: Run migration and verify schema changes
  - [ ] 2.7: Create `app/models/vibecoding_analytic.rb` model
  - [ ] 2.8: Add validations: `event_type` presence, inclusion in whitelist
  - [ ] 2.9: Add scope methods: `by_event_type`, `recent`, `for_user`
  - [ ] 2.10: Write RSpec tests for model validations and scopes

- [ ] Task 3: Service Layer - Anyon::ConversionTracker (AC: #9-11, #15-21)
  - [ ] 3.1: Create `app/services/anyon/conversion_tracker.rb` service
  - [ ] 3.2: Implement `track_event(event_type, metadata = {})` method
  - [ ] 3.3: Add event type whitelist validation
  - [ ] 3.4: Implement database persistence to `vibecoding_analytics` table
  - [ ] 3.5: Add GA4 event broadcasting via JavaScript (data layer push)
  - [ ] 3.6: Implement error handling and logging
  - [ ] 3.7: Add rate limiting logic (Redis-based, 100 req/hour per user)
  - [ ] 3.8: Write RSpec tests for service methods

- [ ] Task 4: Tracking API Controller (AC: #15-21)
  - [ ] 4.1: Create `app/controllers/api/custom/anyon_integrations_controller.rb`
  - [ ] 4.2: Implement `POST /api/custom/anyon/track_conversion` endpoint
  - [ ] 4.3: Add authentication check (logged-in preferred, anonymous allowed)
  - [ ] 4.4: Implement request validation (event_type whitelist, metadata sanitization)
  - [ ] 4.5: Call `Anyon::ConversionTracker` service to persist event
  - [ ] 4.6: Return 201 Created with event details on success
  - [ ] 4.7: Return 422 Unprocessable Entity on validation errors
  - [ ] 4.8: Implement rate limiting middleware (Rack::Attack)
  - [ ] 4.9: Create `POST /api/custom/anyon/validate_project_url` endpoint
  - [ ] 4.10: Add routes to `config/routes.rb` under `namespace :api` → `namespace :custom`
  - [ ] 4.11: Write RSpec request tests for both endpoints

- [ ] Task 5: Frontend Analytics Integration (AC: #9-11)
  - [ ] 5.1: Create `app/javascript/analytics/ga4_tracker.js` module
  - [ ] 5.2: Implement `trackAnyonCTAClick(location)` function (pushes to GTM data layer)
  - [ ] 5.3: Implement `trackAnyonProjectView(post_id, user_id)` function
  - [ ] 5.4: Configure GTM triggers and tags for custom events
  - [ ] 5.5: Map data layer events to GA4 custom events (`anyon_cta_click`, `anyon_project_view`)
  - [ ] 5.6: Test events fire correctly in GA4 real-time reports (<30 seconds latency)
  - [ ] 5.7: Write Jest tests for tracking functions

- [ ] Task 6: Admin Analytics Dashboard (AC: #22-29)
  - [ ] 6.1: Create `app/controllers/admin/analytics_controller.rb`
  - [ ] 6.2: Implement `anyon_funnel` action with Pundit authorization
  - [ ] 6.3: Create `app/views/admin/analytics/anyon_funnel.html.erb` view
  - [ ] 6.4: Build dashboard query service: `Anyon::AnalyticsDashboard.new(date_range)`
  - [ ] 6.5: Implement daily metrics query: Total CTA clicks (grouped by location), Total project links, Unique users
  - [ ] 6.6: Implement weekly/monthly trends query (aggregated by day/week)
  - [ ] 6.7: Implement top 10 converting posts query (join with articles, calculate clicks/CTR)
  - [ ] 6.8: Implement top 10 authors leaderboard (aggregate by user)
  - [ ] 6.9: Add CSV export action (`format.csv`)
  - [ ] 6.10: Implement caching strategy (Rails.cache, 5-minute TTL)
  - [ ] 6.11: Add Chart.js or similar library for trend visualization
  - [ ] 6.12: Style dashboard using Crayons design system
  - [ ] 6.13: Add route to `config/routes.rb`: `namespace :admin` → `get 'analytics/anyon_funnel'`
  - [ ] 6.14: Write system tests for dashboard access and metric display

- [ ] Task 7: GDPR Compliance (AC: #30-34)
  - [ ] 7.1: Research and select cookie consent solution (e.g., CookieYes, Osano, or custom)
  - [ ] 7.2: Implement cookie consent banner for EU users (IP geolocation)
  - [ ] 7.3: Configure GTM to load only after user grants analytics consent
  - [ ] 7.4: Add consent state to localStorage/sessionStorage
  - [ ] 7.5: Update `config/privacy_policy.md` or equivalent with ANYON tracking disclosure
  - [ ] 7.6: Extend user data export to include `vibecoding_analytics` records (GDPR Article 20)
  - [ ] 7.7: Ensure user deletion cascades to `vibecoding_analytics` (foreign key constraint)
  - [ ] 7.8: Test consent banner functionality in staging
  - [ ] 7.9: Verify data export includes analytics events
  - [ ] 7.10: Verify user deletion removes analytics records

- [ ] Task 8: Monitoring and Alerting (AC: #35-37)
  - [ ] 8.1: Verify Sentry is configured in project (check `config/initializers/sentry.rb`)
  - [ ] 8.2: Add Sentry tag `epic: 'anyon_integration'` to all Epic 2 controllers/services
  - [ ] 8.3: Configure Sentry alert for tracking API error rate > 10% (1-hour window)
  - [ ] 8.4: Set up GA4 or external monitoring for event volume
  - [ ] 8.5: Configure alert for GA4 events dropping to zero (1-hour window, PagerDuty or Slack)
  - [ ] 8.6: Test error tracking by triggering intentional error in staging
  - [ ] 8.7: Document alerting setup in runbook or ops documentation

- [ ] Task 9: Integration and System Testing (All ACs)
  - [ ] 9.1: Write integration tests for `Anyon::ConversionTracker` service
  - [ ] 9.2: Write request tests for tracking API endpoints
  - [ ] 9.3: Write system tests (Capybara) for GTM snippet presence
  - [ ] 9.4: Test GA4 event firing in staging environment (manual verification)
  - [ ] 9.5: Test admin dashboard access control (non-admin should get 403)
  - [ ] 9.6: Test dashboard metric calculations with seeded data
  - [ ] 9.7: Test CSV export functionality
  - [ ] 9.8: Test rate limiting (exceed 100 req/hour, verify 429 response)
  - [ ] 9.9: Test GDPR consent flow (EU IP simulation)
  - [ ] 9.10: Test user deletion cascades to analytics table
  - [ ] 9.11: Verify Sentry error tracking captures Epic 2 errors

- [ ] Task 10: Documentation and Deployment Preparation (All ACs)
  - [ ] 10.1: Document GA4 setup process in `docs/deployment-runbook.md`
  - [ ] 10.2: Document GTM container configuration (tags, triggers, variables)
  - [ ] 10.3: Document environment variable setup (`GA4_MEASUREMENT_ID`, `GTM_CONTAINER_ID`)
  - [ ] 10.4: Update `.env.example` with new environment variables
  - [ ] 10.5: Document admin dashboard usage in internal wiki or README
  - [ ] 10.6: Create deployment checklist for Epic 2 analytics setup
  - [ ] 10.7: Update privacy policy (coordinate with legal/compliance if needed)

## Dev Notes

### Architecture Patterns and Constraints

**Brownfield Customization Strategy (ADR-001):**
- Use Service Object pattern for analytics tracking (`Anyon::ConversionTracker`)
- Extend Forem with custom namespaced controllers (`Api::Custom::AnyonIntegrationsController`)
- Database table follows `vibecoding_*` naming convention for clarity
- Google Tag Manager (GTM) for flexible analytics without code deploys
- Admin dashboard under `/admin` namespace using existing Forem admin layout

**Analytics Architecture:**
- **Dual tracking**: GA4 for external analytics + custom database for internal reporting
- **Event whitelist**: Prevent arbitrary event types from being tracked
- **Rate limiting**: Protect tracking API from abuse (100 req/hour per user)
- **Caching**: Dashboard queries cached for 5 minutes to reduce database load
- **JSONB event_data**: Flexible schema for event metadata, indexed with GIN for fast queries

**Service Layer:**
- `Anyon::ConversionTracker`: Core service for event tracking, handles both GA4 and database persistence
- `Anyon::AnalyticsDashboard`: Query service for admin dashboard metrics, encapsulates complex aggregations
- Both services under `app/services/anyon/` namespace

**Frontend Architecture:**
- GTM data layer for event broadcasting: `window.dataLayer.push({event: 'anyon_cta_click', ...})`
- GA4 custom events configured in GTM (not hardcoded in application)
- JavaScript module: `app/javascript/analytics/ga4_tracker.js` for event helpers
- Cookie consent integration: GTM conditionally loads based on user consent

**Security:**
- Pundit authorization for admin dashboard (requires admin role)
- API authentication: prefer logged-in users, allow anonymous with stricter rate limits
- GDPR compliance: consent-based tracking, user data export/deletion
- Sentry tagging for error tracking and alerting

### Source Tree Components to Touch

**Backend Files:**
- `db/migrate/YYYYMMDD_create_vibecoding_analytics.rb` - NEW migration
- `app/models/vibecoding_analytic.rb` - NEW model
- `app/services/anyon/conversion_tracker.rb` - NEW service
- `app/services/anyon/analytics_dashboard.rb` - NEW query service
- `app/controllers/api/custom/anyon_integrations_controller.rb` - NEW API controller
- `app/controllers/admin/analytics_controller.rb` - NEW admin controller
- `config/routes.rb` - Add API and admin routes
- `config/initializers/sentry.rb` - Add Epic 2 tagging (if exists)
- `.env.example` - Document new environment variables

**Frontend Files:**
- `app/views/layouts/application.html.erb` - Add GTM snippets (<head> and <body>)
- `app/javascript/analytics/ga4_tracker.js` - NEW tracking helpers
- `app/views/admin/analytics/anyon_funnel.html.erb` - NEW dashboard view
- Cookie consent component (location TBD based on Forem structure)

**Configuration Files:**
- `.env.staging` - Add `GA4_MEASUREMENT_ID`, `GTM_CONTAINER_ID`
- Production environment variables (Railway/Render/etc.) - Same as staging
- `config/privacy_policy.md` - Update with analytics disclosure

**Testing Files:**
- `spec/models/vibecoding_analytic_spec.rb` - NEW model tests
- `spec/services/anyon/conversion_tracker_spec.rb` - NEW service tests
- `spec/services/anyon/analytics_dashboard_spec.rb` - NEW query service tests
- `spec/requests/api/custom/anyon_integrations_spec.rb` - NEW API tests
- `spec/requests/admin/analytics_spec.rb` - NEW admin controller tests
- `spec/system/admin_analytics_dashboard_spec.rb` - NEW system tests
- `app/javascript/analytics/__tests__/ga4_tracker.test.js` - NEW Jest tests

**Documentation Files:**
- `docs/deployment-runbook.md` - Add GA4/GTM setup instructions
- `docs/architecture.md` - Document analytics architecture decisions (optional update)
- Internal wiki or README - Admin dashboard usage guide

### Testing Standards Summary

**From Architecture: Testing Strategy**
- **Unit Tests (RSpec):** Test `VibeCodingAnalytic` model, `Anyon::ConversionTracker` service, `Anyon::AnalyticsDashboard` query service
- **Integration Tests (RSpec):** Test API endpoints (tracking, validation), admin dashboard controller
- **System Tests (Capybara):** Test GTM snippet presence, admin dashboard UI, consent banner flow
- **Frontend Tests (Jest):** Test `ga4_tracker.js` event functions
- **Manual Verification:** GA4 real-time reports, GTM event debugging, Sentry alert testing

**Test Coverage Target:** Maintain >80% coverage per project testing standards

**Key Test Scenarios:**
1. Event tracking flow: Frontend event → API call → Database persistence → GA4 event
2. Rate limiting: Exceed 100 req/hour → Verify 429 response
3. Authorization: Non-admin access to `/admin/analytics/anyon_funnel` → 403 Forbidden
4. GDPR: Deny consent → GTM/GA4 should not load
5. Data integrity: User deletion → Verify `vibecoding_analytics` records deleted

### Project Structure Notes

**Alignment with Unified Project Structure:**
- Follow Rails convention: `app/services/anyon/` for namespaced services
- API controllers: `app/controllers/api/custom/` for Vibecoding-specific APIs
- Admin controllers: `app/controllers/admin/` consistent with Forem admin structure
- Migrations: `db/migrate/` with descriptive YYYYMMDD timestamp prefixes
- JavaScript modules: `app/javascript/analytics/` for tracking logic
- Tests mirror source structure

**Naming Conventions:**
- Ruby files: `snake_case` (e.g., `conversion_tracker.rb`)
- Database table: `vibecoding_analytics` (plural, prefixed)
- Database columns: `snake_case` (e.g., `event_type`, `tracked_at`)
- JavaScript files: `snake_case` (e.g., `ga4_tracker.js`)
- CSS classes: Use Crayons utility classes for admin dashboard

**Environment Variables:**
- `GA4_MEASUREMENT_ID` - Format: `G-XXXXXXXXXX`
- `GTM_CONTAINER_ID` - Format: `GTM-XXXXXXX`
- Document in `.env.example` with placeholder values

**No Detected Conflicts:** All changes are additive (new table, new services, new controllers). GTM integration is non-invasive (layout snippet addition).

### References

**Technical Specifications:**
- [Source: docs/tech-spec-epic-2.md#AC-2.4: Conversion Tracking & Analytics Setup] - Detailed acceptance criteria (AC-2.4.1 through AC-2.4.37)
- [Source: docs/tech-spec-epic-2.md#3. VibeCodingAnalytic Model] - Database schema design
- [Source: docs/tech-spec-epic-2.md#Custom API Endpoints (Story 2.4)] - API contract specifications
- [Source: docs/tech-spec-epic-2.md#Workflow 4: Analytics Reporting] - Dashboard query logic
- [Source: docs/tech-spec-epic-2.md#1. Google Analytics 4 (GA4)] - GA4 integration details
- [Source: docs/tech-spec-epic-2.md#2. Google Tag Manager (GTM)] - GTM setup instructions

**Epic Context:**
- [Source: docs/epics.md#Story 2.4: Conversion Tracking & Analytics Setup] - User story, high-level acceptance criteria
- [Source: docs/epics.md#Epic 2: ANYON Integration & Conversion Funnel] - Epic goal: measure community ROI

**Architecture Decisions:**
- [Source: docs/architecture.md#ADR-001: Brownfield Customization Strategy] - Extension patterns for Forem
- [Source: docs/architecture.md#Pattern 3: Service Objects] - Business logic encapsulation pattern
- [Source: docs/architecture.md#Testing Strategy] - Coverage targets, test types, frameworks

**Prerequisites:**
- Story 2.3 (Profile Project Linking) should ideally be implemented first, but Story 2.4 can proceed independently since it creates the tracking infrastructure used by 2.1-2.3

## Dev Agent Record

### Context Reference

<!-- Path(s) to story context XML will be added here by context workflow -->

### Agent Model Used

Claude Sonnet 4.5 (claude-sonnet-4-5-20250929)

### Debug Log References

### Completion Notes List

### File List
