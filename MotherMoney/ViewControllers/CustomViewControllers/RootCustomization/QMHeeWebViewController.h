//
//  QMHeeWebViewController.h
//  MotherMoney
//
//  Created by cgt cgt on 16/6/3.
//  Copyright © 2016年 cgt cgt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QMViewController.h"

@interface QMHeeWebViewController : QMViewController

+ (void)showWebViewWithRequest:(NSURLRequest *)request
                      navTitle:(NSString *)title
                       isModel:(BOOL)isModel
                          from:(UIViewController *)controller;

@end
 