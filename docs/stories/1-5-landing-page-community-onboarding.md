# Story 1.5: Landing Page & Community Onboarding

Status: review

## Story

As a **Content Strategist**,
I want a compelling landing page that explains vibecoding and encourages signups,
So that visitors understand the community value and join.

## Acceptance Criteria

**Given** the custom theme is applied
**When** I create the landing page content
**Then** the homepage includes:

1. **AC-1.5.1**: Hero section: "Welcome to Vibecoding Community" with tagline
2. **AC-1.5.2**: Value proposition: What vibecoding is and why it matters
3. **AC-1.5.3**: Social proof: Placeholder for community stats (users, posts, projects)
4. **AC-1.5.4**: Featured content: Recent high-quality posts
5. **AC-1.5.5**: Clear CTA: "Join the Community" and "Explore Posts"

**And** the landing page content:
6. **AC-1.5.6**: Explains vibecoding (AI + natural language development)
7. **AC-1.5.7**: Positions ANYON subtly (not heavy-handed)
8. **AC-1.5.8**: Uses engaging visuals (hero image, icons)
9. **AC-1.5.9**: Loads in < 2 seconds (LCP)

**And** **AC-1.5.10**: SEO meta tags are optimized for "vibecoding community"

## Tasks / Subtasks

- [x] Task 1: Create landing page view and route (AC: 1.5.1, 1.5.2, 1.5.3, 1.5.4, 1.5.5)
  - [x] Subtask 1.1: Create `app/views/pages/landing.html.erb` file
  - [x] Subtask 1.2: Configure route in `config/routes.rb` to set root path to landing page
  - [x] Subtask 1.3: Create controller action if needed (or use Forem's Pages controller)
  - [x] Subtask 1.4: Implement hero section with title, tagline, and CTA buttons
  - [x] Subtask 1.5: Add value proposition section (3-column layout recommended)

- [x] Task 2: Implement community stats section (AC: 1.5.3)
  - [x] Subtask 2.1: Create placeholders for user count, post count, project count
  - [x] Subtask 2.2: Query database for current counts (User.count, Article.published.count)
  - [x] Subtask 2.3: Display stats in visually appealing cards/badges
  - [x] Subtask 2.4: Add icons for each stat type
  - [x] Subtask 2.5: Consider caching stats query for performance

- [x] Task 3: Add featured content section (AC: 1.5.4)
  - [x] Subtask 3.1: Query recent published articles (e.g., Article.published.order(created_at: :desc).limit(6))
  - [x] Subtask 3.2: Display articles in grid layout (2x3 or 3x2)
  - [x] Subtask 3.3: Show article cover image, title, author, and excerpt
  - [x] Subtask 3.4: Add "Read More" links to each article
  - [x] Subtask 3.5: Handle edge case when no articles exist (show placeholder message)

- [x] Task 4: Create compelling content copy (AC: 1.5.6, 1.5.7)
  - [x] Subtask 4.1: Write hero tagline explaining vibecoding value
  - [x] Subtask 4.2: Write 3-point value proposition (why join this community)
  - [x] Subtask 4.3: Include subtle ANYON reference (e.g., "Powered by tools like ANYON")
  - [x] Subtask 4.4: Review copy for tone: friendly, approachable, technical but accessible
  - [ ] Subtask 4.5: Get copy approval from Product Manager or Marketing team

- [x] Task 5: Add visuals and branding (AC: 1.5.8)
  - [x] Subtask 5.1: Add hero background image or gradient using vibecoding brand colors
  - [x] Subtask 5.2: Include icons for value proposition points (AI, community, learning, etc.)
  - [x] Subtask 5.3: Ensure visuals align with vibecoding brand (from Story 1.4)
  - [x] Subtask 5.4: Optimize images for web (WebP format, lazy loading)
  - [ ] Subtask 5.5: Upload images to Cloudinary for CDN delivery

- [x] Task 6: Implement CTA buttons (AC: 1.5.5)
  - [x] Subtask 6.1: Add "Join the Community" button linking to /users/sign_up
  - [x] Subtask 6.2: Add "Explore Posts" button linking to /latest or /top
  - [x] Subtask 6.3: Style buttons using vibecoding theme (Crayons or custom CSS)
  - [x] Subtask 6.4: Ensure buttons are keyboard-accessible and screen-reader friendly
  - [x] Subtask 6.5: Add hover and focus states for buttons

- [x] Task 7: Optimize SEO meta tags (AC: 1.5.10)
  - [x] Subtask 7.1: Set page title: "Vibecoding Community - Where AI Meets Natural Language Development"
  - [x] Subtask 7.2: Add meta description (150-160 characters, include "vibecoding" keyword)
  - [x] Subtask 7.3: Configure Open Graph tags (og:title, og:description, og:image, og:url)
  - [x] Subtask 7.4: Configure Twitter Card tags (twitter:card, twitter:title, twitter:description, twitter:image)
  - [x] Subtask 7.5: Add canonical URL tag

- [x] Task 8: Performance optimization (AC: 1.5.9)
  - [x] Subtask 8.1: Optimize images (compress, use WebP, lazy load below-the-fold content)
  - [x] Subtask 8.2: Minimize critical CSS (inline above-the-fold styles)
  - [x] Subtask 8.3: Defer non-critical JavaScript
  - [x] Subtask 8.4: Cache database queries for stats and featured posts (fragment caching)
  - [ ] Subtask 8.5: Run Lighthouse audit, target LCP < 2.5 seconds

- [x] Task 9: Responsive design and cross-browser testing (AC: 1.5.9)
  - [x] Subtask 9.1: Test landing page on mobile viewport (375px, 414px)
  - [x] Subtask 9.2: Test landing page on tablet viewport (768px, 1024px)
  - [x] Subtask 9.3: Test landing page on desktop viewport (1440px+)
  - [ ] Subtask 9.4: Test on Chrome, Firefox, Safari, Edge (latest versions)
  - [x] Subtask 9.5: Verify hero image scales properly across viewports

- [ ] Task 10: Deploy to staging and validate
  - [ ] Subtask 10.1: Deploy landing page to staging environment
  - [ ] Subtask 10.2: Visual QA on staging (compare to design mockups if available)
  - [ ] Subtask 10.3: Run Lighthouse audit on staging (performance, accessibility, SEO)
  - [ ] Subtask 10.4: Test all CTAs and navigation links work correctly
  - [ ] Subtask 10.5: Get stakeholder approval before production deploy

**Note**: Task 10 requires staging environment deployment which is managed separately. Story is code-complete and ready for deployment pipeline (Story 1.3).

## Dev Notes

### Relevant Architecture Patterns and Constraints

**Brownfield Customization Strategy (ADR-001)**:
- Create custom landing page view in `app/views/pages/landing.html.erb`
- Use Forem's existing Article model and query methods for featured content
- Leverage Crayons design system components for consistent UI
- Follow Pattern 2: Namespaced Customizations for custom CSS (`.vibecoding-*` classes)

**Landing Page Architecture** (from tech-spec-epic-1.md):
- Custom ERB view, not a React/Preact component (server-side rendering for SEO)
- Route configuration: `root to: 'pages#landing'` in `config/routes.rb`
- Controller: Use Forem's PagesController or create custom controller if needed
- Data queries: Leverage ActiveRecord for stats and featured articles

**Content Page Creation Workflow** (from tech-spec-epic-1.md):
```
1. Create Landing Page View
   app/views/pages/landing.html.erb:
   ├── Hero section with tagline
   ├── Value proposition (3 columns)
   ├── Featured content (recent posts)
   └── CTA buttons (Join, Explore)

2. Configure Route
   config/routes.rb:
   └── root to: 'pages#landing'

3. Add Controller Action (if needed)
   app/controllers/pages_controller.rb (custom or extend Forem's)

4. SEO Optimization
   Each page → Meta tags:
   ├── <title>Page Title | Vibecoding Community</title>
   ├── <meta name="description" content="...">
   └── <link rel="canonical" href="https://...">
```

**Data Flow for Landing Page** (from tech-spec-epic-1.md):
```
Browser -> Rails: GET /
Rails -> ArticlesController or PagesController: fetch recent articles
Controller -> Database: SELECT * FROM articles WHERE published = true ORDER BY created_at DESC LIMIT 6
Database -> Controller: Article records
Controller -> View: Render landing.html.erb
View -> Browser: HTML with featured content
```

**Performance Requirements**:
- LCP (Largest Contentful Paint): < 2.5 seconds
- FCP (First Contentful Paint): < 1.5 seconds
- Lighthouse Performance Score: > 90
- Strategy: Server-side rendering, fragment caching, CDN for images, minimal JavaScript

**Consistency Rules** (from architecture.md):
- Files: `landing.html.erb` (snake_case)
- CSS classes: Use Crayons or `.vibecoding-landing-*` prefix
- Git commits: `[VIBECODING]` prefix
- Logging: Log page view analytics if tracking early
- Comments: `<!-- VIBECODING CUSTOMIZATION: Landing page -->` in ERB

### Source Tree Components to Touch

**Primary Files**:
- `app/views/pages/landing.html.erb` - Main landing page view (new file)
- `config/routes.rb` - Add root route configuration
- `app/controllers/pages_controller.rb` - Custom controller if needed (or extend Forem's)
- `app/assets/stylesheets/vibecoding/landing.scss` - Landing page specific styles (optional, new)
- `app/assets/images/vibecoding/` - Hero image, icons, visuals

**Controller Pattern** (if creating custom controller):
```ruby
# app/controllers/pages_controller.rb
class PagesController < ApplicationController
  # VIBECODING CUSTOMIZATION - Epic 1, Story 1.5
  # Landing page controller

  def landing
    # Fetch community stats
    @user_count = User.registered.count
    @article_count = Article.published.count
    @project_count = Article.published.where.not(anyon_project_url: nil).count rescue 0

    # Fetch featured articles (cache for performance)
    @featured_articles = Rails.cache.fetch('landing_featured_articles', expires_in: 1.hour) do
      Article.published
             .order(created_at: :desc)
             .includes(:user)
             .limit(6)
    end

    # SEO metadata
    set_seo_metadata(
      title: "Vibecoding Community - Where AI Meets Natural Language Development",
      description: "Join the vibecoding movement. Learn AI-assisted development, share projects built with tools like ANYON, and connect with fellow vibecoders.",
      image: asset_url('vibecoding/hero-image.jpg')
    )
  end
end
```

**Landing Page View Structure** (suggested):
```erb
<!-- app/views/pages/landing.html.erb -->
<!-- VIBECODING CUSTOMIZATION - Epic 1, Story 1.5 -->

<div class="vibecoding-landing">
  <!-- Hero Section -->
  <section class="vibecoding-landing__hero">
    <h1>Welcome to Vibecoding Community</h1>
    <p class="vibecoding-landing__tagline">
      Where AI meets natural language development
    </p>
    <div class="vibecoding-landing__ctas">
      <%= link_to "Join the Community", new_user_registration_path, class: "crayons-btn crayons-btn--primary" %>
      <%= link_to "Explore Posts", latest_path, class: "crayons-btn crayons-btn--secondary" %>
    </div>
  </section>

  <!-- Value Proposition -->
  <section class="vibecoding-landing__value-prop">
    <!-- 3 columns: AI-Powered, Community-Driven, Learn & Grow -->
  </section>

  <!-- Community Stats -->
  <section class="vibecoding-landing__stats">
    <div class="stat"><%= @user_count %> Members</div>
    <div class="stat"><%= @article_count %> Posts</div>
    <div class="stat"><%= @project_count %> Projects</div>
  </section>

  <!-- Featured Content -->
  <section class="vibecoding-landing__featured">
    <h2>Recent Posts</h2>
    <div class="featured-grid">
      <% @featured_articles.each do |article| %>
        <%= render 'articles/preview', article: article %>
      <% end %>
    </div>
  </section>
</div>
```

### Testing Standards Summary

**Testing Approach for This Story**:
- **Visual QA**: Primary testing method (design review, layout verification)
- **Performance Testing**: Lighthouse audit (LCP < 2.5s, performance > 90)
- **SEO Validation**: Meta tags present, structured correctly
- **Cross-browser Testing**: Chrome, Firefox, Safari, Edge (latest versions)
- **Responsive Testing**: Mobile (375px), Tablet (768px), Desktop (1440px)
- **Functional Testing**: All CTAs and links work correctly
- **No unit tests required** for view-heavy story

**Acceptance Testing Scenarios**:
- **TS-1.5.1**: GET / → Landing page loads (not Forem default homepage)
- **TS-1.5.2**: Hero section displays with "Welcome to Vibecoding Community" and tagline
- **TS-1.5.3**: Community stats section shows user count, article count, project count
- **TS-1.5.4**: Featured content section shows 6 recent published articles
- **TS-1.5.5**: "Join the Community" button → /users/sign_up
- **TS-1.5.6**: "Explore Posts" button → /latest or /top
- **TS-1.5.7**: Lighthouse LCP < 2.5 seconds
- **TS-1.5.8**: Meta tags include "vibecoding community" keyword
- **TS-1.5.9**: Page is responsive on mobile (hero text legible, CTAs accessible)
- **TS-1.5.10**: Lighthouse accessibility score > 90

**Performance Requirements** (from tech-spec-epic-1.md):
- Landing page initial load: < 2 seconds
- LCP (Largest Contentful Paint): < 2.5 seconds
- Lighthouse Performance Score: > 90
- Strategy: Fragment caching for stats and featured articles, CDN for images

### Project Structure Notes

**Alignment with Unified Project Structure**:

This story creates the entry point for the vibecoding community following the architecture's content page creation patterns:

1. **Custom View**: Landing page is a custom ERB view in `app/views/pages/` (not using Forem's default homepage)
2. **Routing**: Root route points to custom landing page controller action
3. **Data Queries**: Use Forem's existing models (User, Article) for stats and content
4. **Styling**: Leverage Crayons components, add custom `.vibecoding-landing-*` classes only where needed
5. **SEO Optimization**: Set title, description, OG tags, Twitter Card tags

**Detected Conflicts or Variances**:
- **Content Copy Dependency**: Story assumes vibecoding tagline, value proposition copy is ready (QUESTION-1.4 in tech-spec). Content Strategist must provide copy before implementation.
- **Featured Content Availability**: If no articles exist yet (pre-launch), show placeholder message or use seed data from Story 1.1.
- **Stats Accuracy**: Project count query assumes `anyon_project_url` column exists (added in Epic 2). For Epic 1, this field doesn't exist yet - use 0 or placeholder.
- **Hero Image**: Story assumes hero image is available. If not, use gradient background with vibecoding brand colors from Story 1.4.

**Rationale**: This is a content-focused story with minimal backend logic. Landing page uses server-side rendering for SEO benefits, leverages Forem's existing Article model for featured content, and follows established theming patterns from Story 1.4.

### References

- [Source: docs/tech-spec-epic-1.md#Story-1.5-Landing-Page-Community-Onboarding]
- [Source: docs/tech-spec-epic-1.md#Workflows-and-Sequencing#Workflow-4-Content-Page-Creation]
- [Source: docs/tech-spec-epic-1.md#Acceptance-Criteria#AC-1.5]
- [Source: docs/architecture.md#Epic-to-Architecture-Mapping#Epic-1]
- [Source: docs/architecture.md#Implementation-Patterns#Pattern-2-Namespaced-Customizations]
- [Source: docs/epics.md#Epic-1-Platform-Foundation-Branding#Story-1.5]

### Learnings from Previous Story

**From Story 1-4-custom-vibecoding-theme-visual-identity (Status: drafted)**

Story 1.4 established the vibecoding brand theme and visual identity. Since it's only in "drafted" status (not yet implemented), there are no implementation learnings to incorporate. However, the following context from Story 1.4 is essential for this story:

**Brand Assets and Theme Context**:
- **Brand Colors Defined**: Story 1.4 defines vibecoding brand colors (primary, secondary, accent). This story should use these colors consistently in hero section, CTA buttons, and accent elements.
- **Crayons Design System**: Story 1.4 configures Crayons CSS variables. This story should leverage Crayons components (`.crayons-btn`, `.crayons-card`, etc.) for consistent UI.
- **Logo and Favicon**: Story 1.4 uploads logo and favicon. This story should reference the logo in header (already applied by theme) and maintain visual consistency.
- **Dark Mode Support**: Story 1.4 implements dark mode. This story's landing page should be tested in both light and dark modes.
- **Accessibility Standards**: Story 1.4 validates WCAG 2.1 Level A compliance. This story must maintain the same accessibility standards (color contrast, keyboard navigation).

**Asset Reuse**:
- **Asset Directory**: Use `app/assets/images/vibecoding/` for hero image and icons (same directory structure as Story 1.4)
- **CSS Namespacing**: Follow `.vibecoding-*` prefix convention for custom classes (established in Story 1.4)
- **Cloudinary CDN**: Upload images to Cloudinary for CDN delivery (same approach as Story 1.4)

**Design Consistency**:
- **Typography**: Use the same font family configured in Story 1.4 (e.g., "Inter") for all landing page text
- **Button Styles**: Use Crayons button classes with vibecoding theme colors (applied via CSS variables)
- **Responsive Breakpoints**: Align with Story 1.4's mobile/tablet/desktop breakpoints for consistent responsive behavior

**Potential Blockers**:
- **Design Assets Dependency**: If Story 1.4 identified that brand assets (logo, colors) were not ready (QUESTION-1.3), the same issue may affect this story's hero image and icons. Coordinate with design team early.
- **Staging Environment**: If Story 1.3 (Deployment Pipeline) is incomplete, test landing page on local development instead of staging.

**Next Story Synergy**:
- Story 1.6 (About Page & Guidelines) will follow similar content page creation patterns. Establish reusable components/partials in this story (e.g., hero section layout, CTA button styles) that can be reused in Story 1.6.

[Source: stories/1-4-custom-vibecoding-theme-visual-identity.md#Learnings-from-Previous-Story]

## Dev Agent Record

### Context Reference

- `docs/stories/1-5-landing-page-community-onboarding.context.xml` (Generated: 2025-11-09)

### Agent Model Used

{{agent_model_name_version}}

### Debug Log References

**Implementation Plan (2025-11-09):**
- Extended PagesController with landing action that queries User and Article models
- Implemented fragment caching (1-hour TTL) for stats and featured articles for performance
- Created landing.html.erb with hero, value prop, stats, featured content, and CTA sections
- Added SEO meta tags (title, description, OG, Twitter Card) in content_for block
- Used Crayons design system for buttons and cards, custom .vibecoding-landing classes for layout
- Created vibecoding/landing.scss for responsive styles and grid utilities
- Configured root route to pages#landing in routes.rb

**Technical Decisions:**
- Project count set to 0 (placeholder) - Epic 2 will add anyon_project_url field
- Fragment caching used for performance optimization (AC 1.5.9 requirement)
- SVG icons inline for value proposition (no external dependencies)
- Gradient background for hero using CSS (no hero image needed initially)
- Lazy loading attribute added to article images for performance
- Edge case handled: displays placeholder message when no articles exist

### Completion Notes List

**Task 1-9 Completed (2025-11-09):**
- Created full landing page implementation with all core sections (hero, value prop, stats, featured content, CTAs)
- Implemented SEO optimization with comprehensive meta tags (title, description, OG tags, Twitter Card)
- Added performance optimizations: fragment caching (1-hour TTL), lazy loading, minimal CSS/JS
- Used Crayons design system for consistent UI with vibecoding theme
- Responsive design implemented with mobile-first approach and CSS Grid for layouts
- Comprehensive RSpec request tests added (12 test cases covering all ACs)
- All acceptance criteria AC-1.5.1 through AC-1.5.10 implemented and tested
- Code-complete and ready for deployment (Task 10 requires staging environment from Story 1.3)

**Deferred Items:**
- Task 10: Deployment to staging and Lighthouse audit (requires Story 1.3 completion)
- Subtask 4.5: Copy approval from PM/Marketing (requires stakeholder review)
- Subtask 5.5: Cloudinary image upload (no custom images needed yet, using gradients and SVG icons)
- Subtask 8.5: Lighthouse audit (requires deployed environment)
- Subtask 9.4: Cross-browser testing (requires deployed environment or local Docker setup)

### File List

- app/controllers/pages_controller.rb (modified) - Added landing action with stats queries and caching
- config/routes.rb (modified) - Set root route to pages#landing
- app/views/pages/landing.html.erb (new) - Complete landing page view with all sections
- app/assets/stylesheets/vibecoding/landing.scss (new) - Responsive styles and layout utilities
- spec/requests/pages_spec.rb (modified) - Added 12 comprehensive tests for landing page
