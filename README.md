# ChatGPTLoginFix

## Description
**ChatGPTLoginFix** adds a share sheet option to paste a ChatGPT session token (obtained from the `__Secure-next-auth.session-token` cookie in your browser's developer tools), enabling logging into ChatGPT in Safari on older iOS versions.

## Installation
1. Ensure your device is jailbroken.
2. Add the tweak's repository to your package manager (e.g., Cydia, Sileo).
3. Install **ChatGPTLoginFix**.
4. Respring your device.

## Usage
1. Open the share sheet in Safari.
2. Select **Paste ChatGPT Cookie**.
3. Paste the `__Secure-next-auth.session-token` value from your browser's developer tools.
4. Tap **Inject** to set the cookie and enable login.

## Requirements
- Jailbroken iOS device
- Safari browser
- iOS version supporting share sheets

## Notes
- The tweak injects the cookie into both `NSHTTPCookieStorage` and WebKit's `WKWebsiteDataStore` for seamless authentication.
- Ensure the session token is valid and correctly copied from your browser.

## License
MIT License