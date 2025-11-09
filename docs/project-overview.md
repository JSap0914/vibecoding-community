# Project Overview - Vibecoding Community

## Executive Summary

**Vibecoding Community** is a Forem-based community platform that powers online communities for developers and creators. It is the same open-source software that powers [dev.to](https://dev.to), providing a feature-rich platform for publishing articles, building discussions, and fostering professional networks.

**Project Name:** Vibecoding Community (Forem)
**Project Type:** Web Application (Monolithic Rails)
**License:** GNU AGPL v3.0
**Repository:** GitHub (forem/forem)

---

## What is This Project?

Forem is **open source software for building communities**. It provides:

- **Content Publishing:** Blog posts, tutorials, technical articles
- **Discussion Forums:** Comment threads, reactions, nested discussions
- **Social Features:** Following users/tags, reading lists, reactions
- **Podcasts & Videos:** Rich media support
- **Gamification:** Badges, credits, reputation system
- **Classifieds:** Job listings, products, events
- **Multi-tenancy:** Host multiple communities

**Primary Use Case:** Developer communities, but extensible to any community type

---

## Technology Overview

### Core Technologies

| Category | Technology | Version |
|----------|-----------|---------|
| **Backend** | Ruby on Rails | 7.0.8.4 |
| **Language** | Ruby | 3.3.0 |
| **Frontend** | Preact | 10.20.2 |
| **Database** | PostgreSQL | 14+ |
| **Cache** | Redis | 4.7.1+ |
| **Jobs** | Sidekiq | 6.5.3 |
| **Build** | ESBuild | 0.19.12 |
| **Search** | Algolia | 4.23.3 |

### Architecture Type

**Monolithic MVC** with modern enhancements:
- Service Objects for business logic
- Query Objects for complex database queries
- Policy Objects for authorization (Pundit)
- Component-driven frontend (Preact)
- Progressive enhancement (Stimulus)

---

## Project Structure

### Repository Type

**Monolith** - Single cohesive codebase

**Total Codebase Metrics:**
- **Controllers:** 76+ main controllers
- **Models:** 105+ ActiveRecord models
- **Database Tables:** 106 tables
- **API Endpoints:** 50+ versioned endpoints (v0, v1)
- **UI Components:** 305+ Preact/JSX components
- **Background Workers:** 40+ Sidekiq jobs
- **Tests:** Comprehensive RSpec, Jest, Cypress coverage

### Directory Organization

```
vibecoding-community/
├── app/              # Main application (MVC + more)
├── config/           # Configuration files
├── db/               # Database schema and migrations
├── docs/             # Documentation
├── spec/             # RSpec tests
├── cypress/          # E2E tests
├── bin/              # Executable scripts
├── lib/              # Custom libraries
├── public/           # Static assets
└── [docker/ci/etc]   # Infrastructure config
```

---

## Key Features

### Content Management

**Article Publishing:**
- Markdown editor with live preview
- Code syntax highlighting (Rouge)
- Image uploads (Cloudinary/S3)
- Series/collections
- Draft/publish workflow
- Canonical URLs
- Front matter support (Liquid)

**Rich Content Types:**
- Articles/blog posts
- Podcasts
- Videos
- Static pages
- Liquid tag embeds (YouTube, CodePen, etc.)

### Social & Engagement

**User Interactions:**
- Reactions (❤️, 🦄, 🔥, etc.) - emoji-based engagement
- Comments with nested threading (ltree-based)
- Following (users, tags, organizations)
- Reading lists (bookmarks)
- Notifications

**Discovery:**
- Tag-based navigation
- Algolia-powered search
- Personalized feed
- Trending algorithm
- Related articles

### Community Features

**Organizations:**
- Multi-user accounts (companies, teams)
- Organization articles
- Member management

**Gamification:**
- User badges
- Credit system
- Reputation scores
- Achievements

**Moderation:**
- Content moderation tools
- User banning
- Context notes
- Spam detection

### Platform Features

**Listings (Classifieds):**
- Job postings
- Products for sale
- Events
- Collabs

**Billboards (Ads):**
- Community ads system
- Impression tracking
- Click analytics

**Podcasts:**
- Podcast hosting
- Episode management
- RSS feeds

---

## Tech Stack Details

### Backend Architecture

**Framework:** Ruby on Rails 7.0.8 (MVC)

**Key Patterns:**
- Service Objects (`app/services/`)
- Query Objects (`app/queries/`)
- Policy Objects (`app/policies/` - Pundit)
- Decorators (`app/decorators/`)
- Form Objects (`app/forms/`)

**Database:**
- PostgreSQL with extensions:
  - `pg_trgm` (fuzzy search)
  - `ltree` (hierarchical data)
  - `pgcrypto` (encryption)
  - `citext` (case-insensitive text)

**Authentication:**
- Devise (email/password)
- OmniAuth (GitHub, Twitter, Google, Facebook, Apple)
- API tokens

**Authorization:**
- Pundit policies

**Background Jobs:**
- Sidekiq (Redis-backed)
- Scheduled jobs via sidekiq-cron

### Frontend Architecture

**UI Framework:** Preact 10.20.2 (React-compatible, smaller)

**Design System:** Crayons
- Component library with 50+ components
- Documented in Storybook
- Accessible (WCAG 2.1 AA)

**Progressive Enhancement:**
- Stimulus controllers for sprinkles of JavaScript
- Server-rendered HTML with client-side enhancements

**State Management:**
- Context API + Hooks (no Redux)
- Component-local state

**Build Pipeline:**
- ESBuild for fast JavaScript bundling
- Sass for CSS preprocessing
- PostCSS with Autoprefixer

### Data Storage

**Primary Database:**
- PostgreSQL (106 tables)
- Full-text search (pg_search)
- Hierarchical comments (ancestry gem + ltree)

**Cache:**
- Redis (ActionCache)
- Fragment caching
- Session storage

**File Storage:**
- Cloudinary (images, default)
- AWS S3 (alternative)
- CarrierWave (upload management)

**Search:**
- Algolia (production)
- PostgreSQL FTS (fallback)

---

## External Integrations

**Authentication:**
- GitHub OAuth
- Twitter OAuth
- Google OAuth2
- Facebook OAuth
- Apple Sign In

**Services:**
- **Stripe:** Payments, memberships
- **Algolia:** Search indexing
- **Cloudinary:** Image processing/hosting
- **Fastly:** CDN
- **SendGrid/Mailgun:** Email delivery
- **Honeybadger:** Error tracking
- **Datadog:** APM monitoring

---

## Development & Testing

### Testing Strategy

**Backend Testing:**
- RSpec (unit, integration, request specs)
- FactoryBot for test data
- SimpleCov for coverage
- VCR for HTTP mocking

**Frontend Testing:**
- Jest for component tests
- Testing Library (Preact)
- Storybook for visual testing

**E2E Testing:**
- Cypress for critical flows
- Knapsack Pro for parallel execution

### CI/CD

**Platform:** GitHub Actions

**Workflows:**
- Continuous Integration (tests, linting)
- Pull Request checks
- Continuous Deployment
- Security scanning (CodeQL, Brakeman)
- Dependency updates (Dependabot)

---

## Deployment

### Containerization

**Docker Support:**
- `Containerfile` (production image)
- `docker-compose.yml` (local development)
- `.dockerdev/` (development containers)

**Services:**
- Web app (Puma)
- Background workers (Sidekiq)
- PostgreSQL
- Redis

### Production Deployment

**Supported Platforms:**
- Heroku
- AWS
- DigitalOcean
- Any container platform

**Release Process:**
1. Migrations run automatically
2. Assets precompiled
3. Zero-downtime rolling deployments

---

## Community & Contribution

### Open Source

**License:** GNU Affero General Public License v3.0

**Contribution:**
- Active community on GitHub
- Contributing guide: https://developers.forem.com/contributing-guide/forem
- Code of Conduct enforced
- CLA required for contributions

### Resources

**Documentation:**
- Developer Docs: https://developers.forem.com
- Installation Guides: macOS, Linux
- Technical Overview: Stack details
- API Documentation: Swagger/OpenAPI

**Community:**
- GitHub Discussions
- dev.to community
- Weekly contributors calls

---

## Use Cases

### Who Uses This?

**Primary Users:**
- Developer communities (dev.to)
- Tech companies building communities
- Open source projects
- Educational platforms
- Creator communities

**Deployment Scenarios:**
1. **Hosted Instances:** Run your own Forem instance
2. **Forem Cloud:** Managed hosting (official)
3. **Self-Hosted:** Deploy on your infrastructure

---

## Quick Reference

### Key Paths

| Purpose | Path |
|---------|------|
| **Controllers** | `app/controllers/` |
| **Models** | `app/models/` |
| **Views** | `app/views/` |
| **API** | `app/controllers/api/` |
| **Components** | `app/javascript/` |
| **Tests** | `spec/` |
| **Migrations** | `db/migrate/` |
| **Docs** | `docs/` |

### Important Commands

```bash
# Setup
bin/setup

# Start dev server
foreman start -f Procfile.dev

# Tests
bin/rspec          # Backend
yarn test          # Frontend
bin/e2e            # E2E

# Console
bin/rails console

# Database
bin/rails db:migrate
```

---

## Documentation Index

**Generated Documentation:**
1. [Architecture](./architecture.md) - System architecture
2. [API Contracts](./api-contracts.md) - API endpoints
3. [Data Models](./data-models.md) - Database schema
4. [Component Inventory](./component-inventory.md) - UI components
5. [Development Guide](./development-guide.md) - Setup and workflow
6. [Source Tree](./source-tree-analysis.md) - Directory structure

**Existing Documentation:**
- README.md (project root)
- CODE_OF_CONDUCT.md
- SECURITY.md
- docs/i18n_implementation_guide.md
- docs/feed_query_optimization.md
- And more in `docs/`

---

**Generated:** 2025-11-09
**Scan Type:** Deep Scan
**Documentation Version:** 1.0
