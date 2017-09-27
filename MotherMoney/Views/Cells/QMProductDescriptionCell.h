//
//  QMProductDescriptionCell.h
//  MotherMoney
//
//  Created by 赵国辉 on 15/4/6.
//  Copyright (c) 2015年 赵国辉. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QMProductInfo.h"
#import "QMCreditorsInfo.h"

@interface QMProductDescriptionCell : UICollectionViewCell

+ (CGFloat)getCellHeightForProductInfo:(QMProductInfo *)info;
- (void)configureCellWithProductInfo:(QMProductInfo *)info;

+ (CGFloat)getCellHeightForCreditorsInfo:(QMCreditorsInfo *)info;
- (void)configureCellWithCreditorsInfo:(QMCreditorsInfo *)info;

@end
