//
//  QMProductInfoNumberCell.h
//  MotherMoney
//
//  Created by   on 14-8-16.
//  Copyright (c) 2014年  . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QMProductInfo.h"
#import "QMNumView.h"
#import "QMCreditorsInfo.h"

@interface QMProductInfoNumberCell : UICollectionViewCell

- (void)configureCellWithProductInfo:(QMProductInfo *)info;

+ (CGFloat)getCellHeightForProductInfo:(QMProductInfo *)info;

- (void)configureCellWithCreditorsInfo:(QMCreditorsInfo *)info;

+ (CGFloat)getCellHeightForCreditorsInfo:(QMCreditorsInfo *)info;

@end
