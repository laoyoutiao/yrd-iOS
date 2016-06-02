//
//  QMFrameUtil.m
//  MotherMoney

//

#import "QMFrameUtil.h"

#define PUSH_NOTIFICATION_KEY @"push_url"

#define PREFERENCE_WELCOM_PAGE_HAS_SHOWN_KEY @"WELCOME_PAGE_HAS_SHOWN_V1.4.2"

@implementation QMFrameUtil {
    NSDictionary *pushInfo;
}
//创建单例
+ (QMFrameUtil *)sharedInstance {
    static QMFrameUtil *sharedInstance_ = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance_ = [[QMFrameUtil alloc] init];
    });
    
    return sharedInstance_;
}

+ (BOOL)hasShownWelcomPage {
    //返回boolKey，YES or NO
    return [QMPreferenceUtil getGlobalBoolKey:PREFERENCE_WELCOM_PAGE_HAS_SHOWN_KEY];
}

+ (void)setHasShownWelcomepage {
    [QMPreferenceUtil setGlobalBoolKey:PREFERENCE_WELCOM_PAGE_HAS_SHOWN_KEY value:YES syncWrite:YES];
}

+ (BOOL)hasGesturePassword {
    return [[QMAccountUtil sharedInstance] isUserUsingRectPwd];
}

- (void)parsePush:(NSDictionary *)dict {
    NSDictionary *remoteNotification = dict;
    if (!QM_IS_DICT_NIL(remoteNotification)) {
        NSString *pushValue = [remoteNotification objectForKey:PUSH_NOTIFICATION_KEY];
        if (!QM_IS_STR_NIL(pushValue)) {
            UIApplicationState appState = [[UIApplication sharedApplication] applicationState];
            if (appState == UIApplicationStateActive) {
                NSString *message = [[remoteNotification objectForKey:@"aps"] objectForKey:@"alert"];
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"新消息"
                                                                    message:message
                                                                   delegate:self
                                                          cancelButtonTitle:QMLocalizedString(@"qm_alertview_cancel_title", @"取消")
                                                          otherButtonTitles:QMLocalizedString(@"qm_alertview_ok_title", @"确定"), nil];
                pushInfo = [NSDictionary dictionaryWithDictionary:remoteNotification];
                [alertView show];
            }else {
                NSURLRequest *request1 = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:pushValue]];
                [self openWebViewControllerWithRequest:request1];
            }
        }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        NSString *pushValue = [pushInfo objectForKey:PUSH_NOTIFICATION_KEY];
        NSURLRequest *request1 = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:pushValue]];
        [self openWebViewControllerWithRequest:request1];
        pushInfo = nil;
    }
}

- (void)openWebViewControllerWithRequest:(NSURLRequest *)urlRequest {
    if (nil == urlRequest) {
        return;
    }
    
    QMWebViewController *con = [[QMWebViewController alloc] init];
    con.request = urlRequest;
    con.isModel = YES;
    QMNavigationController *nav = [[QMNavigationController alloc] initWithRootViewController:con];
    [[AppDelegate appDelegate].window.rootViewController presentViewController:nav animated:YES completion:^{
        
    }];
}


@end
