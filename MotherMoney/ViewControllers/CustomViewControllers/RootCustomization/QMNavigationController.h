//
//  QMNavigationController.h
//  MotherMoney
//
//  Created by   on 14-8-3.
//  Copyright (c) 2014年  . All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QMNavigationController : UINavigationController

- (NSDictionary *)navTitleAttributes;

- (void)updateNavigationBar;

- (UIColor *)navBackgroundColor;
- (UIImage *)navBackgroundImage;

- (void)updateNavigationBarBgWithCurrentBackgroundImage;

@end
