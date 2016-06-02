//
//  QMProductListCell.h
//  MotherMoney
//
//  Created by   on 14-8-6.
//  Copyright (c) 2014年  . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QMProductInfo.h"

@interface QMProductListCell : UICollectionViewCell

- (void)configureCellWithProductionInfo:(QMProductInfo *)info;

+ (CGFloat)getCellHeightForProductInfo:(QMProductInfo *)info;

@end
