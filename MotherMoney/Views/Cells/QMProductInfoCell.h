//
//  QMProductInfoCell.h
//  MotherMoney
//
//  Created by   on 14-8-7.
//  Copyright (c) 2014年  . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QMProductInfo.h"

@interface QMProductInfoCell : UITableViewCell

- (void)configureProductInfoCellWithProductInfo:(QMProductInfo *)info;

+ (CGFloat)getCellHeightForProduct:(QMProductInfo *)product;

@end
