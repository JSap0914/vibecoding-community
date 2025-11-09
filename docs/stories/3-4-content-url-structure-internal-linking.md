# Story 3.4: Content URL Structure & Internal Linking

Status: drafted

## Story

As an **SEO Specialist**,
I want clean, keyword-rich URLs and strategic internal linking,
So that search engines understand content hierarchy and flow link equity effectively.

## Acceptance Criteria

### Clean Slug-Based URLs
1. **AC-3.4.1**: When an article is created and published:
   - URL follows the pattern: `/{slug}`
   - Slug is auto-generated from article title
   - Slug contains only lowercase letters, numbers, and hyphens
   - Stop words (a, the, is, etc.) are removed
   - Slug is ≤ 100 characters
   - Slug is unique across all articles

### Slug Editability
2. **AC-3.4.2**: When an author edits an article:
   - Author can modify the slug before re-publishing
   - System validates slug uniqueness
   - System warns if changing an already-published slug
   - Slug follows same format constraints as auto-generated slugs

### 301 Redirects for Changed Slugs
3. **AC-3.4.3**: When an article slug is changed after publication:
   - A 301 (permanent) redirect is returned for the old URL
   - User is redirected to the new URL
   - Redirect is logged for analytics
   - Old URLs continue to work indefinitely

### Related Posts Internal Linking
4. **AC-3.4.4**: When an article page is rendered:
   - "Related Posts" section shows 3-5 articles with overlapping tags
   - Articles are sorted by relevance (tag overlap) and recency
   - Links to related articles use proper anchor text
   - Section appears at the end of the article

### Tag Page Internal Linking
5. **AC-3.4.5**: When a tag page is rendered (e.g., `/tags/vibecoding`):
   - Page displays all articles tagged with that tag
   - Page shows links to related tags (co-occurring tags)
   - Page has proper heading hierarchy (H1, H2) for SEO
   - Tag page includes tag description for SEO

## Tasks / Subtasks

- [ ] Task 1: Verify Existing Forem Slug Generation (AC: #1)
  - [ ] 1.1: Check if Forem has built-in slug generation (likely uses FriendlyId gem)
  - [ ] 1.2: Read Forem Article model to understand slug generation logic
  - [ ] 1.3: Test slug generation: create article with title "Building a SaaS App with ANYON"
  - [ ] 1.4: Verify slug format: should be "building-saas-app-with-anyon" (lowercase, hyphens, no stop words)
  - [ ] 1.5: Check if slug length is limited to 100 characters
  - [ ] 1.6: Verify slug uniqueness validation exists
  - [ ] 1.7: Document current slug generation behavior

- [ ] Task 2: Customize Slug Generation (AC: #1, if needed)
  - [ ] 2.1: If Forem's slug generation is insufficient, create custom slug generator
  - [ ] 2.2: Implement stop word removal (a, an, the, is, are, was, were, etc.)
  - [ ] 2.3: Ensure slug is lowercase with hyphens (no underscores)
  - [ ] 2.4: Enforce 100 character limit (truncate if needed)
  - [ ] 2.5: Add uniqueness validation with sequential suffix if duplicate (e.g., -2, -3)
  - [ ] 2.6: Handle special characters (remove or convert to nearest ASCII equivalent)
  - [ ] 2.7: Test slug generation with edge cases:
    - Very long titles (> 100 chars)
    - Titles with special characters (é, ñ, 中文)
    - Titles with all stop words ("The Best of the Best")
    - Duplicate titles

- [ ] Task 3: Implement Slug Editability UI (AC: #2)
  - [ ] 3.1: Check if Forem article editor has slug edit field
  - [ ] 3.2: If not, add slug edit field to article form
  - [ ] 3.3: Display current auto-generated slug with edit capability
  - [ ] 3.4: Add real-time slug preview: show full URL as user types
  - [ ] 3.5: Validate slug format on client-side (JavaScript): lowercase, hyphens only, no spaces
  - [ ] 3.6: Show validation error if slug is invalid or too long
  - [ ] 3.7: Add uniqueness check (AJAX request to server)
  - [ ] 3.8: Display warning modal if editing published article's slug:
    - "Changing the URL of a published article will create a redirect from the old URL"
    - Confirm/Cancel buttons

- [ ] Task 4: Implement 301 Redirect System (AC: #3)
  - [ ] 4.1: Check if Forem has built-in redirect system for slug changes
  - [ ] 4.2: If not, create `redirects` table migration:
    ```ruby
    create_table :redirects do |t|
      t.string :from_path, null: false, index: { unique: true }
      t.string :to_path, null: false
      t.integer :status_code, default: 301
      t.timestamps
    end
    ```
  - [ ] 4.3: Create Redirect model with validations
  - [ ] 4.4: Add `before_update` callback to Article model to detect slug changes
  - [ ] 4.5: On slug change, create Redirect record: `from_path = old_slug, to_path = new_slug`
  - [ ] 4.6: Implement redirect middleware or controller method:
    - Check if requested path exists in redirects table
    - If found, return 301 redirect to `to_path`
    - Log redirect event for analytics
  - [ ] 4.7: Handle redirect chains (A→B→C should redirect A→C directly)
  - [ ] 4.8: Test redirect functionality:
    - Change article slug
    - Visit old URL
    - Verify 301 redirect to new URL
    - Check redirect appears in browser network tab

- [ ] Task 5: Implement Related Posts Algorithm (AC: #4)
  - [ ] 5.1: Check if Forem has built-in related posts feature
  - [ ] 5.2: If not, create `RelatedPostsFinder` service object in `lib/vibecoding/related_posts_finder.rb`
  - [ ] 5.3: Implement algorithm to find related articles:
    - Query articles with overlapping tags (SQL: `JOIN articles_tags ON tag_id IN (...)`)
    - Score by tag overlap count (more shared tags = higher score)
    - Secondary sort by recency (`published_at DESC`)
    - Limit to 3-5 results
    - Exclude current article
  - [ ] 5.4: Optimize query performance:
    - Use database indexes on `articles.tags` association
    - Cache results for 1 hour (Rails.cache)
    - Eager load article data (`includes(:user, :tags)`)
  - [ ] 5.5: Handle edge cases:
    - Article with no tags → show recent articles
    - No related articles found → show popular articles
    - Single tag → fallback to other articles with same tag
  - [ ] 5.6: Test related posts algorithm with various scenarios

- [ ] Task 6: Create Related Posts UI Component (AC: #4)
  - [ ] 6.1: Create related posts partial: `app/views/articles/_related_posts.html.erb`
  - [ ] 6.2: Design related posts section:
    - Heading: "Related Posts" or "You Might Also Like"
    - Display 3-5 article cards with: title, excerpt, author, tags
    - Use Crayons design system components for consistency
  - [ ] 6.3: Add proper anchor text for links (use article title)
  - [ ] 6.4: Add `rel="related"` attribute to links for SEO signal
  - [ ] 6.5: Position at end of article content (before comments section)
  - [ ] 6.6: Make responsive (horizontal scroll on mobile, grid on desktop)
  - [ ] 6.7: Track clicks on related posts (GA4 event: `related_post_click`)

- [ ] Task 7: Integrate Related Posts into Article View (AC: #4)
  - [ ] 7.1: Find article show view: `app/views/articles/show.html.erb` or similar
  - [ ] 7.2: Add related posts section at end of article body:
    ```erb
    <% related_posts = Vibecoding::RelatedPostsFinder.new(@article).find %>
    <%= render 'articles/related_posts', articles: related_posts %>
    ```
  - [ ] 7.3: Add controller method to fetch related posts (if needed)
  - [ ] 7.4: Test display on various article types (with/without tags, different tag counts)
  - [ ] 7.5: Verify performance (< 100ms for related posts query)

- [ ] Task 8: Enhance Tag Pages for Internal Linking (AC: #5)
  - [ ] 8.1: Find tag show view: `app/views/tags/show.html.erb` or similar
  - [ ] 8.2: Verify proper heading hierarchy:
    - H1: Tag name (e.g., "Vibecoding")
    - H2: "Articles tagged with Vibecoding"
    - H2: "Related Tags"
  - [ ] 8.3: Add tag description section (if not exists):
    - Display tag's `short_summary` or `rules_html`
    - Edit via Forem admin panel
    - SEO-friendly description (150-300 characters)
  - [ ] 8.4: Implement related tags section:
    - Query co-occurring tags (tags that appear with current tag)
    - Rank by co-occurrence frequency
    - Display as clickable badges/chips
    - Limit to 5-10 related tags
  - [ ] 8.5: Optimize tag page URL structure:
    - Verify URLs follow `/tags/{tag-slug}` pattern
    - Ensure tag slugs are SEO-friendly (lowercase, hyphens)
  - [ ] 8.6: Add breadcrumb navigation (optional):
    - Home > Tags > {Tag Name}
    - Implement via structured data (BreadcrumbList schema)

- [ ] Task 9: Implement Related Tags Algorithm (AC: #5)
  - [ ] 9.1: Create service object: `lib/vibecoding/related_tags_finder.rb`
  - [ ] 9.2: Implement co-occurrence algorithm:
    ```sql
    SELECT tags.*, COUNT(*) as co_occurrence_count
    FROM tags
    JOIN taggings ON tags.id = taggings.tag_id
    WHERE taggings.taggable_id IN (
      SELECT taggable_id FROM taggings WHERE tag_id = :current_tag_id
    )
    AND tags.id != :current_tag_id
    GROUP BY tags.id
    ORDER BY co_occurrence_count DESC
    LIMIT 10
    ```
  - [ ] 9.3: Cache results for 1 hour (tag relationships change slowly)
  - [ ] 9.4: Test with various tags (high/low usage, niche vs broad)

- [ ] Task 10: URL Security and Validation (AC: #3)
  - [ ] 10.1: Implement slug validation regex: `^[a-z0-9-]+$` (lowercase, numbers, hyphens only)
  - [ ] 10.2: Prevent slug injection attacks (e.g., `../../admin`)
  - [ ] 10.3: Sanitize slugs to prevent path traversal
  - [ ] 10.4: Validate redirect `to_path` is internal (same domain)
  - [ ] 10.5: Prevent open redirect vulnerabilities (only allow `/article-slug` paths)
  - [ ] 10.6: Log suspicious slug patterns for security monitoring
  - [ ] 10.7: Test with malicious slug patterns:
    - `../../../etc/passwd`
    - `https://evil.com/phishing`
    - `<script>alert('xss')</script>`

- [ ] Task 11: Performance Optimization (NFR)
  - [ ] 11.1: Add database indexes:
    - `articles.slug` (already exists in Forem, verify)
    - `redirects.from_path` (unique index)
    - `taggings` composite index on (`tag_id`, `taggable_id`)
  - [ ] 11.2: Optimize related posts query:
    - Use eager loading (`includes`)
    - Cache results (1 hour TTL)
    - Ensure query execution time < 100ms (p95)
  - [ ] 11.3: Optimize related tags query:
    - Use database aggregation (GROUP BY, COUNT)
    - Cache results (1 hour TTL)
  - [ ] 11.4: Implement fragment caching for related posts partial
  - [ ] 11.5: Monitor redirect middleware performance (should add < 10ms overhead)

- [ ] Task 12: Analytics and Tracking (AC: #4, observability)
  - [ ] 12.1: Track related post clicks in GA4:
    ```javascript
    gtag('event', 'related_post_click', {
      source_article_id: currentArticleId,
      target_article_id: relatedArticleId,
      position: index
    });
    ```
  - [ ] 12.2: Track 301 redirects (log to database and GA4):
    ```ruby
    Rails.logger.info("VIBECODING: 301 redirect", from: old_path, to: new_path)
    ```
  - [ ] 12.3: Create admin dashboard for redirect monitoring (optional, Epic 5)
  - [ ] 12.4: Monitor internal link click-through rates (CTR)

- [ ] Task 13: Unit and Integration Tests (All ACs)
  - [ ] 13.1: Unit test slug generation:
    - Test auto-generation from title
    - Test stop word removal
    - Test character limit (100 chars)
    - Test special character handling
    - Test uniqueness with sequential suffix
  - [ ] 13.2: Unit test `RelatedPostsFinder`:
    - Test tag overlap scoring
    - Test recency sorting
    - Test edge cases (no tags, no related posts)
  - [ ] 13.3: Unit test `RelatedTagsFinder`:
    - Test co-occurrence algorithm
    - Test sorting by frequency
  - [ ] 13.4: Integration test slug editability:
    - Edit slug via article form
    - Verify uniqueness validation
    - Test warning modal on published article slug change
  - [ ] 13.5: Integration test 301 redirects:
    - Change article slug
    - Visit old URL → verify 301 redirect
    - Check Redirect model created
  - [ ] 13.6: Feature test related posts display:
    - Verify related posts section appears on article page
    - Test with articles sharing tags
    - Test fallback when no related posts
  - [ ] 13.7: Feature test tag pages:
    - Verify heading hierarchy (H1, H2)
    - Verify related tags section appears
    - Test tag description display

- [ ] Task 14: SEO Validation and Documentation
  - [ ] 14.1: Validate URL structure follows SEO best practices:
    - URLs are readable (keyword-rich slugs)
    - URLs are consistent (all lowercase, hyphens)
    - URLs are short (< 75 characters recommended)
    - URLs are unique (no duplicates)
  - [ ] 14.2: Run Lighthouse SEO audit:
    - Check for proper heading hierarchy on tag pages
    - Verify internal links are crawlable
    - Check for broken internal links
  - [ ] 14.3: Use Screaming Frog or similar tool to:
    - Crawl internal links
    - Identify broken links
    - Verify redirect chains
    - Check URL canonicalization
  - [ ] 14.4: Document slug generation rules in `docs/seo-guidelines.md`
  - [ ] 14.5: Document redirect system in `docs/customization-guide.md`
  - [ ] 14.6: Create runbook for managing redirects

## Dev Notes

### Architecture Patterns and Constraints

**Brownfield Customization Strategy (ADR-001):**
- Forem likely uses FriendlyId gem for slug generation - verify before customizing
- Forem may have built-in related posts - check before implementing custom solution
- Extend Forem's existing URL routing, don't replace it
- All custom code namespaced under `vibecoding/` or `lib/vibecoding/`

**Architecture Alignment:**
- **Service Objects:** `RelatedPostsFinder`, `RelatedTagsFinder` in `lib/vibecoding/`
- **Redirect Model:** `Redirect` model with `from_path`, `to_path`, `status_code`
- **Middleware/Controller:** Redirect handling in routing layer or controller concern
- **Views:** Related posts partial, tag page enhancements

**Slug Generation Workflow (expected):**
```
Article created with title
    ↓
Before validation callback
    ↓
Generate slug from title
  - Lowercase and convert to hyphens
  - Remove stop words
  - Remove special characters
  - Truncate to 100 characters
  - Check uniqueness, add suffix if needed
    ↓
Save article with slug
    ↓
Article URL: /{slug}
```

**Redirect Workflow (from Tech Spec):**
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
Save redirect to database
    ↓
Clear page caches
    ↓
Incoming request to old_slug
    ↓
Middleware checks Redirect table
    ↓
Return 301 redirect to new_slug
```

**Related Posts Algorithm:**
```
Article displayed
    ↓
RelatedPostsFinder.new(article).find
    ↓
Query articles with shared tags
    ↓
Score by tag overlap count
    ↓
Sort by score (DESC), then recency (published_at DESC)
    ↓
Limit to 3-5 results
    ↓
Cache for 1 hour
    ↓
Return related articles
    ↓
Render related posts partial
```

**Performance Targets (NFR):**
- Slug generation: < 50ms overhead
- Related posts query: < 100ms (p95)
- Related tags query: < 100ms (p95)
- Redirect middleware: < 10ms overhead
- Fragment cache hit ratio: > 80% for related posts

**Security Requirements (NFR):**
- **Slug Validation:** Only allow `[a-z0-9-]` characters
- **Path Traversal Prevention:** Reject slugs with `../` or absolute paths
- **Open Redirect Prevention:** Only allow internal redirects (same domain)
- **XSS Prevention:** Escape all slug-derived content in HTML
- **SQL Injection Prevention:** Use parameterized queries for all database operations

**Database Schema Changes:**

**New Table: redirects**
```sql
CREATE TABLE redirects (
  id BIGSERIAL PRIMARY KEY,
  from_path VARCHAR(255) NOT NULL,
  to_path VARCHAR(255) NOT NULL,
  status_code INTEGER DEFAULT 301,
  hits INTEGER DEFAULT 0,
  created_at TIMESTAMP NOT NULL,
  updated_at TIMESTAMP NOT NULL
);

CREATE UNIQUE INDEX idx_redirects_from_path ON redirects(from_path);
CREATE INDEX idx_redirects_to_path ON redirects(to_path);

COMMENT ON TABLE redirects IS 'VIBECODING: Tracks 301 redirects for changed article slugs';
```

**Existing Indexes to Verify:**
- `articles.slug` (likely already exists in Forem with unique constraint)
- `taggings` composite index on `(tag_id, taggable_id)` (verify for performance)

### Source Tree Components to Touch

**New Files to Create:**

1. **lib/vibecoding/related_posts_finder.rb** (NEW)
   - Purpose: Service object to find related articles based on tag overlap
   - Methods:
     - `initialize(article)` - Store current article
     - `find(limit: 5)` - Return related articles
   - Algorithm: Query shared tags, score by overlap, sort by recency

2. **lib/vibecoding/related_tags_finder.rb** (NEW)
   - Purpose: Service object to find co-occurring tags
   - Methods:
     - `initialize(tag)` - Store current tag
     - `find(limit: 10)` - Return related tags
   - Algorithm: Query co-occurring tags, rank by frequency

3. **app/models/redirect.rb** (NEW, if Forem doesn't have built-in)
   - Purpose: Model for tracking 301 redirects
   - Validations: `from_path` uniqueness, `to_path` presence, internal URL validation
   - Methods: Track redirect hits, handle redirect chains

4. **app/views/articles/_related_posts.html.erb** (NEW)
   - Purpose: Partial to display related posts at end of articles
   - Props: `@articles` (array of related articles)
   - Design: Article cards with title, excerpt, author, tags

5. **db/migrate/YYYYMMDD_create_redirects.rb** (NEW, if needed)
   - Purpose: Create redirects table for 301 redirect tracking
   - Schema: from_path, to_path, status_code, hits, timestamps

**Files to Modify:**

1. **app/models/article.rb** (MODIFY via concern, do not edit directly)
   - Add concern: `app/models/concerns/slug_redirect_tracking.rb`
   - Behavior: `before_update` callback to create Redirect on slug change
   - Validation: Enhanced slug validation (format, length, uniqueness)

2. **app/models/concerns/slug_redirect_tracking.rb** (CREATE)
   - Purpose: Concern to track slug changes and create redirects
   - Code:
     ```ruby
     module SlugRedirectTracking
       extend ActiveSupport::Concern

       included do
         before_update :create_redirect_if_slug_changed, if: :published?

         private

         def create_redirect_if_slug_changed
           return unless slug_changed?
           Redirect.create!(
             from_path: "/#{slug_was}",
             to_path: "/#{slug}",
             status_code: 301
           )
         end
       end
     end
     ```

3. **config/initializers/vibecoding_customizations.rb** (UPDATE)
   - Include `SlugRedirectTracking` concern in Article model:
     ```ruby
     Article.include SlugRedirectTracking
     ```

4. **app/controllers/application_controller.rb** (MODIFY or create middleware)
   - Add redirect handling:
     ```ruby
     before_action :handle_redirects

     def handle_redirects
       redirect = Redirect.find_by(from_path: request.path)
       if redirect
         redirect.increment!(:hits)
         redirect_to redirect.to_path, status: :moved_permanently
       end
     end
     ```
   - Or implement as Rack middleware for better performance

5. **app/views/articles/show.html.erb** (MODIFY)
   - Add related posts section at end of article:
     ```erb
     <% if @related_posts.present? %>
       <%= render 'articles/related_posts', articles: @related_posts %>
     <% end %>
     ```

6. **app/controllers/articles_controller.rb** (MODIFY via decorator, if needed)
   - Add to show action:
     ```ruby
     @related_posts = Vibecoding::RelatedPostsFinder.new(@article).find
     ```

7. **app/views/tags/show.html.erb** (MODIFY)
   - Verify/enhance heading hierarchy (H1 for tag name, H2 for sections)
   - Add tag description section
   - Add related tags section:
     ```erb
     <% related_tags = Vibecoding::RelatedTagsFinder.new(@tag).find %>
     <%= render 'tags/related_tags', tags: related_tags %>
     ```

8. **app/views/tags/_related_tags.html.erb** (CREATE)
   - Purpose: Partial to display related tags
   - Display tags as clickable badges/chips
   - Use Crayons design system for styling

**Testing Files to Create:**

1. **spec/models/redirect_spec.rb** (NEW)
   - Unit tests for Redirect model validations
   - Test uniqueness, internal URL validation

2. **spec/models/concerns/slug_redirect_tracking_spec.rb** (NEW)
   - Test slug change detection
   - Test redirect creation on slug update

3. **spec/lib/vibecoding/related_posts_finder_spec.rb** (NEW)
   - Unit tests for related posts algorithm
   - Test tag overlap scoring, recency sorting
   - Test edge cases (no tags, no related posts)

4. **spec/lib/vibecoding/related_tags_finder_spec.rb** (NEW)
   - Unit tests for related tags algorithm
   - Test co-occurrence counting, frequency sorting

5. **spec/features/url_structure_spec.rb** (NEW)
   - Feature test: Article URL follows /{slug} pattern
   - Feature test: Slug is lowercase with hyphens
   - Feature test: Slug is unique

6. **spec/features/slug_editing_spec.rb** (NEW)
   - Feature test: Edit slug in article form
   - Feature test: Uniqueness validation
   - Feature test: Warning modal on published slug change

7. **spec/features/redirects_spec.rb** (NEW)
   - Feature test: Change slug → visit old URL → verify 301 redirect
   - Feature test: Redirect logged in database
   - Feature test: Old URL continues to work

8. **spec/features/related_posts_spec.rb** (NEW)
   - Feature test: Related posts appear on article page
   - Feature test: Related posts have shared tags
   - Feature test: Fallback when no related posts

9. **spec/features/tag_pages_spec.rb** (NEW)
   - Feature test: Tag page has proper heading hierarchy
   - Feature test: Related tags section appears
   - Feature test: Tag description displays

### Testing Standards Summary

**From Tech Spec: Testing Strategy**

**1. Unit Tests (RSpec)**
- Target: Slug generation, RelatedPostsFinder, RelatedTagsFinder, Redirect model
- Coverage:
  - Slug generation: auto-generation, stop word removal, character limit, uniqueness
  - RelatedPostsFinder: tag overlap algorithm, recency sorting, edge cases
  - RelatedTagsFinder: co-occurrence algorithm, frequency sorting
  - Redirect model: validations, internal URL check
- Target Coverage: 90%+ for custom code

**2. Integration Tests (RSpec)**
- Target: Redirect system, related posts integration
- Coverage:
  - Slug change creates Redirect record
  - Redirect middleware handles 301 redirects
  - Related posts query performance (< 100ms)
  - Related tags query performance (< 100ms)

**3. Feature Tests (Capybara)**
- Target: End-to-end URL and linking workflows
- Coverage:
  - Article URL structure (/{slug})
  - Slug editability in article form
  - Warning modal on published slug change
  - 301 redirect when visiting old URL
  - Related posts display on article page
  - Related tags display on tag page
  - Proper heading hierarchy on tag pages

**4. SEO Validation Tests (Manual + Automated)**
- **Lighthouse SEO Audit:**
  - Verify heading hierarchy (H1, H2 structure)
  - Check for crawlable internal links
  - Validate URL structure
- **Screaming Frog Crawl:**
  - Check for broken internal links
  - Verify redirect chains
  - Validate URL canonicalization
- **Manual URL Inspection:**
  - Test slug format with various titles
  - Verify URLs are readable and keyword-rich

**Key Test Scenarios:**
1. **Slug Generation:** Title "Building a SaaS App with ANYON" → slug "building-saas-app-with-anyon"
2. **Stop Word Removal:** Title "The Best Guide to Vibecoding" → slug "best-guide-vibecoding"
3. **Slug Uniqueness:** Duplicate title → slug gets suffix "article-title-2"
4. **Slug Edit Warning:** Edit published article slug → warning modal appears
5. **301 Redirect:** Change slug from "old-slug" to "new-slug" → visit "/old-slug" → redirects to "/new-slug"
6. **Related Posts:** Article with tags [vibecoding, anyon] → shows other articles with shared tags
7. **Related Tags:** Tag page for "vibecoding" → shows co-occurring tags like "anyon", "tutorial"

### Project Structure Notes

**Alignment with Unified Project Structure:**
- Service objects: `lib/vibecoding/related_posts_finder.rb`, `lib/vibecoding/related_tags_finder.rb`
- Models: `app/models/redirect.rb` (new table)
- Concerns: `app/models/concerns/slug_redirect_tracking.rb` (extend Article)
- Views: `app/views/articles/_related_posts.html.erb`, `app/views/tags/_related_tags.html.erb`
- Migrations: `db/migrate/YYYYMMDD_create_redirects.rb`

**Naming Conventions (from Architecture):**
- Service classes: `RelatedPostsFinder`, `RelatedTagsFinder` (PascalCase)
- Concerns: `SlugRedirectTracking` (PascalCase)
- Model: `Redirect` (singular, PascalCase)
- Table: `redirects` (plural, snake_case)
- Partials: `_related_posts.html.erb`, `_related_tags.html.erb` (snake_case)

**Dependencies:**
- **Story 3.1 (SEO Meta Tags):** OPTIONAL - Canonical URLs helpful but not required for this story
- **Story 3.2 (Sitemap Generation):** OPTIONAL - Sitemaps will include clean URLs from this story
- **Story 4.1 (Tag Taxonomy):** OPTIONAL - Tag structure already exists, this story enhances tag pages
- **Epic 1 (Platform Foundation):** REQUIRED - Forem must be deployed and functional

**No Detected Conflicts:** URL structure and internal linking are foundational features that don't conflict with other SEO stories.

### Learnings from Previous Story

**From Story 3-3-social-sharing-optimization (Status: drafted)**

Story 3.3 was drafted but not yet implemented. However, it demonstrates consistent architectural patterns:

**Architectural Patterns to Maintain:**
1. **Service Objects:** Use `lib/vibecoding/` for custom business logic
2. **Preact Components:** Use `app/javascript/custom/` for frontend components
3. **Utility Modules:** Use `app/javascript/analytics/` for tracking utilities
4. **Configuration:** Use `config/initializers/vibecoding_seo.rb` for SEO config
5. **Namespacing:** Prefix all custom code with `vibecoding`, `custom`, or `anyon`

**Story 3.3 Key Patterns:**
- Created utility module `social_share_tracker.js` for share URL generation
- Used Preact component `SocialShareButtons.jsx` for UI
- Leveraged Crayons design system for consistent styling
- Implemented GA4 event tracking for share clicks
- Used default fallback images when custom images missing

**Continuity for Story 3.4:**
- **Service Object Pattern:** Create `RelatedPostsFinder`, `RelatedTagsFinder` in `lib/vibecoding/`
- **Configuration Pattern:** Use `config/initializers/vibecoding_seo.rb` if SEO config needed
- **Logging Pattern:** Use structured logging with "VIBECODING:" prefix
- **Performance:** Cache query results (1 hour TTL) like Story 3.3 caches meta tags
- **Testing:** Mix of unit tests (RSpec), feature tests (Capybara), and manual validation

**Expected Flow Based on Previous Stories:**
1. Check if Forem has built-in functionality (slug generation, related posts)
2. If existing, customize; if not, create custom implementation
3. Namespace all custom code appropriately
4. Use service objects for business logic, concerns for model extensions
5. Implement comprehensive tests (unit, integration, feature)
6. Document in `docs/customization-guide.md`

[Source: stories/3-3-social-sharing-optimization.md#Dev-Notes]

### References

**Technical Specifications:**
- [Source: docs/tech-spec-epic-3.md#Story 3.4: Content URL Structure & Internal Linking] - Detailed acceptance criteria and implementation design
- [Source: docs/tech-spec-epic-3.md#Workflows → Slug Change Redirect Workflow] - Complete redirect process flow
- [Source: docs/tech-spec-epic-3.md#NFR → Security → URL Security] - Slug validation and redirect security requirements
- [Source: docs/tech-spec-epic-3.md#Dependencies → Slug Generation] - FriendlyId integration and extension patterns

**Epic Context:**
- [Source: docs/epics.md#Story 3.4: Content URL Structure & Internal Linking] - User story and SEO value proposition
- [Source: docs/epics.md#Epic 3: SEO & Content Discoverability] - Epic goal and organic growth strategy

**Architecture Decisions:**
- [Source: docs/architecture.md#ADR-001: Brownfield Customization Strategy] - Forem extension patterns for slug generation
- [Source: docs/architecture.md#Pattern 1: Service Object Pattern] - Service object implementation for finders
- [Source: docs/architecture.md#Pattern 5: Database Migration Pattern] - Migration pattern for redirects table
- [Source: docs/architecture.md#Consistency Rules → Database] - Table and column naming conventions

**PRD Requirements:**
- [Source: docs/PRD.md#Functional Requirements → Content Discovery & Engagement → Reading Experience] - Internal linking for user navigation
- [Source: docs/PRD.md#Web Application Specific Requirements → SEO Requirements] - Clean URLs, semantic HTML, internal linking strategy
- [Source: docs/PRD.md#Non-Functional Requirements → SEO & Discoverability] - URL structure best practices, internal link equity

**Performance & Security:**
- [Source: docs/tech-spec-epic-3.md#NFR → Performance → Meta Tag Generation] - Query optimization patterns applicable to related posts
- [Source: docs/tech-spec-epic-3.md#NFR → Security → URL Security] - Slug validation, path traversal prevention, redirect security
- [Source: docs/tech-spec-epic-3.md#NFR → Reliability → Redirect Security] - Open redirect prevention, internal URL validation

**Testing Strategy:**
- [Source: docs/tech-spec-epic-3.md#Test Strategy Summary → Unit Tests] - Service object testing patterns
- [Source: docs/tech-spec-epic-3.md#Test Strategy Summary → Integration Tests] - Database query and caching tests
- [Source: docs/tech-spec-epic-3.md#Test Strategy Summary → SEO Audit Tests] - Lighthouse and Screaming Frog validation

## Dev Agent Record

### Context Reference

<!-- Path(s) to story context XML will be added here by context workflow -->

### Agent Model Used

Claude Sonnet 4.5 (claude-sonnet-4-5-20250929)

### Debug Log References

### Completion Notes List

### File List
