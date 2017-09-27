//
//  QMCreditorsInfoViewController.h
//  MotherMoney
//
//  Created by cgt cgt on 2017/6/15.
//  Copyright © 2017年 cgt cgt. All rights reserved.
//

#import "QMViewController.h"
#import "QMCreditorsInfo.h"
#import "QMWebViewController3.h"
@interface QMCreditorsInfoViewController : QMViewController
@property (nonatomic, assign) BOOL isModel;

- (id)initViewControllerWithProductInfo:(QMCreditorsInfo *)product;

@end
