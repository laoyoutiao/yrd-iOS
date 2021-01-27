//
//  AlertMessageShow.m
//  GovernmentEnterprises
//
//  Created by cgt cgt on 2016/12/9.
//  Copyright © 2016年 uones. All rights reserved.
//

#import "AlertMessageShow.h"

@implementation AlertMessageShow

+ (void)showAlertViewOnlyChoiceWithTitle:(NSString *)title Message:(NSString *)message
{
    UIViewController *viewcontroller = [self getCurrentVC];
    UIAlertController *alertviewcontroller = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
    [alertviewcontroller addAction:cancelAction];
    [viewcontroller presentViewController:alertviewcontroller animated:YES completion:nil];
}

+ (UIAlertAction *)showActionTitle:(NSString *)title handler:(void (^)(UIAlertAction *action))handler
{
    UIAlertAction *action = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:handler];
    return action;
}

+ (void)showAlertViewMoreChoiceWithTitle:(NSString *)title Message:(NSString *)message ActionArray:(NSArray *)actionarray
{
    UIViewController *viewcontroller = [self getCurrentVC];
    UIAlertController *alertviewcontroller = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    for (int i = 0; i < [actionarray count]; i ++)
    {
        id action = [actionarray objectAtIndex:i];
        if ([action isKindOfClass:[UIAlertAction class]]) {
            [alertviewcontroller addAction:action];
        }else
        {
            NSLog(@"error by this aciontarray is with wrongaction");
        }
    }
    [viewcontroller presentViewController:alertviewcontroller animated:YES completion:nil];
}

+ (UIViewController *)getCurrentVC
{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    UIViewController *vc = keyWindow.rootViewController;
    if ([vc isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tab = (UITabBarController *)vc;
        if ([tab.selectedViewController isKindOfClass:[UINavigationController class]]) {
            UINavigationController *nav = (UINavigationController *)tab.selectedViewController;
            return [nav.viewControllers lastObject];
        } else {
            return tab.selectedViewController;
        }
    } else if ([vc isKindOfClass:[UINavigationController class]]) {
        UINavigationController *nav = (UINavigationController *)vc;
        return [nav.viewControllers lastObject];
    } else {
        return vc;
    }
    return nil;
}

+ (UINavigationController *)getCurrentNavigationVC
{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    UIViewController *vc = keyWindow.rootViewController;
    if ([vc isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tab = (UITabBarController *)vc;
        if ([tab.selectedViewController isKindOfClass:[UINavigationController class]]) {
            UINavigationController *nav = (UINavigationController *)tab.selectedViewController;
            return nav;
        }
    }else if ([vc isKindOfClass:[UINavigationController class]]) {
        UINavigationController *nav = (UINavigationController *)vc;
        return nav;
    }
    return nil;
}

+ (UITabBarController *)getCurrentTabBC
{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    UIViewController *vc = keyWindow.rootViewController;
    if ([vc isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tab = (UITabBarController *)vc;
        return tab;
    }
    return nil;
}

@end
