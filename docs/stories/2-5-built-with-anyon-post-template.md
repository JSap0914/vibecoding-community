# Story 2.5: Built with ANYON Post Template

Status: drafted

## Story

As a **Content Creator**,
I want a structured template for showcasing ANYON projects,
so that I can easily create high-quality project showcase posts.

## Acceptance Criteria

### Template Availability and Accessibility
1. **AC-2.5.1**: "ANYON Project Showcase" template is available in the post editor template selector
2. **AC-2.5.2**: Template is accessible from post editor dropdown menu
3. **AC-2.5.3**: Template is accessible from "Create Post" button options
4. **AC-2.5.4**: Documentation page exists explaining the template and its usage

### Template Structure and Content
5. **AC-2.5.5**: Template pre-populates with the following sections in Markdown:
   - **Problem:** What were you trying to build?
   - **Why ANYON:** Why did you choose ANYON for this project?
   - **The Build:** Describe your vibecoding process (PRD, TRD, development)
   - **Tech Stack:** Technologies and integrations used
   - **Results:** What did you achieve? (screenshots, metrics, demo link)
   - **Lessons Learned:** Tips for other vibecoders
   - **ANYON Project Link:** [Your project URL]

6. **AC-2.5.6**: Each section includes inline help text and placeholder examples
7. **AC-2.5.7**: Template includes markdown formatting hints (headings, code blocks, lists)
8. **AC-2.5.8**: Template is SEO-friendly with proper heading hierarchy

### Auto-Suggestions and Integration
9. **AC-2.5.9**: Template auto-suggests tags: `#anyon`, `#project-showcase`, `#vibecoding`
10. **AC-2.5.10**: Template prompts user to fill in ANYON Project URL field (from Story 2.2)
11. **AC-2.5.11**: Template placeholder text guides users without being overwhelming
12. **AC-2.5.12**: Users can edit/customize the template structure before or after publishing

### Visual Distinction
13. **AC-2.5.13**: Posts created with this template display visual highlighting (special badge or styling)
14. **AC-2.5.14**: Badge displays "Built with ANYON" or "ANYON Project Showcase"
15. **AC-2.5.15**: Visual distinction is consistent with ANYON branding and theme colors

### Analytics and Tracking
16. **AC-2.5.16**: Template usage is tracked in analytics (template_used: "anyon-showcase")
17. **AC-2.5.17**: Showcase posts can be filtered/discovered easily (via tag or template type)

## Tasks / Subtasks

- [ ] Task 1: Create Template in Forem Admin Panel (AC: #1-4)
  - [ ] 1.1: Access Forem Admin Panel > Customization > Article Templates
  - [ ] 1.2: Create new template named "ANYON Project Showcase"
  - [ ] 1.3: Write template body with all required sections (Problem, Why ANYON, The Build, etc.)
  - [ ] 1.4: Add inline help text and examples for each section
  - [ ] 1.5: Add markdown formatting hints (## for headings, ``` for code blocks)
  - [ ] 1.6: Test template rendering in post editor preview
  - [ ] 1.7: Save and publish template

- [ ] Task 2: Configure Auto-Suggested Tags (AC: #9)
  - [ ] 2.1: Configure template to auto-suggest `#anyon` tag
  - [ ] 2.2: Configure template to auto-suggest `#project-showcase` tag
  - [ ] 2.3: Configure template to auto-suggest `#vibecoding` tag
  - [ ] 2.4: Verify tags appear in editor when template is selected
  - [ ] 2.5: Allow users to add/remove auto-suggested tags

- [ ] Task 3: ANYON Project URL Field Integration (AC: #10)
  - [ ] 3.1: Add prompt in template body to fill ANYON Project URL field
  - [ ] 3.2: Link to ANYON Project URL field in post editor (from Story 2.2)
  - [ ] 3.3: Add help text explaining the project URL field's purpose
  - [ ] 3.4: Validate that project URL field is accessible and functional
  - [ ] 3.5: Test template with ANYON Project URL field populated

- [ ] Task 4: Visual Distinction for Showcase Posts (AC: #13-15)
  - [ ] 4.1: Design "Built with ANYON" badge/indicator
  - [ ] 4.2: Create CSS styles for badge using Vibecoding theme colors
  - [ ] 4.3: Determine badge placement (post header, post footer, or inline)
  - [ ] 4.4: Implement badge component (Preact or HTML/CSS)
  - [ ] 4.5: Add badge to posts created with ANYON Showcase template
  - [ ] 4.6: Ensure badge is responsive (mobile, tablet, desktop)
  - [ ] 4.7: Test badge rendering on various post layouts

- [ ] Task 5: Template Selector UI Enhancement (AC: #2-3)
  - [ ] 5.1: Verify template appears in post editor dropdown
  - [ ] 5.2: Verify template is accessible from "Create Post" button
  - [ ] 5.3: Add template description/tooltip to help users choose
  - [ ] 5.4: Test template selection flow (new post vs edit existing)
  - [ ] 5.5: Ensure template loads correctly when selected

- [ ] Task 6: Documentation and User Guidance (AC: #4, #6, #11)
  - [ ] 6.1: Create documentation page explaining ANYON Showcase template
  - [ ] 6.2: Document each section's purpose and best practices
  - [ ] 6.3: Provide example showcase post for reference
  - [ ] 6.4: Add "How to Use This Template" section in documentation
  - [ ] 6.5: Link documentation from template selector or editor help
  - [ ] 6.6: Include SEO tips for showcase posts in documentation

- [ ] Task 7: Analytics Tracking for Template Usage (AC: #16-17)
  - [ ] 7.1: Add tracking event when ANYON Showcase template is selected
  - [ ] 7.2: Track template usage in GA4 (custom event: `template_selected`)
  - [ ] 7.3: Add `template_type` field to posts metadata (if not already present)
  - [ ] 7.4: Create filter/view in admin panel for showcase posts
  - [ ] 7.5: Tag showcase posts for easy discoverability (via `#project-showcase`)
  - [ ] 7.6: Verify analytics data appears in GA4 and admin dashboard

- [ ] Task 8: Testing and Quality Assurance (All ACs)
  - [ ] 8.1: Test template selection in post editor (new post)
  - [ ] 8.2: Test template application to existing post (edit mode)
  - [ ] 8.3: Test auto-suggested tags appear correctly
  - [ ] 8.4: Test ANYON Project URL field integration
  - [ ] 8.5: Test "Built with ANYON" badge rendering
  - [ ] 8.6: Test template on mobile and desktop
  - [ ] 8.7: Test SEO meta tags for showcase posts
  - [ ] 8.8: Test analytics tracking (template usage event)
  - [ ] 8.9: Create test showcase post using template
  - [ ] 8.10: Verify post is filterable via tags and template type

- [ ] Task 9: Template Iteration and Refinement (Post-Launch)
  - [ ] 9.1: Gather feedback from early users of template
  - [ ] 9.2: Identify sections that are confusing or underutilized
  - [ ] 9.3: Refine placeholder text and examples based on feedback
  - [ ] 9.4: Update documentation with real-world examples
  - [ ] 9.5: Consider adding more templates (Tutorial, Comparison, etc.) in future

## Dev Notes

### Architecture Patterns and Constraints

**Brownfield Customization Strategy (ADR-001):**
- Use Forem's built-in Article Template system (Admin Panel > Customization > Article Templates)
- Store template in Forem database, no custom code required for template content
- Visual badge implemented as custom Preact component or CSS styling
- Analytics tracking via existing GA4/GTM infrastructure from Story 2.4
- Minimal code changes - primarily configuration and styling

**Template Architecture:**
- **Forem Native**: Leverage Forem's Liquid template system for article templates
- **Database Storage**: Template stored in `article_templates` table (Forem built-in)
- **Auto-Tagging**: Use Forem's template configuration to auto-suggest tags
- **Badge Component**: Reuse `AnyonProjectBadge.jsx` component from Story 2.2 (if applicable)

**Content Structure:**
- **Markdown Format**: Template body in Markdown for easy editing
- **Sections**: Clear headings (## Problem, ## Why ANYON, etc.) for structure
- **Placeholders**: Italic text for guidance (e.g., *Describe the problem you were trying to solve*)
- **Examples**: Inline code blocks or lists showing expected format

**Visual Identity:**
- **Badge**: "Built with ANYON" badge using ANYON brand colors
- **Consistency**: Align with Vibecoding theme from Story 1.4
- **Responsive**: Badge must work on all screen sizes

### Source Tree Components to Touch

**Forem Admin Panel (Configuration):**
- `Admin Panel > Customization > Article Templates` - Create new template
- Template configuration: name, body (Markdown), auto-suggested tags

**Frontend Components (Visual Badge):**
- `app/javascript/custom/AnyonProjectBadge.jsx` - Reuse or extend for template badge (Story 2.2)
- `app/assets/stylesheets/vibecoding/badge.scss` - NEW badge styling (if custom CSS needed)
- `app/views/articles/_article_meta.html.erb` - Display badge on posts (if template metadata available)

**Backend (Optional - Template Metadata):**
- `app/models/article.rb` or `app/models/concerns/anyon_trackable.rb` - Track template usage (extend from Story 2.2)
- No database migration needed (Forem's `article_templates` table already exists)

**Analytics (Tracking):**
- `app/javascript/analytics/ga4_tracker.js` - Track template selection event (from Story 2.4)
- GA4 custom event: `template_selected` with `template_name: "anyon-showcase"`

**Documentation:**
- `docs/templates/anyon-showcase-guide.md` - NEW user guide for template
- `app/views/pages/templates.html.erb` - NEW page listing available templates (optional)

### Testing Standards Summary

**From Architecture: Testing Strategy**
- **Manual Testing (MVP):** Test template selection, rendering, auto-tags, badge display
- **Integration Tests (RSpec):** Test template usage tracking (if adding backend logic)
- **E2E Tests (Cypress):** Test full flow: select template → write post → publish → verify badge
- **Frontend Tests (Jest):** Test badge component rendering (if custom Preact component)

**Key Test Scenarios:**
1. Template Selection: User selects "ANYON Project Showcase" → Editor pre-populates with template
2. Auto-Tagging: Template selection → Tags `#anyon`, `#project-showcase`, `#vibecoding` auto-suggested
3. ANYON URL Integration: User fills ANYON Project URL field → Link displays on published post
4. Badge Display: Post created with template → "Built with ANYON" badge visible
5. Analytics Tracking: Template selected → GA4 event recorded

**Test Coverage Target:** Focus on visual and functional testing for MVP; unit tests optional since template is configuration-based

### Project Structure Notes

**Alignment with Unified Project Structure:**
- Template stored via Forem Admin Panel (no file in repo initially)
- Badge component follows naming convention: `AnyonProjectBadge.jsx` (from Story 2.2)
- CSS follows Vibecoding namespace: `.vibecoding-badge` or use Crayons utility classes
- Documentation under `docs/templates/` for template usage guides

**Naming Conventions:**
- Template name: "ANYON Project Showcase" (human-readable)
- Template slug: `anyon-project-showcase` (URL-safe)
- Badge CSS class: `.vibecoding-anyon-badge` or `.badge--anyon-showcase`
- Analytics event: `template_selected` (snake_case)
- GA4 parameter: `template_name` (snake_case)

**Dependencies:**
- **Story 2.2 (ANYON Project Linking in Posts):** REQUIRED - Template references ANYON Project URL field
- **Story 2.4 (Conversion Tracking & Analytics):** OPTIONAL - Template usage tracking uses GA4/GTM setup
- **Story 1.4 (Custom Theme):** REQUIRED - Badge styling uses Vibecoding brand colors

**No Detected Conflicts:** Template is additive (new feature), no modifications to existing Forem core. Badge component may reuse or extend existing `AnyonProjectBadge.jsx` from Story 2.2.

### Learnings from Previous Story

**From Story 2-4-conversion-tracking-analytics-setup (Status: drafted)**

Story 2.4 has not been implemented yet (status: drafted), so there are no implementation learnings or file changes to reference. However, Story 2.5 will leverage the analytics infrastructure planned in Story 2.4.

**Expected Dependencies on Story 2.4:**
- GA4 and GTM setup (for template usage tracking)
- Analytics tracking functions in `app/javascript/analytics/ga4_tracker.js`
- `Anyon::ConversionTracker` service (for tracking template selection events)

**Recommended Approach:**
- Story 2.5 can be implemented independently for template creation and badge display
- Analytics tracking for template usage should be deferred until Story 2.4 is complete (or implemented with placeholder tracking)
- If Story 2.4 is not yet implemented, add TODO comments for analytics integration

[Source: stories/2-4-conversion-tracking-analytics-setup.md#Status]

### References

**Technical Specifications:**
- [Source: docs/tech-spec-epic-2.md#Story 2.5: Built with ANYON Post Template] - Detailed template structure and acceptance criteria
- [Source: docs/tech-spec-epic-2.md#Post Template Service] - Template service design
- [Source: docs/tech-spec-epic-2.md#AnyonProjectBadge Component] - Badge component interface

**Epic Context:**
- [Source: docs/epics.md#Story 2.5: Built with ANYON Post Template] - User story and high-level acceptance criteria
- [Source: docs/epics.md#Epic 2: ANYON Integration & Conversion Funnel] - Epic goal and business value

**Architecture Decisions:**
- [Source: docs/architecture.md#ADR-001: Brownfield Customization Strategy] - Forem extension patterns
- [Source: docs/architecture.md#Pattern 4: Preact Components] - Frontend component structure
- [Source: docs/architecture.md#Epic 2 Mapping] - Template service location and naming

**Dependencies:**
- [Source: docs/epics.md#Story 2.2: ANYON Project Linking in Posts] - ANYON Project URL field (prerequisite)
- [Source: docs/epics.md#Story 2.4: Conversion Tracking & Analytics Setup] - Analytics infrastructure (optional dependency)
- [Source: docs/epics.md#Story 1.4: Custom Theme] - Vibecoding brand colors for badge styling

**Forem Documentation:**
- Forem Article Templates: Admin Panel > Customization > Article Templates
- Liquid Template Variables: Used for dynamic content in templates
- Forem Tag System: Auto-suggested tags configuration

## Dev Agent Record

### Context Reference

<!-- Path(s) to story context XML will be added here by context workflow -->

### Agent Model Used

Claude Sonnet 4.5 (claude-sonnet-4-5-20250929)

### Debug Log References

### Completion Notes List

### File List
