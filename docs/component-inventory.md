# UI Component Inventory - Vibecoding Community

## Overview

This document catalogs the UI components in the Vibecoding Community platform. The frontend uses Preact (React-compatible) with a custom design system called "Crayons."

**Frontend Framework:** Preact 10.20.2
**Build Tool:** ESBuild
**Component Count:** 305+ JSX/TSX files
**Design System:** Crayons
**Component Testing:** Jest + Testing Library
**UI Documentation:** Storybook

---

## Design System: Crayons

Located in `app/javascript/crayons/`

The Crayons design system provides a comprehensive set of reusable UI components following consistent design patterns.

### Form Components

**Input Elements:**
- `AutocompleteTriggerTextArea/` - Autocomplete textarea with mentions
- `FormField/` - Standard form field wrapper
- `TextArea/` - Enhanced textarea component
- `RadioButton/` - Radio button inputs
- `Checkbox/` - Checkbox inputs
- `Select/` - Dropdown select component

### Button Components

- `Button/` - Primary button component
- `ButtonGroup/` - Button grouping container
- `Buttons/` - Button variants and styles
- `IconButton/` - Icon-only buttons

**Features:**
- Multiple variants (primary, secondary, outlined, ghost)
- Size options (small, medium, large)
- Loading states
- Disabled states
- Icon support

### Display Components

**Avatars & Logos:**
- `avatarsAndLogos/Avatar/` - User avatar component
- `avatarsAndLogos/Logo/` - Brand logo component

**Content Display:**
- `Card/` - Content card container
- `Badge/` - Status badges and tags
- `Pills/` - Pill-shaped labels
- `Tooltip/` - Tooltip overlay

### Layout Components

- `Container/` - Layout container
- `Grid/` - Grid layout system
- `Spacing/` - Spacing utilities
- `Divider/` - Visual separators

### Navigation Components

- `Tabs/` - Tab navigation
- `Breadcrumbs/` - Breadcrumb navigation
- `Pagination/` - Page navigation
- `Menu/` - Dropdown menus

### Feedback Components

- `Modal/` - Modal dialogs
- `Alert/` - Alert messages
- `Toast/` - Toast notifications
- `Snackbar/` - Snackbar messages
- `Loading/` - Loading indicators

---

## Feature-Specific Components

Located in `app/javascript/[feature]/components/`

### Article Components

**Location:** `app/javascript/articles/components/`

- Article card
- Article preview
- Article list
- Article metadata
- Reading time indicator
- Save to reading list button

### Article Form Components

**Location:** `app/javascript/article-form/components/`

**Key Components:**
- Rich text editor
- Markdown preview
- Tag selector
- Cover image uploader
- Canonical URL input
- Series selector
- Publishing options

**Features:**
- Auto-save drafts
- Markdown support
- Image upload with drag & drop
- Tag autocomplete

### Actions Panel Components

**Location:** `app/javascript/actionsPanel/`

- Comment actions
- Article actions
- Moderation tools
- Reaction buttons

### Reading List Components

**Location:** `app/javascript/readingList/components/`

- Reading list item
- Archive button
- Tag filter
- Sort options

### Onboarding Components

**Location:** `app/javascript/onboarding/components/`

- Welcome flow
- Profile setup
- Interests selection
- Follow suggestions
- Onboarding progress

### Listings Components

**Location:** `app/javascript/listings/components/`

- Listing card
- Listing form
- Category selector
- Listing filters

---

## Shared Components

**Location:** `app/javascript/shared/components/`

**Common UI Elements:**
- Navigation bar
- Footer
- Sidebar
- Search bar
- User menu
- Notification dropdown

**Utility Components:**
- Image uploader
- Date picker
- Color picker
- Emoji picker
- Code highlighter

---

## Admin Components

**Location:** `app/javascript/admin/`

- Admin dashboard widgets
- User management tables
- Content moderation interface
- Analytics charts
- Configuration panels

---

## Analytics Components

**Location:** `app/javascript/analytics/`

- Chart.js wrappers
- Analytics dashboards
- Metrics visualization
- Report generators

---

## Stimulus Controllers

**Location:** `app/javascript/controllers/`

**Pattern:** Hotwire Stimulus for progressive enhancement

**Key Controllers:**
- Form controllers
- Modal controllers
- Dropdown controllers
- Tab controllers
- Tooltip controllers

**Integration:** Works alongside Preact components for hybrid approach

---

## Component Patterns

### Component Structure

```
ComponentName/
├── ComponentName.jsx          # Main component
├── ComponentName.module.css   # Scoped styles (if any)
├── index.js                   # Export barrel
├── __stories__/
│   └── ComponentName.stories.jsx  # Storybook stories
└── __tests__/
    └── ComponentName.test.jsx     # Jest tests
```

### Prop Types

Components use `prop-types` package for runtime type checking.

**Common Prop Types:** `app/javascript/common-prop-types/`

### Hooks

**Location:** `app/javascript/hooks/`

**Custom Hooks:**
- `useMediaQuery` - Responsive breakpoints
- `useDebounce` - Debounced values
- `useLocalStorage` - LocalStorage sync
- `useFetch` - Data fetching
- `useKeyboardShortcuts` - Keyboard navigation

---

## Styling Approach

### CSS Strategy

**Primary:** Sass/SCSS
**Location:** `app/assets/stylesheets/`
**Utility Classes:** Custom utility class system

**CSS Architecture:**
- Component-scoped styles
- Theme variables
- Utility classes
- Responsive breakpoints

### Theming

**Themes Available:**
- Default (light)
- Dark mode
- High contrast
- Custom brand themes

**Theme Configuration:** `app/assets/stylesheets/themes/`

**Theme Switching:**
- User preference stored in DB
- CSS custom properties for theme colors
- Automatic OS preference detection

---

## Icon System

**Library:** Inline SVG components
**Location:** `app/assets/images/` and inlined in components

**Implementation:**
- `inline_svg` gem for Rails views
- `babel-plugin-inline-react-svg` for Preact components

---

## State Management

### Local State

**Pattern:** Preact hooks (`useState`, `useReducer`)

### Global State

**Approach:** Context API for shared state

**Key Contexts:**
- User context
- Theme context
- Notifications context
- Feature flags context

**Location:** `app/javascript/shared/contexts/`

### External State

**Library:** None (uses Context + Hooks)
**No Redux** - Deliberately avoided for simplicity

---

## Component Testing

### Testing Stack

- **Test Runner:** Jest 28
- **Testing Library:** @testing-library/preact
- **Mocking:** jest-mock, jest-fetch-mock
- **Accessibility:** jest-axe
- **Coverage:** Built-in Jest coverage

### Test Location

**Unit Tests:** `__tests__/` folders co-located with components
**Integration Tests:** `spec/system/` (Capybara)
**E2E Tests:** `cypress/` (Cypress)

---

## Storybook Documentation

**Version:** Storybook 6.5.16
**Configuration:** `app/javascript/.storybook/`
**Stories:** `__stories__/` folders co-located with components

**Run Storybook:**
```bash
yarn storybook
```

**Addons:**
- Accessibility (a11y)
- Controls
- Docs
- Actions
- Backgrounds
- CSS Variables Theme switcher

---

## Accessibility

**Standards:** WCAG 2.1 AA compliance

**Tools:**
- `eslint-plugin-jsx-a11y` - Linting
- `@storybook/addon-a11y` - Storybook testing
- `jest-axe` - Automated a11y testing
- `wcag_color_contrast` gem - Color contrast checking

**Best Practices:**
- Semantic HTML
- ARIA labels where needed
- Keyboard navigation
- Focus management
- Screen reader tested

---

## Internationalization (i18n)

**Library:** i18n-js (4.4.3)
**Backend:** Rails I18n
**Translations:** `config/locales/`

**Supported Languages:**
- English (default)
- Portuguese
- Spanish
- French
- (and more - see locale_analysis.md)

**Component Usage:**
```jsx
import { I18n } from '@utils/i18n';

<Button>{I18n.t('buttons.submit')}</Button>
```

---

## Component Development Guidelines

### Creating New Components

1. Place in appropriate directory (`crayons/` for design system, `[feature]/components/` for feature-specific)
2. Create component file, stories, and tests
3. Add prop-types validation
4. Document in Storybook
5. Ensure accessibility
6. Add unit tests
7. Update this inventory

### Component Naming

- PascalCase for component names
- Descriptive, not too generic
- Avoid prefixes like "My" or "Custom"

### Best Practices

- Keep components small and focused
- Prefer composition over inheritance
- Use hooks for logic reuse
- Memoize expensive computations
- Handle loading and error states

---

## Build & Bundle

**Build Tool:** ESBuild
**Config:** `esbuild.config.mjs`

**Entry Points:**
- Main application bundle
- Stimulus controllers
- Storybook assets

**Output:** `public/packs/` (managed by jsbundling-rails)

---

## Performance Optimization

**Techniques:**
- Code splitting
- Lazy loading
- Memoization (`memo`, `useMemo`, `useCallback`)
- Virtual scrolling for long lists
- Image lazy loading
- Bundle size monitoring

---

**Generated:** 2025-11-09 (Deep Scan)
**Component Count:** 305+ files
**Design System:** Crayons
