# Development Decisions - Itomic Countdown Plugin

## Development Philosophy

This plugin follows **WordPress.org best practices** with a professional Git-based development workflow, automated testing, and comprehensive deployment pipeline.

## Development Workflow

### Local Development Setup
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

### Feature Development Process
```bash
# Create feature branch
git checkout -b feature/new-feature

# Make changes to plugin files
# Edit: itomic-countdown.php, assets/, etc.

# Sync changes to WordPress testing environment
composer sync

# Test and validate
composer test

# Commit changes following convention
git commit -m "Add new feature"

# Push to Bitbucket
git push origin feature/new-feature

# Create Pull Request in Bitbucket
```

## Version Management Strategy

### Single Source of Truth Approach
- **`itomic-countdown.php`** contains the authoritative version number in the plugin header
- All other files get their version from this source
- Eliminates version mismatches and manual errors

### Available Version Commands
```bash
# Automated releases (recommended)
composer run release:patch    # Patch release (1.0.5 → 1.0.6) 
composer run release:minor    # Minor release (1.0.5 → 1.1.0)
composer run release:major    # Major release (1.0.5 → 2.0.0)

# Manual version management
bin/bump-version.sh 1.0.6     # Interactive version bump
bin/bump-version.sh 1.0.6 --commit  # With auto-commit

# Development tools
composer test              # Run PHPUnit tests
composer test:coverage     # Run tests with coverage report
composer phpcs            # Check WordPress coding standards
composer phpcbf           # Fix coding standards automatically
composer build            # Build plugin package
composer deploy           # Deploy to test servers
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

## Testing Strategy

### Comprehensive Test Coverage
The plugin includes tests covering:
- Plugin initialization and activation
- Settings registration and sanitization
- Timezone detection functionality
- Input validation and security measures
- WordPress hooks and filters

### Testing Commands
```bash
# Sync plugin files before testing
composer sync

# Run all tests
composer test

# Run tests with coverage
composer test:coverage

# Run specific test
./vendor/bin/phpunit tests/ItomicCountdownTest.php
```

### Test Writing Guidelines
- Tests go in `tests/` directory
- Extend `WP_UnitTestCase` for WordPress-specific tests
- Use reflection to test private methods
- Test both valid and invalid inputs
- Maintain high test coverage for critical functionality

## Coding Standards

### WordPress Coding Standards Compliance
```bash
# Check standards
composer phpcs

# Fix standards automatically
composer phpcbf
```

### Security Best Practices Implementation
- **Input Sanitization**: Always sanitize input with `sanitize_text_field()`, etc.
- **Output Escaping**: Always escape output with `esc_html()`, `esc_attr()`, etc.
- **Nonce Verification**: Use nonces for all forms and AJAX requests
- **Capability Checking**: Verify user permissions before allowing actions
- **SQL Injection Prevention**: Use prepared statements and WordPress database API
- **XSS Protection**: Proper escaping and validation of all user input

## Development Resources

### Essential WordPress Documentation
- [WordPress Plugin Handbook](https://developer.wordpress.org/plugins/) - The authoritative guide for plugin development
- [WordPress Coding Standards](https://developer.wordpress.org/coding-standards/) - Official coding standards for PHP, JavaScript, CSS, and HTML
- [WordPress Plugin API Reference](https://developer.wordpress.org/plugins/hooks/) - Hooks, actions, and filters documentation

### Development Tools & Testing
- [PHPUnit Testing](https://phpunit.de/) - PHP testing framework
- [WordPress Coding Standards (WPCS)](https://github.com/WordPress/WordPress-Coding-Standards) - PHP_CodeSniffer ruleset for WordPress
- [WP-CLI](https://wp-cli.org/) - Command-line interface for WordPress

### Performance & Security Resources
- [WordPress Performance Guide](https://developer.wordpress.org/advanced-administration/performance/optimization/) - Official performance optimization guide
- [WordPress Security Best Practices](https://developer.wordpress.org/plugins/security/) - Security guidelines and best practices
- [WordPress REST API Security](https://developer.wordpress.org/rest-api/extending-the-rest-api/authentication/) - API security documentation

### Community Resources & Best Practices
- [WordPress Plugin Review Guidelines](https://developer.wordpress.org/plugins/wordpress-org/detailed-plugin-guidelines/) - Requirements for WordPress.org submission
- [Plugin Security Handbook](https://developer.wordpress.org/plugins/security/) - Comprehensive security guide for plugins
- [WordPress Plugin Boilerplate](https://github.com/DevinVinson/WordPress-Plugin-Boilerplate) - Professional plugin development template

### Professional Development Resources
- [WP Engine Developer Best Practices](https://wpengine.com/resources/developer-best-practices/) - Professional development workflows
- [Pantheon WordPress Developer Guide](https://docs.pantheon.io/guides/wordpress-developer/wordpress-best-practices) - Platform-specific best practices
- [Advanced Custom Fields Developer Blog](https://www.advancedcustomfields.com/blog/) - Advanced WordPress development techniques

---

**Last Updated**: 2025-01-17  
**Architecture Review**: After major features or quarterly  
**Decision Authority**: Lead Developer  
**Change Process**: Document in this file before implementation 