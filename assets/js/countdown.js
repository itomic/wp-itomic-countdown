/**
 * Itomic Countdown JavaScript
 * Handles real-time countdown display
 */
(function($) {
    'use strict';
    
    console.log('Itomic Countdown: Script loaded');
    
    // Check if countdown data is available
    if (typeof itomicCountdownData === 'undefined') {
        console.error('Itomic Countdown: itomicCountdownData is undefined');
        return;
    }
    
    console.log('Itomic Countdown: Data received:', itomicCountdownData);
    
    var countdownTimer;
    var eventDate = itomicCountdownData.eventDate;
    var timezone = itomicCountdownData.timezone;
    
    // Initialize countdown
    function initCountdown() {
        console.log('Itomic Countdown: Initializing countdown');
        
        if (!eventDate) {
            console.error('Itomic Countdown: No event date provided');
            return;
        }
        
        // Parse the event date
        var targetDate = new Date(eventDate);
        
        // Check if date is valid
        if (isNaN(targetDate.getTime())) {
            console.error('Itomic Countdown: Invalid event date:', eventDate);
            return;
        }
        
        console.log('Itomic Countdown: Target date parsed:', targetDate);
        
        // Start the countdown
        updateCountdown(targetDate);
        countdownTimer = setInterval(function() {
            updateCountdown(targetDate);
        }, 1000);
    }
    
    // Update countdown display
    function updateCountdown(targetDate) {
        var now = new Date();
        var timeLeft = targetDate.getTime() - now.getTime();
        
        // Check if countdown has ended
        if (timeLeft <= 0) {
            clearInterval(countdownTimer);
            $('#countdown-timer').html('<span class="countdown-ended">Event has started!</span>');
            return;
        }
        
        // Calculate time units
        var days = Math.floor(timeLeft / (1000 * 60 * 60 * 24));
        var hours = Math.floor((timeLeft % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60));
        var minutes = Math.floor((timeLeft % (1000 * 60 * 60)) / (1000 * 60));
        var seconds = Math.floor((timeLeft % (1000 * 60)) / 1000);
        
        // Update display
        $('#countdown-timer .days').text(days);
        $('#countdown-timer .hours').text(hours.toString().padStart(2, '0'));
        $('#countdown-timer .minutes').text(minutes.toString().padStart(2, '0'));
        $('#countdown-timer .seconds').text(seconds.toString().padStart(2, '0'));
    }
    
    // Initialize when document is ready
    $(document).ready(function() {
        console.log('Itomic Countdown: Document ready, checking for countdown element');
        if ($('#itomic-countdown').length) {
            console.log('Itomic Countdown: Found countdown element, initializing');
            initCountdown();
        } else {
            console.error('Itomic Countdown: Countdown element not found in DOM');
        }
    });
    
    // Clean up on page unload
    $(window).on('beforeunload', function() {
        if (countdownTimer) {
            clearInterval(countdownTimer);
        }
    });
    
})(jQuery); 