#!/usr/bin/env node
/**
 * [VIBECODING] Generate PNG favicons and app icons from SVG source
 * Story 1.4 - Review Action Item: Generate missing PNG assets
 *
 * Requirements:
 *   npm install sharp (image processing library)
 *
 * Usage:
 *   node bin/generate-favicons.js
 */

const fs = require('fs');
const path = require('path');

console.log('\x1b[32m%s\x1b[0m', 'Vibecoding Favicon & App Icon Generator');
console.log('==========================================');
console.log('');

// Check if sharp is installed
let sharp;
try {
  sharp = require('sharp');
  console.log('\x1b[32m✓\x1b[0m Found: sharp (Node.js image processing)');
  console.log('');
} catch (error) {
  console.error('\x1b[31mError: sharp module not found\x1b[0m');
  console.log('');
  console.log('Please install sharp:');
  console.log('  npm install sharp --save-dev');
  console.log('');
  console.log('Or use the bash script instead:');
  console.log('  bash bin/generate-favicons.sh');
  console.log('');
  process.exit(1);
}

const sourceDir = path.join(__dirname, '..', 'app', 'assets', 'images', 'vibecoding');
const iconSvg = path.join(sourceDir, 'icon.svg');

// Asset specifications
const assets = [
  { name: 'favicon-32.png', width: 32, height: 32, category: 'Favicons' },
  { name: 'favicon-64.png', width: 64, height: 64, category: 'Favicons' },
  { name: 'app-icon-180.png', width: 180, height: 180, category: 'App Icons (iOS)' },
  { name: 'app-icon-192.png', width: 192, height: 192, category: 'App Icons (Android/PWA)' },
  { name: 'app-icon-512.png', width: 512, height: 512, category: 'App Icons (Android/PWA)' },
];

async function generateAssets() {
  // Check source file exists
  if (!fs.existsSync(iconSvg)) {
    console.error(`\x1b[31mError: Source icon not found: ${iconSvg}\x1b[0m`);
    process.exit(1);
  }

  console.log(`Source: ${iconSvg}`);
  console.log('');
  console.log('Generating assets...');
  console.log('');

  let currentCategory = '';

  for (const asset of assets) {
    // Print category header
    if (asset.category !== currentCategory) {
      if (currentCategory !== '') console.log('');
      console.log(`${asset.category}:`);
      currentCategory = asset.category;
    }

    const outputPath = path.join(sourceDir, asset.name);

    try {
      await sharp(iconSvg)
        .resize(asset.width, asset.height)
        .png()
        .toFile(outputPath);

      const stats = fs.statSync(outputPath);
      const sizeKB = (stats.size / 1024).toFixed(1);
      console.log(`\x1b[32m✓\x1b[0m Generated: ${asset.name} (${asset.width}x${asset.height}, ${sizeKB}KB)`);
    } catch (error) {
      console.error(`\x1b[31m✗\x1b[0m Failed: ${asset.name}`);
      console.error(`  Error: ${error.message}`);
    }
  }

  console.log('');
}

function verifyAssets() {
  console.log('Verification:');
  console.log('');

  const required Files = [
    'favicon-32.png',
    'favicon-64.png',
    'app-icon-180.png',
    'app-icon-192.png',
    'app-icon-512.png',
  ];

  let allPresent = true;

  for (const file of requiredFiles) {
    const filePath = path.join(sourceDir, file);
    if (fs.existsSync(filePath)) {
      console.log(`\x1b[32m✓\x1b[0m ${file}`);
    } else {
      console.log(`\x1b[31m✗\x1b[0m ${file} (missing)`);
      allPresent = false;
    }
  }

  console.log('');

  if (allPresent) {
    console.log('\x1b[32mAll required PNG assets generated successfully!\x1b[0m');
    console.log('');
    console.log('Next steps:');
    console.log('1. Review generated files: ls -lh app/assets/images/vibecoding/');
    console.log('2. Upload to Forem Admin Panel: /admin/customization/config');
    console.log('3. Commit with: git add app/assets/images/vibecoding/*.png');
    console.log('4. Commit message: [VIBECODING] Generate PNG favicon and app icon assets (Story 1.4)');
  } else {
    console.log('\x1b[33mWarning: Some assets missing. Check errors above.\x1b[0m');
    process.exit(1);
  }
}

async function main() {
  try {
    await generateAssets();
    verifyAssets();
  } catch (error) {
    console.error('\x1b[31mFatal error:\x1b[0m', error.message);
    process.exit(1);
  }
}

main();
