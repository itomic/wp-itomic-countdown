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
```bash
# Update version numbers
# - itomic-countdown.php (Version: x.x.x)
# - composer.json (version field)
# - readme.txt (Stable tag: x.x.x)

# Build package
composer build

# Test the package
composer test

# Deploy to test servers
composer deploy

# Merge to main branch
git checkout main
git merge feature/new-feature
git push origin main
```

## File Structure

```
itomic-countdown/
├── itomic-countdown.php      # Main plugin file
├── assets/                   # CSS, JS, images
├── tests/                    # PHPUnit tests
├── bin/                      # Build scripts
├── deploy/                   # Build artifacts (gitignored)
├── composer.json             # Dependencies
├── phpunit.xml              # Test configuration
├── bitbucket-pipelines.yml  # CI/CD pipeline
└── README.md                # This file
```

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

- [WordPress Plugin Handbook](https://developer.wordpress.org/plugins/)
- [WordPress Coding Standards](https://developer.wordpress.org/coding-standards/)
- [PHPUnit Testing](https://phpunit.de/)
- [Bitbucket Pipelines](https://bitbucket.org/product/features/pipelines) 