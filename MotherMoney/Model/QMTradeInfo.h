//
//  QMTradeInfo.h
//  MotherMoney
//
//  Created by   on 14-8-9.
//  Copyright (c) 2014年  . All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QMTradeInfo : NSObject
@property (nonatomic, strong) NSString *bankCardNumber;
@property (nonatomic, strong) NSString *bankWater_id;
@property (nonatomic, strong) NSString *bank_id;
@property (nonatomic, strong) NSString *customer_id;
@property (nonatomic, strong) NSString *inaccount;
@property (nonatomic, strong) NSString *instruction;
@property (nonatomic, strong) NSString *logtime;
@property (nonatomic, strong) NSString *outaccount;
@property (nonatomic, strong) NSString *remainingAmount;
@property (nonatomic, strong) NSString *user_id;
@property (nonatomic, strong) NSString *tradeName;
@property (nonatomic, strong) NSString *amount;

- (id)initWithDictionary:(NSDictionary *)dict;

@end
