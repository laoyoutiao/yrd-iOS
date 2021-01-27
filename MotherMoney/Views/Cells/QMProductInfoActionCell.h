//
//  QMProductInfoActionCell.h
//  MotherMoney
//
//  Created by   on 14-8-16.
//  Copyright (c) 2014年  . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QMProductInfo.h"
#import "QMCreditorsInfo.h"

@interface QMProductInfoActionCell : UICollectionViewCell
@property (nonatomic, strong) UIButton *viewProductDetailBtn;
@property (nonatomic, strong) UIButton *productSecureBtn;

+ (CGFloat)getCellHeightForProductInfo:(QMProductInfo *)info;

+ (CGFloat)getCellHeightForCreditorsInfo:(QMCreditorsInfo *)info;

@end
