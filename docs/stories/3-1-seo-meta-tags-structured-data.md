# Story 3.1: SEO Meta Tags & Structured Data

Status: drafted

## Story

As an **SEO Specialist**,
I want automated, optimized meta tags and Schema.org markup for all content,
So that search engines properly index and display our content in search results.

## Acceptance Criteria

### Meta Tag Generation
1. **AC-3.1.1**: Every published article page includes auto-generated meta tags:
   - `<title>` tag with format "{Article Title} | Vibecoding Community" (< 60 chars)
   - `<meta name="description">` with article description or first 160 chars of body
   - `<link rel="canonical">` pointing to the article's canonical URL
   - `<meta name="robots">` appropriate for content status (index/noindex)

### Open Graph Tags
2. **AC-3.1.2**: Open Graph tags are generated for all published articles with:
   - `og:title` - Article title
   - `og:description` - Article description or excerpt
   - `og:image` - Article main_image or default vibecoding OG image
   - `og:url` - Canonical URL
   - `og:type` - "article"
   - `og:site_name` - "Vibecoding Community"
   - `article:published_time`, `article:author`, `article:tag`

### Twitter Card Tags
3. **AC-3.1.3**: Twitter Card meta tags are present on all published articles:
   - `twitter:card` - "summary_large_image"
   - `twitter:site` - "@vibecoding" (site Twitter handle)
   - `twitter:title` - Article title
   - `twitter:description` - Article description
   - `twitter:image` - Article image or default
   - `twitter:creator` - Author's Twitter handle (if available)

### Schema.org Article Markup
4. **AC-3.1.4**: Valid Schema.org JSON-LD Article schema is embedded with:
   - `@type: "Article"`
   - `headline`, `description`, `author`, `datePublished`, `dateModified`
   - `image`, `publisher` (Organization schema)
   - `mainEntityOfPage` (WebPage schema)
   - Validates successfully at https://validator.schema.org/

### Meta Tag Validation
5. **AC-3.1.5**: All generated meta tags meet quality standards:
   - Title length ≤ 60 characters
   - Description length ≤ 160 characters
   - All URLs are properly formatted and use HTTPS
   - Images use absolute URLs
   - No HTML entities in meta content (properly escaped)

## Tasks / Subtasks

- [ ] Task 1: Create SeoOptimizer Service (AC: #1-5)
  - [ ] 1.1: Create `lib/vibecoding/seo_optimizer.rb` service class
  - [ ] 1.2: Implement `generate_meta_tags(content)` method - Returns hash of meta tags
  - [ ] 1.3: Implement `generate_structured_data(content)` method - Returns Schema.org JSON-LD
  - [ ] 1.4: Implement `validate_meta_tags(tags)` method - Validates tag completeness and character limits
  - [ ] 1.5: Add character limit enforcement (title ≤ 60, description ≤ 160)
  - [ ] 1.6: Add URL formatting validation (HTTPS, absolute paths)
  - [ ] 1.7: Add fallback logic (description from body, default OG image)

- [ ] Task 2: Implement Meta Tag Partial (AC: #1-3)
  - [ ] 2.1: Create or update `app/views/layouts/_meta_tags.html.erb` partial
  - [ ] 2.2: Add standard meta tags (title, description, canonical)
  - [ ] 2.3: Add Open Graph tags (og:title, og:image, og:url, og:type, etc.)
  - [ ] 2.4: Add Twitter Card tags (twitter:card, twitter:title, twitter:image, etc.)
  - [ ] 2.5: Add robots meta tags (index/noindex based on content status)
  - [ ] 2.6: Include Schema.org JSON-LD script tag
  - [ ] 2.7: Ensure proper HTML escaping for all user-generated content

- [ ] Task 3: Integrate Meta Tags into Layout (AC: #1-3)
  - [ ] 3.1: Update `app/views/layouts/application.html.erb` to include `_meta_tags` partial
  - [ ] 3.2: Pass article data to meta tags partial for dynamic generation
  - [ ] 3.3: Handle different content types (articles, tags, user profiles)
  - [ ] 3.4: Implement fragment caching for meta tags (10-minute TTL)
  - [ ] 3.5: Test meta tag rendering on article pages
  - [ ] 3.6: Test meta tag rendering on homepage and other pages

- [ ] Task 4: Configure SEO Settings (AC: #2, #3)
  - [ ] 4.1: Create `config/initializers/vibecoding_seo.rb` initializer
  - [ ] 4.2: Define default SEO settings (site_name, default_og_image, twitter_handle)
  - [ ] 4.3: Store default OG image in `app/assets/images/vibecoding/og-default.png`
  - [ ] 4.4: Create default OG image with Vibecoding branding (1200x630px)
  - [ ] 4.5: Configure keywords: ["vibecoding", "ANYON", "AI development"]
  - [ ] 4.6: Store settings as environment variables where appropriate

- [ ] Task 5: Implement Schema.org JSON-LD Generation (AC: #4)
  - [ ] 5.1: Create Article schema generator in `SeoOptimizer` service
  - [ ] 5.2: Include all required fields (headline, author, datePublished, etc.)
  - [ ] 5.3: Create Person schema for article authors
  - [ ] 5.4: Create Organization schema for publisher (Vibecoding Community)
  - [ ] 5.5: Create BreadcrumbList schema for navigation
  - [ ] 5.6: Ensure JSON-LD is valid (no syntax errors)
  - [ ] 5.7: Add JSON-LD to article pages via `_meta_tags` partial

- [ ] Task 6: Meta Tag Validation and Fallbacks (AC: #5)
  - [ ] 6.1: Implement title truncation to 60 chars with ellipsis
  - [ ] 6.2: Implement description truncation to 160 chars with ellipsis
  - [ ] 6.3: Ensure description generation from article body (first 160 chars if blank)
  - [ ] 6.4: Ensure default OG image is used when article has no main_image
  - [ ] 6.5: Validate all URLs are HTTPS and absolute
  - [ ] 6.6: Add fallback for missing author name ("Vibecoding Community")
  - [ ] 6.7: Log warnings for missing or invalid meta tag data

- [ ] Task 7: Testing and Validation (All ACs)
  - [ ] 7.1: Unit test `SeoOptimizer#generate_meta_tags` method
  - [ ] 7.2: Unit test `SeoOptimizer#generate_structured_data` method
  - [ ] 7.3: Unit test `SeoOptimizer#validate_meta_tags` method
  - [ ] 7.4: Integration test meta tag rendering on article pages
  - [ ] 7.5: Test character limits (title, description)
  - [ ] 7.6: Test fallback values (default image, auto-generated description)
  - [ ] 7.7: Manual validation with Schema.org Validator (https://validator.schema.org/)
  - [ ] 7.8: Manual validation with Twitter Card Validator
  - [ ] 7.9: Manual validation with Facebook Sharing Debugger
  - [ ] 7.10: Manual validation with LinkedIn Post Inspector
  - [ ] 7.11: Test with articles that have/don't have: title, description, image
  - [ ] 7.12: Test proper HTML escaping for special characters

- [ ] Task 8: Performance Optimization (NFR)
  - [ ] 8.1: Implement fragment caching for meta tag partial (cache_key based on article)
  - [ ] 8.2: Measure meta tag generation overhead (target: < 50ms)
  - [ ] 8.3: Optimize database queries (eager load user, tags associations)
  - [ ] 8.4: Test cache hit/miss performance
  - [ ] 8.5: Monitor meta tag generation performance in staging

- [ ] Task 9: Documentation and Monitoring (Post-Implementation)
  - [ ] 9.1: Document `SeoOptimizer` service in code comments
  - [ ] 9.2: Document meta tag generation in `docs/customization-guide.md`
  - [ ] 9.3: Add logging for SEO optimization completion (structured logs)
  - [ ] 9.4: Set up alerts for meta tag validation failures (if > 10/day)
  - [ ] 9.5: Document manual validation process for future reference

## Dev Notes

### Architecture Patterns and Constraints

**Brownfield Customization Strategy (ADR-001):**
- Leverage Forem's existing SEO features (meta tags, canonical URLs) as base
- Extend with custom `Vibecoding::SeoOptimizer` service for enhanced meta tag generation
- No modifications to Forem core files - use partials and concerns
- All customizations namespaced under `vibecoding/`

**Architecture Alignment:**
- **Service Object Pattern (Pattern 3):** SEO logic in `lib/vibecoding/seo_optimizer.rb`
- **Meta Tag Partial:** `app/views/layouts/_meta_tags.html.erb` for rendering
- **Configuration:** `config/initializers/vibecoding_seo.rb` for default settings
- **Caching Strategy:** Fragment caching for meta tags (10-minute TTL)

**SEO Performance Targets (NFR):**
- Meta tag generation: < 50ms overhead per request
- Fragment caching: 10-minute TTL, Russian doll caching for nested JSON-LD
- Database optimization: Eager load associations (Article.includes(:user, :tags))
- LCP impact: Meta tags must not delay LCP (< 2.5s target)

**Security Considerations:**
- **XSS Prevention:** Escape all user-generated content in meta tags (Rails HTML escaping)
- **URL Validation:** Validate canonical URLs and OG image URLs to prevent injection
- **Content Security Policy (CSP):** Allow Schema.org JSON-LD inline scripts with nonce

### Source Tree Components to Touch

**New Files to Create:**

1. **lib/vibecoding/seo_optimizer.rb** (NEW)
   - Purpose: Core SEO service for meta tag and Schema.org generation
   - Methods:
     - `generate_meta_tags(content)` - Returns hash of meta tags
     - `generate_structured_data(content)` - Returns Schema.org JSON-LD
     - `validate_meta_tags(tags)` - Validates tag completeness
   - Dependencies: Article, User, Tag models

2. **app/views/layouts/_meta_tags.html.erb** (NEW or UPDATE)
   - Purpose: Render meta tags in HTML head
   - Includes: Standard meta tags, Open Graph, Twitter Card, Schema.org JSON-LD
   - Called from: `application.html.erb` layout

3. **config/initializers/vibecoding_seo.rb** (NEW)
   - Purpose: Define default SEO settings
   - Configuration: site_name, default_og_image, twitter_handle, keywords

4. **app/assets/images/vibecoding/og-default.png** (NEW)
   - Purpose: Default Open Graph image (1200x630px)
   - Branding: Vibecoding Community logo and colors

**Files to Modify:**

1. **app/views/layouts/application.html.erb** (MODIFY)
   - Add: `<%= render 'layouts/meta_tags', content: @article %>` in `<head>`
   - Location: HTML head section, before closing `</head>`

2. **app/controllers/articles_controller.rb** (POTENTIAL MODIFY)
   - May need to eager load associations for SEO optimization
   - Example: `@article = Article.includes(:user, :tags).find(params[:id])`

**Testing Files to Create:**

1. **spec/lib/vibecoding/seo_optimizer_spec.rb** (NEW)
   - Unit tests for `SeoOptimizer` service methods
   - Test character limits, fallbacks, URL validation

2. **spec/views/layouts/_meta_tags.html.erb_spec.rb** (NEW)
   - View tests for meta tag rendering

3. **spec/requests/seo_meta_tags_spec.rb** (NEW)
   - Integration tests for meta tag presence on article pages

### Testing Standards Summary

**From Tech Spec: Testing Strategy**

**1. Unit Tests (RSpec)**
- Target: `Vibecoding::SeoOptimizer` service methods
- Coverage:
  - `#generate_meta_tags` - Verify correct tag generation for various content types
  - `#generate_structured_data` - Verify valid Schema.org JSON-LD output
  - `#validate_meta_tags` - Test character limits, URL format validation
- Target Coverage: 90%+ for custom SEO code

**2. Integration Tests (RSpec)**
- Target: Meta tag rendering on article pages
- Coverage:
  - Verify all required tags present in HTML head
  - Test fallback values (default OG image, auto-generated descriptions)
  - Test caching behavior

**3. Manual Validation Tests (Required)**
- Schema.org Validator (https://validator.schema.org/) - Paste article URL, verify Article schema validates
- Twitter Card Validator (https://cards-dev.twitter.com/validator) - Test article URL, verify preview
- Facebook Sharing Debugger (https://developers.facebook.com/tools/debug/) - Test article URL, verify OG tags
- LinkedIn Post Inspector (https://www.linkedin.com/post-inspector/) - Test article URL, verify preview
- Google Rich Results Test (https://search.google.com/test/rich-results) - Test for rich result eligibility

**4. Performance Tests**
- Meta Tag Generation Performance: Measure overhead per request (target: < 50ms)
- Test with caching enabled
- Verify fragment cache hit ratio

**Key Test Scenarios:**
1. **Complete Article:** Title, description, image → All meta tags generated correctly
2. **Missing Description:** No description → Auto-generated from body (first 160 chars)
3. **Missing Image:** No main_image → Default OG image used
4. **Long Title:** Title > 60 chars → Truncated with ellipsis
5. **Special Characters:** Title with quotes/ampersands → Properly escaped
6. **Schema Validation:** JSON-LD → Valid at validator.schema.org

### Project Structure Notes

**Alignment with Unified Project Structure:**
- Service location: `lib/vibecoding/seo_optimizer.rb` (follows Pattern 3)
- Partial location: `app/views/layouts/_meta_tags.html.erb` (Rails convention)
- Config location: `config/initializers/vibecoding_seo.rb` (Rails initializer pattern)
- Assets: `app/assets/images/vibecoding/og-default.png` (vibecoding namespace)

**Naming Conventions (from Architecture):**
- Service class: `Vibecoding::SeoOptimizer` (module namespaced, PascalCase)
- Methods: `generate_meta_tags`, `generate_structured_data` (snake_case)
- Partial: `_meta_tags.html.erb` (underscore prefix, snake_case)
- Config constant: `VibeCoding::SEO` (PascalCase module)
- CSS classes: Use Crayons or `.vibecoding-*` prefix

**Dependencies:**
- **Story 1.4 (Custom Theme):** REQUIRED - Default OG image uses Vibecoding brand colors
- **Story 1.6 (About Page):** CONTEXT - Organization schema references About page content
- **Epic 5 (Analytics):** OPTIONAL - SEO metrics will integrate with GA4 tracking

**No Detected Conflicts:** This story is additive (new SEO features), no modifications to existing Forem core meta tag generation. Extends rather than replaces.

### Learnings from Previous Story

**From Story 2-5-built-with-anyon-post-template (Status: drafted)**

Story 2.5 was only drafted but not yet implemented, so there are no concrete file changes or implementation learnings to reference. However, the previous story demonstrates good practices for documentation and planning.

**Key Takeaways for Story 3.1:**
- **Brownfield Approach:** Leverage Forem's existing SEO features rather than rebuilding
- **Configuration Over Code:** Use initializers and partials for flexibility
- **Manual Validation:** External validators (Schema.org, Twitter, Facebook) are critical for SEO quality
- **Fallbacks Are Critical:** Missing descriptions and images must have sensible defaults
- **Performance Matters:** Meta tag generation must be fast (< 50ms) and cacheable

**Expected Architectural Patterns:**
- Service objects for business logic (`Vibecoding::SeoOptimizer`)
- Partials for view rendering (`_meta_tags.html.erb`)
- Initializers for configuration (`vibecoding_seo.rb`)
- Namespacing for custom code (`vibecoding/`, `Vibecoding::`)

**No Predecessor Context:** This is the first story in Epic 3, so no previous story learnings from this epic.

[Source: stories/2-5-built-with-anyon-post-template.md#Status]

### References

**Technical Specifications:**
- [Source: docs/tech-spec-epic-3.md#Story 3.1: SEO Meta Tags & Structured Data] - Detailed acceptance criteria and implementation design
- [Source: docs/tech-spec-epic-3.md#Vibecoding::SeoOptimizer Service] - Service architecture and methods
- [Source: docs/tech-spec-epic-3.md#Meta Tag Partial] - Partial location and structure
- [Source: docs/tech-spec-epic-3.md#APIs & Interfaces → Open Graph Contract] - OG tag format
- [Source: docs/tech-spec-epic-3.md#APIs & Interfaces → Twitter Card Contract] - Twitter Card tag format
- [Source: docs/tech-spec-epic-3.md#APIs & Interfaces → Schema.org JSON-LD Format] - Article schema example

**Epic Context:**
- [Source: docs/epics.md#Story 3.1: SEO Meta Tags & Structured Data] - User story and business value
- [Source: docs/epics.md#Epic 3: SEO & Content Discoverability] - Epic goal and strategy

**Architecture Decisions:**
- [Source: docs/architecture.md#ADR-001: Brownfield Customization Strategy] - Forem extension patterns
- [Source: docs/architecture.md#Pattern 3: Service Object Pattern] - Service implementation guidelines
- [Source: docs/architecture.md#Epic 3 Mapping] - Location and structure for SEO components
- [Source: docs/architecture.md#Consistency Rules] - Naming conventions and code organization

**PRD Requirements:**
- [Source: docs/PRD.md#Web Application Specific Requirements → SEO Requirements] - Server-side rendering, Schema.org, clean URLs
- [Source: docs/PRD.md#Web Application Specific Requirements → Social Sharing] - Open Graph and Twitter Card requirements

**Performance & Security:**
- [Source: docs/tech-spec-epic-3.md#NFR → Performance → Meta Tag Generation] - < 50ms overhead, fragment caching
- [Source: docs/tech-spec-epic-3.md#NFR → Security → Meta Tag Security] - XSS prevention, URL validation, CSP

**Testing Strategy:**
- [Source: docs/tech-spec-epic-3.md#Test Strategy Summary] - Unit tests, integration tests, manual validation
- [Source: docs/tech-spec-epic-3.md#Manual Validation Tests] - External validator requirements

## Dev Agent Record

### Context Reference

<!-- Path(s) to story context XML will be added here by context workflow -->

### Agent Model Used

Claude Sonnet 4.5 (claude-sonnet-4-5-20250929)

### Debug Log References

### Completion Notes List

### File List
