//
//  QMRecommendProductInfoView.h
//  MotherMoney
//
//  Created by   on 14-8-6.
//  Copyright (c) 2014年  . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QMProductInfo.h"
//推荐产品cell的设置
@interface QMRecommendProductInfoCell : UITableViewCell
@property (nonatomic, strong) UIButton *actionBtn;

+ (CGFloat)getCellHeightForProductInfo:(QMProductInfo *)product;

- (void)configureCellWithProductionInfo:(QMProductInfo *)product;

@end
