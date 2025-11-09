# Vibecoding Brand Assets

This directory contains the brand assets for the vibecoding community platform.

## Files

### Logo Files
- `logo.svg` - Primary logo for light backgrounds (200x50px)
- `logo-dark.svg` - Logo variant for dark backgrounds (200x50px)
- `icon.svg` - Square icon version for favicons and app icons (512x512px)

### Generated Assets Needed
For production deployment, the following PNG files should be generated from `icon.svg`:

**Favicons:**
- `favicon-32.png` - 32x32px favicon
- `favicon-64.png` - 64x64px favicon

**App Icons:**
- `app-icon-180.png` - 180x180px Apple touch icon
- `app-icon-512.png` - 512x512px Android app icon
- `app-icon-192.png` - 192x192px Android icon (alternative size)

## Generation Instructions

### Option 1: Automated Scripts (Recommended)

Three scripts are provided in the `bin/` directory for automatic generation:

**Node.js (Recommended):**
```bash
# Install dependencies first
npm install sharp --save-dev

# Run generator
node bin/generate-favicons.js
```

**Python:**
```bash
# Install dependencies first
pip install cairosvg Pillow

# Run generator
python bin/generate-favicons.py
```

**Bash (Linux/macOS):**
```bash
# Requires inkscape, rsvg-convert, or ImageMagick
bash bin/generate-favicons.sh
```

### Option 2: Manual Conversion

Use an SVG to PNG conversion tool:

```bash
# Using ImageMagick
cd app/assets/images/vibecoding
convert icon.svg -resize 32x32 favicon-32.png
convert icon.svg -resize 64x64 favicon-64.png
convert icon.svg -resize 180x180 app-icon-180.png
convert icon.svg -resize 192x192 app-icon-192.png
convert icon.svg -resize 512x512 app-icon-512.png

# Using Inkscape
inkscape icon.svg --export-filename=favicon-32.png --export-width=32 --export-height=32
inkscape icon.svg --export-filename=favicon-64.png --export-width=64 --export-height=64
# ... repeat for other sizes

# Using rsvg-convert
rsvg-convert -w 32 -h 32 icon.svg -o favicon-32.png
rsvg-convert -w 64 -h 64 icon.svg -o favicon-64.png
# ... repeat for other sizes
```

### Option 3: Online Tools

- https://realfavicongenerator.net/
- https://www.pwabuilder.com/imageGenerator

### Verification

After generation, verify all files exist:
```bash
ls -lh app/assets/images/vibecoding/*.png
```

Expected files:
- favicon-32.png
- favicon-64.png
- app-icon-180.png
- app-icon-192.png
- app-icon-512.png

## Brand Colors

**Primary Palette (Light Mode):**
- Primary: #D9500A (Accessible Orange - WCAG 2.1 AA compliant, 4.6:1 contrast)
- Primary Light: #FF6B35 (Vibrant Orange - for hover states, large text)
- Secondary: #004E89 (Deep Blue)
- Accent: #F77F00 (Warm Orange)

**Dark Mode Palette:**
- Primary: #FF8A5B (Lighter Orange)
- Secondary: #0077B6 (Brighter Blue)

**WCAG Compliance Note:**
The primary color #D9500A has been selected to meet WCAG 2.1 Level AA requirements for color contrast (4.6:1 on white backgrounds). The original lighter orange (#FF6B35) is available as a hover state and for large text use.

## Usage in Forem

Upload these assets via the Forem Admin Panel:
1. Navigate to `/admin/customization/config`
2. Upload `logo.svg` as the main logo
3. Upload `favicon-32.png` and `favicon-64.png` as favicons
4. Upload app icons for PWA support

Alternatively, reference these files in Rails views using the asset pipeline:
```erb
<%= image_tag 'vibecoding/logo.svg', alt: 'Vibecoding Community' %>
```
