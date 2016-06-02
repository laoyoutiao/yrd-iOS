//
//  QMBankCardModel.m
//  MotherMoney
//
//  Created by on 14-8-9.
//  Copyright (c) 2014年. All rights reserved.
//

#import "QMBankCardModel.h"

@implementation QMBankCardModel

- (id)initWithDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        NSString *bankBranchName = [NSString stringWithFormat:@"%@", [dict objectForKey:@"bankBranchName"]];
        if ([CMMUtility isStringOk:bankBranchName]) {
            self.bankBranchName = bankBranchName;
        }
        
        NSString *bankCardCity = [NSString stringWithFormat:@"%@", [dict objectForKey:@"bankCardCity"]];
        if ([CMMUtility isStringOk:bankCardCity]) {
            self.bankCardCity = bankCardCity;
        }
        
        NSString *bankCardProvince = [NSString stringWithFormat:@"%@", [dict objectForKey:@"bankCardProvince"]];
        if ([CMMUtility isStringOk:bankCardProvince]) {
            self.bankCardProvince = bankCardProvince;
        }
        
        NSString *bankCardNumber = [NSString stringWithFormat:@"%@", [dict objectForKey:@"bankCardNumber"]];
        if ([CMMUtility isStringOk:bankCardNumber]) {
            self.bankCardNumber = bankCardNumber;
        }
        
        NSString *bankCode = [NSString stringWithFormat:@"%@", [dict objectForKey:@"bankCode"]];
        if ([CMMUtility isStringOk:bankCode]) {
            self.bankCode = bankCode;
        }
        
        NSString *bankDayLimit = [NSString stringWithFormat:@"%@", [dict objectForKey:@"bankDayLimit"]];
        if ([CMMUtility isStringOk:bankDayLimit]) {
            self.bankDayLimit = bankDayLimit;
        }
        
        NSString *bankId = [NSString stringWithFormat:@"%@", [dict objectForKey:@"id"]];
        if ([CMMUtility isStringOk:bankId]) {
            self.bankId = bankId;
        }
        
        NSString *bankName = [NSString stringWithFormat:@"%@", [dict objectForKey:@"bankName"]];
        if ([CMMUtility isStringOk:bankName]) {
            self.bankName = bankName;
        }
        
        NSString *bankPicPath = [NSString stringWithFormat:@"%@", [dict objectForKey:@"bankPicPath"]];
        if ([CMMUtility isStringOk:bankPicPath]) {
            self.bankPicPath = bankPicPath;
        }
        
        NSString *bankTimeLimit = [NSString stringWithFormat:@"%@", [dict objectForKey:@"bankTimeLimit"]];
        if ([CMMUtility isStringOk:bankTimeLimit]) {
            self.bankTimeLimit = bankTimeLimit;
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
        
        NSString *enable = [NSString stringWithFormat:@"%@", [dict objectForKey:@"enable"]];
        if ([CMMUtility isStringOk:enable]) {
            self.enable = enable;
        }
        
        NSString *memberId = [NSString stringWithFormat:@"%@", [dict objectForKey:@"memberId"]];
        if ([CMMUtility isStringOk:memberId]) {
            self.memberId = memberId;
        }
        
        NSString *reservePhoneNumber = [NSString stringWithFormat:@"%@", [dict objectForKey:@"reservePhoneNumber"]];
        if ([CMMUtility isStringOk:reservePhoneNumber]) {
            self.reservePhoneNumber = reservePhoneNumber;
        }
        
        NSString *statusName = [NSString stringWithFormat:@"%@", [dict objectForKey:@"statusName"]];
        if ([CMMUtility isStringOk:statusName]) {
            self.statusName = statusName;
        }
        
        NSString *statusValue = [NSString stringWithFormat:@"%@", [dict objectForKey:@"statusValue"]];
        if ([CMMUtility isStringOk:statusValue]) {
            self.statusValue = statusValue;
        }
        
        NSString *bankCardId = [NSString stringWithFormat:@"%@", [dict objectForKey:@"id"]];
        if ([CMMUtility isStringOk:bankCardId]) {
            self.bankCardId = bankCardId;
        }
    }
    
    return self;
}

@end

