//
//  QMBuyedProductInfoCell.h
//  MotherMoney
//
//  Created by on 14-8-9.
//  Copyright (c) 2014年. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QMBankInfoView.h"
#import "QMBuyedProductInfo.h"


@interface QMBuyedProductInfoCell : UICollectionViewCell
@property (nonatomic, strong) UILabel *productNameLabel;
@property (nonatomic, strong) UILabel *earningsLabel;
@property (nonatomic, strong) UILabel *principalLabel;


+ (CGFloat)getCellHeightForProductInfo:(QMBuyedProductInfo *)info;

- (void)configureCellWithProductInfo:(QMBuyedProductInfo *)info;

@end
