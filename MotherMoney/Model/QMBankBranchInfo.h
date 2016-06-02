//
//  QMBankBranchInfo.h
//  MotherMoney
//
//  Created by 赵国辉 on 15/5/14.
//  Copyright (c) 2015年 赵国辉. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QMSearchItem.h"
//银行支行信息
@interface QMBankBranchInfo : QMSearchItem
@property (nonatomic, strong) NSString *branchName;
@property (nonatomic, strong) NSString *prcpct;

- (id)initWithDictionary:(NSDictionary *)dict;

@end
