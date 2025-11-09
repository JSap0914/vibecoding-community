# Story 2.3: ANYON Project Linking in User Profiles

Status: drafted

## Story

As a **Vibecoder**,
I want to display my ANYON projects on my profile,
so that visitors can see my vibecoding portfolio and discover my ANYON-built applications.

## Acceptance Criteria

1. **Profile Settings - ANYON Projects Section**
   - **Given** I am editing my profile settings
   - **When** I navigate to `/settings/profile`
   - **Then** I see an "ANYON Projects" section
   - **And** I can add multiple ANYON project links (up to 10 projects)

2. **Add ANYON Project Form**
   - **Given** I click "Add ANYON Project" in profile settings
   - **When** the form expands
   - **Then** I see fields for:
     - Project Title (required, max 200 characters)
     - Project URL (required, HTTPS, max 2048 characters)
   - **And** I can submit the form to add the project to my profile

3. **URL Validation**
   - **Given** I enter an ANYON project URL
   - **When** I provide the URL
   - **Then** the system validates the URL format (HTTPS required, max 2048 characters)
   - **And** shows validation feedback (✓ valid or ✗ invalid with reason)
   - **And** rejects duplicate URLs within the same profile

4. **Profile Display - Built with ANYON Badge**
   - **Given** I have at least one ANYON project linked
   - **When** my public profile is displayed
   - **Then** my profile shows a "Built with ANYON" badge/indicator in the header
   - **And** my projects are displayed in a prominently placed "ANYON Projects" section

5. **Projects List Display**
   - **Given** my profile has linked ANYON projects
   - **When** visitors view my profile
   - **Then** they see a list of my projects with titles
   - **And** each project has a "View Project" link that opens in a new tab
   - **And** all project links include UTM tracking parameters (utm_source=community, utm_medium=profile_project)

6. **Project Management**
   - **Given** I have ANYON projects on my profile
   - **When** I return to profile settings
   - **Then** I can edit or delete existing projects
   - **And** the system enforces a maximum of 10 projects per user

7. **Analytics Tracking**
   - **Given** a visitor clicks on an ANYON project link on my profile
   - **When** the click occurs
   - **Then** the click is tracked in analytics (GA4)
   - **And** a `project_linked_profile` event is tracked when I add a project
   - **And** UTM parameters are included (utm_source=community, utm_medium=profile_project)

## Tasks / Subtasks

- [ ] Task 1: Database Schema Changes (AC: #1, #2)
  - [ ] 1.1: Create migration to add `anyon_projects` JSONB column to `users` table (default: `[]`)
  - [ ] 1.2: Add GIN index on `anyon_projects` for efficient JSONB queries
  - [ ] 1.3: Add database comment documenting VIBECODING customization
  - [ ] 1.4: Run migration and verify schema changes

- [ ] Task 2: Model Layer - User Extension (AC: #2, #3, #6)
  - [ ] 2.1: Create validation for `anyon_projects` JSONB structure
  - [ ] 2.2: Enforce max 10 projects per user
  - [ ] 2.3: Validate each project requires `title` (max 200 chars) and `url` (HTTPS, max 2048 chars)
  - [ ] 2.4: Validate no duplicate URLs within the same profile
  - [ ] 2.5: Auto-generate `added_at` timestamp if not provided
  - [ ] 2.6: Implement `has_anyon_projects?` helper method
  - [ ] 2.7: Add `after_save` callback to track `project_linked_profile` events
  - [ ] 2.8: Write RSpec tests for validations and callbacks

- [ ] Task 3: Profile Settings UI - ANYON Projects Section (AC: #1, #2, #6)
  - [ ] 3.1: Add "ANYON Projects" section to `/settings/profile` page
  - [ ] 3.2: Create "Add ANYON Project" button/link
  - [ ] 3.3: Implement expandable form with Title and URL fields
  - [ ] 3.4: Add client-side validation (HTTPS check, length validation, duplicate detection)
  - [ ] 3.5: Add visual validation feedback (checkmark/error icons)
  - [ ] 3.6: Implement edit/delete functionality for existing projects
  - [ ] 3.7: Display current project count and max limit (e.g., "5 / 10 projects")
  - [ ] 3.8: Add help text explaining ANYON project linking

- [ ] Task 4: Public Profile Display - Badge Component (AC: #4, #5)
  - [ ] 4.1: Create "Built with ANYON" badge component (Preact or ERB partial)
  - [ ] 4.2: Conditionally display badge on profiles with ANYON projects
  - [ ] 4.3: Apply Crayons design system styling for consistency
  - [ ] 4.4: Position badge prominently in profile header

- [ ] Task 5: Public Profile Display - Projects Section (AC: #5)
  - [ ] 5.1: Create "ANYON Projects" section component for public profiles
  - [ ] 5.2: Display list of projects with titles
  - [ ] 5.3: Add "View Project" links with `target="_blank"` and `rel="noopener noreferrer"`
  - [ ] 5.4: Implement UTM parameter generation for project links
  - [ ] 5.5: Style projects section using Crayons design system
  - [ ] 5.6: Handle edge cases (no projects, long titles, etc.)

- [ ] Task 6: Analytics Integration (AC: #7)
  - [ ] 6.1: Integrate with `Anyon::ConversionTracker` service for `project_linked_profile` events
  - [ ] 6.2: Add GA4 event tracking to "View Project" link clicks (if not handled by Story 2.4)
  - [ ] 6.3: Implement UTM parameter generation helper (source=community, medium=profile_project)
  - [ ] 6.4: Test analytics events fire correctly in browser console

- [ ] Task 7: Testing and Quality Assurance (All ACs)
  - [ ] 7.1: Write unit tests for JSONB validation (RSpec)
  - [ ] 7.2: Write integration tests for profile update with projects (RSpec)
  - [ ] 7.3: Write system tests for profile settings workflow (Capybara)
  - [ ] 7.4: Write E2E tests for public profile display (Cypress)
  - [ ] 7.5: Test URL validation edge cases (malformed URLs, HTTP vs HTTPS, duplicates)
  - [ ] 7.6: Test max projects limit enforcement
  - [ ] 7.7: Verify badge rendering across different screen sizes (responsive)
  - [ ] 7.8: Test analytics tracking in staging environment
  - [ ] 7.9: Accessibility check (WCAG 2.1 Level A compliance for badge/links)

## Dev Notes

### Architecture Patterns and Constraints

**Brownfield Customization Strategy (ADR-001):**
- Extend User model with JSONB column (no need for concerns since this is direct column addition)
- Namespace all code under `anyon/` or `vibecoding/` (Pattern 2: Namespacing)
- Use Service Object pattern for analytics tracking: `Anyon::ConversionTracker` (Pattern 3: Business Logic Services)
- Preact components or ERB partials for frontend badge and projects section (Pattern 4: Frontend Framework)
- Commented database migrations (Pattern 5: Documentation Standards)

**Database Architecture:**
- Single column addition to `users` table: `anyon_projects JSONB` with default `[]`
- GIN index for efficient JSONB queries: `CREATE INDEX idx_users_anyon_projects ON users USING gin(anyon_projects)`
- Follow VIBECODING naming convention: prefix custom columns with `anyon_` or `vibecoding_`
- JSONB structure: Array of objects with `{ title, url, added_at }` fields

**Validation Strategy:**
- Max 10 projects per user (prevent profile spam and bloat)
- Each project must have:
  - `title`: String, required, max 200 characters
  - `url`: String, required, HTTPS only, max 2048 characters, valid URI format
  - `added_at`: ISO 8601 timestamp, auto-generated if not provided
- No duplicate URLs within the same user profile

**Service Layer:**
- Use `Anyon::ConversionTracker` service for analytics tracking (implemented in Story 2.4, may need to stub if Story 2.4 not complete)
- UTM parameter generation for project links: `?utm_source=community&utm_medium=profile_project`

**Frontend Architecture:**
- Profile settings form: Add to existing `/settings/profile` view
- Public profile badge: Preact component or ERB partial (decide based on existing profile patterns)
- Projects section: Display using Forem's Crayons design system
- Use Forem's existing form patterns for consistency

### Source Tree Components to Touch

**Backend Files:**
- `db/migrate/YYYYMMDD_add_anyon_projects_to_users.rb` - NEW migration
- `app/models/user.rb` - Add JSONB validation and helper methods (or create concern if preferred)
- `app/controllers/users/settings_controller.rb` - May need to permit new param (verify strong params)
- `app/services/anyon/conversion_tracker.rb` - Use existing service from Story 2.4 (or create stub)

**Frontend Files (Profile Settings):**
- `app/views/users/settings/profile.html.erb` - Add ANYON Projects section
- `app/javascript/custom/AnyonProfileProjects.jsx` - NEW Preact component for form (optional)
- OR use server-rendered forms with minimal JS for progressive enhancement

**Frontend Files (Public Profile):**
- `app/views/users/show.html.erb` - Display badge and projects section
- `app/views/users/_anyon_projects.html.erb` - NEW partial for projects list
- `app/views/users/_anyon_badge.html.erb` - NEW partial for "Built with ANYON" badge
- OR create Preact component: `app/javascript/custom/AnyonProfileBadge.jsx`

**Testing Files:**
- `spec/models/user_spec.rb` - Add tests for ANYON projects validation
- `spec/requests/users/settings_spec.rb` - Integration tests for profile update
- `spec/system/user_profile_spec.rb` - System tests for profile settings and display
- `spec/cypress/e2e/anyon_profile_projects.cy.js` - E2E tests (if using Cypress)

### Testing Standards Summary

**From Architecture: Testing Strategy**
- **Unit Tests (RSpec):** Test User model JSONB validations, helper methods, callbacks
- **Integration Tests (RSpec):** Test profile update endpoint with `anyon_projects` field
- **System Tests (Capybara):** Test profile settings workflow, public profile display
- **E2E Tests (Cypress):** Test complete user journey (add project → view profile → click link)
- **Accessibility Tests:** Verify badge/links are keyboard navigable and screen-reader friendly

**Test Coverage Target:** Maintain >80% coverage per project testing standards

**Key Test Cases (from Tech Spec):**
- TS-2.3.1: User model validates JSONB structure for `anyon_projects`
- TS-2.3.2: Validation enforces max 10 projects per user
- TS-2.3.3: Validation requires title and URL for each project
- TS-2.3.4: Validation rejects duplicate URLs within same profile
- TS-2.3.5: `added_at` timestamp auto-generated if not provided
- TS-2.3.10: Profile settings display "ANYON Projects" section
- TS-2.3.14: Public profile displays "Built with ANYON" badge
- TS-2.3.16: Clicking "View" opens URL in new tab with UTM

### Project Structure Notes

**Alignment with Unified Project Structure:**
- Follow Rails convention: `app/models/` for model extensions
- Custom JavaScript: `app/javascript/custom/` for Vibecoding-specific components (if using Preact)
- Migrations: `db/migrate/` with descriptive YYYYMMDD timestamp prefixes
- Views: `app/views/users/` for profile-related views
- Partials: `app/views/users/_*.html.erb` for reusable components
- Tests mirror source structure: `spec/models/`, `spec/requests/`, `spec/system/`

**Naming Conventions:**
- Ruby files: `snake_case` (e.g., `user.rb`)
- Database columns: `snake_case` with prefix (e.g., `anyon_projects`)
- JavaScript components: `PascalCase` (e.g., `AnyonProfileBadge.jsx`)
- ERB partials: `snake_case` with underscore prefix (e.g., `_anyon_projects.html.erb`)
- CSS classes: Use Crayons utility classes or `.vibecoding-*` if custom needed

**No Detected Conflicts:** All changes are additive (new column, new views/partials) and follow established Forem extension patterns.

### Learnings from Previous Story

**From Story 2-2-anyon-project-linking-in-posts (Status: drafted)**

Previous story 2-2 is currently in "drafted" status, meaning it has not yet been implemented by the Dev agent. Therefore, there are no Dev Agent completion notes, file changes, or architectural decisions to learn from yet.

**Expected Dependencies (when Story 2.2 is implemented):**
- **Shared Service**: `Anyon::ConversionTracker` service will be available for reuse (created in Story 2.2 or 2.4)
- **Shared Patterns**: `AnyonTrackable` concern pattern from Story 2.2 demonstrates how to extend models with ANYON tracking
- **Validation Patterns**: URL validation approach (HTTPS enforcement, URI parsing) should be consistent with Story 2.2
- **UTM Parameter Generation**: Reuse helper methods for consistent UTM tracking across posts and profiles

**Note for Dev Agent:** If Story 2.2 has been completed when you start this story, review the following sections in `docs/stories/2-2-anyon-project-linking-in-posts.md`:
- Dev Agent Record → Completion Notes List (for patterns and services created)
- Dev Agent Record → File List (for files created/modified)
- Senior Developer Review findings (if review has been completed)

[Source: docs/stories/2-2-anyon-project-linking-in-posts.md - Currently drafted, not yet implemented]

### References

**Technical Specifications:**
- [Source: docs/tech-spec-epic-2.md#Story 2.3: ANYON Project Linking in User Profiles] - Detailed design, data models, workflows
- [Source: docs/tech-spec-epic-2.md#Users Table Extension (Story 2.3)] - Migration details and JSONB schema
- [Source: docs/tech-spec-epic-2.md#Workflow 3: User Adds ANYON Projects to Profile] - User workflow and sequence diagram
- [Source: docs/tech-spec-epic-2.md#Data Validation Rules] - Validation requirements for ANYON projects

**Epic Context:**
- [Source: docs/epics.md#Story 2.3: ANYON Project Linking in User Profiles] - User story, acceptance criteria, prerequisites
- [Source: docs/epics.md#Epic 2: ANYON Integration & Conversion Funnel] - Epic goal and business value

**Architecture Decisions:**
- [Source: docs/architecture.md#ADR-001: Brownfield Customization Strategy] - Extension patterns and constraints
- [Source: docs/architecture.md#Pattern 2: Namespacing] - How to namespace custom code
- [Source: docs/architecture.md#Pattern 4: Preact Components] - Frontend component standards (if using Preact)

**Testing Standards:**
- [Source: docs/architecture.md#Testing Strategy] - Coverage targets, test types, frameworks
- [Source: docs/tech-spec-epic-2.md#Story 2.3 Test Cases] - Specific test cases for this story

**Performance Requirements:**
- [Source: docs/tech-spec-epic-2.md#Performance] - Profile load impact target: < 150ms additional load time

**Security Requirements:**
- [Source: docs/tech-spec-epic-2.md#Security] - URL validation, XSS prevention, HTTPS enforcement

## Dev Agent Record

### Context Reference

<!-- Path(s) to story context XML will be added here by context workflow -->

### Agent Model Used

Claude Sonnet 4.5 (claude-sonnet-4-5-20250929)

### Debug Log References

### Completion Notes List

### File List
