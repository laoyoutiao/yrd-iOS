//
//  AppDelegate.m
//  MotherMoney
//
//  Created by on 14-8-3.
//  Copyright (c) 2014年 ___FULLUSERNAME___. All rights reserved.
//

#import "AppDelegate.h"
#import "SVProgressHUD.h"
#import "QMGestureWindow.h"
#import "UMessage.h"
#import "QMWebViewController.h"
#import "QMFrameUtil.h"
#import "QMWelcomeViewController.h"
#import "QMUMTookKitManager.h"
#import "BlockAlertView.h"
#import "QMMSplashViewController.h"
#import "NetServiceManager.h"
#import "QMTokenInfo.h"


#define SHOW_RECT_PWD_MIN_TIME_INTERVAL 30

@implementation AppDelegate {
    QMGestureWindow *gesWindow;
    NSDictionary *pushUserInfo;
    NSDate *appEnterBackgroundTime;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [NSThread sleepForTimeInterval:2.0];
    if (![QMFrameUtil hasShownWelcomPage]) {
        // 第一次使用app，需要清除LockBox中的设置
        [[QMAccountUtil sharedInstance] clearCurrentAccountInfo];
    }
    // log configuration
    [QMLogUtil startLog];
    
    [self customizeAppearance];
    // Override point for customization after application launch.
    UIWindow *window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    window.backgroundColor = [UIColor whiteColor];
    self.window = window;
    
    // configure tabs
    QMTabBarController *tabbarController = [QMTabBarConfigure configuredTabBarController];
    tabbarController.delegate = self;
    self.window.rootViewController = tabbarController;
    [self.window makeKeyAndVisible];
    
    
//    QMTestImageViewViewController *testview = [[QMTestImageViewViewController alloc] init];
//    self.window.rootViewController = testview;
//    [self.window makeKeyAndVisible];
    

    // register notification
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleWindowDidBecomeKeyNotification:)
                                                 name:UIWindowDidBecomeKeyNotification
                                               object:nil];
    [self configureUMMessageInfo:launchOptions];
    [self configClickTag];
    
    [[QMFrameUtil sharedInstance] parsePush:[launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey]];
    
    [self handleAppDidFinishLaunching];
    
    if (![QMFrameUtil hasShownWelcomPage]) {
        QMWelcomeViewController *con = [[QMWelcomeViewController alloc] initWithStart:YES];
        [self.window.rootViewController presentViewController:con animated:YES completion:nil];
    }
    
    [QMUMTookKitManager UMShareConfigure:nil];
    
    
//    NSString *bundleID = [[[NSBundle bundleForClass:[self class]] infoDictionary] objectForKey:(NSString*)kCFBundleIdentifierKey];
//    [[VENTouchLock sharedInstance] setKeychainService:bundleID
//                                      keychainAccount:bundleID
//                                        touchIDReason:@"通过Home键验证已有手机指纹"
//                                 passcodeAttemptLimit:5
//                            splashViewControllerClass:[QMMSplashViewController class]];
    
    return YES;
}

- (void)handleAppDidFinishLaunching {
    // 获取用户的信息
    QMAccountInfo *account = [[QMAccountUtil sharedInstance] currentAccount];
    // 用户已经登录，并且在使用手势密码
    if (account.isLogin && account.isUsingRecPwd) {
        
        
        
        [self tryShowGesturePwdWindow];
    }else if ([QMFrameUtil hasShownWelcomPage]) { // 已经显示过欢迎页，直接显示登录界面
        
        
//        [QMLoginManagerUtil showLoginViewControllerFromViewController:self.window.rootViewController];
    }
}

-(void)configClickTag {
    [MobClick startWithAppkey:UMKey reportPolicy:BATCH channelId:AppChannel];
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [MobClick setAppVersion:version];
    [MobClick setLogEnabled:NO];
    [MobClick updateOnlineConfig];
}


- (void)configureUMMessageInfo:(NSDictionary *)options {
    //set AppKey and AppSecret
    [UMessage startWithAppkey:UMKey launchOptions:options];
    
    if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]) {
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil];
        
        [UMessage registerRemoteNotificationAndUserNotificationSettings:settings];
    }else {
        //register remoteNotification types (iOS 8.0以下)
        [UMessage registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge
         |UIRemoteNotificationTypeSound
         |UIRemoteNotificationTypeAlert];
    }
    
    //for log（optional）
    [UMessage setLogEnabled:NO];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    QMAccountInfo *account = [[QMAccountUtil sharedInstance] currentAccount];
    // 用户已经登录，并且在使用手势密码
    if (account.isLogin && account.isUsingRecPwd) {
        // 判断时间
        NSDate *curDate = [NSDate date];
        if ([curDate timeIntervalSinceDate:appEnterBackgroundTime] >= SHOW_RECT_PWD_MIN_TIME_INTERVAL) {
            [self tryShowGesturePwdWindow];
        }
    }
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    appEnterBackgroundTime = [NSDate date];
}

#pragma mark -
#pragma mark Public Methods
- (QMTabBarController *)rootViewController {
    QMTabBarController *tabBarController = (QMTabBarController *)self.window.rootViewController;
    if ([tabBarController isKindOfClass:[QMTabBarController class]]) {
        return tabBarController;
    }
    
    return nil;
}

- (CGFloat)navigationBarAndStatusBarHeight {
    return [self navigationBarHeight] + [self statusBarHeight];
}

- (CGFloat)navigationBarHeight {
    return 44.0f;
}

- (CGFloat)statusBarHeight {
    return CGRectGetHeight([UIApplication sharedApplication].statusBarFrame);
}

+ (AppDelegate *)appDelegate {
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if ([appDelegate isKindOfClass:[AppDelegate class]]) {
        return appDelegate;
    }
    
    return nil;
}

- (void)customizeAppearance {
    SVProgressHUD *progressHUDAppearanceProxy = [SVProgressHUD appearance];
    [progressHUDAppearanceProxy setHudForegroundColor:[UIColor colorWithWhite:0.8f alpha:1.0f]];
    [progressHUDAppearanceProxy setHudSuccessImage:[UIImage imageNamed:@"success.png"]];
    [progressHUDAppearanceProxy setHudErrorImage:[UIImage imageNamed:@"error.png"]];
    [progressHUDAppearanceProxy setHudBackgroundColor:[UIColor blackColor]];
    [progressHUDAppearanceProxy setHudFont:[UIFont systemFontOfSize:14]];
}

// push相关
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    NSLog(@"%@",deviceToken);

    [[QMTokenInfo sharedInstance] setMobileToken:deviceToken];
    
    [UMessage registerDeviceToken:deviceToken];
}


- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [UMessage didReceiveRemoteNotification:userInfo];
    
    [[QMFrameUtil sharedInstance] parsePush:userInfo];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return  [UMSocialSnsService handleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    return  [UMSocialSnsService handleOpenURL:url];
}

/////
#pragma mark - gesture
- (void)applicationWillResignActive:(UIApplication *)application {
    [self prepareGesturePwdWindow];
}

- (void)handleWindowDidBecomeKeyNotification:(NSNotification*)notification{
    UIWindow *curWindow = (UIWindow *)[notification object];
    if ([curWindow isKindOfClass:[UIWindow class]]) {
//        [self.window makeKeyAndVisible];
    }

    [gesWindow handleWindowDidBecomeKeyNotification:notification];
}

- (void)prepareGesturePwdWindow {
    if (gesWindow == nil) {
        gesWindow = [[QMGestureWindow alloc] initWithFrame:self.window.frame];
    }
    
    [gesWindow prepareGesturePwdWindow];
}

- (void)tryShowGesturePwdWindow{
    if (gesWindow == nil) {
        
        gesWindow = [[QMGestureWindow alloc] initWithFrame:self.window.frame];
    }
    
    [gesWindow tryShowGesturePwdWindow];
}

- (void)tryHideGesturePwdWindow:(BOOL)animated{
    if (gesWindow != nil) {
        
        
        [gesWindow tryHideGesturePwdWindow:animated];
        gesWindow = nil;
    }else{
        if (animated) {
            [self.window makeKeyAndVisible];
        }else{
            [self.window makeKeyWindow];
        }
    }
}

#pragma mark -
#pragma mark RDVTabBarDelegate
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    
    if (viewController == [[tabBarController viewControllers] objectAtIndex:2] && ![[QMAccountUtil sharedInstance] userHasLogin]) {
        [QMLoginManagerUtil showLoginViewControllerFromViewController:tabBarController.selectedViewController];
        return NO;
    }
    
    return YES;
}

- (void)handleUserNotNotLoginError {
    if ([QMFrameUtil hasGesturePassword]) {
        // 有手势密码
        [self tryShowGesturePwdWindow];
    }else {
        [QMLoginManagerUtil showLoginViewControllerFromViewController:self.window.rootViewController];
    }
}

- (void)showAppStoreCommentAlertView {
    BlockAlertView *alertView = [[BlockAlertView alloc] initWithTitle:QMLocalizedString(@"qm_app_title_text", @"粤融贷") message:QMLocalizedString(@"qm_app_comment_text", @"感谢您使用粤融贷理财APP,\n如果喜欢我们,就鼓励一下吧")];
    __weak typeof(self)weakSelf = self;
    [alertView addButtonWithTitle:QMLocalizedString(@"qm_app_comment_refuse_title", @"下次再说") color:QM_THEME_COLOR block:^{
        
    }];

    [alertView addButtonWithTitle:QMLocalizedString(@"qm_app_comment_confirm_title", @"五星鼓励") color:QM_THEME_COLOR block:^{
        [weakSelf gotoAppStoreAndComment];
    }];
    [alertView show];
}

- (void)gotoAppStoreAndComment {
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=%@&pageNumber=0&sortOrdering=2&type=Purple+Software&mt=8", kAppId]]];
}

@end
