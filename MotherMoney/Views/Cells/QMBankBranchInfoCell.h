//
//  QMBankBranchInfoCell.h
//  MotherMoney
//
//  Created by 赵国辉 on 15/5/14.
//  Copyright (c) 2015年 赵国辉. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QMBankBranchInfo.h"

@interface QMBankBranchInfoCell : UITableViewCell

- (void)configureCellWithBranchInfo:(QMBankBranchInfo *)info;
+ (CGFloat)getCellHeightWithBranchInfo:(QMBankBranchInfo *)info;

@end
