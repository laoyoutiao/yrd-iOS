//
//  QMAccountInfoCell.h
//  MotherMoney
//
//  Created by   on 14-8-9.
//  Copyright (c) 2014年  . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QMAccountInfo.h"
//个人账户cell，头像，姓名，手机号
@interface QMAccountInfoCell : UICollectionViewCell
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UIImageView *indicatorView;

+ (CGFloat)getCellHeightWithAccountInfo:(QMAccountInfo *)accountInfo;

- (void)configureCellWithAccountInfo:(QMAccountInfo *)accountInfo;

@end
