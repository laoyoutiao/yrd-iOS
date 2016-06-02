//
//  QMBuyedProductInfoCell2.h
//  MotherMoney
//
//  Created by liuyanfang on 15/8/14.
//  Copyright (c) 2015年 liuyanfang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QMBankInfoView.h"
#import "QMBuyedProductInfo.h"
@interface QMBuyedProductInfoCell2 : UICollectionViewCell
@property (nonatomic, strong) UILabel *productNameLabel;
@property (nonatomic, strong) UILabel *earningsLabel;
@property (nonatomic, strong) UILabel *principalLabel;

+ (CGFloat)getCellHeightForProductInfo:(QMBuyedProductInfo *)info;

- (void)configureCellWithProductInfo2:(QMBuyedProductInfo *)info;
@end
