//
//  QMTradeRecordCell.h
//  MotherMoney
//
//  Created by   on 14-8-9.
//  Copyright (c) 2014年  . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QMTradeInfo.h"

// 交易记录信息
@interface QMTradeRecordCell : UICollectionViewCell
@property (nonatomic, strong) UIImageView *horizontalLine;

- (void)configureCellWithTradeInfo:(QMTradeInfo *)tradeInfo;
- (void)reset;

+ (CGFloat)getCellHeightForTradeInfo:(QMTradeInfo *)tradeInfo;

@end
