<p align="center">
  <img src="icon.png" width="200" alt="ChatGPTLoginFix Icon">
</p>

## Description
**ChatGPTLoginFix** adds a share sheet option to paste a ChatGPT session token (obtained from the `__Secure-next-auth.session-token` cookie in your browser's developer tools), enabling logging into ChatGPT in Safari on older iOS versions.

---

## 🔑 Login Instructions

### 1. Using Desktop Chrome

1. Open https://chat.openai.com and sign in.  
2. Click the ⋮ menu (top-right) → More tools → Developer tools  
   (or press Ctrl + Shift + I on Windows/Linux, ⌘ + Option + I on Mac).  
3. In Developer Tools, go to the **Application** tab → Storage → Cookies → https://chatgpt.com.  
4. Locate the cookie named `__Secure-next-auth.session-token`.  
5. Copy the **Value** field to your device.  

### 2. Using Desktop Firefox

1. Open https://chat.openai.com and sign in.  
2. Click the ☰ menu (top-right) → More Tools → Web Developer Tools → Storage.  
3. In Developer Tools, go to the **Storage** tab, expand **Cookies** → https://chatgpt.com.  
4. Locate the cookie named `__Secure-next-auth.session-token`.  
5. Copy the **Value** field to your device.  

### On Your iOS Device

1. Open Safari, go to https://chatgpt.com/ and bring up the share sheet.  
2. Select **Paste ChatGPT Cookie**.  
3. Paste your token.  
4. Tap **Inject**.  
5. Reload Safari — you should have now logged into your ChatGPT account.

## License
MIT License
