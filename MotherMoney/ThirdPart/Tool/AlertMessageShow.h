//
//  AlertMessageShow.h
//  GovernmentEnterprises
//
//  Created by cgt cgt on 2016/12/9.
//  Copyright © 2016年 uones. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface AlertMessageShow : NSObject

+ (void)showAlertViewOnlyChoiceWithTitle:(NSString *)title Message:(NSString *)message;

+ (UIAlertAction *)showActionTitle:(NSString *)title handler:(void (^)(UIAlertAction *action))handler;

+ (void)showAlertViewMoreChoiceWithTitle:(NSString *)title Message:(NSString *)message ActionArray:(NSArray *)actionarray;

+ (UIViewController *)getCurrentVC;

+ (UINavigationController *)getCurrentNavigationVC;

+ (UITabBarController *)getCurrentTabBC;

@end
