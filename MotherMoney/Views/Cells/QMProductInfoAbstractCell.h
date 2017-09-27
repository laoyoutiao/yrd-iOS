//
//  QMProductInfoAbstractCell.h
//  MotherMoney
//
//  Created by   on 14-8-16.
//  Copyright (c) 2014年  . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QMProductInfo.h"
#import "QMCreditorsInfo.h"

@interface QMProductInfoAbstractCell : UICollectionViewCell

@property (nonatomic, strong) UIButton *mJumpRealProductInfoViewLabel;

- (void)configureCellWithProductInfo:(QMProductInfo *)info;

+ (CGFloat)getCellHeightForProductInfo:(QMProductInfo *)info;

- (void)configureCellWithCreditorsInfo:(QMCreditorsInfo *)info ViewConrtoller:(UIViewController *)viewcontroller;

+ (CGFloat)getCellHeightForCreditorsInfo:(QMCreditorsInfo *)info;

@end
