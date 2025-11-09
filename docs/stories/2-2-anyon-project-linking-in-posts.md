# Story 2.2: ANYON Project Linking in Posts

Status: drafted

## Story

As a **Vibecoder**,
I want to link my ANYON projects in my community posts,
so that I can showcase my ANYON-built applications and drive traffic to my projects.

## Acceptance Criteria

1. **Post Editor Enhancement**
   - **Given** I am creating or editing a post
   - **When** I access the post editor
   - **Then** I see an optional "ANYON Project URL" field

2. **URL Validation**
   - **Given** I enter an ANYON project URL
   - **When** I provide the URL
   - **Then** the system validates the URL format (HTTPS required, max 2048 characters)
   - **And** shows validation feedback (✓ valid or ✗ invalid with reason)

3. **Visual Project Badge**
   - **Given** I publish a post with an ANYON project URL
   - **When** the post is displayed
   - **Then** the post shows an "ANYON Project" badge/indicator
   - **And** a "View Project" link appears with UTM tracking parameters

4. **Post Distinction**
   - **Given** a post has an ANYON project linked
   - **When** the post is rendered in feeds or lists
   - **Then** the post is visually distinguished (badge, icon, or highlight)

5. **Filtering and Search**
   - **Given** multiple posts with ANYON projects exist
   - **When** I filter by #anyon tag or ANYON projects
   - **Then** I can see all posts with linked ANYON projects

6. **Analytics Tracking**
   - **Given** a user clicks on an ANYON project link
   - **When** the click occurs
   - **Then** the click is tracked in analytics (GA4)
   - **And** UTM parameters are included (utm_source=community, utm_medium=project_link)

## Tasks / Subtasks

- [ ] Task 1: Database Schema Changes (AC: #1, #2)
  - [ ] 1.1: Create migration to add `anyon_project_url` column to `articles` table (VARCHAR 2048, nullable)
  - [ ] 1.2: Add partial index on `anyon_project_url` for non-null values
  - [ ] 1.3: Add database comment documenting VIBECODING customization
  - [ ] 1.4: Run migration and verify schema changes

- [ ] Task 2: Model Layer - Article Extension (AC: #2, #6)
  - [ ] 2.1: Create `AnyonTrackable` concern in `app/models/concerns/`
  - [ ] 2.2: Add HTTPS validation for `anyon_project_url` (URI format, max 2048 chars)
  - [ ] 2.3: Implement `has_anyon_project?` helper method
  - [ ] 2.4: Add `after_save` callback to track project linking events
  - [ ] 2.5: Include concern in Article model via initializer
  - [ ] 2.6: Write RSpec tests for validations and callbacks

- [ ] Task 3: Post Editor UI Enhancement (AC: #1, #2)
  - [ ] 3.1: Add "ANYON Project URL" field to post editor form
  - [ ] 3.2: Implement client-side validation (HTTPS check, length validation)
  - [ ] 3.3: Add visual validation feedback (checkmark/error icon)
  - [ ] 3.4: Add help text explaining the field and ANYON project linking
  - [ ] 3.5: Test form submission with valid and invalid URLs

- [ ] Task 4: Frontend Badge Component (AC: #3, #4)
  - [ ] 4.1: Create `AnyonProjectBadge.jsx` Preact component
  - [ ] 4.2: Implement badge rendering with ANYON branding
  - [ ] 4.3: Add "View Project" link with UTM parameter generation
  - [ ] 4.4: Apply Crayons design system styling for consistency
  - [ ] 4.5: Handle `target="_blank"` and `rel="noopener noreferrer"` for security
  - [ ] 4.6: Write component tests

- [ ] Task 5: Post Display Integration (AC: #3, #4)
  - [ ] 5.1: Integrate `AnyonProjectBadge` component into post view templates
  - [ ] 5.2: Add conditional rendering (only show if `has_anyon_project?`)
  - [ ] 5.3: Style badge placement (consistent positioning in post layout)
  - [ ] 5.4: Test badge rendering in single post view
  - [ ] 5.5: Test badge rendering in post feed/list views

- [ ] Task 6: Filtering and Indexing (AC: #5)
  - [ ] 6.1: Ensure #anyon tag auto-suggests for posts with ANYON projects
  - [ ] 6.2: Create filter/query capability for posts with `anyon_project_url`
  - [ ] 6.3: Test filtering ANYON projects via tag page
  - [ ] 6.4: Verify search indexing includes ANYON project posts

- [ ] Task 7: Analytics Tracking Implementation (AC: #6)
  - [ ] 7.1: Add GA4 event tracking to "View Project" link clicks
  - [ ] 7.2: Implement UTM parameter generation helper (source=community, medium=project_link)
  - [ ] 7.3: Integrate with `Anyon::ConversionTracker` service
  - [ ] 7.4: Log tracking events with VIBECODING prefix
  - [ ] 7.5: Test analytics events fire correctly in browser console

- [ ] Task 8: Testing and Quality Assurance (All ACs)
  - [ ] 8.1: Write integration tests for post creation with ANYON project URL
  - [ ] 8.2: Write system tests for post editor workflow
  - [ ] 8.3: Test URL validation edge cases (malformed URLs, HTTP vs HTTPS)
  - [ ] 8.4: Verify badge rendering across different screen sizes (responsive)
  - [ ] 8.5: Test analytics tracking in staging environment
  - [ ] 8.6: Accessibility check (WCAG 2.1 Level A compliance for badge/link)

## Dev Notes

### Architecture Patterns and Constraints

**Brownfield Customization Strategy (ADR-001):**
- Extend Article model using `AnyonTrackable` concern (Pattern 1: Model Extension via Concerns)
- Namespace all code under `anyon/` or `vibecoding/` (Pattern 2: Namespacing)
- Use Service Object pattern for analytics tracking (Pattern 3: Business Logic Services)
- Preact components for frontend badge (Pattern 4: Frontend Framework)
- Commented database migrations (Pattern 5: Documentation Standards)

**Database Architecture:**
- Single column addition to `articles` table: `anyon_project_url VARCHAR(2048)` nullable
- Partial index for efficient querying: `CREATE INDEX idx_articles_anyon_project_url ON articles(anyon_project_url) WHERE anyon_project_url IS NOT NULL`
- Follow VIBECODING naming convention: prefix custom columns with `anyon_` or `vibecoding_`

**Service Layer:**
- Use existing `Anyon::ConversionTracker` service for analytics (to be created in Story 2.4, stub for now)
- Validation service: `Anyon::ProjectLinker` for URL validation and sanitization

**Frontend Architecture:**
- Preact component: `AnyonProjectBadge.jsx` in `app/javascript/custom/`
- Use Forem's Crayons design system for consistent styling
- UTM tracking: `?utm_source=community&utm_medium=project_link&utm_campaign=<optional>`

### Source Tree Components to Touch

**Backend Files:**
- `db/migrate/YYYYMMDD_add_anyon_project_url_to_articles.rb` - NEW migration
- `app/models/concerns/anyon_trackable.rb` - NEW concern for Article model
- `config/initializers/vibecoding_customizations.rb` - Include concern in Article
- `app/controllers/articles_controller.rb` - May need to permit new param (verify strong params)

**Frontend Files:**
- `app/javascript/custom/AnyonProjectBadge.jsx` - NEW Preact component
- `app/views/articles/_form.html.erb` - Add ANYON Project URL field to editor
- `app/views/articles/show.html.erb` - Integrate badge component
- `app/views/articles/_article.html.erb` - Integrate badge in feed/list views (if applicable)

**Testing Files:**
- `spec/models/concerns/anyon_trackable_spec.rb` - NEW RSpec tests for concern
- `spec/requests/articles_spec.rb` - Integration tests for post creation with ANYON URL
- `spec/system/post_editor_spec.rb` - System tests for editor workflow
- `app/javascript/custom/__tests__/AnyonProjectBadge.test.jsx` - Component tests

### Testing Standards Summary

**From Architecture: Testing Strategy**
- **Unit Tests (RSpec):** Test `AnyonTrackable` concern validations, callbacks, helper methods
- **Integration Tests (RSpec):** Test Article creation/update with `anyon_project_url` field
- **System Tests (Capybara):** Test post editor workflow, badge rendering, link clicking
- **Frontend Tests (Jest/Preact Testing Library):** Test `AnyonProjectBadge` component rendering and interaction
- **Accessibility Tests:** Verify badge/link are keyboard navigable and screen-reader friendly

**Test Coverage Target:** Maintain >80% coverage per project testing standards

### Project Structure Notes

**Alignment with Unified Project Structure:**
- Follow Rails convention: `app/models/concerns/` for mixins
- Custom JavaScript: `app/javascript/custom/` for Vibecoding-specific components
- Migrations: `db/migrate/` with descriptive YYYYMMDD timestamp prefixes
- Tests mirror source structure: `spec/models/concerns/`, `app/javascript/custom/__tests__/`

**Naming Conventions:**
- Ruby files: `snake_case` (e.g., `anyon_trackable.rb`)
- Database columns: `snake_case` with prefix (e.g., `anyon_project_url`)
- JavaScript components: `PascalCase` (e.g., `AnyonProjectBadge.jsx`)
- CSS classes: Use Crayons utility classes or `.vibecoding-*` if custom needed

**No Detected Conflicts:** All changes are additive (new column, new concern, new component) and follow established Forem extension patterns.

### References

**Technical Specifications:**
- [Source: docs/tech-spec-epic-2.md#Story 2.2: ANYON Project Linking in Posts] - Detailed design, data models, workflows
- [Source: docs/tech-spec-epic-2.md#Database Schema Changes] - Migration details and SQL examples
- [Source: docs/tech-spec-epic-2.md#Model Concerns (Forem Extension Pattern)] - `AnyonTrackable` concern implementation
- [Source: docs/tech-spec-epic-2.md#Frontend Component Interfaces] - `AnyonProjectBadge` component spec

**Epic Context:**
- [Source: docs/epics.md#Story 2.2: ANYON Project Linking in Posts] - User story, acceptance criteria, prerequisites
- [Source: docs/epics.md#Epic 2: ANYON Integration & Conversion Funnel] - Epic goal and business value

**Architecture Decisions:**
- [Source: docs/architecture.md#ADR-001: Brownfield Customization Strategy] - Extension patterns and constraints
- [Source: docs/architecture.md#Pattern 1: Model Extension via Concerns] - How to extend Forem models safely
- [Source: docs/architecture.md#Pattern 4: Preact Components] - Frontend component standards

**Testing Standards:**
- [Source: docs/architecture.md#Testing Strategy] - Coverage targets, test types, frameworks

## Dev Agent Record

### Context Reference

<!-- Path(s) to story context XML will be added here by context workflow -->

### Agent Model Used

Claude Sonnet 4.5 (claude-sonnet-4-5-20250929)

### Debug Log References

### Completion Notes List

### File List
