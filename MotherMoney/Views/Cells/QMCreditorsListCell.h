//
//  QMCreditorsListCell.h
//  MotherMoney
//
//  Created by cgt cgt on 2017/6/13.
//  Copyright © 2017年 cgt cgt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QMCreditorsInfo.h"

@interface QMCreditorsListCell : UICollectionViewCell

- (void)configureCellWithProductionInfo:(QMCreditorsInfo *)info;

+ (CGFloat)getCellHeightForProductInfo:(QMCreditorsInfo *)info;

@end
