//
//  deviceSize.h
//
//
//  Created by Rakib Rz on 23/7/2015.
//  Copyright (c) 2015 Rz. All rights reserved.
//
/*
    - - - - - Some useful information - - - - -

                wid x hei
iPhone 6 Plus   414 x 736 points  2208x1242 pixels    3x scale    1920x1080 physical pixels   401 physical ppi    5.5"
iPhone 6        375 x 667 points  1334x750 pixels     2x scale    1334x750 physical pixels    326 physical ppi    4.7"
iPhone 5        320 x 568 points  1136x640 pixels     2x scale    1136x640 physical pixels    326 physical ppi    4.0"
iPhone 4        320 x 480 points  960x640 pixels      2x scale    960x640 physical pixels     326 physical ppi    3.5"
iPhone 3GS      320 x 480 points  480x320 pixels      1x scale    480x320 physical pixels     163 physical ppi    3.5"

 */

// delegate
#define UIAppDelegate (AppDelegate *)[[UIApplication sharedApplication] delegate]
#define APPDELEGATE ((AppDelegate *)[[UIApplication sharedApplication] delegate])

// screen size
#define IsIpad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IsIPhone (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)

#define IsIphone_4 (IsIPhone && [[UIScreen mainScreen] bounds].size.height == 480.0)
#define IsIphone_5 (IsIPhone && [[UIScreen mainScreen] bounds].size.height == 568.0)
#define IsIphone_6 (IsIPhone && [[UIScreen mainScreen] bounds].size.height == 667.0)
#define IsIphone_6Plus (IsIPhone && [[UIScreen mainScreen] bounds].size.height == 736.0)
#define IsIphone_6Plus_Scale (IsIPhone && [[UIScreen mainScreen] nativeScale] == 3.0f)

#define ISRetina ([[UIScreen mainScreen] scale] == 2.0)
#define ISRetinaDisplay ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] && ([UIScreen mainScreen].scale == 2.0))

#define IsPortrait UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation])
#define IsLandscape UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation])

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

//system version
#define SYSTEM_VERSION_LESS_THAN(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_GREATER_THAN(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)

// math
#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)
#define RADIANS_TO_DEGREES(radians) ((radians) * (180.0 / M_PI))

// cores
#define RGB(r,g,b)    [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]
#define RGBA(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a]
#define MAKECOLOR(R, G, B, A) [UIColor colorWithRed:((float)R/255.0f) green:((float)G/255.0f) blue:((float)B/255.0f) alpha:A]
#define MAKECOLORFROMHEX(hexValue) [UIColor colorWithRed: ((float)((hexValue & 0xFF0000) >> 16))/255.0 green:((float)((hexValue & 0xFF00) >> 8))/255.0 blue:((float)(hexValue & 0xFF))/255.0 alpha:1.0]

//customizations
#define SHOW_STATUS_BAR [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
#define HIDE_STATUS_BAR [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];

#define SHOW_NAVIGATION_BAR [self.navigationController setNavigationBarHidden:FALSE];
#define HIDE_NAVIGATION_BAR [self.navigationController setNavigationBarHidden:TRUE];

#define VC_OBJ(x) [[x alloc] init]
#define VC_OBJ_WITH_NIB(x) [[x alloc] initWithNibName : (NSString *)CFSTR(#x) bundle : nil]

#define RESIGN_KEYBOARD [[[UIApplication sharedApplication] keyWindow] endEditing:YES];

#define CLEAR_NOTIFICATION_BADGE [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
#define REGISTER_APPLICATION_FOR_NOTIFICATION_SERVICE [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)]

#define HIDE_NETWORK_ACTIVITY_INDICATOR [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
#define SHOW_NETWORK_ACTIVITY_INDICATOR [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
