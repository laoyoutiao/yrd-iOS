//
//  QMRechargeRecordItem.h
//  MotherMoney
//
//  Created by 赵国辉 on 15/5/13.
//  Copyright (c) 2015年 赵国辉. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QMRechargeRecordItem : NSObject
@property (nonatomic, strong) NSString *amount;
@property (nonatomic, strong) NSString *arriveTime;
@property (nonatomic, strong) NSString *bankCardNumber;
@property (nonatomic, strong) NSString *bankCode;
@property (nonatomic, strong) NSString *createTime;
@property (nonatomic, strong) NSString *customerId;
@property (nonatomic, strong) NSString *customerSubAccountId;
@property (nonatomic, strong) NSString *fee;
@property (nonatomic, strong) NSString *recordId;
@property (nonatomic, strong) NSString *mobile;
@property (nonatomic, strong) NSString *productChannelId;
@property (nonatomic, strong) NSString *realFeeCostAccount;
@property (nonatomic, strong) NSString *realName;
@property (nonatomic, strong) NSString *reason;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *statusValue;
@property (nonatomic, strong) NSString *successAmount;
@property (nonatomic, strong) NSString *userBankCardId;

- (id)initWithDictionary:(NSDictionary *)dict;

@end
