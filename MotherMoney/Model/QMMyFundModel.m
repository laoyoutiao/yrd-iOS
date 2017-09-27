//
//  QMMyFundModel.m
//  MotherMoney
//
//  Created by   on 14-8-9.
//  Copyright (c) 2014年  . All rights reserved.
//

#import "QMMyFundModel.h"

@implementation QMMyFundModel

- (id)initWithDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        // customerAccount
        NSDictionary *customerAccount = [dict objectForKey:@"customerAccount"];
        
        // phone number
        NSString *mobile = [NSString stringWithFormat:@"%@", [customerAccount objectForKey:@"mobile"]];
        if ([CMMUtility isStringOk:mobile]) {
            self.mobile = _mobile;
        }
        
        // real name
        NSString *realName = [NSString stringWithFormat:@"%@", [customerAccount objectForKey:@"realName"]];
        if ([CMMUtility isStringOk:realName]) {
            self.realName = realName;
        }
        
        // identifierNumber
        NSString *idCardNumber = [NSString stringWithFormat:@"%@", [customerAccount objectForKey:@"idCardNumber"]];
        if ([CMMUtility isStringOk:idCardNumber]) {
            self.idCardNumber = _idCardNumber;
        }
        
        // hasRealName
        self.realNameAuthed = NO;
        if (!QM_IS_STR_NIL(self.realName)) {
            self.realNameAuthed = YES;
        }
        
        // available score
        NSString *availableScore = [NSString stringWithFormat:@"%@", [customerAccount objectForKey:@"availableScore"]];
        if ([CMMUtility isStringOk:availableScore]) {
            self.availableScore = availableScore;
        }
        
        // todayTotalEarning
        NSString *todayTotalEarnings = [NSString stringWithFormat:@"%@", [customerAccount objectForKey:@"todayTotalEarnings"]];
        if ([CMMUtility isStringOk:todayTotalEarnings]) {
            self.todayTotalEarnings = todayTotalEarnings;
        }
        
        // totalAssets
        NSString *totalAssets = [NSString stringWithFormat:@"%@", [customerAccount objectForKey:@"totalAssets"]];
        if ([CMMUtility isStringOk:totalAssets]) {
            self.totalAssets = totalAssets;
        }
        
        NSString *hasPayPwd = [NSString stringWithFormat:@"%@", [customerAccount objectForKey:@"hasPayPwd"]];
        if ([CMMUtility isStringOk:hasPayPwd]) {
            self.hasPayPwd = [hasPayPwd boolValue];
        }
        NSString *isBuy = [NSString stringWithFormat:@"%@", [customerAccount objectForKey:@"isBuy"]];
        if ([CMMUtility isStringOk:isBuy]) {
            self.isBuy = [isBuy boolValue];
        }  
        
        // totalEarnings
        NSString *totalEarnings = [NSString stringWithFormat:@"%@", [customerAccount objectForKey:@"totalEarnings"]];
        if ([CMMUtility isStringOk:totalEarnings]) {
            self.totalEarnings = totalEarnings;
        }
        
        // totalAvailable
        NSString *ableWithdrawalAmount = [NSString stringWithFormat:@"%@", [dict objectForKey:@"ableWithdrawalAmount"]];
        if ([CMMUtility isStringOk:ableWithdrawalAmount]) {
            self.ableWithdrawalAmount = ableWithdrawalAmount;
        }
        
        NSString *ableCardNum = [NSString stringWithFormat:@"%@", [dict objectForKey:@"ableCardNum"]];
        if ([CMMUtility isStringOk:ableCardNum]) {
            self.ableCardNum = ableCardNum;
        }
        
        NSString *salesman = [NSString stringWithFormat:@"%@", [dict objectForKey:@"salesman"]];
        if ([CMMUtility isStringOk:salesman]) {
            self.salesman = [salesman boolValue];
            NSLog(@"%u",self.salesman);
        }
        
        NSString *channelId = [NSString stringWithFormat:@"%@",[dict objectForKey:@"channelId"]];
        if ([CMMUtility isStringOk:channelId]) {
            self.channelId = channelId;
        }
        
        NSString *customerCount = [NSString stringWithFormat:@"%@",[dict objectForKey:@"customerCount"]];
        if ([CMMUtility isStringOk:customerCount]) {
            self.customerCount = customerCount;
        }
        
        NSString *openAccountStatus = [NSString stringWithFormat:@"%@",[dict objectForKey:@"status"]];
        if ([CMMUtility isStringOk:openAccountStatus]) {
            self.openAccountStatus = openAccountStatus;
        }

        
//        // 初始化产品数据
//        NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
//        
//        NSArray *products = [dict objectForKey:@"productAccountList"];
//        if ([products isKindOfClass:[NSArray class]]) {
//            for (NSDictionary *dict in products) {
//                QMBuyedProductInfo *info = [[QMBuyedProductInfo alloc] initWithDictionary:dict];
//                [array addObject:info];
//            }
//        }
//        
//        
//        self.productions = [NSArray arrayWithArray:array];
        
        
    }
    
    return self;
}

@end
