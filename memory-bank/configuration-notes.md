# Configuration Notes - Itomic Countdown Plugin

## WordPress Plugin Installation

### Method 1: WordPress Admin (Recommended)
1. Go to **Plugins > Add New**
2. Click **Upload Plugin**
3. Choose the plugin ZIP file
4. Click **Install Now**
5. Activate the plugin

### Method 2: Manual Installation
1. Upload the plugin files to `/wp-content/plugins/itomic-countdown/`
2. Activate the plugin through the **Plugins** menu in WordPress
3. Go to **Settings > Itomic Countdown** to configure

### Method 3: Quick Installation Steps
1. **Download the plugin files**
   - All files should be in a folder named `itomic-countdown`
   - The main plugin file is `itomic-countdown.php`

2. **Upload to WordPress**
   - Upload the entire `itomic-countdown` folder to `/wp-content/plugins/`
   - Or zip the folder and upload via WordPress admin

3. **Activate the plugin**
   - Go to WordPress Admin → Plugins
   - Find "Itomic Countdown" and click "Activate"

## Plugin Configuration

1. Navigate to **Settings > Itomic Countdown** in your WordPress admin
2. Enter your event details:
   - **Event Title**: Name of your event (e.g., "New Year 2025")
   - **Event Date & Time**: When your event will occur
   - **Timezone**: Your event's timezone (auto-detected by default)
   - **Display Position**: Where to show the countdown on your site

3. Click **Save Changes**

## Plugin File Structure

```
itomic-countdown/
├── itomic-countdown.php     # Main plugin file
├── readme.txt              # WordPress plugin readme
├── uninstall.php           # Cleanup when deleted
├── assets/
│   ├── css/
│   │   └── countdown.css   # Styles for countdown display
│   └── js/
│       └── countdown.js    # JavaScript for countdown logic
├── languages/              # Translation files
├── tests/                  # PHPUnit tests
├── bin/                    # Build and version management scripts
├── deploy/                 # Build artifacts (gitignored)
└── memory-bank/           # Project documentation
```

## Troubleshooting

### Common Issues

**Countdown not showing?**
- Check that you've set an event date in Settings → Itomic Countdown
- Ensure the plugin is activated
- Check browser console for JavaScript errors
- Verify the event date is in the future

**Countdown in wrong timezone?**
- Verify your timezone selection in the plugin settings
- The countdown uses the browser's local time for display
- Check WordPress timezone settings under Settings → General

**Styling issues?**
- The plugin uses modern CSS with backdrop-filter
- Some older browsers may not support all features
- The countdown will still function, just with reduced visual effects
- Check for theme CSS conflicts

**Plugin conflicts:**
- Ensure no duplicate plugin headers exist in development files
- Check for JavaScript conflicts with other plugins
- Verify WordPress and PHP version compatibility

**File permissions issues:**
- Ensure wp-content directory has proper write permissions
- Check that plugin files are readable by web server
- Verify no file ownership conflicts

## 🖥️ **Development Environment**

### **System Information**
- **OS**: AlmaLinux 9 on WSL2 (Windows 11 Pro)
- **Kernel**: Linux 6.6.87.2-microsoft-standard-WSL2
- **Shell**: /bin/bash
- **User**: spaceman
- **Workspace**: vscode-remote://wsl%2Balmalinux-9/home/spaceman/itomic-countdown

### **Web Server Stack**
- **Web Server**: Apache HTTP Server
- **PHP**: php-fpm (multiple versions via CloudLinux PHP Selector)
- **Database**: MariaDB
- **Port**: 80 (localhost)

## 📁 **Directory Structure**

```
/home/spaceman/
├── itomic-countdown/                           # Plugin development (THIS PROJECT)
│   ├── memory-bank/                           # Local documentation system
│   ├── plugin/                                # Clean WordPress plugin files (symlinked)
│   │   ├── itomic-countdown.php               # Main plugin file
│   │   ├── assets/, languages/               # Plugin assets
│   │   └── readme.txt, uninstall.php         # WordPress files
│   ├── assets/, bin/, tests/, deploy/        # Development files
│   └── [All other development files]
├── vanilla/                                   # WordPress testing environment
│   └── public_html/                          # WordPress installation
│       └── wp-content/plugins/
│           └── itomic-countdown -> /home/spaceman/itomic-countdown/plugin/
└── wordpress-dev-tools/                      # Plugin scaffolding toolkit
    ├── create-plugin.sh                      # Plugin generator
    └── README.md                             # Toolkit documentation
```

## 🔗 **Symlink Configuration**

### **Clean Plugin Structure** *(Security Enhancement)*
The symlink now points to a clean `plugin/` directory containing only WordPress plugin files, not the entire development repository.

### **Active Symlinks**
```bash
# Plugin development → WordPress testing (SECURE)
/home/spaceman/vanilla/public_html/wp-content/plugins/itomic-countdown
    → /home/spaceman/itomic-countdown/plugin

# WordPress only sees: itomic-countdown.php, readme.txt, uninstall.php, assets/, languages/
# WordPress CANNOT see: .git/, composer.json, tests/, bin/, deploy/, memory-bank/, etc.
```

### **Symlink Management**
```bash
# Create clean symlink (current setup)
ln -sf /home/spaceman/itomic-countdown/plugin /home/spaceman/vanilla/public_html/wp-content/plugins/itomic-countdown

# Verify symlink
ls -la /home/spaceman/vanilla/public_html/wp-content/plugins/ | grep itomic

# Check what WordPress can see (should only show plugin files)
ls -la /home/spaceman/vanilla/public_html/wp-content/plugins/itomic-countdown/

# Remove symlink (development only)
rm /home/spaceman/vanilla/public_html/wp-content/plugins/itomic-countdown
```

### **Development Sync Workflow**
Since the symlink points to `plugin/`, you need to sync changes from the main development files:

```bash
# After editing plugin files, sync to WordPress
composer sync

# Or run the sync script directly
./bin/sync-plugin.sh

# What gets synced to plugin/:
# ✅ itomic-countdown.php
# ✅ readme.txt  
# ✅ uninstall.php
# ✅ assets/ (CSS, JS)
# ✅ languages/ (translations)
# ❌ All development files excluded
```

## 🐘 **PHP Configuration**

### **Upload Settings** *(Updated for Plugin Testing)*
- **upload_max_filesize**: 64M *(was 2M)*
- **post_max_size**: 64M *(was 8M)*
- **max_execution_time**: 0 (unlimited)
- **memory_limit**: 128M

### **Configuration File**
- **Location**: `/etc/php.ini`
- **Changes Applied**: 2025-01-17

### **Service Restart Commands**
```bash
# Restart PHP-FPM
sudo systemctl restart php-fpm

# Restart Apache
sudo systemctl restart httpd

# Verify changes
php -i | grep -E "(upload_max_filesize|post_max_size)"
```

## 🌐 **WordPress Configuration**

### **Testing WordPress Installation**
- **Location**: `/home/spaceman/vanilla/public_html/`
- **URL**: http://localhost/vanilla/public_html/
- **Admin URL**: http://localhost/vanilla/public_html/wp-admin/
- **Database**: vanilla (MariaDB)

### **WordPress-Specific Settings**
```php
// Added to wp-config.php for local development
define( 'FS_METHOD', 'direct' );  // Enables direct file access
```

### **File Permissions**
```bash
# Directory permissions
find /home/spaceman/vanilla/public_html -type d -exec chmod 775 {} \;

# File permissions  
find /home/spaceman/vanilla/public_html -type f -exec chmod 664 {} \;

# wp-content ownership and permissions
sudo chown -R spaceman:apache /home/spaceman/vanilla/public_html/wp-content/
sudo chmod -R 775 /home/spaceman/vanilla/public_html/wp-content/

# uploads directory (apache-owned)
sudo chown -R apache:apache /home/spaceman/vanilla/public_html/wp-content/uploads/
sudo chmod -R 777 /home/spaceman/vanilla/public_html/wp-content/uploads/

# User group membership
sudo usermod -a -G apache spaceman
```

## 🔧 **Apache Configuration**

### **Virtual Host** *(Existing Configuration)*
```apache
# Configuration location: /etc/httpd/conf.d/
# The vanilla WordPress uses the standard document root configuration
# No custom virtual host needed for /vanilla/public_html/
```

### **Key Apache Settings**
- **Document Root**: `/var/www/html` (with subdirectories)
- **User**: apache
- **Group**: apache
- **Process**: Multiple httpd processes

## 🛠️ **Development Tools**

### **Composer Dependencies**
```json
{
    "require-dev": {
        "phpunit/phpunit": "^9.0",
        "squizlabs/php_codesniffer": "^3.6", 
        "wp-coding-standards/wpcs": "^2.3",
        "dealerdirect/phpcodesniffer-composer-installer": "^0.7"
    }
}
```

### **Development Commands**
```bash
# Install dependencies
composer install

# Sync plugin files to WordPress (after making changes)
composer sync

# Coding standards check
composer phpcs

# Auto-fix coding standards
composer phpcbf

# Version management
composer run release:patch
composer run release:minor
composer run release:major
```

## 🔍 **WordPress Plugin Checker**

### **Installation Status**
- ✅ **Installed**: Successfully uploaded and activated
- ✅ **Upload Limit**: Fixed (increased to 64MB)
- ✅ **Permissions**: Resolved with FS_METHOD=direct

### **Plugin Checker Results**
- **Development Files Detected**: ✅ Expected for development environment
- **Component Files**: composer.json, tests/, bin/, deploy/ (normal)
- **Custom Update System**: Detected (normal for self-hosted)

## 🔐 **Security Configuration**

### **Local Development Security**
- **File Permissions**: Relaxed for development (775/664)
- **User Groups**: spaceman added to apache group
- **WordPress**: Direct file system access enabled
- **Upload Directory**: Full write permissions

### **Production vs Development**
```bash
# Development (current)
chmod 775 directories
chmod 664 files
FS_METHOD = direct

# Production (would be)
chmod 755 directories  
chmod 644 files
FS_METHOD = auto (FTP/SSH)
```

## 🚨 **Troubleshooting**

### **Common Permission Issues**
```bash
# Fix WordPress permissions
sudo chown -R spaceman:apache /home/spaceman/vanilla/public_html/wp-content/
sudo chmod -R 775 /home/spaceman/vanilla/public_html/wp-content/

# Fix uploads directory
sudo chown -R apache:apache /home/spaceman/vanilla/public_html/wp-content/uploads/
sudo chmod -R 777 /home/spaceman/vanilla/public_html/wp-content/uploads/
```

### **Symlink Issues**
```bash
# Check if symlink exists and points to clean plugin directory
ls -la /home/spaceman/vanilla/public_html/wp-content/plugins/ | grep itomic

# Recreate clean symlink (security-enhanced)
rm /home/spaceman/vanilla/public_html/wp-content/plugins/itomic-countdown
ln -sf /home/spaceman/itomic-countdown/plugin /home/spaceman/vanilla/public_html/wp-content/plugins/itomic-countdown

# Sync plugin files after symlink creation
composer sync
```

### **Plugin Sync Issues**
```bash
# If plugin changes don't appear in WordPress
composer sync

# Or run sync script directly
./bin/sync-plugin.sh

# Check sync was successful
ls -la /home/spaceman/itomic-countdown/plugin/
```

### **Plugin Not Appearing**
1. **Check symlink** - Verify symlink is created and pointing correctly
2. **Check permissions** - Ensure WordPress can read plugin files
3. **Check plugin header** - Verify main plugin file has proper headers
4. **Restart services** - Restart Apache/PHP-FPM if needed

### **Upload Issues**
```bash
# Check PHP upload settings
php -i | grep -E "(upload_max_filesize|post_max_size)"

# Restart services after changes
sudo systemctl restart php-fpm
sudo systemctl restart httpd
```

## 📋 **Environment Checklist**

### **Before Development**
- [ ] WordPress test site accessible (http://localhost/vanilla/public_html/)
- [ ] Plugin symlink created and pointing to clean plugin/ directory
- [ ] Plugin files synced to WordPress (composer sync)
- [ ] Composer dependencies installed
- [ ] Git repository initialized
- [ ] File permissions correct

### **Before Deployment**
- [ ] Version updated in all files
- [ ] Coding standards check passed
- [ ] Plugin tested locally
- [ ] Git changes committed
- [ ] Deployment scripts tested

## 🔄 **Backup & Recovery**

### **Configuration Backup**
```bash
# Backup important configs
cp /etc/php.ini /home/spaceman/config-backups/php.ini.backup
cp /home/spaceman/vanilla/public_html/wp-config.php /home/spaceman/config-backups/

# Backup WordPress database
mysqldump -u root -p vanilla > /home/spaceman/config-backups/vanilla-wp.sql
```

### **Recovery Procedures**
```bash
# Restore PHP config
sudo cp /home/spaceman/config-backups/php.ini.backup /etc/php.ini
sudo systemctl restart php-fpm httpd

# Restore WordPress
cp /home/spaceman/config-backups/wp-config.php /home/spaceman/vanilla/public_html/
mysql -u root -p vanilla < /home/spaceman/config-backups/vanilla-wp.sql
```

---

**Configuration Date**: 2025-01-17  
**Last Verified**: 2025-01-17  
**Environment**: Local Development (WSL2)  
**Status**: ✅ Fully Configured and Working 