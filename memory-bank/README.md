# Memory Bank - Itomic Countdown Plugin Documentation

*Centralized documentation system for the Itomic Countdown WordPress plugin project.*

## 📚 **Documentation Index**

### **Quick Reference**
- **Current Version**: 1.0.10
- **Project Status**: Production-ready with automated deployment
- **Local Environment**: `/home/spaceman/itomic-countdown/` (development) + `/home/spaceman/vanilla/public_html/` (testing)

### **Documentation Files**

| File | Purpose | Contents |
|------|---------|----------|
| [`project-overview.md`](project-overview.md) | **What & Why** | Features, architecture, use cases, version history |
| [`configuration-notes.md`](configuration-notes.md) | **Setup & Config** | Installation, WordPress setup, troubleshooting |
| [`development-decisions.md`](development-decisions.md) | **How & Standards** | Workflow, testing, coding standards, resources |
| [`deployment-guide.md`](deployment-guide.md) | **Release & Deploy** | Version management, CI/CD, update system |

## 🔄 **Recent Updates**

### **Security Enhancement - Clean Symlink Setup** *(January 2025)*
Improved development environment security by isolating WordPress plugin files:

**Security Improvements:**
- ✅ **Clean Plugin Directory** - WordPress only sees production plugin files in `plugin/` subdirectory
- ✅ **Development Isolation** - Git, composer, tests, and build files are hidden from WordPress
- ✅ **Sync Workflow** - New `composer sync` command to update WordPress testing environment
- ✅ **Enhanced Documentation** - Updated memory-bank docs with new workflow

### **Documentation Consolidation** *(January 2025)*
Successfully merged original project documentation into centralized memory-bank:

**Consolidated Files:**
- ✅ `README.md` → Merged into `project-overview.md` (features, changelog) and `configuration-notes.md` (installation)
- ✅ `DEVELOPMENT.md` → Merged into `development-decisions.md` (workflow, testing) and `deployment-guide.md` (releases)
- ✅ `INSTALLATION.md` → Merged into `configuration-notes.md` (setup, troubleshooting)

**Benefits:**
- **Single Source of Truth**: All documentation in one organized location
- **Comprehensive Coverage**: No information loss during consolidation
- **Better Organization**: Logical grouping by purpose rather than historical files
- **Easier Maintenance**: One system to update rather than scattered files

## 🎯 **Quick Navigation**

### **New to the Project?**
1. Start with [`project-overview.md`](project-overview.md) - Understand what the plugin does
2. Read [`configuration-notes.md`](configuration-notes.md) - Set up your environment
3. Review [`development-decisions.md`](development-decisions.md) - Learn the development workflow

### **Working on Features?**
- [`development-decisions.md`](development-decisions.md) - Development workflow and testing
- [`configuration-notes.md`](configuration-notes.md) - Local environment setup

### **Releasing Updates?**
- [`deployment-guide.md`](deployment-guide.md) - Version management and deployment procedures
- [`project-overview.md`](project-overview.md) - Update version history

### **Troubleshooting?**
- [`configuration-notes.md`](configuration-notes.md) - Environment and plugin issues
- [`deployment-guide.md`](deployment-guide.md) - Deployment and update problems

## 🏗️ **Development Environment Architecture**

```
/home/spaceman/
├── itomic-countdown/                    # 🚀 Plugin Development (Git repo)
│   ├── memory-bank/                     # 📚 This documentation system
│   ├── itomic-countdown.php            # 🔧 Main plugin file (v1.0.10)
│   ├── assets/                         # 🎨 CSS, JS, images
│   ├── bin/                            # 🛠️ Version management scripts
│   ├── deploy/                         # 📦 Build artifacts
│   └── tests/                          # 🧪 PHPUnit tests
├── vanilla/public_html/                 # 🧪 WordPress Testing Environment
│   └── wp-content/plugins/
│       └── itomic-countdown -> symlink  # 🔗 Live testing link
└── wordpress-dev-tools/                 # 🏭 Plugin Scaffolding System
    ├── create-plugin.sh                # 🚀 New plugin generator
    └── README.md                       # 📖 Toolkit documentation
```

## 🚀 **Essential Commands**

### **Development**
```bash
cd /home/spaceman/itomic-countdown

# Sync plugin files to WordPress (after changes)
composer sync                    # Sync to plugin/ directory

# Test and validate
composer test                    # Run PHPUnit tests
composer phpcs                   # Check coding standards

# Version management
composer run release:patch       # 1.0.10 → 1.0.11
composer run release:minor       # 1.0.10 → 1.1.0
```

### **Local Testing**
```bash
# WordPress testing environment
http://localhost/vanilla/public_html/wp-admin/
# Login: admin / admin (or set during setup)
```

## 💡 **Key Insights**

### **Project Strengths**
- ✅ **Professional Development Environment** - Full CI/CD pipeline with local testing
- ✅ **WordPress.org Compliance** - Follows all coding standards and best practices  
- ✅ **Automated Deployment** - Bitbucket Pipelines → pegasus.itomic.com → client sites
- ✅ **Single Source Version Management** - Eliminates version conflicts
- ✅ **Comprehensive Documentation** - This memory-bank system

### **Current Focus Areas**
- 🎯 **Enhanced Documentation** - Centralized knowledge management
- 🎯 **Development Security** - Clean symlink setup isolating development files
- 🎯 **Development Efficiency** - Streamlined local testing with sync workflow
- 🎯 **Code Quality** - Automated testing and standards compliance

## 📞 **Quick Help**

### **Common Tasks**
- **New feature development**: See [`development-decisions.md`](development-decisions.md#development-workflow)
- **Release new version**: See [`deployment-guide.md`](deployment-guide.md#release-process)
- **Fix environment issues**: See [`configuration-notes.md`](configuration-notes.md#troubleshooting)
- **Understand plugin features**: See [`project-overview.md`](project-overview.md#key-features)

### **Support Resources**
- **Plugin Issues**: Check [`configuration-notes.md`](configuration-notes.md#troubleshooting)
- **Development Questions**: Review [`development-decisions.md`](development-decisions.md#development-resources)
- **Deployment Problems**: See [`deployment-guide.md`](deployment-guide.md#troubleshooting-deployment)

---

**📅 Last Updated**: January 17, 2025  
**🔄 Documentation Version**: 2.0 (Post-consolidation)  
**👤 Maintained by**: Itomic Development Team 