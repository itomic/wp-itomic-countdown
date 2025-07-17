# Itomic Countdown Plugin - Development Guide

## Overview

This plugin follows WordPress.org best practices with a Git-based development workflow and automated testing/deployment.

## Development Workflow

### 1. Local Development
```bash
# Clone the repository
git clone <bitbucket-repo-url>
cd itomic-countdown

# Install dependencies
composer install

# Set up WordPress test environment
bin/install-wp-tests.sh wordpress_test root root localhost latest

# Run tests
composer test

# Check coding standards
composer phpcs

# Fix coding standards automatically
composer phpcbf
```

### 2. Making Changes
```bash
# Create feature branch
git checkout -b feature/new-feature

# Make changes and test
composer test

# Commit changes
git commit -m "Add new feature"

# Push to Bitbucket
git push origin feature/new-feature

# Create Pull Request in Bitbucket
```

### 3. Release Process

#### Automated Version Management (Recommended)
```bash
# Patch release (1.0.5 → 1.0.6)
composer run release:patch

# Minor release (1.0.5 → 1.1.0) 
composer run release:minor

# Major release (1.0.5 → 2.0.0)
composer run release:major

# Push to remote
git push origin main
```

#### Manual Version Management
```bash
# Update version manually using our script
bin/bump-version.sh 1.0.6

# Or with auto-commit
bin/bump-version.sh 1.0.6 --commit

# Build package
composer build

# Push to remote
git push origin main
```

#### Legacy Manual Process (Not Recommended)
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

## File Structure

```
itomic-countdown/
├── itomic-countdown.php      # Main plugin file (VERSION SOURCE OF TRUTH)
├── assets/                   # CSS, JS, images
├── tests/                    # PHPUnit tests
├── bin/                      # Build and version management scripts
│   ├── bump-version.sh      # Automated version management
│   └── install-wp-tests.sh  # WordPress test setup
├── deploy/                   # Build artifacts (gitignored)
├── composer.json             # Dependencies + version commands
├── phpunit.xml              # Test configuration
├── bitbucket-pipelines.yml  # CI/CD pipeline
└── README.md                # This file
```

## Version Management

This plugin follows **WordPress.org best practices** for version management with a **single source of truth** approach.

### Single Source of Truth
- **`itomic-countdown.php`** contains the authoritative version number in the plugin header
- All other files get their version from this source
- Eliminates version mismatches and manual errors

### Available Commands
```bash
# Interactive version bump
bin/bump-version.sh 1.0.6

# Automated patch release (1.0.5 → 1.0.6)
composer run release:patch

# Automated minor release (1.0.5 → 1.1.0)
composer run release:minor

# Automated major release (1.0.5 → 2.0.0)
composer run release:major

# Build package only
composer build

# Manual version with auto-commit
bin/bump-version.sh 1.0.6 --commit
```

### What Gets Updated Automatically
- ✅ Plugin header `Version:` field
- ✅ `ITOMIC_COUNTDOWN_VERSION` constant
- ✅ `readme.txt` stable tag
- ✅ `composer.json` version field
- ✅ `deploy/version.json`
- ✅ `deploy/info.json`
- ✅ Git commit with proper message
- ✅ Optional git tag creation
- ✅ Interactive changelog entry

## Testing

### Running Tests
```bash
# Run all tests
composer test

# Run tests with coverage
composer test:coverage

# Run specific test
./vendor/bin/phpunit tests/ItomicCountdownTest.php
```

### Writing Tests
- Tests go in `tests/` directory
- Extend `WP_UnitTestCase` for WordPress-specific tests
- Use reflection to test private methods
- Test both valid and invalid inputs

## Coding Standards

### WordPress Coding Standards
```bash
# Check standards
composer phpcs

# Fix standards automatically
composer phpcbf
```

### Security Best Practices
- Always escape output with `esc_html()`, `esc_attr()`, etc.
- Always sanitize input with `sanitize_text_field()`, etc.
- Use nonces for forms
- Check user capabilities
- Validate and sanitize all data

## Deployment

### Automated Deployment (Bitbucket Pipelines)
- Triggers on push to `main` branch
- Runs tests and coding standards
- Builds package automatically
- Deploys to test servers

### Manual Deployment
```bash
# Build package
./deploy.sh

# Upload to test servers
scp deploy/itomic-countdown-*.zip root@atlas.itomic.com:/path/to/plugin/
scp deploy/*.json root@pegasus.itomic.com:/path/to/updates/
```

## WordPress.org Preparation

When ready for WordPress.org:

1. **Set up SVN repository**
2. **Copy code to trunk**
3. **Create version tags**
4. **Upload assets**
5. **Submit for review**

### SVN Structure
```
/trunk/                     # Latest development code
/tags/1.0.0/               # Version 1.0.0
/tags/1.0.1/               # Version 1.0.1
/assets/                    # Screenshots, icons
```

## Troubleshooting

### Common Issues

**Tests failing:**
- Ensure WordPress test environment is set up
- Check database connection
- Verify plugin is loading correctly

**Coding standards errors:**
- Run `composer phpcbf` to auto-fix
- Check WordPress Coding Standards documentation

**Deployment issues:**
- Verify SSH keys are configured in Bitbucket
- Check server permissions
- Ensure all files are committed

## Resources

### Official WordPress Documentation
- [WordPress Plugin Handbook](https://developer.wordpress.org/plugins/) - The authoritative guide for plugin development
- [WordPress Coding Standards](https://developer.wordpress.org/coding-standards/) - Official coding standards for PHP, JavaScript, CSS, and HTML
- [WordPress Theme Handbook](https://developer.wordpress.org/themes/) - Complete guide for theme development
- [WordPress Plugin API Reference](https://developer.wordpress.org/plugins/hooks/) - Hooks, actions, and filters documentation

### Development Tools & Testing
- [PHPUnit Testing](https://phpunit.de/) - PHP testing framework
- [Bitbucket Pipelines](https://bitbucket.org/product/features/pipelines) - CI/CD automation
- [WordPress Coding Standards (WPCS)](https://github.com/WordPress/WordPress-Coding-Standards) - PHP_CodeSniffer ruleset for WordPress
- [WP-CLI](https://wp-cli.org/) - Command-line interface for WordPress

### Performance & Security
- [WordPress Performance Guide](https://developer.wordpress.org/advanced-administration/performance/optimization/) - Official performance optimization guide
- [WordPress Security Best Practices](https://developer.wordpress.org/plugins/security/) - Security guidelines and best practices
- [WordPress REST API Security](https://developer.wordpress.org/rest-api/extending-the-rest-api/authentication/) - API security documentation

### Community Resources & Best Practices
- [WP Engine Developer Best Practices](https://wpengine.com/resources/developer-best-practices/) - Professional development workflows
- [Pantheon WordPress Developer Guide](https://docs.pantheon.io/guides/wordpress-developer/wordpress-best-practices) - Platform-specific best practices
- [Advanced Custom Fields Developer Blog](https://www.advancedcustomfields.com/blog/) - Advanced WordPress development techniques
- [WordPress Development Subreddit](https://www.reddit.com/r/Wordpress/) - Community discussions and problem-solving
- [Make WordPress Core](https://make.wordpress.org/core/) - WordPress core development news and guidelines

### Plugin Development Specific
- [WordPress Plugin Review Guidelines](https://developer.wordpress.org/plugins/wordpress-org/detailed-plugin-guidelines/) - Requirements for WordPress.org submission
- [Plugin Security Handbook](https://developer.wordpress.org/plugins/security/) - Comprehensive security guide for plugins
- [WordPress Plugin Boilerplate](https://github.com/DevinVinson/WordPress-Plugin-Boilerplate) - Professional plugin development template 