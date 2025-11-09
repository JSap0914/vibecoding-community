#!/usr/bin/env bash
# [VIBECODING] Generate PNG favicons and app icons from SVG source
# Story 1.4 - Review Action Item: Generate missing PNG assets

set -e

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${GREEN}Vibecoding Favicon & App Icon Generator${NC}"
echo "=========================================="
echo ""

# Check for required tools
check_dependencies() {
    local missing=()

    if ! command -v inkscape &> /dev/null && ! command -v rsvg-convert &> /dev/null && ! command -v convert &> /dev/null; then
        echo -e "${RED}Error: No SVG conversion tool found${NC}"
        echo ""
        echo "Please install one of the following:"
        echo "  - Inkscape: https://inkscape.org/release/"
        echo "  - librsvg (rsvg-convert): brew install librsvg (macOS) or apt-get install librsvg2-bin (Linux)"
        echo "  - ImageMagick: https://imagemagick.org/script/download.php"
        echo ""
        exit 1
    fi

    # Determine which tool to use
    if command -v inkscape &> /dev/null; then
        CONVERTER="inkscape"
        echo -e "${GREEN}✓${NC} Found: Inkscape"
    elif command -v rsvg-convert &> /dev/null; then
        CONVERTER="rsvg-convert"
        echo -e "${GREEN}✓${NC} Found: rsvg-convert"
    elif command -v convert &> /dev/null; then
        CONVERTER="imagemagick"
        echo -e "${GREEN}✓${NC} Found: ImageMagick"
    fi

    echo ""
}

# Convert SVG to PNG using available tool
convert_svg() {
    local input=$1
    local output=$2
    local width=$3
    local height=${4:-$width}

    case $CONVERTER in
        inkscape)
            inkscape "$input" --export-filename="$output" --export-width=$width --export-height=$height 2>/dev/null
            ;;
        rsvg-convert)
            rsvg-convert -w $width -h $height "$input" -o "$output"
            ;;
        imagemagick)
            convert -background none -resize "${width}x${height}" "$input" "$output"
            ;;
    esac

    if [ -f "$output" ]; then
        local size=$(du -h "$output" | cut -f1)
        echo -e "${GREEN}✓${NC} Generated: $(basename $output) (${width}x${height}, $size)"
    else
        echo -e "${RED}✗${NC} Failed: $(basename $output)"
        return 1
    fi
}

# Main generation logic
generate_assets() {
    local source_dir="app/assets/images/vibecoding"
    local icon_svg="$source_dir/icon.svg"

    if [ ! -f "$icon_svg" ]; then
        echo -e "${RED}Error: Source icon not found: $icon_svg${NC}"
        exit 1
    fi

    echo "Source: $icon_svg"
    echo ""
    echo "Generating assets..."
    echo ""

    # Favicons
    echo "Favicons:"
    convert_svg "$icon_svg" "$source_dir/favicon-32.png" 32
    convert_svg "$icon_svg" "$source_dir/favicon-64.png" 64
    echo ""

    # App Icons
    echo "App Icons (iOS):"
    convert_svg "$icon_svg" "$source_dir/app-icon-180.png" 180
    echo ""

    echo "App Icons (Android/PWA):"
    convert_svg "$icon_svg" "$source_dir/app-icon-192.png" 192
    convert_svg "$icon_svg" "$source_dir/app-icon-512.png" 512
    echo ""

    # Generate ICO file (multi-resolution favicon for browsers)
    if command -v convert &> /dev/null; then
        echo "Multi-resolution Favicon (.ico):"
        convert "$source_dir/favicon-32.png" "$source_dir/favicon-64.png" "$source_dir/favicon.ico"
        if [ -f "$source_dir/favicon.ico" ]; then
            local size=$(du -h "$source_dir/favicon.ico" | cut -f1)
            echo -e "${GREEN}✓${NC} Generated: favicon.ico (multi-res, $size)"
        fi
        echo ""
    fi
}

# Verification
verify_assets() {
    echo "Verification:"
    echo ""

    local required_files=(
        "favicon-32.png"
        "favicon-64.png"
        "app-icon-180.png"
        "app-icon-192.png"
        "app-icon-512.png"
    )

    local all_present=true
    for file in "${required_files[@]}"; do
        if [ -f "app/assets/images/vibecoding/$file" ]; then
            echo -e "${GREEN}✓${NC} $file"
        else
            echo -e "${RED}✗${NC} $file (missing)"
            all_present=false
        fi
    done

    echo ""

    if [ "$all_present" = true ]; then
        echo -e "${GREEN}All required PNG assets generated successfully!${NC}"
        echo ""
        echo "Next steps:"
        echo "1. Review generated files: ls -lh app/assets/images/vibecoding/"
        echo "2. Upload to Forem Admin Panel: /admin/customization/config"
        echo "3. Commit with: git add app/assets/images/vibecoding/*.png"
        echo "4. Commit message: [VIBECODING] Generate PNG favicon and app icon assets (Story 1.4)"
    else
        echo -e "${YELLOW}Warning: Some assets missing. Check errors above.${NC}"
        exit 1
    fi
}

# Main execution
main() {
    check_dependencies
    generate_assets
    verify_assets
}

main
