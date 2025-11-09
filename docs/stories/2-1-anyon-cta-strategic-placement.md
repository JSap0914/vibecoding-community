# Story 2.1: ANYON CTA Strategic Placement

Status: drafted

## Story

As a **Growth Manager**,
I want strategically placed "Try ANYON" calls-to-action throughout the platform,
So that interested community members can easily discover and try ANYON.

## Acceptance Criteria

**Given** the foundation platform is deployed
**When** I implement ANYON CTAs
**Then** the following CTAs are visible and functional:

1. **AC-2.1.1**: Header: "Try ANYON" button (non-intrusive, visible on all pages)
2. **AC-2.1.2**: Sidebar widget: "Build with ANYON" on post pages (right rail)
3. **AC-2.1.3**: Footer: "Powered by ANYON" with logo and link
4. **AC-2.1.4**: Post-signup page: "Optional: Link your ANYON account"

**And** all CTAs:
5. **AC-2.1.5**: Include UTM tracking parameters (utm_source=community, utm_medium=cta, utm_campaign=<location>)
6. **AC-2.1.6**: Open ANYON signup in new tab
7. **AC-2.1.7**: Have consistent branding (colors, typography)
8. **AC-2.1.8**: Track click events in Google Analytics

**And** CTAs are not intrusive (no popups, modals, or interstitials)

## Tasks / Subtasks

- [ ] Task 1: Create AnyonCTA Preact component (AC: 2.1.5, 2.1.6, 2.1.7, 2.1.8)
  - [ ] Subtask 1.1: Create `app/javascript/anyon/components/AnyonCTA.jsx`
  - [ ] Subtask 1.2: Implement props: `location`, `ctaText`, `className`, `utmCampaign`
  - [ ] Subtask 1.3: Build ANYON signup URL with UTM parameters
  - [ ] Subtask 1.4: Add click event tracking (GA4 event: `cta_click`)
  - [ ] Subtask 1.5: Apply consistent vibecoding branding (colors, fonts)
  - [ ] Subtask 1.6: Set `target="_blank"` and `rel="noopener noreferrer"` for security
  - [ ] Subtask 1.7: Test component renders correctly in Storybook (optional) or local dev

- [ ] Task 2: Implement header CTA (AC: 2.1.1)
  - [ ] Subtask 2.1: Locate Forem header layout file: `app/views/layouts/_header.html.erb`
  - [ ] Subtask 2.2: Add AnyonCTA component to header navigation (right side, after search)
  - [ ] Subtask 2.3: Set props: `location="header"`, `ctaText="Try ANYON"`, `utmCampaign="header"`
  - [ ] Subtask 2.4: Ensure button is visible on all pages (logged in/out)
  - [ ] Subtask 2.5: Test header CTA on desktop (1920px, 1440px, 1024px widths)
  - [ ] Subtask 2.6: Test header CTA on mobile (375px, 414px widths)
  - [ ] Subtask 2.7: Verify CTA doesn't break responsive header layout
  - [ ] Subtask 2.8: Test dark mode rendering

- [ ] Task 3: Implement sidebar widget (AC: 2.1.2)
  - [ ] Subtask 3.1: Create sidebar widget partial: `app/views/anyon/_build_with_anyon_widget.html.erb`
  - [ ] Subtask 3.2: Add widget content: "Build with ANYON" headline, brief description, CTA button
  - [ ] Subtask 3.3: Use AnyonCTA component with `location="sidebar"`, `ctaText="Get Started"`, `utmCampaign="sidebar"`
  - [ ] Subtask 3.4: Locate Forem article show layout: `app/views/articles/_sidebar.html.erb`
  - [ ] Subtask 3.5: Inject widget in right sidebar (below author info, above related posts)
  - [ ] Subtask 3.6: Ensure widget only shows on post pages (not homepage, tags, profiles)
  - [ ] Subtask 3.7: Test sidebar widget on desktop (right rail)
  - [ ] Subtask 3.8: Verify widget stacks correctly on mobile (below post content)

- [ ] Task 4: Implement footer CTA (AC: 2.1.3)
  - [ ] Subtask 4.1: Locate Forem footer layout file: `app/views/layouts/_footer.html.erb`
  - [ ] Subtask 4.2: Add "Powered by ANYON" section to footer (separate from footer links)
  - [ ] Subtask 4.3: Include ANYON logo (SVG or PNG from `app/assets/images/vibecoding/`)
  - [ ] Subtask 4.4: Use AnyonCTA component with `location="footer"`, `ctaText="Learn More"`, `utmCampaign="footer"`
  - [ ] Subtask 4.5: Style footer section (subtle, not overpowering footer navigation)
  - [ ] Subtask 4.6: Test footer CTA on all pages (homepage, posts, profiles, tags)
  - [ ] Subtask 4.7: Verify footer is responsive (mobile, tablet, desktop)

- [ ] Task 5: Implement post-signup account linking prompt (AC: 2.1.4)
  - [ ] Subtask 5.1: Locate Forem post-signup flow (typically `/onboarding` or redirect after signup)
  - [ ] Subtask 5.2: Check if Forem has onboarding steps feature (Admin Panel → Config → Onboarding)
  - [ ] Subtask 5.3: If onboarding steps exist, add custom step: "Link Your ANYON Account (Optional)"
  - [ ] Subtask 5.4: If no onboarding steps, create `app/views/users/post_signup.html.erb` view
  - [ ] Subtask 5.5: Add prompt: "Want to showcase your ANYON projects? Link your account"
  - [ ] Subtask 5.6: Use AnyonCTA component with `location="post_signup"`, `ctaText="Link ANYON Account"`, `utmCampaign="signup"`
  - [ ] Subtask 5.7: Add "Skip" or "Maybe Later" option (not forced)
  - [ ] Subtask 5.8: Test post-signup flow for new users

- [ ] Task 6: Configure UTM tracking and Google Analytics events (AC: 2.1.5, 2.1.8)
  - [ ] Subtask 6.1: Create `Anyon::ConversionTracker` service: `app/services/anyon/conversion_tracker.rb`
  - [ ] Subtask 6.2: Implement `track_cta_click(user, location, metadata)` method
  - [ ] Subtask 6.3: Send custom GA4 event: `gtag('event', 'cta_click', { location, campaign })`
  - [ ] Subtask 6.4: Optionally store event in `vibecoding_analytics` table (for internal reporting)
  - [ ] Subtask 6.5: Test GA4 events fire correctly (use GA4 DebugView or browser console)
  - [ ] Subtask 6.6: Verify UTM parameters are correctly appended to ANYON signup URL

- [ ] Task 7: Add ANYON signup URL environment variable (AC: 2.1.6)
  - [ ] Subtask 7.1: Add `ANYON_SIGNUP_URL` to `.env.example` (e.g., `https://anyon.app/signup`)
  - [ ] Subtask 7.2: Add `ANYON_SIGNUP_URL` to production environment variables (via hosting platform)
  - [ ] Subtask 7.3: Update AnyonCTA component to read URL from ENV variable or Rails config
  - [ ] Subtask 7.4: Verify URL is configurable without code changes

- [ ] Task 8: Create reusable CTA styling (AC: 2.1.7)
  - [ ] Subtask 8.1: Create `app/assets/stylesheets/vibecoding/anyon_cta.scss`
  - [ ] Subtask 8.2: Define `.vibecoding-cta-btn` class with vibecoding brand colors
  - [ ] Subtask 8.3: Ensure button styles match existing Crayons theme (consistency)
  - [ ] Subtask 8.4: Add hover/focus states for accessibility
  - [ ] Subtask 8.5: Test button styling in light and dark modes
  - [ ] Subtask 8.6: Verify button meets WCAG 2.1 Level A color contrast ratios (4.5:1)

- [ ] Task 9: Write unit tests for AnyonCTA component
  - [ ] Subtask 9.1: Create test file: `app/javascript/anyon/components/__tests__/AnyonCTA.test.jsx`
  - [ ] Subtask 9.2: Test component renders with correct props
  - [ ] Subtask 9.3: Test UTM parameters are correctly generated
  - [ ] Subtask 9.4: Test click event fires tracking function
  - [ ] Subtask 9.5: Test `target="_blank"` and `rel="noopener noreferrer"` are set
  - [ ] Subtask 9.6: Run tests with Jest and ensure 100% coverage for component

- [ ] Task 10: Integration testing for CTA placement
  - [ ] Subtask 10.1: Test header CTA appears on homepage, post pages, profile pages, tag pages
  - [ ] Subtask 10.2: Test sidebar widget appears only on post pages (not other pages)
  - [ ] Subtask 10.3: Test footer CTA appears on all pages
  - [ ] Subtask 10.4: Test post-signup prompt appears for new users (after signup)
  - [ ] Subtask 10.5: Verify all CTAs open ANYON signup URL in new tab
  - [ ] Subtask 10.6: Verify no CTAs are intrusive (no popups, modals, or page overlays)

- [ ] Task 11: Accessibility and performance validation
  - [ ] Subtask 11.1: Run Lighthouse audit on homepage (verify performance score > 90)
  - [ ] Subtask 11.2: Run Lighthouse audit on post page (verify sidebar widget doesn't degrade performance)
  - [ ] Subtask 11.3: Test keyboard navigation (tab to CTA buttons, press Enter to activate)
  - [ ] Subtask 11.4: Test screen reader compatibility (CTA buttons have aria-labels)
  - [ ] Subtask 11.5: Verify CTA buttons meet touch target size (minimum 44x44px for mobile)

- [ ] Task 12: Deploy to staging and validate
  - [ ] Subtask 12.1: Deploy CTAs to staging environment
  - [ ] Subtask 12.2: Visual QA all CTA placements (header, sidebar, footer, post-signup)
  - [ ] Subtask 12.3: Test click tracking in GA4 DebugView (staging GA4 property)
  - [ ] Subtask 12.4: Test UTM parameters in ANYON signup URL (verify in browser dev tools)
  - [ ] Subtask 12.5: Get stakeholder approval (Product Manager, Growth Manager)

## Dev Notes

### Relevant Architecture Patterns and Constraints

**Brownfield Customization Strategy (ADR-001)**:
- Extend Forem layout templates (`_header.html.erb`, `_footer.html.erb`, `_sidebar.html.erb`)
- Namespace custom code under `anyon/` (e.g., `app/javascript/anyon/components/AnyonCTA.jsx`)
- Use Service Object pattern for tracking: `Anyon::ConversionTracker`
- Preact components for frontend interactivity (Pattern 4)
- Commented database migrations if storing analytics events

**Epic 2 Architecture Alignment** (from tech-spec-epic-2.md):

**Custom Services**:
- `Anyon::ConversionTracker` - Track ANYON conversion events (CTA clicks)
  - Input: `user`, `event_type`, `metadata`
  - Output: GA4 events, optional database records
  - Location: `app/services/anyon/conversion_tracker.rb`

**Frontend Components**:
- `AnyonCTA.jsx` - Reusable CTA button with tracking
  - Props: `location`, `ctaText`, `className`, `utmCampaign`
  - Location: `app/javascript/anyon/components/AnyonCTA.jsx`
  - Pattern: Preact component (NOT React)

**Database Schema** (Optional - Story 2.4 primary):
- `vibecoding_analytics` table for internal event tracking
- Event types: `cta_click_header`, `cta_click_sidebar`, `cta_click_footer`, `cta_click_signup`

**External Integrations**:
- Google Analytics 4 - Track CTA clicks as custom events
- Google Tag Manager - Optional for complex tracking scenarios

**Consistency Rules**:
- File naming: `anyon/conversion_tracker.rb` (snake_case, namespaced)
- CSS classes: `.vibecoding-cta-btn` (prefixed, kebab-case)
- Git commits: `[VIBECODING]` prefix
- Logging: `Rails.logger.info("VIBECODING: CTA clicked - #{location}")`

### Source Tree Components to Touch

**Primary Files to Modify**:

1. **Layout Templates** (Forem core customization):
   - `app/views/layouts/_header.html.erb` - Add header CTA button
   - `app/views/layouts/_footer.html.erb` - Add "Powered by ANYON" footer section
   - `app/views/articles/_sidebar.html.erb` - Inject sidebar widget on post pages
   - `app/views/users/post_signup.html.erb` - Post-signup account linking prompt (may need to create)

2. **New Preact Component**:
   - `app/javascript/anyon/components/AnyonCTA.jsx` - Reusable CTA button component

3. **New Service Object**:
   - `app/services/anyon/conversion_tracker.rb` - Track conversion events

4. **New Partial View**:
   - `app/views/anyon/_build_with_anyon_widget.html.erb` - Sidebar widget content

5. **Stylesheets**:
   - `app/assets/stylesheets/vibecoding/anyon_cta.scss` - CTA button styles

6. **Configuration**:
   - `.env.example` - Add `ANYON_SIGNUP_URL` environment variable
   - `config/initializers/vibecoding_customizations.rb` - Register custom components (if needed)

7. **Assets**:
   - `app/assets/images/vibecoding/anyon-logo.svg` - ANYON logo for footer

**Testing Files to Create**:
- `app/javascript/anyon/components/__tests__/AnyonCTA.test.jsx` - Jest component tests
- `spec/services/anyon/conversion_tracker_spec.rb` - RSpec service tests (optional)

**Database Migrations** (Optional - defer to Story 2.4 if not needed immediately):
- `db/migrate/YYYYMMDD_create_vibecoding_analytics.rb` - Analytics events table

### Testing Standards Summary

**Unit Tests** (Jest for Preact components):
- `AnyonCTA.test.jsx` - Test component rendering, props, UTM generation, click tracking
- Coverage target: 100% for AnyonCTA component

**Service Tests** (RSpec, optional):
- `conversion_tracker_spec.rb` - Test event tracking logic
- Coverage target: > 80% for service objects

**Integration Tests**:
- Verify CTAs appear in correct locations (header, sidebar, footer, post-signup)
- Test CTA links open ANYON signup URL in new tab
- Verify UTM parameters are correct in URLs
- Test GA4 events fire on CTA clicks (manual verification via GA4 DebugView)

**Acceptance Testing Scenarios**:
- **TS-2.1.1**: Header CTA visible on all pages (logged in/out)
- **TS-2.1.2**: Sidebar widget visible only on post pages (right rail on desktop, below content on mobile)
- **TS-2.1.3**: Footer "Powered by ANYON" visible on all pages
- **TS-2.1.4**: Post-signup prompt appears for new users after registration
- **TS-2.1.5**: All CTA links include correct UTM parameters (utm_source=community, utm_medium=cta, utm_campaign=<location>)
- **TS-2.1.6**: All CTA links open in new tab with `rel="noopener noreferrer"`
- **TS-2.1.7**: CTA buttons match vibecoding brand colors and typography
- **TS-2.1.8**: GA4 custom events fire on CTA clicks (event: `cta_click`, params: `location`, `campaign`)
- **TS-2.1.9**: No intrusive CTAs (no popups, modals, or interstitials)
- **TS-2.1.10**: CTAs are responsive (mobile, tablet, desktop)

**Performance Requirements**:
- CTAs should not degrade page load times (< 100ms overhead)
- Lighthouse Performance Score: > 90 (with CTAs)
- CTA JavaScript bundle size: < 10KB (minimal impact)

**Accessibility Requirements**:
- CTA buttons have aria-labels for screen readers
- CTA buttons meet minimum touch target size (44x44px)
- CTA button color contrast meets WCAG 2.1 Level A (4.5:1)
- Keyboard navigation works (tab to CTA, press Enter to activate)

### Project Structure Notes

**Alignment with Unified Project Structure**:

This story introduces the first custom JavaScript component (`AnyonCTA.jsx`) and custom service object (`Anyon::ConversionTracker`) to the project. It follows the brownfield customization patterns:

1. **Namespace Isolation**: All custom code namespaced under `anyon/` to avoid conflicts with Forem core
2. **Service Object Pattern**: Business logic (tracking) extracted to service objects, not in controllers or models
3. **Preact Components**: Frontend uses Preact (Forem default), not React
4. **Layout Template Extension**: Modify Forem layouts minimally, inject custom partials
5. **Environment Configuration**: ANYON signup URL stored as ENV variable for flexibility

**Detected Conflicts or Variances**:
- **Header Space Constraint**: Forem header may be crowded with logo, navigation, search, notifications. Header CTA must fit without breaking layout. Consider mobile hamburger menu placement.
- **Sidebar Widget Position**: Forem's right sidebar has author info, related posts, tags. Widget must stack correctly without pushing important content down. May need A/B testing for optimal position.
- **Post-Signup Flow**: Forem's default post-signup flow may vary (onboarding steps, email verification). May need to customize or use Forem's onboarding feature (Admin Panel → Config → Onboarding).
- **GA4 Setup Dependency**: This story assumes GA4 is already configured (Story 2.4 or Epic 5). If not, CTA click tracking will fail. Verify GA4 tracking code is present.
- **ANYON Signup URL**: Story assumes ANYON has a public signup URL (e.g., `https://anyon.app/signup`). Verify correct URL with ANYON team before implementation.

**Rationale**: CTAs are the core conversion funnel entry points. Strategic placement (header, sidebar, footer, post-signup) maximizes visibility without being intrusive. UTM tracking enables attribution and ROI measurement. This story lays the foundation for Epic 2's conversion optimization.

### References

- [Source: docs/tech-spec-epic-2.md#Story-2.1-ANYON-CTA-Strategic-Placement]
- [Source: docs/tech-spec-epic-2.md#Services-and-Modules#Anyon::ConversionTracker]
- [Source: docs/tech-spec-epic-2.md#Frontend-Components#AnyonCTA]
- [Source: docs/architecture.md#Epic-to-Architecture-Mapping#Epic-2]
- [Source: docs/epics.md#Epic-2-ANYON-Integration-Conversion-Funnel#Story-2.1]
- [Source: docs/PRD.md#Functional-Requirements#ANYON-Integration]

### Learnings from Previous Story

**From Story 1-6-about-page-community-guidelines (Status: ready-for-dev)**

Story 1.6 completed Epic 1 (Platform Foundation & Branding) and established patterns for content pages. Since it's in "ready-for-dev" status (drafted but not yet implemented), there are no implementation learnings to incorporate. However, the following context from Story 1.6 is essential for this story:

**Epic Transition - Foundation to Integration**:
- **Epic 1 Complete**: Story 1.6 is the final story in Epic 1. This story (2.1) is the first story in Epic 2.
- **ANYON Narrative Established**: Story 1.6's About page establishes the ANYON connection narrative ("authentic, not salesy"). This story's CTAs must maintain the same balanced tone - helpful discovery CTAs, not aggressive sales tactics.
- **Community Guidelines**: Story 1.6 creates guidelines including self-promotion policy ("ANYON showcases encouraged"). This supports Epic 2's conversion strategy - community members can freely showcase ANYON projects.

**Visual and Branding Consistency**:
- **Vibecoding Theme**: Story 1.4 (Custom Theme) established vibecoding brand colors, typography, logo. This story's CTAs MUST use the same brand colors for consistency.
- **Crayons Design System**: Forem uses Crayons components (305+ components). CTAs should leverage existing Crayons button classes or extend them minimally.
- **Dark Mode Support**: Story 1.4 enabled dark mode. CTAs must render correctly in both light and dark modes.
- **Responsive Design**: All Epic 1 stories validated responsive design. CTAs must work on mobile, tablet, desktop without breaking layouts.

**Performance Standards Established**:
- **Page Load Targets**: Epic 1 stories target LCP < 2.5 seconds. CTAs must not degrade performance (< 100ms overhead).
- **Lighthouse Scores**: Epic 1 stories aim for Lighthouse Performance > 90, Accessibility > 90, SEO > 90. This story must maintain these benchmarks.

**Footer Navigation Context**:
- **Footer Links**: Story 1.6 added "About" and "Community Guidelines" links to footer navigation. This story adds "Powered by ANYON" footer section. Ensure footer doesn't become cluttered - may need separate "Powered by" section vs. navigation links.
- **Footer Styling**: Use the same footer layout and typography from Story 1.6 for consistency.

**Content Tone and Positioning**:
- **Non-Intrusive Philosophy**: Story 1.6 (and entire Epic 1) avoids heavy-handed ANYON promotion. This story's CTAs must align - no popups, modals, or interstitials (explicitly stated in ACs).
- **"Powered by ANYON" Phrasing**: Similar to "Built with ANYON" from Story 1.6's tone. Acknowledges ANYON as enabling tool, not sales pitch.

**Staging Environment and Testing**:
- **Deployment Pipeline**: Story 1.3 established staging environment. This story should deploy CTAs to staging first for visual QA and stakeholder approval.
- **Lighthouse Audits**: Epic 1 stories run Lighthouse audits. This story should do the same for pages with CTAs (homepage, post pages).

**Technical Dependencies**:
- **Custom Theme Applied**: Story 1.4's theme is prerequisite for CTA styling. CTAs should use theme color variables (e.g., `--vibecoding-primary-color`).
- **Header/Footer Layouts Exist**: Story 1.4 customized header/footer. This story extends those layouts further.
- **Landing Page Context**: Story 1.5 created landing page with "Join the Community" CTAs. This story's CTAs are complementary ("Try ANYON") - different call-to-action for different conversion goals.

**Asset Management Patterns**:
- **Asset Directory**: Epic 1 stories use `app/assets/images/vibecoding/` for visual assets. This story should use same directory for ANYON logo.
- **CDN for Assets**: If Epic 1 configured Cloudinary or CDN (Story 1.3), use same CDN for ANYON logo to maintain performance.

**Potential Blockers and Risks**:
- **GA4 Not Configured**: This story requires GA4 for click tracking (AC-2.1.8). If Story 2.4 (Conversion Tracking) or Epic 5.1 (GA4 Integration) hasn't run, tracking will fail. **MITIGATION**: Check if GA4 tracking code exists in `<head>`. If not, defer GA4 event tracking to Story 2.4 or add basic GA4 setup as prerequisite.
- **ANYON Signup URL Unknown**: This story requires ANYON signup URL. If ANYON doesn't have public signup, CTAs can't link anywhere. **MITIGATION**: Coordinate with ANYON team to confirm signup URL before implementation.
- **Header Space Limited**: Adding "Try ANYON" button to header may break responsive layout on mobile. **MITIGATION**: Test header on multiple screen sizes. Consider hamburger menu placement for mobile.

**Reusable Components from Epic 1**:
- **Crayons Button Classes**: Use `.crayons-btn`, `.crayons-btn--primary` for CTA styling (extends Forem's design system).
- **Vibecoding Color Variables**: Use CSS custom properties from Story 1.4 (e.g., `var(--vibecoding-primary-color)`).

**Testing Approach Consistency**:
- **Cross-Browser Testing**: Epic 1 tested Chrome, Firefox, Safari, Edge. This story should do the same for CTAs.
- **Mobile-First Testing**: Epic 1 prioritized mobile responsiveness. This story should test mobile layouts first (375px, 414px widths).

**Next Story Synergy**:
- **Story 2.2 (ANYON Project Linking)**: CTAs drive users to ANYON. Story 2.2 enables users to link their ANYON projects back to community posts - completing the conversion loop.
- **Story 2.4 (Conversion Tracking)**: This story creates CTAs. Story 2.4 measures their effectiveness. CTAs should be instrumented for tracking from the start.

**Key Learnings to Apply**:
- **Maintain Non-Intrusive Design**: Epic 1's philosophy: helpful, not pushy. CTAs should be visible but not disruptive.
- **Brand Consistency**: Use vibecoding colors, fonts, logo from Story 1.4. CTAs are part of the brand identity.
- **Performance First**: Don't sacrifice page speed for CTAs. Keep JavaScript bundle small (< 10KB).
- **Accessibility**: Epic 1 validated WCAG 2.1 Level A. CTAs must maintain accessibility (keyboard nav, screen readers, color contrast).

**Files Modified in Epic 1** (may need coordination):
- `app/views/layouts/_header.html.erb` - This story extends further
- `app/views/layouts/_footer.html.erb` - This story extends further
- `app/assets/stylesheets/vibecoding/` - This story adds `anyon_cta.scss`

**User Expectations from Epic 1**:
- **Vibecoding Community Brand**: Users now recognize vibecoding branding. CTAs should feel like natural part of the platform, not external ads.
- **Quality Content Standards**: Epic 1 established quality bar. CTAs should reflect same quality (good copy, design, UX).

[Source: stories/1-6-about-page-community-guidelines.md#Learnings-from-Previous-Story]

## Change Log

**2025-11-09**: Story created by BMad create-story workflow for Epic 2, Story 1

## Dev Agent Record

### Context Reference

<!-- Path(s) to story context XML will be added here by context workflow -->

### Agent Model Used

{{agent_model_name_version}}

### Debug Log References

### Completion Notes List

### File List
