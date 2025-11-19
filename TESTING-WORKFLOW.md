# Testing Workflow - Best Practices

## Overview

This document outlines the recommended workflow for testing the Itomic Countdown plugin before releasing to production.

## Branch Strategy for Testing

### Development Branch Workflow

1. **Work on `develop` branch** (or create feature branches from `develop`)
   ```bash
   git checkout develop
   git pull origin develop
   ```

2. **Make your changes** to plugin files

3. **Test locally** using one of the methods below

4. **Commit and push to `develop`**
   ```bash
   git add .
   git commit -m "Add new feature"
   git push origin develop
   ```

5. **When ready for release**, merge `develop` to `main` and bump version

## Testing Methods

### Method 1: ZIP Installation (Recommended for Herd/wordpress.test)

**Best for:** Testing the exact package that will be distributed

1. **Create development ZIP from current branch:**
   ```bash
   # Make sure you're on develop branch (or your feature branch)
   git checkout develop
   
   # Create the ZIP file
   bash package-plugin.sh
   # Or: ./package-plugin.sh (if using Git Bash)
   ```

2. **Install in WordPress:**
   - Go to https://wordpress.test/wp-admin/
   - Navigate to **Plugins → Add New → Upload Plugin**
   - Click **Choose File** and select `itomic-countdown.zip` from your project directory
   - Click **Install Now**
   - Activate the plugin

3. **Test your changes:**
   - Go to **Settings → Itomic Countdown**
   - Configure and test the countdown
   - Check frontend display
   - Test all functionality

4. **After testing, update ZIP:**
   - Make more changes if needed
   - Run `bash package-plugin.sh` again to rebuild
   - In WordPress: **Plugins → Installed Plugins → Itomic Countdown → Delete**
   - Upload the new ZIP and test again

### Method 2: Symlink Approach (Advanced)

**Best for:** Instant testing without rebuilding ZIP

**Setup (one-time):**
```bash
# Create symlink from WordPress plugins directory to your plugin/ directory
# For Herd on Windows, the path would be something like:
# C:\Users\Ross Gerring\Herd\sites\wordpress.test\wp-content\plugins\itomic-countdown
# → C:\Users\Ross Gerring\Herd\wp-plugins\itomic-countdown\plugin

# First, sync your files to plugin/ directory
composer sync
# Or: bash bin/sync-plugin.sh

# Then create symlink (Windows requires admin or developer mode)
# Use mklink command in Command Prompt (as Administrator):
mklink /D "C:\Users\Ross Gerring\Herd\sites\wordpress.test\wp-content\plugins\itomic-countdown" "C:\Users\Ross Gerring\Herd\wp-plugins\itomic-countdown\plugin"
```

**Workflow:**
```bash
# Make changes to plugin files
# Sync to plugin/ directory
composer sync

# Changes appear instantly in WordPress (no reinstall needed)
# Just refresh your browser
```

### Method 3: Direct File Copy (Simple but Manual)

**Best for:** Quick one-off tests

1. **Copy files directly to WordPress:**
   ```bash
   # Copy plugin files to WordPress plugins directory
   cp -r plugin/* "C:\Users\Ross Gerring\Herd\sites\wordpress.test\wp-content\plugins\itomic-countdown\"
   ```

2. **Refresh WordPress admin** to see changes

## Recommended Testing Checklist

Before merging to `main`:

- [ ] Plugin activates without errors
- [ ] Settings page loads correctly
- [ ] Can save settings without errors
- [ ] Countdown displays on frontend
- [ ] Countdown updates in real-time
- [ ] All 9 display positions work
- [ ] Timezone selection works
- [ ] Responsive design works (mobile/tablet)
- [ ] No JavaScript console errors
- [ ] No PHP errors in WordPress debug log
- [ ] Plugin deactivates cleanly
- [ ] Plugin uninstalls cleanly (if testing uninstall)

## Testing Different Scenarios

### Test on `develop` branch:
```bash
git checkout develop
bash package-plugin.sh
# Install itomic-countdown.zip in WordPress
```

### Test on feature branch:
```bash
git checkout feature/my-new-feature
bash package-plugin.sh
# Install itomic-countdown.zip in WordPress
```

### Test production build (from `main`):
```bash
git checkout main
bash package-plugin.sh
# Install itomic-countdown.zip in WordPress
```

## Quick Reference

**Create ZIP for testing:**
```bash
bash package-plugin.sh
```

**ZIP location:**
```
C:\Users\Ross Gerring\Herd\wp-plugins\itomic-countdown\itomic-countdown.zip
```

**WordPress test site:**
```
https://wordpress.test/
```

**WordPress admin:**
```
https://wordpress.test/wp-admin/
```

## Troubleshooting

**ZIP not updating in WordPress?**
- Delete the plugin first: **Plugins → Installed Plugins → Delete**
- Then upload the new ZIP

**Changes not appearing?**
- Clear WordPress cache (if using caching plugin)
- Hard refresh browser (Ctrl+F5)
- Check browser console for errors

**Symlink not working?**
- Ensure you're using Windows Developer Mode or running as Administrator
- Verify paths are correct
- Check that `plugin/` directory exists and has files

---

**Remember:** Always test on `develop` branch (or feature branches) before merging to `main`. The `main` branch should only contain production-ready, tested code.

