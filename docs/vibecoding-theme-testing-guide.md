# Vibecoding Theme Testing Guide

This document provides comprehensive testing procedures for the vibecoding custom theme, covering responsive design, accessibility compliance, cross-browser compatibility, and performance validation.

## Table of Contents

1. [Responsive Design Testing](#responsive-design-testing)
2. [Accessibility Compliance Testing](#accessibility-compliance-testing)
3. [Cross-Browser Testing](#cross-browser-testing)
4. [Performance Testing](#performance-testing)
5. [Visual QA Checklist](#visual-qa-checklist)
6. [Automated Testing](#automated-testing)

---

## Responsive Design Testing

### AC-1.4.9: Theme works responsively across mobile, tablet, desktop

#### Test Viewports

Test the vibecoding theme across these standard breakpoints:

1. **Mobile (< 768px)**
   - 375x667px (iPhone SE, most common mobile size)
   - 360x740px (Samsung Galaxy S8+)
   - 414x896px (iPhone 11 Pro Max)

2. **Tablet (768px - 1024px)**
   - 768x1024px (iPad portrait)
   - 1024x768px (iPad landscape)
   - 834x1112px (iPad Pro 10.5")

3. **Desktop (> 1024px)**
   - 1366x768px (common laptop resolution)
   - 1920x1080px (Full HD)
   - 2560x1440px (2K display)

#### Responsive Testing Procedure

**Using Chrome DevTools:**

```bash
1. Open Chrome Developer Tools (F12 or Ctrl+Shift+I)
2. Click "Toggle Device Toolbar" (Ctrl+Shift+M)
3. Select device preset or enter custom dimensions
4. Test each viewport size listed above
```

**Manual Testing Checklist:**

- [ ] **Mobile (375px width)**
  - [ ] Logo scales appropriately in header (32px height)
  - [ ] Navigation menu collapses to hamburger icon
  - [ ] Text remains readable (no overflow or tiny fonts)
  - [ ] Buttons are tappable (min 44x44px touch target)
  - [ ] Images scale responsively
  - [ ] No horizontal scrolling on any page
  - [ ] Footer content stacks vertically

- [ ] **Tablet (768px width)**
  - [ ] Logo displays at medium size (36px height)
  - [ ] Navigation shows condensed menu
  - [ ] Two-column layouts display correctly
  - [ ] Sidebar content is accessible
  - [ ] Cards/posts display in grid (2 columns)

- [ ] **Desktop (1366px+ width)**
  - [ ] Logo displays at full size (40px height)
  - [ ] Full navigation menu visible
  - [ ] Three-column layout works properly
  - [ ] Content centered with max-width (--site-width: 1380px)
  - [ ] Sidebar remains fixed during scroll
  - [ ] No excessive white space on ultra-wide screens

#### Responsive Component Tests

**Hero Section (`.vibecoding-hero`):**
```css
/* Mobile: Padding reduces to var(--su-6) */
/* Desktop: Padding increases to var(--su-8) */
```

Test:
- [ ] Hero section padding adjusts at 768px breakpoint
- [ ] Title font size increases on desktop (--fs-4xl → --fs-5xl)
- [ ] Background gradient displays smoothly across all sizes

**CTA Buttons (`.vibecoding-cta`):**
- [ ] Buttons are full-width on mobile (< 480px) if needed
- [ ] Button text wraps appropriately
- [ ] Hover states work on desktop (not on mobile)
- [ ] Touch targets meet 44x44px minimum on mobile

---

## Accessibility Compliance Testing

### AC-1.4.10: Accessibility maintained (WCAG 2.1 Level A compliance)

#### Color Contrast Testing

**WCAG 2.1 Level A Requirements:**
- Normal text (< 18px): Minimum 4.5:1 contrast ratio
- Large text (≥ 18px or ≥ 14px bold): Minimum 3:1 contrast ratio

**Vibecoding Color Contrast Ratios:**

| Foreground | Background | Ratio | WCAG Level | Notes |
|------------|------------|-------|------------|-------|
| #090909 (text) | #F9F9F9 (body bg) | 16.5:1 | AAA ✓ | Body text |
| #FF6B35 (primary) | #FFFFFF (card bg) | 3.2:1 | AA Large ✓ | Large text only |
| #004E89 (secondary) | #FFFFFF | 8.5:1 | AAA ✓ | All text sizes |
| #F9F9F9 (text) | #FF6B35 (button) | 3.2:1 | AA Large ✓ | CTA buttons |
| #FF8A5B (dark primary) | #242424 (dark bg) | 4.8:1 | AA ✓ | Dark mode text |

**Contrast Testing Tools:**

1. **WebAIM Contrast Checker**: https://webaim.org/resources/contrastchecker/
2. **Chrome DevTools**:
   ```
   Inspect element → Styles tab → Color picker → Shows contrast ratio
   ```
3. **WAVE Browser Extension**: https://wave.webaim.org/extension/

**Testing Procedure:**

- [ ] Test all text/background combinations using WebAIM checker
- [ ] Verify primary orange (#FF6B35) used only for large text or headings
- [ ] Confirm all body text uses sufficient contrast (4.5:1+)
- [ ] Check link colors against background colors
- [ ] Validate button text contrast in both light and dark modes
- [ ] Test focus indicators (outline contrast must be 3:1+)

#### Keyboard Navigation Testing

**Requirements:**
- All interactive elements must be keyboard accessible
- Focus indicators must be visible
- Tab order must be logical

**Testing Procedure:**

1. **Basic Navigation**:
   - [ ] Tab key moves focus through all interactive elements
   - [ ] Shift+Tab moves focus backward
   - [ ] Enter/Space activates buttons and links
   - [ ] Arrow keys work in dropdown menus

2. **Focus Indicators**:
   - [ ] All focused elements show visible outline
   - [ ] Vibecoding CTA buttons show focus ring (2px outline)
   - [ ] Focus ring color meets 3:1 contrast ratio
   - [ ] Focus not trapped in any component

3. **Skip Links**:
   - [ ] "Skip to main content" link present (`.vibecoding-skip-link`)
   - [ ] Skip link becomes visible on focus
   - [ ] Skip link moves focus to main content area

#### Screen Reader Testing

**Tools:**
- **NVDA** (Windows, free): https://www.nvaccess.org/
- **JAWS** (Windows, trial): https://www.freedomscientific.com/
- **VoiceOver** (Mac, built-in): Cmd+F5

**Testing Checklist:**

- [ ] Logo has appropriate alt text ("Vibecoding Community")
- [ ] All images have alt text or role="presentation" for decorative images
- [ ] Form inputs have associated labels
- [ ] Buttons have descriptive text (not just icons)
- [ ] ARIA labels used appropriately (not overused)
- [ ] Heading hierarchy is logical (h1 → h2 → h3, no skips)
- [ ] Dark mode toggle has clear label and state

#### Lighthouse Accessibility Audit

**Target Score: > 90**

Run Lighthouse in Chrome DevTools:

```bash
1. Open Chrome DevTools (F12)
2. Navigate to "Lighthouse" tab
3. Select "Accessibility" category
4. Click "Generate report"
```

**Common Issues to Fix:**

- Missing alt text on images
- Insufficient color contrast
- Missing form labels
- Duplicate IDs
- Missing ARIA landmarks

**Acceptance Criteria:**
- [ ] Lighthouse accessibility score ≥ 90
- [ ] All critical issues resolved (red flags)
- [ ] Best practices followed for ARIA usage

#### axe DevTools Testing

**Tool**: https://www.deque.com/axe/devtools/

Install browser extension and run scan:

```bash
1. Install axe DevTools extension for Chrome/Firefox
2. Open DevTools, navigate to "axe DevTools" tab
3. Click "Scan ALL of my page"
4. Review issues by severity (Critical, Serious, Moderate, Minor)
```

**Acceptance Criteria:**
- [ ] Zero critical issues
- [ ] Zero serious issues
- [ ] Document any moderate/minor issues with justification

---

## Cross-Browser Testing

### AC-1.4 (Implied): Theme works across modern browsers

#### Browsers to Test

**Desktop Browsers (latest versions):**

1. **Google Chrome** (v120+)
2. **Mozilla Firefox** (v120+)
3. **Microsoft Edge** (v120+)
4. **Safari** (v17+, macOS only)

**Mobile Browsers:**

1. **Safari iOS** (iPhone/iPad)
2. **Chrome Android** (Samsung, Pixel devices)
3. **Samsung Internet** (Samsung devices)

#### Cross-Browser Testing Procedure

**For Each Browser:**

- [ ] **Logo Display**
  - [ ] SVG logo renders correctly
  - [ ] Logo scales appropriately
  - [ ] Dark mode logo switches correctly

- [ ] **Color Rendering**
  - [ ] CSS custom properties apply correctly
  - [ ] Gradient backgrounds display smoothly
  - [ ] Opacity/transparency works as expected

- [ ] **CSS Features**
  - [ ] Grid/Flexbox layouts work
  - [ ] CSS transforms (translateY on hover) function
  - [ ] Transitions/animations play smoothly
  - [ ] Border-radius displays correctly

- [ ] **Dark Mode**
  - [ ] [data-theme="dark"] selector applies
  - [ ] Dark mode colors render correctly
  - [ ] Toggle switch works
  - [ ] Theme preference persists

- [ ] **Fonts**
  - [ ] Inter font loads (if using Google Fonts)
  - [ ] Fallback fonts display correctly
  - [ ] Font weights render properly (400, 600, 700)

#### Browser-Specific Issues to Watch

**Safari:**
- CSS custom properties in pseudo-elements
- Gradient rendering differences
- SVG scaling issues

**Firefox:**
- Flexbox gap property support (use margin as fallback if needed)
- Scroll-behavior smooth (may not work)

**Edge:**
- Generally matches Chrome (Chromium-based)
- Occasional CSS grid differences

**Mobile Safari:**
- Viewport units (vh/vw) behave differently
- Touch event handling
- Fixed positioning quirks

#### Testing Tools

**BrowserStack** (optional, paid):
https://www.browserstack.com/

**LambdaTest** (optional, free tier):
https://www.lambdatest.com/

**Manual Testing**:
- Use actual devices if available
- Chrome DevTools device emulation for quick checks

---

## Performance Testing

### AC-1.4 (Implied): Theme does not degrade performance

#### Lighthouse Performance Audit

**Target Score: > 90**

Run Lighthouse performance audit:

```bash
1. Open Chrome DevTools → Lighthouse tab
2. Select "Performance" category
3. Set throttling: "Simulated Throttling (Mobile 4G)"
4. Clear cache and run report
```

**Key Metrics:**

| Metric | Target | Notes |
|--------|--------|-------|
| First Contentful Paint (FCP) | < 1.8s | When first content appears |
| Largest Contentful Paint (LCP) | < 2.5s | Main content loaded |
| Cumulative Layout Shift (CLS) | < 0.1 | No unexpected layout shifts |
| Total Blocking Time (TBT) | < 300ms | Page responsiveness |

**Acceptance Criteria:**
- [ ] Lighthouse performance score ≥ 90
- [ ] LCP < 2.5s (good)
- [ ] CLS < 0.1 (good)
- [ ] TBT < 300ms (good)

#### CSS Bundle Size

**Constraint:** Custom theme adds < 10KB to CSS payload

**Measurement:**

```bash
# Check compiled CSS size
ls -lh public/assets/application-*.css

# Or during asset precompilation
rails assets:precompile
# Check output for vibecoding/theme.scss size
```

**Acceptance Criteria:**
- [ ] `vibecoding/theme.scss` compiles to < 10KB
- [ ] No significant increase to total CSS bundle size
- [ ] No duplicate CSS rules

#### Asset Loading Performance

**Logo/Image Optimization:**

- [ ] SVG files are optimized (unnecessary metadata removed)
- [ ] SVG logos are < 5KB each
- [ ] PNG assets use appropriate compression
- [ ] Assets served with proper caching headers

**Font Loading:**

If using Google Fonts (Inter):

```html
<!-- Use font-display: swap for better performance -->
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&display=swap" rel="stylesheet">
```

- [ ] Fonts load asynchronously (font-display: swap)
- [ ] Fallback fonts display during font loading
- [ ] No Flash of Unstyled Text (FOUT) on repeat visits

---

## Visual QA Checklist

### General Visual Validation

- [ ] **Homepage**
  - [ ] Logo visible in header
  - [ ] Brand colors applied to UI elements
  - [ ] Hero section displays correctly (if implemented)
  - [ ] All images load properly

- [ ] **Article/Post Page**
  - [ ] Typography styles applied correctly
  - [ ] Code blocks styled appropriately
  - [ ] Blockquotes/callouts use vibecoding colors
  - [ ] Comments section displays correctly

- [ ] **User Profile Page**
  - [ ] Profile cards use theme colors
  - [ ] Badges/pills styled correctly
  - [ ] Avatar placeholders use brand colors

- [ ] **Dark Mode**
  - [ ] Toggle switch works
  - [ ] All pages adapt to dark theme
  - [ ] Logo switches to dark variant (if applicable)
  - [ ] Colors maintain readability
  - [ ] No "flashbang" white backgrounds

- [ ] **Footer**
  - [ ] Logo appears in footer
  - [ ] Brand colors applied
  - [ ] Links styled correctly
  - [ ] Copyright/legal text readable

### Component-Specific Checks

- [ ] **Buttons**
  - [ ] Primary buttons use vibecoding orange
  - [ ] Hover states work (color darkens)
  - [ ] Disabled states styled appropriately
  - [ ] Focus indicators visible

- [ ] **Links**
  - [ ] Link color uses brand palette
  - [ ] Visited links styled differently
  - [ ] Hover/focus states clear
  - [ ] No broken or missing links

- [ ] **Forms**
  - [ ] Input fields have proper borders
  - [ ] Labels positioned correctly
  - [ ] Error states use appropriate colors
  - [ ] Success states use green accent

---

## Automated Testing

### Cypress E2E Tests (Optional)

If Cypress is configured in the project, create a theme test:

**`cypress/e2e/vibecoding-theme.cy.js`:**

```javascript
describe('Vibecoding Theme', () => {
  beforeEach(() => {
    cy.visit('/')
  })

  it('displays vibecoding logo in header', () => {
    cy.get('header img[alt*="vibecoding"]').should('be.visible')
  })

  it('applies brand colors to primary buttons', () => {
    cy.get('.crayons-btn--primary').should('have.css', 'background-color')
      .and('match', /rgb\(255, 107, 53\)/) // #FF6B35
  })

  it('toggles dark mode correctly', () => {
    cy.get('[data-testid="dark-mode-toggle"]').click()
    cy.get('html').should('have.attr', 'data-theme', 'dark')

    // Verify dark mode colors applied
    cy.get('body').should('have.css', 'background-color')
      .and('match', /rgb\(36, 36, 36\)/) // --base-90 in dark mode
  })

  it('is responsive on mobile viewport', () => {
    cy.viewport('iphone-6')
    cy.get('header .logo').should('have.css', 'height', '32px')
    cy.get('.hamburger-menu').should('be.visible')
  })

  it('meets accessibility standards', () => {
    cy.injectAxe()
    cy.checkA11y()
  })
})
```

### RSpec Tests (Ruby, for admin configuration)

**`spec/features/admin/theme_config_spec.rb`:**

```ruby
require 'rails_helper'

RSpec.describe 'Admin Theme Configuration', type: :feature do
  it 'allows admin to upload vibecoding logo' do
    admin = create(:user, :admin)
    login_as(admin)

    visit '/admin/customization/config'
    attach_file('Logo', Rails.root.join('app/assets/images/vibecoding/logo.svg'))
    click_button 'Save'

    expect(page).to have_content('Logo updated successfully')
  end
end
```

---

## Test Results Documentation

After completing all tests, document results in the story file:

**Story File Update:**

```markdown
## Testing Results

### Responsive Design (AC-1.4.9) ✓
- Mobile (375px): Logo scales, navigation collapses correctly
- Tablet (768px): Two-column layout displays properly
- Desktop (1366px): Full layout with sidebar functional
- No horizontal scrolling on any viewport

### Accessibility (AC-1.4.10) ✓
- Lighthouse Score: 94/100
- Color Contrast: All text meets WCAG 2.1 Level A (4.5:1+)
- Keyboard Navigation: All elements accessible via Tab
- Screen Reader: Logo alt text present, headings logical
- axe DevTools: 0 critical, 0 serious issues

### Cross-Browser Compatibility ✓
- Chrome 120: All features working
- Firefox 121: All features working
- Edge 120: All features working
- Safari 17: All features working
- Mobile Safari (iOS 17): Responsive design correct

### Performance ✓
- Lighthouse Performance: 92/100
- CSS Bundle Size: vibecoding/theme.scss = 8.2KB (< 10KB target)
- LCP: 1.8s (< 2.5s target)
- CLS: 0.05 (< 0.1 target)
```

---

## Summary

This testing guide covers all required acceptance criteria for Story 1.4:

- **AC-1.4.1 - AC-1.4.8**: Verified through visual QA and configuration
- **AC-1.4.9**: Validated through responsive design testing
- **AC-1.4.10**: Confirmed via accessibility compliance tests

Run all tests before marking the story as "Ready for Review" (status: review).
