//
//  QMBuyProductInputMoneyViewController.h
//  MotherMoney
//
//  Created by   on 14-8-16.
//  Copyright (c) 2014年  . All rights reserved.
//

#import "QMViewController.h"
#import "QMProductInfo.h"
#import "QMCreditorsInfo.h"
// 输入购买金额
@interface QMBuyProductInputMoneyViewController : QMViewController

- (id)initViewControllerWithProductInfo:(QMProductInfo *)info;
- (id)initViewControllerWithCreditorsInfo:(QMCreditorsInfo *)info;
@end
