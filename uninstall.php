<?php
/**
 * Uninstall Itomic Countdown Plugin
 * 
 * This file is executed when the plugin is deleted.
 * It removes all plugin data from the database.
 */

// If uninstall not called from WordPress, exit
if ( ! defined( 'WP_UNINSTALL_PLUGIN' ) ) {
    exit;
}

// Delete plugin options
delete_option( 'itomic_countdown_settings' );

// Clean up any transients
delete_transient( 'itomic_countdown_cache' );

// Note: We don't delete user meta or posts as this plugin doesn't create any 