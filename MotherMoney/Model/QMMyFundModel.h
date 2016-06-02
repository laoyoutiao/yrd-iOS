//
//  QMMyFundModel.h
//  MotherMoney
//
//  Created by   on 14-8-9.
//  Copyright (c) 2014年  . All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QMBuyedProductInfo.h"


// 我的资产信息
@interface QMMyFundModel : NSObject
@property (nonatomic, strong) NSString *mobile; // 手机号码
@property (nonatomic, strong) NSString *realName; // 真是姓名
@property (nonatomic, strong) NSString *idCardNumber; // 身份证号
@property (nonatomic, assign) BOOL realNameAuthed; // 是否实名认证
@property (nonatomic, strong) NSString *availableScore;
@property (nonatomic, strong) NSString *todayTotalEarnings; // 今日收益
@property (nonatomic, strong) NSString *totalAssets; // 总资产
@property (nonatomic, assign) BOOL hasPayPwd; // 是否有支付密码
@property (nonatomic, strong) NSString *totalEarnings;
@property (nonatomic, assign) BOOL isBuy;
@property (nonatomic, strong) NSString *ableWithdrawalAmount;


- (id)initWithDictionary:(NSDictionary *)dict;



/*
 customerAccount =     {
 availableScore = 1000;
 idCardNumber = "5109********4652";
 mobile = 15528178166;
 realName = "\U5510\U667a";
 todayTotalEarnings = 0;
 totalAssets = 50;
 };
 productAccountList =     (
 {
 id = 5;
 productId = 1;
 productName = "\U5171\U9e23\U751f\U4ea7\U73af\U5883\U6d4b\U8bd5\U8d44\U4ea7";
 todayTotalEarnings = 0;
 totalBuyAmount = 50;
 totalEarnings = 0;
 }
 );
 */

@end
