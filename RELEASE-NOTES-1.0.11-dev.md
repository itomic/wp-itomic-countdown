# Version 1.0.11-dev (Development Pre-Release)

## Development Pre-Release

This is a pre-release from the develop branch for testing auto-update functionality.

**⚠️ Do not use in production!**

### Changes
- Added pre-release support for testing auto-updates from develop branch
- Enhanced updater class to check for pre-releases when `ITOMIC_COUNTDOWN_CHECK_PRERELEASES` constant is set

### Testing
This release is intended for testing the auto-update mechanism on development/staging sites.

### Installation
1. Download the `itomic-countdown.zip` file
2. Go to WordPress Admin → Plugins → Add New → Upload Plugin
3. Upload the ZIP file and activate

### Auto-Update
If you have `ITOMIC_COUNTDOWN_CHECK_PRERELEASES` set to `true` in wp-config.php, WordPress will detect this update.

---
*This is a development pre-release for testing purposes only.*
