# Architecture - Vibecoding Community

## Executive Summary

**Vibecoding Community** is a strategic brownfield customization of the Forem open-source platform (the technology behind DEV.to) to create the central hub for the vibecoding movement. This architecture focuses on **minimal, maintainable customizations** that enable ANYON integration, brand identity, and growth optimization while preserving Forem's upgradability and battle-tested infrastructure.

**Strategic Approach:** Hybrid customization strategy - leverage Forem's 106-table database, 305+ UI components, and proven community features while adding targeted customizations for vibecoding-specific needs (ANYON CTAs, conversion tracking, enhanced SEO, custom branding).

**Key Architectural Principles:**
1. **Brownfield First** - Extend, don't rebuild; customize only where necessary
2. **Upgrade Safety** - Document and isolate all customizations for future Forem upgrades
3. **Cost Efficiency** - Target $30-50/month hosting for MVP, scale economically to 10k+ users
4. **Agent Consistency** - Clear patterns ensure AI agents implement features uniformly

## Project Initialization

**Foundation:** Existing Forem Installation (Already Complete)

This project uses the **Forem platform** - mature, open-source community software with comprehensive features already built.

**Current Setup:**
```bash
# Forem is already installed and running
# No initialization command needed - customization only

# Development setup (for new developers):
git clone <repository>
bin/setup
docker-compose up  # Start PostgreSQL + Redis
foreman start -f Procfile.dev  # Start Rails + Sidekiq
```

**Version Strategy:** **Conservative (Option A)** - Stay on current stable versions for MVP to minimize risk and accelerate launch. Upgrades planned post-launch.

## Decision Summary

| Category | Decision | Version | Affects Epics | Rationale |
| -------- | -------- | ------- | ------------- | --------- |
| **Platform** | Forem (existing) | Current installation | All | Battle-tested community platform, 80% of features pre-built |
| **Backend Framework** | Ruby on Rails | 7.0.8.4 | All | Existing Forem stack, stable and mature |
| **Language** | Ruby | 3.3.0 | All | Existing Forem requirement |
| **Frontend Framework** | Preact | 10.20.2 | 1, 2, 3 | Forem's frontend framework (React-compatible, smaller bundle) |
| **Database** | PostgreSQL (Managed) | 14+ | All | Existing Forem DB with 106 tables, managed via Railway/Render |
| **Cache & Jobs** | Redis (Managed) | 4.7.1+ | All | Existing Forem cache/queue, managed via Railway/Render |
| **Background Jobs** | Sidekiq | 6.5.3 | 2, 5 | Existing Forem job processor |
| **Hosting Platform** | Railway or Render | Latest | All | Simple deployment, affordable ($30-50/month), auto-scaling |
| **File Storage** | Cloudinary | Free tier | 1, 4 | Already configured in Forem, free tier sufficient for MVP |
| **Email Service** | SendGrid | Free tier (100/day) | 4, 5 | Simple setup, generous free tier, good deliverability |
| **Search** | PostgreSQL FTS → Algolia | Built-in → v4.23.3 | 3 | PG FTS for MVP, Algolia when scaling |
| **CDN** | Cloudflare | Free tier | 3, 6 | Best free CDN, DDoS protection, analytics |
| **Analytics** | Google Analytics 4 + GTM | Latest | 2, 5 | GA4 for core analytics, GTM for flexible event tracking |
| **Error Tracking** | Sentry | Free tier (5k/month) | 6 | Excellent DX, generous free tier |
| **APM** | Hosting platform metrics | Built-in | 6 | Sufficient for MVP, Scout APM optional |
| **CI/CD** | GitHub Actions | Existing | All | Already configured in Forem, free for public repos |
| **Development** | Docker Compose | Existing | All | Consistent environment, matches production |
| **Customization Strategy** | Hybrid (Theme + Code) | N/A | All | Admin panel for branding, code for ANYON integration |

## Project Structure

```
vibecoding-community/
├── app/
│   ├── controllers/
│   │   ├── [76+ Forem controllers]
│   │   └── custom/                           # VIBECODING: Custom controllers
│   │       └── anyon_integrations_controller.rb
│   ├── models/
│   │   ├── [105+ Forem models]
│   │   └── concerns/
│   │       └── anyon_trackable.rb            # VIBECODING: ANYON tracking
│   ├── services/
│   │   ├── [Forem services]
│   │   └── anyon/                            # VIBECODING: ANYON integration
│   │       ├── conversion_tracker.rb
│   │       └── project_linker.rb
│   ├── views/
│   │   ├── layouts/
│   │   │   ├── [Forem layouts]
│   │   │   └── custom_header.html.erb       # VIBECODING: Custom header
│   │   └── pages/
│   │       └── landing.html.erb              # VIBECODING: Landing page
│   ├── javascript/
│   │   ├── [305+ Forem Preact components]
│   │   ├── custom/                           # VIBECODING: Custom components
│   │   │   ├── AnyonCTA.jsx
│   │   │   └── AnyonProjectBadge.jsx
│   │   └── analytics/
│   │       └── ga4_tracker.js                # VIBECODING: GA4 tracking
│   ├── assets/
│   │   ├── images/
│   │   │   └── vibecoding/                   # VIBECODING: Brand assets
│   │   └── stylesheets/
│   │       └── vibecoding/                   # VIBECODING: Custom theme
│   └── policies/
│       └── [Forem Pundit policies]
│
├── db/
│   ├── schema.rb                             # 106 Forem tables
│   └── migrate/
│       ├── [Forem migrations]
│       └── YYYYMMDD_add_anyon_fields.rb      # VIBECODING: Custom fields
│
├── config/
│   ├── initializers/
│   │   └── vibecoding_customizations.rb      # VIBECODING: Custom config
│   ├── vibecoding.yml                        # VIBECODING: Settings
│   └── [Forem config files]
│
├── lib/
│   └── vibecoding/                           # VIBECODING: Custom libraries
│       ├── analytics_tracker.rb
│       └── seo_optimizer.rb
│
├── spec/                                     # RSpec tests
├── cypress/                                  # E2E tests
├── docs/
│   ├── PRD.md
│   ├── epics.md
│   ├── architecture.md                       # This document
│   └── customization-guide.md                # VIBECODING: Change tracking
│
└── [Forem infrastructure files]
```

## Epic to Architecture Mapping

### Epic 1: Platform Foundation & Branding
**Location:** `app/assets/vibecoding/`, `app/views/layouts/`, Admin Panel
**Database Impact:** None (configuration-based)
**Services:** None
**Components:** Theme CSS, logo assets, custom landing page
**External Services:** Cloudflare CDN, Railway/Render hosting

### Epic 2: ANYON Integration & Conversion Funnel
**Location:** `app/services/anyon/`, `app/controllers/custom/`, `app/javascript/custom/`
**Database Impact:** Add `anyon_project_url` to articles, `anyon_projects` JSON to users, `vibecoding_analytics` table
**Services:** `Anyon::ConversionTracker`, `Anyon::ProjectLinker`
**Components:** `AnyonCTA.jsx`, `AnyonProjectBadge.jsx`
**External Services:** Google Analytics 4, Google Tag Manager

### Epic 3: SEO & Content Discoverability
**Location:** `app/views/layouts/`, `lib/vibecoding/seo_optimizer.rb`, `config/sitemap.rb`
**Database Impact:** None (leverages Forem's existing schema)
**Services:** `Vibecoding::SeoOptimizer`
**Components:** Open Graph meta tags, Twitter Card components
**External Services:** Google Search Console, Cloudflare CDN

### Epic 4: Content Strategy & Community Launch
**Location:** Admin Panel, `db/seeds/vibecoding_content.rb`, Forem liquid tags
**Database Impact:** Seed data for tags, initial posts, community guidelines
**Services:** None (content creation)
**Components:** Content templates (Forem built-in)
**External Services:** Cloudinary (images)

### Epic 5: Analytics & Growth Infrastructure
**Location:** `app/javascript/analytics/`, `lib/vibecoding/analytics_tracker.rb`, `app/views/admin/vibecoding/`
**Database Impact:** `vibecoding_analytics` table for custom metrics
**Services:** `Vibecoding::AnalyticsTracker`
**Components:** Admin dashboard components
**External Services:** GA4, GTM, Google Search Console

### Epic 6: Performance Optimization & Security Hardening
**Location:** `config/`, infrastructure (Railway/Render), Cloudflare
**Database Impact:** Database indexing optimization
**Services:** None (infrastructure-level)
**Components:** Performance monitoring, caching strategies
**External Services:** Cloudflare CDN, Sentry, hosting platform metrics

## Technology Stack Details

### Core Technologies

**Backend Stack:**
- **Ruby on Rails 7.0.8.4** - MVC framework (Forem's backbone)
- **Ruby 3.3.0** - Programming language
- **Puma** - Application server
- **Sidekiq 6.5.3** - Background job processing
- **Devise** - Authentication (Forem built-in)
- **OmniAuth** - OAuth providers (GitHub, Twitter, Google)
- **Pundit** - Authorization policies
- **ActiveRecord** - ORM

**Frontend Stack:**
- **Preact 10.20.2** - UI framework (React-compatible, 3KB)
- **Stimulus** - JavaScript sprinkles (progressive enhancement)
- **ESBuild 0.19.12** - Fast bundling
- **Sass** - CSS preprocessing
- **Crayons Design System** - 305+ UI components (Forem's design system)

**Data Layer:**
- **PostgreSQL 14+** - Primary database (106 tables)
  - Extensions: pg_trgm, ltree, pgcrypto, citext
- **Redis 4.7.1+** - Cache, sessions, job queue

**Infrastructure:**
- **Railway/Render** - Hosting platform
- **Cloudflare Free** - CDN, DDoS protection
- **Cloudinary** - Image hosting/optimization
- **SendGrid** - Transactional email
- **GitHub Actions** - CI/CD

**Development:**
- **Docker Compose** - Local development
- **RSpec** - Backend testing
- **Jest** - Frontend testing
- **Cypress** - E2E testing

### Integration Points

**ANYON Integration:**
- **CTAs:** Header, sidebar, footer buttons with UTM tracking
- **Project Linking:** Custom field on articles and user profiles
- **Conversion Tracking:** GA4 events via GTM

**External Services:**
```
Forem Platform
    ↓
┌───────────────────────────────────┐
│   Vibecoding Community (Rails)    │
│                                   │
│  ┌─────────────────────────────┐ │
│  │  Custom ANYON Integration   │ │
│  │  - ConversionTracker        │ │
│  │  - ProjectLinker            │ │
│  └─────────────────────────────┘ │
└───────────────────────────────────┘
    ↓           ↓           ↓
┌─────────┐ ┌─────────┐ ┌─────────┐
│   GA4   │ │Cloudinary│ │SendGrid│
└─────────┘ └─────────┘ └─────────┘
```

**Data Flow:**
1. User interacts with ANYON CTA → GTM tracks event → GA4 records
2. User creates post with ANYON link → `Anyon::ProjectLinker` validates → DB saves
3. User visits ANYON link → UTM params track source → Conversion measured

## Implementation Patterns

These patterns ensure consistent implementation across all AI agents:

### Pattern 1: Forem Extension (NOT Modification)

**CRITICAL:** Always extend Forem, never monkey-patch core code.

```ruby
# ✅ CORRECT: Use concerns to extend Forem models
# app/models/concerns/anyon_trackable.rb
module AnyonTrackable
  extend ActiveSupport::Concern

  included do
    # Add ANYON-specific behavior to Article model
    validates :anyon_project_url, format: { with: URI::DEFAULT_PARSER.make_regexp }, allow_blank: true

    after_save :track_anyon_project_link, if: :anyon_project_url_changed?
  end

  def has_anyon_project?
    anyon_project_url.present?
  end

  private

  def track_anyon_project_link
    Anyon::ConversionTracker.new(user, 'project_linked').track!
  end
end

# app/models/article.rb (Forem core - don't edit directly!)
# Instead, add to config/initializers/vibecoding_customizations.rb:
Article.include AnyonTrackable

# ❌ WRONG: Monkey-patching Forem core
class Article < ApplicationRecord
  # Overriding Forem's methods breaks on upgrades!
end
```

### Pattern 2: Namespaced Customizations

**Rule:** All custom code must be clearly namespaced.

```
Files:           vibecoding/ or custom/ or anyon/
Classes:         Anyon::*, Vibecoding::*
Tables:          vibecoding_analytics (prefixed)
Columns:         anyon_project_url (prefixed)
Routes:          /api/custom/anyon/*
CSS classes:     .vibecoding-* or use Crayons
Git commits:     [VIBECODING] prefix
Code comments:   # VIBECODING CUSTOMIZATION
```

### Pattern 3: Service Object Pattern

All ANYON business logic in service objects:

```ruby
# app/services/anyon/conversion_tracker.rb
module Anyon
  class ConversionTracker
    def initialize(user, event_type)
      @user = user
      @event_type = event_type
    end

    def track!
      track_in_analytics
      store_in_database
    rescue StandardError => e
      handle_error(e)
    end

    private

    def track_in_analytics
      # GA4 tracking via GTM
      Analytics.track(
        user_id: @user.id,
        event: "anyon_#{@event_type}",
        properties: {
          timestamp: Time.current,
          user_created_at: @user.created_at
        }
      )
    end

    def store_in_database
      VibeCodingAnalytic.create!(
        user: @user,
        event_type: @event_type,
        tracked_at: Time.current
      )
    end

    def handle_error(error)
      Rails.logger.error("VIBECODING: Tracking failed - #{error.message}")
      Sentry.capture_exception(error, extra: { user_id: @user.id, event: @event_type })
    end
  end
end

# Usage in controllers:
Anyon::ConversionTracker.new(current_user, 'cta_click').track!
```

### Pattern 4: Frontend Component Pattern

**Use Preact** (not React) and Forem's Crayons design system:

```jsx
// app/javascript/custom/AnyonCTA.jsx
import { h } from 'preact';
import { useState } from 'preact/hooks';

/**
 * VIBECODING CUSTOMIZATION
 * Epic 2, Story 2.1 - ANYON CTA Strategic Placement
 *
 * Renders ANYON call-to-action button with tracking
 */
export const AnyonCTA = ({ location, className = '' }) => {
  const [clicked, setClicked] = useState(false);

  const handleClick = () => {
    setClicked(true);

    // Track via GTM
    if (window.gtag) {
      window.gtag('event', 'anyon_cta_click', {
        location: location,
        timestamp: Date.now()
      });
    }
  };

  const utmParams = `utm_source=community&utm_medium=cta&utm_campaign=${location}`;
  const anyonUrl = `${process.env.ANYON_SIGNUP_URL}?${utmParams}`;

  return (
    <a
      href={anyonUrl}
      onClick={handleClick}
      target="_blank"
      rel="noopener noreferrer"
      className={`crayons-btn crayons-btn--primary ${className}`}
      data-anyon-cta={location}
    >
      {clicked ? '✓ Opening ANYON...' : 'Try ANYON'}
    </a>
  );
};
```

### Pattern 5: Database Migration Pattern

```ruby
# db/migrate/20250109_add_anyon_fields_to_articles.rb
class AddAnyonFieldsToArticles < ActiveRecord::Migration[7.0]
  def change
    # VIBECODING CUSTOMIZATION
    # Epic 2, Story 2.2 - ANYON Project Linking in Posts
    # Adds optional ANYON project URL field to articles

    add_column :articles, :anyon_project_url, :string
    add_index :articles, :anyon_project_url

    # Add comment for future reference
    reversible do |dir|
      dir.up do
        execute <<-SQL
          COMMENT ON COLUMN articles.anyon_project_url IS
          'VIBECODING: Optional ANYON project URL for project showcase posts';
        SQL
      end
    end
  end
end
```

## Consistency Rules

### Naming Conventions

**Files & Directories:**
- Custom namespaces: `vibecoding/`, `custom/`, `anyon/`
- Controllers: `custom/anyon_integrations_controller.rb` (snake_case)
- Services: `anyon/conversion_tracker.rb` (snake_case, namespaced)
- Models: `vibecoding_analytic.rb` (singular, snake_case)
- Components: `AnyonCTA.jsx` (PascalCase)
- Stylesheets: `vibecoding-theme.scss` (kebab-case)

**Database:**
- Tables: `vibecoding_analytics` (plural, snake_case, prefixed)
- Columns: `anyon_project_url` (snake_case, prefixed)
- Indexes: `index_articles_on_anyon_project_url`
- Foreign keys: `user_id` (Forem convention)

**API Endpoints:**
- Custom routes: `/api/custom/anyon/conversions`
- Namespaced under `/api/custom/`
- RESTful conventions

**Frontend:**
- CSS classes: Use Crayons (`.crayons-btn`) or prefix (`.vibecoding-cta`)
- Component files: `AnyonCTA.jsx` (PascalCase)
- JavaScript modules: `ga4_tracker.js` (snake_case)

### Code Organization

**Service Objects:**
- Location: `app/services/anyon/` or `app/services/vibecoding/`
- Pattern: One class per file, single responsibility
- Naming: Verb-based (`ConversionTracker`, `ProjectLinker`)

**Custom Controllers:**
- Location: `app/controllers/custom/`
- Inherit from: `ApplicationController`
- Authorization: Use Pundit policies

**Custom Models:**
- Location: `app/models/` (new tables) or `app/models/concerns/` (extensions)
- Use concerns for extending Forem models
- Never modify Forem model files directly

**Frontend Components:**
- Location: `app/javascript/custom/`
- Use Preact, not React
- Leverage Crayons design system

### Error Handling

**Standardized Error Handling:**

```ruby
# All services inherit from base with error handling
module Anyon
  class BaseService
    class Error < StandardError; end

    def self.call(*args, **kwargs)
      new(*args, **kwargs).call
    rescue StandardError => e
      handle_error(e)
      raise
    end

    private

    def self.handle_error(error)
      # Log with context
      Rails.logger.error(
        "VIBECODING: #{self.name} failed",
        error: error.message,
        backtrace: error.backtrace.first(5)
      )

      # Report to Sentry
      Sentry.capture_exception(error, extra: {
        service: self.name,
        timestamp: Time.current
      })
    end
  end
end
```

### Logging Strategy

**Structured Logging Format:**

```ruby
# Always use structured logging for custom code
Rails.logger.info(
  "VIBECODING: #{action}",
  user_id: user.id,
  event_type: event_type,
  timestamp: Time.current,
  metadata: additional_data
)

# Examples:
Rails.logger.info("VIBECODING: ANYON CTA clicked", user_id: 123, location: 'header')
Rails.logger.error("VIBECODING: Project link validation failed", url: url, error: e.message)
```

**Log Levels:**
- `debug`: Detailed tracking (GA4 events, analytics)
- `info`: Important events (CTA clicks, project links)
- `warn`: Potential issues (missing config)
- `error`: Failures (tracking errors, validation failures)

**Prefix:** Always prefix custom logs with `"VIBECODING:"` for easy filtering

## Data Architecture

### Custom Database Schema

**New Tables:**

```sql
-- vibecoding_analytics
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
```

**Modified Forem Tables:**

```sql
-- articles (existing Forem table)
ALTER TABLE articles ADD COLUMN anyon_project_url VARCHAR(2048);
CREATE INDEX idx_articles_anyon_project_url ON articles(anyon_project_url);
COMMENT ON COLUMN articles.anyon_project_url IS 'VIBECODING: Optional ANYON project URL';

-- users (existing Forem table)
ALTER TABLE users ADD COLUMN anyon_projects JSONB DEFAULT '[]';
COMMENT ON COLUMN users.anyon_projects IS 'VIBECODING: Array of ANYON project links';
```

## API Contracts

### Custom ANYON Integration API

**Endpoint:** `/api/custom/anyon/track_conversion`
**Method:** POST
**Authentication:** Requires logged-in user

**Request:**
```json
{
  "event_type": "cta_click",
  "metadata": {
    "location": "header",
    "campaign": "launch"
  }
}
```

**Response (Success):**
```json
{
  "success": true,
  "data": {
    "id": 12345,
    "event_type": "cta_click",
    "tracked_at": "2025-01-09T12:34:56Z"
  }
}
```

## Security Architecture

### Authentication & Authorization

**Leverage Forem's Existing Security:**
- Devise authentication (already configured)
- OAuth providers: GitHub, Twitter, Google (already configured)
- Pundit authorization policies (already configured)
- CSRF protection (Rails built-in)

**Custom Security Additions:**
- Rate limiting on ANYON conversion tracking endpoints
- URL validation for ANYON project links (prevent XSS)
- UTM parameter sanitization

### GDPR Compliance

**Cookie Consent:**
- Cookie consent banner for EU users
- Load GTM only after consent

**Data Export/Deletion:**
- Leverage Forem's built-in GDPR data export
- Include `vibecoding_analytics` in user data export
- Cascade delete analytics on user deletion

## Performance Considerations

### Target Metrics

- **LCP (Largest Contentful Paint):** < 2.5 seconds
- **FID (First Input Delay):** < 100ms
- **CLS (Cumulative Layout Shift):** < 0.1
- **Lighthouse Performance Score:** > 90

### Optimization Strategies

**Leverage Forem's Built-In Optimizations:**
- Server-side rendering (SSR) for all public content
- Fragment caching (Rails)
- Redis caching for sessions and data
- Asset precompilation and fingerprinting
- ESBuild for fast JavaScript bundling

**CDN Strategy:**
- Cloudflare CDN for all static assets
- Cache-Control headers for browser caching
- Aggressive caching for images (1 year)

**Database Optimization:**
- Indexes on all foreign keys (Forem default)
- Custom indexes on `anyon_project_url`, `vibecoding_analytics.event_type`
- N+1 query prevention (use `includes`)

## Deployment Architecture

### Infrastructure Overview

```
┌─────────────────────────────────────────────┐
│           Cloudflare CDN (Free)             │
│  - DDoS protection                          │
│  - Static asset caching                     │
│  - DNS management                           │
└──────────────────┬──────────────────────────┘
                   │ HTTPS
                   ↓
┌─────────────────────────────────────────────┐
│      Railway/Render (App Platform)          │
│                                             │
│  ┌─────────────────────────────────────┐   │
│  │  Web (Puma)                         │   │
│  │  - Rails application                │   │
│  │  - Horizontal auto-scaling          │   │
│  └─────────────────────────────────────┘   │
│                                             │
│  ┌─────────────────────────────────────┐   │
│  │  Workers (Sidekiq)                  │   │
│  │  - Background jobs                  │   │
│  │  - Separate process                 │   │
│  └─────────────────────────────────────┘   │
│                                             │
│  ┌──────────────┐    ┌──────────────┐     │
│  │ PostgreSQL   │    │   Redis      │     │
│  │ (Managed)    │    │  (Managed)   │     │
│  └──────────────┘    └──────────────┘     │
└─────────────────────────────────────────────┘
         │              │              │
         ↓              ↓              ↓
┌──────────────┐ ┌─────────┐ ┌──────────────┐
│  Cloudinary  │ │SendGrid │ │  Sentry      │
│  (Images)    │ │ (Email) │ │  (Errors)    │
└──────────────┘ └─────────┘ └──────────────┘
         │                          │
         ↓                          ↓
┌──────────────────────────────────────────┐
│     Google Analytics 4 + GTM             │
│     (Analytics & Conversion Tracking)    │
└──────────────────────────────────────────┘
```

### Scaling Strategy

**MVP (100-500 users):**
- Single web instance (512MB RAM)
- Single worker instance (512MB RAM)
- Managed PostgreSQL (starter tier)
- Managed Redis (starter tier)
- **Cost:** ~$30-50/month

**Growth (1,000-10,000 users):**
- 2-4 web instances (auto-scaling)
- 2 worker instances
- PostgreSQL with read replica
- Redis (standard tier)
- **Cost:** ~$150-300/month

**Scale (10,000+ users):**
- 5+ web instances (auto-scaling)
- 3+ worker instances
- PostgreSQL with multiple read replicas
- Redis clustering
- Consider migrating to AWS/GCP for cost optimization
- **Cost:** ~$500-1,000/month

## Development Environment

### Prerequisites

- **Ruby:** 3.3.0 (via rbenv or rvm)
- **Node.js:** 18+ (for JavaScript assets)
- **PostgreSQL:** 14+
- **Redis:** 4.7.1+
- **Docker & Docker Compose:** Latest (recommended for development)

### Setup Commands

```bash
# Clone repository
git clone <repository-url>
cd vibecoding-community

# Option 1: Docker Compose (Recommended)
docker-compose up -d postgres redis
bin/setup
foreman start -f Procfile.dev

# Option 2: Native (PostgreSQL and Redis installed locally)
bin/setup
foreman start -f Procfile.dev

# Run tests
bin/rspec              # Backend tests
yarn test              # Frontend tests
bin/e2e                # E2E tests (Cypress)

# Database operations
bin/rails db:migrate   # Run migrations
bin/rails db:seed      # Seed data
bin/rails console      # Rails console

# Code quality
bin/rubocop            # Ruby linting
bin/erblint            # ERB linting
yarn lint              # JavaScript linting
```

### Development Workflow

1. **Create feature branch:** `git checkout -b feature/epic-X-story-Y`
2. **Make changes** following implementation patterns
3. **Run tests:** `bin/rspec && yarn test`
4. **Commit with prefix:** `git commit -m "[VIBECODING] Add ANYON CTA component"`
5. **Push and create PR:** GitHub Actions runs tests
6. **Merge to main:** Auto-deploys to staging
7. **Manual deploy to production** after validation

## Architecture Decision Records (ADRs)

### ADR-001: Brownfield Customization Strategy

**Status:** Accepted | **Date:** 2025-01-09

**Decision:** Use Forem platform with hybrid customization (theme + targeted code changes) instead of building from scratch

**Rationale:**
- Forem provides 80% of needed features (articles, comments, users, tags, etc.)
- 106-table database schema already handles complexity
- 305+ UI components (Crayons) provide consistent design
- Proven scalability (powers DEV.to with millions of users)
- Focus team energy on differentiators (ANYON integration, branding, SEO)

**Consequences:**
- Must maintain upgrade compatibility with Forem
- Limited by Forem's architecture choices
- Faster time to market (4-6 weeks vs 6+ months)
- Lower development cost (~$30-50/month hosting vs $500+ for custom build)

---

### ADR-002: Version Strategy - Conservative Approach

**Status:** Accepted | **Date:** 2025-01-09

**Decision:** Stay on current versions for MVP, upgrade post-launch

**Rationale:**
- Current stack is stable and battle-tested
- Version upgrades carry risk and testing burden
- MVP launch urgency (4-6 weeks)
- Latest versions (Rails 8, PostgreSQL 18) offer marginal benefits for this use case

---

### ADR-003: Hosting Platform - Railway/Render

**Status:** Accepted | **Date:** 2025-01-09

**Decision:** Use Railway or Render for application hosting

**Rationale:**
- Simple Dockerfile-based deployment
- Managed PostgreSQL + Redis included
- Auto-scaling built-in
- Affordable ($30-50/month for MVP)
- Good Rails ecosystem support
- Easy migration path to AWS/GCP if needed at scale

---

### ADR-004: Search Strategy - PostgreSQL FTS First

**Status:** Accepted | **Date:** 2025-01-09

**Decision:** Use PostgreSQL FTS for MVP, migrate to Algolia at scale

**Rationale:**
- PostgreSQL FTS adequate for < 10k users
- Zero additional cost for MVP
- Algolia free tier only 10k searches/month (exhausted quickly)
- Easy migration path (Forem supports both)

**Migration Trigger:** When search queries exceed 50k/month or search quality degrades

---

### ADR-005: Analytics Stack - GA4 + GTM

**Status:** Accepted | **Date:** 2025-01-09

**Decision:** Google Analytics 4 + Google Tag Manager for all tracking

**Rationale:**
- GA4 is industry standard, free, comprehensive
- GTM provides flexible event tracking without code deploys
- ANYON team likely uses GA4 (easy conversion attribution)

---

### ADR-006: Customization Documentation Standard

**Status:** Accepted | **Date:** 2025-01-09

**Decision:** All custom code must be clearly marked and documented

**Requirements:**
1. File header comments: `# VIBECODING CUSTOMIZATION`
2. Database migrations: Comment custom columns/tables
3. Git commits: Prefix `[VIBECODING]`
4. Namespacing: `vibecoding/`, `custom/`, `anyon/`
5. Documentation: Track in `docs/customization-guide.md`

**Rationale:** Enables safe Forem upgrades by clearly identifying custom vs. core code

---

_Generated by BMAD Decision Architecture Workflow v1.3.2_
_Date: 2025-01-09_
_For: JSup_
_Project: vibecoding-community_
