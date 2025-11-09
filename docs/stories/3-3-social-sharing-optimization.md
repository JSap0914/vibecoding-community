# Story 3.3: Social Sharing Optimization

Status: drafted

## Story

As a **Growth Marketer**,
I want beautiful, optimized social sharing previews for all content,
So that shared posts drive maximum engagement and traffic from social media.

## Acceptance Criteria

### Social Share Buttons
1. **AC-3.3.1**: Social share buttons are visible on article pages for:
   - Twitter
   - LinkedIn
   - Facebook
   - Copy Link
   - Buttons are positioned below the article title or at the end of content

### Share URL Generation with UTM Tracking
2. **AC-3.3.2**: When a user clicks a share button, the generated share URL includes UTM parameters:
   - `utm_source=social`
   - `utm_medium={platform}` (twitter, linkedin, facebook)
   - `utm_campaign=organic-share`
   - URL is properly encoded

### Social Share Event Tracking
3. **AC-3.3.3**: When a user clicks a social share button:
   - A GA4 event is tracked with:
     - Event name: `social_share`
     - Parameters: `platform`, `content_id` (article ID), `user_id` (if logged in)
   - Event appears in GA4 real-time reports

### Auto-Generated Social Images
4. **AC-3.3.4**: For articles without custom cover images:
   - Default social image is used with:
     - Vibecoding Community branding
     - Article title overlaid (optional)
     - Dimensions: 1200x630px (Open Graph), 1200x600px (Twitter)
     - Format: PNG or JPEG

### Social Preview Validation
5. **AC-3.3.5**: Social previews validate correctly on:
   - Twitter Card Validator - shows correct preview
   - Facebook Sharing Debugger - shows correct preview
   - LinkedIn Post Inspector - shows correct preview
   - Preview image loads within 3 seconds

## Tasks / Subtasks

- [ ] Task 1: Verify Existing Social Meta Tags (AC: #5)
  - [ ] 1.1: Check if Story 3.1 (SEO Meta Tags) already implemented Open Graph and Twitter Card tags
  - [ ] 1.2: Read existing `app/views/layouts/_meta_tags.html.erb` or similar partial
  - [ ] 1.3: Verify OG tags present: og:title, og:description, og:image, og:url, og:type, og:site_name
  - [ ] 1.4: Verify Twitter Card tags present: twitter:card, twitter:site, twitter:title, twitter:description, twitter:image
  - [ ] 1.5: If missing, note which tags need to be added (Story 3.1 dependency)

- [ ] Task 2: Create Default OG Image Assets (AC: #4)
  - [ ] 2.1: Design default Open Graph image (1200x630px) with vibecoding branding
  - [ ] 2.2: Design default Twitter Card image (1200x600px) with vibecoding branding
  - [ ] 2.3: Optimize images (compress to < 300KB for fast load times)
  - [ ] 2.4: Upload images to `app/assets/images/vibecoding/` directory
  - [ ] 2.5: Add images to asset pipeline (precompile manifest)
  - [ ] 2.6: Store default OG image URL in `config/initializers/vibecoding_seo.rb`

- [ ] Task 3: Implement Social Share Buttons UI (AC: #1)
  - [ ] 3.1: Check if Forem has built-in social share buttons (review existing UI)
  - [ ] 3.2: If existing, customize styling and placement (CSS overrides)
  - [ ] 3.3: If not existing, create `app/javascript/custom/SocialShareButtons.jsx` Preact component
  - [ ] 3.4: Implement share buttons for: Twitter, LinkedIn, Facebook, Copy Link
  - [ ] 3.5: Position buttons below article title or at end of content (user-configurable)
  - [ ] 3.6: Style buttons to match vibecoding theme (use Crayons design system if possible)
  - [ ] 3.7: Add icons for each platform (SVG icons preferred for performance)
  - [ ] 3.8: Implement "Copy Link" button with clipboard API and success toast notification

- [ ] Task 4: Generate Share URLs with UTM Tracking (AC: #2)
  - [ ] 4.1: Create `app/javascript/analytics/social_share_tracker.js` utility module
  - [ ] 4.2: Implement `generateSocialUrl(platform, articleUrl, title)` function
  - [ ] 4.3: Add UTM parameters: utm_source=social, utm_medium={platform}, utm_campaign=organic-share
  - [ ] 4.4: URL-encode share URLs properly (handle special characters)
  - [ ] 4.5: Generate platform-specific share URLs:
    - Twitter: `https://twitter.com/intent/tweet?url={url}&text={title}`
    - LinkedIn: `https://www.linkedin.com/sharing/share-offsite/?url={url}`
    - Facebook: `https://www.facebook.com/sharer/sharer.php?u={url}`
  - [ ] 4.6: Test share URL generation with sample article data

- [ ] Task 5: Implement GA4 Event Tracking (AC: #3)
  - [ ] 5.1: Check if GA4 is already configured (Story 5.1 may provide this)
  - [ ] 5.2: Add `trackShareClick(platform, contentId, userId)` function to `social_share_tracker.js`
  - [ ] 5.3: Fire GA4 event on share button click:
    ```javascript
    gtag('event', 'social_share', {
      platform: platform,
      content_id: contentId,
      user_id: userId
    });
    ```
  - [ ] 5.4: Handle case where GA4 is not loaded (graceful degradation)
  - [ ] 5.5: Test event tracking in GA4 DebugView or real-time reports
  - [ ] 5.6: Document event structure in `docs/analytics-events.md`

- [ ] Task 6: Integrate Share Buttons into Article Views (AC: #1)
  - [ ] 6.1: Identify article view template (`app/views/articles/show.html.erb` or similar)
  - [ ] 6.2: Add share buttons below article title section
  - [ ] 6.3: Add share buttons at end of article content (optional, configurable)
  - [ ] 6.4: Pass article data to component (article URL, title, ID)
  - [ ] 6.5: Ensure buttons work for both logged-in and logged-out users
  - [ ] 6.6: Test responsive layout (mobile, tablet, desktop)

- [ ] Task 7: Ensure Default OG Image Fallback (AC: #4)
  - [ ] 7.1: Update meta tag generation logic (Story 3.1 dependency)
  - [ ] 7.2: Check if `article.main_image` or `article.cover_image` exists
  - [ ] 7.3: If missing, use default OG image from config: `VibeCoding::SEO[:default_og_image]`
  - [ ] 7.4: Ensure both Open Graph and Twitter Card tags use same fallback
  - [ ] 7.5: Test meta tags for articles with and without custom images

- [ ] Task 8: Optional Dynamic Social Image Generation (AC: #4, post-MVP)
  - [ ] 8.1: Decide whether to implement dynamic image generation (see Open Question Q-3.1)
  - [ ] 8.2: If yes, integrate with Cloudinary or similar service
  - [ ] 8.3: Generate images with article title overlay, author name, vibecoding branding
  - [ ] 8.4: Cache generated images (CDN or Cloudinary)
  - [ ] 8.5: Update meta tag generation to use dynamic images
  - [ ] 8.6: Performance test image generation speed (target: < 2 seconds)

- [ ] Task 9: Manual Validation with Social Platform Validators (AC: #5)
  - [ ] 9.1: Test article URL in Twitter Card Validator (https://cards-dev.twitter.com/validator)
  - [ ] 9.2: Verify Twitter preview shows correct title, description, image
  - [ ] 9.3: Test article URL in Facebook Sharing Debugger (https://developers.facebook.com/tools/debug/)
  - [ ] 9.4: Verify Facebook preview shows correct Open Graph data
  - [ ] 9.5: Use "Scrape Again" button to clear Facebook cache if needed
  - [ ] 9.6: Test article URL in LinkedIn Post Inspector (https://www.linkedin.com/post-inspector/)
  - [ ] 9.7: Verify LinkedIn preview renders correctly
  - [ ] 9.8: Test preview image load time (must be < 3 seconds)
  - [ ] 9.9: Document validation results and screenshots

- [ ] Task 10: Unit and Integration Tests (All ACs)
  - [ ] 10.1: Unit test `generateSocialUrl()` function - verify UTM parameter generation
  - [ ] 10.2: Unit test `trackShareClick()` function - mock gtag and verify event structure
  - [ ] 10.3: Component test SocialShareButtons.jsx - verify buttons render
  - [ ] 10.4: Integration test: Click share button → verify URL generated → verify GA4 event fired (mock)
  - [ ] 10.5: Feature test: Verify share buttons appear on article page (Capybara)
  - [ ] 10.6: Test "Copy Link" button functionality with Cypress
  - [ ] 10.7: Test default OG image fallback (articles without images)
  - [ ] 10.8: Test responsive layout of share buttons (mobile, tablet, desktop)

- [ ] Task 11: Performance Testing (NFR)
  - [ ] 11.1: Measure share button render time (target: < 100ms to interactive)
  - [ ] 11.2: Verify JavaScript bundle size increase is minimal (< 5KB gzipped)
  - [ ] 11.3: Test lazy loading of share buttons (if below the fold)
  - [ ] 11.4: Measure social preview image load time (target: < 3 seconds)
  - [ ] 11.5: Test share button clicks don't block UI thread

- [ ] Task 12: Documentation and Monitoring (Post-Implementation)
  - [ ] 12.1: Document share button implementation in `docs/customization-guide.md`
  - [ ] 12.2: Add social share event tracking to `docs/analytics-events.md`
  - [ ] 12.3: Document default OG image creation process for future updates
  - [ ] 12.4: Set up monitoring for social share event tracking (GA4 custom report)
  - [ ] 12.5: Create admin dashboard widget showing social share metrics (optional, Epic 5)

## Dev Notes

### Architecture Patterns and Constraints

**Brownfield Customization Strategy (ADR-001):**
- Forem has built-in social sharing features - verify and customize before building from scratch
- If Forem has share buttons: customize styling and add UTM tracking
- If no built-in solution: create custom Preact component following Forem's component patterns
- All custom code namespaced under `vibecoding/` or `custom/`

**Architecture Alignment:**
- **Component Pattern:** Social share buttons as Preact component (`SocialShareButtons.jsx`)
- **Utility Module:** Share URL generation and tracking in `social_share_tracker.js`
- **Asset Storage:** Default OG images in `app/assets/images/vibecoding/`
- **Configuration:** Default OG image URL stored in `config/initializers/vibecoding_seo.rb`

**Integration with Story 3.1 (SEO Meta Tags):**
- Story 3.1 should have already implemented Open Graph and Twitter Card meta tags
- This story focuses on share button UI and UTM tracking, not meta tag generation
- If meta tags are missing, coordinate with Story 3.1 completion first

**Social Share Workflow (from Tech Spec):**
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

**Performance Targets (NFR):**
- Share button load time: < 100ms to interactive
- JavaScript bundle size: < 5KB gzipped for share functionality
- Social preview image load: < 3 seconds
- Lazy load share buttons if below the fold (optional optimization)

**Security Considerations:**
- **UTM Parameter Validation:** Sanitize UTM parameters to prevent XSS in analytics
- **Share URL Validation:** Validate shared URLs are from vibecoding.com domain (prevent arbitrary URL sharing)
- **XSS Prevention:** Escape all user-generated content in share URLs (article titles)
- **Content Security Policy:** Ensure share dialog popups are allowed by CSP

**Reliability Requirements:**
- **Graceful Degradation:** Share buttons should work even if GA4 tracking fails
- **Fallback for No Image:** Always use default OG image if article has no custom image
- **Error Handling:** Log errors if share URL generation fails, but don't block user action
- **Copy Link Fallback:** If Clipboard API not supported, provide fallback UI (show URL in modal)

### Source Tree Components to Touch

**New Files to Create:**

1. **app/javascript/custom/SocialShareButtons.jsx** (NEW, if Forem doesn't have built-in)
   - Purpose: Preact component for social share buttons (Twitter, LinkedIn, Facebook, Copy Link)
   - Props: `articleUrl`, `articleTitle`, `articleId`, `userId`
   - Renders share button icons with click handlers
   - Calls `social_share_tracker.js` for URL generation and analytics

2. **app/javascript/analytics/social_share_tracker.js** (NEW)
   - Purpose: Utility module for share URL generation and GA4 tracking
   - Functions:
     - `generateSocialUrl(platform, url, title)` - Generate share URL with UTM params
     - `trackShareClick(platform, contentId, userId)` - Track GA4 event
   - No dependencies on React/Preact (vanilla JS)

3. **app/assets/images/vibecoding/og-default.png** (NEW)
   - Purpose: Default Open Graph image (1200x630px)
   - Design: Vibecoding Community branding, gradient background, logo

4. **app/assets/images/vibecoding/twitter-card-default.png** (NEW, optional if same as OG)
   - Purpose: Default Twitter Card image (1200x600px)
   - May be same as og-default.png if aspect ratio acceptable

**Files to Modify:**

1. **app/views/articles/show.html.erb** (MODIFY)
   - Add social share buttons below article title
   - Add social share buttons at end of article content (optional)
   - Pass article data to SocialShareButtons component

2. **config/initializers/vibecoding_seo.rb** (UPDATE or CREATE)
   - Add default OG image URL configuration:
     ```ruby
     VibeCoding::SEO = {
       site_name: "Vibecoding Community",
       default_og_image: "https://vibecoding.com/assets/vibecoding/og-default.png",
       twitter_handle: "@vibecoding"
     }
     ```

3. **app/assets/config/manifest.js** (MODIFY, if needed)
   - Add vibecoding images to asset pipeline:
     ```javascript
     //= link vibecoding/og-default.png
     //= link vibecoding/twitter-card-default.png
     ```

4. **app/views/layouts/_meta_tags.html.erb** (VERIFY/UPDATE, Story 3.1 dependency)
   - Ensure default OG image fallback is used:
     ```erb
     <meta property="og:image" content="<%= @article.main_image || VibeCoding::SEO[:default_og_image] %>" />
     ```

**Testing Files to Create:**

1. **spec/javascript/analytics/social_share_tracker.spec.js** (NEW)
   - Unit tests for `generateSocialUrl()` function
   - Unit tests for `trackShareClick()` function
   - Mock gtag for GA4 event verification

2. **spec/javascript/custom/SocialShareButtons.spec.jsx** (NEW)
   - Component tests for SocialShareButtons
   - Test button rendering for each platform
   - Test click handlers

3. **spec/features/social_sharing_spec.rb** (NEW)
   - Feature test: Share buttons appear on article page
   - Feature test: Click share button generates correct URL
   - Feature test: Copy Link button copies URL to clipboard

4. **cypress/integration/social_sharing.spec.js** (NEW, optional)
   - E2E test: Click share button → verify dialog opens
   - E2E test: Copy Link button functionality
   - E2E test: GA4 event tracking (mock gtag)

### Testing Standards Summary

**From Tech Spec: Testing Strategy**

**1. Unit Tests (Jest for JavaScript)**
- Target: `social_share_tracker.js`, `SocialShareButtons.jsx`
- Coverage:
  - `generateSocialUrl()` - Verify UTM parameter generation for each platform
  - `trackShareClick()` - Verify GA4 event structure (mock gtag)
  - SocialShareButtons component rendering
  - Button click handlers
- Target Coverage: 90%+ for custom code

**2. Integration Tests (RSpec + Capybara)**
- Target: Share button integration with article pages
- Coverage:
  - Share buttons render on article page
  - Share buttons include correct article data (URL, title, ID)
  - Default OG image fallback works when article has no image
  - Meta tags include proper Open Graph and Twitter Card tags

**3. Feature Tests (Capybara/Cypress)**
- Target: End-to-end share workflows
- Coverage:
  - Click Twitter share button → verify URL generated with UTM params
  - Click LinkedIn share button → verify URL format
  - Click Facebook share button → verify URL format
  - Click Copy Link button → verify URL copied to clipboard
  - GA4 event fires on share click (mock gtag)

**4. Manual Validation Tests (Required)**
- **Twitter Card Validator:** Paste article URL, verify preview renders correctly
- **Facebook Sharing Debugger:** Paste article URL, verify Open Graph tags
- **LinkedIn Post Inspector:** Paste article URL, verify preview
- **Image Load Time Test:** Measure time to load social preview images (< 3 seconds)
- **Cross-Browser Test:** Verify share buttons work in Chrome, Firefox, Safari

**Key Test Scenarios:**
1. **Article with Custom Image:** Share button → social preview uses article image
2. **Article without Custom Image:** Share button → social preview uses default OG image
3. **UTM Tracking:** Click share → URL includes utm_source, utm_medium, utm_campaign
4. **GA4 Event Tracking:** Click share → GA4 event fires with correct parameters
5. **Copy Link:** Click Copy Link → URL copied to clipboard → success toast appears
6. **Responsive Design:** Share buttons display correctly on mobile, tablet, desktop

### Project Structure Notes

**Alignment with Unified Project Structure:**
- Component location: `app/javascript/custom/SocialShareButtons.jsx` (Preact component)
- Utility module: `app/javascript/analytics/social_share_tracker.js` (vanilla JS)
- Assets: `app/assets/images/vibecoding/` (vibecoding namespace)
- Configuration: `config/initializers/vibecoding_seo.rb` (custom config)

**Naming Conventions (from Architecture):**
- Component: `SocialShareButtons.jsx` (PascalCase)
- Module: `social_share_tracker.js` (snake_case)
- Functions: `generateSocialUrl()`, `trackShareClick()` (camelCase)
- CSS classes: `.vibecoding-share-button` (kebab-case, namespaced)

**Dependencies:**
- **Story 3.1 (SEO Meta Tags):** REQUIRED - Meta tags must be present for social previews to work
- **Story 1.3 (Deployment Pipeline):** REQUIRED - CDN (Cloudflare) must be configured for image delivery
- **Epic 5 (Analytics):** OPTIONAL - GA4 may not be configured yet (graceful degradation required)

**No Detected Conflicts:** Social sharing is additive (new UI components), no conflicts with existing Forem functionality.

### Learnings from Previous Story

**From Story 3-2-sitemap-generation-search-engine-indexing (Status: drafted)**

Story 3.2 was only drafted but not yet implemented, so there are no concrete file changes or implementation learnings to reference. However, the previous story demonstrates good planning for SEO infrastructure.

**Key Takeaways for Story 3.3:**
- **Brownfield Approach:** Check Forem's built-in social sharing features before building custom solution
- **External API Integration:** Use service objects or utility modules for clean integrations
- **Error Handling:** Implement graceful degradation for external dependencies (GA4)
- **Performance Critical:** Social share buttons must load quickly (< 100ms) to not impact user experience
- **Testing:** Manual validation with platform-specific validators (Twitter, Facebook, LinkedIn) is essential

**Expected Architectural Patterns:**
- Preact component for social share buttons (`SocialShareButtons.jsx`)
- Vanilla JS utility module for share tracking (`social_share_tracker.js`)
- Configuration file for default OG image (`config/initializers/vibecoding_seo.rb`)
- Namespacing for custom code (`vibecoding/`, `custom/`)

**Continuity Notes:**
- Story 3.1 creates meta tag infrastructure - Story 3.3 should leverage those meta tags for social previews
- Story 3.2 uses `lib/vibecoding/` for custom services - Story 3.3 uses `app/javascript/analytics/` for tracking
- Both stories focus on SEO optimization infrastructure - maintain consistent logging format

[Source: stories/3-2-sitemap-generation-search-engine-indexing.md#Status]

### References

**Technical Specifications:**
- [Source: docs/tech-spec-epic-3.md#Story 3.3: Social Sharing Optimization] - Detailed acceptance criteria and implementation design
- [Source: docs/tech-spec-epic-3.md#SocialShareTracking Module] - Share URL generation and GA4 tracking implementation
- [Source: docs/tech-spec-epic-3.md#Workflows → Social Share Click Workflow] - Complete share click process
- [Source: docs/tech-spec-epic-3.md#APIs & Interfaces → Open Graph Meta Tags] - OG tag structure and requirements
- [Source: docs/tech-spec-epic-3.md#APIs & Interfaces → Twitter Card Meta Tags] - Twitter Card tag requirements
- [Source: docs/tech-spec-epic-3.md#NFR → Performance → Social Share Button Load Time] - Performance targets and optimization strategies

**Epic Context:**
- [Source: docs/epics.md#Story 3.3: Social Sharing Optimization] - User story and business value
- [Source: docs/epics.md#Epic 3: SEO & Content Discoverability] - Epic goal and SEO strategy

**Architecture Decisions:**
- [Source: docs/architecture.md#ADR-001: Brownfield Customization Strategy] - Forem extension patterns
- [Source: docs/architecture.md#Pattern 2: Namespaced Customizations] - Naming and file organization guidelines
- [Source: docs/architecture.md#Epic 3 Mapping] - Location and structure for SEO components
- [Source: docs/architecture.md#Consistency Rules → Naming Conventions] - Component, module, and function naming

**PRD Requirements:**
- [Source: docs/PRD.md#Web Application Specific Requirements → Social Sharing] - Share button requirements, UTM tracking
- [Source: docs/PRD.md#Non-Functional Requirements → Performance] - Social button load time targets

**Performance & Security:**
- [Source: docs/tech-spec-epic-3.md#NFR → Performance → Social Share Button Load Time] - < 100ms to interactive, < 5KB gzipped
- [Source: docs/tech-spec-epic-3.md#NFR → Security → Social Sharing Security] - UTM parameter validation, share URL validation
- [Source: docs/tech-spec-epic-3.md#NFR → Observability → Social Sharing Analytics] - GA4 event tracking, UTM parameter tracking

**Testing Strategy:**
- [Source: docs/tech-spec-epic-3.md#Test Strategy Summary → Unit Tests] - Social share tracker unit tests
- [Source: docs/tech-spec-epic-3.md#Test Strategy Summary → Feature Tests] - Share button click tests
- [Source: docs/tech-spec-epic-3.md#Test Strategy Summary → Manual Validation Tests] - Twitter Card Validator, Facebook Sharing Debugger, LinkedIn Post Inspector

## Dev Agent Record

### Context Reference

<!-- Path(s) to story context XML will be added here by context workflow -->

### Agent Model Used

Claude Sonnet 4.5 (claude-sonnet-4-5-20250929)

### Debug Log References

### Completion Notes List

### File List
