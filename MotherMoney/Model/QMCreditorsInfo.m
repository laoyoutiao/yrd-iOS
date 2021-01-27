//
//  QMCreditorsInfo.m
//  MotherMoney
//
//  Created by cgt cgt on 2017/6/13.
//  Copyright © 2017年 cgt cgt. All rights reserved.
//

#import "QMCreditorsInfo.h"

@implementation QMCreditorsInfo

- (id)initWithDictionary:(NSDictionary *)dictionary {
    if (self = [super init]) {
        NSString *remainingDay = [NSString stringWithFormat:@"%@", [dictionary objectForKey:@"remainingDay"]];
        if ([CMMUtility isStringOk:remainingDay]) {
            self.remainingDay = remainingDay;
        }
        
        NSString *transferPrincipal = [NSString stringWithFormat:@"%@", [dictionary objectForKey:@"transfer_principal"]];
        if ([CMMUtility isStringOk:transferPrincipal]) {
            self.transferPrincipal = transferPrincipal;
        }
        
        NSString *isMonthlySettlement = [NSString stringWithFormat:@"%@", [dictionary objectForKey:@"is_monthly_settlement"]];
        if ([CMMUtility isStringOk:isMonthlySettlement]) {
            self.isMonthlySettlement = isMonthlySettlement;
        }
        
        NSString *pricePercentage = [NSString stringWithFormat:@"%@", [dictionary objectForKey:@"pricePercentage"]];
        if ([CMMUtility isStringOk:pricePercentage]) {
            self.pricePercentage = pricePercentage;
        }
        
        NSString *interest = [NSString stringWithFormat:@"%@", [dictionary objectForKey:@"interest"]];
        if ([CMMUtility isStringOk:interest]) {
            self.interest = interest;
        }
        
        NSString *transferredNum = [NSString stringWithFormat:@"%@", [dictionary objectForKey:@"transferred_num"]];
        if ([CMMUtility isStringOk:transferredNum]) {
            self.transferredNum = transferredNum;
        }
        
        NSString *remainingNum = [NSString stringWithFormat:@"%@", [dictionary objectForKey:@"remainingNum"]];
        if ([CMMUtility isStringOk:remainingNum]) {
            self.remainingNum = remainingNum;
        }
        
        NSString *progressRate = [NSString stringWithFormat:@"%@", [dictionary objectForKey:@"progressRate"]];
        if ([CMMUtility isStringOk:progressRate]) {
            self.progressRate = progressRate;
        }
        
        NSString *productName = [NSString stringWithFormat:@"%@", [dictionary objectForKey:@"product_name"]];
        if ([CMMUtility isStringOk:productName]) {
            self.productName = productName;
        }
        
        NSString *product_id = [NSString stringWithFormat:@"%@", [dictionary objectForKey:@"id"]];
        if ([CMMUtility isStringOk:product_id]) {
            self.product_id = product_id;
        }
        
        NSString *activity_desc = [NSString stringWithFormat:@"%@", [dictionary objectForKey:@"activity_desc"]];
        if ([CMMUtility isStringOk:activity_desc]) {
            self.activity_desc = activity_desc;
        }
        
        NSString *pass_time = [NSString stringWithFormat:@"%@", [dictionary objectForKey:@"pass_time"]];
        if ([CMMUtility isStringOk:pass_time]) {
            self.pass_time = pass_time;
        }
        
        NSString *repay_date = [NSString stringWithFormat:@"%@", [dictionary objectForKey:@"repay_date"]];
        if ([CMMUtility isStringOk:repay_date]) {
            self.repay_date = repay_date;
        }
        
        NSString *remark = [NSString stringWithFormat:@"%@", [dictionary objectForKey:@"remark"]];
        if ([CMMUtility isStringOk:remark]) {
            self.remark = remark;
        }
        
        NSString *maturity_duration = [NSString stringWithFormat:@"%@", [dictionary objectForKey:@"maturity_duration"]];
        if ([CMMUtility isStringOk:maturity_duration]) {
            self.maturity_duration = maturity_duration;
        }
        
        NSString *desciption_title = [NSString stringWithFormat:@"%@", [dictionary objectForKey:@"desciption_title"]];
        if ([CMMUtility isStringOk:desciption_title]) {
            self.desciption_title = desciption_title;
        }
        
        NSString *base_amount = [NSString stringWithFormat:@"%@", [dictionary objectForKey:@"base_amount"]];
        if ([CMMUtility isStringOk:base_amount]) {
            self.baseAmount = base_amount;
        }
        
        NSString *product_id_real = [NSString stringWithFormat:@"%@", [dictionary objectForKey:@"product_id"]];
        if ([CMMUtility isStringOk:product_id_real]) {
            self.product_id_real = product_id_real;
        }
        
        _productChannelId = @"2";
    }
    
    return self;
}

@end
