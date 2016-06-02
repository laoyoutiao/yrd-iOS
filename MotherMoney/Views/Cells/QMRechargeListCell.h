//
//  QMRechargeListCell.h
//  MotherMoney
//
//  Created by 赵国辉 on 15/5/13.
//  Copyright (c) 2015年 赵国辉. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QMRechargeRecordItem.h"

@interface QMRechargeListCell : UICollectionViewCell

+ (CGFloat)getCellHeightForRechargeItem:(QMRechargeRecordItem *)info;

- (void)configureCellWithItemInfo:(QMRechargeRecordItem *)info;

@end
