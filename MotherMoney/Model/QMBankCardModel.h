//
//  QMBankCardModel.h
//  MotherMoney
//
//  Created by on 14-8-9.
//  Copyright (c) 2014年. All rights reserved.
//

#import <Foundation/Foundation.h>

// 银行卡信息
@interface QMBankCardModel : NSObject
@property (nonatomic, strong) NSString *bankBranchName;
@property (nonatomic, strong) NSString *bankCardCity;
@property (nonatomic, strong) NSString *bankCardNumber;
@property (nonatomic, strong) NSString *bankCardProvince;
@property (nonatomic, strong) NSString *bankCode;
@property (nonatomic, strong) NSString *bankDayLimit;
@property (nonatomic, strong) NSString *bankId;
@property (nonatomic, strong) NSString *bankName;
@property (nonatomic, strong) NSString *bankPicPath;
@property (nonatomic, strong) NSString *bankTimeLimit;
@property (nonatomic, strong) NSString *createTime;
@property (nonatomic, strong) NSString *customerId;
@property (nonatomic, strong) NSString *customerSubAccountId;
@property (nonatomic, strong) NSString *enable;
@property (nonatomic, strong) NSString *memberId;
@property (nonatomic, strong) NSString *reservePhoneNumber;
@property (nonatomic, strong) NSString *statusName;
@property (nonatomic, strong) NSString *statusValue;
@property (nonatomic, strong) NSString *bankCardId;
@property (nonatomic, strong) NSString *isWithdrawCard;

- (id)initWithDictionary:(NSDictionary *)dict;
+ (NSArray *)getArrayModel:(NSArray *)array;
@end
