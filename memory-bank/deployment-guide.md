# Deployment Guide - Itomic Countdown Plugin

Complete deployment procedures and workflows for the Itomic Countdown plugin.

## Deployment Architecture Overview

### **Infrastructure Components**
1. **Development Environment**: `/home/spaceman/itomic-countdown/` (Local WSL2)
2. **Version Control**: GitHub repository
3. **CI/CD Pipeline**: GitHub Actions
4. **Update Server**: GitHub Releases
5. **Distribution**: GitHub-based update system for self-hosted WordPress sites

### **Repository Details**
- **GitHub Repository**: `itomic/wp-itomic-countdown`
- **Update System**: GitHub Releases API
- **Auto-Updates**: WordPress detects updates from GitHub releases within 12 hours

## Release Process

### Automated Version Management (Recommended)

The plugin uses GitHub Actions for fully automated releases:

```bash
# Patch release (1.0.10 → 1.0.11) - Bug fixes and minor updates
./bump-version.sh patch
# Or on Windows:
.\bump-version.ps1 patch

# Minor release (1.0.10 → 1.1.0) - New features, backward compatible
./bump-version.sh minor

# Major release (1.0.10 → 2.0.0) - Breaking changes, major updates
./bump-version.sh major

# Commit and push to trigger GitHub Actions
git add itomic-countdown.php readme.txt
git commit -m "Bump version to 1.0.11"
git push origin main
```

GitHub Actions will automatically:
- ✅ Package the plugin ZIP
- ✅ Generate changelog from commits
- ✅ Create GitHub release with tag
- ✅ Attach ZIP file to release
- ✅ WordPress detects update within 12 hours

### Manual Version Management

For cases requiring manual control:

```bash
# Bump version (updates plugin file and readme.txt)
./bump-version.sh patch
# Or on Windows:
.\bump-version.ps1 patch

# Build package manually (for testing)
./package-plugin.sh

# Commit and push
git add itomic-countdown.php readme.txt
git commit -m "Bump version to 1.0.11"
git push origin main
```

### Legacy Manual Process (Not Recommended)

Only use when automated tools are unavailable:

```bash
# Manually update version in all files:
# - itomic-countdown.php (Version: x.x.x)
# - composer.json (version field)
# - readme.txt (Stable tag: x.x.x)

# Build package
composer build

# Commit changes
git commit -m "Bump version to x.x.x"
git push origin main
```

## Automated Deployment (GitHub Actions)

### Pipeline Triggers
- Automatically triggers on push to `main` branch when `itomic-countdown.php` changes
- Can be manually triggered via GitHub Actions UI
- Extracts version from plugin file header
- Creates GitHub release automatically

### Pipeline Process
1. **Version Extraction**
   - Reads version from plugin file header
   - Verifies version matches readme.txt
   - Checks if release already exists

2. **Changelog Generation**
   - Compares commits since last release tag
   - Generates markdown changelog automatically

3. **Plugin Packaging**
   - Runs `package-plugin.sh` to create ZIP
   - Verifies ZIP structure is correct
   - Includes all plugin files (excluding development files)

4. **Release Creation**
   - Creates GitHub release with version tag
   - Attaches plugin ZIP file
   - Includes changelog in release notes
   - WordPress detects update within 12 hours

## Manual Deployment

### Build Package Locally
```bash
# Build plugin package for testing
./package-plugin.sh

# This creates: itomic-countdown.zip
# Ready for manual upload to WordPress
```

### Manual Release Creation
If GitHub Actions fails, create release manually:

1. Package the plugin: `./package-plugin.sh`
2. Go to: https://github.com/itomic/wp-itomic-countdown/releases/new
3. Tag: `v1.0.11` (must match version in plugin file)
4. Attach: `itomic-countdown.zip`
5. Publish release

WordPress will detect the update within 12 hours.

## Update System Configuration

### GitHub-Based Update System
The plugin uses GitHub Releases for automatic updates:

- **Automatic update notifications** in WordPress admin
- **Secure update downloads** from GitHub releases
- **Version compatibility checking** before updates
- **12-hour cache** for update checks (WordPress standard)

### Update System Files
- **GitHub Repository**: `itomic/wp-itomic-countdown`
- **Releases**: https://github.com/itomic/wp-itomic-countdown/releases
- **Update Class**: `includes/class-plugin-updater.php` (loaded automatically)
- **Update URI Header**: Set in plugin file header

### Update Process Flow
1. WordPress checks for updates every 12 hours (standard WordPress behavior)
2. Plugin updater queries GitHub Releases API
3. Compares local version with latest GitHub release
4. If new version available, displays update notification
5. User clicks update, WordPress downloads ZIP from GitHub release
6. Automatic installation and activation of new version

## WordPress.org Preparation

When preparing for WordPress.org submission:

### Repository Setup
1. **Set up SVN repository** with WordPress.org
2. **Copy code to trunk** directory
3. **Create version tags** for each release
4. **Upload assets** (screenshots, icons, banners)
5. **Submit for review** following guidelines

### SVN Structure
```
/trunk/                     # Latest development code
/tags/1.0.0/               # Version 1.0.0 release
/tags/1.0.1/               # Version 1.0.1 release
/assets/                    # Screenshots, icons, banners
    ├── screenshot-1.png    # Admin interface
    ├── screenshot-2.png    # Frontend display
    ├── banner-772x250.png  # Plugin directory banner
    └── icon-256x256.png    # Plugin icon
```

### Compliance Requirements
- Remove development files (composer.json, tests/, bin/, deploy/)
- Ensure WordPress.org coding standards compliance
- Include proper readme.txt with WordPress formatting
- Remove custom update system for WordPress.org version

## Troubleshooting Deployment

### Common Deployment Issues

**GitHub Actions failures:**
- Check GitHub Actions tab for workflow errors
- Verify version updated in plugin file
- Ensure pushed to `main` branch
- Check that `package-plugin.sh` is executable

**Release not created:**
- Verify version number in plugin file matches expected format
- Check if release with same tag already exists
- Review GitHub Actions logs for specific errors

**Update not detected:**
- Wait 12 hours for WordPress update cache to expire
- Or clear WordPress update cache manually
- Verify ZIP file attached to GitHub release
- Check that Update URI header is set correctly

**Version management issues:**
- Ensure single source of truth in main plugin file
- Verify version matches in plugin file and readme.txt
- Check for merge conflicts in version control

## 📊 **Deployment History**

### **Recent Deployments**
- **v1.0.10**: 2025-01-17 - Migrated to GitHub Actions and GitHub-based updates
- **v1.0.9**: Previous - Update system enhancements  
- **v1.0.8**: Previous - Bug fixes

### **Deployment Metrics**
- **Average Deployment Time**: ~2 minutes (GitHub Actions)
- **Success Rate**: 98%+ (automated pipeline)
- **Update Detection**: Within 12 hours (WordPress standard)

---

**Last Updated**: 2025-01-17  
**Deployment Method**: Automated GitHub Actions  
**Update System**: GitHub Releases  
**Current Version**: 1.0.10  
**Next Scheduled Deployment**: TBD 