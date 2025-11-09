# Epic Technical Specification: SEO & Content Discoverability

Date: 2025-11-09
Author: JSup
Epic ID: 3
Status: Draft

---

## Overview

Epic 3 focuses on implementing comprehensive SEO optimization and content discoverability infrastructure for the Vibecoding Community platform. This epic transforms the Forem-based community into a search engine optimized content hub designed to capture organic traffic for "vibecoding" and AI development related searches, while maximizing social sharing reach.

The epic encompasses five core technical areas: automated meta tag generation with Schema.org structured data, XML sitemap generation with search engine submission workflows, social sharing optimization with Open Graph/Twitter Card previews, clean URL structures with strategic internal linking, and RSS feed distribution infrastructure.

## Objectives and Scope

**In Scope:**

- **SEO Meta Tags & Structured Data (Story 3.1)**
  - Automated meta tag generation (title, description, canonical URLs) for all content
  - Schema.org JSON-LD implementation (Article, Person, Organization schemas)
  - Open Graph and Twitter Card markup for social sharing
  - Robots meta tags for crawl control

- **Sitemap & Search Engine Indexing (Story 3.2)**
  - Automated XML sitemap generation (/sitemap.xml)
  - Sitemap index for large-scale content
  - robots.txt configuration for crawler optimization
  - Google Search Console and Bing Webmaster Tools integration

- **Social Sharing Optimization (Story 3.3)**
  - Beautiful social preview cards for all shared content
  - Share buttons (Twitter, LinkedIn, Facebook, Copy Link)
  - Auto-generated social images for posts without custom covers
  - UTM parameter tracking on social shares

- **Content URL Structure & Internal Linking (Story 3.4)**
  - Clean, keyword-rich slug-based URLs
  - 301 redirect handling for changed slugs
  - Related posts and tag-based content discovery
  - Strategic internal linking for SEO equity distribution

- **RSS Feeds & Content Distribution (Story 3.5)**
  - Global RSS feed (/feed.xml)
  - Tag-specific and user-specific feeds
  - RSS autodiscovery tags
  - Feed promotion and subscriber tracking

**Out of Scope:**

- Paid search advertising campaigns
- Advanced link building or backlink acquisition (manual process)
- Multilingual SEO (future enhancement)
- Video SEO optimization (YouTube embeds only)
- Local SEO optimization (not geographically focused)
- Advanced schema types (FAQ, HowTo, etc. - post-MVP)

## System Architecture Alignment

This epic aligns with the **Brownfield Customization Strategy** defined in the architecture, extending Forem's existing SEO capabilities rather than rebuilding them:

**Leverage Existing Forem Infrastructure:**
- Forem's built-in SEO features (meta tags, sitemaps, RSS feeds)
- Server-side rendering (SSR) for all public content
- Clean URL routing via Rails ActiveRecord slugs
- Existing Crayons design system for UI components

**Custom Extensions Required:**
- `lib/vibecoding/seo_optimizer.rb` - Custom SEO service for meta tag generation
- `config/sitemap.rb` - Enhanced sitemap configuration for vibecoding taxonomy
- `app/javascript/custom/SocialShareButtons.jsx` - Custom social sharing components
- `app/views/layouts/_meta_tags.html.erb` - Enhanced meta tag partials

**Integration Points:**
- **Google Search Console** - Sitemap submission, crawl error monitoring, search analytics
- **Bing Webmaster Tools** - Alternative search engine indexing
- **Cloudflare CDN** - Static asset delivery and caching (from Epic 1)
- **Google Analytics 4** - Social share tracking and SEO performance metrics (from Epic 5)

**Architecture Constraints:**
- Must maintain Forem upgradability (no core file modifications)
- All customizations namespaced under `vibecoding/` or `custom/`
- Performance budget: LCP < 2.5s (SEO ranking factor)
- Schema.org validation required for all structured data

## Detailed Design

### Services and Modules

**Vibecoding::SeoOptimizer Service**
- **Location:** `lib/vibecoding/seo_optimizer.rb`
- **Responsibility:** Generate and validate SEO meta tags for all content types
- **Key Methods:**
  - `generate_meta_tags(content)` - Returns hash of meta tags (title, description, OG, Twitter Card)
  - `generate_structured_data(content)` - Returns Schema.org JSON-LD markup
  - `validate_meta_tags(tags)` - Validates tag completeness and character limits
- **Inputs:** Article, User, Page models
- **Outputs:** Hash of meta tag key-value pairs, JSON-LD structured data
- **Dependencies:** Rails helpers, MetaTags gem (if used)

**SocialShareTracking Module**
- **Location:** `app/javascript/analytics/social_share_tracker.js`
- **Responsibility:** Track social share button clicks and generate UTM parameters
- **Key Functions:**
  - `trackShareClick(platform, url)` - Sends GA4 event when share button clicked
  - `generateSocialUrl(platform, url, title)` - Builds share URL with UTM params
- **Integration:** Google Analytics 4 events, GTM dataLayer

**SitemapGenerator Configuration**
- **Location:** `config/sitemap.rb`
- **Responsibility:** Define sitemap structure and update frequency
- **Configuration:**
  - Posts: priority 0.8, changefreq daily
  - Tags: priority 0.6, changefreq weekly
  - User profiles: priority 0.4, changefreq weekly
  - Static pages: priority 0.9, changefreq monthly
- **Auto-update:** Triggered on post publish/update via ActiveJob

**RSS Feed Controllers**
- **Location:** `app/controllers/feeds_controller.rb` (Forem existing, may extend)
- **Responsibility:** Serve RSS/Atom feeds with proper formatting
- **Endpoints:**
  - `/feed.xml` - Global feed
  - `/tags/:tag/feed.xml` - Tag-specific feed
  - `/:username/feed.xml` - User feed
- **Output:** RSS 2.0 and Atom 1.0 formats with full content

**Meta Tag Partial**
- **Location:** `app/views/layouts/_meta_tags.html.erb`
- **Responsibility:** Render meta tags in HTML head
- **Includes:**
  - Standard meta tags (title, description, canonical)
  - Open Graph tags (og:title, og:image, og:url, og:type)
  - Twitter Card tags (twitter:card, twitter:title, twitter:image)
  - Schema.org JSON-LD scripts
  - Robots meta tags

### Data Models and Contracts

**No New Database Tables Required**

This epic leverages existing Forem schema without modifications. All SEO data is derived from existing models:

**Existing Models Used:**
- **Article** (Forem core)
  - Fields: `title`, `body_markdown`, `description`, `slug`, `canonical_url`, `main_image`, `published_at`
  - Used for: Article schema, meta tags, sitemap entries

- **User** (Forem core)
  - Fields: `name`, `username`, `summary`, `profile_image`, `created_at`
  - Used for: Person schema, author metadata, user feeds

- **Tag** (Forem core)
  - Fields: `name`, `short_summary`, `rules_html`, `bg_color_hex`
  - Used for: Tag pages, tag-specific feeds and sitemaps

**Configuration Data:**

**SEO Settings** (stored in environment variables or Rails config):
```ruby
# config/initializers/vibecoding_seo.rb
VibeCoding::SEO = {
  site_name: "Vibecoding Community",
  site_description: "The central hub for vibecoders - developers using AI and natural language to build applications",
  twitter_handle: "@vibecoding",
  default_og_image: "https://cdn.vibecoding.com/assets/og-default.png",
  keywords: ["vibecoding", "ANYON", "AI development", "natural language programming"]
}
```

### APIs and Interfaces

**External Service Integrations:**

**1. Google Search Console API**
- **Purpose:** Sitemap submission, crawl error monitoring
- **Authentication:** OAuth 2.0 service account
- **Endpoints Used:**
  - `POST /webmasters/v3/sites/{siteUrl}/sitemaps/{feedpath}` - Submit sitemap
  - `GET /webmasters/v3/sites/{siteUrl}/sitemaps` - List sitemaps
- **Rate Limits:** 1,200 queries/minute
- **Error Handling:** Retry with exponential backoff, log failures to Sentry

**2. Bing Webmaster Tools API**
- **Purpose:** Submit sitemaps to Bing search engine
- **Authentication:** API key
- **Endpoints Used:**
  - `POST /Webmaster/Api.svc/json/SubmitUrlbatch` - Submit URLs
- **Rate Limits:** 10,000 URLs/day
- **Error Handling:** Queue failed submissions for retry

**3. Schema.org JSON-LD Format**

**Article Schema Example:**
```json
{
  "@context": "https://schema.org",
  "@type": "Article",
  "headline": "Building a SaaS Platform with ANYON Vibecoding",
  "description": "A step-by-step guide to building production applications using natural language and AI",
  "author": {
    "@type": "Person",
    "name": "John Vibecoder",
    "url": "https://vibecoding.com/vibecoders/john"
  },
  "datePublished": "2025-01-15T10:00:00Z",
  "dateModified": "2025-01-16T14:30:00Z",
  "image": "https://cdn.vibecoding.com/posts/saas-anyon.png",
  "publisher": {
    "@type": "Organization",
    "name": "Vibecoding Community",
    "logo": {
      "@type": "ImageObject",
      "url": "https://vibecoding.com/logo.png"
    }
  },
  "mainEntityOfPage": {
    "@type": "WebPage",
    "@id": "https://vibecoding.com/building-saas-with-anyon"
  }
}
```

**Open Graph Meta Tags Contract:**
```html
<meta property="og:title" content="{{article.title}} | Vibecoding Community" />
<meta property="og:description" content="{{article.description || first 160 chars}}" />
<meta property="og:image" content="{{article.main_image || default_og_image}}" />
<meta property="og:url" content="{{canonical_url}}" />
<meta property="og:type" content="article" />
<meta property="og:site_name" content="Vibecoding Community" />
<meta property="article:published_time" content="{{article.published_at}}" />
<meta property="article:author" content="{{article.user.name}}" />
<meta property="article:tag" content="{{article.tags.join(', ')}}" />
```

**Twitter Card Meta Tags Contract:**
```html
<meta name="twitter:card" content="summary_large_image" />
<meta name="twitter:site" content="@vibecoding" />
<meta name="twitter:title" content="{{article.title}}" />
<meta name="twitter:description" content="{{article.description}}" />
<meta name="twitter:image" content="{{article.main_image || default_twitter_image}}" />
<meta name="twitter:creator" content="{{article.user.twitter_username}}" />
```

### Workflows and Sequencing

**1. Post Publication SEO Workflow**

```
User publishes new article
    ↓
Article model after_save callback
    ↓
Enqueue SeoOptimizationJob (Sidekiq)
    ↓
┌─────────────────────────────────────┐
│ SeoOptimizationJob.perform          │
│ 1. Generate slug (if not exists)    │
│ 2. Generate meta description        │
│ 3. Validate canonical URL           │
│ 4. Generate Schema.org JSON-LD      │
│ 5. Update sitemap cache             │
│ 6. Ping search engines (optional)   │
└─────────────────────────────────────┘
    ↓
Update article.seo_metadata (JSON field, if added)
    ↓
Clear page cache for article
    ↓
Log SEO optimization completion
```

**2. Sitemap Generation Workflow**

```
Scheduled job (daily at 2 AM UTC)
    ↓
SitemapGeneratorJob.perform
    ↓
Query all published articles (published_at < now)
    ↓
Query all active users (articles_count > 0)
    ↓
Query all tags (taggings_count > 0)
    ↓
Generate XML sitemap chunks (max 50k URLs per file)
    ↓
┌──────────────────────────────────┐
│ sitemap.xml.gz (index)           │
│ ├─ sitemap-posts.xml.gz          │
│ ├─ sitemap-users.xml.gz          │
│ ├─ sitemap-tags.xml.gz           │
│ └─ sitemap-pages.xml.gz          │
└──────────────────────────────────┘
    ↓
Upload to CDN (Cloudflare)
    ↓
Submit to Google Search Console API
Submit to Bing Webmaster Tools API
    ↓
Log sitemap generation completion
```

**3. Social Share Click Workflow**

```
User clicks share button (Twitter, LinkedIn, Facebook)
    ↓
JavaScript event handler fires
    ↓
Generate share URL with UTM parameters
  - utm_source=social
  - utm_medium={platform}
  - utm_campaign=organic-share
    ↓
Track event in Google Analytics 4
  - event: social_share
  - platform: twitter|linkedin|facebook
  - content_id: article.id
    ↓
Open share dialog (platform-specific)
    ↓
User completes share (external to our platform)
```

**4. RSS Feed Request Workflow**

```
User/RSS reader requests /feed.xml
    ↓
Rails routing → FeedsController#index
    ↓
Check Rails cache for feed (10 min TTL)
    ↓
Cache miss?
  ├─ YES → Query last 50 published articles
  │         ↓
  │         Render RSS template (XML builder)
  │         ↓
  │         Cache result for 10 minutes
  │         ↓
  │         Return XML response
  └─ NO → Return cached feed
```

**5. Slug Change Redirect Workflow**

```
Author changes article slug (edit post)
    ↓
Article model before_update callback
    ↓
Detect slug change (slug_was != slug)
    ↓
Create Redirect record
  - from: old_slug
  - to: new_slug
  - status: 301 (permanent)
    ↓
Save redirect to database (redirects table, if implemented)
    ↓
Clear page caches
    ↓
Incoming request to old_slug
    ↓
Middleware checks Redirect table
    ↓
Return 301 redirect to new_slug
```

## Non-Functional Requirements

### Performance

**SEO Performance Targets (Critical for Search Rankings):**

- **Largest Contentful Paint (LCP):** < 2.5 seconds
  - All pages with meta tags must meet Core Web Vitals thresholds
  - SEO-critical pages (posts, tags, profiles) prioritized for fastest LCP

- **Meta Tag Generation:** < 50ms overhead per request
  - Meta tag generation via `SeoOptimizer` service must be fast and cacheable
  - Use fragment caching for meta tag partials (10-minute TTL)

- **Sitemap Generation:** Complete in < 5 minutes for 10,000 posts
  - Scheduled job should handle up to 50,000 URLs efficiently
  - Incremental sitemap updates for new posts (not full regeneration)

- **RSS Feed Response Time:** < 200ms (p95)
  - RSS feeds cached for 10 minutes in Rails cache
  - Use counter caches to avoid N+1 queries

- **Social Share Button Load Time:** < 100ms to interactive
  - JavaScript for share buttons must be lightweight (< 5KB gzipped)
  - Lazy load share buttons below the fold

**Optimization Strategies:**

- **Caching:**
  - Fragment cache meta tag partials: `cache ["meta-tags-v1", article.cache_key_with_version]`
  - Russian doll caching for nested Schema.org JSON-LD
  - CDN caching for sitemap.xml (1-hour TTL)

- **Database Query Optimization:**
  - Eager load associations for SEO data: `Article.includes(:user, :tags)`
  - Database indexes on `articles.published_at`, `articles.slug`
  - Avoid N+1 queries in sitemap generation

- **Asset Optimization:**
  - Minify and compress social share JavaScript
  - Use SVG icons for share buttons (smaller than images)
  - Defer non-critical JavaScript (share tracking)

### Security

**Meta Tag Security:**

- **XSS Prevention:**
  - Escape all user-generated content in meta tags using Rails HTML escaping
  - Sanitize article titles, descriptions before rendering in meta tags
  - Validate URLs in canonical tags and Open Graph image URLs

- **Content Security Policy (CSP):**
  - Allow Schema.org JSON-LD inline scripts with nonce
  - Restrict external script sources for social share buttons
  - Example: `script-src 'self' 'nonce-{{csp_nonce}}' https://www.googletagmanager.com`

**API Security:**

- **Google Search Console API:**
  - Use OAuth 2.0 service account with least-privilege access
  - Store service account credentials in encrypted environment variables
  - Rotate API credentials every 90 days

- **Bing Webmaster Tools API:**
  - Store API key in Rails encrypted credentials
  - Rate limit API calls to prevent abuse

**URL Security:**

- **Slug Validation:**
  - Validate slugs match pattern: `[a-z0-9-]+` (no special characters)
  - Prevent slug injection attacks (e.g., `../../admin`)
  - Maximum slug length: 100 characters

- **Redirect Security:**
  - Only allow 301 redirects to internal URLs (same domain)
  - Prevent open redirect vulnerabilities
  - Log all redirect creations for audit trail

**Social Sharing Security:**

- **UTM Parameter Validation:**
  - Sanitize UTM parameters to prevent XSS in analytics
  - Use allowlist for utm_source, utm_medium values

- **Share URL Validation:**
  - Validate shared URLs are from vibecoding.com domain
  - Prevent social share buttons from sharing arbitrary URLs

### Reliability/Availability

**Sitemap Generation Reliability:**

- **Job Failure Handling:**
  - Retry sitemap generation job up to 3 times with exponential backoff
  - Alert on job failure after retries exhausted (Sentry notification)
  - Fallback to previous sitemap if generation fails

- **Partial Failure Tolerance:**
  - If a single sitemap chunk fails, other chunks should still be generated
  - Log errors but continue processing remaining content types

**RSS Feed Availability:**

- **Cache Fallback:**
  - If database query fails, serve stale cached RSS feed
  - Display "last updated" timestamp in RSS to indicate freshness

- **Rate Limiting:**
  - Prevent RSS feed abuse with rate limiting: 60 requests/minute per IP
  - Return 429 status code when rate limit exceeded

**Search Engine API Reliability:**

- **Graceful Degradation:**
  - If Google Search Console API fails, log error but don't block sitemap generation
  - Sitemap should still be generated and served even if submission fails

- **Timeout Handling:**
  - Set 10-second timeout for external API calls
  - Use circuit breaker pattern to prevent cascading failures

**Meta Tag Fallbacks:**

- **Default Values:**
  - If article description is blank, use first 160 characters of body
  - If article image is missing, use default OG image from config
  - If author name is blank, use "Vibecoding Community" as fallback

**Monitoring Thresholds:**

- **Sitemap Freshness:** Alert if sitemap not updated in > 48 hours
- **RSS Feed Errors:** Alert if RSS feed returns 500 errors > 5 times/hour
- **Meta Tag Validation:** Alert if Schema.org validation fails > 10 times/day

### Observability

**SEO Performance Metrics:**

- **Google Search Console Integration:**
  - Track search impressions, clicks, CTR, average position
  - Monitor crawl errors and indexing status
  - Alert on sudden drops in indexed pages

- **Meta Tag Validation Logging:**
  - Log Schema.org validation results (pass/fail) for each post
  - Track meta tag completeness (e.g., % of posts with custom descriptions)
  - Monitor character limit violations (title > 60 chars, description > 160 chars)

**Sitemap Monitoring:**

- **Generation Metrics:**
  - Track sitemap generation duration (should be < 5 minutes)
  - Count URLs in each sitemap chunk
  - Monitor sitemap file sizes

- **Submission Tracking:**
  - Log successful/failed submissions to Google/Bing
  - Track time between sitemap generation and submission
  - Alert on submission API errors

**Social Sharing Analytics:**

- **GA4 Custom Events:**
  - `social_share` event with dimensions: platform, content_id, user_id
  - Track share button clicks vs actual shares (when possible)
  - Monitor share conversion rate by platform

- **UTM Parameter Tracking:**
  - Validate UTM parameters are present on all social shares
  - Track inbound traffic from social shares in GA4

**RSS Feed Metrics:**

- **Feed Usage:**
  - Track RSS feed requests per hour/day
  - Monitor feed subscriber count (if using FeedBurner or similar)
  - Track which tag feeds are most popular

- **Feed Performance:**
  - Monitor RSS feed response times (p50, p95, p99)
  - Track cache hit/miss ratio
  - Alert on RSS feed errors or slow responses

**Application Logging:**

```ruby
# Structured logging for SEO operations
Rails.logger.info(
  "VIBECODING: SEO optimization completed",
  article_id: article.id,
  slug: article.slug,
  meta_tags_generated: meta_tags.keys,
  schema_valid: schema_validator.valid?,
  duration_ms: elapsed_time
)

Rails.logger.info(
  "VIBECODING: Sitemap generated",
  total_urls: sitemap.total_urls,
  chunks: sitemap.chunks.count,
  duration_ms: elapsed_time,
  submitted_to: ["google", "bing"]
)

Rails.logger.info(
  "VIBECODING: Social share tracked",
  platform: platform,
  article_id: article.id,
  user_id: current_user&.id,
  utm_params: utm_params
)
```

**Alerting Rules:**

- **Critical:**
  - Sitemap generation failure after 3 retries
  - Schema.org validation failure rate > 5%
  - Meta tag generation error rate > 1%

- **Warning:**
  - RSS feed cache hit ratio < 80%
  - Social share tracking error rate > 0.1%
  - Sitemap generation duration > 10 minutes

## Dependencies and Integrations

### Ruby Gem Dependencies

**Existing Forem Dependencies (Leveraged):**

- **Rails 7.0.8.4** - Core framework, provides server-side rendering and URL routing
- **metainspector ~> 5.12** - Parse website metadata for Open Graph objects (already included)
- **nokogiri ~> 1.13** - HTML/XML parsing for meta tag generation and RSS feeds
- **jbuilder ~> 2.11** - JSON structure generation (can be used for Schema.org JSON-LD)
- **kaminari ~> 1.2** - Pagination for sitemap generation
- **redis ~> 4.7.1** - Caching for RSS feeds and meta tags
- **rack-attack ~> 6.7.0** - Rate limiting for RSS feed endpoints

**Potential New Dependencies (If Needed):**

- **sitemap_generator ~> 6.3** - Automated sitemap generation (if Forem's built-in is insufficient)
  - Purpose: Generate XML sitemaps with customizable priority and changefreq
  - Alternative: Build custom sitemap generator using Nokogiri

- **meta-tags ~> 2.18** - Meta tag helper (if enhanced functionality needed)
  - Purpose: Simplified meta tag generation with OpenGraph and Twitter Card support
  - Alternative: Use custom helpers in `lib/vibecoding/seo_optimizer.rb`

### JavaScript/Node Dependencies

**Existing Dependencies (Leveraged):**

- **Preact 10.20.2** - Frontend framework for social share button components
- **esbuild** - Fast JavaScript bundling for social share tracking modules

**No New JavaScript Dependencies Required**

All social sharing functionality can be implemented with vanilla JavaScript and Preact components.

### External Service Integrations

**1. Google Search Console**
- **Purpose:** Sitemap submission, search analytics, crawl error monitoring
- **Authentication:** OAuth 2.0 service account
- **API:** Google Search Console API v3
- **Credentials Storage:** Rails encrypted credentials
- **Rate Limits:** 1,200 queries/minute
- **Cost:** Free
- **Setup Required:**
  - Create Google Cloud project
  - Enable Search Console API
  - Create service account with domain verification
  - Store credentials in `config/credentials.yml.enc`

**2. Bing Webmaster Tools**
- **Purpose:** Sitemap submission to Bing search engine
- **Authentication:** API key
- **API:** Bing Webmaster Tools API
- **Credentials Storage:** Rails encrypted credentials
- **Rate Limits:** 10,000 URLs/day
- **Cost:** Free
- **Setup Required:**
  - Register site with Bing Webmaster Tools
  - Generate API key
  - Store in `config/credentials.yml.enc`

**3. Cloudflare CDN** (from Epic 1)
- **Purpose:** Cache and serve sitemap.xml, static assets for social share buttons
- **Integration:** DNS/proxy configuration
- **Caching:** 1-hour TTL for sitemap.xml
- **Cost:** Free tier sufficient
- **Already Configured:** Yes (Epic 1 dependency)

**4. Google Analytics 4** (from Epic 5)
- **Purpose:** Track social share events, UTM parameters
- **Integration:** gtag.js or Google Tag Manager
- **Events Tracked:**
  - `social_share` - Share button clicks
  - `outbound_click` - Links to shared content
- **Cost:** Free
- **Dependency:** Epic 5, Story 5.1 (can be implemented in parallel)

**5. Schema.org Validator** (Development Tool)
- **Purpose:** Validate JSON-LD structured data
- **URL:** https://validator.schema.org/
- **Usage:** Manual validation during development and testing
- **Cost:** Free
- **Integration:** Manual testing, not runtime dependency

**6. Social Platform APIs** (Read-only)

- **Twitter Card Validator**
  - URL: https://cards-dev.twitter.com/validator
  - Purpose: Validate Twitter Card meta tags
  - Usage: Manual testing

- **Facebook Sharing Debugger**
  - URL: https://developers.facebook.com/tools/debug/
  - Purpose: Validate Open Graph tags, clear cache
  - Usage: Manual testing and cache clearing

- **LinkedIn Post Inspector**
  - URL: https://www.linkedin.com/post-inspector/
  - Purpose: Validate social preview for LinkedIn
  - Usage: Manual testing

### Internal Forem Dependencies

**Existing Forem Features (Must Not Break):**

- **Article Model:**
  - Fields used: `title`, `slug`, `description`, `body_markdown`, `canonical_url`, `main_image`, `published_at`
  - Must not modify core model behavior
  - May add concerns for SEO functionality

- **Slug Generation:**
  - Forem uses FriendlyId or similar for slug generation
  - Must extend, not replace, existing slug logic
  - 301 redirects may require custom middleware or Forem's redirect system

- **RSS Feeds:**
  - Forem has built-in RSS at `/feed`, `/feed.xml`
  - May need to extend controllers or views for customization
  - Must maintain backward compatibility

- **Caching System:**
  - Forem uses Redis for caching
  - Fragment caching available via Rails
  - Must use consistent cache keys and invalidation

- **Admin Panel:**
  - Configuration for SEO settings may be added to admin panel
  - Use Forem's existing admin authorization (Pundit policies)

### Database Dependencies

**No Schema Changes Required**

All functionality can be implemented using existing Forem schema:
- Articles table (posts)
- Users table (authors)
- Tags table (taxonomy)

**Optional Enhancement (Post-MVP):**
- `redirects` table for tracking 301 redirects (if not already present in Forem)
  ```sql
  CREATE TABLE redirects (
    id BIGSERIAL PRIMARY KEY,
    from_path VARCHAR(255) NOT NULL,
    to_path VARCHAR(255) NOT NULL,
    status_code INTEGER DEFAULT 301,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL
  );
  CREATE UNIQUE INDEX idx_redirects_from_path ON redirects(from_path);
  ```

### Dependency Constraints

**Version Compatibility:**

- Ruby 3.3.0 (Forem requirement)
- Rails 7.0.8.4 (Forem current version)
- PostgreSQL 14+ (Forem requirement)
- Redis 4.7.1+ (Forem requirement)
- Node.js 20.x (Forem requirement)

**Breaking Change Risks:**

- **Forem Upgrades:** Custom SEO code must be isolated to prevent conflicts during Forem version upgrades
- **API Changes:** Google Search Console API changes may require code updates
- **Schema.org Updates:** New schema versions may require JSON-LD updates

**Mitigation Strategy:**

- Namespace all custom code under `vibecoding/` or `custom/`
- Use Forem extension points (concerns, decorators) rather than monkey patches
- Pin external API gem versions with pessimistic version constraints
- Document all customizations in `docs/customization-guide.md`

### Integration Testing Dependencies

**Testing Tools:**

- **RSpec** (existing) - Unit and integration tests for SEO services
- **VCR** (existing in Forem) - Record HTTP interactions for Google/Bing API tests
- **Webmock** (existing in Forem) - Stub HTTP requests in tests
- **Capybara** (existing) - Feature tests for social share buttons
- **Cypress** (existing) - E2E tests for social sharing workflows

**Validation Tools:**

- Schema.org Validator (https://validator.schema.org/)
- W3C Feed Validator (https://validator.w3.org/feed/)
- Google Rich Results Test (https://search.google.com/test/rich-results)
- Lighthouse CI (for SEO audit automation)

## Acceptance Criteria (Authoritative)

### Story 3.1: SEO Meta Tags & Structured Data

**AC-3.1.1: Meta Tag Generation**
- GIVEN an article is published
- WHEN the article page is rendered
- THEN the HTML head contains:
  - `<title>` tag with format "{Article Title} | Vibecoding Community" (< 60 chars)
  - `<meta name="description">` with article description or first 160 chars of body
  - `<link rel="canonical">` pointing to the article's canonical URL
  - `<meta name="robots">` appropriate for content status (index/noindex)

**AC-3.1.2: Open Graph Tags**
- GIVEN an article with title, description, and image
- WHEN the page meta tags are generated
- THEN Open Graph tags include:
  - `og:title` - Article title
  - `og:description` - Article description or excerpt
  - `og:image` - Article main_image or default vibecoding OG image
  - `og:url` - Canonical URL
  - `og:type` - "article"
  - `og:site_name` - "Vibecoding Community"
  - `article:published_time`, `article:author`, `article:tag`

**AC-3.1.3: Twitter Card Tags**
- GIVEN an article is published
- WHEN Twitter Card meta tags are generated
- THEN the following tags are present:
  - `twitter:card` - "summary_large_image"
  - `twitter:site` - "@vibecoding" (site Twitter handle)
  - `twitter:title` - Article title
  - `twitter:description` - Article description
  - `twitter:image` - Article image or default
  - `twitter:creator` - Author's Twitter handle (if available)

**AC-3.1.4: Schema.org Article Markup**
- GIVEN an article is published
- WHEN Schema.org JSON-LD is generated
- THEN a valid Article schema is embedded with:
  - `@type: "Article"`
  - `headline`, `description`, `author`, `datePublished`, `dateModified`
  - `image`, `publisher` (Organization schema)
  - `mainEntityOfPage` (WebPage schema)
- AND the JSON-LD validates successfully at https://validator.schema.org/

**AC-3.1.5: Meta Tag Validation**
- GIVEN meta tags are generated for any content
- WHEN tags are validated
- THEN:
  - Title length ≤ 60 characters
  - Description length ≤ 160 characters
  - All URLs are properly formatted and use HTTPS
  - Images use absolute URLs
  - No HTML entities in meta content (properly escaped)

### Story 3.2: Sitemap Generation & Search Engine Indexing

**AC-3.2.1: Automated Sitemap Generation**
- GIVEN the platform has published content
- WHEN the sitemap generation job runs
- THEN a valid XML sitemap is generated at `/sitemap.xml` containing:
  - All published articles with URL, lastmod, priority (0.8), changefreq (daily)
  - All active tag pages with priority (0.6), changefreq (weekly)
  - All user profiles with published content, priority (0.4), changefreq (weekly)
  - All static pages (About, Guidelines) with priority (0.9), changefreq (monthly)
- AND the sitemap validates against XML sitemap schema

**AC-3.2.2: Sitemap Index for Scale**
- GIVEN the platform has > 10,000 URLs
- WHEN the sitemap is generated
- THEN a sitemap index is created at `/sitemap.xml` linking to:
  - `/sitemap-posts.xml.gz` (articles)
  - `/sitemap-users.xml.gz` (user profiles)
  - `/sitemap-tags.xml.gz` (tag pages)
  - `/sitemap-pages.xml.gz` (static pages)
- AND each sitemap chunk contains ≤ 50,000 URLs

**AC-3.2.3: robots.txt Configuration**
- GIVEN the platform is deployed
- WHEN `/robots.txt` is accessed
- THEN it contains:
  - `User-agent: *`
  - `Allow: /` (allow all public content)
  - `Disallow: /admin` (block admin pages)
  - `Disallow: /settings` (block user settings)
  - `Sitemap: https://vibecoding.com/sitemap.xml`

**AC-3.2.4: Google Search Console Integration**
- GIVEN Google Search Console is configured
- WHEN the sitemap is generated
- THEN the sitemap is automatically submitted to Google Search Console API
- AND submission success/failure is logged
- AND sitemap appears in Search Console within 24 hours

**AC-3.2.5: Bing Webmaster Tools Integration**
- GIVEN Bing Webmaster Tools is configured
- WHEN the sitemap is generated
- THEN the sitemap URL is submitted to Bing Webmaster Tools API
- AND submission success/failure is logged

### Story 3.3: Social Sharing Optimization

**AC-3.3.1: Social Share Buttons**
- GIVEN an article is displayed
- WHEN the page is rendered
- THEN social share buttons are visible for:
  - Twitter
  - LinkedIn
  - Facebook
  - Copy Link
- AND buttons are positioned below the article title or at the end of content

**AC-3.3.2: Share URL Generation with UTM Tracking**
- GIVEN a user clicks a share button
- WHEN the share URL is generated
- THEN it includes UTM parameters:
  - `utm_source=social`
  - `utm_medium={platform}` (twitter, linkedin, facebook)
  - `utm_campaign=organic-share`
- AND the URL is properly encoded

**AC-3.3.3: Social Share Event Tracking**
- GIVEN a user clicks a social share button
- WHEN the click event fires
- THEN a GA4 event is tracked with:
  - Event name: `social_share`
  - Parameters: `platform`, `content_id` (article ID), `user_id` (if logged in)
- AND the event appears in GA4 real-time reports

**AC-3.3.4: Auto-Generated Social Images**
- GIVEN an article without a custom cover image
- WHEN social preview is generated
- THEN a default social image is used with:
  - Vibecoding Community branding
  - Article title overlaid
  - Dimensions: 1200x630px (Open Graph), 1200x600px (Twitter)
  - Format: PNG or JPEG

**AC-3.3.5: Social Preview Validation**
- GIVEN an article is published
- WHEN previews are tested
- THEN:
  - Twitter Card Validator shows correct preview
  - Facebook Sharing Debugger shows correct preview
  - LinkedIn Post Inspector shows correct preview
  - Preview image loads within 3 seconds

### Story 3.4: Content URL Structure & Internal Linking

**AC-3.4.1: Clean Slug-Based URLs**
- GIVEN an article is created
- WHEN the article is published
- THEN the URL follows the pattern: `/{slug}`
- WHERE slug:
  - Is auto-generated from the article title
  - Contains only lowercase letters, numbers, and hyphens
  - Has no stop words (a, the, is, etc.)
  - Is ≤ 100 characters
  - Is unique across all articles

**AC-3.4.2: Slug Editability**
- GIVEN an article exists
- WHEN an author edits the article
- THEN the author can modify the slug before re-publishing
- AND the system validates slug uniqueness
- AND warns if changing an already-published slug

**AC-3.4.3: 301 Redirects for Changed Slugs**
- GIVEN an article slug is changed after publication
- WHEN a user visits the old URL
- THEN:
  - A 301 (permanent) redirect is returned
  - The user is redirected to the new URL
  - The redirect is logged for analytics
- AND old URLs continue to work indefinitely

**AC-3.4.4: Related Posts Internal Linking**
- GIVEN an article is displayed
- WHEN the article page is rendered
- THEN "Related Posts" section shows:
  - 3-5 articles with overlapping tags
  - Sorted by relevance (tag overlap) and recency
  - Links to related articles with proper anchor text
- AND the section appears at the end of the article

**AC-3.4.5: Tag Page Internal Linking**
- GIVEN a tag page (e.g., `/tags/vibecoding`)
- WHEN the page is rendered
- THEN it displays:
  - All articles tagged with that tag
  - Links to related tags (co-occurring tags)
  - Proper heading hierarchy (H1, H2) for SEO

### Story 3.5: RSS Feeds & Content Distribution

**AC-3.5.1: Global RSS Feed**
- GIVEN the platform has published articles
- WHEN `/feed.xml` is accessed
- THEN a valid RSS 2.0 feed is returned containing:
  - Last 50 published articles
  - Item elements with: title, link, description, pubDate, author, guid
  - Channel metadata: title, description, link, language
  - Full article content or excerpt (configurable)

**AC-3.5.2: Tag-Specific RSS Feeds**
- GIVEN a tag exists with published articles
- WHEN `/tags/{tag-name}/feed.xml` is accessed
- THEN a valid RSS feed is returned with:
  - Only articles tagged with {tag-name}
  - Last 50 articles for that tag
  - Channel title: "{Tag Name} | Vibecoding Community"

**AC-3.5.3: User-Specific RSS Feeds**
- GIVEN a user has published articles
- WHEN `/{username}/feed.xml` is accessed
- THEN a valid RSS feed is returned with:
  - Only articles authored by {username}
  - Last 50 articles by that user
  - Channel title: "{Username}'s Posts | Vibecoding Community"

**AC-3.5.4: RSS Autodiscovery Tags**
- GIVEN any page with an RSS feed
- WHEN the HTML head is rendered
- THEN autodiscovery link tags are present:
  - `<link rel="alternate" type="application/rss+xml" href="/feed.xml" />`
  - Tag and user pages include their specific feed URLs

**AC-3.5.5: RSS Feed Performance**
- GIVEN RSS feeds are requested
- WHEN feed response time is measured
- THEN:
  - 95th percentile response time < 200ms
  - Feeds are cached for 10 minutes in Rails cache
  - Cache hit ratio > 80%
  - Feeds validate at https://validator.w3.org/feed/

## Traceability Mapping

| AC ID | Requirement Source | Spec Section | Components/APIs | Test Idea |
|-------|-------------------|--------------|-----------------|-----------|
| **AC-3.1.1** | PRD § SEO Optimization (5.1) | Detailed Design → Meta Tag Partial | `_meta_tags.html.erb`, `SeoOptimizer` | Unit test: Verify meta tag generation for sample article |
| **AC-3.1.2** | PRD § Social Sharing (5.2) | APIs & Interfaces → Open Graph Contract | `SeoOptimizer#generate_meta_tags` | Integration test: Verify OG tags render on article page |
| **AC-3.1.3** | PRD § Social Sharing (5.2) | APIs & Interfaces → Twitter Card Contract | `SeoOptimizer#generate_meta_tags` | Validation test: Twitter Card Validator |
| **AC-3.1.4** | PRD § SEO Optimization (5.1) | APIs & Interfaces → Schema.org JSON-LD | `SeoOptimizer#generate_structured_data` | Validation test: Schema.org validator |
| **AC-3.1.5** | PRD § SEO Optimization (5.1) | Detailed Design → SeoOptimizer Service | `SeoOptimizer#validate_meta_tags` | Unit test: Character limits, URL format validation |
| **AC-3.2.1** | PRD § SEO Optimization (5.1) | Workflows → Sitemap Generation | `SitemapGeneratorJob`, `config/sitemap.rb` | Integration test: Generate sitemap, validate XML schema |
| **AC-3.2.2** | Architecture § Scalability | Workflows → Sitemap Generation | `SitemapGeneratorJob` | Load test: Generate sitemap with 60k URLs |
| **AC-3.2.3** | PRD § SEO Optimization (5.1) | Dependencies → Internal Forem | `public/robots.txt` | E2E test: Fetch robots.txt, verify content |
| **AC-3.2.4** | PRD § SEO Optimization (5.1) | APIs & Interfaces → Google Search Console API | `SitemapGeneratorJob`, Google API client | Integration test: Mock API submission, verify request |
| **AC-3.2.5** | PRD § SEO Optimization (5.1) | APIs & Interfaces → Bing Webmaster API | `SitemapGeneratorJob`, Bing API client | Integration test: Mock API submission |
| **AC-3.3.1** | PRD § Social Sharing (5.2) | Detailed Design → SocialShareButtons component | `SocialShareButtons.jsx` | Feature test: Verify share buttons render on article |
| **AC-3.3.2** | PRD § Conversion Tracking (4.3) | Workflows → Social Share Click | `social_share_tracker.js#generateSocialUrl` | Unit test: Verify UTM params in generated URL |
| **AC-3.3.3** | Epic 5 (Analytics) dependency | NFR → Observability → Social Sharing Analytics | `social_share_tracker.js#trackShareClick`, GA4 | Integration test: Verify GA4 event fired (mock gtag) |
| **AC-3.3.4** | PRD § Social Sharing (5.2) | Dependencies → Cloudinary | Cloudinary image generation or default OG image | Manual test: Verify social preview images |
| **AC-3.3.5** | PRD § Social Sharing (5.2) | - | Social platform validators | Manual validation: Twitter, Facebook, LinkedIn |
| **AC-3.4.1** | PRD § Content URL Structure (3.4) | Detailed Design → URL Security | Article model slug generation, FriendlyId | Unit test: Verify slug generation from title |
| **AC-3.4.2** | PRD § Post Editing (2.3) | Dependencies → Slug Generation | Article edit form, slug validation | Feature test: Edit slug, verify uniqueness check |
| **AC-3.4.3** | PRD § Content URL Structure (3.4) | Workflows → Slug Change Redirect | Redirect middleware, redirects table | Integration test: Change slug, verify 301 redirect |
| **AC-3.4.4** | PRD § Internal Linking (3.4) | Detailed Design → Related posts algorithm | Article view partial, related posts query | Feature test: Verify related posts appear |
| **AC-3.4.5** | PRD § Tag Pages (4.1) | Dependencies → Tag model | Tag show view | SEO audit: Verify heading hierarchy |
| **AC-3.5.1** | PRD § RSS Feeds (5.3) | Workflows → RSS Feed Request | `FeedsController#index` | Integration test: Fetch feed, validate RSS 2.0 |
| **AC-3.5.2** | PRD § RSS Feeds (5.3) | Detailed Design → RSS Feed Controllers | `FeedsController` tag-specific action | Integration test: Fetch tag feed, verify filtering |
| **AC-3.5.3** | PRD § RSS Feeds (5.3) | Detailed Design → RSS Feed Controllers | `FeedsController` user-specific action | Integration test: Fetch user feed, verify filtering |
| **AC-3.5.4** | PRD § RSS Feeds (5.3) | Detailed Design → Meta Tag Partial | `_meta_tags.html.erb` autodiscovery links | Feature test: Verify autodiscovery link in head |
| **AC-3.5.5** | NFR § Performance → RSS Feed | NFR → Performance → RSS Feed Response Time | Rails cache, FeedsController | Performance test: Measure p95 response time |

## Risks, Assumptions, Open Questions

### Risks

**R-3.1: Forem Core Conflicts During Upgrades**
- **Risk:** Custom SEO code may conflict with Forem core updates, breaking functionality during version upgrades
- **Probability:** Medium
- **Impact:** High (could break SEO features entirely)
- **Mitigation:**
  - Namespace all custom code under `vibecoding/` or `custom/`
  - Use Forem extension points (concerns, decorators) rather than monkey patches
  - Document all customizations in `docs/customization-guide.md`
  - Test against Forem release candidates before upgrading production
  - Maintain automated test suite to catch regressions

**R-3.2: Google Search Console API Changes**
- **Risk:** Google may deprecate or change Search Console API, breaking sitemap submission
- **Probability:** Low (stable API)
- **Impact:** Medium (manual submission still works)
- **Mitigation:**
  - Monitor Google API deprecation announcements
  - Implement graceful degradation (sitemap still generated if API fails)
  - Log API failures and alert on errors
  - Manual submission fallback documented

**R-3.3: Social Platform Meta Tag Requirements Change**
- **Risk:** Twitter, Facebook, LinkedIn may change meta tag requirements or preview rendering
- **Probability:** Medium (platforms evolve frequently)
- **Impact:** Low (previews degrade, but links still work)
- **Mitigation:**
  - Monitor platform developer blogs for changes
  - Use validators regularly to catch breaking changes
  - Implement flexible meta tag generation (easy to update)
  - Test previews manually during QA

**R-3.4: Schema.org Validation Failures**
- **Risk:** Schema.org standards may evolve, causing existing JSON-LD to fail validation
- **Probability:** Low (backward compatible)
- **Impact:** Low (Google still indexes, just no rich results)
- **Mitigation:**
  - Implement automated Schema.org validation in CI/CD
  - Monitor Google Rich Results Test for errors
  - Keep JSON-LD generation modular for easy updates

**R-3.5: Sitemap Generation Performance Degradation at Scale**
- **Risk:** As content grows beyond 50k URLs, sitemap generation may exceed 5-minute target
- **Probability:** Medium (at scale)
- **Impact:** Medium (stale sitemaps affect SEO)
- **Mitigation:**
  - Implement incremental sitemap updates (only changed content)
  - Use background jobs with sufficient worker capacity
  - Monitor generation duration and alert on regressions
  - Optimize database queries (indexes, eager loading)

**R-3.6: CDN Caching Issues for Sitemap**
- **Risk:** Cloudflare may cache stale sitemap.xml, serving outdated content to search engines
- **Probability:** Low (with proper cache headers)
- **Impact:** Medium (delayed indexing of new content)
- **Mitigation:**
  - Set appropriate cache TTL (1 hour)
  - Implement cache purge on sitemap regeneration
  - Monitor sitemap freshness via Google Search Console

### Assumptions

**A-3.1: Forem SEO Features Are Sufficient Base**
- **Assumption:** Forem's built-in SEO features (meta tags, RSS feeds) provide a solid foundation requiring only minor customization
- **Validation:** Review Forem documentation and existing meta tag implementation
- **Impact if False:** May need more extensive custom implementation, increasing development time

**A-3.2: Google Search Console Service Account Access**
- **Assumption:** We can create a Google Cloud service account with Search Console API access for automated sitemap submission
- **Validation:** Test service account creation and domain verification in development
- **Impact if False:** Must use manual sitemap submission, losing automation benefit

**A-3.3: No Database Schema Changes Required**
- **Assumption:** All SEO functionality can be implemented using existing Forem schema
- **Validation:** Confirmed via architecture analysis of Forem Article, User, Tag models
- **Impact if False:** Would require migrations, increasing complexity and testing burden

**A-3.4: Social Share Tracking via GA4 is Sufficient**
- **Assumption:** GA4 event tracking provides adequate visibility into social share behavior without dedicated social analytics platform
- **Validation:** Test GA4 event tracking in development, review reports
- **Impact if False:** May need additional social analytics tool (e.g., AddThis, ShareThis)

**A-3.5: Default OG Images Are Acceptable**
- **Assumption:** Auto-generated or default social preview images are acceptable for posts without custom images
- **Validation:** Design default OG image template, test with stakeholders
- **Impact if False:** May need to implement dynamic image generation (e.g., using Cloudinary or imgix)

**A-3.6: RSS Feeds Don't Require Advanced Features**
- **Assumption:** Basic RSS 2.0 feeds are sufficient; no need for Atom, JSON Feed, or podcast-specific features
- **Validation:** Confirm with stakeholders and review competitor RSS implementations
- **Impact if False:** Additional development for alternative feed formats

### Open Questions

**Q-3.1: Should We Implement Automatic Social Image Generation?**
- **Question:** Should posts without custom images automatically generate social preview images with overlaid titles?
- **Options:**
  1. Use static default OG image for all posts (simple, low cost)
  2. Generate dynamic images with title overlay (better engagement, requires image processing)
  3. Prompt authors to upload custom images (highest quality, manual effort)
- **Decision Needed By:** Story 3.3 implementation
- **Impact:** Affects social share CTR and development complexity

**Q-3.2: What Should Be the Sitemap Update Frequency?**
- **Question:** How often should sitemaps be regenerated?
- **Options:**
  1. On every post publish (real-time, high resource usage)
  2. Hourly scheduled job (near real-time, moderate resources)
  3. Daily scheduled job (simple, delayed indexing)
  4. Incremental updates + full regeneration daily (optimal, complex)
- **Decision Needed By:** Story 3.2 implementation
- **Impact:** Affects indexing speed vs. infrastructure cost

**Q-3.3: Should We Track Internal Link Clicks for SEO Insights?**
- **Question:** Should we track clicks on related posts and internal links to measure SEO effectiveness?
- **Options:**
  1. Yes, track all internal link clicks via GA4 (full visibility, more events)
  2. No, rely on Google Search Console for click data (simpler, less granular)
- **Decision Needed By:** Story 3.4 implementation
- **Impact:** Affects analytics complexity and data volume

**Q-3.4: RSS Feed Content: Full or Excerpt?**
- **Question:** Should RSS feeds include full article content or excerpts?
- **Options:**
  1. Full content (better for subscribers, risk of content scraping)
  2. Excerpts only (drives traffic to site, worse subscriber experience)
  3. Configurable per feed (flexible, more complex)
- **Decision Needed By:** Story 3.5 implementation
- **Impact:** Affects user experience and potential content theft

**Q-3.5: Should We Support AMP for Mobile SEO?**
- **Question:** Should we implement AMP (Accelerated Mobile Pages) for better mobile search rankings?
- **Options:**
  1. Yes, implement AMP (potential SEO boost, significant development)
  2. No, focus on Core Web Vitals instead (simpler, still good mobile SEO)
- **Decision Needed By:** Pre-Epic 3 (affects architecture)
- **Impact:** Major development effort if yes; AMP is less critical now with Core Web Vitals focus

**Q-3.6: Do We Need Multi-Language SEO Support (i18n)?**
- **Question:** Should Epic 3 include multi-language SEO support (hreflang tags, localized sitemaps)?
- **Options:**
  1. Yes, include in Epic 3 (future-proof, more complex)
  2. No, defer to post-MVP (simpler, can add later)
- **Decision Needed By:** Epic 3 planning
- **Impact:** Explicitly out of scope per requirements, but confirming decision

## Test Strategy Summary

### Testing Approach

Epic 3 requires a multi-layered testing strategy combining automated unit/integration tests, manual validation with external tools, and SEO performance monitoring.

### Test Levels

**1. Unit Tests (RSpec)**

Target: Individual services, helpers, and model concerns

Coverage:
- `Vibecoding::SeoOptimizer` service methods
  - `#generate_meta_tags` - Verify correct tag generation for various content types
  - `#generate_structured_data` - Verify valid Schema.org JSON-LD output
  - `#validate_meta_tags` - Test character limits, URL format validation
- `SocialShareTracking` JavaScript module
  - `generateSocialUrl()` - Verify UTM parameter generation
  - `trackShareClick()` - Verify GA4 event structure (with mocks)
- Slug generation and validation logic
  - Verify slug format (lowercase, hyphens, no special chars)
  - Test uniqueness validation

**Test Framework:** RSpec for Ruby, Jest for JavaScript
**Target Coverage:** 90%+ for custom SEO code

**2. Integration Tests (RSpec + Capybara)**

Target: Multi-component workflows and API interactions

Coverage:
- Meta tag rendering on article pages
  - Verify all required tags present in HTML head
  - Test fallback values (default OG image, auto-generated descriptions)
- Sitemap generation job
  - Generate sitemap with sample data
  - Validate XML structure and content
  - Test chunking for large datasets (mock 60k URLs)
- Search engine API submissions (mocked)
  - Google Search Console API call structure
  - Bing Webmaster Tools API call structure
  - Error handling and retries
- RSS feed generation
  - Global, tag-specific, user-specific feeds
  - Validate RSS 2.0 XML structure
  - Test caching behavior

**Test Framework:** RSpec with VCR for API mocking
**Mock External Services:** Google/Bing APIs (record/replay with VCR)

**3. Feature Tests (Capybara/Cypress)**

Target: End-to-end user workflows

Coverage:
- Social share button interactions
  - Click share button → verify URL generated with UTM params
  - Verify GA4 event fired (mock gtag.js)
- Article slug editing
  - Edit slug → verify uniqueness validation
  - Change published slug → verify warning shown
- Related posts display
  - Verify related posts appear on article page
  - Test sorting by tag overlap
- RSS autodiscovery
  - Verify feed link tags in HTML head

**Test Framework:** Cypress for critical E2E flows
**Browser Coverage:** Chrome, Firefox (latest versions)

**4. Manual Validation Tests**

Target: External platform compatibility

Required Manual Checks:
- **Schema.org Validator** (https://validator.schema.org/)
  - Paste article URL, verify Article schema validates
  - Check for warnings or errors
- **Twitter Card Validator** (https://cards-dev.twitter.com/validator)
  - Test article URL, verify preview renders correctly
  - Check image dimensions and text truncation
- **Facebook Sharing Debugger** (https://developers.facebook.com/tools/debug/)
  - Test article URL, verify OG tags
  - Use "Scrape Again" to clear cache
- **LinkedIn Post Inspector** (https://www.linkedin.com/post-inspector/)
  - Test article URL, verify preview
- **W3C Feed Validator** (https://validator.w3.org/feed/)
  - Validate /feed.xml, tag feeds, user feeds
- **Google Rich Results Test** (https://search.google.com/test/rich-results)
  - Test article URLs for rich result eligibility

**Frequency:** Run during development and before release

**5. Performance Tests**

Target: NFR validation

Coverage:
- **Meta Tag Generation Performance:**
  - Measure overhead per request (target: < 50ms)
  - Test with caching enabled
- **Sitemap Generation Performance:**
  - Generate sitemap with 10k, 50k, 100k URLs
  - Measure duration (target: < 5 minutes for 50k)
- **RSS Feed Response Time:**
  - Load test with 100 concurrent requests
  - Measure p95 response time (target: < 200ms)
  - Verify cache hit ratio > 80%

**Test Framework:** k6 or Apache JMeter
**Test Environment:** Staging (production-like)

**6. SEO Audit Tests (Lighthouse CI)**

Target: SEO best practices and Core Web Vitals

Coverage:
- Run Lighthouse SEO audit on key pages (homepage, article, tag page)
- Verify SEO score > 90
- Check Core Web Vitals (LCP < 2.5s, FID < 100ms, CLS < 0.1)
- Validate meta tags, heading hierarchy, canonical URLs
- Check for broken links, missing alt text

**Test Framework:** Lighthouse CI in GitHub Actions
**Frequency:** On every PR to main branch

### Test Data Requirements

- **Sample Articles:** 100+ articles with varying content (with/without images, descriptions)
- **Sample Tags:** 20+ tags with co-occurring relationships
- **Sample Users:** 10+ users with varying post counts
- **Edge Cases:** Articles with very long titles, special characters, missing descriptions

### Continuous Integration

**Pre-Merge Checks (GitHub Actions):**
1. Run all unit tests (RSpec + Jest)
2. Run integration tests (RSpec with VCR)
3. Run Lighthouse CI SEO audit
4. Check code coverage (> 85% required)

**Post-Merge (Staging Deploy):**
1. Run E2E tests (Cypress)
2. Run performance tests (k6)
3. Manual validation checklist (before production deploy)

### Acceptance Testing

**Definition of Done for Epic 3:**
- All automated tests passing (unit, integration, E2E)
- All 25 acceptance criteria validated
- Manual validation complete (Schema.org, Twitter, Facebook, LinkedIn validators)
- Lighthouse SEO score > 90 on all page types
- Performance targets met (LCP < 2.5s, RSS < 200ms p95, sitemap < 5 min)
- No critical or high-severity security vulnerabilities (Brakeman scan)
- Documentation updated (customization guide, architecture docs)

### Regression Testing

**Ongoing Monitoring (Post-Deploy):**
- Daily: Check Google Search Console for crawl errors
- Weekly: Validate Schema.org markup on new posts
- Monthly: Run full Lighthouse audit on production
- Continuous: Monitor sitemap generation success rate, RSS feed errors (via Sentry)
