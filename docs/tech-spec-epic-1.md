# Epic Technical Specification: Platform Foundation & Branding

Date: 2025-11-09
Author: JSup
Epic ID: 1
Status: Draft

---

## Overview

Epic 1 establishes the technical foundation and vibecoding brand identity for the Vibecoding Community platform. This epic focuses on setting up a production-ready Forem instance with custom theming, automated deployment pipelines, and a compelling landing experience that introduces the vibecoding movement and positions ANYON.

**Key Deliverables:**
- Production-ready Forem deployment on Railway/Render with staging environment
- Custom vibecoding theme applied via Crayons design system and CSS overrides
- Landing page, About page, and Community Guidelines that communicate vibecoding value
- Fully documented development environment enabling team onboarding
- Foundation for all subsequent customization work (ANYON integration, SEO, analytics)

**Business Impact:** Creates the essential platform infrastructure that enables community building, establishes vibecoding brand presence, and provides the foundation for ANYON conversion funnel implementation in Epic 2.

## Objectives and Scope

### In-Scope

**Story 1.1: Project Setup & Infrastructure Initialization**
- Git repository configuration with proper .gitignore
- Environment configuration files (.env.example, database.yml)
- Ruby 3.3.0, Rails 7.0.8.4, PostgreSQL, Redis setup
- Development setup documentation in docs/development-guide.md
- Seed data for local testing

**Story 1.2: Local Development Environment Configuration**
- Functional Forem instance on localhost:3000
- Database migrations, Rails console, Preact frontend with hot-reload
- Background jobs via Sidekiq
- RSpec test suite execution
- Docker Compose for PostgreSQL and Redis

**Story 1.3: Deployment Pipeline & Staging Environment**
- Staging environment on Railway/Render
- CI/CD via GitHub Actions
- Automated tests on pull requests
- Database migration automation
- Health check endpoints and rollback procedures
- Error tracking (Sentry) and log aggregation

**Story 1.4: Custom Vibecoding Theme & Visual Identity**
- Custom vibecoding brand colors, logo, favicon
- Typography and dark mode support
- Crayons design system variable customization
- Responsive design (mobile, tablet, desktop)
- WCAG 2.1 Level A accessibility compliance

**Story 1.5: Landing Page & Community Onboarding**
- Homepage with hero section, value proposition, featured content
- Clear "Join the Community" and "Explore Posts" CTAs
- SEO meta tags optimized for "vibecoding community"
- Page load time < 2 seconds (LCP)

**Story 1.6: About Page & Community Guidelines**
- /about page: Mission, ANYON connection, team introduction
- /community-guidelines page: Behavior standards, moderation policy
- Footer navigation links
- SEO optimization

### Out-of-Scope

- ANYON integration (Epic 2)
- SEO meta tag automation and sitemap generation (Epic 3)
- Content seeding beyond initial documentation pages (Epic 4)
- Analytics and tracking setup (Epic 5)
- Performance optimization and security hardening (Epic 6)
- Custom ANYON project embedding or OAuth single sign-on
- Video hosting, gamification, mobile apps

## System Architecture Alignment

### Architecture Constraints

**Brownfield Customization Strategy (ADR-001):**
- Leverage existing Forem platform (106 tables, 305+ UI components)
- Extend, don't modify core Forem code
- All customizations must be namespaced (vibecoding/, custom/)
- Maintain upgrade compatibility with Forem

**Technology Stack (from Architecture):**
- **Backend:** Ruby on Rails 7.0.8.4, Ruby 3.3.0, Puma
- **Frontend:** Preact 10.20.2, Stimulus, Crayons Design System
- **Database:** PostgreSQL 14+ (managed)
- **Cache/Jobs:** Redis 4.7.1+, Sidekiq 6.5.3
- **Hosting:** Railway or Render ($30-50/month MVP)
- **CDN:** Cloudflare Free tier
- **File Storage:** Cloudinary free tier

### Referenced Architecture Components

**Development Environment (Architecture Section):**
- Docker Compose for local PostgreSQL and Redis
- Foreman/Overmind for process management
- RSpec for backend testing, Jest for frontend, Cypress for E2E

**Deployment Architecture:**
```
Cloudflare CDN (Free)
    ↓ HTTPS
Railway/Render App Platform
    ├── Web (Puma) - Rails application
    ├── Workers (Sidekiq) - Background jobs
    ├── PostgreSQL (Managed)
    └── Redis (Managed)
    ↓
External Services: Cloudinary, SendGrid, Sentry
```

**Implementation Patterns (from Architecture):**
- Pattern 1: Forem Extension (concerns, not monkey-patching)
- Pattern 2: Namespaced Customizations (vibecoding/, custom/)
- Pattern 5: Database Migration Pattern (commented migrations)

**Consistency Rules:**
- Files: snake_case, namespaced
- Git commits: `[VIBECODING]` prefix
- CSS classes: Crayons or `.vibecoding-*` prefix
- Logging: `Rails.logger.info("VIBECODING: ...")` format

## Detailed Design

### Services and Modules

| Module/Service | Responsibility | Inputs | Outputs | Owner |
|----------------|----------------|--------|---------|-------|
| **Environment Configuration** | Manage environment variables and configuration files | .env.example, database.yml templates | Configured local/staging/prod environments | DevOps |
| **Docker Compose Stack** | Provide local PostgreSQL and Redis instances | docker-compose.yml | Running postgres:14, redis:7 containers | DevOps |
| **Deployment Service (Railway/Render)** | Deploy application to cloud infrastructure | Dockerfile, railway.toml/render.yaml | Running application instances | DevOps |
| **CI/CD Pipeline** | Automate testing and deployment | .github/workflows/ci.yml | Test results, deployment status | DevOps |
| **Theme Customization Service** | Apply vibecoding brand via Crayons variables | Brand assets, color palette, CSS overrides | Themed Forem instance | Frontend |
| **Landing Page Renderer** | Render custom homepage | app/views/pages/landing.html.erb | HTML homepage with CTAs | Frontend |
| **Static Page Generator** | Create About and Guidelines pages | Markdown content via Forem Pages feature | /about, /community-guidelines routes | Content |
| **Seed Data Service** | Populate initial data for testing | db/seeds/vibecoding_setup.rb | Test users, sample content | Backend |
| **Health Check Endpoint** | Monitor application status | GET /health | JSON status response | Backend |

**Key Implementation Notes:**
- All modules leverage existing Forem infrastructure (no custom services in Epic 1)
- Theme customization uses Forem Admin Panel + CSS overrides (no code changes)
- Landing page is a custom ERB view, not a React component
- Static pages use Forem's built-in Pages feature (admin-managed content)

### Data Models and Contracts

**No New Database Tables in Epic 1**

Epic 1 uses Forem's existing database schema without modifications. The 106 existing Forem tables provide all necessary functionality for this epic:

**Key Forem Tables Used:**
- `users` - User accounts and profiles
- `articles` - Posts and content
- `pages` - Static pages (About, Guidelines)
- `settings` - Application configuration
- `site_configs` - Forem admin panel settings

**Configuration Data (Non-Database):**

```yaml
# config/vibecoding.yml (new file)
development:
  brand_name: "Vibecoding Community"
  tagline: "Where AI meets natural language development"
  primary_color: "#FF6B35"  # Example vibecoding orange
  logo_url: "/assets/vibecoding/logo.svg"

staging:
  brand_name: "Vibecoding Community (Staging)"
  # ... same as production

production:
  brand_name: "Vibecoding Community"
  # ... production values
```

**Environment Variables:**

```bash
# .env (not committed, created from .env.example)

# Database
DATABASE_URL=postgresql://localhost/vibecoding_dev
REDIS_URL=redis://localhost:6379/0

# Application
RAILS_ENV=development
SECRET_KEY_BASE=<generated>
FOREM_OWNER_SECRET=<secret>

# External Services (added in Epic 1 setup)
CLOUDINARY_URL=cloudinary://<api_key>:<api_secret>@<cloud_name>
SENTRY_DSN=https://<key>@sentry.io/<project>
SENDGRID_API_KEY=<key>

# Deployment (Railway/Render)
RAILWAY_ENVIRONMENT=staging  # or production
```

### APIs and Interfaces

**No Custom APIs in Epic 1**

Epic 1 focuses on infrastructure and theming, leveraging Forem's existing API endpoints:

**Forem Built-In APIs Used:**
- `GET /api/articles` - List articles (for landing page featured content)
- `GET /api/users/:id` - User profiles
- `POST /users` - User registration
- `POST /users/sign_in` - Authentication

**Admin Panel Interfaces:**

```
Forem Admin Panel (Web UI)
├── /admin/customization/config
│   └── Theme settings (colors, logo, fonts)
├── /admin/pages
│   └── Create About and Guidelines pages
├── /admin/content_manager/tags
│   └── Pre-create vibecoding tags (Epic 4)
└── /admin/users
    └── User management
```

**Health Check Endpoint (New in Story 1.3):**

```ruby
# config/routes.rb
Rails.application.routes.draw do
  # VIBECODING: Health check for monitoring
  get '/health', to: 'health#show'
end

# app/controllers/health_controller.rb
class HealthController < ApplicationController
  skip_before_action :verify_authenticity_token

  def show
    render json: {
      status: 'ok',
      timestamp: Time.current.iso8601,
      version: ENV['GIT_SHA'] || 'development',
      services: {
        database: database_status,
        redis: redis_status
      }
    }
  end

  private

  def database_status
    ActiveRecord::Base.connection.execute('SELECT 1')
    'connected'
  rescue StandardError
    'disconnected'
  end


  def redis_status
    Redis.current.ping == 'PONG' ? 'connected' : 'disconnected'
  rescue StandardError
    'disconnected'
  end
end
```

### Workflows and Sequencing

#### Workflow 1: Developer Onboarding (Story 1.1, 1.2)

```
1. Clone Repository
   Developer → GitHub → Local machine

2. Install Dependencies
   bin/setup script:
   ├── Check Ruby version (3.3.0)
   ├── Install gems (bundle install)
   ├── Install npm packages (yarn install)
   └── Create .env from .env.example

3. Start Infrastructure
   docker-compose up -d:
   ├── PostgreSQL container (port 5432)
   └── Redis container (port 6379)

4. Initialize Database
   bin/rails db:setup:
   ├── Create database
   ├── Run migrations (106 Forem tables)
   └── Load seed data

5. Start Application
   foreman start -f Procfile.dev:
   ├── Rails server (localhost:3000)
   ├── Sidekiq worker
   └── Webpack dev server (hot reload)

6. Verify Setup
   ├── Visit http://localhost:3000
   ├── Create test user
   └── Publish test post
```

**Sequence Diagram:**
```
Developer -> Git: git clone
Developer -> Docker: docker-compose up -d
Developer -> Setup: bin/setup
Setup -> Bundler: bundle install
Setup -> Database: rails db:setup
Developer -> Foreman: foreman start
Foreman -> Rails: Start Puma server
Foreman -> Sidekiq: Start worker
Developer -> Browser: Visit localhost:3000
Browser -> Rails: GET /
Rails -> Developer: Forem homepage
```

#### Workflow 2: Deployment Pipeline (Story 1.3)

```
1. Code Commit
   Developer → GitHub (feature branch)

2. CI Pipeline Trigger (GitHub Actions)
   .github/workflows/ci.yml:
   ├── Run RSpec tests
   ├── Run Jest tests
   ├── Run Rubocop linter
   ├── Run security scan (Brakeman)
   └── Build Docker image

3. Pull Request Review
   Team review → Approval

4. Merge to Main
   GitHub → Auto-deploy to staging

5. Staging Deployment (Railway/Render)
   ├── Pull latest code
   ├── Build Docker image
   ├── Run migrations (rails db:migrate)
   ├── Restart application
   └── Run health check

6. Smoke Tests
   ├── GET /health → 200 OK
   ├── GET / → Homepage loads
   └── POST /users/sign_in → Auth works

7. Manual Production Deploy (after validation)
   Railway/Render dashboard:
   ├── Promote staging → production
   └── Monitor logs and metrics
```

**Sequence Diagram:**
```
Developer -> GitHub: Push to feature branch
GitHub -> CI: Trigger workflow
CI -> Tests: Run test suite
Tests -> CI: ✓ All pass
Developer -> GitHub: Create PR
Team -> GitHub: Approve PR
Developer -> GitHub: Merge to main
GitHub -> Railway: Deploy to staging
Railway -> Database: Run migrations
Railway -> App: Restart services
Railway -> HealthCheck: GET /health
HealthCheck -> Railway: 200 OK
Team -> Railway: Manual deploy to prod
Railway -> Production: Deploy
```

#### Workflow 3: Theme Customization (Story 1.4)

```
1. Access Forem Admin Panel
   /admin/customization/config

2. Upload Brand Assets
   ├── Logo (SVG, 200x50px)
   ├── Favicon (32x32, 64x64)
   └── App icons (180x180, 512x512)

3. Configure Theme Variables
   Crayons CSS variables:
   ├── --color-primary: #FF6B35 (vibecoding orange)
   ├── --color-secondary: #004E89 (vibecoding blue)
   ├── --font-family-sans: "Inter", sans-serif
   └── --border-radius: 8px

4. Add CSS Overrides (if needed)
   app/assets/stylesheets/vibecoding/theme.scss:
   ├── Custom button styles
   ├── Landing page specific styles
   └── Dark mode adjustments

5. Preview Changes
   Staging environment → Visual review

6. Deploy to Production
   Merge CSS → Auto-deploy
```

#### Workflow 4: Content Page Creation (Story 1.5, 1.6)

```
1. Create Landing Page
   app/views/pages/landing.html.erb:
   ├── Hero section with tagline
   ├── Value proposition (3 columns)
   ├── Featured content (recent posts)
   └── CTA buttons (Join, Explore)

   config/routes.rb:
   └── root to: 'pages#landing'

2. Create About Page (Forem Pages Feature)
   /admin/pages → New Page:
   ├── Slug: "about"
   ├── Title: "About Vibecoding Community"
   ├── Body: Markdown content
   └── Publish

3. Create Guidelines Page (Forem Pages Feature)
   /admin/pages → New Page:
   ├── Slug: "community-guidelines"
   ├── Title: "Community Guidelines"
   ├── Body: Markdown content
   └── Publish

4. Update Footer Navigation
   /admin/customization/config → Footer:
   └── Add links to About, Guidelines

5. SEO Optimization
   Each page → Meta tags:
   ├── <title>Page Title | Vibecoding Community</title>
   ├── <meta name="description" content="...">
   └── <link rel="canonical" href="https://...">
```

**Data Flow for Landing Page:**
```
Browser -> Rails: GET /
Rails -> ArticlesController: fetch recent articles
ArticlesController -> Database: SELECT * FROM articles ORDER BY created_at DESC LIMIT 6
Database -> ArticlesController: Article records
ArticlesController -> View: Render landing.html.erb
View -> Browser: HTML with featured content
```

## Non-Functional Requirements

### Performance

**Target Metrics (from PRD):**
- **LCP (Largest Contentful Paint):** < 2.5 seconds (landing page)
- **FCP (First Contentful Paint):** < 1.5 seconds
- **TTI (Time to Interactive):** < 3.5 seconds
- **Lighthouse Performance Score:** > 90

**Epic 1 Specific Performance Requirements:**

| Metric | Target | Measurement Point | Story |
|--------|--------|-------------------|-------|
| Local dev server startup | < 60 seconds | `foreman start` to localhost:3000 responsive | 1.2 |
| Database migration time | < 5 minutes | `rails db:migrate` execution | 1.1, 1.3 |
| CI/CD pipeline execution | < 10 minutes | GitHub Actions workflow completion | 1.3 |
| Staging deployment time | < 5 minutes | Code push to live staging environment | 1.3 |
| Landing page initial load | < 2 seconds | Browser navigation to / | 1.5 |
| Static page load (About, Guidelines) | < 1.5 seconds | Browser navigation to /about, /community-guidelines | 1.6 |

**Implementation Approach:**
- Leverage Forem's built-in performance optimizations (SSR, fragment caching, asset fingerprinting)
- Use Cloudflare CDN for static assets (Story 1.3)
- Optimize images via Cloudinary automatic compression
- No custom JavaScript bundles in Epic 1 (use Forem defaults)
- Defer Epic 6 for aggressive optimization (code splitting, lazy loading)

**Monitoring (Story 1.3):**
- Railway/Render platform metrics (response time, throughput)
- Manual Lighthouse audits on staging before production deploy
- Browser DevTools Network tab for waterfall analysis

### Security

**Epic 1 Security Requirements:**

**Infrastructure Security (Story 1.3):**
- **HTTPS Enforcement:** All traffic over TLS 1.3 (Railway/Render automatic SSL)
- **Environment Variables:** Secrets stored in hosting platform (never in git)
- **Database Credentials:** Managed by Railway/Render (connection string in ENV)
- **Redis Security:** Password-protected Redis instance (managed service)

**Application Security (Forem Built-In):**
- **Authentication:** Devise with bcrypt password hashing (Forem default)
- **CSRF Protection:** Rails authenticity tokens on all forms
- **XSS Prevention:** Rails ERB auto-escaping, Content Security Policy headers
- **SQL Injection:** ActiveRecord parameterized queries (ORM protection)

**Development Security (Story 1.1, 1.2):**
- **.gitignore:** Exclude .env, credentials, database.yml from version control
- **.env.example:** Template without real secrets (safe to commit)
- **Seed Data:** Use fake/test data only (no production data in development)

**Deployment Security (Story 1.3):**
- **CI/CD Secrets:** GitHub Actions secrets for deployment credentials
- **Dependency Scanning:** Bundler-audit in CI pipeline (detect CVEs)
- **Security Headers:** Rails secure headers (HSTS, X-Frame-Options, X-Content-Type-Options)
- **Error Tracking:** Sentry configured to sanitize sensitive data

**Access Control:**
- **Admin Panel:** Only accessible to authorized users (Forem admin role)
- **Staging Environment:** Password-protected or IP-whitelisted (optional)
- **Production Deploy:** Manual approval required (not automatic from main)

**Compliance:**
- GDPR: Defer to Epic 6 (cookie consent banner, data export)
- Focus Epic 1 on infrastructure security only

### Reliability/Availability

**Availability Targets:**

| Environment | Target Uptime | Acceptable Downtime | Recovery Time |
|-------------|---------------|---------------------|---------------|
| Development | N/A | N/A | Developer restart |
| Staging | 95% | ~36 hours/month | < 30 minutes |
| Production | 99% | ~7 hours/month | < 15 minutes |

**Epic 1 Reliability Measures:**

**Health Monitoring (Story 1.3):**
- **Health Check Endpoint:** `/health` returns database + Redis status
- **Platform Monitoring:** Railway/Render health checks every 30 seconds
- **Auto-Restart:** Unhealthy containers automatically restarted
- **Uptime Monitoring:** External monitoring (UptimeRobot free tier) pings /health every 5 minutes

**Database Reliability:**
- **Managed PostgreSQL:** Railway/Render handles backups, replication, failover
- **Daily Backups:** Automatic daily snapshots (retained 7 days)
- **Connection Pooling:** PgBouncer included in managed service

**Application Reliability:**
- **Graceful Degradation:** Forem continues serving cached pages if Redis fails
- **Job Retries:** Sidekiq automatic retry with exponential backoff
- **Error Handling:** Rails exception handling, user-friendly error pages

**Deployment Reliability (Story 1.3):**
- **Zero-Downtime Deploys:** Railway/Render rolling deploys (keep old version running until new healthy)
- **Rollback Capability:** One-click rollback to previous version in platform dashboard
- **Database Migration Safety:** Review migrations before deploy, reversible migrations
- **Smoke Tests:** Automated health check after deploy before traffic switch

**Disaster Recovery:**
- **Backup Strategy:** Daily database backups retained 7 days (defer long-term archival to Epic 6)
- **Recovery Procedure:** Restore from backup via Railway/Render dashboard
- **RTO (Recovery Time Objective):** < 4 hours
- **RPO (Recovery Point Objective):** < 24 hours (daily backups)

**Failure Scenarios and Mitigation:**

| Failure | Probability | Impact | Mitigation |
|---------|-------------|--------|------------|
| Application crash | Medium | High | Auto-restart, health checks |
| Database connection loss | Low | High | Connection pooling, retry logic |
| Redis failure | Low | Medium | Graceful degradation (cached pages) |
| Hosting platform outage | Low | High | Monitor status page, communicate with users |
| Bad deployment | Medium | High | Automated tests, manual approval, rollback capability |

### Observability

**Logging (Story 1.3):**

**Application Logs:**
```ruby
# Structured logging format for Epic 1
Rails.logger.info(
  "VIBECODING: Setup complete",
  developer: ENV['USER'],
  timestamp: Time.current.iso8601
)

# Log levels
# - info: Setup steps, deployment events
# - warn: Missing configuration (non-blocking)
# - error: Setup failures, deployment errors
```

**Log Aggregation:**
- **Development:** Local stdout (foreman output)
- **Staging/Production:** Railway/Render log viewer (7-day retention)
- **External (Optional):** Papertrail free tier (100MB/month, 2-day retention)

**Key Logged Events (Epic 1):**
- Developer onboarding steps (setup script execution)
- CI/CD pipeline stages (test results, deployment status)
- Deployment events (migration start/complete, app restart)
- Health check failures
- Theme customization changes (admin panel actions)

**Metrics (Story 1.3):**

**Infrastructure Metrics (Railway/Render Dashboard):**
- CPU usage (per container)
- Memory usage (per container)
- Disk usage
- Network I/O
- Response time (p50, p95, p99)
- Request throughput (requests/second)

**Application Metrics:**
- HTTP status codes (2xx, 4xx, 5xx counts)
- Database connection pool usage
- Sidekiq queue depth and processing time

**Custom Metrics (Epic 1):**
- Deployment frequency (manual tracking in Story 1.3)
- CI/CD success rate (GitHub Actions dashboard)
- Developer onboarding time (manual timing in Story 1.1)

**Error Tracking (Story 1.3):**

**Sentry Integration:**
```ruby
# config/initializers/sentry.rb
Sentry.init do |config|
  config.dsn = ENV['SENTRY_DSN']
  config.breadcrumbs_logger = [:active_support_logger, :http_logger]
  config.traces_sample_rate = 0.1  # 10% performance tracing
  config.environment = Rails.env

  # VIBECODING: Tag all errors with epic context
  config.tags = { epic: 'foundation' }
end
```

**Error Monitoring:**
- Real-time alerts for production errors (Sentry email/Slack)
- Error rate threshold: < 0.1% of requests
- Error grouping and deduplication
- Stack traces with source code context

**Alerts (Story 1.3):**

| Alert | Trigger | Channel | Action |
|-------|---------|---------|--------|
| Health check failed | 3 consecutive failures | Railway/Render + Email | Investigate logs, restart if needed |
| Error rate spike | > 10 errors/minute | Sentry → Email/Slack | Check recent deployment, rollback if needed |
| Deployment failure | CI/CD pipeline fail | GitHub Actions → Email | Review logs, fix issue, retry |
| Disk space low | < 20% remaining | Railway/Render → Email | Clean up logs, upgrade plan |

**Dashboards:**

**Railway/Render Dashboard (Primary):**
- Application metrics (CPU, memory, response time)
- Deployment history
- Logs viewer
- Health status

**GitHub Actions (CI/CD):**
- Workflow runs (test results, build status)
- Deployment history
- Test coverage trends

**Manual Monitoring (Epic 1):**
- Weekly Lighthouse audit (performance, accessibility, SEO)
- Manual smoke tests after production deploy
- Developer feedback on onboarding experience

## Dependencies and Integrations

### Ruby Dependencies (Gemfile)

**Core Framework (Forem Existing):**
- `rails` ~> 7.0.8 - Web application framework
- `ruby` 3.3.0 - Programming language
- `puma` - Application server
- `bootsnap` >= 1.1.0 - Boot performance optimization

**Database & Caching:**
- `pg` - PostgreSQL adapter
- `redis` ~> 4.0 - Redis client
- `connection_pool` - Database connection pooling
- `ancestry` ~> 4.2 - Tree structure for nested data

**Authentication & Authorization:**
- `devise` ~> 4.8 - Authentication
- `devise_invitable` ~> 2.0.6 - Invitation system
- `pundit` - Authorization policies

**Background Jobs:**
- `sidekiq` ~> 6.5 - Background job processing
- `sidekiq-cron` - Scheduled jobs

**File Upload & Images:**
- `carrierwave` ~> 2.2 - File uploads
- `cloudinary` ~> 1.23 - Image hosting and optimization
- `fastimage` ~> 2.2 - Image size detection

**Frontend Assets:**
- `sassc-rails` - Sass compilation
- `webpacker` or `jsbundling-rails` - JavaScript bundling

**Testing (Development/Test):**
- `rspec-rails` ~> 6.0 - Testing framework
- `factory_bot_rails` - Test data factories
- `faker` - Fake data generation
- `capybara` - Integration testing
- `webmock` - HTTP request stubbing

**Code Quality (Development):**
- `rubocop` - Ruby linter
- `rubocop-rails` - Rails-specific linting
- `brakeman` - Security scanner

**Epic 1 Additions:**
- `sentry-ruby` - Error tracking (Story 1.3)
- `sentry-rails` - Rails integration for Sentry

### JavaScript Dependencies (package.json)

**Core:**
- `node` 20.x - JavaScript runtime
- `yarn` 1.22.18 - Package manager

**Frontend Framework:**
- `preact` 10.20.2 - UI framework
- `preact-render-to-string` - Server-side rendering

**Build Tools:**
- `esbuild` ~> 0.19 - JavaScript bundler
- `sass` - CSS preprocessing
- `postcss` - CSS processing

**Testing:**
- `jest` - JavaScript testing framework
- `@testing-library/preact` - Component testing
- `cypress` - E2E testing (Story 1.1)

**Code Quality:**
- `eslint` - JavaScript linter
- `prettier` - Code formatter

### External Service Integrations

**Hosting & Infrastructure (Story 1.3):**

| Service | Purpose | Tier | Cost | Configuration |
|---------|---------|------|------|---------------|
| **Railway** or **Render** | Application hosting | Starter | $30-50/month | Dockerfile, railway.toml/render.yaml |
| **PostgreSQL (Managed)** | Primary database | Included in hosting | $0 (included) | DATABASE_URL env var |
| **Redis (Managed)** | Cache & job queue | Included in hosting | $0 (included) | REDIS_URL env var |

**CDN & Assets (Story 1.3, 1.4):**

| Service | Purpose | Tier | Cost | Configuration |
|---------|---------|------|------|---------------|
| **Cloudflare** | CDN, DDoS protection, DNS | Free | $0 | DNS CNAME to Railway/Render |
| **Cloudinary** | Image hosting & optimization | Free | $0 (25GB storage, 25GB bandwidth) | CLOUDINARY_URL env var |

**Monitoring & Errors (Story 1.3):**

| Service | Purpose | Tier | Cost | Configuration |
|---------|---------|------|------|---------------|
| **Sentry** | Error tracking | Free | $0 (5k errors/month) | SENTRY_DSN env var |
| **UptimeRobot** | Uptime monitoring | Free | $0 (50 monitors) | Configure /health endpoint |

**Email (Story 1.3):**

| Service | Purpose | Tier | Cost | Configuration |
|---------|---------|------|------|---------------|
| **SendGrid** | Transactional email | Free | $0 (100 emails/day) | SENDGRID_API_KEY env var |

**CI/CD (Story 1.3):**

| Service | Purpose | Tier | Cost | Configuration |
|---------|---------|------|------|---------------|
| **GitHub Actions** | CI/CD pipelines | Free | $0 (public repos) | .github/workflows/ci.yml |

### Integration Points Summary

**Story 1.1 (Project Setup):**
- Docker Compose → PostgreSQL + Redis containers
- Bundler → RubyGems.org for gem installation
- Yarn → npm registry for package installation

**Story 1.2 (Local Development):**
- Rails → PostgreSQL (DATABASE_URL)
- Rails → Redis (REDIS_URL)
- Sidekiq → Redis (job queue)
- Webpacker/ESBuild → JavaScript bundling

**Story 1.3 (Deployment):**
- GitHub → Railway/Render (webhook deployment)
- Railway/Render → PostgreSQL (managed)
- Railway/Render → Redis (managed)
- Application → Sentry (error reporting)
- Application → SendGrid (email delivery)
- Cloudflare → Railway/Render (CDN origin)
- UptimeRobot → /health endpoint (monitoring)

**Story 1.4 (Theme):**
- Application → Cloudinary (logo/favicon upload)
- Admin Panel → Crayons CSS variables (theme config)

**Story 1.5, 1.6 (Content Pages):**
- Rails → Forem Pages feature (static content)
- Landing page → Articles API (featured content)

### Version Constraints

**Critical Version Requirements:**
- Ruby: 3.3.0 (exact - specified in .ruby-version)
- Rails: ~> 7.0.8 (minor updates ok, major version locked)
- Node: 20.x (LTS version)
- PostgreSQL: 14+ (managed service handles version)
- Redis: 4.7.1+ (managed service handles version)

**Upgrade Strategy (ADR-002):**
- Stay on current versions for Epic 1-6 (MVP)
- Plan upgrades post-launch (Rails 8, PostgreSQL 16, etc.)
- Test upgrades in staging first

## Acceptance Criteria (Authoritative)

### AC-1.1: Project Setup & Infrastructure (Story 1.1)

**Given** the existing Forem codebase at the repository
**When** I set up the project infrastructure
**Then** the following are configured and documented:
- AC-1.1.1: Git repository with proper .gitignore for Ruby/Rails projects
- AC-1.1.2: Environment configuration files (.env.example, database.yml)
- AC-1.1.3: Ruby version management (rbenv/rvm) with Ruby 3.3.0
- AC-1.1.4: Bundler for dependency management
- AC-1.1.5: PostgreSQL database setup scripts
- AC-1.1.6: Redis configuration for caching and background jobs
- AC-1.1.7: Node.js and Yarn for frontend asset management

**And** AC-1.1.8: A development setup guide is created in docs/development-guide.md

**And** AC-1.1.9: All developers can clone and run `bin/setup` successfully

### AC-1.2: Local Development Environment (Story 1.2)

**Given** the project infrastructure from Story 1.1 is complete
**When** I run the local development setup
**Then** AC-1.2.1: The Forem application starts successfully on localhost:3000

**And** the following are functional:
- AC-1.2.2: Database migrations run without errors
- AC-1.2.3: Rails console accessible via `bin/rails console`
- AC-1.2.4: Preact frontend compiles and hot-reloads
- AC-1.2.5: Background jobs process via Sidekiq
- AC-1.2.6: Test suite runs via `bin/rspec`

**And** AC-1.2.7: I can create a test user account and publish a test post

### AC-1.3: Deployment Pipeline & Staging (Story 1.3)

**Given** the local development environment is functional
**When** I configure the deployment pipeline
**Then** the following are established:
- AC-1.3.1: Staging environment deployed and accessible
- AC-1.3.2: CI/CD pipeline (GitHub Actions) configured
- AC-1.3.3: Automated tests run on every pull request
- AC-1.3.4: Deployment to staging on merge to main branch
- AC-1.3.5: Production deployment process documented (manual approval gate)

**And** deployment includes:
- AC-1.3.6: Database migration automation
- AC-1.3.7: Asset precompilation and CDN upload
- AC-1.3.8: Environment variable management (secrets)
- AC-1.3.9: Health check endpoints validation
- AC-1.3.10: Rollback procedure documentation

**And** AC-1.3.11: Staging environment mirrors production configuration

### AC-1.4: Custom Vibecoding Theme (Story 1.4)

**Given** the Forem instance is deployed to staging
**When** I apply custom theme customizations
**Then** the following visual elements are updated:
- AC-1.4.1: Primary brand color scheme (vibecoding colors)
- AC-1.4.2: Custom logo in header and footer
- AC-1.4.3: Custom favicon and app icons
- AC-1.4.4: Typography updates (fonts, sizes, line-height)
- AC-1.4.5: Dark mode support with brand colors

**And** theme customizations are implemented via:
- AC-1.4.6: Forem's Crayons design system variables
- AC-1.4.7: Custom CSS overrides (minimal, maintainable)
- AC-1.4.8: Logo assets in multiple sizes (SVG preferred)

**And** AC-1.4.9: Theme works responsively across mobile, tablet, desktop

**And** AC-1.4.10: Accessibility is maintained (color contrast ratios WCAG 2.1 Level A)

### AC-1.5: Landing Page & Onboarding (Story 1.5)

**Given** the custom theme is applied
**When** I create the landing page content
**Then** the homepage includes:
- AC-1.5.1: Hero section: "Welcome to Vibecoding Community" with tagline
- AC-1.5.2: Value proposition: What vibecoding is and why it matters
- AC-1.5.3: Social proof: Placeholder for community stats (users, posts, projects)
- AC-1.5.4: Featured content: Recent high-quality posts
- AC-1.5.5: Clear CTA: "Join the Community" and "Explore Posts"

**And** the landing page content:
- AC-1.5.6: Explains vibecoding (AI + natural language development)
- AC-1.5.7: Positions ANYON subtly (not heavy-handed)
- AC-1.5.8: Uses engaging visuals (hero image, icons)
- AC-1.5.9: Loads in < 2 seconds (LCP)

**And** AC-1.5.10: SEO meta tags are optimized for "vibecoding community"

### AC-1.6: About Page & Guidelines (Story 1.6)

**Given** the landing page is complete
**When** I create the About and Guidelines pages
**Then** the About page (/about) includes:
- AC-1.6.1: Mission: Building the vibecoding movement
- AC-1.6.2: What makes this community special
- AC-1.6.3: Connection to ANYON (authentic, not salesy)
- AC-1.6.4: Team introduction (optional)
- AC-1.6.5: Contact information

**And** Community Guidelines (/community-guidelines) include:
- AC-1.6.6: Expected behavior (respectful, constructive, authentic)
- AC-1.6.7: Content quality standards (substantive posts, no spam)
- AC-1.6.8: Self-promotion policy (ANYON showcases encouraged, other products limited)
- AC-1.6.9: Moderation policy and consequences
- AC-1.6.10: How to report issues

**And** both pages are:
- AC-1.6.11: Accessible from footer navigation
- AC-1.6.12: Referenced in signup flow
- AC-1.6.13: Written in friendly, approachable tone
- AC-1.6.14: SEO-optimized

## Traceability Mapping

| AC ID | Epic Story | Spec Section | Components/Services | Test Approach |
|-------|-----------|--------------|---------------------|---------------|
| AC-1.1.1 | Story 1.1 | Data Models | .gitignore file | Manual verification |
| AC-1.1.2 | Story 1.1 | Services (Environment Configuration) | .env.example, database.yml | Manual verification |
| AC-1.1.3 | Story 1.1 | Dependencies | .ruby-version, rbenv | `ruby -v` check |
| AC-1.1.4 | Story 1.1 | Dependencies | Gemfile, Bundler | `bundle -v` check |
| AC-1.1.5 | Story 1.1 | Services (Docker Compose) | docker-compose.yml | `docker-compose up` test |
| AC-1.1.6 | Story 1.1 | Services (Docker Compose) | docker-compose.yml | Redis ping test |
| AC-1.1.7 | Story 1.1 | Dependencies | package.json, Yarn | `yarn -v` check |
| AC-1.1.8 | Story 1.1 | Documentation | docs/development-guide.md | Manual review |
| AC-1.1.9 | Story 1.1 | Workflows (Developer Onboarding) | bin/setup script | End-to-end setup test |
| AC-1.2.1 | Story 1.2 | Workflows (Developer Onboarding) | Puma server | HTTP GET / → 200 |
| AC-1.2.2 | Story 1.2 | Data Models | Database migrations | `rails db:migrate` test |
| AC-1.2.3 | Story 1.2 | APIs (Admin Panel) | Rails console | Manual console test |
| AC-1.2.4 | Story 1.2 | Services (Landing Page Renderer) | ESBuild, Preact | Hot reload test |
| AC-1.2.5 | Story 1.2 | Services (Background Jobs) | Sidekiq | Queue job and verify |
| AC-1.2.6 | Story 1.2 | Testing | RSpec suite | `bin/rspec` execution |
| AC-1.2.7 | Story 1.2 | Workflows (Developer Onboarding) | User registration, Articles | E2E test |
| AC-1.3.1 | Story 1.3 | Deployment Architecture | Railway/Render hosting | Manual verification |
| AC-1.3.2 | Story 1.3 | Services (CI/CD Pipeline) | .github/workflows/ci.yml | Pipeline run test |
| AC-1.3.3 | Story 1.3 | Services (CI/CD Pipeline) | GitHub Actions | PR test run |
| AC-1.3.4 | Story 1.3 | Workflows (Deployment Pipeline) | GitHub + Railway/Render | Merge and verify deploy |
| AC-1.3.5 | Story 1.3 | Documentation | Deployment runbook | Manual review |
| AC-1.3.6 | Story 1.3 | Workflows (Deployment Pipeline) | Rails migrations | Deploy and verify schema |
| AC-1.3.7 | Story 1.3 | Dependencies (Cloudflare) | Asset pipeline, CDN | Asset URL verification |
| AC-1.3.8 | Story 1.3 | Security (Deployment) | ENV variables | Secrets audit |
| AC-1.3.9 | Story 1.3 | APIs (Health Check) | /health endpoint | GET /health → 200 |
| AC-1.3.10 | Story 1.3 | Documentation | Rollback procedures | Manual review |
| AC-1.3.11 | Story 1.3 | Deployment Architecture | Staging config | Config comparison |
| AC-1.4.1-5 | Story 1.4 | Services (Theme Customization) | Crayons CSS variables | Visual QA |
| AC-1.4.6-8 | Story 1.4 | Workflows (Theme Customization) | Admin Panel, CSS overrides | Code review |
| AC-1.4.9 | Story 1.4 | NFR (Performance) | Responsive layouts | Cross-device testing |
| AC-1.4.10 | Story 1.4 | NFR (Accessibility) | Color contrast | Lighthouse accessibility |
| AC-1.5.1-5 | Story 1.5 | Services (Landing Page Renderer) | app/views/pages/landing.html.erb | Visual QA |
| AC-1.5.6-8 | Story 1.5 | Workflows (Content Page Creation) | Landing page content | Content review |
| AC-1.5.9 | Story 1.5 | NFR (Performance) | Page load metrics | Lighthouse LCP test |
| AC-1.5.10 | Story 1.5 | SEO (meta tags) | HTML meta tags | Meta tag validation |
| AC-1.6.1-10 | Story 1.6 | Services (Static Page Generator) | Forem Pages (/about, /community-guidelines) | Content review |
| AC-1.6.11-12 | Story 1.6 | Workflows (Content Page Creation) | Footer navigation | Navigation test |
| AC-1.6.13 | Story 1.6 | Content | Page copy | Editorial review |
| AC-1.6.14 | Story 1.6 | SEO (meta tags) | HTML meta tags | Meta tag validation |

## Risks, Assumptions, Open Questions

### Risks

**RISK-1.1: Forem Upgrade Compatibility** (Medium Impact, Low Probability)
- **Description:** Future Forem upgrades may conflict with Epic 2+ customizations (ANYON integration)
- **Mitigation:** Follow Architecture Pattern 1 (extend, don't modify). Document all customizations clearly. Test upgrades in staging.
- **Contingency:** Maintain fork of Forem if upstream becomes incompatible

**RISK-1.2: Hosting Platform Cost Overruns** (Medium Impact, Low Probability)
- **Description:** Railway/Render costs may exceed $50/month if traffic spikes unexpectedly
- **Mitigation:** Set up billing alerts. Monitor resource usage. Plan scaling strategy in Epic 6.
- **Contingency:** Migrate to AWS/GCP if costs exceed budget at scale

**RISK-1.3: Developer Onboarding Friction** (Low Impact, Medium Probability)
- **Description:** Windows development environment (MINGW64) may have compatibility issues
- **Mitigation:** Docker Compose for consistent environment. Document Windows-specific issues.
- **Contingency:** Recommend WSL2 for Windows developers

**RISK-1.4: Deployment Pipeline Failures** (Medium Impact, Low Probability)
- **Description:** CI/CD failures could block deployments and slow iteration
- **Mitigation:** Comprehensive testing before merge. Manual deploy option. Rollback capability.
- **Contingency:** Hotfix procedure for critical bugs

**RISK-1.5: Theme Customization Limitations** (Low Impact, Medium Probability)
- **Description:** Crayons design system may not support all desired customizations
- **Mitigation:** Review Crayons documentation early. Plan CSS overrides where needed.
- **Contingency:** More extensive CSS overrides (maintain upgrade risk)

### Assumptions

**ASSUMPTION-1.1: Forem Platform Stability**
- Current Forem version (Ruby 3.3.0, Rails 7.0.8.4) is stable and production-ready
- Validation: Forem powers DEV.to with millions of users

**ASSUMPTION-1.2: External Service Availability**
- Railway/Render, Cloudflare, Cloudinary, Sentry free/starter tiers will suffice for MVP (100-500 users)
- Validation: Tier limits documented. Monitor usage in Story 1.3.

**ASSUMPTION-1.3: Team Ruby/Rails Expertise**
- Team has sufficient Ruby/Rails knowledge to customize Forem
- Validation: Development guide in Story 1.1 will enable onboarding

**ASSUMPTION-1.4: Existing Forem Configuration**
- Current Forem installation is functional and properly configured
- Validation: Existing bin/setup script works, database schema present

**ASSUMPTION-1.5: Design Assets Availability**
- Vibecoding logo, brand colors, and visual assets will be available for Story 1.4
- Validation: Confirm with design team before starting Story 1.4

**ASSUMPTION-1.6: Content Readiness**
- About page and Community Guidelines copy will be ready for Story 1.6
- Validation: Content team can draft before Epic 1 completion

### Open Questions

**QUESTION-1.1: Hosting Platform Selection**
- **Question:** Railway vs. Render - which provides better Rails support and pricing?
- **Owner:** DevOps Engineer (Story 1.3)
- **Deadline:** Before Story 1.3 begins
- **Impact:** Affects deployment configuration and cost

**QUESTION-1.2: Custom Domain**
- **Question:** What domain will be used for vibecoding community? (e.g., vibecoding.community, community.anyon.app)
- **Owner:** Product Manager / Marketing
- **Deadline:** Before Story 1.3 deployment
- **Impact:** DNS configuration, SSL certificates

**QUESTION-1.3: Brand Assets**
- **Question:** Are vibecoding logo (SVG), brand colors (hex codes), and favicon ready?
- **Owner:** Designer
- **Deadline:** Before Story 1.4 begins
- **Impact:** Theme customization cannot proceed without assets

**QUESTION-1.4: Landing Page Copy**
- **Question:** Who will write the landing page hero text, value proposition, and CTAs?
- **Owner:** Content Strategist / Product Manager
- **Deadline:** Before Story 1.5 begins
- **Impact:** Landing page content quality

**QUESTION-1.5: Community Guidelines Detail**
- **Question:** Should we adopt Forem's default Code of Conduct or write custom guidelines?
- **Owner:** Community Manager
- **Deadline:** Before Story 1.6 begins
- **Impact:** Moderation policy clarity

## Test Strategy Summary

### Test Levels

**Unit Tests (RSpec):**
- Target coverage: 80% minimum
- Focus: Health check controller, custom configuration loading
- Execution: `bin/rspec` in CI pipeline
- Responsibility: Backend developers

**Integration Tests (RSpec + Capybara):**
- Target coverage: Critical user flows
- Focus: Developer onboarding workflow, deployment pipeline
- Execution: `bin/rspec spec/features` in CI
- Responsibility: QA + Backend developers

**Frontend Tests (Jest):**
- Target coverage: 70% minimum
- Focus: No custom JavaScript in Epic 1 (defer to Epic 2)
- Execution: `yarn test` in CI
- Responsibility: Frontend developers

**E2E Tests (Cypress):**
- Target coverage: Happy path scenarios
- Focus: Landing page load, About/Guidelines page navigation, user signup flow
- Execution: `bin/e2e` manually before production deploy
- Responsibility: QA team

**Manual Testing:**
- Visual QA for theme customization (Story 1.4)
- Content review for landing page, About, Guidelines (Story 1.5, 1.6)
- Cross-browser testing (Chrome, Firefox, Safari, Edge)
- Cross-device testing (mobile, tablet, desktop)
- Accessibility testing (Lighthouse, axe DevTools)

### Test Scenarios by Story

**Story 1.1: Project Setup**
- TS-1.1.1: New developer clones repo and runs bin/setup → Success
- TS-1.1.2: Dependencies install without errors (bundle install, yarn install)
- TS-1.1.3: .env.example exists and is valid
- TS-1.1.4: docs/development-guide.md is complete and accurate

**Story 1.2: Local Development**
- TS-1.2.1: `foreman start` → Application runs on localhost:3000
- TS-1.2.2: Database migrations run successfully
- TS-1.2.3: Rails console starts and connects to database
- TS-1.2.4: Preact hot reload works when editing JavaScript
- TS-1.2.5: Sidekiq processes background jobs
- TS-1.2.6: Full RSpec test suite passes
- TS-1.2.7: User can register, login, create post (E2E)

**Story 1.3: Deployment Pipeline**
- TS-1.3.1: Staging environment accessible at staging URL
- TS-1.3.2: GitHub Actions workflow runs on PR creation
- TS-1.3.3: Tests fail → PR blocked, Tests pass → PR mergeable
- TS-1.3.4: Merge to main → Auto-deploy to staging within 5 minutes
- TS-1.3.5: GET /health → 200 OK with database + Redis status
- TS-1.3.6: Database migration runs automatically on deploy
- TS-1.3.7: Cloudflare CDN serves static assets
- TS-1.3.8: Sentry captures and reports application errors
- TS-1.3.9: Rollback to previous version works

**Story 1.4: Custom Theme**
- TS-1.4.1: Logo appears in header and footer
- TS-1.4.2: Brand colors applied throughout UI
- TS-1.4.3: Dark mode toggle works with vibecoding colors
- TS-1.4.4: Theme is responsive on mobile (< 768px)
- TS-1.4.5: Lighthouse accessibility score > 90

**Story 1.5: Landing Page**
- TS-1.5.1: GET / → Landing page loads (not Forem default)
- TS-1.5.2: Hero section displays with tagline
- TS-1.5.3: Featured content section shows recent articles
- TS-1.5.4: "Join the Community" button → /users/sign_up
- TS-1.5.5: Lighthouse LCP < 2.5 seconds
- TS-1.5.6: Meta tags include "vibecoding community" keyword

**Story 1.6: About & Guidelines**
- TS-1.6.1: GET /about → About page loads
- TS-1.6.2: GET /community-guidelines → Guidelines page loads
- TS-1.6.3: Footer contains links to both pages
- TS-1.6.4: Pages are SEO-optimized (meta tags, headings)

### Test Data

**Seed Data (Story 1.1):**
- 3 test user accounts (admin, author, reader)
- 10 sample articles (various tags, published/draft)
- 20 sample comments
- 5 tags (vibecoding, anyon, tutorial, project-showcase, ai-development)

### Acceptance Testing

**Definition of Done for Epic 1:**
- ✅ All 6 stories completed
- ✅ All acceptance criteria (AC-1.1 through AC-1.6) verified
- ✅ All automated tests passing
- ✅ Manual testing completed (cross-browser, cross-device)
- ✅ Lighthouse scores: Performance > 90, Accessibility > 90, SEO > 90
- ✅ Staging environment stable for 48 hours
- ✅ Production deployment successful
- ✅ Development guide validated by new developer onboarding
- ✅ Zero P0/P1 bugs

### Test Environment Requirements

**Local Development:**
- Docker Desktop installed
- PostgreSQL 14 container
- Redis 7 container

**Staging:**
- Railway/Render staging environment
- Separate database from production
- Same configuration as production (mirrored)

**Production:**
- Railway/Render production environment
- Cloudflare CDN enabled
- Sentry error tracking active
- UptimeRobot monitoring /health endpoint
