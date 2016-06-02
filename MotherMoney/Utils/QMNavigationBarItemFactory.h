//
//  QMNavigationBarItemFactory.h
//  MotherMoney
//
//  Created by   on 14-8-4.
//  Copyright (c) 2014年  . All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QMNavigationBarItemFactory : NSObject

+ (UIBarButtonItem *)createNavigationImageButtonWithNormalImage:(UIImage *)normalImage
                                                        hlImage:(UIImage *)hlImage
                                                         target:(id)target
                                                       selector:(SEL)selector
                                                         isLeft:(BOOL)isLeft;

+ (UIBarButtonItem *)createNavigationItemWithTitle:(NSString *)title
                                            target:(id)target
                                          selector:(SEL)selector
                                            isLeft:(BOOL)isLeft;

+ (UIBarButtonItem *)createNavigationBackItemWithTarget:(id)target selector:(SEL)selector;
+ (UIBarButtonItem *)createNavigationReloadItemWithTarget:(id)target selector:(SEL)selector;
@end
