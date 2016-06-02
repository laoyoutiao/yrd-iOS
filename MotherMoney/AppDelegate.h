//
//  AppDelegate.h
//  MotherMoney
//
//  Created by on 14-8-3.
//  Copyright (c) 2014年 ___FULLUSERNAME___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QMTabBarConfigure.h"
#import "QMTabBarController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, UIAlertViewDelegate, UITabBarControllerDelegate, UIWebViewDelegate>

@property (strong, nonatomic) UIWindow *window;

+ (AppDelegate *)appDelegate;
- (QMTabBarController *)rootViewController;

- (CGFloat)navigationBarAndStatusBarHeight;
- (CGFloat)navigationBarHeight;
- (CGFloat)statusBarHeight;

- (void)tryHideGesturePwdWindow:(BOOL)animated;

- (void)handleUserNotNotLoginError;

- (void)showAppStoreCommentAlertView;

@end
