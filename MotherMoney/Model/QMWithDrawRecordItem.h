//
//  QMWithDrawRecordItem.h
//  MotherMoney
//
//  Created by 赵国辉 on 15/5/13.
//  Copyright (c) 2015年 赵国辉. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QMWithDrawRecordItem : NSObject
@property (nonatomic, strong) NSString *amount;
@property (nonatomic, strong) NSString *applyTime;
@property (nonatomic, strong) NSString *statusValue;
@property (nonatomic, strong) NSString *again;
@property (nonatomic, strong) NSString *auditStaffId;
@property (nonatomic, strong) NSString *auditStaffName;
@property (nonatomic, strong) NSString *auditTime;
@property (nonatomic, strong) NSString *customerId;
@property (nonatomic, strong) NSString *customerSubAccountId;
@property (nonatomic, strong) NSString *mobile;
@property (nonatomic, strong) NSString *notes;
@property (nonatomic, strong) NSString *realName;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *typeValue;
@property (nonatomic, strong) NSString *withdrawalNotes;
@property (nonatomic, strong) NSString *withdrawalStaffId;
@property (nonatomic, strong) NSString *withdrawalStaffName;
@property (nonatomic, strong) NSString *withdrawalTime;
@property (nonatomic, strong) NSString *recordId;

- (id)initWithDictionary:(NSDictionary *)dict;





@end