# Testing Auto-Updates with Develop Branch

## Overview

This guide explains how to test the auto-update functionality on your local WordPress test site (`wordpress.test`) using releases from the `develop` branch instead of `main`.

## The Challenge

By default, the plugin updater checks GitHub releases, which are typically created from the `main` branch. To test the update detection mechanism with `develop` branch code, we need to:

1. Create releases from `develop` branch (as pre-releases)
2. Configure the plugin to check for pre-releases
3. Test the update detection and installation process

## Solution: Pre-Release Testing

The updater class now supports checking for pre-releases. Here's how to set it up:

### Step 1: Enable Pre-Release Checking

Add this constant to your `wp-config.php` file for your test site:

```php
// Enable checking for pre-releases (for testing develop branch)
define( 'ITOMIC_COUNTDOWN_CHECK_PRERELEASES', true );
```

**Location:** `C:\Users\Ross Gerring\Herd\sites\wordpress.test\wp-config.php`

### Step 2: Create a Pre-Release from Develop Branch

When you want to test updates from `develop`:

1. **Work on develop branch:**
   ```bash
   git checkout develop
   # Make your changes
   git commit -m "Add new feature for testing"
   git push origin develop
   ```

2. **Bump version on develop:**
   ```bash
   ./bump-version.sh patch
   git add itomic-countdown.php readme.txt
   git commit -m "Bump version to 1.0.11-dev"
   git push origin develop
   ```

3. **Create a pre-release manually on GitHub:**
   - Go to: https://github.com/itomic/wp-itomic-countdown/releases/new
   - **Tag:** `v1.0.11-dev` (or use `-dev`, `-beta`, `-rc` suffix)
   - **Release title:** `Version 1.0.11-dev (Development)`
   - **Description:** Mark this as a development/pre-release version
   - **Check:** ☑️ Set as a pre-release
   - **Attach:** Upload `itomic-countdown.zip` (created with `bash package-plugin.sh`)
   - Click **Publish release**

### Step 3: Install Lower Version on Test Site

1. **Install an older version:**
   - Install version 1.0.10 (or lower) on wordpress.test
   - Or manually edit the version in the installed plugin to be lower than the pre-release

2. **WordPress will detect the update:**
   - Go to **Dashboard → Updates**
   - Or **Plugins → Installed Plugins**
   - You should see "There is a new version of Itomic Countdown available"

3. **Test the update:**
   - Click **Update now**
   - Verify the update installs correctly
   - Check that the new version is active

## Alternative: Automated Pre-Release Workflow

You can also create a GitHub Actions workflow that automatically creates pre-releases from `develop` branch:

### Create `.github/workflows/pre-release.yml`:

```yaml
name: Pre-Release from Develop

on:
  push:
    branches:
      - develop
    paths:
      - 'itomic-countdown.php'
  workflow_dispatch:

jobs:
  pre-release:
    runs-on: ubuntu-latest
    permissions:
      contents: write
    
    steps:
      - name: Checkout code
        uses: actions/checkout@v4
      
      - name: Extract version
        id: get_version
        run: |
          VERSION=$(grep -oP 'Version: \K[0-9]+\.[0-9]+\.[0-9]+' itomic-countdown.php | head -1)
          echo "version=$VERSION-dev" >> $GITHUB_OUTPUT
          echo "tag=v$VERSION-dev" >> $GITHUB_OUTPUT
      
      - name: Package plugin
        run: |
          chmod +x package-plugin.sh
          ./package-plugin.sh
      
      - name: Create Pre-Release
        uses: softprops/action-gh-release@v1
        with:
          tag_name: ${{ steps.get_version.outputs.tag }}
          name: Version ${{ steps.get_version.outputs.version }} (Development)
          body: |
            ## Development Pre-Release
            
            This is a pre-release from the develop branch for testing purposes.
            
            **⚠️ Do not use in production!**
            
            Version: ${{ steps.get_version.outputs.version }}
          files: |
            itomic-countdown.zip
          draft: false
          prerelease: true  # Mark as pre-release
```

## Testing Workflow

### Complete Testing Scenario:

1. **Initial Setup:**
   ```bash
   # On develop branch
   git checkout develop
   
   # Install version 1.0.10 on wordpress.test
   # Add constant to wp-config.php:
   # define( 'ITOMIC_COUNTDOWN_CHECK_PRERELEASES', true );
   ```

2. **Make Changes:**
   ```bash
   # Make your changes on develop
   # Bump version
   ./bump-version.sh patch
   git add itomic-countdown.php readme.txt
   git commit -m "Bump version to 1.0.11-dev"
   git push origin develop
   ```

3. **Create Pre-Release:**
   - Package: `bash package-plugin.sh`
   - Create pre-release on GitHub with tag `v1.0.11-dev`
   - Attach `itomic-countdown.zip`

4. **Test Update Detection:**
   - Go to wordpress.test/wp-admin
   - Check **Dashboard → Updates**
   - Should show update available
   - Test the update process

5. **Verify:**
   - Plugin updates successfully
   - New version is active
   - Functionality works as expected

## Important Notes

- **Pre-releases are separate from stable releases:** The updater uses different cache keys for pre-releases vs stable releases
- **Version comparison:** WordPress will update if the pre-release version is higher than the installed version
- **Production sites:** Should NOT have `ITOMIC_COUNTDOWN_CHECK_PRERELEASES` set, so they only get stable releases from `main`
- **Cache:** Update checks are cached for 12 hours. Clear cache or wait for it to expire to see new releases

## Clearing Update Cache

If you need to force WordPress to check for updates immediately:

```php
// Add to wp-config.php temporarily, or run in WordPress:
delete_transient( 'itomic_countdown_update_' . md5( 'itomic/wp-itomic-countdown_prerelease' ) );
delete_site_transient( 'update_plugins' );
wp_update_plugins();
```

Or use the "Check for updates" link in the Plugins page.

## Summary

- **Production:** Uses stable releases from `main` branch (default)
- **Testing:** Set `ITOMIC_COUNTDOWN_CHECK_PRERELEASES` constant to check pre-releases from `develop`
- **Workflow:** Create pre-releases on GitHub with `-dev` suffix for testing
- **Result:** wordpress.test can test the full update experience using develop branch releases

