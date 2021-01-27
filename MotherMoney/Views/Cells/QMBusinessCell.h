//
//  QMBusinessCell.h
//  MotherMoney
//
//  Created by cgt cgt on 2017/8/9.
//  Copyright © 2017年 cgt cgt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QMBusinessInfoModel.h"

@interface QMBusinessCell : UITableViewCell

- (void)setupFrame:(CGRect)rect;
- (void)configureCellWithItemInfo:(QMBusinessInfoModel *)info;
- (void)setupBusinessText:(NSString *)text;

@end
