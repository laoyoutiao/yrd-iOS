//
//  QMActivityItemInfoCell.h
//  MotherMoney
//
//  Created by    on 14-8-10.
//  Copyright (c) 2014年   . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QMActivityItemInfo.h"

@interface QMActivityItemInfoCell : UICollectionViewCell

+ (CGFloat)getCellHeightForActivityInfo:(QMActivityItemInfo *)info;

- (void)configureCellWithItemInfo:(QMActivityItemInfo *)info;

@end
