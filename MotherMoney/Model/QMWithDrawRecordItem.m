//
//  QMWithDrawRecordItem.m
//  MotherMoney
//
//  Created by 赵国辉 on 15/5/13.
//  Copyright (c) 2015年 赵国辉. All rights reserved.
//

#import "QMWithDrawRecordItem.h"

@implementation QMWithDrawRecordItem

- (id)initWithDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        NSString *amount = [NSString stringWithFormat:@"%@", [dict objectForKey:@"amount"]];
        if ([CMMUtility isStringOk:amount]) {
            self.amount = amount;
        }
        
        NSString *createTime = [NSString stringWithFormat:@"%@", [dict objectForKey:@"applyTime"]];
        if ([CMMUtility isStringOk:createTime]) {
            self.applyTime = createTime;
        }
        
        NSString *statusValue = [NSString stringWithFormat:@"%@", [dict objectForKey:@"statusValue"]];
        if ([CMMUtility isStringOk:statusValue]) {
            self.statusValue = statusValue;
        }
        
        NSString *auditStaffName = [NSString stringWithFormat:@"%@", [dict objectForKey:@"auditStaffName"]];
        if ([CMMUtility isStringOk:auditStaffName]) {
            self.auditStaffName = auditStaffName;
        }
        
        NSString *again = [NSString stringWithFormat:@"%@", [dict objectForKey:@"again"]];
        if ([CMMUtility isStringOk:again]) {
            self.again = again;
        }
        
        NSString *auditStaffId = [NSString stringWithFormat:@"%@", [dict objectForKey:@"auditStaffId"]];
        if ([CMMUtility isStringOk:auditStaffId]) {
            self.auditStaffId = auditStaffId;
        }
        
        NSString *auditTime = [NSString stringWithFormat:@"%@", [dict objectForKey:@"auditTime"]];
        if ([CMMUtility isStringOk:auditTime]) {
            self.auditTime = auditTime;
        }
        
        NSString *customerId = [NSString stringWithFormat:@"%@", [dict objectForKey:@"customerId"]];
        if ([CMMUtility isStringOk:customerId]) {
            self.customerId = customerId;
        }
        
        NSString *customerSubAccountId = [NSString stringWithFormat:@"%@", [dict objectForKey:@"customerSubAccountId"]];
        if ([CMMUtility isStringOk:customerSubAccountId]) {
            self.customerSubAccountId = customerSubAccountId;
        }
        
        NSString *mobile = [NSString stringWithFormat:@"%@", [dict objectForKey:@"mobile"]];
        if ([CMMUtility isStringOk:mobile]) {
            self.mobile = mobile;
        }
        
        NSString *realName = [NSString stringWithFormat:@"%@", [dict objectForKey:@"realName"]];
        if ([CMMUtility isStringOk:realName]) {
            self.realName = realName;
        }
        
        NSString *status = [NSString stringWithFormat:@"%@", [dict objectForKey:@"status"]];
        if ([CMMUtility isStringOk:status]) {
            self.status = status;
        }
        
        NSString *notes = [NSString stringWithFormat:@"%@", [dict objectForKey:@"notes"]];
        if ([CMMUtility isStringOk:notes]) {
            self.notes = notes;
        }
        
        NSString *type = [NSString stringWithFormat:@"%@", [dict objectForKey:@"type"]];
        if ([CMMUtility isStringOk:notes]) {
            self.type = type;
        }
        
        NSString *typeValue = [NSString stringWithFormat:@"%@", [dict objectForKey:@"typeValue"]];
        if ([CMMUtility isStringOk:typeValue]) {
            self.typeValue = typeValue;
        }
        
        NSString *withdrawalNotes = [NSString stringWithFormat:@"%@", [dict objectForKey:@"withdrawalNotes"]];
        if ([CMMUtility isStringOk:withdrawalNotes]) {
            self.withdrawalNotes = withdrawalNotes;
        }
        
        NSString *withdrawalStaffId = [NSString stringWithFormat:@"%@", [dict objectForKey:@"withdrawalStaffId"]];
        if ([CMMUtility isStringOk:withdrawalStaffId]) {
            self.withdrawalStaffId = withdrawalStaffId;
        }
        
        NSString *withdrawalStaffName = [NSString stringWithFormat:@"%@", [dict objectForKey:@"withdrawalStaffName"]];
        if ([CMMUtility isStringOk:withdrawalStaffName]) {
            self.withdrawalStaffName = withdrawalStaffName;
        }
        
        NSString *withdrawalTime = [NSString stringWithFormat:@"%@", [dict objectForKey:@"withdrawalTime"]];
        if ([CMMUtility isStringOk:withdrawalTime]) {
            self.withdrawalTime = withdrawalTime;
        }
        
        NSString *recordId = [NSString stringWithFormat:@"%@", [dict objectForKey:@"id"]];
        if ([CMMUtility isStringOk:recordId]) {
            self.recordId = recordId;
        }
    }
    
    return self;
}

@end
