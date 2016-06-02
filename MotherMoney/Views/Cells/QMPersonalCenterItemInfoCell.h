//
//  QMPersonalCenterItemInfoCell.h
//  MotherMoney
//
//  Created by   on 14-8-15.
//  Copyright (c) 2014年  . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QMPersonalCenterItemInfo.h"

@interface QMPersonalCenterItemInfoCell : UITableViewCell
@property (nonatomic, strong) UIImageView *horizontalLine;

- (void)configureCellWithItemInfo:(QMPersonalCenterItemInfo *)info;

@end
