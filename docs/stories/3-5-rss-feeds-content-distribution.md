# Story 3.5: RSS Feeds & Content Distribution

Status: drafted

## Story

As a **Content Distributor**,
I want RSS feeds for all content streams,
So that users can subscribe and content can be syndicated to external platforms.

## Acceptance Criteria

### Global RSS Feed
1. **AC-3.5.1**: When `/feed.xml` is accessed:
   - A valid RSS 2.0 feed is returned
   - Contains last 50 published articles
   - Item elements include: title, link, description, pubDate, author, guid
   - Channel metadata includes: title ("Vibecoding Community"), description, link, language (en)
   - Full article content or excerpt (configurable)
   - Feed validates at https://validator.w3.org/feed/

### Tag-Specific RSS Feeds
2. **AC-3.5.2**: When `/tags/{tag-name}/feed.xml` is accessed:
   - A valid RSS feed is returned with only articles tagged with {tag-name}
   - Last 50 articles for that tag
   - Channel title: "{Tag Name} | Vibecoding Community"
   - All standard RSS 2.0 elements present
   - Feed validates successfully

### User-Specific RSS Feeds
3. **AC-3.5.3**: When `/{username}/feed.xml` is accessed:
   - A valid RSS feed is returned with only articles authored by {username}
   - Last 50 articles by that user
   - Channel title: "{Username}'s Posts | Vibecoding Community"
   - All standard RSS 2.0 elements present
   - Feed validates successfully

### RSS Autodiscovery Tags
4. **AC-3.5.4**: When any page with an RSS feed is rendered:
   - Autodiscovery link tags are present in HTML `<head>`:
     - Homepage: `<link rel="alternate" type="application/rss+xml" title="Vibecoding Community" href="/feed.xml" />`
     - Tag pages: Include tag-specific feed URL
     - User profile pages: Include user-specific feed URL
   - Multiple feeds can be discovered on a single page (e.g., global + tag)

### RSS Feed Performance
5. **AC-3.5.5**: When RSS feeds are requested:
   - 95th percentile response time < 200ms
   - Feeds are cached for 10 minutes in Rails cache
   - Cache hit ratio > 80%
   - No N+1 database queries (use eager loading)
   - Proper HTTP caching headers (Last-Modified, ETag, Cache-Control)

## Tasks / Subtasks

- [ ] Task 1: Verify Existing Forem RSS Implementation (AC: #1, #2, #3)
  - [ ] 1.1: Check if Forem has built-in RSS feeds at `/feed.xml`, `/feed` routes
  - [ ] 1.2: Test global feed: verify it returns valid RSS 2.0 XML
  - [ ] 1.3: Check for tag-specific feeds: `/tags/{tag}/feed.xml`
  - [ ] 1.4: Check for user-specific feeds: `/{username}/feed.xml` or `/feed/{username}`
  - [ ] 1.5: Review Forem's FeedsController (or similar) source code
  - [ ] 1.6: Validate existing feeds at https://validator.w3.org/feed/
  - [ ] 1.7: Document current RSS functionality and gaps
  - [ ] 1.8: Determine if customization is needed or if Forem's built-in is sufficient

- [ ] Task 2: Implement/Enhance Global RSS Feed (AC: #1, if needed)
  - [ ] 2.1: If Forem feed exists but needs customization, create decorator or override controller
  - [ ] 2.2: Ensure feed includes last 50 published articles (limit query)
  - [ ] 2.3: Verify item elements contain all required fields:
    - `<title>` - Article title
    - `<link>` - Full URL to article (https://vibecoding.com/{slug})
    - `<description>` - Article excerpt or full content
    - `<pubDate>` - RFC 822 formatted publication date
    - `<author>` - Author email or name
    - `<guid>` - Unique identifier (article URL or ID)
  - [ ] 2.4: Add channel metadata:
    - `<title>Vibecoding Community</title>`
    - `<description>The central hub for vibecoders - developers using AI and natural language to build applications</description>`
    - `<link>https://vibecoding.com</link>`
    - `<language>en</language>`
    - `<lastBuildDate>` - Current timestamp
    - `<generator>Forem/Vibecoding</generator>`
  - [ ] 2.5: Configure content mode (full vs excerpt):
    - Add configuration option in `config/vibecoding.yml`: `rss_content_mode: full` or `excerpt`
    - If full: Include entire article HTML in `<description>` (CDATA wrapped)
    - If excerpt: Use first 300 characters or article summary
  - [ ] 2.6: Include article images:
    - Add `<enclosure>` tag for article cover image (main_image)
    - Include inline images in content (if full mode)
  - [ ] 2.7: Add UTM tracking to article links:
    - Append `?utm_source=rss&utm_medium=feed&utm_campaign=global-feed` to link URLs
  - [ ] 2.8: Ensure proper XML escaping for all content
  - [ ] 2.9: Test feed with various RSS readers (Feedly, NewsBlur, RSS reader apps)

- [ ] Task 3: Implement Tag-Specific RSS Feeds (AC: #2)
  - [ ] 3.1: Check if Forem already supports `/tags/{tag-name}/feed.xml`
  - [ ] 3.2: If not, add route: `get 'tags/:tag/feed', to: 'feeds#tag', as: :tag_feed`
  - [ ] 3.3: Implement `FeedsController#tag` action (or extend Forem's existing):
    - Query articles tagged with specified tag
    - Order by published_at DESC
    - Limit to 50 articles
    - Eager load associations (user, tags, main_image)
  - [ ] 3.4: Customize channel metadata for tag feeds:
    - `<title>{Tag Name} | Vibecoding Community</title>`
    - `<description>Latest posts about {tag name} from Vibecoding Community</description>`
    - `<link>https://vibecoding.com/tags/{tag-slug}</link>`
  - [ ] 3.5: Add UTM tracking: `?utm_source=rss&utm_medium=feed&utm_campaign=tag-{tag-name}`
  - [ ] 3.6: Handle tag not found (404 if tag doesn't exist)
  - [ ] 3.7: Test with various tags (vibecoding, anyon, tutorial, etc.)

- [ ] Task 4: Implement User-Specific RSS Feeds (AC: #3)
  - [ ] 4.1: Check if Forem already supports `/{username}/feed.xml`
  - [ ] 4.2: If not, add route: `get ':username/feed', to: 'feeds#user', as: :user_feed`
  - [ ] 4.3: Implement `FeedsController#user` action (or extend Forem's existing):
    - Find user by username (case-insensitive)
    - Query articles authored by user
    - Order by published_at DESC
    - Limit to 50 articles
    - Eager load associations
  - [ ] 4.4: Customize channel metadata for user feeds:
    - `<title>{Username}'s Posts | Vibecoding Community</title>`
    - `<description>Latest posts by {username} on Vibecoding Community</description>`
    - `<link>https://vibecoding.com/{username}</link>`
    - `<image>` - User's profile image
  - [ ] 4.5: Add UTM tracking: `?utm_source=rss&utm_medium=feed&utm_campaign=author-{username}`
  - [ ] 4.6: Handle user not found (404 if user doesn't exist)
  - [ ] 4.7: Test with various user profiles

- [ ] Task 5: Add RSS Autodiscovery Link Tags (AC: #4)
  - [ ] 5.1: Find Forem's application layout: `app/views/layouts/application.html.erb` or base layout
  - [ ] 5.2: Add global feed autodiscovery to all pages (in `<head>`):
    ```erb
    <link rel="alternate" type="application/rss+xml"
          title="Vibecoding Community"
          href="<%= feed_url %>" />
    ```
  - [ ] 5.3: For tag pages (`app/views/tags/show.html.erb` or similar):
    - Add tag-specific feed link:
      ```erb
      <link rel="alternate" type="application/rss+xml"
            title="<%= @tag.name %> | Vibecoding Community"
            href="<%= tag_feed_url(@tag.name) %>" />
      ```
  - [ ] 5.4: For user profile pages:
    - Add user-specific feed link:
      ```erb
      <link rel="alternate" type="application/rss+xml"
            title="<%= @user.name %>'s Posts"
            href="<%= user_feed_url(@user.username) %>" />
      ```
  - [ ] 5.5: Verify autodiscovery works in browsers (RSS icon appears in address bar)
  - [ ] 5.6: Test with RSS reader applications (should auto-detect feeds)

- [ ] Task 6: Implement RSS Feed UI Promotion (AC: #4, UX)
  - [ ] 6.1: Add RSS icon to footer:
    - Create "Subscribe" section in footer
    - Add RSS icon (SVG) with link to `/feed.xml`
    - Text: "Subscribe to our RSS feed"
  - [ ] 6.2: Add feed links to tag pages:
    - Display RSS icon/link near tag description
    - Label: "Subscribe to {Tag} posts"
    - Link to tag-specific feed
  - [ ] 6.3: Add feed links to user profiles:
    - Display RSS icon near user bio or post list
    - Label: "Subscribe to {Username}'s posts"
    - Link to user-specific feed
  - [ ] 6.4: Create RSS subscriber documentation page:
    - Path: `/pages/rss` or `/about/rss`
    - Explain what RSS is and how to subscribe
    - List available feeds (global, tag-specific, user-specific)
    - Recommend RSS readers (Feedly, Inoreader, NetNewsWire, etc.)
    - Provide example RSS reader setup instructions
  - [ ] 6.5: Link to RSS docs from footer and About page

- [ ] Task 7: Optimize RSS Feed Performance (AC: #5)
  - [ ] 7.1: Implement Rails fragment caching for feeds:
    ```ruby
    cache ["feed-v1", Article.maximum(:updated_at)], expires_in: 10.minutes do
      # Generate feed XML
    end
    ```
  - [ ] 7.2: Use eager loading to prevent N+1 queries:
    ```ruby
    articles = Article.published
                      .includes(:user, :tags, :main_image)
                      .limit(50)
                      .order(published_at: :desc)
    ```
  - [ ] 7.3: Add HTTP caching headers in controller:
    ```ruby
    response.headers['Cache-Control'] = 'public, max-age=600' # 10 minutes
    response.headers['Last-Modified'] = @articles.first.updated_at.httpdate if @articles.any?
    etag @articles.map(&:cache_key_with_version).join('-')
    ```
  - [ ] 7.4: Set proper content type and charset:
    ```ruby
    response.content_type = 'application/rss+xml; charset=utf-8'
    ```
  - [ ] 7.5: Optimize database query performance:
    - Verify index on `articles.published_at` exists
    - Add index on `taggings` if tag queries are slow
    - Monitor query execution time (< 50ms target)
  - [ ] 7.6: Test cache hit ratio:
    - Monitor Rails cache hit/miss in logs
    - Verify > 80% cache hit ratio under load
  - [ ] 7.7: Load test RSS feeds:
    - Use k6 or Apache JMeter
    - Simulate 100 concurrent requests
    - Measure p95 response time (target: < 200ms)

- [ ] Task 8: Add Atom Feed Support (Optional Enhancement)
  - [ ] 8.1: Decide if Atom format is needed (check Forem's defaults)
  - [ ] 8.2: If yes, implement Atom 1.0 feeds in addition to RSS 2.0
  - [ ] 8.3: Add routes: `/feed.atom`, `/tags/{tag}/feed.atom`, etc.
  - [ ] 8.4: Implement Atom XML generation (Rails has built-in atom_feed helper)
  - [ ] 8.5: Add Atom autodiscovery links in addition to RSS
  - [ ] 8.6: Validate Atom feeds at W3C validator

- [ ] Task 9: RSS Feed Security and Validation (All ACs)
  - [ ] 9.1: Validate XML output:
    - Ensure all user-generated content is properly escaped
    - Use CDATA sections for HTML content
    - Prevent XML injection attacks
  - [ ] 9.2: Implement rate limiting for RSS feeds:
    ```ruby
    # config/initializers/rack_attack.rb (Forem likely has this)
    throttle('rss/ip', limit: 60, period: 1.minute) do |req|
      req.ip if req.path.match?(/feed\.xml/)
    end
    ```
  - [ ] 9.3: Validate feed URLs are internal (no open redirects)
  - [ ] 9.4: Test with malicious content:
    - Article titles with XML special characters (<, >, &, ', ")
    - Article content with CDATA end markers (]]>)
    - Very long content (ensure no truncation issues)
  - [ ] 9.5: Ensure private/unpublished articles are excluded from feeds
  - [ ] 9.6: Verify feeds only include publicly visible content

- [ ] Task 10: RSS Feed Monitoring and Analytics (Observability)
  - [ ] 10.1: Add logging for feed requests:
    ```ruby
    Rails.logger.info("VIBECODING: RSS feed requested",
      feed_type: params[:feed_type],
      user_agent: request.user_agent,
      cache_hit: cache_hit?,
      response_time_ms: elapsed_time
    )
    ```
  - [ ] 10.2: Track feed subscriber count (if possible):
    - Use FeedBurner (Google service, free)
    - Or count unique IPs requesting feeds per week
    - Log user agents to identify popular RSS readers
  - [ ] 10.3: Create admin dashboard metric (optional, Epic 5):
    - Feed requests per day
    - Most popular feeds (global vs tag-specific)
    - Cache hit ratio
    - Average response time
  - [ ] 10.4: Monitor feed errors in Sentry:
    - XML generation failures
    - Database query timeouts
    - Cache failures

- [ ] Task 11: Unit and Integration Tests (All ACs)
  - [ ] 11.1: Unit test FeedsController actions (RSpec):
    - Test global feed returns 50 articles
    - Test tag feed filters by tag correctly
    - Test user feed filters by user correctly
    - Test feed returns 404 for invalid tag/user
    - Test eager loading (no N+1 queries)
  - [ ] 11.2: Integration test RSS XML structure:
    - Verify RSS 2.0 XML is valid
    - Check all required elements present (<channel>, <item>, etc.)
    - Validate date formatting (RFC 822)
    - Test XML escaping of special characters
  - [ ] 11.3: Integration test feed caching:
    - First request generates feed (cache miss)
    - Second request uses cache (cache hit)
    - Cache expires after 10 minutes
    - Cache invalidates when new article published
  - [ ] 11.4: Feature test autodiscovery links:
    - Homepage has global feed link in <head>
    - Tag page has tag feed link
    - User profile has user feed link
  - [ ] 11.5: Performance test feed response times:
    - Measure p95 response time < 200ms
    - Test with 50 articles (full dataset)
    - Verify cache hit ratio > 80% after warmup

- [ ] Task 12: W3C Feed Validation and RSS Reader Testing
  - [ ] 12.1: Validate all feeds at https://validator.w3.org/feed/:
    - Global feed: /feed.xml
    - Tag feed example: /tags/vibecoding/feed.xml
    - User feed example: /{username}/feed.xml
    - Fix any validation errors or warnings
  - [ ] 12.2: Test feeds in RSS readers:
    - Feedly: Subscribe to global feed, verify articles appear
    - NewsBlur: Test tag-specific feed
    - Apple Podcasts / Overcast (if podcast features added)
    - Browser-based readers (Chrome RSS extensions)
  - [ ] 12.3: Test feed content rendering:
    - Verify images display correctly
    - Check HTML formatting (if full content mode)
    - Ensure links are clickable and UTM params work
  - [ ] 12.4: Test feed updates:
    - Publish new article
    - Verify it appears in feed within cache TTL (10 min)
    - Check feed readers auto-update

- [ ] Task 13: Documentation and Runbook
  - [ ] 13.1: Document RSS feed implementation in `docs/customization-guide.md`:
    - Feed URLs and patterns
    - Configuration options (full vs excerpt)
    - Caching strategy
    - Performance targets
  - [ ] 13.2: Document feed promotion strategy:
    - Where feed links appear (footer, tag pages, profiles)
    - How to add new feed types (future enhancement)
  - [ ] 13.3: Create RSS subscriber guide (user-facing):
    - What is RSS and why subscribe?
    - Available feeds (global, tag, user)
    - Recommended RSS readers
    - Troubleshooting feed issues
  - [ ] 13.4: Create admin runbook:
    - How to check feed health
    - How to clear feed cache manually
    - How to debug feed errors
    - Feed performance monitoring

## Dev Notes

### Architecture Patterns and Constraints

**Brownfield Customization Strategy (ADR-001):**
- Forem likely has built-in RSS feeds - verify first before implementing custom solution
- RSS feeds are a core Forem feature (used by DEV.to), so customization may be minimal
- Extend Forem's existing FeedsController if customization needed
- All custom code namespaced under `vibecoding/` or extend via concerns

**Architecture Alignment:**
- **Location:** `app/controllers/feeds_controller.rb` (Forem existing, may extend)
- **Views:** `app/views/feeds/` (XML templates using Rails builder)
- **Services:** No custom services needed unless complex feed logic required
- **Configuration:** `config/vibecoding.yml` for RSS-specific settings (content mode, cache TTL)

**RSS Feed Requirements (from Tech Spec):**
- **Format:** RSS 2.0 (industry standard)
- **Optional:** Atom 1.0 format (if Forem supports or needed)
- **Content:** Full HTML content or excerpt (configurable)
- **Limit:** Last 50 articles per feed
- **Performance:** < 200ms p95, 10-min cache, > 80% hit ratio

**Feed Types to Implement:**
1. **Global Feed:** `/feed.xml` - All published articles
2. **Tag Feed:** `/tags/{tag}/feed.xml` - Tag-filtered articles
3. **User Feed:** `/{username}/feed.xml` - User-authored articles

**RSS 2.0 XML Structure (Expected):**
```xml
<?xml version="1.0" encoding="UTF-8"?>
<rss version="2.0" xmlns:atom="http://www.w3.org/2005/Atom">
  <channel>
    <title>Vibecoding Community</title>
    <link>https://vibecoding.com</link>
    <description>The central hub for vibecoders...</description>
    <language>en</language>
    <lastBuildDate>Mon, 10 Nov 2025 12:00:00 +0000</lastBuildDate>
    <atom:link href="https://vibecoding.com/feed.xml" rel="self" type="application/rss+xml" />

    <item>
      <title>Building a SaaS App with ANYON</title>
      <link>https://vibecoding.com/building-saas-app-anyon?utm_source=rss&amp;utm_medium=feed</link>
      <description><![CDATA[Full article HTML content...]]></description>
      <pubDate>Mon, 10 Nov 2025 10:00:00 +0000</pubDate>
      <author>author@vibecoding.com (John Vibecoder)</author>
      <guid isPermaLink="true">https://vibecoding.com/building-saas-app-anyon</guid>
      <enclosure url="https://cdn.vibecoding.com/posts/saas-anyon.png" length="0" type="image/png" />
    </item>
    <!-- More items... -->
  </channel>
</rss>
```

**Performance Targets (NFR from Tech Spec):**
- **Response Time:** p95 < 200ms
- **Caching:** 10 minutes TTL in Rails cache
- **Cache Hit Ratio:** > 80%
- **Database Query:** < 50ms (with eager loading, no N+1)
- **Content Mode:** Configurable (full HTML vs excerpt)

### Source Tree Components to Touch

**Files to Verify/Modify:**

1. **app/controllers/feeds_controller.rb** (Forem existing, verify first)
   - Check if global feed exists (`index` action)
   - Check if tag feed exists (`tag` or `show` action)
   - Check if user feed exists (`user` action)
   - May need to extend with decorators or override actions

2. **config/routes.rb** (Forem existing, may extend)
   - Verify routes: `get '/feed', to: 'feeds#index'` (or similar)
   - May need to add: `get 'tags/:tag/feed', to: 'feeds#tag'`
   - May need to add: `get ':username/feed', to: 'feeds#user'`

3. **app/views/feeds/** (Forem existing, verify templates)
   - Check for RSS XML templates (`.rss.builder` or `.xml.erb`)
   - May use Rails `xml.rss` builder
   - Customize channel metadata (title, description)
   - Ensure UTM tracking on links

4. **app/views/layouts/application.html.erb** (MODIFY via partial)
   - Add RSS autodiscovery link tags in `<head>`
   - Use partial: `app/views/layouts/_rss_links.html.erb`

5. **app/views/tags/show.html.erb** (MODIFY)
   - Add tag-specific feed link in `<head>`
   - Add RSS icon/link in tag page UI

6. **app/views/users/show.html.erb** (MODIFY, or user profile template)
   - Add user-specific feed link in `<head>`
   - Add RSS icon/link in user profile UI

7. **app/views/layouts/_footer.html.erb** (MODIFY)
   - Add "Subscribe" section with RSS icon
   - Link to global feed and RSS documentation

8. **config/vibecoding.yml** (CREATE or UPDATE)
   - Add RSS configuration:
     ```yaml
     rss:
       content_mode: full  # or "excerpt"
       cache_ttl_minutes: 10
       items_per_feed: 50
     ```

9. **config/initializers/vibecoding_customizations.rb** (UPDATE if needed)
   - Include any RSS-related configurations
   - Override Forem defaults if necessary

**Files to Create (if needed):**

1. **app/views/pages/rss.html.erb** (NEW)
   - Purpose: RSS subscriber documentation page
   - Content: What is RSS, how to subscribe, available feeds, recommended readers

2. **app/views/layouts/_rss_links.html.erb** (NEW, optional)
   - Purpose: Partial for RSS autodiscovery links
   - Used in application layout, tag pages, user profiles

**Testing Files to Create:**

1. **spec/requests/feeds_spec.rb** (NEW or UPDATE)
   - Request specs for FeedsController actions
   - Test global, tag, user feeds
   - Verify HTTP headers, caching, response codes

2. **spec/views/feeds/index.rss.builder_spec.rb** (NEW, if using builder)
   - Test RSS XML generation
   - Verify all required elements present

3. **spec/features/rss_feeds_spec.rb** (NEW)
   - Feature test: Autodiscovery links present
   - Feature test: RSS icons visible on pages
   - Feature test: Feeds accessible via browser

4. **spec/performance/feeds_performance_spec.rb** (NEW, optional)
   - Performance test: Measure feed response times
   - Test cache hit ratio

### Testing Standards Summary

**From Tech Spec: Testing Strategy**

**1. Unit Tests (RSpec)**
- Target: FeedsController actions, feed generation logic
- Coverage:
  - Global feed returns correct articles (limit 50, published only)
  - Tag feed filters by tag correctly
  - User feed filters by user correctly
  - Feed returns 404 for invalid tag/user
  - Eager loading (no N+1 queries)
  - HTTP headers (Cache-Control, Last-Modified, ETag)
- Target Coverage: 90%+ for custom feed code

**2. Integration Tests (RSpec)**
- Target: RSS XML generation, caching behavior
- Coverage:
  - RSS 2.0 XML structure validation
  - Required elements present (<channel>, <item>, <title>, <link>, <description>, etc.)
  - Date formatting (RFC 822: "Mon, 10 Nov 2025 12:00:00 +0000")
  - XML escaping of special characters (<, >, &, ', ")
  - CDATA sections for HTML content
  - Feed caching (miss, hit, expiration, invalidation)

**3. Feature Tests (Capybara)**
- Target: End-to-end RSS discovery and access
- Coverage:
  - Homepage has global feed autodiscovery link
  - Tag page has tag feed link (both autodiscovery and UI)
  - User profile has user feed link
  - RSS icons visible in footer
  - Feed documentation page accessible

**4. Performance Tests (k6 or JMeter)**
- Target: NFR validation
- Coverage:
  - Feed response time p95 < 200ms (with 50 articles)
  - Cache hit ratio > 80% (after warmup period)
  - Database query time < 50ms (with indexes)
  - Load test: 100 concurrent requests

**5. Manual Validation (W3C Feed Validator)**
- Tool: https://validator.w3.org/feed/
- Validate:
  - Global feed: /feed.xml
  - Tag feed example: /tags/vibecoding/feed.xml
  - User feed example: /{username}/feed.xml
- Fix all errors and warnings

**6. RSS Reader Compatibility Testing**
- Test feeds in popular RSS readers:
  - **Feedly** - Web-based, most popular
  - **NewsBlur** - Web and mobile
  - **Inoreader** - Advanced features
  - **NetNewsWire** - macOS/iOS native
  - **Thunderbird** - Desktop client
- Verify:
  - Feeds can be subscribed to
  - Articles display correctly
  - Images load properly
  - Links work with UTM tracking

**Key Test Scenarios:**
1. **Global Feed:** Access /feed.xml → verify 50 most recent published articles
2. **Tag Feed:** Access /tags/vibecoding/feed.xml → verify only vibecoding-tagged articles
3. **User Feed:** Access /{username}/feed.xml → verify only user's articles
4. **Autodiscovery:** View homepage source → verify `<link rel="alternate" type="application/rss+xml">` present
5. **Caching:** Request feed twice → first is cache miss, second is cache hit
6. **Performance:** Load test 100 concurrent requests → p95 < 200ms
7. **Validation:** Paste feed URL into W3C validator → no errors
8. **RSS Reader:** Subscribe in Feedly → articles appear correctly

### Project Structure Notes

**Alignment with Unified Project Structure:**
- Controllers: `app/controllers/feeds_controller.rb` (Forem existing, may extend)
- Views: `app/views/feeds/` (RSS XML templates)
- Configuration: `config/vibecoding.yml` (RSS settings)
- Routes: `config/routes.rb` (feed URL patterns)
- Tests: `spec/requests/feeds_spec.rb`, `spec/features/rss_feeds_spec.rb`

**Naming Conventions (from Architecture):**
- Controller: `FeedsController` (Forem standard)
- Actions: `index` (global), `tag` (tag-specific), `user` (user-specific)
- Routes: `/feed.xml`, `/tags/:tag/feed.xml`, `/:username/feed.xml`
- Views: `index.rss.builder` or `index.xml.erb`
- Configuration keys: `rss.content_mode`, `rss.cache_ttl_minutes`

**Dependencies:**
- **Story 3.4 (Content URL Structure):** REQUIRED - Clean URLs needed for feed item links
- **Story 3.1 (SEO Meta Tags):** OPTIONAL - Canonical URLs helpful for feed items
- **Epic 1 (Platform Foundation):** REQUIRED - Forem must be deployed and functional
- **Epic 5 (Analytics):** OPTIONAL - UTM tracking ties into GA4 (can implement in parallel)

**No Detected Conflicts:** RSS feeds are a standard feature, well-supported by Forem and Rails. Minimal risk of conflicts.

### Learnings from Previous Story

**From Story 3-4-content-url-structure-internal-linking (Status: drafted)**

Story 3.4 was drafted but not yet implemented. However, it demonstrates consistent architectural patterns:

**Architectural Patterns to Maintain:**
1. **Service Objects:** Use `lib/vibecoding/` for custom business logic (e.g., `RelatedPostsFinder`)
2. **Concerns:** Use `app/models/concerns/` for model extensions
3. **Configuration:** Use `config/initializers/vibecoding_seo.rb` or `config/vibecoding.yml` for settings
4. **Namespacing:** Prefix all custom code with `vibecoding`, `custom`, or `anyon`
5. **Logging:** Use structured logging with "VIBECODING:" prefix

**Story 3.4 Key Patterns:**
- Created service objects in `lib/vibecoding/` (`RelatedPostsFinder`, `RelatedTagsFinder`)
- Used concerns to extend Article model (`SlugRedirectTracking`)
- Leveraged Forem's existing features (FriendlyId for slug generation)
- Implemented caching for performance (1-hour TTL for related posts)
- Used Rails fragment caching for partials

**Continuity for Story 3.5:**
- **Verify Existing Functionality First:** Check Forem's built-in RSS before implementing custom solution
- **Extend, Don't Replace:** If Forem has RSS, customize it rather than rebuilding
- **Caching Pattern:** Use Rails fragment caching with 10-minute TTL (similar to Story 3.4)
- **Performance Optimization:** Eager load associations to prevent N+1 queries
- **Configuration Pattern:** Use `config/vibecoding.yml` for RSS settings (content_mode, cache_ttl)
- **Logging Pattern:** Use structured logging with "VIBECODING:" prefix for feed requests
- **Testing:** Mix of unit tests (RSpec), feature tests (Capybara), and manual validation (W3C)

**Expected Flow Based on Previous Stories:**
1. Check if Forem has built-in RSS feeds (likely yes, Forem powers DEV.to which has RSS)
2. If existing, verify functionality and customize as needed
3. If gaps exist, extend FeedsController or create custom actions
4. Namespace all custom code appropriately
5. Implement comprehensive tests (unit, integration, feature)
6. Validate with W3C Feed Validator
7. Document in `docs/customization-guide.md`

[Source: stories/3-4-content-url-structure-internal-linking.md#Dev-Notes]

### References

**Technical Specifications:**
- [Source: docs/tech-spec-epic-3.md#Story 3.5: RSS Feeds & Content Distribution] - Detailed acceptance criteria (AC-3.5.1 through AC-3.5.5)
- [Source: docs/tech-spec-epic-3.md#Workflows → RSS Feed Request Workflow] - Complete feed request and caching flow
- [Source: docs/tech-spec-epic-3.md#NFR → Performance → RSS Feed Response Time] - Performance targets (< 200ms p95, 10-min cache, > 80% hit ratio)
- [Source: docs/tech-spec-epic-3.md#Detailed Design → RSS Feed Controllers] - FeedsController endpoints and output formats

**Epic Context:**
- [Source: docs/epics.md#Story 3.5: RSS Feeds & Content Distribution] - User story and feed requirements
- [Source: docs/epics.md#Epic 3: SEO & Content Discoverability] - Epic goal and organic growth strategy

**Architecture Decisions:**
- [Source: docs/architecture.md#ADR-001: Brownfield Customization Strategy] - Forem extension patterns for RSS feeds
- [Source: docs/architecture.md#Pattern 1: Forem Extension (NOT Modification)] - Extension via concerns and decorators
- [Source: docs/architecture.md#Epic 3: SEO & Content Discoverability] - Location and service mapping for RSS feeds
- [Source: docs/architecture.md#Technology Stack → Core Technologies] - Rails, Preact, Redis for caching

**PRD Requirements:**
- [Source: docs/PRD.md#Functional Requirements → Content Discovery & Engagement → RSS Feeds] - RSS feed types and content requirements
- [Source: docs/PRD.md#Web Application Specific Requirements → SEO Requirements] - Feed promotion and subscriber tracking
- [Source: docs/PRD.md#Non-Functional Requirements → Performance] - Response time targets for feeds

**Performance & Security:**
- [Source: docs/tech-spec-epic-3.md#NFR → Performance → RSS Feed Response Time] - < 200ms p95, 10-min cache, > 80% hit ratio
- [Source: docs/tech-spec-epic-3.md#NFR → Security → Meta Tag Security] - XML escaping and XSS prevention patterns
- [Source: docs/tech-spec-epic-3.md#NFR → Reliability → RSS Feed Availability] - Cache fallback and rate limiting strategies

**Testing Strategy:**
- [Source: docs/tech-spec-epic-3.md#Test Strategy Summary → Unit Tests] - FeedsController testing patterns
- [Source: docs/tech-spec-epic-3.md#Test Strategy Summary → Integration Tests] - RSS XML validation and caching tests
- [Source: docs/tech-spec-epic-3.md#Test Strategy Summary → Manual Validation Tests] - W3C Feed Validator, RSS reader testing

## Dev Agent Record

### Context Reference

<!-- Path(s) to story context XML will be added here by context workflow -->

### Agent Model Used

Claude Sonnet 4.5 (claude-sonnet-4-5-20250929)

### Debug Log References

### Completion Notes List

### File List
