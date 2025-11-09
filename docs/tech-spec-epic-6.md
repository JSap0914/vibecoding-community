# Epic Technical Specification: Performance Optimization & Security Hardening

Date: 2025-11-09
Author: JSup
Epic ID: 6
Status: Draft

---

## Overview

Epic 6 focuses on ensuring the Vibecoding Community platform meets production-ready standards for performance, security, and operational resilience. This epic addresses critical non-functional requirements (NFRs) that protect user trust, improve SEO rankings through fast load times, reduce bounce rates, and prevent costly security incidents.

The epic encompasses five key areas: Core Web Vitals optimization to achieve Google's performance thresholds, comprehensive security hardening including GDPR compliance, robust monitoring and alerting infrastructure, scalability preparation through load testing, and backup/disaster recovery procedures. All work leverages Forem's existing optimizations while adding targeted enhancements for the vibecoding community's specific needs.

## Objectives and Scope

**In Scope:**
- Performance optimization to meet Core Web Vitals targets (LCP < 2.5s, FID < 100ms, CLS < 0.1)
- Security hardening: HTTPS/TLS 1.3, security headers, CSRF protection, rate limiting, GDPR compliance
- Comprehensive monitoring: application metrics, infrastructure health, error tracking, alerting
- Scalability preparation: load testing for 1,000+ concurrent users, auto-scaling configuration
- Backup and disaster recovery: automated daily backups, documented recovery procedures (RTO < 4hrs, RPO < 24hrs)
- CDN configuration (Cloudflare) for static asset delivery
- Image optimization pipeline (WebP format, lazy loading, responsive images)
- Database query optimization and indexing
- SSL certificate management and auto-renewal

**Out of Scope:**
- Major infrastructure migrations (staying on Railway/Render for MVP)
- Advanced APM tools (New Relic/Datadog - using hosting platform metrics for MVP)
- Complex caching strategies beyond Forem defaults
- Custom CDN implementation (using Cloudflare free tier)
- Penetration testing (scheduled for post-launch)
- Multi-region deployment
- Advanced DDoS mitigation beyond Cloudflare free tier

## System Architecture Alignment

This epic aligns with the brownfield customization strategy defined in the Architecture document (ADR-001). We leverage Forem's existing performance optimizations (server-side rendering, Rails fragment caching, ESBuild bundling, Redis caching) and security features (Devise authentication, Pundit authorization, CSRF protection) while adding targeted enhancements.

**Key Architectural Components Referenced:**
- **Hosting Platform:** Railway/Render with managed PostgreSQL and Redis (ADR-003)
- **CDN Layer:** Cloudflare free tier for static assets, DDoS protection, and DNS (Section: Deployment Architecture)
- **External Services:** Cloudinary (image optimization), SendGrid (email), Sentry (error tracking), GA4 (RUM)
- **Database:** PostgreSQL 14+ with connection pooling via PgBouncer, custom indexes on ANYON fields
- **Caching:** Redis for sessions, page cache, job queues
- **Background Jobs:** Sidekiq for async processing

**Consistency Pattern:** All custom monitoring, logging, and security configurations follow the "VIBECODING" namespace pattern (Pattern 2) with structured logging (Section: Logging Strategy) to maintain clear separation from Forem core code and ensure upgrade safety.

## Detailed Design

### Services and Modules

| Module/Service | Responsibility | Inputs | Outputs | Owner/Location |
|----------------|----------------|--------|---------|----------------|
| **Performance Optimizer** | Image optimization, lazy loading, code splitting | Image assets, JS bundles | Optimized WebP images, split bundles | `lib/vibecoding/performance_optimizer.rb` |
| **Security Headers Manager** | Configure and validate security headers | HTTP requests | Security headers (HSTS, CSP, etc.) | `config/initializers/security_headers.rb` |
| **Monitoring Service** | Collect and aggregate metrics | Application events, logs | Metrics data, alerts | `lib/vibecoding/monitoring_service.rb` |
| **Backup Manager** | Automated database backups | PostgreSQL database | Encrypted backup files to S3 | `lib/tasks/vibecoding_backup.rake` |
| **Load Testing Suite** | Simulate traffic and measure performance | Test scenarios, user profiles | Performance reports, bottleneck analysis | `spec/load/` (k6 or JMeter scripts) |
| **Health Check Endpoint** | Application health monitoring | None | JSON health status | `app/controllers/health_controller.rb` |
| **GDPR Compliance Module** | Cookie consent, data export/deletion | User requests | User data exports, deletion confirmations | `app/services/vibecoding/gdpr_service.rb` |
| **Rate Limiter** | Prevent abuse on auth and API endpoints | HTTP requests | 429 responses when limits exceeded | `config/initializers/rack_attack.rb` |

**Integration Points:**
- Cloudflare CDN for static asset delivery and DDoS protection
- Sentry for error tracking and exception reporting
- GA4 for Real User Monitoring (RUM) performance data
- Hosting platform (Railway/Render) metrics dashboard for infrastructure monitoring
- SendGrid for email delivery with SPF/DKIM/DMARC configuration

### Data Models and Contracts

**No New Tables Required** - This epic primarily deals with infrastructure and configuration. However, we utilize existing Forem tables:

**Existing Tables Used:**
- `users` - For GDPR data export/deletion
- `articles`, `comments`, `reactions` - Optimized with database indexes
- `vibecoding_analytics` (from Epic 2) - For performance metrics tracking

**Database Optimization:**

```sql
-- Performance indexes (Story 6.1)
CREATE INDEX CONCURRENTLY idx_articles_published_at_desc
  ON articles(published_at DESC) WHERE published = true;

CREATE INDEX CONCURRENTLY idx_articles_score_published
  ON articles(score DESC, published_at DESC) WHERE published = true;

-- ANYON project URLs (from Epic 2, optimized for Epic 6)
CREATE INDEX CONCURRENTLY idx_articles_anyon_project_url
  ON articles(anyon_project_url) WHERE anyon_project_url IS NOT NULL;

-- Analytics performance
CREATE INDEX CONCURRENTLY idx_vibecoding_analytics_composite
  ON vibecoding_analytics(event_type, tracked_at DESC);
```

**Configuration Schema:**

```yaml
# config/vibecoding.yml (Epic 6 additions)
performance:
  lighthouse_threshold: 90
  lcp_target_ms: 2500
  fid_target_ms: 100
  cls_target: 0.1
  image_optimization:
    webp_quality: 85
    lazy_load_threshold: 800

security:
  hsts_max_age: 31536000
  csp_directives:
    default_src: ["'self'"]
    script_src: ["'self'", "'unsafe-inline'", "https://www.googletagmanager.com"]
    img_src: ["'self'", "https:", "data:"]
  rate_limits:
    login_attempts: 5
    login_period: 300
    post_creation: 5
    post_period: 86400

monitoring:
  sentry_dsn: ENV['SENTRY_DSN']
  alert_thresholds:
    error_rate: 0.01
    response_time_p95_ms: 1000

backup:
  schedule: "0 2 * * *"  # 2 AM daily
  retention_days: 30
  s3_bucket: ENV['BACKUP_S3_BUCKET']
```

### APIs and Interfaces

**Health Check Endpoint (Story 6.3):**

```
GET /health
Content-Type: application/json

Response (200 OK):
{
  "status": "healthy",
  "timestamp": "2025-11-09T12:34:56Z",
  "services": {
    "database": "healthy",
    "redis": "healthy",
    "sidekiq": "healthy"
  },
  "metrics": {
    "response_time_ms": 45,
    "db_connections": 8,
    "redis_memory_mb": 128
  }
}

Response (503 Service Unavailable):
{
  "status": "unhealthy",
  "timestamp": "2025-11-09T12:34:56Z",
  "services": {
    "database": "unhealthy",
    "redis": "healthy",
    "sidekiq": "degraded"
  },
  "errors": ["Database connection pool exhausted"]
}
```

**GDPR Data Export Endpoint (Story 6.2):**

```
POST /api/custom/gdpr/export
Authorization: Bearer <user_token>
Content-Type: application/json

Request:
{
  "format": "json"  # or "csv"
}

Response (202 Accepted):
{
  "job_id": "export-12345",
  "status": "processing",
  "estimated_completion": "2025-11-09T13:00:00Z"
}

# Later: GET /api/custom/gdpr/export/export-12345
Response (200 OK):
{
  "job_id": "export-12345",
  "status": "completed",
  "download_url": "https://s3.../user-data-export.zip",
  "expires_at": "2025-11-10T12:34:56Z"
}
```

**Backup Status Endpoint (Internal/Admin Only):**

```
GET /admin/vibecoding/backups
Authorization: Admin session

Response (200 OK):
{
  "backups": [
    {
      "id": "backup-2025-11-09",
      "created_at": "2025-11-09T02:00:00Z",
      "size_mb": 2048,
      "status": "completed",
      "location": "s3://backups/vibecoding/2025-11-09.dump.gz"
    }
  ],
  "last_restore_test": "2025-11-01T10:00:00Z",
  "next_scheduled": "2025-11-10T02:00:00Z"
}
```

### Workflows and Sequencing

**Performance Optimization Workflow (Story 6.1):**

```
1. Developer commits code
   ↓
2. GitHub Actions CI runs
   ↓
3. Lighthouse CI audit (performance budget check)
   ↓
4. If Lighthouse score < 90 → Build fails, developer notified
   ↓
5. If score >= 90 → Build passes
   ↓
6. Deploy to staging
   ↓
7. Real User Monitoring (RUM) via GA4 tracks Core Web Vitals
   ↓
8. Weekly performance report generated
   ↓
9. If metrics degrade → Alert to DevOps team
```

**Security Incident Response Workflow (Story 6.2):**

```
1. Security event detected (rate limit triggered, suspicious login, etc.)
   ↓
2. Sentry captures event with context
   ↓
3. Structured log entry created: "VIBECODING: Security event - rate_limit_exceeded"
   ↓
4. If critical severity → Slack/email alert to on-call engineer
   ↓
5. Engineer reviews logs and Sentry trace
   ↓
6. Take action: block IP, disable account, deploy hotfix
   ↓
7. Document incident in incident log
   ↓
8. Post-mortem review (for P0/P1 incidents)
```

**Backup and Recovery Workflow (Story 6.5):**

```
Daily Backup (Automated):
1. Cron job triggers at 2 AM UTC (lib/tasks/vibecoding_backup.rake)
   ↓
2. pg_dump creates database snapshot
   ↓
3. Compress with gzip
   ↓
4. Encrypt backup file
   ↓
5. Upload to S3 with 30-day lifecycle
   ↓
6. Verify backup integrity (checksum)
   ↓
7. Log success/failure to monitoring service
   ↓
8. If failure → Alert DevOps team

Disaster Recovery (Manual):
1. Incident declared (data loss, corruption, etc.)
   ↓
2. On-call engineer retrieves latest backup from S3
   ↓
3. Spin up new PostgreSQL instance
   ↓
4. Restore database from backup (pg_restore)
   ↓
5. Verify data integrity and completeness
   ↓
6. Update DNS/config to point to new instance
   ↓
7. Test application functionality
   ↓
8. Monitor for issues
   ↓
9. RTO target: < 4 hours | RPO: < 24 hours (last backup)
```

**Load Testing Workflow (Story 6.4):**

```
1. DevOps engineer creates load test scenario (k6 script)
   ↓
2. Define user behaviors: browse posts, create post, comment, search
   ↓
3. Configure load profile: ramp from 0 → 1,000 concurrent users over 10 min
   ↓
4. Execute load test against staging environment
   ↓
5. Monitor metrics: response times, error rates, database connections, memory usage
   ↓
6. Identify bottlenecks: slow queries, memory leaks, connection pool exhaustion
   ↓
7. Optimize identified issues
   ↓
8. Re-run load test to validate improvements
   ↓
9. Document results and scaling thresholds
   ↓
10. Configure auto-scaling rules based on load test findings
```

## Non-Functional Requirements

### Performance

**Core Web Vitals Targets (Story 6.1):**
- **LCP (Largest Contentful Paint):** < 2.5 seconds (75th percentile)
- **FID (First Input Delay):** < 100ms (75th percentile)
- **CLS (Cumulative Layout Shift):** < 0.1 (75th percentile)
- **FCP (First Contentful Paint):** < 1.5 seconds
- **TTI (Time to Interactive):** < 3.5 seconds
- **Lighthouse Performance Score:** > 90 (enforced in CI/CD)

**API Response Times:**
- Homepage rendering: < 500ms (p95)
- Post listing API: < 500ms (p95)
- Search queries: < 1 second (p95)
- Post creation/editing: < 2 seconds (p95)
- Comment submission: < 1 second (p95)

**Implementation Techniques (from PRD Section: Non-Functional Requirements - Performance):**
- Image optimization: WebP format with 85% quality, lazy loading below fold
- Code splitting: ESBuild-based chunking for Preact components
- CSS optimization: Critical CSS inlining, minification
- CDN: Cloudflare for all static assets (images, CSS, JS)
- Browser caching: 1 year for fingerprinted assets, 5 minutes for HTML
- Server-side rendering: All public content pre-rendered
- Database query optimization: N+1 elimination, eager loading, strategic indexes
- Fragment caching: Rails fragment cache for expensive partial renders

**Monitoring:**
- Lighthouse CI in GitHub Actions (blocks merge if score < 90)
- Real User Monitoring (RUM) via GA4
- Performance budgets enforced: max bundle size 250KB (gzipped)
- Weekly performance reports to DevOps team

### Security

**Authentication & Authorization (Story 6.2):**
- **Password Hashing:** Bcrypt with salt (Devise default)
- **OAuth 2.0:** GitHub, Twitter, Google providers (OmniAuth)
- **Session Management:** Secure, HTTP-only cookies with SameSite=Lax
- **CSRF Protection:** Rails built-in authenticity tokens on all state-changing operations
- **Rate Limiting:**
  - Login attempts: 5 per 5 minutes per IP
  - Post creation: 5 per day for users < 7 days old
  - API endpoints: 100 requests per minute per user

**Transport & Headers (Story 6.2):**
- **HTTPS/TLS 1.3:** Enforced on all connections, HTTP redirects to HTTPS
- **HSTS:** max-age=31536000; includeSubDomains; preload
- **Content Security Policy (CSP):**
  - default-src 'self'
  - script-src 'self' 'unsafe-inline' https://www.googletagmanager.com https://www.google-analytics.com
  - img-src 'self' https: data:
  - style-src 'self' 'unsafe-inline'
- **X-Frame-Options:** SAMEORIGIN (prevent clickjacking)
- **X-Content-Type-Options:** nosniff
- **Referrer-Policy:** strict-origin-when-cross-origin

**Input Validation & Injection Prevention:**
- **XSS Prevention:** Rails auto-escaping, Content Security Policy
- **SQL Injection:** ActiveRecord parameterized queries (ORM-only database access)
- **URL Validation:** ANYON project URLs validated with URI parser
- **Markdown Sanitization:** HTML sanitizer for user-generated content

**GDPR Compliance (Story 6.2):**
- **Cookie Consent Banner:** EU users must consent before analytics cookies loaded
- **Privacy Policy:** /privacy page with data collection transparency
- **Data Export:** Users can download all their data (JSON/CSV format)
- **Data Deletion:** Users can request account deletion with cascade to all user data
- **Data Processing Agreement:** Documented in /privacy-policy

**Dependency Security:**
- **Automated Scanning:** Dependabot enabled for Ruby gems and npm packages
- **Vulnerability Alerts:** Sentry integration for runtime security events
- **SSL Certificate:** Auto-renewal via Let's Encrypt or hosting provider
- **Security Audit Logging:** All authentication events, admin actions, data exports logged

**Incident Response:**
- **Response Plan:** Documented in docs/incident-response.md
- **On-Call Rotation:** DevOps engineer available 24/7
- **Breach Notification:** 72-hour GDPR compliance for data breaches
- **Penetration Testing:** Scheduled quarterly post-launch

### Reliability/Availability

**Availability Targets (Story 6.5):**
- **Uptime SLA:** 99.5% (43.8 hours downtime/year acceptable for MVP)
- **Degraded Performance:** < 1% of requests
- **Planned Maintenance:** Monthly window, 2 AM UTC, < 2 hours

**Recovery Targets (Story 6.5):**
- **RTO (Recovery Time Objective):** < 4 hours
- **RPO (Recovery Point Objective):** < 24 hours (daily backups)

**Resilience Strategies:**
- **Database Backups:** Automated daily at 2 AM UTC, retained 30 days, encrypted at rest
- **Connection Pooling:** PgBouncer for database connection management
- **Graceful Degradation:**
  - Search falls back to simple text search if PostgreSQL FTS slow
  - Images served from CDN cache even if origin down
  - Background jobs retry with exponential backoff (Sidekiq default)
- **Circuit Breakers:** Timeout external API calls (Cloudinary, SendGrid) after 10 seconds
- **Health Checks:** /health endpoint monitored every 30 seconds by hosting platform

**Disaster Recovery Procedures (Story 6.5):**
1. Backup verification: Monthly restore test to staging environment
2. Runbook documentation: Step-by-step recovery procedures in docs/disaster-recovery.md
3. Alternative hosting: Pre-configured secondary hosting provider identified
4. Data integrity checks: Automated checksums on backups
5. Rollback strategy: Previous deployment artifacts retained 30 days

**Error Handling:**
- **500 Errors:** Custom error page, logged to Sentry with full context
- **Database Failures:** Connection retry with exponential backoff (3 attempts)
- **External Service Failures:** Graceful degradation, user-friendly error messages
- **Background Job Failures:** Automatic retry (3 attempts), then dead letter queue with alert

### Observability

**Application Monitoring (Story 6.3):**
- **APM:** Hosting platform metrics (Railway/Render built-in dashboard)
  - Response times (p50, p95, p99)
  - Throughput (requests/second)
  - Error rates
  - Memory usage, CPU utilization
- **Error Tracking:** Sentry (free tier: 5,000 events/month)
  - Exception capture with stack traces
  - User context (user ID, session ID, browser)
  - Performance transaction tracing
  - Release tracking for regression detection

**Infrastructure Monitoring (Story 6.3):**
- **Database:**
  - Query performance: Slow query log (> 1 second)
  - Connection pool: Active/idle connections
  - Disk usage: Alert at 80% capacity
  - Replication lag: For read replicas (if configured)
- **Redis:**
  - Memory usage
  - Hit/miss ratio
  - Command latency
- **Background Jobs (Sidekiq):**
  - Queue depth (alert if > 1,000 pending jobs)
  - Job processing times
  - Failed jobs count
  - Retry queue depth

**Logging (Story 6.3):**
- **Structured Logging:** JSON format with consistent fields
  ```ruby
  {
    "timestamp": "2025-11-09T12:34:56Z",
    "level": "info",
    "message": "VIBECODING: Performance optimization completed",
    "user_id": 123,
    "duration_ms": 45,
    "environment": "production"
  }
  ```
- **Log Aggregation:** Hosting platform log viewer (Railway/Render)
- **Log Levels:**
  - DEBUG: Development only (verbose tracking)
  - INFO: Important events (deployments, migrations, scheduled jobs)
  - WARN: Potential issues (slow queries, high memory)
  - ERROR: Failures requiring attention (exceptions, service outages)
  - FATAL: Critical failures (database connection lost)
- **Log Retention:** 7 days on hosting platform, 30 days for ERROR+ levels in Sentry

**Alerting (Story 6.3):**
- **Critical Alerts (PagerDuty/Email):**
  - Application error rate > 1%
  - Database connection pool exhausted
  - Disk usage > 90%
  - SSL certificate expiring < 7 days
  - Backup failure
  - Response time p95 > 2 seconds
- **Warning Alerts (Slack/Email):**
  - Error rate > 0.1%
  - Response time p95 > 1 second
  - Sidekiq queue depth > 500
  - Unusual traffic spike (> 2x normal)
- **Alert Channels:**
  - Email for critical alerts
  - Slack #ops-alerts for warnings
  - Weekly digest report to team

**Real User Monitoring (RUM):**
- **GA4 Integration:** Track Core Web Vitals from real users
- **Session Recording:** NOT implemented (privacy concerns, post-MVP consideration)
- **Performance Metrics:**
  - Page load times by route
  - Browser/device breakdown
  - Geographic performance distribution
  - Conversion funnel drop-off analysis

## Dependencies and Integrations

### Ruby Dependencies (Gemfile)

**Performance Related:**
- `puma ~> 5.6.4` - High-concurrency HTTP server
- `bootsnap >= 1.1.0` - Boot performance optimization
- `rack-timeout ~> 0.6` - Request timeout middleware to prevent hanging requests
- `redis ~> 4.7.1` - Caching and session storage
- `redis-actionpack ~> 5.4.0` - Redis session store for Rails

**Security & Authentication:**
- `devise ~> 4.8` - User authentication (existing)
- `pundit ~> 2.2` - Authorization policies (existing)
- `rack-attack ~> 6.7.0` - **CRITICAL FOR EPIC 6** - Rate limiting and throttling
- `omniauth ~> 2.1` + providers (GitHub, Google, Twitter, Facebook, Apple)
- `omniauth-rails_csrf_protection ~> 1.0` - CSRF protection for OAuth
- `recaptcha ~> 5.10` - Bot prevention

**Monitoring & Error Tracking:**
- `honeybadger ~> 4.12` - Error tracking (Forem default, can replace with Sentry)
- `honeycomb-beeline ~> 2.11.0` - Observability and monitoring
- `ddtrace ~> 1.16.2` - Datadog APM (optional, not required for MVP)
- `dogstatsd-ruby ~> 5.6` - StatsD metrics (optional)

**Image Optimization:**
- `cloudinary ~> 1.23` - **CRITICAL FOR EPIC 6** - Image hosting and optimization
- `carrierwave ~> 2.2` - File upload management
- `mini_magick ~> 4.13` - Image manipulation
- `fastimage ~> 2.2` - Fast image size detection
- `imgproxy ~> 2.1` - On-the-fly image resizing

**Database:**
- `pg ~> 1.4` - PostgreSQL adapter
- `pg_search ~> 2.3.6` - Full-text search
- `pghero ~> 3.6` - **USEFUL FOR EPIC 6** - Database performance dashboard

**Background Jobs:**
- `sidekiq` (implicit dependency via Forem) - Background job processing

**Additional Epic 6 Dependencies (to be added):**
```ruby
# Add to Gemfile for Epic 6
gem 'sentry-ruby', '~> 5.18'  # Error tracking (replace Honeybadger)
gem 'sentry-rails', '~> 5.18'  # Rails integration for Sentry
# rack-attack already present
```

### JavaScript Dependencies (package.json)

**Build & Bundling:**
- `esbuild ^0.19.12` - **CRITICAL FOR EPIC 6** - Fast JavaScript bundling
- `@babel/core ^7.23.3` - JavaScript transpilation
- `postcss ^8.4.31` - CSS processing and optimization
- `autoprefixer ^10.4.16` - Automatic vendor prefixes

**Frontend Framework:**
- `preact ^10.20.2` - **CORE FRAMEWORK** - Lightweight React alternative
- `@babel/plugin-transform-react-jsx ^7.22.15` - JSX transformation
- `@hotwired/stimulus 3.2.2` - JavaScript framework for Rails

**Performance Optimization:**
- `intersection-observer ^0.12.2` - Lazy loading support
- `focus-trap ^6.9.4` - Accessibility and performance

**Monitoring:**
- `ahoy.js ^0.4.4` - Event tracking (complements GA4)
- `@honeybadger-io/js ^6.9.1` - Frontend error tracking

**Testing:**
- `cypress ^13.7.2` - **CRITICAL FOR EPIC 6** - E2E testing for load testing setup
- `jest 28.1.3` - Unit testing
- `@testing-library/preact ^2.0.1` - Component testing

**Additional Epic 6 Dependencies (to be added):**
```json
{
  "devDependencies": {
    "@sentry/browser": "^7.100.0",  // Frontend error tracking
    "lighthouse": "^11.5.0",  // Performance auditing in CI
    "k6": "^0.49.0"  // Load testing (if using k6)
  }
}
```

### External Services & Integrations

| Service | Purpose | Tier | Cost (MVP) | Configuration |
|---------|---------|------|------------|---------------|
| **Cloudflare CDN** | Static asset delivery, DDoS protection | Free | $0/month | DNS + SSL auto-renewal |
| **Cloudinary** | Image optimization, hosting, transformations | Free | $0/month | ENV: CLOUDINARY_URL |
| **Sentry** | Error tracking, performance monitoring | Free (5k events) | $0/month | ENV: SENTRY_DSN |
| **SendGrid** | Transactional email (SPF/DKIM/DMARC) | Free (100/day) | $0/month | ENV: SENDGRID_API_KEY |
| **Railway/Render** | Hosting platform with PostgreSQL + Redis | Starter | $30-50/month | Auto-configured |
| **PostgreSQL** | Managed database (14+) | Managed (Railway/Render) | Included | Auto-configured |
| **Redis** | Cache, sessions, job queue | Managed (Railway/Render) | Included | Auto-configured |
| **Google Analytics 4** | Web analytics, Core Web Vitals tracking | Free | $0/month | GTM_ID in ENV |
| **Google Tag Manager** | Event tracking and conversion tracking | Free | $0/month | GTM container |
| **Google Search Console** | SEO monitoring, sitemap submission | Free | $0/month | Manual setup |
| **AWS S3** | Backup storage (encrypted) | Pay-as-you-go | ~$5/month | ENV: S3_BACKUP_BUCKET |
| **Let's Encrypt** | SSL certificate (via hosting provider) | Free | $0/month | Auto-renewal |

**Total External Service Cost (MVP):** ~$35-55/month

### Integration Patterns

**CDN Integration (Cloudflare):**
```ruby
# config/environments/production.rb
config.action_controller.asset_host = ENV['CDN_HOST']  # e.g., https://cdn.vibecoding.community
config.action_mailer.asset_host = ENV['CDN_HOST']
```

**Error Tracking Integration (Sentry):**
```ruby
# config/initializers/sentry.rb
Sentry.init do |config|
  config.dsn = ENV['SENTRY_DSN']
  config.breadcrumbs_logger = [:active_support_logger, :http_logger]
  config.traces_sample_rate = 0.1  # 10% transaction sampling
  config.environment = Rails.env
  config.release = ENV['GIT_SHA']
end
```

**Performance Monitoring (Lighthouse CI):**
```yaml
# .github/workflows/lighthouse.yml
- name: Lighthouse CI
  uses: treosh/lighthouse-ci-action@v9
  with:
    urls: |
      https://staging.vibecoding.community
      https://staging.vibecoding.community/tags/anyon
    uploadArtifacts: true
    temporaryPublicStorage: true
    budgetPath: ./lighthouse-budget.json  # Performance budgets
```

**Health Check Integration:**
```ruby
# config/routes.rb
get '/health', to: 'health#index'

# app/controllers/health_controller.rb (Story 6.3)
class HealthController < ActionController::Base
  def index
    render json: {
      status: all_services_healthy? ? 'healthy' : 'unhealthy',
      services: check_services
    }, status: all_services_healthy? ? 200 : 503
  end
end
```

### Version Constraints & Compatibility

**Ruby Version:** 3.3.0 (from .ruby-version)
**Node Version:** 20.x (from package.json engines)
**Rails Version:** ~> 7.0.8.4
**PostgreSQL Version:** 14+ (managed by hosting provider)
**Redis Version:** 4.7.1+

**Browser Support:**
- Chrome/Edge: Latest 2 versions
- Firefox: Latest 2 versions
- Safari: Latest 2 versions (iOS and macOS)
- Mobile browsers: iOS Safari 14+, Chrome Mobile latest

**Breaking Changes / Upgrade Considerations:**
- Forem platform upgrades: All VIBECODING customizations documented for safe upgrades
- Rails 7.1+ upgrade path: Prepared but not required for MVP
- PostgreSQL 15/16: Compatible but staying on 14 for MVP stability
- ESBuild: Using Forem's existing esbuild configuration, no changes needed

## Acceptance Criteria (Authoritative)

### Story 6.1: Performance Optimization & Core Web Vitals

**AC-6.1.1:** Core Web Vitals meet targets
- **Given** the platform is deployed to production
- **When** measured by Google PageSpeed Insights and Real User Monitoring
- **Then** the following thresholds are met at 75th percentile:
  - LCP (Largest Contentful Paint) < 2.5 seconds
  - FID (First Input Delay) < 100ms
  - CLS (Cumulative Layout Shift) < 0.1
  - FCP (First Contentful Paint) < 1.5 seconds
  - TTI (Time to Interactive) < 3.5 seconds

**AC-6.1.2:** Lighthouse Performance Score enforced in CI
- **Given** a developer creates a pull request
- **When** GitHub Actions runs the CI pipeline
- **Then** Lighthouse CI audit runs and enforces score > 90
- **And** if score < 90, the build fails with performance regression details

**AC-6.1.3:** Image optimization implemented
- **Given** images are uploaded to the platform
- **When** images are served to users
- **Then** images are optimized:
  - WebP format with 85% quality
  - Lazy loading for images below the fold
  - Responsive images with appropriate sizes
  - Served via Cloudflare CDN

**AC-6.1.4:** Code splitting and asset optimization
- **Given** JavaScript and CSS assets
- **When** the application is built and deployed
- **Then** assets are optimized:
  - JavaScript bundled via ESBuild with code splitting
  - CSS minified with critical CSS inlined
  - Total bundle size < 250KB gzipped
  - Cache headers set: 1 year for fingerprinted assets

**AC-6.1.5:** Real User Monitoring (RUM) tracking
- **Given** GA4 is integrated
- **When** users browse the platform
- **Then** Core Web Vitals are tracked and reported in GA4
- **And** weekly performance reports are generated

### Story 6.2: Security Hardening & Compliance

**AC-6.2.1:** HTTPS/TLS 1.3 enforced
- **Given** the platform is deployed
- **When** a user visits any page
- **Then** all connections use HTTPS/TLS 1.3
- **And** HTTP requests are redirected to HTTPS
- **And** SSL certificate is valid and auto-renews

**AC-6.2.2:** Security headers configured
- **Given** any HTTP response
- **When** headers are inspected
- **Then** the following security headers are present:
  - HSTS: max-age=31536000; includeSubDomains; preload
  - Content-Security-Policy (CSP) with appropriate directives
  - X-Frame-Options: SAMEORIGIN
  - X-Content-Type-Options: nosniff
  - Referrer-Policy: strict-origin-when-cross-origin

**AC-6.2.3:** Rate limiting configured
- **Given** rate limiting is enabled via rack-attack
- **When** excessive requests are made
- **Then** rate limits are enforced:
  - Login attempts: 5 per 5 minutes per IP
  - Post creation: 5 per day for new users (< 7 days)
  - API endpoints: 100 requests per minute per user
- **And** 429 (Too Many Requests) response returned when exceeded

**AC-6.2.4:** GDPR compliance implemented
- **Given** EU users visit the platform
- **When** they interact with the site
- **Then** GDPR compliance features are available:
  - Cookie consent banner displayed before analytics loaded
  - Privacy policy page accessible at /privacy
  - Data export functionality via user settings
  - Data deletion functionality (right to be forgotten)
- **And** all user data exports include vibecoding_analytics data

**AC-6.2.5:** Input validation and injection prevention
- **Given** user-submitted content
- **When** content is processed and displayed
- **Then** security measures are active:
  - XSS prevention via Rails auto-escaping and CSP
  - SQL injection prevention via ActiveRecord parameterized queries
  - URL validation for ANYON project links
  - Markdown sanitization for user-generated content

**AC-6.2.6:** Dependency security scanning
- **Given** Dependabot is enabled
- **When** a vulnerability is detected in dependencies
- **Then** a pull request is automatically created to update the vulnerable dependency
- **And** alerts are sent to the development team

### Story 6.3: Monitoring, Logging & Alerting

**AC-6.3.1:** Application monitoring configured
- **Given** the application is running
- **When** monitoring systems are checked
- **Then** the following metrics are tracked:
  - Response times (p50, p95, p99)
  - Throughput (requests/second)
  - Error rates
  - Memory usage and CPU utilization

**AC-6.3.2:** Error tracking via Sentry
- **Given** an error occurs in the application
- **When** the error is captured
- **Then** Sentry records:
  - Exception with full stack trace
  - User context (user ID, session ID, browser)
  - Request context (URL, HTTP method, headers)
  - Environment and release version
- **And** alerts are sent for critical errors

**AC-6.3.3:** Structured logging implemented
- **Given** application events occur
- **When** logs are generated
- **Then** logs are structured in JSON format with:
  - timestamp, level, message
  - user_id, duration_ms, environment
  - "VIBECODING:" prefix for custom logs
- **And** logs are aggregated in hosting platform log viewer

**AC-6.3.4:** Health check endpoint functional
- **Given** the health check endpoint exists at /health
- **When** the endpoint is requested
- **Then** it returns JSON with:
  - Overall status (healthy/unhealthy)
  - Individual service statuses (database, redis, sidekiq)
  - Basic metrics (response_time_ms, db_connections, redis_memory_mb)
- **And** returns HTTP 200 if healthy, 503 if unhealthy
- **And** hosting platform monitors this endpoint every 30 seconds

**AC-6.3.5:** Alerting configured
- **Given** monitoring thresholds are configured
- **When** thresholds are exceeded
- **Then** alerts are sent via appropriate channels:
  - Critical alerts (>1% error rate, db pool exhausted) → Email
  - Warning alerts (>0.1% error rate, slow queries) → Slack
  - Weekly digest reports → Team email

### Story 6.4: Scalability Preparation & Load Testing

**AC-6.4.1:** Load testing demonstrates scalability
- **Given** a load testing scenario with k6 or JMeter
- **When** load test simulates 1,000 concurrent users
- **Then** the platform meets performance targets:
  - Response times remain < 1 second (p95)
  - Error rate stays < 0.1%
  - Database connections don't exceed pool limit
  - Background job queue doesn't back up
- **And** results are documented with identified bottlenecks and optimizations

**AC-6.4.2:** Auto-scaling configured
- **Given** auto-scaling rules are configured on Railway/Render
- **When** traffic increases beyond thresholds
- **Then** additional application instances are automatically provisioned
- **And** load is distributed across instances
- **And** scaling events are logged

**AC-6.4.3:** Database optimization for scale
- **Given** the database is under load
- **When** queries are executed
- **Then** performance optimizations are in place:
  - Strategic indexes on frequently queried columns
  - PgBouncer for connection pooling
  - Slow query log enabled (> 1 second)
  - N+1 query prevention via eager loading

**AC-6.4.4:** Caching strategy implemented
- **Given** the application serves content
- **When** users make requests
- **Then** caching is utilized:
  - Redis caching for sessions, page cache, job queues
  - CDN caching for static assets via Cloudflare
  - Fragment caching for expensive partial renders
  - Browser caching with appropriate cache headers

### Story 6.5: Backup & Disaster Recovery

**AC-6.5.1:** Automated daily backups
- **Given** the backup cron job is configured
- **When** 2 AM UTC arrives each day
- **Then** an automated backup runs:
  - pg_dump creates database snapshot
  - Backup is compressed with gzip
  - Backup is encrypted at rest
  - Backup is uploaded to S3 with 30-day retention
  - Backup integrity is verified via checksum
- **And** success/failure is logged and monitored

**AC-6.5.2:** Backup restoration tested
- **Given** backups are being created
- **When** a monthly restore test is performed
- **Then** backup can be successfully restored to staging environment
- **And** data integrity is verified
- **And** test results are documented

**AC-6.5.3:** Disaster recovery procedures documented
- **Given** a disaster recovery plan is required
- **When** procedures are reviewed
- **Then** documentation exists for:
  - Step-by-step recovery procedures in docs/disaster-recovery.md
  - RTO (Recovery Time Objective) < 4 hours
  - RPO (Recovery Point Objective) < 24 hours
  - Alternative hosting provider identified and pre-configured
  - Rollback strategy with previous deployment artifacts retained 30 days
- **And** on-call rotation is established

**AC-6.5.4:** Incident response plan
- **Given** an incident occurs
- **When** the incident response plan is followed
- **Then** the plan covers:
  - Incident declaration and on-call notification
  - Data loss/corruption recovery procedures
  - Communication plan for users and stakeholders
  - Post-mortem template and process

## Traceability Mapping

| AC # | Story | Spec Section | Component/API | Test Approach |
|------|-------|--------------|---------------|---------------|
| **AC-6.1.1** | 6.1 | NFR: Performance - Core Web Vitals | Entire application | Lighthouse audit + GA4 RUM monitoring |
| **AC-6.1.2** | 6.1 | Workflows: Performance Optimization | GitHub Actions CI | CI/CD integration test |
| **AC-6.1.3** | 6.1 | Services: Performance Optimizer | Cloudinary + Cloudflare CDN | Visual regression test + Lighthouse image audit |
| **AC-6.1.4** | 6.1 | NFR: Performance - Implementation | ESBuild configuration | Bundle size analysis + performance budget |
| **AC-6.1.5** | 6.1 | NFR: Observability - RUM | GA4 integration | Manual GA4 dashboard verification |
| **AC-6.2.1** | 6.2 | NFR: Security - Transport | SSL/TLS configuration | SSL Labs test + manual verification |
| **AC-6.2.2** | 6.2 | Services: Security Headers Manager | config/initializers/security_headers.rb | Security header scanner (securityheaders.com) |
| **AC-6.2.3** | 6.2 | Services: Rate Limiter | config/initializers/rack_attack.rb | Integration test simulating excessive requests |
| **AC-6.2.4** | 6.2 | Services: GDPR Compliance Module | app/services/vibecoding/gdpr_service.rb | Manual GDPR compliance checklist + data export test |
| **AC-6.2.5** | 6.2 | NFR: Security - Input Validation | Rails application | Security audit (Brakeman) + manual penetration test |
| **AC-6.2.6** | 6.2 | NFR: Security - Dependency Scanning | Dependabot configuration | Verify Dependabot PRs created for known vulnerabilities |
| **AC-6.3.1** | 6.3 | NFR: Observability - Application | Hosting platform dashboard | Manual dashboard verification |
| **AC-6.3.2** | 6.3 | Services: Monitoring Service (Sentry) | Sentry integration | Trigger test exception, verify Sentry capture |
| **AC-6.3.3** | 6.3 | NFR: Observability - Logging | Structured logging | Log inspection + grep for JSON format |
| **AC-6.3.4** | 6.3 | APIs: Health Check Endpoint | app/controllers/health_controller.rb | Integration test + hosting platform uptime monitor |
| **AC-6.3.5** | 6.3 | NFR: Observability - Alerting | Alert configuration | Trigger alert threshold, verify notification received |
| **AC-6.4.1** | 6.4 | Workflows: Load Testing | spec/load/ (k6 scripts) | Execute load test, analyze results |
| **AC-6.4.2** | 6.4 | Deployment Architecture: Scaling | Railway/Render auto-scaling | Simulate traffic spike, verify auto-scaling |
| **AC-6.4.3** | 6.4 | Data Models: Database Optimization | PostgreSQL indexes + PgBouncer | Query performance analysis (PgHero) |
| **AC-6.4.4** | 6.4 | NFR: Performance - Caching | Redis + Cloudflare CDN | Cache hit ratio monitoring |
| **AC-6.5.1** | 6.5 | Services: Backup Manager | lib/tasks/vibecoding_backup.rake | Verify backup creation + S3 upload |
| **AC-6.5.2** | 6.5 | Workflows: Backup and Recovery | Backup restoration procedure | Monthly restore test to staging |
| **AC-6.5.3** | 6.5 | NFR: Reliability - Disaster Recovery | docs/disaster-recovery.md | Documentation review + runbook validation |
| **AC-6.5.4** | 6.5 | Workflows: Security Incident Response | docs/incident-response.md | Incident simulation exercise |

## Risks, Assumptions, Open Questions

### Risks

**R-6.1 [HIGH] - Performance Regression Post-Deployment**
- **Description:** Core Web Vitals may degrade after deployment due to third-party scripts (GA4, GTM) or user-generated content
- **Impact:** Poor SEO rankings, high bounce rate, user dissatisfaction
- **Mitigation:**
  - Lighthouse CI blocks PRs with score < 90
  - Weekly RUM monitoring via GA4
  - Performance budgets enforced (bundle size < 250KB)
  - Gradual rollout with canary deployments
- **Contingency:** Rollback to previous version, optimize offending components

**R-6.2 [HIGH] - Security Vulnerability in Dependencies**
- **Description:** Critical vulnerability discovered in Ruby gem or npm package
- **Impact:** Platform compromise, data breach, reputation damage
- **Mitigation:**
  - Dependabot auto-updates enabled
  - Security audit tools (Brakeman) in CI
  - Subscribe to security mailing lists (Ruby, Rails, Node.js)
- **Contingency:** Emergency patch deployment within 24 hours, user notification if data affected

**R-6.3 [MEDIUM] - Monitoring Blind Spots**
- **Description:** Critical issues not detected by monitoring due to incomplete coverage
- **Impact:** Extended downtime, user impact before detection
- **Mitigation:**
  - Comprehensive health check endpoint covering all services
  - Multiple alert channels (email, Slack)
  - Synthetic monitoring of critical user journeys
- **Contingency:** Manual incident detection via user reports, post-incident monitoring improvement

**R-6.4 [MEDIUM] - Backup Corruption or Restoration Failure**
- **Description:** Backups corrupted or restoration fails during disaster recovery
- **Impact:** Data loss exceeding RPO (24 hours)
- **Mitigation:**
  - Monthly restore tests to staging
  - Automated backup integrity checks (checksums)
  - Multiple backup retention points (30 days)
- **Contingency:** Use older backup (data loss increases), rebuild from application logs where possible

**R-6.5 [MEDIUM] - Auto-Scaling Misconfiguration**
- **Description:** Auto-scaling triggers too aggressively or not aggressively enough
- **Impact:** Excessive costs or performance degradation under load
- **Mitigation:**
  - Load testing to determine optimal thresholds
  - Conservative initial scaling rules
  - Cost alerts set at $100/month threshold
- **Contingency:** Manual scaling adjustment, spending limit enforcement

**R-6.6 [LOW] - GDPR Compliance Gap**
- **Description:** Missing GDPR requirement discovered post-launch (e.g., data retention policy)
- **Impact:** Legal liability, fines (up to 4% of revenue or €20M)
- **Mitigation:**
  - GDPR compliance checklist reviewed by legal counsel
  - Privacy policy drafted with legal review
  - Data processing agreement templates
- **Contingency:** Rapid compliance fix, user notification, legal consultation

**R-6.7 [LOW] - CDN Downtime**
- **Description:** Cloudflare CDN experiences outage
- **Impact:** Slower page loads (images, CSS, JS served from origin), potential origin overload
- **Mitigation:**
  - Origin can serve assets directly (graceful degradation)
  - Cloudflare has 99.9%+ uptime SLA
  - Cache headers allow browser caching
- **Contingency:** Temporary switch to origin-only serving, consider multi-CDN setup post-MVP

### Assumptions

**A-6.1:** Forem's existing performance optimizations (SSR, fragment caching, ESBuild) are sufficient baseline
- **Validation:** Lighthouse audit of baseline Forem instance confirms score > 80

**A-6.2:** Railway/Render hosting platform provides adequate performance for MVP (100-500 users)
- **Validation:** Load testing confirms platform handles 1,000 concurrent users

**A-6.3:** Cloudflare free tier CDN is sufficient for MVP traffic levels
- **Validation:** Cloudflare free tier supports unlimited bandwidth (no overage charges)

**A-6.4:** Sentry free tier (5,000 events/month) is adequate for MVP error volume
- **Validation:** Monitor Sentry event count, upgrade to paid tier if exceeded

**A-6.5:** GA4 accurately tracks Core Web Vitals from real users
- **Validation:** Cross-check GA4 RUM data with Lighthouse field data

**A-6.6:** Database backups via pg_dump are sufficient (no need for point-in-time recovery yet)
- **Validation:** RPO of 24 hours is acceptable for MVP; PITR can be added later

**A-6.7:** Manual SSL certificate renewal via Let's Encrypt is acceptable
- **Validation:** Hosting provider auto-renews SSL certificates (Railway/Render)

**A-6.8:** Team has sufficient DevOps expertise to configure monitoring and respond to alerts
- **Validation:** DevOps engineer with Rails/PostgreSQL experience on team

### Open Questions

**Q-6.1:** Should we implement Datadog APM or rely on hosting platform metrics for MVP?
- **Context:** Datadog provides richer APM features but costs ~$15/host/month
- **Decision Needed By:** Sprint planning for Epic 6
- **Proposed Answer:** Use hosting platform metrics for MVP, evaluate Datadog post-launch if gaps identified

**Q-6.2:** What is the acceptable RTO (Recovery Time Objective) and RPO (Recovery Point Objective)?
- **Context:** Current targets: RTO < 4 hours, RPO < 24 hours (daily backups)
- **Decision Needed By:** Story 6.5 planning
- **Proposed Answer:** RTO/RPO acceptable for MVP; evaluate tightening based on user feedback and growth

**Q-6.3:** Should we configure multi-region deployment for disaster recovery?
- **Context:** Multi-region adds complexity and cost but improves resilience
- **Decision Needed By:** Post-MVP (not required for launch)
- **Proposed Answer:** Single-region deployment for MVP, multi-region if/when community reaches 10k+ active users

**Q-6.4:** Which load testing tool should we use: k6, JMeter, or Gatling?
- **Context:** k6 is modern and scriptable, JMeter is mature, Gatling is Scala-based
- **Decision Needed By:** Story 6.4 implementation
- **Proposed Answer:** k6 (modern, JavaScript-based, integrates with CI/CD easily)

**Q-6.5:** Should we implement rate limiting on read operations (e.g., post viewing)?
- **Context:** Current rate limiting only covers write operations (login, post creation)
- **Decision Needed By:** Security review during Story 6.2
- **Proposed Answer:** Not required for MVP (DDoS protection via Cloudflare sufficient); evaluate post-launch

**Q-6.6:** Do we need a separate staging environment for load testing, or can we use production?
- **Context:** Load testing on production risks degrading user experience
- **Decision Needed By:** Story 6.4 planning
- **Proposed Answer:** Use staging environment for load testing; production only for final validation

**Q-6.7:** Should we implement automated SSL certificate pinning?
- **Context:** SSL pinning provides additional security but adds operational complexity
- **Decision Needed By:** Security review during Story 6.2
- **Proposed Answer:** Not required for MVP (hosting provider manages SSL); consider post-launch

## Test Strategy Summary

### Testing Pyramid for Epic 6

```
                    /\
                   /  \          E2E: Load testing, disaster recovery drills
                  /----\
                 /      \        Integration: API tests, security scans
                /--------\
               /          \      Unit: Service objects, configuration validation
              /------------\
             /______________\
```

### Test Levels and Coverage

**1. Unit Tests (RSpec)**
- **Scope:** Service objects, configuration validators, utility methods
- **Coverage Target:** 80%+ for custom VIBECODING code
- **Examples:**
  - `Vibecoding::PerformanceOptimizer` image optimization logic
  - `Vibecoding::GdprService` data export/deletion methods
  - `HealthController` service status checks
  - Structured logging format validation

**2. Integration Tests (RSpec + Request Specs)**
- **Scope:** API endpoints, service integrations, database queries
- **Coverage Target:** All critical paths covered
- **Examples:**
  - `/health` endpoint returns correct status codes
  - Rate limiting (rack-attack) blocks excessive requests
  - Security headers present in all responses
  - GDPR data export creates valid ZIP file
  - Database backups successfully upload to S3

**3. End-to-End Tests (Cypress)**
- **Scope:** Critical user journeys, performance validation
- **Coverage Target:** Happy path + key error scenarios
- **Examples:**
  - Page load performance meets Core Web Vitals targets
  - Error pages render correctly (500, 503)
  - GDPR cookie consent banner functions
  - User data export flow end-to-end

**4. Load/Performance Tests (k6)**
- **Scope:** Scalability validation, bottleneck identification
- **Coverage Target:** 1,000 concurrent users
- **Examples:**
  - Homepage rendering under load
  - Post creation under concurrent writes
  - Search performance with large dataset
  - Database connection pool under stress
  - Background job queue handling

**5. Security Tests**
- **Scope:** Vulnerability scanning, penetration testing
- **Tools:** Brakeman (Ruby), npm audit, OWASP ZAP (optional)
- **Examples:**
  - Brakeman scan passes with no high/critical issues
  - Security headers validated (securityheaders.com)
  - Rate limiting prevents brute force attacks
  - XSS/SQL injection attempts blocked
  - SSL/TLS configuration validated (SSL Labs)

**6. Manual Tests**
- **Scope:** GDPR compliance, disaster recovery, monitoring validation
- **Examples:**
  - GDPR compliance checklist walkthrough
  - Disaster recovery drill (restore from backup)
  - Alert triggering and notification delivery
  - Lighthouse audit review
  - Browser compatibility testing

### Test Environments

| Environment | Purpose | Data | Configuration |
|-------------|---------|------|---------------|
| **Local** | Development, unit tests | Seed data | .env.development |
| **Staging** | Integration, E2E, load testing | Sanitized production copy | .env.staging |
| **Production** | Final validation, RUM | Real user data | .env.production |

### CI/CD Pipeline Testing

**GitHub Actions Workflow:**
```yaml
1. Lint (Rubocop, ESLint)
2. Unit Tests (RSpec, Jest)
3. Integration Tests (RSpec request specs)
4. Security Scan (Brakeman, npm audit)
5. Lighthouse CI (performance budget)
6. E2E Tests (Cypress) - on staging deployment
7. Deploy to Production (if all pass + manual approval)
```

### Test Data Strategy

- **Unit/Integration Tests:** Factories (FactoryBot) with realistic but minimal data
- **E2E Tests:** Seed data scripts with representative user scenarios
- **Load Tests:** Scripted data generation to simulate 1,000+ users
- **Production:** Real user data (no test data in production)

### Performance Testing Approach

**Lighthouse CI:**
- Runs on every PR against staging URL
- Enforces thresholds: Performance > 90, Accessibility > 90
- Fails build if thresholds not met

**Load Testing (Story 6.4):**
1. Create k6 test scenarios (browse, create post, comment, search)
2. Configure load profile: 0 → 1,000 concurrent users over 10 minutes
3. Execute against staging environment
4. Monitor: response times, error rates, database connections, memory
5. Identify bottlenecks (slow queries, memory leaks, connection exhaustion)
6. Optimize and re-test until targets met
7. Document results and scaling thresholds

**Real User Monitoring (RUM):**
- GA4 tracks Core Web Vitals from production users
- Weekly performance reports generated
- Alerts triggered if metrics degrade > 20%

### Security Testing Approach

**Automated (Story 6.2):**
- Brakeman security scan in CI (blocks on high/critical issues)
- Dependabot auto-updates for vulnerable dependencies
- npm audit / bundle audit in CI

**Manual (Post-Launch):**
- Quarterly penetration testing by security consultant
- GDPR compliance audit by legal counsel
- Security header validation (securityheaders.com, SSL Labs)

### Disaster Recovery Testing (Story 6.5)

**Monthly Drill:**
1. Retrieve latest backup from S3
2. Spin up temporary PostgreSQL instance
3. Restore database from backup
4. Verify data integrity (row counts, checksums)
5. Test sample queries
6. Document RTO (actual time taken)
7. Clean up temporary resources

**Incident Simulation (Quarterly):**
- Simulate disaster scenario (database corruption, hosting outage)
- Follow incident response plan
- Measure RTO against < 4 hour target
- Conduct post-mortem and improve procedures

### Test Metrics and Reporting

**Coverage Reports:**
- RSpec coverage report (SimpleCov): Target 80%+ for custom code
- Jest coverage report: Target 70%+ for JavaScript

**Performance Metrics:**
- Lighthouse CI reports uploaded to GitHub artifacts
- GA4 RUM dashboard for Core Web Vitals trends
- Load test results documented in docs/load-test-results.md

**Security Metrics:**
- Brakeman scan results in CI logs
- Dependabot PR count and resolution time
- Vulnerability count by severity

**Test Execution Tracking:**
- CI/CD pipeline pass rate: Target > 95%
- Flaky test identification and resolution
- Test execution time optimization (< 10 minutes total)
