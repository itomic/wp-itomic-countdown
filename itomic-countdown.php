<?php
/**
 * Plugin Name: Itomic Countdown
 * Plugin URI: https://www.itomic.com.au/itomic-countdown/
 * Description: Display a real-time countdown to any event on your WordPress site.
 * Version: 1.0.10
 * Author: Itomic
 * Author URI: https://www.itomic.com.au/
 * Developer: Itomic
 * Developer URI: https://www.itomic.com.au/
 * Text Domain: itomic-countdown
 * Domain Path: /languages
 * License: GNU General Public License v3.0
 * License URI: http://www.gnu.org/licenses/gpl-3.0.html
 * Requires at least: 5.0
 * Tested up to: 6.8
 * Requires PHP: 7.4
 * Update URI: https://github.com/itomic/wp-itomic-countdown
 *
 * @package Itomic_Countdown
 */

// Prevent direct access.
if ( ! defined( 'ABSPATH' ) ) {
	exit; // Exit if accessed directly.
}

// Define plugin constants.
define( 'ITOMIC_COUNTDOWN_VERSION', '1.0.10' );
define( 'ITOMIC_COUNTDOWN_PLUGIN_DIR', plugin_dir_path( __FILE__ ) );
define( 'ITOMIC_COUNTDOWN_PLUGIN_URL', plugin_dir_url( __FILE__ ) );

// Load the updater class (only for self-hosted installations, not WordPress.org)
// WordPress.org plugins must use the built-in update system
if ( file_exists( plugin_dir_path( __FILE__ ) . 'includes/class-plugin-updater.php' ) ) {
	require_once plugin_dir_path( __FILE__ ) . 'includes/class-plugin-updater.php';
}

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
			/* translators: Page title for the admin settings page */
			__( 'Itomic Countdown Settings', 'itomic-countdown' ),
			/* translators: Menu title in WordPress admin */
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
		register_setting(
			'itomic_countdown_options',
			'itomic_countdown_settings',
			array(
				'sanitize_callback' => array( $this, 'sanitize_settings' ),
			)
		);

		add_settings_section(
			'itomic_countdown_main',
			/* translators: Settings section title for countdown configuration */
			__( 'Countdown Settings', 'itomic-countdown' ),
			array( $this, 'settings_section_callback' ),
			'itomic-countdown'
		);

		add_settings_field(
			'event_title',
			/* translators: Label for the event title input field */
			__( 'Event Title', 'itomic-countdown' ),
			array( $this, 'event_title_callback' ),
			'itomic-countdown',
			'itomic_countdown_main'
		);

		add_settings_field(
			'event_date',
			/* translators: Label for the event date and time input field */
			__( 'Event Date & Time', 'itomic-countdown' ),
			array( $this, 'event_date_callback' ),
			'itomic-countdown',
			'itomic_countdown_main'
		);

		add_settings_field(
			'timezone',
			/* translators: Label for the timezone selection field */
			__( 'Timezone', 'itomic-countdown' ),
			array( $this, 'timezone_callback' ),
			'itomic-countdown',
			'itomic_countdown_main'
		);

		add_settings_field(
			'display_position',
			/* translators: Label for the display position selection field */
			__( 'Display Position', 'itomic-countdown' ),
			array( $this, 'display_position_callback' ),
			'itomic-countdown',
			'itomic_countdown_main'
		);
	}

	/**
	 * Sanitize settings
	 *
	 * @param array $input The input array to sanitize.
	 * @return array Sanitized settings array.
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
			$timezones             = DateTimeZone::listIdentifiers();
			$sanitized['timezone'] = in_array( $input['timezone'], $timezones, true ) ? sanitize_text_field( $input['timezone'] ) : 'UTC';
		}

		if ( isset( $input['display_position'] ) ) {
			$valid_positions               = array( 'top-left', 'top-middle', 'top-right', 'middle-left', 'middle-middle', 'middle-right', 'bottom-left', 'bottom-middle', 'bottom-right' );
			$sanitized['display_position'] = in_array( $input['display_position'], $valid_positions, true ) ? sanitize_text_field( $input['display_position'] ) : 'top-right';
		}

		return $sanitized;
	}

	/**
	 * Settings section callback
	 */
	public function settings_section_callback() {
		echo '<p>' . esc_html__( 'Configure your countdown display settings below.', 'itomic-countdown' ) . '</p>';
	}

	/**
	 * Event title field callback
	 */
	public function event_title_callback() {
		$options = get_option( 'itomic_countdown_settings' );
		$value   = isset( $options['event_title'] ) ? $options['event_title'] : '';
		echo '<input type="text" id="event_title" name="itomic_countdown_settings[event_title]" value="' . esc_attr( $value ) . '" class="regular-text" />';
		/* translators: Help text for the event title field */
		echo '<p class="description">' . esc_html__( 'Enter the title of your event (e.g., "New Year 2025")', 'itomic-countdown' ) . '</p>';
	}

	/**
	 * Event date field callback
	 */
	public function event_date_callback() {
		$options = get_option( 'itomic_countdown_settings' );
		$value   = isset( $options['event_date'] ) ? $options['event_date'] : '';
		echo '<input type="datetime-local" id="event_date" name="itomic_countdown_settings[event_date]" value="' . esc_attr( $value ) . '" />';
		/* translators: Help text for the event date and time field */
		echo '<p class="description">' . esc_html__( 'Select the date and time of your event', 'itomic-countdown' ) . '</p>';
	}

	/**
	 * Get default timezone for the user/server
	 * Attempts to detect the most appropriate timezone
	 *
	 * @return string The detected timezone or UTC as fallback.
	 */
	private function get_default_timezone() {
		// First, try to get the server's timezone.
		$server_timezone = date_default_timezone_get();

		// If server timezone is valid and not UTC, use it.
		if ( 'UTC' !== $server_timezone && $server_timezone && in_array( $server_timezone, DateTimeZone::listIdentifiers(), true ) ) {
			return $server_timezone;
		}

		// Try to get timezone from WordPress settings.
		$wp_timezone = get_option( 'timezone_string' );
		if ( $wp_timezone && in_array( $wp_timezone, DateTimeZone::listIdentifiers(), true ) ) {
			return $wp_timezone;
		}

		// Try to get timezone from WordPress offset.
		$wp_offset = get_option( 'gmt_offset' );
		if ( false !== $wp_offset ) {
			// Convert offset to timezone.
			$offset_hours   = intval( $wp_offset );
			$offset_minutes = abs( ( $wp_offset - $offset_hours ) * 60 );
			$offset_string  = sprintf( '%+03d:%02d', $offset_hours, $offset_minutes );

			// Find a timezone that matches this offset.
			$timezones = DateTimeZone::listIdentifiers();
			foreach ( $timezones as $timezone ) {
				try {
					$tz     = new DateTimeZone( $timezone );
					$date   = new DateTime( 'now', $tz );
					$offset = $date->format( 'P' );
					if ( $offset === $offset_string ) {
						return $timezone;
					}
				} catch ( Exception $e ) {
					continue;
				}
			}
		}

		// Fallback to UTC if nothing else works.
		return 'UTC';
	}

	/**
	 * Timezone field callback
	 */
	public function timezone_callback() {
		$options = get_option( 'itomic_countdown_settings' );
		$value   = isset( $options['timezone'] ) ? $options['timezone'] : $this->get_default_timezone();

		$timezones = DateTimeZone::listIdentifiers();
		echo '<select id="timezone" name="itomic_countdown_settings[timezone]">';
		foreach ( $timezones as $timezone ) {
			$selected = ( $timezone === $value ) ? 'selected' : '';
			echo '<option value="' . esc_attr( $timezone ) . '" ' . esc_attr( $selected ) . '>' . esc_html( $timezone ) . '</option>';
		}
		echo '</select>';
		/* translators: Help text for the timezone field */
		echo '<p class="description">' . esc_html__( 'Select the timezone for your event. Default is automatically detected from your server/WordPress settings.', 'itomic-countdown' ) . '</p>';
	}

	/**
	 * Display position field callback
	 */
	public function display_position_callback() {
		$options = get_option( 'itomic_countdown_settings' );
		$value   = isset( $options['display_position'] ) ? $options['display_position'] : 'top-right';

		$positions = array(
			/* translators: Display position option for countdown - top left corner */
			'top-left'      => __( 'Top Left', 'itomic-countdown' ),
			/* translators: Display position option for countdown - top center */
			'top-middle'    => __( 'Top Middle', 'itomic-countdown' ),
			/* translators: Display position option for countdown - top right corner */
			'top-right'     => __( 'Top Right', 'itomic-countdown' ),
			/* translators: Display position option for countdown - middle left side */
			'middle-left'   => __( 'Middle Left', 'itomic-countdown' ),
			/* translators: Display position option for countdown - center of screen */
			'middle-middle' => __( 'Middle Middle', 'itomic-countdown' ),
			/* translators: Display position option for countdown - middle right side */
			'middle-right'  => __( 'Middle Right', 'itomic-countdown' ),
			/* translators: Display position option for countdown - bottom left corner */
			'bottom-left'   => __( 'Bottom Left', 'itomic-countdown' ),
			/* translators: Display position option for countdown - bottom center */
			'bottom-middle' => __( 'Bottom Middle', 'itomic-countdown' ),
			/* translators: Display position option for countdown - bottom right corner */
			'bottom-right'  => __( 'Bottom Right', 'itomic-countdown' ),
		);

		echo '<select id="display_position" name="itomic_countdown_settings[display_position]">';
		foreach ( $positions as $key => $label ) {
			$selected = ( $key === $value ) ? 'selected' : '';
			echo '<option value="' . esc_attr( $key ) . '" ' . esc_attr( $selected ) . '>' . esc_html( $label ) . '</option>';
		}
		echo '</select>';
		/* translators: Help text for the display position field */
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
	 *
	 * @param array $links Existing plugin action links.
	 * @return array Modified plugin action links.
	 */
	public function add_settings_link( $links ) {
		/* translators: Link text for plugin settings page */
		$settings_link = '<a href="' . esc_url( admin_url( 'options-general.php?page=itomic-countdown' ) ) . '">' . __( 'Settings', 'itomic-countdown' ) . '</a>';
		array_unshift( $links, $settings_link );
		return $links;
	}

	/**
	 * Enqueue scripts and styles
	 */
	public function enqueue_scripts() {
		wp_enqueue_script( 'itomic-countdown', ITOMIC_COUNTDOWN_PLUGIN_URL . 'assets/js/countdown.js', array( 'jquery' ), ITOMIC_COUNTDOWN_VERSION, true );
		wp_enqueue_style( 'itomic-countdown', ITOMIC_COUNTDOWN_PLUGIN_URL . 'assets/css/countdown.css', array(), ITOMIC_COUNTDOWN_VERSION );

		// Pass data to JavaScript.
		$options = get_option( 'itomic_countdown_settings' );

		wp_localize_script(
			'itomic-countdown',
			'itomicCountdownData',
			array(
				'eventDate' => isset( $options['event_date'] ) ? $options['event_date'] : '',
				'timezone'  => isset( $options['timezone'] ) ? $options['timezone'] : 'UTC',
				'position'  => isset( $options['display_position'] ) ? $options['display_position'] : 'top-right',
			)
		);
	}

	/**
	 * Display countdown in footer
	 */
	public function display_countdown() {
		$options = get_option( 'itomic_countdown_settings' );

		if ( empty( $options['event_date'] ) ) {
			return;
		}

		/* translators: Default event title when none is specified */
		$event_title = isset( $options['event_title'] ) ? $options['event_title'] : __( 'Event', 'itomic-countdown' );
		$position    = isset( $options['display_position'] ) ? $options['display_position'] : 'top-right';

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
	 * Plugin activation hook
	 */
	public static function activate() {
		// Set default options if they don't exist.
		if ( ! get_option( 'itomic_countdown_settings' ) ) {
			add_option( 'itomic_countdown_settings', array() );
		}

		// Set activation flag to track successful activation.
		update_option( 'itomic_countdown_activated', true );
	}

	/**
	 * Plugin deactivation hook
	 */
	public static function deactivate() {
		// Clean up transients but keep settings.
		delete_transient( 'itomic_countdown_cache' );
		delete_option( 'itomic_countdown_activated' );
	}
}

// Register activation and deactivation hooks.
register_activation_hook( __FILE__, array( 'Itomic_Countdown_Plugin', 'activate' ) );
register_deactivation_hook( __FILE__, array( 'Itomic_Countdown_Plugin', 'deactivate' ) );

// Initialize the plugin.
new Itomic_Countdown_Plugin();

// Initialize the updater (only for self-hosted installations, NOT for WordPress.org)
// WordPress.org plugins use the built-in update system and should not include this file
// The Update URI header tells WordPress this is a self-hosted plugin
if ( is_admin() && class_exists( 'Itomic_Countdown_Updater' ) ) {
	// Only initialize updater if Update URI is set (indicates self-hosted)
	// This prevents warnings in Plugin Check tool for WordPress.org submissions
	$plugin_data = get_file_data( __FILE__, array( 'UpdateURI' => 'Update URI' ) );
	
	// If Update URI is set and points to GitHub (not wordpress.org), use custom updater
	if ( ! empty( $plugin_data['UpdateURI'] ) && strpos( $plugin_data['UpdateURI'], 'wordpress.org' ) === false ) {
		// Check if we should use pre-releases (for testing/develop branch)
		// Set ITOMIC_COUNTDOWN_CHECK_PRERELEASES constant to true in wp-config.php for testing
		$check_prereleases = defined( 'ITOMIC_COUNTDOWN_CHECK_PRERELEASES' ) && ITOMIC_COUNTDOWN_CHECK_PRERELEASES;
		
		$updater = new Itomic_Countdown_Updater(
			__FILE__,
			'itomic/wp-itomic-countdown',  // GitHub repository: username/repo
			$check_prereleases              // Check for pre-releases if constant is set
		);
		
		// Opt into WordPress auto-updates (WordPress 5.5+)
		// This allows users to enable auto-updates from the Plugins page
		add_filter(
			'auto_update_plugin',
			function( $update, $item ) {
				// Only auto-update this specific plugin
				if ( isset( $item->plugin ) && $item->plugin === plugin_basename( __FILE__ ) ) {
					return true; // Allow auto-updates (user can still disable per-plugin)
				}
				return $update;
			},
			10,
			2
		);
	}
}
