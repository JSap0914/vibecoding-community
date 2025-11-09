# Documentation Index - Vibecoding Community

## Welcome

This is the comprehensive documentation index for the **Vibecoding Community** platform (Forem). This documentation was auto-generated through deep codebase analysis and provides a complete reference for developers working with this project.

**Platform:** Forem - Open source community platform
**License:** GNU AGPL v3.0
**Primary Language:** Ruby (Rails) + JavaScript (Preact)

---

## Quick Start

**New to this project?** Start here:

1. 📖 [Project Overview](./project-overview.md) - Understand what this project is
2. 🏗️ [Architecture](./architecture.md) - Learn the system design
3. 🚀 [Development Guide](./development-guide.md) - Set up your environment
4. 🌳 [Source Tree Analysis](./source-tree-analysis.md) - Navigate the codebase

---

## Project Information

### At a Glance

- **Type:** Monolithic Web Application
- **Primary Language:** Ruby 3.3.0
- **Framework:** Rails 7.0.8 + Preact 10.20.2
- **Architecture:** MVC with service objects, policies, and component-based UI
- **Database:** PostgreSQL (106 tables, 105+ models)
- **Total Components:** 305+ UI components

### Quick Reference

| Aspect | Value |
|--------|-------|
| **Backend** | Ruby on Rails 7.0.8 |
| **Frontend** | Preact 10.20.2 |
| **Database** | PostgreSQL 14+ |
| **Cache/Jobs** | Redis + Sidekiq |
| **Entry Point** | `config/application.rb` |
| **Main Route File** | `config/routes.rb` |
| **Controllers** | 76+ |
| **Models** | 105+ |
| **API Endpoints** | 50+ (versioned v0, v1) |

---

## Generated Documentation

### Core Documentation

1. **[Project Overview](./project-overview.md)**
   - What is Vibecoding Community?
   - Technology stack summary
   - Key features overview
   - Quick command reference

2. **[Architecture Documentation](./architecture.md)**
   - System architecture diagram
   - Technology stack details
   - Design patterns used
   - Data flow and request lifecycle
   - Caching strategy
   - Security architecture
   - Deployment architecture

3. **[API Contracts](./api-contracts.md)**
   - REST API endpoints (v0, v1)
   - Authentication methods
   - Request/response formats
   - Rate limiting
   - API documentation locations

4. **[Data Models](./data-models.md)**
   - Database schema (106 tables)
   - Entity relationships
   - Key models (User, Article, Comment, etc.)
   - PostgreSQL extensions used
   - Migration patterns

5. **[Component Inventory](./component-inventory.md)**
   - UI component catalog (305+ components)
   - Crayons design system
   - Component organization
   - State management patterns
   - Testing approach
   - Storybook documentation

6. **[Source Tree Analysis](./source-tree-analysis.md)**
   - Directory structure
   - Critical paths explained
   - Entry points
   - Integration points
   - Configuration file locations

7. **[Development Guide](./development-guide.md)**
   - Prerequisites and installation
   - Local development setup
   - Running tests
   - Common development tasks
   - Debugging tips
   - CI/CD pipelines

---

## Existing Documentation

### Project Root Documentation

- **[README.md](../README.md)** - Project introduction and getting started
- **[CODE_OF_CONDUCT.md](../CODE_OF_CONDUCT.md)** - Community guidelines
- **[SECURITY.md](../SECURITY.md)** - Security policy
- **[CLA.md](../CLA.md)** - Contributor License Agreement
- **[LICENSE.md](../LICENSE.md)** - GNU AGPL v3.0 license
- **[CHANGELOG.md](../CHANGELOG.md)** - Release notes

### Technical Documentation (docs/)

**Internationalization:**
- [I18n Implementation Guide](./i18n_implementation_guide.md) - i18n architecture
- [Portuguese Internationalization Summary](./portuguese_internationalization_summary.md)
- [Locale Analysis](./locale_analysis.md) - Supported languages

**Performance:**
- [Feed Query Optimization](./feed_query_optimization.md) - Feed performance tuning
- [Feed Partial Index Optimization](./feed_partial_index_optimization.md) - Database indexes
- [Moderations Performance Optimizations](./moderations_performance_optimizations.md)

**Features:**
- [Survey Resubmission](./survey_resubmission.md) - Survey feature docs
- [Read-Only Database](./README_READ_ONLY_DATABASE.md) - Database replica setup

### GitHub Documentation (.github/)

- **[Pull Request Template](.github/PULL_REQUEST_TEMPLATE.md)** - PR guidelines
- **[Code Owners](.github/CODEOWNERS)** - Code ownership
- **[Issue Templates](.github/ISSUE_TEMPLATE/)** - Bug/feature templates
- **[Workflows](.github/workflows/)** - CI/CD configurations

---

## Documentation by Role

### For New Developers

**Start Here:**
1. [Project Overview](./project-overview.md) - Understand the project
2. [Development Guide](./development-guide.md) - Set up your environment
3. [Source Tree Analysis](./source-tree-analysis.md) - Navigate the code
4. ../README.md - Official getting started guide

**Then:**
- [Architecture](./architecture.md) - Learn system design
- [Component Inventory](./component-inventory.md) - UI components
- [Data Models](./data-models.md) - Database structure

### For Frontend Developers

**Key Docs:**
1. [Component Inventory](./component-inventory.md) - All UI components
2. [Architecture](./architecture.md) → Frontend Architecture section
3. [Development Guide](./development-guide.md) → Frontend Development section

**Important Paths:**
- Components: `app/javascript/`
- Design System: `app/javascript/crayons/`
- Storybook: Run `yarn storybook`

### For Backend Developers

**Key Docs:**
1. [API Contracts](./api-contracts.md) - API endpoints
2. [Data Models](./data-models.md) - Database models
3. [Architecture](./architecture.md) → Backend sections

**Important Paths:**
- Controllers: `app/controllers/`
- Models: `app/models/`
- Services: `app/services/`
- Workers: `app/workers/`

### For DevOps/Infrastructure

**Key Docs:**
1. [Architecture](./architecture.md) → Deployment Architecture
2. [Development Guide](./development-guide.md) → Deployment section

**Important Files:**
- `Containerfile` (Docker production)
- `docker-compose.yml` (local services)
- `.github/workflows/` (CI/CD)
- `config/` (application config)

### For API Consumers

**Key Docs:**
1. [API Contracts](./api-contracts.md) - Complete API reference
2. [Architecture](./architecture.md) → API Design section

**Endpoints:**
- v0: `/api/v0/*` (legacy)
- v1: `/api/v1/*` (current)

### For Product Managers / Architects

**Key Docs:**
1. [Project Overview](./project-overview.md) - High-level overview
2. [Architecture](./architecture.md) - System design
3. [Data Models](./data-models.md) - Data entities

---

## Getting Started Guides

### Local Development Setup

**Quick Setup:**
```bash
# Clone repository
git clone <repo-url>
cd vibecoding-community

# Install dependencies
bin/setup

# Start development server
foreman start -f Procfile.dev
```

**Access:** http://localhost:3000

**Details:** See [Development Guide](./development-guide.md)

### Running Tests

```bash
# Backend tests
bin/rspec

# Frontend tests
yarn test

# E2E tests
bin/e2e
```

**Details:** See [Development Guide](./development-guide.md) → Testing

### Common Tasks

**Database:**
```bash
bin/rails db:migrate          # Run migrations
bin/rails db:seed             # Seed data
bin/rails console             # Rails console
```

**Frontend:**
```bash
yarn build                    # Build JavaScript
yarn build --watch            # Watch mode
yarn storybook                # Component docs
```

---

## Architecture Overview

```
┌──────────────────────────────────────────────┐
│            User / Browser                     │
└──────────────┬───────────────────────────────┘
               │
        ┌──────┴──────┐
        │   CDN        │
        │  (Fastly)    │
        └──────┬──────┘
               │
┌──────────────┴───────────────────────────────┐
│         Rails Application (Puma)              │
│  ┌─────────────────────────────────────────┐ │
│  │ Controllers → Services → Models          │ │
│  │      ↓           ↓         ↓            │ │
│  │   Policies   Queries   Validators       │ │
│  └─────────────────────────────────────────┘ │
└──────┬────────────┬──────────────┬───────────┘
       │            │              │
   ┌───▼────┐  ┌───▼────┐    ┌───▼─────┐
   │Postgres│  │ Redis  │    │ Sidekiq │
   │        │  │ Cache  │    │ Workers │
   └────────┘  └────────┘    └─────────┘
```

**See:** [Architecture Documentation](./architecture.md)

---

## Technology Stack Summary

### Backend

- **Ruby:** 3.3.0
- **Rails:** 7.0.8.4
- **Database:** PostgreSQL 14+
- **Cache:** Redis 4.7.1
- **Jobs:** Sidekiq 6.5.3
- **Web Server:** Puma 5.6.4

### Frontend

- **Framework:** Preact 10.20.2
- **Build:** ESBuild 0.19.12
- **Enhancement:** Stimulus 3.2.2
- **Styles:** Sass 1.54.0
- **Docs:** Storybook 6.5.16

### Testing

- **Backend:** RSpec 6.0
- **Frontend:** Jest 28.1.3
- **E2E:** Cypress 13.7.2

**See:** [Architecture Documentation](./architecture.md) → Technology Stack

---

## Key Concepts

### Architecture Patterns

- **MVC:** Rails Model-View-Controller
- **Service Objects:** Business logic encapsulation
- **Query Objects:** Complex database queries
- **Policy Objects:** Authorization (Pundit)
- **Component-Based UI:** Reusable Preact components

### Data Patterns

- **Counter Caching:** Denormalized counts
- **Hierarchical Data:** Nested comments (ltree)
- **Polymorphic Associations:** Flexible relationships
- **Full-Text Search:** PostgreSQL + Algolia

### Frontend Patterns

- **Progressive Enhancement:** Stimulus controllers
- **Component Hierarchy:** Crayons design system
- **Context + Hooks:** State management (no Redux)
- **Lazy Loading:** Code splitting

**See:** [Architecture Documentation](./architecture.md)

---

## External Resources

### Official Forem Docs

- **Developer Docs:** https://developers.forem.com
- **Installation:** https://developers.forem.com/getting-started
- **Contributing:** https://developers.forem.com/contributing-guide
- **Technical Overview:** https://developers.forem.com/technical-overview

### Community

- **GitHub Repo:** https://github.com/forem/forem
- **Discussions:** https://github.com/forem/forem/discussions
- **DEV Community:** https://dev.to/t/forem

---

## Contributing

**Before Contributing:**
1. Read [CODE_OF_CONDUCT.md](../CODE_OF_CONDUCT.md)
2. Read [Contributing Guide](https://developers.forem.com/contributing-guide/forem)
3. Sign the [CLA](../CLA.md)

**Setup:**
1. Fork the repository
2. Follow [Development Guide](./development-guide.md)
3. Create feature branch
4. Write tests
5. Submit pull request

---

## Documentation Maintenance

**This documentation was auto-generated:**
- **Date:** 2025-11-09
- **Scan Type:** Deep Scan
- **Scan Level:** Critical directories + key files read
- **Generation Tool:** BMad Method document-project workflow

**To Regenerate:**
```bash
# Run the documentation workflow
/bmad:bmm:workflows:document-project
```

**To Update:**
- Manually edit individual docs as needed
- Re-run workflow for full refresh
- Keep index.md in sync with new documents

---

## Troubleshooting

### Can't Find Something?

**Use these strategies:**

1. **Search by keyword:**
   - Use GitHub search in repository
   - Search in specific docs (Cmd/Ctrl + F)

2. **Check these docs:**
   - **API Endpoints:** [API Contracts](./api-contracts.md)
   - **Database Tables:** [Data Models](./data-models.md)
   - **UI Components:** [Component Inventory](./component-inventory.md)
   - **File Paths:** [Source Tree Analysis](./source-tree-analysis.md)

3. **Explore the code:**
   - Use [Source Tree Analysis](./source-tree-analysis.md) as a map
   - Check `config/routes.rb` for routes
   - Check `db/schema.rb` for database structure

4. **Ask the community:**
   - GitHub Discussions
   - DEV.to platform

---

## Next Steps

### First Time Here?

✅ Read [Project Overview](./project-overview.md)
✅ Follow [Development Guide](./development-guide.md) to set up
✅ Explore [Source Tree](./source-tree-analysis.md) to understand layout
✅ Review [Architecture](./architecture.md) for system design

### Ready to Code?

✅ Check issues on GitHub (look for "ready for dev" label)
✅ Set up your local environment
✅ Write tests for your changes
✅ Follow coding standards (RuboCop, ESLint)
✅ Submit a pull request

### Planning New Features?

✅ Review [Architecture](./architecture.md) for patterns
✅ Check [Data Models](./data-models.md) for schema
✅ Review [API Contracts](./api-contracts.md) for existing endpoints
✅ Consider [Component Inventory](./component-inventory.md) for UI

---

**Last Updated:** 2025-11-09
**Documentation Version:** 1.0
**Scan Mode:** Deep Scan

---

## About This Documentation

This comprehensive documentation set was generated automatically by analyzing the Vibecoding Community codebase. It includes:

- 7 generated documentation files
- 15+ existing documentation files cataloged
- Complete API, data model, and component inventories
- Architecture and development guides

**Coverage:**
- ✅ 106 database tables documented
- ✅ 76+ controllers cataloged
- ✅ 105+ models analyzed
- ✅ 305+ UI components inventoried
- ✅ 50+ API endpoints documented

For questions, issues, or contributions, see the [Contributing](#contributing) section above.
