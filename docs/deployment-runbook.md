# Vibecoding Community - Deployment Runbook

**Version:** 1.0
**Last Updated:** 2025-11-09
**Maintained By:** DevOps Team

This runbook documents the complete deployment process for the Vibecoding Community platform, including staging and production environments, rollback procedures, and troubleshooting guides.

---

## Table of Contents

1. [Architecture Overview](#architecture-overview)
2. [Prerequisites](#prerequisites)
3. [Environment Configuration](#environment-configuration)
4. [Staging Deployment](#staging-deployment)
5. [Production Deployment](#production-deployment)
6. [Rollback Procedures](#rollback-procedures)
7. [Post-Deployment Validation](#post-deployment-validation)
8. [Troubleshooting](#troubleshooting)
9. [Emergency Procedures](#emergency-procedures)
10. [Monitoring & Alerts](#monitoring--alerts)

---

## Architecture Overview

```
Cloudflare CDN (Free tier)
    ↓ HTTPS + DDoS Protection
Railway/Render Platform
    ├── Web Service (Puma) - Rails 7.0.8 application
    ├── Worker Service (Sidekiq) - Background jobs
    ├── PostgreSQL 14+ (Managed)
    └── Redis 4.7.1+ (Managed)
    ↓
External Services:
    ├── Cloudinary (Image storage)
    ├── SendGrid (Email delivery)
    └── Sentry (Error tracking)
```

### Technology Stack

- **Backend:** Ruby on Rails 7.0.8.4, Ruby 3.3.0
- **Frontend:** Preact 10.20.2, Stimulus, Crayons Design System
- **Database:** PostgreSQL 14+ (managed)
- **Cache/Jobs:** Redis 4.7.1+, Sidekiq 6.5.3
- **Hosting:** Railway or Render ($30-50/month MVP)
- **CDN:** Cloudflare Free tier
- **Container:** Docker with multi-stage builds

---

## Prerequisites

### Required Accounts

✅ **GitHub** - Repository and CI/CD
- Access to: https://github.com/your-org/vibecoding-community
- Admin access for configuring secrets

✅ **Railway OR Render** - Hosting platform
- Railway: https://railway.app (preferred for Rails)
- Render: https://render.com
- Billing method configured

✅ **Cloudflare** - CDN and DNS (Free tier)
- Account: https://cloudflare.com

✅ **Cloudinary** - Image storage (Free tier: 25GB)
- Account: https://cloudinary.com

✅ **Sentry** - Error tracking (Free tier: 5k events/month)
- Account: https://sentry.io

✅ **SendGrid** - Email delivery (Free tier: 100/day)
- Account: https://sendgrid.com

### Required Tools

```bash
# Ruby environment
ruby 3.3.0
bundler 2.4.17

# Node environment
node 20.x (see .nvmrc)
yarn 1.22.18

# Platform CLIs (choose one)
npm i -g @railway/cli  # For Railway
npm i -g render-cli    # For Render

# Docker (for local testing)
docker --version  # 20.x or higher
docker-compose --version  # 1.29.x or higher
```

---

## Environment Configuration

### Step 1: Generate Secrets

```bash
# Generate SECRET_KEY_BASE
bundle exec rails secret
# Output: Copy this to SECRET_KEY_BASE

# Generate FOREM_OWNER_SECRET
bundle exec rails secret
# Output: Copy this to FOREM_OWNER_SECRET
```

### Step 2: External Service Configuration

#### Cloudinary Setup (Image Storage)

1. Sign up at https://cloudinary.com
2. Navigate to **Dashboard**
3. Copy your credentials:
   ```
   Cloud Name: your_cloud_name
   API Key: 123456789012345
   API Secret: abc123xyz456
   ```
4. Form CLOUDINARY_URL:
   ```
   cloudinary://123456789012345:abc123xyz456@your_cloud_name
   ```

#### Sentry Setup (Error Tracking)

1. Sign up at https://sentry.io
2. Create new project → Select **Ruby on Rails**
3. Navigate to **Settings** → **Client Keys (DSN)**
4. Copy DSN:
   ```
   https://abc123@o456789.ingest.sentry.io/1234567
   ```

#### SendGrid Setup (Email Delivery)

1. Sign up at https://sendgrid.com
2. Navigate to **Settings** → **API Keys**
3. Click **Create API Key**
4. Name: "Vibecoding Staging" or "Vibecoding Production"
5. Permissions: **Full Access** (or Mail Send only)
6. Copy API Key:
   ```
   SG.abc123xyz456...
   ```

### Step 3: Configure Environment Variables

Use the `.env.staging` template in the repository root as reference.

**Required Variables:**

| Variable | Description | Source |
|----------|-------------|--------|
| `DATABASE_URL` | PostgreSQL connection string | Auto-provided by platform |
| `REDIS_URL` | Redis connection string | Auto-provided by platform |
| `SECRET_KEY_BASE` | Rails secret for sessions | Generate with `rails secret` |
| `FOREM_OWNER_SECRET` | Admin access secret | Generate with `rails secret` |
| `APP_DOMAIN` | Your staging/production domain | Platform-assigned or custom |
| `APP_PROTOCOL` | `https://` | Manual |
| `RAILS_ENV` | `production` | Manual |
| `NODE_ENV` | `production` | Manual |
| `RAILS_SERVE_STATIC_FILES` | `true` | Manual |
| `RAILS_LOG_TO_STDOUT` | `true` | Manual |

**Recommended Variables:**

| Variable | Description | Source |
|----------|-------------|--------|
| `CLOUDINARY_URL` | Cloudinary connection string | Cloudinary dashboard |
| `SENTRY_DSN` | Sentry error tracking | Sentry dashboard |
| `SENDGRID_API_KEY` | SendGrid API key | SendGrid dashboard |

---

## Staging Deployment

### Option A: Railway Deployment

#### Initial Setup

```bash
# 1. Install Railway CLI
npm i -g @railway/cli

# 2. Login to Railway
railway login

# 3. Create new project
railway init
# Project name: vibecoding-staging

# 4. Add PostgreSQL
railway add --plugin postgresql

# 5. Add Redis
railway add --plugin redis

# 6. Link to GitHub repository
railway link
# Select your GitHub repo

# 7. Configure environment variables
railway variables set SECRET_KEY_BASE="<your-secret-key-base>"
railway variables set FOREM_OWNER_SECRET="<your-owner-secret>"
railway variables set RAILS_ENV="production"
railway variables set NODE_ENV="production"
railway variables set RAILS_SERVE_STATIC_FILES="true"
railway variables set RAILS_LOG_TO_STDOUT="true"
railway variables set APP_PROTOCOL="https://"

# Optional but recommended
railway variables set CLOUDINARY_URL="<your-cloudinary-url>"
railway variables set SENTRY_DSN="<your-sentry-dsn>"
railway variables set SENDGRID_API_KEY="<your-sendgrid-key>"

# 8. Deploy
railway up
```

#### GitHub Integration (Auto-Deploy)

1. Go to Railway dashboard → Your project
2. Navigate to **Settings** → **GitHub**
3. Connect your repository
4. Set branch: `main`
5. Enable **Auto-Deploy on Push**
6. ✅ Done! Every merge to `main` will auto-deploy

#### Custom Domain Setup

```bash
# Via CLI
railway domain

# Or via Dashboard:
# 1. Go to project → Settings → Domains
# 2. Add custom domain: staging.vibecoding.community
# 3. Update DNS (CNAME or A record) as instructed
# 4. Wait for SSL certificate provisioning (automatic)
```

---

### Option B: Render Deployment

#### Initial Setup

```bash
# 1. Sign up and create new project
# Go to: https://render.com/dashboard

# 2. Create new Blueprint
# - Click "New +" → "Blueprint"
# - Connect your GitHub repository
# - Select render.yaml from repo
# - Click "Apply"

# 3. Configure environment variables
# Go to each service → Environment tab:

# Web Service:
SECRET_KEY_BASE=<your-secret-key-base>
FOREM_OWNER_SECRET=<your-owner-secret>
APP_DOMAIN=<your-render-domain>.onrender.com
CLOUDINARY_URL=<your-cloudinary-url>  # optional
SENTRY_DSN=<your-sentry-dsn>          # optional
SENDGRID_API_KEY=<your-sendgrid-key>  # optional

# Worker Service (same as web):
# Copy environment variables from web service

# 4. Deploy
# Render automatically deploys after Blueprint setup
```

#### Custom Domain Setup

1. Go to service → **Settings** tab
2. Scroll to **Custom Domain** section
3. Add domain: `staging.vibecoding.community`
4. Update DNS (CNAME to `your-app.onrender.com`)
5. Wait for SSL certificate provisioning (automatic)

---

### GitHub Actions Setup (Both Platforms)

Configure GitHub Secrets for CI/CD deployment:

```bash
# Go to: Repository → Settings → Secrets and variables → Actions

# For Railway:
RAILWAY_TOKEN=<from Railway dashboard → Account → Tokens>
STAGING_DOMAIN=<your-staging-domain>  # without https://

# For Render:
RENDER_SERVICE_ID=<from Render dashboard → Service → Settings>
RENDER_API_KEY=<from Render dashboard → Account → API Keys>
RENDER_DEPLOY_HOOK_URL=<from Render dashboard → Service → Deploy Hook>
STAGING_DOMAIN=<your-staging-domain>  # without https://
```

**Enable Deploy Job:**

Edit `.github/workflows/ci.yml` and uncomment the deployment method you're using (Railway or Render).

---

## Production Deployment

### Important: Manual Approval Gate

🚨 **Production deployments require manual approval and should NOT auto-deploy on merge to main.**

### Pre-Production Checklist

Before deploying to production, ensure:

- [ ] All staging tests passed
- [ ] Staging environment is stable (no errors in last 24 hours)
- [ ] Database migrations tested on staging
- [ ] Performance requirements met (see smoke test checklist)
- [ ] Security scan passed (no critical vulnerabilities)
- [ ] Backup of production database taken
- [ ] Team notified of deployment window
- [ ] Rollback plan reviewed

### Production Deployment Steps

#### Railway Production

```bash
# 1. Create production project (separate from staging)
railway init
# Project name: vibecoding-production

# 2. Add plugins (PostgreSQL, Redis)
railway add --plugin postgresql
railway add --plugin redis

# 3. Configure environment variables
# Same as staging, but with production values:
railway variables set APP_DOMAIN="vibecoding.community"
railway variables set SENTRY_ENVIRONMENT="production"
# ... (all other variables)

# 4. Manual deploy
railway up

# 5. Verify deployment
curl https://vibecoding.community/api/v1/health_checks/app
```

#### Render Production

1. Create new services from same `render.yaml`
2. Select **Production** environment
3. Configure environment variables with production values
4. **Disable** auto-deploy
5. Deploy manually via dashboard: **Manual Deploy** → **Deploy latest commit**

### Production Deployment Cadence

- **Staging:** Continuous deployment (every merge to `main`)
- **Production:** Weekly releases (Fridays, 10 AM PST) or as needed
- **Hotfixes:** As needed, with expedited approval

---

## Rollback Procedures

### When to Rollback

Rollback immediately if:

- Critical bugs affecting core functionality
- Data corruption or loss detected
- Performance degradation > 50% (response time > 3 seconds)
- Security vulnerability introduced
- Health check failures persist > 5 minutes
- Error rate > 5% of requests

### Rollback Steps

#### Railway Rollback

```bash
# Option 1: Via CLI
railway rollback

# Option 2: Via Dashboard
# 1. Go to project → Deployments
# 2. Find previous stable deployment
# 3. Click "Redeploy"
```

**Time to Rollback:** ~2 minutes

#### Render Rollback

```bash
# Via Dashboard:
# 1. Go to service → Deploys tab
# 2. Find previous successful deploy
# 3. Click "Rollback to this version"
```

**Time to Rollback:** ~2 minutes

### Database Rollback (Migrations)

If a migration caused issues:

```bash
# Option 1: SSH into running container (Railway)
railway run bash
bundle exec rails db:rollback STEP=1

# Option 2: SSH into running container (Render)
# Via dashboard → Shell tab
bundle exec rails db:rollback STEP=1

# Option 3: Manual SQL (for complex rollbacks)
# Connect to database and execute SQL manually
```

### Post-Rollback Verification

After rollback, verify:

1. Health check returns 200 OK
2. Homepage loads successfully
3. User authentication works
4. Database queries execute normally
5. Background jobs processing
6. Error rate back to normal (< 1%)

---

## Post-Deployment Validation

### Automated Validation (CI/CD)

The GitHub Actions workflow automatically runs:

1. ✅ Build Docker image
2. ✅ Run RSpec test suite
3. ✅ Deploy to staging
4. ✅ Health check validation

### Manual Smoke Test Checklist

After deployment, manually verify:

#### Critical Path Testing

- [ ] **Homepage:** https://staging.vibecoding.community loads successfully
- [ ] **Health Check:** `/api/v1/health_checks/app` returns 200 OK
- [ ] **Database Health:** `/api/v1/health_checks/database` returns 200 OK
- [ ] **Cache Health:** `/api/v1/health_checks/cache` returns 200 OK
- [ ] **User Registration:** Can create new account
- [ ] **User Login:** Can log in with existing account
- [ ] **Create Post:** Can publish new post
- [ ] **Image Upload:** Can upload image to Cloudinary
- [ ] **Email Delivery:** Welcome email received (check SendGrid)
- [ ] **Background Jobs:** Sidekiq processing jobs

#### Performance Validation

- [ ] Homepage load time < 2 seconds
- [ ] API response time < 500ms (average)
- [ ] Database queries < 100ms (average)
- [ ] Redis latency < 10ms

#### Security Validation

- [ ] HTTPS enforced (http:// redirects to https://)
- [ ] SSL certificate valid
- [ ] Security headers present (check with securityheaders.com)
- [ ] No sensitive data in logs

#### External Services Validation

- [ ] Cloudinary: Images loading via CDN
- [ ] Sentry: Errors captured and reported
- [ ] SendGrid: Emails delivered successfully
- [ ] Cloudflare: CDN serving static assets

### Performance Benchmarks

**Expected Performance (Staging):**

| Metric | Target | Acceptable | Critical |
|--------|--------|------------|----------|
| Homepage Load Time | < 1.5s | < 2.5s | > 3s |
| API Response Time | < 300ms | < 500ms | > 1s |
| Database Query Time | < 50ms | < 100ms | > 200ms |
| Error Rate | < 0.1% | < 1% | > 5% |
| Uptime | 99.9% | 99% | < 99% |

---

## Troubleshooting

### Common Issues

#### 1. Deployment Fails: "Build Error"

**Symptoms:**
- CI/CD pipeline fails at build step
- Error: "Docker build failed"

**Solution:**
```bash
# Test Docker build locally
docker build -t vibecoding-test .

# Check for syntax errors in Dockerfile
# Check for missing dependencies in Gemfile/package.json
# Ensure all files are committed and pushed
```

#### 2. Health Check Fails After Deployment

**Symptoms:**
- Deployment succeeds but health check returns 500 or timeout

**Diagnosis:**
```bash
# Check application logs
railway logs  # Railway
# or Render dashboard → Logs tab

# Common causes:
# - Database migration failed
# - Redis connection failed
# - Environment variable missing
```

**Solution:**
```bash
# Verify environment variables
railway variables  # Railway
# or Render dashboard → Environment tab

# Check database connection
railway run rails db:migrate:status

# Check Redis connection
railway run rails runner 'puts Redis.current.ping'
```

#### 3. Database Migration Fails

**Symptoms:**
- Deployment hangs at migration step
- Error: "PG::Error: relation does not exist"

**Solution:**
```bash
# SSH into container and run migrations manually
railway run bash
bundle exec rails db:migrate

# If migration is stuck, check for:
# - Long-running queries (kill them)
# - Table locks (release them)
# - Missing indexes (add them)
```

#### 4. Asset Precompilation Fails

**Symptoms:**
- Build fails with "Error: ENOENT" or "Sprockets::NotFound"

**Solution:**
```bash
# Clear asset cache locally
rm -rf tmp/cache/assets public/assets

# Rebuild assets
RAILS_ENV=production bundle exec rails assets:precompile

# Check for:
# - Missing JavaScript dependencies (run `yarn install`)
# - Invalid asset paths in manifests
```

#### 5. "Out of Memory" Error

**Symptoms:**
- Application crashes with "Killed" status
- Health check fails intermittently

**Solution:**
```bash
# Railway: Upgrade plan or reduce WEB_CONCURRENCY
railway variables set WEB_CONCURRENCY=1

# Render: Upgrade to higher plan
# Dashboard → Settings → Instance Type → Select larger plan

# Monitor memory usage
railway run ps aux  # Check memory consumption
```

#### 6. Background Jobs Not Processing

**Symptoms:**
- Emails not sending
- Sidekiq dashboard shows queued jobs

**Solution:**
```bash
# Check Sidekiq is running
railway ps  # Should show worker process

# If not running on Railway, add worker:
# Update railway.toml to include worker service

# For Render, verify worker service exists:
# Dashboard → Services → Should see "vibecoding-sidekiq"

# Check Redis connection
railway run rails runner 'puts Sidekiq.redis { |c| c.ping }'
```

### Debug Commands

```bash
# View logs (Railway)
railway logs --tail 100

# View logs (Render)
# Dashboard → Logs tab

# SSH into container (Railway)
railway run bash

# SSH into container (Render)
# Dashboard → Shell tab

# Run Rails console
railway run rails console

# Check environment variables
railway variables

# Test database connection
railway run rails dbconsole

# Test Redis connection
railway run rails runner 'puts Redis.current.ping'

# Check Sidekiq status
railway run rails runner 'puts Sidekiq::Stats.new.inspect'
```

---

## Emergency Procedures

### Emergency Contact List

**On-Call Rotation:**
- Primary: [Your Name] - [Email] - [Phone]
- Secondary: [Backup Name] - [Email] - [Phone]
- Escalation: [Manager Name] - [Email] - [Phone]

**External Support:**
- Railway Support: support@railway.app
- Render Support: support@render.com
- Sentry Support: https://sentry.io/support/

### Critical Outage Response

**Severity Levels:**

- **P0 (Critical):** Complete outage, data loss, security breach
  - Response time: Immediate (< 15 minutes)
  - Action: Rollback immediately, notify team

- **P1 (High):** Major feature broken, performance degradation > 50%
  - Response time: < 1 hour
  - Action: Investigate, prepare rollback

- **P2 (Medium):** Minor feature broken, isolated user impact
  - Response time: < 4 hours
  - Action: Fix in next deployment

- **P3 (Low):** Cosmetic issues, minor bugs
  - Response time: < 24 hours
  - Action: Add to backlog

### Emergency Rollback Process

```bash
# 1. Assess severity (P0/P1/P2/P3)
# 2. Notify team via Slack/Email
# 3. Execute rollback (see Rollback Procedures section)
# 4. Verify stability post-rollback
# 5. Conduct post-mortem within 24 hours
```

### Database Emergency Recovery

**If database corruption detected:**

```bash
# 1. Stop application (prevent further writes)
railway service stop

# 2. Restore from latest backup
# Railway: Dashboard → PostgreSQL → Backups → Restore
# Render: Dashboard → Database → Backups → Restore

# 3. Verify data integrity
railway run rails dbconsole
# Run: SELECT COUNT(*) FROM users;  # Sanity check

# 4. Restart application
railway service start

# 5. Monitor error rates
```

---

## Monitoring & Alerts

### Health Check Endpoints

| Endpoint | Purpose | Expected Response |
|----------|---------|-------------------|
| `/api/v1/health_checks/app` | Application health | `{"message": "App is up"}` |
| `/api/v1/health_checks/database` | PostgreSQL connection | `{"message": "Database connected"}` |
| `/api/v1/health_checks/cache` | Redis connection | `{"message": "Cache connected"}` |

### Sentry Error Tracking

**Setup:**

1. Go to https://sentry.io/your-project
2. Navigate to **Alerts** → **Create Alert**
3. Create alert rule:
   - **Name:** "Production Error Spike"
   - **Condition:** Error count > 10 in 5 minutes
   - **Action:** Email + Slack notification

### Platform Monitoring

**Railway:**
- Dashboard → Metrics tab
- View CPU, Memory, Network usage
- Set up alerts for resource limits

**Render:**
- Dashboard → Metrics tab
- View Request rate, Response time, Errors
- Set up alerts for health check failures

### Custom Monitoring (Optional)

Consider adding:
- **UptimeRobot:** Free uptime monitoring (https://uptimerobot.com)
- **Better Uptime:** Status page + monitoring (https://betteruptime.com)
- **Datadog:** Comprehensive APM (paid)

---

## Appendix

### A. Environment Variables Reference

See `.env.staging` in repository root for complete list.

### B. Platform Comparison

| Feature | Railway | Render |
|---------|---------|--------|
| **Pricing** | $5-10/service | $7/service |
| **Free Tier** | $5 credit/month | No (trial only) |
| **Auto-scaling** | Yes | Yes (Standard plan) |
| **Zero-downtime** | Yes | Yes (Standard plan) |
| **GitHub Integration** | Excellent | Excellent |
| **Database Backups** | Daily (automatic) | Daily (automatic) |
| **Support** | Community + Email | Community + Email |
| **Ease of Use** | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ |
| **Rails Support** | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ |

**Recommendation:** Railway for MVP (easier setup), Render for production (more mature).

### C. Cost Breakdown

**Staging Environment (Railway):**
- Web service: $5/month
- Worker service: $5/month
- PostgreSQL: $5/month (1GB)
- Redis: $5/month (256MB)
- **Total:** ~$20/month

**Staging Environment (Render):**
- Web service: $7/month
- Worker service: $7/month
- PostgreSQL: $7/month
- Redis: $10/month
- **Total:** ~$31/month

**Production (Recommended):**
- Web service: $25/month (Standard plan)
- Worker service: $25/month (Standard plan)
- PostgreSQL: $15/month (2GB)
- Redis: $20/month (1GB)
- **Total:** ~$85/month

**External Services (All Free Tiers):**
- Cloudinary: $0 (25GB storage)
- SendGrid: $0 (100 emails/day)
- Sentry: $0 (5k events/month)
- Cloudflare: $0 (unlimited CDN)

---

## Changelog

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.0 | 2025-11-09 | BMAD Dev Agent | Initial runbook creation for Epic 1, Story 1.3 |

---

**End of Deployment Runbook**

For questions or updates, contact the DevOps team or submit a PR to this document.
