//
//  QMMessageCell.h
//  MotherMoney
//
//  Created by   on 14-8-9.
//  Copyright (c) 2014年  . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QMMessageInfo.h"

@interface QMMessageCell : UITableViewCell
@property (nonatomic, strong) UILabel *msgTitleLabel;
@property (nonatomic, strong) UILabel *msgDateLabel;
@property (nonatomic, strong) UILabel *msgContentLabel;

- (void)configureCellWithMessage:(QMMessageInfo *)info;

+ (CGFloat)getCellHeightForMessage:(QMMessageInfo *)info;

@end
