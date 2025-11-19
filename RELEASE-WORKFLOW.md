# Release Workflow - Quick Reference

## Current Version: 1.0.10

## Branching Strategy

- **`main`**: Production-ready code. Releases are created from this branch.
- **`develop`**: Development branch. All features are merged here first.
- **`feature/*`**: Individual feature branches.

**Important:** Only merge to `main` when ready for release. GitHub Actions only creates releases from `main` branch.

## Creating a New Release

### Step 1: Bump Version

**Windows:**
```powershell
.\bump-version.ps1 patch    # 1.0.10 → 1.0.11
.\bump-version.ps1 minor   # 1.0.10 → 1.1.0
.\bump-version.ps1 major   # 1.0.10 → 2.0.0
```

**Linux/Mac:**
```bash
./bump-version.sh patch
./bump-version.sh minor
./bump-version.sh major
```

### Step 2: Merge develop to main (if needed)

```bash
# If you've been working on develop branch
git checkout main
git pull origin main
git merge develop
```

### Step 3: Commit and Push

```bash
git add itomic-countdown.php readme.txt
git commit -m "Bump version to 1.0.11"
git push origin main
```

### Step 4: GitHub Actions Does the Rest!

✅ Automatically packages plugin ZIP  
✅ Generates changelog from commits  
✅ Creates GitHub release with tag  
✅ Attaches ZIP file to release  
✅ WordPress detects update within 12 hours  

## What Happens Automatically

1. **GitHub Actions detects** version change in `itomic-countdown.php`
2. **Extracts version** (e.g., `1.0.11`)
3. **Packages plugin** using `package-plugin.sh`
4. **Generates changelog** from git commits since last release
5. **Creates release** with tag `v1.0.11`
6. **Attaches ZIP** file to release
7. **WordPress detects** update within 12 hours

## Version Numbering

- **PATCH** (1.0.10 → 1.0.11): Bug fixes
- **MINOR** (1.0.10 → 1.1.0): New features
- **MAJOR** (1.0.10 → 2.0.0): Breaking changes

## Files Updated by Script

- ✅ `itomic-countdown.php` - Plugin header version and constant
- ✅ `readme.txt` - Stable tag version

## Manual Release (If Needed)

If GitHub Actions fails, create release manually:

1. Package: `./package-plugin.sh`
2. Go to: https://github.com/itomic/wp-itomic-countdown/releases/new
3. Tag: `v1.0.11` (must match version)
4. Attach: `itomic-countdown.zip`
5. Publish

## Troubleshooting

**Release not created?**
- Check GitHub Actions tab for errors
- Verify version updated in plugin file
- Ensure pushed to `main` branch

**Update not detected?**
- Wait 12 hours for cache to expire
- Or clear WordPress update cache
- Verify ZIP file attached to release

## Documentation

- **Full Guide:** `memory-bank/deployment-guide.md`
- **Workflow:** `.github/workflows/release.yml`
- **Scripts:** `bump-version.ps1`, `bump-version.sh`

---

**That's it!** Just bump version, commit, and push. Everything else is automated! 🚀

