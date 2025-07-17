<?php
/**
 * Test class for Itomic Countdown Plugin
 */

class ItomicCountdownTest extends WP_UnitTestCase {

    /**
     * Test plugin initialization
     */
    public function test_plugin_initialization() {
        // Test that the plugin class exists
        $this->assertTrue( class_exists( 'Itomic_Countdown_Plugin' ) );
        
        // Test that plugin constants are defined
        $this->assertTrue( defined( 'ITOMIC_COUNTDOWN_VERSION' ) );
        $this->assertTrue( defined( 'ITOMIC_COUNTDOWN_PLUGIN_DIR' ) );
        $this->assertTrue( defined( 'ITOMIC_COUNTDOWN_PLUGIN_URL' ) );
    }

    /**
     * Test settings registration
     */
    public function test_settings_registration() {
        // Test that settings are properly registered
        $options = get_option( 'itomic_countdown_settings' );
        $this->assertIsArray( $options );
    }

    /**
     * Test timezone detection
     */
    public function test_timezone_detection() {
        // Create a mock plugin instance
        $plugin = new Itomic_Countdown_Plugin();
        
        // Use reflection to access private method
        $reflection = new ReflectionClass( $plugin );
        $method = $reflection->getMethod( 'get_default_timezone' );
        $method->setAccessible( true );
        
        $timezone = $method->invoke( $plugin );
        
        // Test that a valid timezone is returned
        $this->assertNotEmpty( $timezone );
        $this->assertTrue( in_array( $timezone, DateTimeZone::listIdentifiers() ) );
    }

    /**
     * Test settings sanitization
     */
    public function test_settings_sanitization() {
        // Create a mock plugin instance
        $plugin = new Itomic_Countdown_Plugin();
        
        // Use reflection to access private method
        $reflection = new ReflectionClass( $plugin );
        $method = $reflection->getMethod( 'sanitize_settings' );
        $method->setAccessible( true );
        
        // Test input sanitization
        $input = array(
            'event_title' => '<script>alert("xss")</script>Event',
            'event_date' => '2024-01-01T12:00',
            'timezone' => 'America/New_York',
            'display_position' => 'top-right'
        );
        
        $sanitized = $method->invoke( $plugin, $input );
        
        // Test that XSS is prevented
        $this->assertNotContains( '<script>', $sanitized['event_title'] );
        $this->assertEquals( 'Event', $sanitized['event_title'] );
        
        // Test that valid values are preserved
        $this->assertEquals( 'America/New_York', $sanitized['timezone'] );
        $this->assertEquals( 'top-right', $sanitized['display_position'] );
    }

    /**
     * Test invalid input handling
     */
    public function test_invalid_input_handling() {
        // Create a mock plugin instance
        $plugin = new Itomic_Countdown_Plugin();
        
        // Use reflection to access private method
        $reflection = new ReflectionClass( $plugin );
        $method = $reflection->getMethod( 'sanitize_settings' );
        $method->setAccessible( true );
        
        // Test invalid timezone
        $input = array(
            'timezone' => 'Invalid/Timezone',
            'display_position' => 'invalid-position'
        );
        
        $sanitized = $method->invoke( $plugin, $input );
        
        // Test that invalid values are replaced with defaults
        $this->assertEquals( 'UTC', $sanitized['timezone'] );
        $this->assertEquals( 'top-right', $sanitized['display_position'] );
    }
} 