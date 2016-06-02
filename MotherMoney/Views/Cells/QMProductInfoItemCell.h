//
//  QMProductInfoItemCell.h
//  MotherMoney
//
//  Created by   on 14-8-16.
//  Copyright (c) 2014年  . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QMProductInfo.h"

@interface QMProductInfoItemCell : UICollectionViewCell
@property (nonatomic, strong) UILabel *itemTitleLabel;
@property (nonatomic, strong) UILabel *itemValueLabel;
@property (nonatomic, assign) BOOL showsIndicator;

+ (CGFloat)getCellHeightForProductInfo:(QMProductInfo *)info;

@end
