//
//  QMMoreItemInfoCell.h
//  MotherMoney
//
//  Created by    on 14-8-10.
//  Copyright (c) 2014年   . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QMMoreItemInfo.h"

@interface QMMoreItemInfoCell : UICollectionViewCell
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subTitleLabel;
@property (nonatomic, strong) UILabel *detailInfoLabel;
@property (nonatomic, strong) UIImageView *accessoryImageView;
@property (nonatomic, assign) BOOL showsIndicator;
@property (nonatomic, assign) BOOL showsLine;

+ (CGFloat)getCellHeightForItemInfo:(QMMoreItemInfo *)info;

- (void)configureCellWithMoreItemInfo:(QMMoreItemInfo *)info;

@end
