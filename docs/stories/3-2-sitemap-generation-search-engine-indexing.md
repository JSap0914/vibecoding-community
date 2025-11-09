# Story 3.2: Sitemap Generation & Search Engine Indexing

Status: drafted

## Story

As an **SEO Specialist**,
I want automated XML sitemaps and optimized robots.txt,
So that search engines efficiently crawl and index all community content.

## Acceptance Criteria

### Automated Sitemap Generation
1. **AC-3.2.1**: Valid XML sitemap is generated at `/sitemap.xml` containing:
   - All published articles with URL, lastmod, priority (0.8), changefreq (daily)
   - All active tag pages with priority (0.6), changefreq (weekly)
   - All user profiles with published content, priority (0.4), changefreq (weekly)
   - All static pages (About, Guidelines) with priority (0.9), changefreq (monthly)
   - Sitemap validates against XML sitemap schema

### Sitemap Index for Scale
2. **AC-3.2.2**: When platform has > 10,000 URLs, sitemap index is created at `/sitemap.xml` linking to:
   - `/sitemap-posts.xml.gz` (articles)
   - `/sitemap-users.xml.gz` (user profiles)
   - `/sitemap-tags.xml.gz` (tag pages)
   - `/sitemap-pages.xml.gz` (static pages)
   - Each sitemap chunk contains ≤ 50,000 URLs

### robots.txt Configuration
3. **AC-3.2.3**: `/robots.txt` is accessible and contains:
   - `User-agent: *`
   - `Allow: /` (allow all public content)
   - `Disallow: /admin` (block admin pages)
   - `Disallow: /settings` (block user settings)
   - `Sitemap: https://vibecoding.com/sitemap.xml`

### Google Search Console Integration
4. **AC-3.2.4**: Sitemap is automatically submitted to Google Search Console:
   - Sitemap submitted via Google Search Console API when generated
   - Submission success/failure is logged
   - Sitemap appears in Search Console within 24 hours

### Bing Webmaster Tools Integration
5. **AC-3.2.5**: Sitemap URL is submitted to Bing Webmaster Tools:
   - Sitemap submitted via Bing Webmaster Tools API
   - Submission success/failure is logged

## Tasks / Subtasks

- [ ] Task 1: Configure Sitemap Generation (AC: #1, #2)
  - [ ] 1.1: Check if Forem has built-in sitemap generation (verify existing implementation)
  - [ ] 1.2: Create or update `config/sitemap.rb` configuration file
  - [ ] 1.3: Configure sitemap for published articles (priority 0.8, changefreq daily)
  - [ ] 1.4: Configure sitemap for tag pages (priority 0.6, changefreq weekly)
  - [ ] 1.5: Configure sitemap for user profiles with published content (priority 0.4, changefreq weekly)
  - [ ] 1.6: Configure sitemap for static pages (About, Guidelines) (priority 0.9, changefreq monthly)
  - [ ] 1.7: Set up sitemap index for > 10k URLs (chunking strategy)
  - [ ] 1.8: Configure gzip compression for sitemap files

- [ ] Task 2: Create Sitemap Generation Job (AC: #1, #2)
  - [ ] 2.1: Create `app/jobs/sitemap_generator_job.rb` background job
  - [ ] 2.2: Implement sitemap generation logic (query articles, tags, users, pages)
  - [ ] 2.3: Generate XML sitemap with proper structure (url, loc, lastmod, priority, changefreq)
  - [ ] 2.4: Implement sitemap chunking for > 50k URLs per file
  - [ ] 2.5: Generate sitemap index when multiple chunks exist
  - [ ] 2.6: Write sitemap files to `public/` directory or upload to CDN
  - [ ] 2.7: Set up scheduled job (daily at 2 AM UTC via cron or Sidekiq scheduler)
  - [ ] 2.8: Add error handling and retry logic (3 retries with exponential backoff)
  - [ ] 2.9: Log sitemap generation completion with metrics (total URLs, duration)

- [ ] Task 3: Optimize Database Queries (AC: #1)
  - [ ] 3.1: Add database indexes on `articles.published_at` if missing
  - [ ] 3.2: Add database indexes on `articles.slug` if missing
  - [ ] 3.3: Optimize query for published articles (avoid N+1 queries)
  - [ ] 3.4: Optimize query for active users (articles_count > 0)
  - [ ] 3.5: Optimize query for active tags (taggings_count > 0)
  - [ ] 3.6: Use pagination/batch processing for large datasets (process 1000 records at a time)
  - [ ] 3.7: Measure query performance (target: complete in < 5 minutes for 10k posts)

- [ ] Task 4: Configure robots.txt (AC: #3)
  - [ ] 4.1: Create or update `public/robots.txt` file
  - [ ] 4.2: Add `User-agent: *` directive
  - [ ] 4.3: Add `Allow: /` directive for public content
  - [ ] 4.4: Add `Disallow: /admin` to block admin pages
  - [ ] 4.5: Add `Disallow: /settings` to block user settings
  - [ ] 4.6: Add `Disallow: /connect` for OAuth callbacks (optional)
  - [ ] 4.7: Add `Sitemap: https://vibecoding.com/sitemap.xml` directive
  - [ ] 4.8: Test robots.txt accessibility via HTTP request

- [ ] Task 5: Google Search Console API Integration (AC: #4)
  - [ ] 5.1: Create Google Cloud project and enable Search Console API
  - [ ] 5.2: Create service account with domain verification
  - [ ] 5.3: Store service account credentials in Rails encrypted credentials
  - [ ] 5.4: Install Google API client gem (if not already present)
  - [ ] 5.5: Create `lib/vibecoding/search_console_client.rb` wrapper service
  - [ ] 5.6: Implement sitemap submission via Search Console API
  - [ ] 5.7: Add API error handling (retry with exponential backoff, log failures)
  - [ ] 5.8: Call submission API from `SitemapGeneratorJob` after sitemap is generated
  - [ ] 5.9: Log submission success/failure with timestamps

- [ ] Task 6: Bing Webmaster Tools API Integration (AC: #5)
  - [ ] 6.1: Register site with Bing Webmaster Tools
  - [ ] 6.2: Generate Bing Webmaster Tools API key
  - [ ] 6.3: Store API key in Rails encrypted credentials
  - [ ] 6.4: Create `lib/vibecoding/bing_webmaster_client.rb` wrapper service
  - [ ] 6.5: Implement sitemap submission via Bing API
  - [ ] 6.6: Add API error handling (retry logic, log failures)
  - [ ] 6.7: Call submission API from `SitemapGeneratorJob` after sitemap is generated
  - [ ] 6.8: Log submission success/failure with timestamps

- [ ] Task 7: CDN Integration for Sitemap (AC: #1, #2)
  - [ ] 7.1: Configure Cloudflare CDN caching for sitemap.xml (1-hour TTL)
  - [ ] 7.2: Set up cache purge on sitemap regeneration
  - [ ] 7.3: Test sitemap accessibility via CDN URL
  - [ ] 7.4: Monitor sitemap freshness (alert if not updated in > 48 hours)

- [ ] Task 8: Post-Publication Sitemap Update Trigger (AC: #1)
  - [ ] 8.1: Add after_save callback to Article model to trigger sitemap update
  - [ ] 8.2: Enqueue `SitemapGeneratorJob` when article is published
  - [ ] 8.3: Implement incremental sitemap update (optional - update only changed content)
  - [ ] 8.4: Add debouncing to prevent excessive sitemap regeneration (max once per hour)

- [ ] Task 9: Testing and Validation (All ACs)
  - [ ] 9.1: Unit test `SitemapGeneratorJob` sitemap generation logic
  - [ ] 9.2: Test sitemap XML structure validation
  - [ ] 9.3: Test sitemap chunking for > 50k URLs (mock data)
  - [ ] 9.4: Integration test sitemap endpoint (`GET /sitemap.xml`)
  - [ ] 9.5: Test robots.txt endpoint (`GET /robots.txt`)
  - [ ] 9.6: Test Google Search Console API submission (with VCR fixtures)
  - [ ] 9.7: Test Bing Webmaster API submission (with VCR fixtures)
  - [ ] 9.8: Validate sitemap XML with W3C validator or sitemap validator tool
  - [ ] 9.9: Manual test: Submit sitemap to Google Search Console manually
  - [ ] 9.10: Manual test: Submit sitemap to Bing Webmaster Tools manually
  - [ ] 9.11: Verify sitemap appears in Google Search Console within 24 hours

- [ ] Task 10: Performance Testing (NFR)
  - [ ] 10.1: Load test sitemap generation with 10k, 50k, 100k URLs
  - [ ] 10.2: Measure sitemap generation duration (target: < 5 minutes for 50k URLs)
  - [ ] 10.3: Test database query performance under load
  - [ ] 10.4: Verify sitemap generation doesn't impact application performance
  - [ ] 10.5: Monitor memory usage during sitemap generation

- [ ] Task 11: Monitoring and Alerting (Post-Implementation)
  - [ ] 11.1: Add structured logging for sitemap generation (VIBECODING prefix)
  - [ ] 11.2: Log sitemap generation metrics (total URLs, chunks, duration)
  - [ ] 11.3: Log Google/Bing API submission results
  - [ ] 11.4: Set up alert for sitemap generation failures (after 3 retries)
  - [ ] 11.5: Set up alert for sitemap not updated in > 48 hours
  - [ ] 11.6: Monitor sitemap freshness via Google Search Console
  - [ ] 11.7: Document sitemap generation process in `docs/customization-guide.md`

## Dev Notes

### Architecture Patterns and Constraints

**Brownfield Customization Strategy (ADR-001):**
- Forem may have built-in sitemap generation - verify before implementing custom solution
- If Forem has sitemaps: customize `config/sitemap.rb` to add vibecoding-specific priorities
- If no built-in solution: use `sitemap_generator` gem (Rails standard)
- All customizations namespaced under `vibecoding/`

**Architecture Alignment:**
- **Service Object Pattern (Pattern 3):** Sitemap generation job in `app/jobs/sitemap_generator_job.rb`
- **External API Clients:** `lib/vibecoding/search_console_client.rb`, `lib/vibecoding/bing_webmaster_client.rb`
- **Configuration:** `config/sitemap.rb` for sitemap structure, encrypted credentials for API keys
- **Scheduled Jobs:** Use Sidekiq scheduler or cron for daily sitemap regeneration

**Sitemap Generation Workflow (from Tech Spec):**
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

**Performance Targets (NFR):**
- Sitemap generation: Complete in < 5 minutes for 10,000 posts
- Scheduled job: Handle up to 50,000 URLs efficiently
- Incremental updates: Update sitemap on new post publish (not full regeneration)
- CDN caching: 1-hour TTL for sitemap.xml

**Security Considerations:**
- **API Credentials:** Store Google/Bing API credentials in Rails encrypted credentials
- **Rate Limiting:** Respect Google (1,200 queries/minute) and Bing (10,000 URLs/day) rate limits
- **robots.txt Security:** Block admin pages, user settings, OAuth callbacks
- **Sitemap Security:** Only include publicly accessible URLs (no draft posts, private content)

**Reliability Requirements:**
- **Job Failure Handling:** Retry sitemap generation up to 3 times with exponential backoff
- **Partial Failure Tolerance:** If one chunk fails, other chunks should still be generated
- **Graceful API Degradation:** If Google/Bing API fails, sitemap should still be generated and served
- **Timeout Handling:** Set 10-second timeout for external API calls

### Source Tree Components to Touch

**New Files to Create:**

1. **config/sitemap.rb** (NEW)
   - Purpose: Define sitemap structure and update frequency
   - Configuration:
     - Posts: priority 0.8, changefreq daily
     - Tags: priority 0.6, changefreq weekly
     - User profiles: priority 0.4, changefreq weekly
     - Static pages: priority 0.9, changefreq monthly

2. **app/jobs/sitemap_generator_job.rb** (NEW)
   - Purpose: Background job to generate sitemap XML files
   - Responsibilities:
     - Query published content (articles, tags, users, pages)
     - Generate XML sitemap with proper structure
     - Implement chunking for > 50k URLs
     - Upload to CDN and submit to search engines
     - Log generation metrics

3. **lib/vibecoding/search_console_client.rb** (NEW)
   - Purpose: Wrapper service for Google Search Console API
   - Methods:
     - `submit_sitemap(sitemap_url)` - Submit sitemap to Google
     - `list_sitemaps` - List submitted sitemaps
   - Error handling: Retry with exponential backoff, log failures

4. **lib/vibecoding/bing_webmaster_client.rb** (NEW)
   - Purpose: Wrapper service for Bing Webmaster Tools API
   - Methods:
     - `submit_sitemap(sitemap_url)` - Submit sitemap to Bing
   - Error handling: Queue failed submissions for retry

5. **public/robots.txt** (NEW or UPDATE)
   - Purpose: Configure crawler access rules
   - Content: User-agent, Allow/Disallow directives, Sitemap reference

**Files to Modify:**

1. **app/models/article.rb** (MODIFY via Concern)
   - Add after_save callback to trigger sitemap update on publish
   - Example: `after_save :enqueue_sitemap_update, if: :published?`

2. **config/initializers/vibecoding_seo.rb** (UPDATE)
   - Add sitemap-related configuration (update frequency, chunk size)

3. **Gemfile** (POTENTIAL MODIFY)
   - Add `sitemap_generator` gem if not using Forem's built-in solution
   - Add Google API client gem: `google-api-client` (if needed)

**Testing Files to Create:**

1. **spec/jobs/sitemap_generator_job_spec.rb** (NEW)
   - Unit tests for sitemap generation job
   - Test chunking logic, XML structure, error handling

2. **spec/lib/vibecoding/search_console_client_spec.rb** (NEW)
   - Unit tests for Google Search Console API client
   - Mock API responses with VCR

3. **spec/lib/vibecoding/bing_webmaster_client_spec.rb** (NEW)
   - Unit tests for Bing Webmaster API client
   - Mock API responses with VCR

4. **spec/requests/sitemap_spec.rb** (NEW)
   - Integration tests for sitemap endpoint (`GET /sitemap.xml`)
   - Test sitemap XML validity

5. **spec/requests/robots_txt_spec.rb** (NEW)
   - Integration tests for robots.txt endpoint
   - Verify content and directives

### Testing Standards Summary

**From Tech Spec: Testing Strategy**

**1. Unit Tests (RSpec)**
- Target: `SitemapGeneratorJob`, API client services
- Coverage:
  - Sitemap generation logic (query, XML structure, chunking)
  - Google Search Console API submission (with VCR mocks)
  - Bing Webmaster API submission (with VCR mocks)
  - Error handling and retry logic
- Target Coverage: 90%+ for custom code

**2. Integration Tests (RSpec)**
- Target: Sitemap and robots.txt endpoints
- Coverage:
  - `GET /sitemap.xml` returns valid XML
  - `GET /robots.txt` returns correct directives
  - Sitemap includes all published content
  - Sitemap respects priority and changefreq settings
  - Test with mock data (10k, 50k URLs)

**3. Manual Validation Tests (Required)**
- W3C Sitemap Validator: Validate sitemap XML structure
- Google Search Console: Submit sitemap manually, verify indexing
- Bing Webmaster Tools: Submit sitemap manually, verify submission
- Test sitemap accessibility via CDN URL
- Verify sitemap appears in search console within 24 hours

**4. Performance Tests**
- Load Test: Generate sitemap with 10k, 50k, 100k URLs
- Duration Test: Measure time to complete (target: < 5 minutes for 50k)
- Database Query Performance: Monitor query execution time
- Memory Usage: Track memory consumption during generation

**Key Test Scenarios:**
1. **Small Site (<10k URLs):** Single sitemap.xml file generated
2. **Large Site (>10k URLs):** Sitemap index with multiple chunks generated
3. **API Success:** Google/Bing API submission succeeds, logged
4. **API Failure:** Google/Bing API submission fails, retries, logs error
5. **Scheduled Job:** Daily cron job triggers sitemap regeneration
6. **Incremental Update:** New article publish triggers sitemap update

### Project Structure Notes

**Alignment with Unified Project Structure:**
- Job location: `app/jobs/sitemap_generator_job.rb` (Rails convention)
- API clients: `lib/vibecoding/search_console_client.rb`, `lib/vibecoding/bing_webmaster_client.rb` (vibecoding namespace)
- Configuration: `config/sitemap.rb` (Rails sitemap_generator convention)
- Static file: `public/robots.txt` (Rails public directory)

**Naming Conventions (from Architecture):**
- Job class: `SitemapGeneratorJob` (PascalCase, Job suffix)
- API clients: `Vibecoding::SearchConsoleClient`, `Vibecoding::BingWebmasterClient` (module namespaced)
- Methods: `submit_sitemap`, `generate_sitemap` (snake_case)
- Config file: `sitemap.rb` (snake_case)

**Dependencies:**
- **Story 3.1 (SEO Meta Tags):** CONTEXT - Meta tags improve indexing quality
- **Story 1.3 (Deployment Pipeline):** REQUIRED - CDN (Cloudflare) must be configured
- **Story 1.6 (About Page):** REQUIRED - Static pages must exist to include in sitemap
- **Epic 5 (Analytics):** OPTIONAL - Google Search Console metrics integrate with analytics

**No Detected Conflicts:** Sitemap generation is additive (new SEO infrastructure), no conflicts with existing Forem routing or content.

### Learnings from Previous Story

**From Story 3-1-seo-meta-tags-structured-data (Status: drafted)**

Story 3.1 was only drafted but not yet implemented, so there are no concrete file changes or implementation learnings to reference. However, the previous story demonstrates good planning for SEO infrastructure.

**Key Takeaways for Story 3.2:**
- **Brownfield Approach:** Check Forem's built-in sitemap features before building custom solution
- **External API Integration:** Use service objects (`SearchConsoleClient`, `BingWebmasterClient`) for clean API interactions
- **Error Handling:** Implement retry logic and graceful degradation for external APIs
- **Performance Critical:** Sitemap generation at scale requires database query optimization (indexes, batching)
- **Scheduled Jobs:** Use Sidekiq scheduler or cron for daily sitemap regeneration
- **Monitoring:** Log sitemap generation metrics (URLs, duration, success/failure)

**Expected Architectural Patterns:**
- Background job for sitemap generation (`SitemapGeneratorJob`)
- Service objects for API clients (`SearchConsoleClient`, `BingWebmasterClient`)
- Configuration file for sitemap structure (`config/sitemap.rb`)
- Namespacing for custom code (`vibecoding/`, `Vibecoding::`)

**Continuity Notes:**
- Story 3.1 creates `lib/vibecoding/seo_optimizer.rb` service - Story 3.2 should follow same service pattern for API clients
- Story 3.1 uses `config/initializers/vibecoding_seo.rb` for config - Story 3.2 should update this file for sitemap settings
- Both stories focus on SEO optimization infrastructure - maintain consistent logging format

[Source: stories/3-1-seo-meta-tags-structured-data.md#Status]

### References

**Technical Specifications:**
- [Source: docs/tech-spec-epic-3.md#Story 3.2: Sitemap & Search Engine Indexing] - Detailed acceptance criteria and implementation design
- [Source: docs/tech-spec-epic-3.md#SitemapGenerator Configuration] - Sitemap structure and auto-update triggers
- [Source: docs/tech-spec-epic-3.md#Workflows → Sitemap Generation Workflow] - Complete sitemap generation process
- [Source: docs/tech-spec-epic-3.md#APIs & Interfaces → Google Search Console API] - API endpoints and authentication
- [Source: docs/tech-spec-epic-3.md#APIs & Interfaces → Bing Webmaster Tools API] - API endpoints and rate limits
- [Source: docs/tech-spec-epic-3.md#NFR → Performance → Sitemap Generation] - Performance targets and optimization strategies

**Epic Context:**
- [Source: docs/epics.md#Story 3.2: Sitemap Generation & Search Engine Indexing] - User story and business value
- [Source: docs/epics.md#Epic 3: SEO & Content Discoverability] - Epic goal and SEO strategy

**Architecture Decisions:**
- [Source: docs/architecture.md#ADR-001: Brownfield Customization Strategy] - Forem extension patterns
- [Source: docs/architecture.md#Pattern 3: Service Object Pattern] - Service implementation guidelines for API clients
- [Source: docs/architecture.md#Epic 3 Mapping] - Location and structure for SEO components
- [Source: docs/architecture.md#Consistency Rules → Naming Conventions] - Job, service, and file naming

**PRD Requirements:**
- [Source: docs/PRD.md#Web Application Specific Requirements → SEO Requirements] - Sitemap generation, robots.txt configuration
- [Source: docs/PRD.md#Non-Functional Requirements → Performance] - Sitemap generation performance targets

**Performance & Security:**
- [Source: docs/tech-spec-epic-3.md#NFR → Performance → Sitemap Generation Performance] - < 5 minutes for 10k posts, incremental updates
- [Source: docs/tech-spec-epic-3.md#NFR → Security → API Security] - OAuth 2.0 for Google, API key storage, rate limiting
- [Source: docs/tech-spec-epic-3.md#NFR → Reliability → Sitemap Generation Reliability] - Retry logic, partial failure tolerance

**Testing Strategy:**
- [Source: docs/tech-spec-epic-3.md#Test Strategy Summary → Integration Tests] - Sitemap generation job tests, API submission tests
- [Source: docs/tech-spec-epic-3.md#Test Strategy Summary → Manual Validation Tests] - W3C validator, Google/Bing manual submission
- [Source: docs/tech-spec-epic-3.md#Test Strategy Summary → Performance Tests] - Load test with 10k, 50k, 100k URLs

## Dev Agent Record

### Context Reference

<!-- Path(s) to story context XML will be added here by context workflow -->

### Agent Model Used

Claude Sonnet 4.5 (claude-sonnet-4-5-20250929)

### Debug Log References

### Completion Notes List

### File List
