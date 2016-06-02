//
//  QMRechargeRecordItem.m
//  MotherMoney
//
//  Created by 赵国辉 on 15/5/13.
//  Copyright (c) 2015年 赵国辉. All rights reserved.
//

#import "QMRechargeRecordItem.h"

@implementation QMRechargeRecordItem

- (id)initWithDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        NSString *amount = [NSString stringWithFormat:@"%@", [dict objectForKey:@"amount"]];
        if ([CMMUtility isStringOk:amount]) {
            self.amount = amount;
        }
        
        NSString *arriveTime = [NSString stringWithFormat:@"%@", [dict objectForKey:@"arriveTime"]];
        if ([CMMUtility isStringOk:arriveTime]) {
            self.arriveTime = arriveTime;
        }
        
        
        NSString *bankCardNumber = [NSString stringWithFormat:@"%@", [dict objectForKey:@"bankCardNumber"]];
        if ([CMMUtility isStringOk:bankCardNumber]) {
            self.bankCardNumber = bankCardNumber;
        }
        
        NSString *bankCode = [NSString stringWithFormat:@"%@", [dict objectForKey:@"bankCode"]];
        if ([CMMUtility isStringOk:bankCode]) {
            self.bankCode = bankCode;
        }
        
        NSString *createTime = [NSString stringWithFormat:@"%@", [dict objectForKey:@"createTime"]];
        if ([CMMUtility isStringOk:createTime]) {
            self.createTime = createTime;
        }
        
        NSString *customerId = [NSString stringWithFormat:@"%@", [dict objectForKey:@"customerId"]];
        if ([CMMUtility isStringOk:customerId]) {
            self.customerId = customerId;
        }
        
        NSString *customerSubAccountId = [NSString stringWithFormat:@"%@", [dict objectForKey:@"customerSubAccountId"]];
        if ([CMMUtility isStringOk:customerSubAccountId]) {
            self.customerSubAccountId = customerSubAccountId;
        }
        
        NSString *fee = [NSString stringWithFormat:@"%@", [dict objectForKey:@"fee"]];
        if ([CMMUtility isStringOk:fee]) {
            self.fee = fee;
        }
        
        NSString *recordId = [NSString stringWithFormat:@"%@", [dict objectForKey:@"id"]];
        if ([CMMUtility isStringOk:recordId]) {
            self.recordId = recordId;
        }
        
        NSString *mobile = [NSString stringWithFormat:@"%@", [dict objectForKey:@"mobile"]];
        if ([CMMUtility isStringOk:mobile]) {
            self.mobile = mobile;
        }
        
        NSString *productChannelId = [NSString stringWithFormat:@"%@", [dict objectForKey:@"productChannelId"]];
        if ([CMMUtility isStringOk:productChannelId]) {
            self.productChannelId = productChannelId;
        }
        
        NSString *realFeeCostAccount = [NSString stringWithFormat:@"%@", [dict objectForKey:@"realFeeCostAccount"]];
        if ([CMMUtility isStringOk:realFeeCostAccount]) {
            self.realFeeCostAccount = realFeeCostAccount;
        }
        
        NSString *realName = [NSString stringWithFormat:@"%@", [dict objectForKey:@"realName"]];
        if ([CMMUtility isStringOk:realName]) {
            self.realName = realName;
        }
        
        NSString *reason = [NSString stringWithFormat:@"%@", [dict objectForKey:@"reason"]];
        if ([CMMUtility isStringOk:reason]) {
            self.reason = reason;
        }
        
        NSString *status = [NSString stringWithFormat:@"%@", [dict objectForKey:@"status"]];
        if ([CMMUtility isStringOk:status]) {
            self.status = status;
        }
        
        NSString *statusValue = [NSString stringWithFormat:@"%@", [dict objectForKey:@"statusValue"]];
        if ([CMMUtility isStringOk:statusValue]) {
            self.statusValue = statusValue;
        }
        
        NSString *successAmount = [NSString stringWithFormat:@"%@", [dict objectForKey:@"successAmount"]];
        if ([CMMUtility isStringOk:successAmount]) {
            self.successAmount = successAmount;
        }
        
        NSString *userBankCardId = [NSString stringWithFormat:@"%@", [dict objectForKey:@"userBankCardId"]];
        if ([CMMUtility isStringOk:userBankCardId]) {
            self.userBankCardId = userBankCardId;
        }
    }
    
    return self;
}

@end
