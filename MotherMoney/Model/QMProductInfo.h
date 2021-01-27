//
//  QMProductInfo.h
//  MotherMoney
//
//  Created by   on 14-8-6.
//  Copyright (c) 2014年  . All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QMBankCardModel.h"

@interface QMProductInfo : NSObject
@property (nonatomic, strong) NSString *product_id;     // 产品id
@property (nonatomic, strong) NSString *productName;    // 产品名称
@property (nonatomic, strong) NSString *baseAmount; // 增长值
@property (nonatomic, assign) BOOL isRecommended;  // 是否推荐
@property (nonatomic, strong) NSString *endBuyTime;
@property (nonatomic, strong) NSString *endInterestDate;
@property (nonatomic, strong) NSString *finishRatio;
@property (nonatomic, strong) NSString *totalBuyNumber; // 购买人数
@property (nonatomic, strong) NSString *totalAmount;
@property (nonatomic, strong) NSString *interest; // 固定收益，如果为0，设为浮动收益
@property (nonatomic, strong) NSString *maturityDuration; // 期限
@property (nonatomic, assign) NSInteger maturityDurationValue;
@property (nonatomic, strong) NSString *maxAmount; // 最大购买金额
@property (nonatomic, strong) NSString *minAmount; // 起购金额
@property (nonatomic, strong) NSString *maxInterest;
@property (nonatomic, strong) NSString *minInterest; // 浮动收益最大值和最小值
@property (nonatomic, strong) NSString *productChannelId;
@property (nonatomic, strong) NSString *productInterestType;
@property (nonatomic, strong) NSString *productStatus;
@property (nonatomic, strong) NSString *productStatusValue;
@property (nonatomic, strong) NSString *remainingAmount;
@property (nonatomic, strong) NSString *saleAmount;
@property (nonatomic, strong) NSString *saleEndTime;
@property (nonatomic, strong) NSString *saleStartTime;
@property (nonatomic, strong) NSString *startBuyTime;
@property (nonatomic, strong) NSString *startInterestDate;
@property (nonatomic, strong) NSString *cornerType;
@property (nonatomic, strong) NSString *descriptionTitle;
@property (nonatomic, strong) NSString *isMonthlySettlement;
// 计算起购金额
@property (nonatomic, strong) NSString *calculateMinAmount;

// 新增字段
@property (nonatomic, strong) NSString *productText; // 车辆质押
@property (nonatomic, strong) NSString *productDescription; // 产品描述
@property (nonatomic, strong) NSString *productDetailText; 


@property (nonatomic, strong) NSString *expectedRateStr;

// 新增产品收益的字段
@property (nonatomic, strong) NSString *normalInterest;
@property (nonatomic, strong) NSString *awardInterest;

- (CGFloat)expectedRateForCalculator;

- (id)initWithDictionary:(NSDictionary *)dictionary;


- (id)initWithRecommandDictionary:(NSDictionary *)dictionary;

@end

