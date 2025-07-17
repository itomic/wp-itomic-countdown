# Itomic Countdown WordPress Plugin

A WordPress plugin that displays a real-time countdown to any event on your website.

## Features

- **Real-time countdown**: Displays days, hours, minutes, and seconds until your event
- **Customizable display**: Choose from 9 different positions on your site
- **Timezone support**: Automatic timezone detection with manual override options
- **Admin interface**: Easy-to-use settings page in WordPress admin
- **Auto-updates**: Self-hosted update system with automatic notifications
- **Responsive design**: Works on all devices and screen sizes
- **WordPress standards**: Follows WordPress coding standards and best practices

## Installation

### From WordPress Admin
1. Go to **Plugins > Add New**
2. Click **Upload Plugin**
3. Choose the plugin ZIP file
4. Click **Install Now**
5. Activate the plugin

### Manual Installation
1. Upload the plugin files to `/wp-content/plugins/itomic-countdown/`
2. Activate the plugin through the **Plugins** menu in WordPress
3. Go to **Settings > Itomic Countdown** to configure

## Configuration

1. Navigate to **Settings > Itomic Countdown** in your WordPress admin
2. Enter your event details:
   - **Event Title**: Name of your event (e.g., "New Year 2025")
   - **Event Date & Time**: When your event will occur
   - **Timezone**: Your event's timezone (auto-detected by default)
   - **Display Position**: Where to show the countdown on your site

3. Click **Save Changes**

## Display Positions

The countdown can be displayed in 9 different positions:
- Top: Left, Middle, Right
- Middle: Left, Middle, Right  
- Bottom: Left, Middle, Right

## Development

This plugin follows WordPress.org best practices with automated testing and deployment.

### Prerequisites
- PHP 7.4 or higher
- WordPress 5.0 or higher
- Composer (for development)

### Local Development Setup
```bash
# Clone the repository
git clone <repository-url>
cd itomic-countdown

# Install dependencies
composer install

# Set up WordPress test environment
bin/install-wp-tests.sh wordpress_test root root localhost latest

# Run tests
composer test

# Check coding standards
composer phpcs
```

### Available Commands

#### Version Management (WordPress Best Practice)
```bash
composer run release:patch    # Patch release (1.0.5 → 1.0.6) 
composer run release:minor    # Minor release (1.0.5 → 1.1.0)
composer run release:major    # Major release (1.0.5 → 2.0.0)
bin/bump-version.sh 1.0.6     # Manual version bump
```

#### Development & Testing
```bash
composer test              # Run PHPUnit tests
composer test:coverage     # Run tests with coverage report
composer phpcs            # Check WordPress coding standards
composer phpcbf           # Fix coding standards automatically
composer build            # Build plugin package
composer deploy           # Deploy to test servers
```

## Testing

The plugin includes comprehensive tests covering:
- Plugin initialization
- Settings registration and sanitization
- Timezone detection
- Input validation
- Security measures

Run tests with:
```bash
composer test
```

## Deployment

### Automated Deployment
The plugin uses Bitbucket Pipelines for automated testing and deployment:
- Runs on every push to `main` branch
- Executes tests and coding standards checks
- Builds plugin package
- Deploys to test servers

### Manual Deployment
```bash
# Build package
./deploy.sh

# Upload to servers
scp deploy/itomic-countdown-*.zip root@server:/path/to/plugin/
scp deploy/*.json root@server:/path/to/updates/
```

## Update System

The plugin includes a self-hosted update system:
- Automatic update notifications in WordPress admin
- Secure update downloads
- Version compatibility checking
- Rollback capability

### Update Server Configuration
Update files are hosted at: `https://itomic.com.au/plugins/itomic-countdown/`

Required files:
- `version.json` - Current version information
- `info.json` - Plugin details for WordPress
- `itomic-countdown-x.x.x.zip` - Plugin package

## Security

The plugin follows WordPress security best practices:
- Input sanitization and validation
- Output escaping
- Nonce verification
- Capability checking
- SQL injection prevention
- XSS protection

## Support

For support and feature requests:
- **Email**: info@itomic.com.au
- **Website**: https://www.itomic.com.au
- **Documentation**: See `DEVELOPMENT.md` for development guide

## Changelog

### Version 1.0.3
- Added automatic timezone detection
- Improved CSS and JavaScript consistency
- Enhanced update system reliability
- Fixed display positioning issues

### Version 1.0.2
- Added self-hosted update system
- Implemented auto-update functionality
- Enhanced admin interface
- Improved error handling

### Version 1.0.1
- Added timezone support
- Improved responsive design
- Enhanced admin settings
- Bug fixes and improvements

### Version 1.0.0
- Initial release
- Basic countdown functionality
- Admin settings interface
- Multiple display positions

## License

This plugin is licensed under the GPL v3.0 - see the [LICENSE](LICENSE) file for details.

## Credits

Developed by [Itomic](https://www.itomic.com.au)

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests for new functionality
5. Ensure coding standards compliance
6. Submit a pull request

For detailed development information, see [DEVELOPMENT.md](DEVELOPMENT.md).

### Additional Resources

For comprehensive WordPress plugin development guidance, refer to the official [WordPress Plugin Developer Handbook](https://developer.wordpress.org/plugins/) and our expanded resources section in the [development documentation](DEVELOPMENT.md#resources). 