//
//  QMBuyedProductInfoHeaderView.h
//  MotherMoney
//
//  Created by   on 14-8-9.
//  Copyright (c) 2014年  . All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QMBuyedProductInfoHeaderView : UICollectionReusableView
@property (nonatomic, strong) UILabel *productNameLabel;
@property (nonatomic, strong) UILabel *principalLabel;
@property (nonatomic, strong) UILabel *earningsLabel;

+ (CGFloat)getProductInfoHeaderHeight;

@end
