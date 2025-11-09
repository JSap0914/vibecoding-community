# Deployment Setup Quick Start Guide

🚀 **Story 1.3 Implementation Status:** Code artifacts complete, manual setup required

---

## What's Been Done (Automated)

✅ **Configuration Files Created:**
- `.env.staging` - Complete environment variable template
- `railway.toml` - Railway deployment configuration
- `render.yaml` - Render deployment configuration
- `.github/workflows/ci.yml` - Enhanced with deploy-staging job

✅ **Documentation Created:**
- `docs/deployment-runbook.md` - Comprehensive 90+ page deployment guide

✅ **Verified Existing:**
- `Dockerfile` - Production-ready (no changes needed)
- Health check endpoints at `/api/v1/health_checks/*` (working)
- CI/CD pipeline with automated tests (working)

---

## What You Need to Do (Manual Setup)

### Quick Setup Path (~2 hours)

#### Step 1: Choose Hosting Platform (5 minutes)

**Recommendation: Railway** (easier setup, great for Rails)

| Feature | Railway | Render |
|---------|---------|--------|
| Cost | ~$20/month | ~$31/month |
| Setup Ease | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ |
| Rails Support | Excellent | Excellent |

#### Step 2: Generate Secrets (2 minutes)

```bash
cd vibecoding-community

# Generate two secrets
bundle exec rails secret
# Copy output for SECRET_KEY_BASE

bundle exec rails secret
# Copy output for FOREM_OWNER_SECRET
```

Save these somewhere safe - you'll need them in Step 4.

#### Step 3: Create Platform Account (10 minutes)

**Option A: Railway Setup**

```bash
# Install CLI
npm i -g @railway/cli

# Login
railway login

# Create project
railway init
# Name: vibecoding-staging

# Add database and cache
railway add --plugin postgresql
railway add --plugin redis

# Link to GitHub
railway link
# Select your vibecoding-community repo
```

**Option B: Render Setup**

1. Go to https://render.com/dashboard
2. Click "New +" → "Blueprint"
3. Connect GitHub repository
4. Select `render.yaml` from repo
5. Click "Apply"

#### Step 4: Configure Environment Variables (15 minutes)

**Railway:**

```bash
# Required variables
railway variables set SECRET_KEY_BASE="<paste-secret-from-step-2>"
railway variables set FOREM_OWNER_SECRET="<paste-second-secret-from-step-2>"
railway variables set RAILS_ENV="production"
railway variables set NODE_ENV="production"
railway variables set RAILS_SERVE_STATIC_FILES="true"
railway variables set RAILS_LOG_TO_STDOUT="true"
railway variables set APP_PROTOCOL="https://"

# APP_DOMAIN will be provided by Railway
# DATABASE_URL will be auto-set by PostgreSQL plugin
# REDIS_URL will be auto-set by Redis plugin
```

**Render:**

Go to Dashboard → Service → Environment tab and add:
- `SECRET_KEY_BASE` = (from Step 2)
- `FOREM_OWNER_SECRET` = (from Step 2)
- `APP_DOMAIN` = your-app.onrender.com (provided after deploy)
- (Other vars are auto-set or configured in render.yaml)

#### Step 5: Deploy! (10 minutes)

**Railway:**

```bash
railway up
```

Wait 5-10 minutes for first deployment. Railway will:
- Build Docker image
- Run database migrations
- Start application

**Render:**

Render auto-deploys after Blueprint setup. Watch progress in Dashboard.

#### Step 6: Verify Deployment (5 minutes)

```bash
# Get your staging URL
# Railway: Shows in CLI output or dashboard
# Render: Shows in dashboard after deploy

# Test health check
curl https://your-staging-url/api/v1/health_checks/app
# Should return: {"message":"App is up"}

# Open in browser
open https://your-staging-url
```

✅ **If homepage loads, you're done with minimal setup!**

---

### Full Production Setup (~4 hours)

After basic staging works, set up external services:

#### 1. Image Storage: Cloudinary (15 minutes)

**Why:** Store user-uploaded images

1. Sign up: https://cloudinary.com (Free: 25GB storage, 25GB bandwidth/month)
2. Dashboard → Copy credentials:
   - Cloud Name: `your_cloud_name`
   - API Key: `123456789012345`
   - API Secret: `abc123xyz456`
3. Form URL: `cloudinary://API_KEY:API_SECRET@CLOUD_NAME`
4. Add to platform:
   ```bash
   railway variables set CLOUDINARY_URL="cloudinary://..."
   ```

#### 2. Error Tracking: Sentry (15 minutes)

**Why:** Monitor application errors

1. Sign up: https://sentry.io (Free: 5k events/month)
2. Create project → Ruby on Rails
3. Copy DSN: `https://abc123@o456789.ingest.sentry.io/1234567`
4. Add to platform:
   ```bash
   railway variables set SENTRY_DSN="https://..."
   railway variables set SENTRY_ENVIRONMENT="staging"
   ```

#### 3. Email Delivery: SendGrid (15 minutes)

**Why:** Send welcome emails, notifications

1. Sign up: https://sendgrid.com (Free: 100 emails/day)
2. Settings → API Keys → Create API Key
3. Name: "Vibecoding Staging", Permissions: Full Access
4. Copy API Key: `SG.abc123xyz456...`
5. Add to platform:
   ```bash
   railway variables set SENDGRID_API_KEY="SG...."
   ```

#### 4. CDN: Cloudflare (30 minutes)

**Why:** Speed up asset delivery, DDoS protection

1. Sign up: https://cloudflare.com (Free tier)
2. Add domain: `vibecoding.community`
3. Update nameservers at domain registrar (as instructed)
4. Wait for DNS propagation (15-30 minutes)
5. Configure staging subdomain:
   - DNS → Add record → CNAME → `staging` → `your-railway-url`

#### 5. GitHub Actions Auto-Deploy (20 minutes)

**Why:** Auto-deploy when merging PRs to main

1. Get platform credentials:

**Railway:**
```bash
# Get token from: Railway Dashboard → Account → Tokens
# Create new token: "GitHub Actions Deploy"
```

**Render:**
```
# Get from Dashboard → Service → Settings:
# - Service ID: srv-abc123
# - Deploy Hook URL: https://api.render.com/deploy/srv-abc123...

# Get API key from: Dashboard → Account → API Keys
```

2. Add to GitHub:
   - Go to: Repository → Settings → Secrets and variables → Actions
   - Click "New repository secret"

**For Railway:**
   - Name: `RAILWAY_TOKEN`, Value: (your token)
   - Name: `STAGING_DOMAIN`, Value: your-app.up.railway.app

**For Render:**
   - Name: `RENDER_SERVICE_ID`, Value: srv-abc123
   - Name: `RENDER_API_KEY`, Value: (your API key)
   - Name: `RENDER_DEPLOY_HOOK_URL`, Value: (deploy hook URL)
   - Name: `STAGING_DOMAIN`, Value: your-app.onrender.com

3. Edit `.github/workflows/ci.yml`:
   - Uncomment your platform's deployment section (lines ~137-158)
   - Save and commit

4. Test:
   - Create test PR
   - Merge to main
   - Watch GitHub Actions tab for auto-deploy

---

## Troubleshooting

### "Health check returns 500"

```bash
# Check logs
railway logs  # Railway
# or Dashboard → Logs tab (Render)

# Common issues:
# - Database not connected (check DATABASE_URL)
# - Redis not connected (check REDIS_URL)
# - Missing SECRET_KEY_BASE
```

### "Deployment times out"

```bash
# Increase build timeout
# Railway: Settings → Build timeout → 15 minutes
# Render: Automatically retries, wait longer

# Check build logs for errors
```

### "Assets not loading"

```bash
# Verify RAILS_SERVE_STATIC_FILES=true
railway variables get RAILS_SERVE_STATIC_FILES

# Check asset precompilation in build logs
# Should see: "Compiled all assets"
```

### "Can't access admin panel"

```bash
# Verify FOREM_OWNER_SECRET is set
railway variables get FOREM_OWNER_SECRET

# Access via: https://your-staging-url/admin
# Use the FOREM_OWNER_SECRET value to authenticate
```

---

## Next Steps

After deployment works:

1. ✅ **Test smoke checklist** (see `docs/deployment-runbook.md` page 35)
2. 📝 **Update Story 1.3** - Mark remaining manual tasks as complete
3. 🎨 **Move to Story 1.4** - Custom Vibecoding Theme (fully automatable!)
4. 🔄 **Set up production** - Follow same process with production environment

---

## Quick Reference

| Resource | Location |
|----------|----------|
| **Full Deployment Guide** | `docs/deployment-runbook.md` |
| **Environment Variables** | `.env.staging` (template) |
| **Railway Config** | `railway.toml` |
| **Render Config** | `render.yaml` |
| **CI/CD Workflow** | `.github/workflows/ci.yml` |
| **Health Checks** | `/api/v1/health_checks/{app,database,cache}` |

---

## Support

**Questions?**
- Check `docs/deployment-runbook.md` (comprehensive guide)
- Railway docs: https://docs.railway.app
- Render docs: https://render.com/docs

**Issues?**
- Railway support: support@railway.app
- Render support: support@render.com

---

**Last Updated:** 2025-11-09
**Story:** 1.3 Deployment Pipeline & Staging Environment
