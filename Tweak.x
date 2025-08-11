#import <UIKit/UIKit.h>
#import <WebKit/WKWebsiteDataStore.h>
#import <WebKit/WKHTTPCookieStore.h>
#import <AudioToolbox/AudioToolbox.h>

@interface CustomActivity : UIActivity
@end

@implementation CustomActivity

- (NSString *)activityType {
    return @"com.korboy.chatgptloginfix";
}

- (NSString *)activityTitle {
    return @"Paste ChatGPT Cookie";
}

- (UIImage *)activityImage {
    return [UIImage systemImageNamed:@"key"];
}

- (BOOL)canPerformWithActivityItems:(NSArray *)activityItems {
    return YES;
}

- (void)performActivity {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Paste ChatGPT Session Token"
                                                                   message:@"Paste only the session token value:"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Paste your cookie here";
        textField.autocorrectionType = UITextAutocorrectionTypeNo;
        textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    }];
    
    UIAlertAction *injectAction = [UIAlertAction actionWithTitle:@"Inject"
                                                        style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction *action) {
        NSString *token = alert.textFields.firstObject.text ?: @"";
        
        if (token.length < 3000) {
            [self showPopupWithTitle:@"Error" message:@"Cookie too short. Please paste the full token."];
            [self triggerHaptic:NO];
            [self activityDidFinish:NO];
            return;
        }
        
        NSUInteger dotCount = [[token componentsSeparatedByString:@"."] count] - 1;
        if (dotCount < 2) {
            [self showPopupWithTitle:@"Error" message:@"Invalid token format."];
            [self triggerHaptic:NO];
            [self activityDidFinish:NO];
            return;
        }
        
        NSString *cookieString = [NSString stringWithFormat:
                                @"__Secure-next-auth.session-token=%@; Domain=.chatgpt.com; Path=/; Secure; HttpOnly; SameSite=Lax; Max-Age=31536000",
                                token];
        NSDictionary *headers = @{@"Set-Cookie": cookieString};
        NSURL *url = [NSURL URLWithString:@"https://chatgpt.com/"];
        NSArray *cookies = [NSHTTPCookie cookiesWithResponseHeaderFields:headers forURL:url];
        NSHTTPCookie *cookie = cookies.firstObject;
        
        if (cookie) {
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
            
            WKWebsiteDataStore *dataStore = [WKWebsiteDataStore defaultDataStore];
            if (dataStore) {
                [[dataStore httpCookieStore] setCookie:cookie completionHandler:^{
                    [self triggerHaptic:YES];
                    [self showPopupWithTitle:@"Success" message:@"Cookie injected successfully."];
                    
                    // Delay 2 seconds then open ChatGPT in Safari
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        NSURL *refreshURL = [NSURL URLWithString:@"https://chatgpt.com/."];
                        [[UIApplication sharedApplication] openURL:refreshURL options:@{} completionHandler:nil];
                    });
                }];
            } else {
                [self triggerHaptic:NO];
                [self showPopupWithTitle:@"Error" message:@"Failed to access WKWebView cookie store."];
            }
        } else {
            [self triggerHaptic:NO];
            [self showPopupWithTitle:@"Error" message:@"Failed to create cookie."];
        }
        
        [self activityDidFinish:YES];
    }];

    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                           style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction *action) {
        [self activityDidFinish:NO];
    }];
    
    [alert addAction:injectAction];
    [alert addAction:cancelAction];
    
    UIWindow *keyWindow = nil;
    for (UIWindow *window in [UIApplication sharedApplication].windows) {
        if (window.isKeyWindow) {
            keyWindow = window;
            break;
        }
    }
    UIViewController *topVC = keyWindow.rootViewController;
    while (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
    }
    [topVC presentViewController:alert animated:YES completion:nil];
}

- (void)triggerHaptic:(BOOL)success {
    if (success) {
        AudioServicesPlaySystemSound(1519); // Light tap
    } else {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    }
}

- (void)showPopupWithTitle:(NSString *)title message:(NSString *)message {
    UIAlertController *popup = [UIAlertController alertControllerWithTitle:title
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [popup addAction:ok];
    
    UIWindow *keyWindow = nil;
    for (UIWindow *window in [UIApplication sharedApplication].windows) {
        if (window.isKeyWindow) {
            keyWindow = window;
            break;
        }
    }
    UIViewController *topVC = keyWindow.rootViewController;
    while (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
    }
    [topVC presentViewController:popup animated:YES completion:nil];
}

@end

%hook UIActivityViewController

- (id)initWithActivityItems:(NSArray *)activityItems applicationActivities:(NSArray *)applicationActivities {
    NSMutableArray *newActivities = [applicationActivities mutableCopy] ?: [NSMutableArray array];
    CustomActivity *custom = [[CustomActivity alloc] init];
    [newActivities addObject:custom];
    return %orig(activityItems, newActivities);
}

%end
