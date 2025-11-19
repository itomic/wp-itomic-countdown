#!/bin/bash

# WordPress Plugin Version Management Script
# This script follows WordPress.org best practices for version management
# Usage: ./bin/bump-version.sh <new-version> [--commit]
# Examples:
#   ./bin/bump-version.sh 1.0.6
#   ./bin/bump-version.sh 1.1.0 --commit

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
PLUGIN_FILE="itomic-countdown.php"
README_FILE="readme.txt"
COMPOSER_FILE="composer.json"
DEPLOY_DIR="deploy"
VERSION_JSON="$DEPLOY_DIR/version.json"
INFO_JSON="$DEPLOY_DIR/info.json"

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to validate semantic version
validate_version() {
    if [[ ! $1 =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
        print_error "Invalid version format. Please use semantic versioning (e.g., 1.0.6)"
        echo "Examples: 1.0.6, 1.1.0, 2.0.0"
        exit 1
    fi
}

# Function to get current version from plugin file
get_current_version() {
    grep "Version:" "$PLUGIN_FILE" | head -1 | sed 's/.*Version: *//' | tr -d ' \t\r\n'
}

# Function to compare versions
version_greater() {
    test "$(printf '%s\n' "$@" | sort -V | head -n 1)" != "$1"
}

# Function to update plugin header
update_plugin_header() {
    local new_version=$1
    print_status "Updating plugin header in $PLUGIN_FILE..."
    
    # Update Version field in plugin header
    sed -i "s/^ \* Version: .*/ * Version: $new_version/" "$PLUGIN_FILE"
    
    # Update ITOMIC_COUNTDOWN_VERSION constant
    sed -i "s/define( 'ITOMIC_COUNTDOWN_VERSION', '.*' );/define( 'ITOMIC_COUNTDOWN_VERSION', '$new_version' );/" "$PLUGIN_FILE"
    
    print_success "Updated plugin header"
}

# Function to update readme.txt
update_readme() {
    local new_version=$1
    print_status "Updating readme.txt..."
    
    # Update Stable tag
    sed -i "s/Stable tag: .*/Stable tag: $new_version/" "$README_FILE"
    
    print_success "Updated readme.txt"
}

# Function to update composer.json
update_composer() {
    local new_version=$1
    print_status "Updating composer.json..."
    
    # Check if version field exists, add it if not
    if grep -q '"version":' "$COMPOSER_FILE"; then
        sed -i "s/\"version\": \".*\"/\"version\": \"$new_version\"/" "$COMPOSER_FILE"
    else
        # Add version field after name
        sed -i "/\"name\": \".*\"/a\\    \"version\": \"$new_version\"," "$COMPOSER_FILE"
    fi
    
    print_success "Updated composer.json"
}

# Function to update deploy files
update_deploy_files() {
    local new_version=$1
    print_status "Updating deploy files..."
    
    # Create deploy directory if it doesn't exist
    mkdir -p "$DEPLOY_DIR"
    
    # Update version.json if it exists
    if [ -f "$VERSION_JSON" ]; then
        sed -i "s/\"version\": \".*\"/\"version\": \"$new_version\"/" "$VERSION_JSON"
        print_success "Updated $VERSION_JSON"
    fi
    
    # Update info.json if it exists
    if [ -f "$INFO_JSON" ]; then
        sed -i "s/\"version\": \".*\"/\"version\": \"$new_version\"/" "$INFO_JSON"
        print_success "Updated $INFO_JSON"
    fi
}

# Function to add changelog entry
add_changelog_entry() {
    local new_version=$1
    local current_date=$(date +%Y-%m-%d)
    
    print_status "Would you like to add a changelog entry for version $new_version? (y/n)"
    read -r add_changelog
    
    if [[ $add_changelog == "y" || $add_changelog == "Y" ]]; then
        echo ""
        echo "Enter changelog items (one per line, press Ctrl+D when done):"
        echo "Example: * Fixed countdown display issues"
        echo "         * Added new timezone support"
        echo ""
        
        # Read changelog items
        changelog_items=""
        while IFS= read -r line; do
            if [[ -n "$line" ]]; then
                changelog_items+="$line\\n"
            fi
        done
        
        if [[ -n "$changelog_items" ]]; then
            # Add to readme.txt
            sed -i "/== Changelog ==/a\\\\n= $new_version =\\n$changelog_items" "$README_FILE"
            print_success "Added changelog entry to readme.txt"
            
            # Update info.json changelog if it exists
            if [ -f "$INFO_JSON" ]; then
                # This is more complex - we'll update the deploy script to handle this
                print_warning "info.json changelog will be updated by deploy script"
            fi
        fi
    fi
}

# Function to show summary of changes
show_summary() {
    local old_version=$1
    local new_version=$2
    
    echo ""
    echo "================================"
    echo -e "${GREEN}VERSION UPDATE SUMMARY${NC}"
    echo "================================"
    echo "Previous version: $old_version"
    echo "New version:      $new_version"
    echo ""
    echo "Files updated:"
    echo "  ✓ $PLUGIN_FILE (header + constant)"
    echo "  ✓ $README_FILE (stable tag)"
    echo "  ✓ $COMPOSER_FILE (version field)"
    if [ -f "$VERSION_JSON" ]; then
        echo "  ✓ $VERSION_JSON"
    fi
    if [ -f "$INFO_JSON" ]; then
        echo "  ✓ $INFO_JSON"
    fi
    echo ""
}

# Function to commit changes
commit_changes() {
    local new_version=$1
    print_status "Committing version bump to git..."
    
    git add .
    git commit -m "Bump version to $new_version

- Updated plugin header and version constant
- Updated readme.txt stable tag
- Updated composer.json version
- Updated deploy configuration files

Ready for deployment and release."
    
    print_success "Changes committed to git"
    
    # Ask about creating a tag
    echo ""
    print_status "Would you like to create a git tag for version $new_version? (y/n)"
    read -r create_tag
    
    if [[ $create_tag == "y" || $create_tag == "Y" ]]; then
        git tag -a "v$new_version" -m "Release version $new_version"
        print_success "Created git tag v$new_version"
        
        print_status "Push tag to remote? (y/n)"
        read -r push_tag
        
        if [[ $push_tag == "y" || $push_tag == "Y" ]]; then
            git push origin "v$new_version"
            print_success "Pushed tag to remote repository"
        fi
    fi
}

# Main script logic
main() {
    echo ""
    echo "================================="
    echo -e "${BLUE}WordPress Plugin Version Manager${NC}"
    echo "================================="
    echo ""
    
    # Check if we're in the right directory
    if [ ! -f "$PLUGIN_FILE" ]; then
        print_error "Plugin file $PLUGIN_FILE not found. Are you in the plugin root directory?"
        exit 1
    fi
    
    # Parse arguments
    if [ $# -eq 0 ]; then
        print_error "No version specified"
        echo "Usage: $0 <new-version> [--commit]"
        echo "Example: $0 1.0.6 --commit"
        exit 1
    fi
    
    NEW_VERSION=$1
    COMMIT_CHANGES=false
    
    if [ $# -eq 2 ] && [ "$2" = "--commit" ]; then
        COMMIT_CHANGES=true
    fi
    
    # Validate version format
    validate_version "$NEW_VERSION"
    
    # Get current version
    CURRENT_VERSION=$(get_current_version)
    
    if [ -z "$CURRENT_VERSION" ]; then
        print_error "Could not determine current version from $PLUGIN_FILE"
        exit 1
    fi
    
    print_status "Current version: $CURRENT_VERSION"
    print_status "New version: $NEW_VERSION"
    
    # Check if new version is greater than current
    if ! version_greater "$NEW_VERSION" "$CURRENT_VERSION"; then
        print_error "New version ($NEW_VERSION) must be greater than current version ($CURRENT_VERSION)"
        exit 1
    fi
    
    # Confirm with user unless auto-committing
    if [ "$COMMIT_CHANGES" = false ]; then
        echo ""
        print_status "Update version from $CURRENT_VERSION to $NEW_VERSION? (y/n)"
        read -r confirm
        
        if [[ $confirm != "y" && $confirm != "Y" ]]; then
            print_warning "Version update cancelled"
            exit 0
        fi
    fi
    
    echo ""
    print_status "Starting version update..."
    
    # Update all files
    update_plugin_header "$NEW_VERSION"
    update_readme "$NEW_VERSION"
    update_composer "$NEW_VERSION"
    update_deploy_files "$NEW_VERSION"
    
    # Add changelog entry (interactive)
    if [ "$COMMIT_CHANGES" = false ]; then
        add_changelog_entry "$NEW_VERSION"
    fi
    
    # Show summary
    show_summary "$CURRENT_VERSION" "$NEW_VERSION"
    
    # Commit if requested
    if [ "$COMMIT_CHANGES" = true ]; then
        commit_changes "$NEW_VERSION"
        echo ""
        print_success "Version bump complete and committed!"
        print_status "Next steps:"
        echo "  1. Push to remote: git push origin main"
        echo "  2. Deploy: ./deploy.sh"
        echo "  3. Verify deployment on your update server"
    else
        echo ""
        print_success "Version bump complete!"
        print_status "Next steps:"
        echo "  1. Review the changes"
        echo "  2. Commit: git add . && git commit -m 'Bump version to $NEW_VERSION'"
        echo "  3. Push: git push origin main"
        echo "  4. Deploy: ./deploy.sh"
    fi
    
    echo ""
}

# Run the script
main "$@" 