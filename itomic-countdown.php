<?php
/**
 * Plugin Name: Itomic Countdown
 * Plugin URI: https://www.itomic.com.au/itomic-countdown/
 * Description: Display a real-time countdown to any event on your WordPress site.
 * Version: 1.0.4
 * Author: Itomic
 * Author URI: https://www.itomic.com.au/
 * Developer: Itomic
 * Developer URI: https://www.itomic.com.au/
 * Text Domain: itomic-countdown
 * Domain Path: /languages
 * License: GNU General Public License v3.0
 * License URI: http://www.gnu.org/licenses/gpl-3.0.html
 */

// Prevent direct access
if ( ! defined( 'ABSPATH' ) ) {
    exit; // Exit if accessed directly
}

// Define plugin constants
define( 'ITOMIC_COUNTDOWN_VERSION', '1.0.4' );
define( 'ITOMIC_COUNTDOWN_PLUGIN_DIR', plugin_dir_path( __FILE__ ) );
define( 'ITOMIC_COUNTDOWN_PLUGIN_URL', plugin_dir_url( __FILE__ ) );
define( 'ITOMIC_COUNTDOWN_UPDATE_URL', 'https://itomic.com.au/plugins/itomic-countdown/' );

/**
 * Main Itomic Countdown Plugin Class
 */
class Itomic_Countdown_Plugin {
    
    /**
     * Constructor
     */
    public function __construct() {
        add_action( 'init', array( $this, 'init' ) );
        add_action( 'admin_menu', array( $this, 'add_admin_menu' ) );
        add_action( 'admin_init', array( $this, 'init_settings' ) );
        add_action( 'wp_enqueue_scripts', array( $this, 'enqueue_scripts' ) );
        add_action( 'wp_footer', array( $this, 'display_countdown' ) );
        add_filter( 'plugin_action_links_' . plugin_basename( __FILE__ ), array( $this, 'add_settings_link' ) );
        
        // Add update checking
        add_filter( 'pre_set_site_transient_update_plugins', array( $this, 'check_for_updates' ) );
        add_filter( 'plugins_api', array( $this, 'plugin_info' ), 10, 3 );
        
        // Add auto-update functionality
        add_filter( 'auto_update_plugin', array( $this, 'auto_update_plugin' ), 10, 2 );
        add_filter( 'plugin_auto_update_setting_html', array( $this, 'auto_update_setting_html' ), 10, 2 );
    }
    
    /**
     * Initialize the plugin
     */
    public function init() {
        load_plugin_textdomain( 'itomic-countdown', false, dirname( plugin_basename( __FILE__ ) ) . '/languages' );
    }
    
    /**
     * Add admin menu
     */
    public function add_admin_menu() {
        add_options_page(
            __( 'Itomic Countdown Settings', 'itomic-countdown' ),
            __( 'Itomic Countdown', 'itomic-countdown' ),
            'manage_options',
            'itomic-countdown',
            array( $this, 'admin_page' )
        );
    }
    
    /**
     * Initialize settings
     */
    public function init_settings() {
        register_setting( 'itomic_countdown_options', 'itomic_countdown_settings', array(
            'sanitize_callback' => array( $this, 'sanitize_settings' )
        ) );
        
        add_settings_section(
            'itomic_countdown_main',
            __( 'Countdown Settings', 'itomic-countdown' ),
            array( $this, 'settings_section_callback' ),
            'itomic-countdown'
        );
        
        add_settings_field(
            'event_title',
            __( 'Event Title', 'itomic-countdown' ),
            array( $this, 'event_title_callback' ),
            'itomic-countdown',
            'itomic_countdown_main'
        );
        
        add_settings_field(
            'event_date',
            __( 'Event Date & Time', 'itomic-countdown' ),
            array( $this, 'event_date_callback' ),
            'itomic-countdown',
            'itomic_countdown_main'
        );
        
        add_settings_field(
            'timezone',
            __( 'Timezone', 'itomic-countdown' ),
            array( $this, 'timezone_callback' ),
            'itomic-countdown',
            'itomic_countdown_main'
        );
        
        add_settings_field(
            'display_position',
            __( 'Display Position', 'itomic-countdown' ),
            array( $this, 'display_position_callback' ),
            'itomic-countdown',
            'itomic_countdown_main'
        );
    }
    
    /**
     * Sanitize settings
     */
    public function sanitize_settings( $input ) {
        $sanitized = array();
        
        if ( isset( $input['event_title'] ) ) {
            $sanitized['event_title'] = sanitize_text_field( $input['event_title'] );
        }
        
        if ( isset( $input['event_date'] ) ) {
            $sanitized['event_date'] = sanitize_text_field( $input['event_date'] );
        }
        
        if ( isset( $input['timezone'] ) ) {
            $timezones = DateTimeZone::listIdentifiers();
            $sanitized['timezone'] = in_array( $input['timezone'], $timezones ) ? sanitize_text_field( $input['timezone'] ) : 'UTC';
        }
        
        if ( isset( $input['display_position'] ) ) {
            $valid_positions = array( 'top-left', 'top-middle', 'top-right', 'middle-left', 'middle-middle', 'middle-right', 'bottom-left', 'bottom-middle', 'bottom-right' );
            $sanitized['display_position'] = in_array( $input['display_position'], $valid_positions ) ? sanitize_text_field( $input['display_position'] ) : 'top-right';
        }
        
        return $sanitized;
    }
    
    /**
     * Settings section callback
     */
    public function settings_section_callback() {
        echo '<p>' . __( 'Configure your countdown display settings below.', 'itomic-countdown' ) . '</p>';
    }
    
    /**
     * Event title field callback
     */
    public function event_title_callback() {
        $options = get_option( 'itomic_countdown_settings' );
        $value = isset( $options['event_title'] ) ? $options['event_title'] : '';
        echo '<input type="text" id="event_title" name="itomic_countdown_settings[event_title]" value="' . esc_attr( $value ) . '" class="regular-text" />';
        echo '<p class="description">' . esc_html__( 'Enter the title of your event (e.g., "New Year 2025")', 'itomic-countdown' ) . '</p>';
    }
    
    /**
     * Event date field callback
     */
    public function event_date_callback() {
        $options = get_option( 'itomic_countdown_settings' );
        $value = isset( $options['event_date'] ) ? $options['event_date'] : '';
        echo '<input type="datetime-local" id="event_date" name="itomic_countdown_settings[event_date]" value="' . esc_attr( $value ) . '" />';
        echo '<p class="description">' . esc_html__( 'Select the date and time of your event', 'itomic-countdown' ) . '</p>';
    }
    
    /**
     * Get default timezone for the user/server
     * Attempts to detect the most appropriate timezone
     */
    private function get_default_timezone() {
        // First, try to get the server's timezone
        $server_timezone = date_default_timezone_get();
        
        // If server timezone is valid and not UTC, use it
        if ($server_timezone && $server_timezone !== 'UTC' && in_array($server_timezone, DateTimeZone::listIdentifiers())) {
            return $server_timezone;
        }
        
        // Try to get timezone from WordPress settings
        $wp_timezone = get_option('timezone_string');
        if ($wp_timezone && in_array($wp_timezone, DateTimeZone::listIdentifiers())) {
            return $wp_timezone;
        }
        
        // Try to get timezone from WordPress offset
        $wp_offset = get_option('gmt_offset');
        if ($wp_offset !== false) {
            // Convert offset to timezone
            $offset_hours = intval($wp_offset);
            $offset_minutes = abs(($wp_offset - $offset_hours) * 60);
            $offset_string = sprintf('%+03d:%02d', $offset_hours, $offset_minutes);
            
            // Find a timezone that matches this offset
            $timezones = DateTimeZone::listIdentifiers();
            foreach ($timezones as $timezone) {
                try {
                    $tz = new DateTimeZone($timezone);
                    $date = new DateTime('now', $tz);
                    $offset = $date->format('P');
                    if ($offset === $offset_string) {
                        return $timezone;
                    }
                } catch (Exception $e) {
                    continue;
                }
            }
        }
        
        // Fallback to UTC if nothing else works
        return 'UTC';
    }

    /**
     * Timezone field callback
     */
    public function timezone_callback() {
        $options = get_option( 'itomic_countdown_settings' );
        $value = isset( $options['timezone'] ) ? $options['timezone'] : $this->get_default_timezone();
        
        $timezones = DateTimeZone::listIdentifiers();
        echo '<select id="timezone" name="itomic_countdown_settings[timezone]">';
        foreach ( $timezones as $timezone ) {
            $selected = ( $timezone === $value ) ? 'selected' : '';
            echo '<option value="' . esc_attr( $timezone ) . '" ' . esc_attr( $selected ) . '>' . esc_html( $timezone ) . '</option>';
        }
        echo '</select>';
        echo '<p class="description">' . esc_html__( 'Select the timezone for your event. Default is automatically detected from your server/WordPress settings.', 'itomic-countdown' ) . '</p>';
    }
    
    /**
     * Display position field callback
     */
    public function display_position_callback() {
        $options = get_option( 'itomic_countdown_settings' );
        $value = isset( $options['display_position'] ) ? $options['display_position'] : 'top-right';
        
        $positions = array(
            'top-left' => __( 'Top Left', 'itomic-countdown' ),
            'top-middle' => __( 'Top Middle', 'itomic-countdown' ),
            'top-right' => __( 'Top Right', 'itomic-countdown' ),
            'middle-left' => __( 'Middle Left', 'itomic-countdown' ),
            'middle-middle' => __( 'Middle Middle', 'itomic-countdown' ),
            'middle-right' => __( 'Middle Right', 'itomic-countdown' ),
            'bottom-left' => __( 'Bottom Left', 'itomic-countdown' ),
            'bottom-middle' => __( 'Bottom Middle', 'itomic-countdown' ),
            'bottom-right' => __( 'Bottom Right', 'itomic-countdown' )
        );
        
        echo '<select id="display_position" name="itomic_countdown_settings[display_position]">';
        foreach ( $positions as $key => $label ) {
            $selected = ( $key === $value ) ? 'selected' : '';
            echo '<option value="' . esc_attr( $key ) . '" ' . esc_attr( $selected ) . '>' . esc_html( $label ) . '</option>';
        }
        echo '</select>';
        echo '<p class="description">' . esc_html__( 'Choose where to display the countdown on your site', 'itomic-countdown' ) . '</p>';
    }
    
    /**
     * Admin page callback
     */
    public function admin_page() {
        ?>
        <div class="wrap">
            <h1><?php echo esc_html( get_admin_page_title() ); ?></h1>
            <form method="post" action="options.php">
                <?php
                settings_fields( 'itomic_countdown_options' );
                do_settings_sections( 'itomic-countdown' );
                submit_button();
                ?>
            </form>
        </div>
        <?php
    }
    
    /**
     * Add settings link to plugins page
     */
    public function add_settings_link( $links ) {
        $settings_link = '<a href="' . admin_url( 'options-general.php?page=itomic-countdown' ) . '">' . __( 'Settings', 'itomic-countdown' ) . '</a>';
        array_unshift( $links, $settings_link );
        return $links;
    }
    
    /**
     * Enqueue scripts and styles
     */
    public function enqueue_scripts() {
        wp_enqueue_script( 'itomic-countdown', ITOMIC_COUNTDOWN_PLUGIN_URL . 'assets/js/countdown.js', array( 'jquery' ), ITOMIC_COUNTDOWN_VERSION, true );
        wp_enqueue_style( 'itomic-countdown', ITOMIC_COUNTDOWN_PLUGIN_URL . 'assets/css/countdown.css', array(), ITOMIC_COUNTDOWN_VERSION );
        
        // Pass data to JavaScript
        $options = get_option( 'itomic_countdown_settings' );
        
        // Debug output for admins
        if ( current_user_can( 'manage_options' ) ) {
            echo '<!-- Itomic Countdown JS Debug: ';
            echo 'Event date: ' . ( isset( $options['event_date'] ) ? $options['event_date'] : 'NOT SET' ) . ' | ';
            echo 'Timezone: ' . ( isset( $options['timezone'] ) ? $options['timezone'] : 'NOT SET' ) . ' | ';
            echo 'Position: ' . ( isset( $options['display_position'] ) ? $options['display_position'] : 'NOT SET' );
            echo ' -->';
        }
        
        wp_localize_script( 'itomic-countdown', 'itomicCountdownData', array(
            'eventDate' => isset( $options['event_date'] ) ? $options['event_date'] : '',
            'timezone' => isset( $options['timezone'] ) ? $options['timezone'] : 'UTC',
            'position' => isset( $options['display_position'] ) ? $options['display_position'] : 'top-right'
        ) );
    }
    
    /**
     * Display countdown in footer
     */
    public function display_countdown() {
        $options = get_option( 'itomic_countdown_settings' );
        
        // Debug output (remove this after fixing)
        if ( current_user_can( 'manage_options' ) ) {
            echo '<!-- Itomic Countdown Debug: ';
            echo 'Event date: ' . ( isset( $options['event_date'] ) ? esc_html( $options['event_date'] ) : 'NOT SET' ) . ' | ';
            echo 'Event title: ' . ( isset( $options['event_title'] ) ? esc_html( $options['event_title'] ) : 'NOT SET' ) . ' | ';
            echo 'Position: ' . ( isset( $options['display_position'] ) ? esc_html( $options['display_position'] ) : 'NOT SET' ) . ' | ';
            echo 'Timezone: ' . ( isset( $options['timezone'] ) ? esc_html( $options['timezone'] ) : 'NOT SET' );
            echo ' -->';
        }
        
        if ( empty( $options['event_date'] ) ) {
            if ( current_user_can( 'manage_options' ) ) {
                echo '<!-- Itomic Countdown: No event date set -->';
            }
            return;
        }
        
        $event_title = isset( $options['event_title'] ) ? $options['event_title'] : __( 'Event', 'itomic-countdown' );
        $position = isset( $options['display_position'] ) ? $options['display_position'] : 'top-right';
        
        echo '<div id="itomic-countdown" class="itomic-countdown itomic-countdown-' . esc_attr( $position ) . '">';
        echo '<div class="countdown-content">';
        echo '<div class="countdown-title">' . esc_html( $event_title ) . '</div>';
        echo '<div class="countdown-timer" id="countdown-timer">';
        echo '<span class="days">0</span>d ';
        echo '<span class="hours">0</span>h ';
        echo '<span class="minutes">0</span>m ';
        echo '<span class="seconds">0</span>s';
        echo '</div>';
        echo '</div>';
        echo '</div>';
    }
    
    /**
     * Check for plugin updates
     */
    public function check_for_updates( $transient ) {
        // Simple test to see if this function is called
        file_put_contents( WP_CONTENT_DIR . '/update-test.txt', date('Y-m-d H:i:s') . ' - Update check called' . PHP_EOL, FILE_APPEND );
        
        if ( empty( $transient->checked ) ) {
            return $transient;
        }
        
        // Get plugin info
        $plugin_slug = basename( dirname( __FILE__ ) ) . '/' . basename( __FILE__ );
        
        // Debug output for admins
        if ( current_user_can( 'manage_options' ) ) {
            error_log( 'Itomic Countdown: Checking for updates from ' . ITOMIC_COUNTDOWN_UPDATE_URL );
        }
        
        // Check for updates from our server
        $response = wp_remote_get( ITOMIC_COUNTDOWN_UPDATE_URL . 'version.json' );
        
        if ( is_wp_error( $response ) ) {
            if ( current_user_can( 'manage_options' ) ) {
                error_log( 'Itomic Countdown: Update check failed - ' . $response->get_error_message() );
            }
            return $transient;
        }
        
        $body = wp_remote_retrieve_body( $response );
        $data = json_decode( $body, true );
        
        if ( ! $data || ! isset( $data['version'] ) ) {
            if ( current_user_can( 'manage_options' ) ) {
                error_log( 'Itomic Countdown: Invalid version data received' );
            }
            return $transient;
        }
        
        // Debug output for admins
        if ( current_user_can( 'manage_options' ) ) {
            error_log( 'Itomic Countdown: Current version ' . ITOMIC_COUNTDOWN_VERSION . ', Available version ' . $data['version'] );
        }
        
        // Compare versions
        if ( version_compare( ITOMIC_COUNTDOWN_VERSION, $data['version'], '<' ) ) {
            if ( current_user_can( 'manage_options' ) ) {
                error_log( 'Itomic Countdown: Update available - adding to transient' );
            }
            $transient->response[ $plugin_slug ] = (object) array(
                'slug' => basename( dirname( __FILE__ ) ),
                'new_version' => $data['version'],
                'url' => ITOMIC_COUNTDOWN_UPDATE_URL . 'info.json',
                'package' => ITOMIC_COUNTDOWN_UPDATE_URL . 'itomic-countdown-' . $data['version'] . '.zip'
            );
        }
        
        return $transient;
    }
    
    /**
     * Plugin information for update screen
     */
    public function plugin_info( $result, $action, $args ) {
        if ( $action !== 'plugin_information' ) {
            return $result;
        }
        
        if ( ! isset( $args->slug ) || $args->slug !== basename( dirname( __FILE__ ) ) ) {
            return $result;
        }
        
        // Get plugin info from our server
        $response = wp_remote_get( ITOMIC_COUNTDOWN_UPDATE_URL . 'info.json' );
        
        if ( is_wp_error( $response ) ) {
            return $result;
        }
        
        $body = wp_remote_retrieve_body( $response );
        $data = json_decode( $body, true );
        
        if ( ! $data ) {
            return $result;
        }
        
        return (object) $data;
    }

    /**
     * Auto-update plugin setting HTML
     */
    public function auto_update_setting_html( $html, $plugin_file ) {
        if ( $plugin_file !== plugin_basename( __FILE__ ) ) {
            return $html;
        }

        $checked = get_option( 'auto_update_plugin_' . $plugin_file, 'off' );
        $html = '<p>' . __( 'Automatically update this plugin to the latest version.', 'itomic-countdown' ) . '</p>';
        $html .= '<label for="auto_update_plugin_' . esc_attr( $plugin_file ) . '">';
        $html .= '<input type="checkbox" id="auto_update_plugin_' . esc_attr( $plugin_file ) . '" name="auto_update_plugin_' . esc_attr( $plugin_file ) . '" value="on" ' . checked( $checked, 'on', false ) . ' />';
        $html .= __( 'Enable automatic updates', 'itomic-countdown' ) . '</label>';
        return $html;
    }

    /**
     * Auto-update plugin filter
     */
    public function auto_update_plugin( $update, $item ) {
        if ( $item->slug === basename( dirname( __FILE__ ) ) ) {
            $auto_update = get_option( 'auto_update_plugin_' . $item->slug, 'off' );
            if ( $auto_update === 'on' ) {
                return true;
            }
        }
        return $update;
    }
}

// Initialize the plugin
new Itomic_Countdown_Plugin(); 