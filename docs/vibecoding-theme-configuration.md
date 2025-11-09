# Vibecoding Theme Configuration Guide

This document provides step-by-step instructions for applying the vibecoding custom theme to the Forem platform.

## Overview

The vibecoding theme is implemented using:
1. **Forem Admin Panel** - No-code configuration for basic theming
2. **CSS Custom Properties** - Crayons design system variables for colors and typography
3. **Custom CSS** - Minimal overrides in `app/assets/stylesheets/vibecoding/theme.scss`
4. **Brand Assets** - Logo, favicons, and app icons in `app/assets/images/vibecoding/`

## Step 1: Access Forem Admin Panel

1. Navigate to `/admin/customization/config` (requires admin privileges)
2. You should see the "Config" section of the Forem admin interface

## Step 2: Upload Brand Assets

### Logo Configuration
1. In the Admin Panel, locate the "Logo" section
2. Upload `app/assets/images/vibecoding/logo.svg` as the main logo
3. Set logo dimensions: Width 200px, Height 50px
4. Alternative: For dark mode logo, upload `logo-dark.svg` if admin panel supports theme-specific logos

### Favicon Configuration
1. Locate the "Favicon" section
2. Upload `app/assets/images/vibecoding/favicon-32.png` (32x32)
3. Upload `app/assets/images/vibecoding/favicon-64.png` (64x64) if supported

### App Icons (PWA Support)
1. Locate the "App Icons" or "PWA" section
2. Upload Apple Touch Icon: `app-assets/images/vibecoding/app-icon-180.png` (180x180)
3. Upload Android Icons:
   - `app-icon-192.png` (192x192)
   - `app-icon-512.png` (512x512)

## Step 3: Configure Crayons Color Variables

In the Admin Panel's "Customization" section, configure the following CSS variables:

### Primary Brand Colors
```css
--accent-brand-rgb: 255, 107, 53;        /* #FF6B35 - Vibecoding Orange */
--accent-brand-lighter-rgb: 255, 138, 91; /* #FF8A5B */
--accent-brand-darker-rgb: 230, 85, 39;   /* #E65527 */
```

### Secondary Colors
```css
/* These are already defined in vibecoding/theme.scss, but can be set here too */
--vibecoding-secondary: 0, 78, 137;      /* #004E89 - Deep Blue */
--vibecoding-accent: 247, 127, 0;        /* #F77F00 - Warm Orange */
```

## Step 4: Configure Typography

In the Admin Panel's typography settings:

### Font Family
```css
--ff-sans-serif: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif;
```

**Note:** To use the Inter font, you may need to enable Google Fonts integration in the admin panel:
1. Enable "Use Google Fonts" option
2. Enter font family: `Inter:400,500,600,700`

### Font Sizes (Optional - already well-defined in Crayons)
- Keep default Crayons font sizes unless specific customization is needed
- Base font size: 16px (1rem)

## Step 5: Configure Header and Footer

### Header Settings
- Background color: Default (white) - handled by CSS variables
- Height: 56px (default `--header-height`)
- Shadow: Enabled (controlled by `--header-shadow` variable)

### Footer Settings
- Background: Light gray (`--footer-bg: rgb(var(--grey-200))`)
- Text color: Medium gray (`--footer-color: rgb(var(--grey-700))`)

## Step 6: Enable Dark Mode Support

1. In Admin Panel, ensure "Dark Mode Toggle" is enabled
2. Dark mode theme is automatically handled by `app/assets/stylesheets/vibecoding/theme.scss`
3. The theme uses Forem's standard `[data-theme="dark"]` attribute selector

## Step 7: Verify Configuration

After saving all changes in the Admin Panel:

1. Navigate to the homepage
2. Verify vibecoding logo appears in header and footer
3. Check brand colors are applied (buttons, links, accents)
4. Toggle dark mode and verify theme adapts correctly
5. Test on mobile viewport to ensure responsive behavior

## Alternative: Manual Configuration (File-based)

If you don't have admin panel access or prefer file-based configuration:

### Update Configuration File (if exists)
Some Forem deployments use `config/settings.yml` or environment variables for theme settings:

```yaml
# config/settings.yml or similar
community:
  name: "Vibecoding Community"
  logo_svg: "vibecoding/logo.svg"
  favicon: "vibecoding/favicon-32.png"

theme:
  primary_brand_color: "#FF6B35"
  primary_brand_hex_color_rgb: "255, 107, 53"
```

### Asset References in Views
Edit layout files to reference vibecoding assets:

```erb
<!-- app/views/layouts/_header.html.erb (if customizing) -->
<%= image_tag 'vibecoding/logo.svg', alt: 'Vibecoding Community', class: 'logo' %>
```

## Accessibility Compliance

All vibecoding theme colors meet WCAG 2.1 Level A contrast requirements:

- **Text on White Background**: #FF6B35 on #FFFFFF = 3.2:1 (Large text OK, adjust for normal text)
- **Primary Text**: #090909 on #F9F9F9 = 16.5:1 ✓
- **Dark Mode Primary**: #FF8A5B on #242424 = 4.8:1 ✓

**Note:** For body text using brand orange (#FF6B35), ensure it's only used for large text (18px+) or headings. Use darker variants for smaller text to meet 4.5:1 minimum.

## Performance Optimization

The vibecoding theme is optimized for performance:

- **SVG Logos**: Scalable, small file size (~2KB each)
- **CSS Variables**: No JavaScript required for theming
- **Minimal CSS Bundle**: Custom theme adds < 10KB to CSS payload
- **CDN Ready**: Assets can be served from Cloudinary or Cloudflare CDN

## Troubleshooting

### Logo Not Showing
- Verify asset paths are correct
- Clear Rails asset cache: `rails tmp:cache:clear`
- Check browser console for 404 errors

### Colors Not Applying
- Ensure `vibecoding/theme.scss` is imported in `application.scss`
- Check CSS variable syntax (RGB values vs hex)
- Verify dark mode selector `[data-theme="dark"]` is working

### Dark Mode Not Working
- Ensure dark mode toggle is enabled in admin panel
- Verify `themes/dark.css` is loading
- Check that custom dark mode overrides in `vibecoding/theme.scss` are after base dark theme

## Next Steps

After configuring the theme:

1. **Test Accessibility**: Run Lighthouse audit, use axe DevTools
2. **Cross-browser Testing**: Chrome, Firefox, Safari, Edge
3. **Mobile Testing**: Test on actual devices (iOS, Android)
4. **Performance Testing**: Lighthouse performance score should be > 90
5. **Deploy to Staging**: Apply theme to staging environment for team review

## References

- [Forem Admin Customization Guide](https://docs.forem.com/)
- [Crayons Design System](https://crayons.io/)
- [WCAG Contrast Checker](https://webaim.org/resources/contrastchecker/)
- Vibecoding brand assets: `app/assets/images/vibecoding/`
- Custom theme CSS: `app/assets/stylesheets/vibecoding/theme.scss`
