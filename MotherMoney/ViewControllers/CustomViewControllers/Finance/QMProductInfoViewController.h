//
//  QMProductInfoViewController.h
//  MotherMoney
//
//  Created by   on 14-8-7.
//  Copyright (c) 2014年  . All rights reserved.
//

#import "QMViewController.h"
#import "QMProductInfo.h"
#import "QMWebViewController3.h"
@interface QMProductInfoViewController : QMViewController
@property (nonatomic, assign) BOOL isModel;

- (id)initViewControllerWithProductInfo:(QMProductInfo *)product;

@end
