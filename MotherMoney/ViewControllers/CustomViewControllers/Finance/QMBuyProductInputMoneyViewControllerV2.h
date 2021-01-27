//
//  QMBuyProductInputMoneyViewControllerV2.h
//  MotherMoney
//
//  Created by 赵国辉 on 15/5/17.
//  Copyright (c) 2015年 赵国辉. All rights reserved.
//

#import "QMViewController.h"
#import "QMProductInfo.h"
#import "QMCreditorsInfo.h"
//钱宝宝产品，点击购买之后跳入的界面，申购
@interface QMBuyProductInputMoneyViewControllerV2 : QMViewController
@property(nonatomic,strong)NSString *couponName;
@property(nonatomic,strong)NSString *useCode;
@property(nonatomic,assign)float value;
@property(nonatomic,assign)float useLimit;
- (id)initViewControllerWithProductInfo:(QMProductInfo *)info;
- (id)initViewControllerWithCreditorsInfo:(QMCreditorsInfo *)info;

@end

