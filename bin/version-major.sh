#!/bin/bash

# Get current version from plugin file
CURRENT_VERSION=$(grep "Version:" itomic-countdown.php | head -1 | sed 's/.*Version: *//' | tr -d ' \t\r\n')

if [ -z "$CURRENT_VERSION" ]; then
    echo "ERROR: Could not determine current version"
    exit 1
fi

# Split version into parts
IFS='.' read -r -a version_parts <<< "$CURRENT_VERSION"
major=${version_parts[0]}

# Increment major version, reset minor and patch
new_major=$((major + 1))
NEW_VERSION="$new_major.0.0"

echo "Major version bump: $CURRENT_VERSION → $NEW_VERSION"

# Call bump-version script
bin/bump-version.sh "$NEW_VERSION" --commit 