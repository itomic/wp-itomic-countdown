# Itomic Countdown Plugin - Installation Guide

## Quick Installation

1. **Download the plugin files**
   - All files should be in a folder named `itomic-countdown`
   - The main plugin file is `itomic-countdown.php`

2. **Upload to WordPress**
   - Upload the entire `itomic-countdown` folder to `/wp-content/plugins/`
   - Or zip the folder and upload via WordPress admin

3. **Activate the plugin**
   - Go to WordPress Admin → Plugins
   - Find "Itomic Countdown" and click "Activate"

4. **Configure your countdown**
   - Go to Settings → Itomic Countdown
   - Enter your event title
   - Select event date and time
   - Choose timezone
   - Select display position
   - Click "Save Changes"

5. **View your countdown**
   - Visit your website's frontend
   - The countdown will appear in your chosen position

## File Structure

```
itomic-countdown/
├── itomic-countdown.php     # Main plugin file
├── readme.txt              # WordPress plugin readme
├── uninstall.php           # Cleanup when deleted
├── INSTALLATION.md         # This file
├── assets/
│   ├── css/
│   │   └── countdown.css   # Styles for countdown display
│   └── js/
│       └── countdown.js    # JavaScript for countdown logic
└── languages/              # Translation files (empty for now)
```

## Features

- ✅ Real-time countdown updates every second
- ✅ 9 display position options
- ✅ Full timezone support
- ✅ Responsive design for mobile/desktop
- ✅ Modern, accessible styling
- ✅ Easy admin configuration
- ✅ WordPress coding standards compliant

## Troubleshooting

**Countdown not showing?**
- Check that you've set an event date in Settings → Itomic Countdown
- Ensure the plugin is activated
- Check browser console for JavaScript errors

**Countdown in wrong timezone?**
- Verify your timezone selection in the plugin settings
- The countdown uses the browser's local time for display

**Styling issues?**
- The plugin uses modern CSS with backdrop-filter
- Some older browsers may not support all features
- The countdown will still function, just with reduced visual effects

## Support

For support or feature requests, please refer to the plugin documentation or contact Itomic at https://www.itomic.com.au/. 