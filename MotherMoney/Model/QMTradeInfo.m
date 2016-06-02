//
//  QMTradeInfo.m
//  MotherMoney
//
//  Created by   on 14-8-9.
//  Copyright (c) 2014年  . All rights reserved.
//

#import "QMTradeInfo.h"

@implementation QMTradeInfo

- (id)initWithDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        NSString *bankCardNumber = [NSString stringWithFormat:@"%@", [dict objectForKey:@"bankCardNumber"]];
        if ([CMMUtility isStringOk:bankCardNumber]) {
            self.bankCardNumber = bankCardNumber;
        }
        
        NSString *bankWater_id = [NSString stringWithFormat:@"%@", [dict objectForKey:@"bankWater_id"]];
        if ([CMMUtility isStringOk:bankWater_id]) {
            self.bankWater_id = bankWater_id;
        }
        
        NSString *bank_id = [NSString stringWithFormat:@"%@", [dict objectForKey:@"bank_id"]];
        if ([CMMUtility isStringOk:bank_id]) {
            self.bank_id = bank_id;
        }
        
        NSString *customer_id = [NSString stringWithFormat:@"%@", [dict objectForKey:@"customer_id"]];
        if ([CMMUtility isStringOk:customer_id]) {
            self.customer_id = customer_id;
        }
        
        NSString *inaccount = [NSString stringWithFormat:@"%@", [dict objectForKey:@"inaccount"]];
        if ([CMMUtility isStringOk:inaccount]) {
            self.inaccount = inaccount;
        }
        
        NSString *instruction = [NSString stringWithFormat:@"%@", [dict objectForKey:@"instruction"]];
        if ([CMMUtility isStringOk:instruction]) {
            self.instruction = instruction;
        }
        
        NSString *logtime = [NSString stringWithFormat:@"%@", [dict objectForKey:@"logtime"]];
        if ([CMMUtility isStringOk:logtime]) {
            self.logtime = logtime;
        }
        
        NSString *outaccount = [NSString stringWithFormat:@"%@", [dict objectForKey:@"outaccount"]];
        if ([CMMUtility isStringOk:outaccount]) {
            self.outaccount = outaccount;
        }
        
        NSString *remainingAmount = [NSString stringWithFormat:@"%@", [dict objectForKey:@"remainingAmount"]];
        if ([CMMUtility isStringOk:remainingAmount]) {
            self.remainingAmount = remainingAmount;
        }
        
        NSString *user_id = [NSString stringWithFormat:@"%@", [dict objectForKey:@"user_id"]];
        if ([CMMUtility isStringOk:user_id]) {
            self.user_id = user_id;
        }
        
        NSString *amount = [NSString stringWithFormat:@"%@", [dict objectForKey:@"amount"]];
        if ([CMMUtility isStringOk:amount]) {
            self.amount = amount;
        }
        
        // TODO
        self.tradeName = self.bankCardNumber;
    }
    
    return self;
}

@end
