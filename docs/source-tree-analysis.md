# Source Tree Analysis - Vibecoding Community

## Overview

This document provides an annotated source tree of the Vibecoding Community codebase, highlighting critical directories and their purposes.

**Project Type:** Monolithic Rails web application
**Architecture Pattern:** MVC (Model-View-Controller) with modern frontend

---

## Root Directory Structure

```
vibecoding-community/
├── app/                    # Main application code (Rails MVC)
├── bin/                    # Executable scripts and CLI tools
├── config/                 # Application configuration
├── db/                     # Database schemas and migrations
├── docs/                   # Project documentation
├── lib/                    # Custom libraries and extensions
├── public/                 # Static assets (served directly)
├── spec/                   # RSpec tests
├── cypress/                # E2E tests (Cypress)
├── scripts/                # Utility scripts
├── swagger/                # API documentation (OpenAPI)
├── .github/                # GitHub workflows and templates
├── .buildkite/             # CI/CD configuration (Buildkite)
├── .devcontainer/          # VS Code dev container config
├── .dockerdev/             # Docker development setup
├── datadog/                # Datadog monitoring config
└── uffizzi/                # Uffizzi preview environment config
```

---

## Application Directory (`app/`)

The heart of the Rails application following MVC architecture with additional modern patterns.

```
app/
├── assets/                 # Asset pipeline (images, fonts, stylesheets)
│   ├── stylesheets/        # Sass/CSS files
│   └── images/             # Image assets
│
├── controllers/            # HTTP request handlers (76+ controllers)
│   ├── api/                # API endpoints
│   │   ├── v0/             # API version 0 (legacy)
│   │   └── v1/             # API version 1 (current)
│   ├── admin/              # Admin panel controllers
│   ├── concerns/           # Shared controller logic
│   └── *.rb                # Feature controllers (articles, comments, etc.)
│
├── models/                 # Business logic and data models (105+ models)
│   ├── concerns/           # Shared model logic
│   ├── ahoy/               # Analytics models
│   ├── articles/           # Article-related models
│   └── *.rb                # Domain models (User, Article, Comment, etc.)
│
├── views/                  # HTML templates (ERB)
│   ├── layouts/            # Page layouts
│   ├── shared/             # Shared partials
│   └── [resource]/         # Resource-specific views
│
├── javascript/             # Frontend code (Preact/JavaScript)
│   ├── crayons/            # Design system components (Crayons)
│   ├── controllers/        # Stimulus controllers
│   ├── article-form/       # Article editor components
│   ├── articles/           # Article display components
│   ├── admin/              # Admin UI components
│   ├── hooks/              # Custom React hooks
│   ├── shared/             # Shared utilities and components
│   ├── __tests__/          # JavaScript tests
│   └── .storybook/         # Storybook configuration
│
├── helpers/                # View helper methods
│   └── *.rb                # Template helpers
│
├── mailers/                # Email templates and mailers
│   └── *.rb                # Mailer classes
│
├── workers/                # Background job workers (Sidekiq)
│   └── *.rb                # Job classes
│
├── services/               # Service objects (business logic)
│   └── *.rb                # Service classes
│
├── policies/               # Authorization policies (Pundit)
│   └── *.rb                # Policy classes
│
├── queries/                # Query objects (complex DB queries)
│   └── *.rb                # Query classes
│
├── serializers/            # JSON API serializers
│   └── *.rb                # Serializer classes
│
├── decorators/             # Presentation logic decorators
│   └── *.rb                # Decorator classes
│
├── forms/                  # Form objects (complex forms)
│   └── *.rb                # Form classes
│
├── validators/             # Custom validators
│   └── *.rb                # Validator classes
│
├── uploaders/              # File upload handlers (CarrierWave)
│   └── *.rb                # Uploader classes
│
├── liquid_tags/            # Liquid tag extensions
│   └── *.rb                # Custom Liquid tags
│
├── sanitizers/             # HTML sanitization
│   └── *.rb                # Sanitizer classes
│
├── view_objects/           # View-specific objects
│   └── *.rb                # View object classes
│
├── errors/                 # Custom error classes
│   └── *.rb                # Error classes
│
└── refinements/            # Ruby refinements
    └── *.rb                # Refinement modules
```

---

## Configuration Directory (`config/`)

Application-wide configuration files.

```
config/
├── environments/           # Environment-specific configs
│   ├── development.rb      # Development settings
│   ├── test.rb             # Test settings
│   └── production.rb       # Production settings
│
├── initializers/           # App initialization code
│   ├── devise.rb           # Authentication config
│   ├── sidekiq.rb          # Background jobs config
│   ├── rack_attack.rb      # Rate limiting config
│   └── *.rb                # Other initializers
│
├── locales/                # I18n translation files
│   ├── en.yml              # English translations
│   ├── pt.yml              # Portuguese translations
│   └── *.yml               # Other languages
│
├── routes.rb               # URL routing definitions
├── database.yml            # Database configuration
├── application.rb          # Main app configuration
├── cable.yml               # Action Cable config (WebSockets)
├── storage.yml             # Active Storage config
└── puma.rb                 # Web server configuration
```

---

## Database Directory (`db/`)

Database-related files.

```
db/
├── migrate/                # Database migrations (chronological)
│   └── YYYYMMDDHHMMSS_*.rb # Migration files
│
├── seeds/                  # Seed data files
│   └── *.rb                # Seed scripts
│
└── schema.rb               # Current database schema (auto-generated)
```

**Schema Version:** `2025_10_22_175824`
**Total Tables:** 106
**Extensions:** pg_trgm, ltree, pgcrypto, citext, unaccent

---

## Testing Directory (`spec/`)

RSpec test suite.

```
spec/
├── models/                 # Model tests
├── controllers/            # Controller tests
├── requests/               # API/request tests
├── features/               # Feature specs (integration)
├── system/                 # System tests (Capybara)
├── services/               # Service object tests
├── workers/                # Background job tests
├── policies/               # Policy tests
├── factories/              # Test data factories (FactoryBot)
├── support/                # Test helpers and configurations
└── spec_helper.rb          # RSpec configuration
```

**Test Framework:** RSpec 6.0
**Coverage Tool:** SimpleCov
**Factories:** FactoryBot

---

## End-to-End Testing (`cypress/`)

Cypress E2E test suite.

```
cypress/
├── e2e/                    # Test specs
├── fixtures/               # Test data
├── support/                # Custom commands and utilities
└── cypress.config.js       # Cypress configuration
```

---

## Binary Scripts (`bin/`)

Executable scripts for development and operations.

```
bin/
├── rails                   # Rails CLI
├── rake                    # Rake tasks
├── rspec                   # RSpec test runner
├── setup                   # Initial project setup
├── dev                     # Start development server
├── bundle                  # Bundler wrapper
├── yarn                    # Yarn wrapper
├── e2e                     # Run E2E tests
└── *.sh                    # Custom scripts
```

---

## Public Assets (`public/`)

Statically served files.

```
public/
├── assets/                 # Compiled assets (from asset pipeline)
├── packs/                  # JavaScript bundles (from ESBuild)
├── images/                 # Public images
├── robots.txt              # Search engine directives
├── 404.html                # Error pages
└── favicon.ico             # Site favicon
```

---

## Library Extensions (`lib/`)

Custom libraries and Rake tasks.

```
lib/
├── tasks/                  # Custom Rake tasks
│   └── *.rake              # Task definitions
│
└── *.rb                    # Custom library code
```

---

## Container Configuration

### Docker

```
.dockerdev/                 # Docker development environment
├── Dockerfile              # Development container
└── docker-compose.yml      # Service orchestration

Containerfile               # Production container (symlinked as Dockerfile)
Containerfile.base          # Base image
container-compose.yml       # Container orchestration
docker-compose.yml          # Development services (PostgreSQL, Redis, etc.)
docker-compose.override.yml # Local overrides
```

**Services:**
- PostgreSQL (database)
- Redis (cache + Sidekiq)
- Rails app

### Development Container

```.devcontainer/            # VS Code dev containers
└── devcontainer.json       # Container configuration
```

---

## CI/CD Configuration

### GitHub Actions

```.github/
├── workflows/              # CI/CD pipelines
│   ├── ci.yml              # Continuous Integration
│   ├── cd.yml              # Continuous Deployment
│   ├── pr.yml              # Pull Request checks
│   ├── codeql-analysis.yml # Security scanning
│   └── *.yml               # Other workflows
│
├── CODEOWNERS              # Code ownership
├── dependabot.yml          # Dependency updates
├── PULL_REQUEST_TEMPLATE.md # PR template
└── ISSUE_TEMPLATE/         # Issue templates
```

### Buildkite

```.buildkite/              # Buildkite CI configuration
└── pipeline.yml            # Build pipeline
```

---

## Documentation (`docs/`)

Project documentation files.

```
docs/
├── README.md               # Docs overview
├── api-contracts.md        # API documentation (generated)
├── data-models.md          # Database models (generated)
├── component-inventory.md  # UI components (generated)
├── source-tree-analysis.md # This file (generated)
├── i18n_implementation_guide.md # I18n guide
├── feed_query_optimization.md # Performance docs
└── *.md                    # Feature-specific docs
```

---

## Configuration Files (Root)

### Package Management

- `Gemfile`, `Gemfile.lock` - Ruby dependencies (Bundler)
- `package.json`, `yarn.lock` - JavaScript dependencies (Yarn)
- `.ruby-version` - Ruby version (3.3.0)
- `.nvmrc` - Node version (20)

### Build Tools

- `esbuild.config.mjs` - ESBuild configuration
- `babel.config.js` - Babel transpilation
- `postcss.config.js` - PostCSS processing
- `jsconfig.json` - JavaScript project config

### Linting & Formatting

- `.rubocop.yml` - Ruby linting (RuboCop)
- `.eslintrc.js` - JavaScript linting (ESLint)
- `.prettierrc.json` - Code formatting (Prettier)
- `.erb-lint.yml` - ERB template linting

### Testing

- `jest.config.js` - Jest testing configuration
- `cypress.config.js` - Cypress E2E configuration
- `.rspec` - RSpec configuration
- `.simplecov` - Code coverage config

### Git

- `.gitignore` - Ignored files
- `.gitattributes` - Git attributes

### Other

- `config.ru` - Rack configuration
- `Procfile`, `Procfile.dev` - Process definitions (Heroku/Foreman)
- `Rakefile` - Rake tasks entry point

---

## Critical Entry Points

### Backend Entry Points

1. **Main Application:** `config/application.rb`
2. **Routes:** `config/routes.rb`
3. **Rack Server:** `config.ru`

### Frontend Entry Points

1. **JavaScript:** `app/javascript/packs/application.js`
2. **Stimulus:** `app/javascript/controllers/index.js`
3. **Styles:** `app/assets/stylesheets/application.scss`

### Background Jobs

1. **Sidekiq:** `config/sidekiq.yml`
2. **Workers:** `app/workers/`

---

## Integration Points

**External Services Integration:**
- Algolia (search) - `algoliasearch-rails`
- Cloudinary (images) - `cloudinary` gem
- Stripe (payments) - `stripe` gem
- Honeybadger (error tracking) - `honeybadger` gem
- Datadog (monitoring) - `ddtrace` gem
- Fastly (CDN) - `fastly` gem

**OAuth Providers:**
- GitHub
- Twitter
- Facebook
- Google
- Apple

---

## Key Patterns & Conventions

### Backend Patterns

- **MVC:** Traditional Rails MVC
- **Service Objects:** `app/services/` for complex business logic
- **Query Objects:** `app/queries/` for complex queries
- **Policy Objects:** `app/policies/` for authorization (Pundit)
- **Decorators:** `app/decorators/` for presentation logic
- **Form Objects:** `app/forms/` for complex form handling

### Frontend Patterns

- **Component-Based:** Preact components
- **Progressive Enhancement:** Stimulus controllers
- **Design System:** Crayons component library
- **Hook-Based:** Custom hooks for logic reuse

### Testing Patterns

- **Unit Tests:** RSpec for models, services
- **Integration Tests:** Request specs, feature specs
- **E2E Tests:** Cypress for critical flows
- **Component Tests:** Jest + Testing Library

---

**Generated:** 2025-11-09 (Deep Scan)
**Total Directories Analyzed:** 60+
**Critical Paths Documented:** 25+
