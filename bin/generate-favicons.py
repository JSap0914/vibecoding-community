#!/usr/bin/env python3
"""
[VIBECODING] Generate PNG favicons and app icons from SVG source
Story 1.4 - Review Action Item: Generate missing PNG assets

Requirements:
  pip install cairosvg Pillow

Usage:
  python bin/generate-favicons.py
"""

import os
import sys
from pathlib import Path

# ANSI color codes
GREEN = '\033[0;32m'
YELLOW = '\033[1;33m'
RED = '\033[0;31m'
NC = '\033[0m'  # No Color

print(f"{GREEN}Vibecoding Favicon & App Icon Generator{NC}")
print("==========================================")
print()

# Check for required modules
try:
    import cairosvg
    from PIL import Image
    print(f"{GREEN}✓{NC} Found: cairosvg and Pillow")
    print()
except ImportError as e:
    print(f"{RED}Error: Required Python modules not found{NC}")
    print()
    print("Please install dependencies:")
    print("  pip install cairosvg Pillow")
    print()
    print("Or use alternative generation scripts:")
    print("  bash bin/generate-favicons.sh")
    print("  node bin/generate-favicons.js")
    print()
    sys.exit(1)

# Paths
source_dir = Path(__file__).parent.parent / 'app' / 'assets' / 'images' / 'vibecoding'
icon_svg = source_dir / 'icon.svg'

# Asset specifications
assets = [
    {'name': 'favicon-32.png', 'width': 32, 'height': 32, 'category': 'Favicons'},
    {'name': 'favicon-64.png', 'width': 64, 'height': 64, 'category': 'Favicons'},
    {'name': 'app-icon-180.png', 'width': 180, 'height': 180, 'category': 'App Icons (iOS)'},
    {'name': 'app-icon-192.png', 'width': 192, 'height': 192, 'category': 'App Icons (Android/PWA)'},
    {'name': 'app-icon-512.png', 'width': 512, 'height': 512, 'category': 'App Icons (Android/PWA)'},
]

def generate_assets():
    """Generate PNG assets from SVG source."""
    # Check source file exists
    if not icon_svg.exists():
        print(f"{RED}Error: Source icon not found: {icon_svg}{NC}")
        sys.exit(1)

    print(f"Source: {icon_svg}")
    print()
    print("Generating assets...")
    print()

    current_category = ''

    for asset in assets:
        # Print category header
        if asset['category'] != current_category:
            if current_category:
                print()
            print(f"{asset['category']}:")
            current_category = asset['category']

        output_path = source_dir / asset['name']

        try:
            # Convert SVG to PNG at specified dimensions
            cairosvg.svg2png(
                url=str(icon_svg),
                write_to=str(output_path),
                output_width=asset['width'],
                output_height=asset['height']
            )

            # Get file size
            size_kb = output_path.stat().st_size / 1024
            print(f"{GREEN}✓{NC} Generated: {asset['name']} ({asset['width']}x{asset['height']}, {size_kb:.1f}KB)")
        except Exception as e:
            print(f"{RED}✗{NC} Failed: {asset['name']}")
            print(f"  Error: {str(e)}")

    print()

def verify_assets():
    """Verify all required assets were generated."""
    print("Verification:")
    print()

    required_files = [
        'favicon-32.png',
        'favicon-64.png',
        'app-icon-180.png',
        'app-icon-192.png',
        'app-icon-512.png',
    ]

    all_present = True

    for file in required_files:
        file_path = source_dir / file
        if file_path.exists():
            print(f"{GREEN}✓{NC} {file}")
        else:
            print(f"{RED}✗{NC} {file} (missing)")
            all_present = False

    print()

    if all_present:
        print(f"{GREEN}All required PNG assets generated successfully!{NC}")
        print()
        print("Next steps:")
        print("1. Review generated files: ls -lh app/assets/images/vibecoding/")
        print("2. Upload to Forem Admin Panel: /admin/customization/config")
        print("3. Commit with: git add app/assets/images/vibecoding/*.png")
        print("4. Commit message: [VIBECODING] Generate PNG favicon and app icon assets (Story 1.4)")
    else:
        print(f"{YELLOW}Warning: Some assets missing. Check errors above.{NC}")
        sys.exit(1)

def main():
    """Main execution."""
    try:
        generate_assets()
        verify_assets()
    except Exception as e:
        print(f"{RED}Fatal error:{NC} {str(e)}")
        sys.exit(1)

if __name__ == '__main__':
    main()
