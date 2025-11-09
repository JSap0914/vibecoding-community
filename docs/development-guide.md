# Vibecoding Community - Development Setup Guide

**Last Updated:** 2025-11-09
**Version:** 1.0.0
**Platform:** Forem (Brownfield Customization)
**Architecture:** Ruby on Rails 7.0.8.4 + Preact 10.20.2
**Target:** New developers setting up local development environment

---

## Table of Contents

1. [Overview](#overview)
2. [Prerequisites](#prerequisites)
3. [Quick Start](#quick-start)
4. [Detailed Setup](#detailed-setup)
5. [Docker Setup (Recommended)](#docker-setup-recommended)
6. [Native Installation (Alternative)](#native-installation-alternative)
7. [Running the Application](#running-the-application)
8. [Development Workflow](#development-workflow)
9. [Testing](#testing)
10. [Troubleshooting](#troubleshooting)
11. [Windows MINGW64 Considerations](#windows-mingw64-considerations)
12. [Additional Resources](#additional-resources)

---

## Overview

Vibecoding Community is a customized Forem platform designed for the South Korean developer community. This guide will help you set up your local development environment.

**Key Features:**
- Brownfield Forem customization with namespaced extensions
- PostgreSQL 14+ database
- Redis 7 for caching and background jobs
- Preact 10.20.2 for frontend components
- Docker Compose for local services

**Project Structure:**
- All customizations namespaced under `vibecoding/` or `custom/`
- Maintains Forem upgrade compatibility
- Git commits prefixed with `[VIBECODING]` for custom code

---

## Prerequisites

### Required Software

**Ruby 3.3.0**
- Install via: rbenv (recommended), rvm, or direct download
- Verify: `.ruby-version` file specifies 3.3.0

**Node.js 20.x**
- Install via: nvm (recommended) or direct download
- Verify: `.nvmrc` file specifies Node 20

**PostgreSQL 14+**
- **Recommended:** Docker Compose (see Docker Setup section)
- Alternative: Native installation (see Native Installation section)

**Redis 7**
- **Recommended:** Docker Compose (see Docker Setup section)
- Alternative: Native installation (see Native Installation section)

**Yarn 1.22.18**
- Package manager for JavaScript dependencies
- Install: `npm install -g yarn@1.22.18`

**Bundler**
- Ruby dependency manager
- Install: `gem install bundler`

**Docker Desktop (Recommended)**
- Simplifies PostgreSQL and Redis setup
- Download: https://www.docker.com/products/docker-desktop

### System Requirements

- **OS**: macOS, Linux, or Windows (with MINGW64/WSL2)
- **RAM**: Minimum 8GB, recommended 16GB
- **Disk Space**: Minimum 10GB free space

### Optional Tools

- **Foreman** - Process manager for running multiple services
- **mise** - Multi-language version manager
- **Git** - Required for version control

---

## Quick Start

For experienced developers who want to get up and running quickly:

```bash
# 1. Clone repository
git clone https://github.com/your-org/vibecoding-community.git
cd vibecoding-community

# 2. Install Ruby and Node (if needed)
rbenv install 3.3.0  # or: rvm install 3.3.0
nvm install 20

# 3. Start Docker services (PostgreSQL + Redis)
docker-compose up -d postgres redis

# 4. Set up environment
cp .env.example .env
# Edit .env: Set FOREM_OWNER_SECRET (generate with: rails secret after bundle install)

# 5. Run setup script
bin/setup

# 6. Start development server
foreman start -f Procfile.dev
# OR individually: bin/rails server, bundle exec sidekiq, yarn build --watch
```

**Access:** http://localhost:3000

---

## Detailed Setup

### Step 1: Clone the Repository

```bash
git clone https://github.com/your-org/vibecoding-community.git
cd vibecoding-community
```

### Step 2: Install Ruby 3.3.0

**Option A - Using rbenv (Recommended for macOS/Linux):**

```bash
# Install rbenv (if not already installed)
brew install rbenv ruby-build  # macOS
# or follow: https://github.com/rbenv/rbenv#installation

# Install Ruby 3.3.0
rbenv install 3.3.0
rbenv global 3.3.0

# Verify
ruby --version  # Should show: ruby 3.3.0
```

**Option B - Using RVM:**

```bash
# Install RVM (if not already installed)
\curl -sSL https://get.rvm.io | bash -s stable

# Install Ruby 3.3.0
rvm install 3.3.0
rvm use 3.3.0 --default

# Verify
ruby --version  # Should show: ruby 3.3.0
```

### Step 3: Install Node.js 20.x

**Using nvm (Recommended):**

```bash
# Install nvm (if not already installed)
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
# or follow: https://github.com/nvm-sh/nvm#installing-and-updating

# Install Node 20.x (version from .nvmrc)
nvm install 20
nvm use 20

# Verify
node --version  # Should show: v20.x.x
```

### Step 4: Install Yarn

```bash
npm install -g yarn@1.22.18
yarn --version  # Should show: 1.22.18
```

### Step 5: Install Bundler

```bash
gem install bundler
bundler --version  # Should show: 2.x
```

---

## Docker Setup (Recommended)

Vibecoding Community uses Docker Compose for PostgreSQL 14 and Redis 7 services.

### Docker Architecture

**PostgreSQL 14 (vibecoding_postgres)**
- Image: `postgres:14-alpine`
- Port: `5432`
- Credentials: `postgres` / `postgres`
- Database: `vibecoding_dev`
- Volume: `postgres_data` (persistent storage)

**Redis 7 (vibecoding_redis)**
- Image: `redis:7.0-alpine`
- Port: `6379`
- Volume: `redis_data` (persistent storage)

### Starting Docker Services

```bash
# Start both PostgreSQL and Redis
docker-compose up -d postgres redis

# Verify containers are running
docker-compose ps

# Expected output:
#   NAME                    STATUS    PORTS
#   vibecoding_postgres     Up        0.0.0.0:5432->5432/tcp
#   vibecoding_redis        Up        0.0.0.0:6379->6379/tcp

# View logs
docker-compose logs -f postgres
docker-compose logs -f redis

# Stop services
docker-compose stop postgres redis

# Restart services
docker-compose restart postgres redis
```

### Docker Health Checks

```bash
# Check PostgreSQL connectivity
docker exec vibecoding_postgres pg_isready -U postgres
# Expected: /var/run/postgresql:5432 - accepting connections

# Check Redis connectivity
docker exec vibecoding_redis redis-cli ping
# Expected: PONG
```

### Docker Volume Management

```bash
# List volumes
docker volume ls | grep vibecoding

# Remove containers (keeps volumes/data)
docker-compose down

# Remove containers AND volumes (WARNING: Deletes all data)
docker-compose down -v
```

---

## Native Installation (Alternative)

If you prefer not to use Docker, install PostgreSQL and Redis natively.

### PostgreSQL 14+ (Native)

**macOS (Homebrew):**
```bash
brew install postgresql@14
brew services start postgresql@14

# Create user and databases
createuser -s postgres
createdb vibecoding_dev
createdb vibecoding_test
```

**Linux (Ubuntu/Debian):**
```bash
sudo apt update
sudo apt install postgresql-14 postgresql-contrib

# Start service
sudo systemctl start postgresql
sudo systemctl enable postgresql

# Create user and databases
sudo -u postgres createuser -s $USER
createdb vibecoding_dev
createdb vibecoding_test
```

**Update `.env`:**
```bash
DATABASE_URL="postgresql://localhost:5432/vibecoding_dev"
DATABASE_URL_TEST="postgresql://localhost:5432/vibecoding_test"
```

### Redis 7 (Native)

**macOS (Homebrew):**
```bash
brew install redis
brew services start redis
```

**Linux (Ubuntu/Debian):**
```bash
sudo apt update
sudo apt install redis-server

# Start service
sudo systemctl start redis-server
sudo systemctl enable redis-server
```

**Update `.env`:**
```bash
REDIS_URL="redis://localhost:6379"
```

---

## Environment Configuration

### Create .env File

```bash
cp .env.example .env
```

### Required Environment Variables

Edit `.env` with the following required values:

```bash
# Application Core
APP_DOMAIN="localhost:3000"
APP_PROTOCOL="http://"
FOREM_OWNER_SECRET="<generate-with-rails-secret-after-bundle-install>"
COMMUNITY_NAME="Vibecoding Community"
DEFAULT_EMAIL="admin@vibecoding.community"

# Database (Docker setup)
DATABASE_NAME="vibecoding_dev"
DATABASE_URL="postgresql://localhost:5432/vibecoding_dev"
DATABASE_NAME_TEST="vibecoding_test"
DATABASE_URL_TEST="postgresql://localhost:5432/vibecoding_test"

# Redis (Docker setup)
REDIS_URL="redis://localhost:6379"
SESSION_KEY="_Vibecoding_Community_Session"

# Rails/Node
RAILS_ENV="development"
NODE_ENV="development"

# Optional: Third-party services (leave empty for local dev)
# CLOUDINARY_URL=
# SENDGRID_API_KEY=
# GA_ANALYTICS_4_ID=
```

**Generate SECRET:**
```bash
# After running bundle install
bundle exec rails secret
# Copy output to FOREM_OWNER_SECRET in .env
```

---

## Run Setup Script

The Forem `bin/setup` script automates most setup tasks:

```bash
bin/setup
```

**What `bin/setup` does:**
1. Installs Bundler
2. Configures bundle settings
3. Runs `bundle install` (Ruby dependencies)
4. Runs `yarn install` (JavaScript dependencies)
5. Copies sample configuration files
6. Creates databases (`vibecoding_dev`, `vibecoding_test`)
7. Runs database migrations
8. Seeds initial data
9. Runs application initializer (`rails app_initializer:setup`, `forem:setup`)

**Expected successful output:**
```
== Installing dependencies ==
The Gemfile's dependencies are satisfied
...
== Preparing database ==
Created database 'vibecoding_dev'
Created database 'vibecoding_test'
...
== Removing old logs and tempfiles ==
== Restarting application server ==
```

**If setup fails:**
- Check Docker containers are running: `docker-compose ps`
- Check environment variables in `.env`
- See [Troubleshooting](#troubleshooting) section

---

## Installation

### Method 1: Local Installation (Recommended for Contributors)

#### Step 1: Clone the Repository

```bash
git clone https://github.com/forem/forem.git
cd forem
```

#### Step 2: Install Ruby & Node

Using mise (recommended):
```bash
mise install
```

Or manually:
```bash
# Ruby (using rbenv)
rbenv install 3.3.0
rbenv local 3.3.0

# Node (using nvm)
nvm install 20
nvm use 20
```

#### Step 3: Install PostgreSQL & Redis

**macOS (Homebrew):**
```bash
brew install postgresql@14 redis
brew services start postgresql@14
brew services start redis
```

**Linux (Ubuntu/Debian):**
```bash
sudo apt-get install postgresql postgresql-contrib redis-server
sudo systemctl start postgresql
sudo systemctl start redis
```

#### Step 4: Run Setup Script

```bash
bin/setup
```

This script will:
- Install gem dependencies (Bundler)
- Install JavaScript dependencies (Yarn)
- Copy sample configuration files
- Create database
- Run migrations
- Seed initial data

#### Step 5: Start Development Server

```bash
foreman start -f Procfile.dev
```

This starts:
- Rails web server on port 3000
- Sidekiq background worker
- JavaScript build watcher (ESBuild)

**Access the app:** http://localhost:3000

### Method 2: Docker Development

#### Prerequisites
- Docker
- Docker Compose

#### Start Services

```bash
docker-compose up
```

**Access the app:** http://localhost:3000

**Note:** Docker setup is in `.dockerdev/` directory

### Method 3: Gitpod / Cloud Development

**Gitpod:**
1. Navigate to: `https://gitpod.io/#https://github.com/{your_username}/forem`
2. Workspace auto-configures
3. Development server starts automatically

**Configuration:** `.gitpod.yml`

---

## Development Workflow

### Running the Application

**Start all services:**
```bash
foreman start -f Procfile.dev
```

**Individual services:**
```bash
# Rails server only
bin/rails server

# Sidekiq only
bundle exec sidekiq

# JavaScript watch mode only
yarn build --watch
```

### Database Operations

**Create database:**
```bash
bin/rails db:create
```

**Run migrations:**
```bash
bin/rails db:migrate
```

**Seed data:**
```bash
bin/rails db:seed
```

**Reset database (WARNING: Destructive):**
```bash
bin/db-reset  # Custom script
# OR
bin/rails db:drop db:create db:migrate db:seed
```

**Console:**
```bash
bin/rails console
```

### Frontend Development

**Build JavaScript:**
```bash
yarn build
```

**Watch mode (auto-rebuild):**
```bash
yarn build --watch
```

**Storybook (component development):**
```bash
yarn storybook
# Access at http://localhost:6006
```

**Generate CSS utility docs:**
```bash
yarn generate-storybook-themes
```

---

## Testing

### Backend Tests (RSpec)

**Run all tests:**
```bash
bin/rspec
```

**Run specific test file:**
```bash
bin/rspec spec/models/article_spec.rb
```

**Run specific test:**
```bash
bin/rspec spec/models/article_spec.rb:10
```

**Run with coverage:**
```bash
bin/rspecov  # Custom script with coverage
```

**Parallel execution:**
```bash
bin/parallel_rspec
```

**With Knapsack Pro (CI):**
```bash
bin/knapsack_pro_rspec
```

### Frontend Tests (Jest)

**Run all tests:**
```bash
yarn test
```

**Watch mode:**
```bash
yarn test:watch
```

**With coverage:**
```bash
yarn test --coverage
```

### E2E Tests (Cypress)

**Run E2E tests:**
```bash
yarn e2e
# OR
bin/e2e
```

**Setup E2E environment:**
```bash
bin/e2e-setup
```

**Interactive mode:**
```bash
yarn cypress open
```

**With Knapsack Pro (CI):**
```bash
bin/knapsack_pro_cypress
```

### Linting

**Ruby (RuboCop):**
```bash
bin/rubocop
# Auto-fix
bin/rubocop -A
```

**JavaScript (ESLint):**
```bash
yarn lint:frontend
```

**ERB Templates:**
```bash
bin/erblint
```

**Formatting (Prettier):**
```bash
npx prettier --write "app/javascript/**/*.{js,jsx}"
```

---

## Code Quality Tools

### Git Hooks (Husky + lint-staged)

**Installed automatically** on `yarn install`

**Pre-commit checks:**
- Prettier formatting
- ESLint linting
- RuboCop (if configured)

**Configuration:** `.lintstagedrc.js`

### Security Scanning

**Brakeman (Security vulnerabilities):**
```bash
bundle exec brakeman
```

**Bundler Audit (Gem vulnerabilities):**
```bash
bundle exec bundler-audit check --update
```

**CodeQL:** Runs automatically on GitHub PRs (.github/workflows/codeql-analysis.yml)

### Performance Profiling

**Derailed Benchmarks:**
```bash
bundle exec derailed bundle:mem
bundle exec derailed bundle:objects
```

**Memory Profiler:**
```ruby
# In code
require 'memory_profiler'
report = MemoryProfiler.report do
  # code to profile
end
report.pretty_print
```

**StackProf:**
```ruby
require 'stackprof'
StackProf.run(mode: :cpu, out: 'tmp/stackprof.dump') do
  # code to profile
end
```

---

## Configuration

### Environment Variables

**Sample file:** `.env_sample`
**Local file:** `.env` (git-ignored)

**Key variables:**
```bash
# Database
DATABASE_URL=postgresql://localhost/forem_development

# Redis
REDIS_URL=redis://localhost:6379

# Rails
RAILS_ENV=development
SECRET_KEY_BASE=<generated>

# Application
APP_DOMAIN=localhost:3000
APP_PROTOCOL=http

# Feature flags
# (see .env_sample for full list)
```

**Copy sample:**
```bash
cp .env_sample .env
# Edit .env with your values
```

### Database Configuration

**File:** `config/database.yml`
**Sample:** `config/database.yml.sample`

**Auto-copied** by `bin/setup`

### Application Configuration

**Rails config:** `config/application.rb`
**Environment configs:** `config/environments/{development,test,production}.rb`
**Initializers:** `config/initializers/`

---

## Common Development Tasks

### Creating a Migration

```bash
bin/rails generate migration AddFieldToModel field:type
bin/rails db:migrate
```

### Creating a Model

```bash
bin/rails generate model Article title:string body:text user:references
bin/rails db:migrate
```

### Creating a Controller

```bash
bin/rails generate controller Articles index show create
```

### Adding a Background Job

```bash
bin/rails generate job ProcessArticle
# Edit app/workers/process_article_job.rb
```

### Managing I18n Translations

**Find missing translations:**
```bash
bundle exec i18n-tasks missing
```

**Find unused translations:**
```bash
bundle exec i18n-tasks unused
```

**Normalize translation files:**
```bash
bundle exec i18n-tasks normalize
```

---

## Debugging

### Rails Console

```bash
bin/rails console
# or
bin/rails c
```

### Debugging with binding.pry

Add to code:
```ruby
require 'pry'
binding.pry
```

Run code and console will break at that line.

### Debugging JavaScript

**Browser DevTools:** Chrome/Firefox DevTools
**VS Code:** Launch configurations in `.vscode/`

### Rails Debugging

**web-console:** Available in browser on errors (development only)

**debug gem:**
```ruby
require 'debug'
debugger
```

---

## CI/CD

### GitHub Actions

**Workflows:** `.github/workflows/`

**Key workflows:**
- `ci.yml` - Continuous Integration (tests, linting)
- `pr.yml` - Pull Request checks
- `cd.yml` - Continuous Deployment
- `codeql-analysis.yml` - Security scanning

**Test in Pull Requests:**
- RSpec tests (parallel)
- Jest tests
- Cypress E2E tests
- RuboCop linting
- ESLint linting
- Security scans

### Buildkite

**Configuration:** `.buildkite/pipeline.yml`
**Used for:** Parallel test execution with Knapsack Pro

---

## Deployment

### Production Deployment

**Platform:** Varies by deployment (Heroku, AWS, etc.)

**Release tasks:** `release-tasks.sh`
- Runs migrations
- Compiles assets

**Procfile:** Defines web and worker processes

### Container Deployment

**Production container:** `Containerfile` (symlinked as Dockerfile)
**Base image:** `Containerfile.base`

**Build:**
```bash
docker build -t forem:latest .
```

**Run:**
```bash
docker-compose -f container-compose.yml up
```

---

## Windows MINGW64 Considerations

Vibecoding Community can be developed on Windows using MINGW64 (Git Bash).

### Prerequisites for Windows

1. **Git for Windows** (includes MINGW64/Git Bash)
   - Download: https://git-scm.com/download/win
   - Use Git Bash for all commands in this guide

2. **Docker Desktop for Windows**
   - Download: https://www.docker.com/products/docker-desktop
   - Ensure WSL2 backend is enabled
   - Docker Desktop must be running

3. **Ruby for Windows**
   - Use RubyInstaller with MSYS2 toolchain
   - Download: https://rubyinstaller.org/
   - Select Ruby 3.3.0 with DevKit

4. **Node.js for Windows**
   - Download: https://nodejs.org/en/download/
   - Select Node 20.x LTS Windows installer

### Windows-Specific Setup

**Line Endings:**
```bash
# Configure Git to handle line endings correctly
git config --global core.autocrlf true
```

**File Permissions:**
```bash
# Grant execute permissions to scripts (in Git Bash)
chmod +x bin/setup
chmod +x bin/rails
chmod +x bin/rake
```

**Docker Networking:**
- The `docker-compose.override.yml` is already configured for Windows
- Uses `host.docker.internal` for container-to-host communication
- Uses `bridge` network mode for Windows compatibility

### Running on Windows

**Start Docker Services:**
```bash
# In Git Bash
docker-compose up -d postgres redis

# Verify
docker-compose ps
```

**Run Setup:**
```bash
# In Git Bash
./bin/setup
```

**Start Development Server:**
```bash
# In Git Bash
bundle exec rails server
# In separate terminal: bundle exec sidekiq
# In separate terminal: yarn build --watch
```

### Windows-Specific Troubleshooting

**Issue: Ruby native extension build failures**

Solution:
```bash
# Ensure Ruby DevKit/MSYS2 is installed
# Reinstall using RubyInstaller with DevKit
# Download from: https://rubyinstaller.org/
```

**Issue: Docker containers fail to start**

Solution:
1. Ensure Docker Desktop is running
2. Check WSL2 is enabled: `wsl --status`
3. Restart Docker Desktop
4. Check Docker Desktop Settings → Resources → WSL Integration

**Issue: Permission denied on scripts**

Solution:
```bash
# In Git Bash, grant execute permissions
chmod +x bin/*
```

**Issue: PostgreSQL connection fails from Rails**

Solution:
```bash
# Verify containers are running
docker-compose ps

# Check container logs
docker-compose logs postgres

# Test connection manually
docker exec vibecoding_postgres psql -U postgres -c "SELECT version();"
```

**Issue: Path issues with spaces**

Solution:
- Avoid spaces in project path
- Clone to: `C:\projects\vibecoding-community` (not `C:\Users\My Name\...`)

---

## Troubleshooting

### PostgreSQL Connection Issues

```bash
# Check if PostgreSQL is running
pg_isready

# Start PostgreSQL (macOS)
brew services start postgresql@14

# Check connection
psql -d postgres -c "SELECT version();"
```

### Redis Connection Issues

```bash
# Check if Redis is running
redis-cli ping
# Should return: PONG

# Start Redis (macOS)
brew services start redis
```

### Asset Compilation Issues

```bash
# Clear cache
bin/rails tmp:cache:clear

# Rebuild assets
yarn build
bin/rails assets:precompile
```

### Database Migration Issues

```bash
# Check migration status
bin/rails db:migrate:status

# Rollback last migration
bin/rails db:rollback

# Reset database (WARNING: Destructive)
bin/db-reset
```

---

## Developer Resources

### Official Documentation

- **Forem Docs:** https://developers.forem.com
- **Installation Guides:** https://developers.forem.com/getting-started
- **Technical Overview:** https://developers.forem.com/technical-overview
- **Contributing Guide:** https://developers.forem.com/contributing-guide

### Community

- **GitHub Discussions:** https://github.com/forem/forem/discussions
- **DEV Community:** https://dev.to/t/forem

### Key Commands Reference

| Task | Command |
|------|---------|
| Setup project | `bin/setup` |
| Start dev server | `foreman start -f Procfile.dev` |
| Rails console | `bin/rails console` |
| Run tests | `bin/rspec` |
| Run frontend tests | `yarn test` |
| Run E2E tests | `bin/e2e` |
| Lint Ruby | `bin/rubocop` |
| Lint JavaScript | `yarn lint:frontend` |
| Database migrate | `bin/rails db:migrate` |
| Storybook | `yarn storybook` |

---

**Generated:** 2025-11-09 (Deep Scan)
**Based on:** Forem codebase analysis
