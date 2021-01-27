//
//  QMCreditorsInfo.h
//  MotherMoney
//
//  Created by cgt cgt on 2017/6/13.
//  Copyright © 2017年 cgt cgt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QMCreditorsInfo : NSObject
@property (nonatomic, strong) NSString *remainingDay;
@property (nonatomic, strong) NSString *transferPrincipal;
@property (nonatomic, strong) NSString *isMonthlySettlement;
@property (nonatomic, strong) NSString *pricePercentage;
@property (nonatomic, strong) NSString *interest;
@property (nonatomic, strong) NSString *transferredNum;
@property (nonatomic, strong) NSString *remainingNum;
@property (nonatomic, strong) NSString *progressRate;
@property (nonatomic, strong) NSString *productName;
@property (nonatomic, strong) NSString *product_id;
@property (nonatomic, strong) NSString *activity_desc;
@property (nonatomic, strong) NSString *productChannelId;
@property (nonatomic, strong) NSString *pass_time;
@property (nonatomic, strong) NSString *repay_date;
@property (nonatomic, strong) NSString *maturity_duration;
@property (nonatomic, strong) NSString *desciption_title;
@property (nonatomic, strong) NSString *remark;
@property (nonatomic, strong) NSString *baseAmount;
@property (nonatomic, strong) NSString *product_id_real;
//remainingAmount;
//minAmount;


- (id)initWithDictionary:(NSDictionary *)dictionary;

@end
