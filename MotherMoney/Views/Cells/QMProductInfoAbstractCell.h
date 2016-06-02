//
//  QMProductInfoAbstractCell.h
//  MotherMoney
//
//  Created by   on 14-8-16.
//  Copyright (c) 2014年  . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QMProductInfo.h"

@interface QMProductInfoAbstractCell : UICollectionViewCell

- (void)configureCellWithProductInfo:(QMProductInfo *)info;

+ (CGFloat)getCellHeightForProductInfo:(QMProductInfo *)info;

@end
