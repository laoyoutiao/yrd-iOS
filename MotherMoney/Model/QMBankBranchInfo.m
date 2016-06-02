//
//  QMBankBranchInfo.m
//  MotherMoney
//
//  Created by 赵国辉 on 15/5/14.
//  Copyright (c) 2015年 赵国辉. All rights reserved.
//

#import "QMBankBranchInfo.h"

@implementation QMBankBranchInfo

- (id)initWithDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        self.branchName = [dict objectForKey:@"branchName"];
        
        NSString *prcptcd = [dict objectForKey:@"prcptcd"];
        if ([CMMUtility isStringOk:prcptcd]) {
            self.prcpct = prcptcd;
        }
    }
    
    return self;
}

@end
