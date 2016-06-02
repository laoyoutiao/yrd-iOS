//
//  QMMyFundAbstractCell.h
//  MotherMoney
//
//  Created by   on 14-8-9.
//  Copyright (c) 2014年  . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QMMyFundModel.h"

@interface QMMyFundAbstractCell : UICollectionViewCell


+ (CGFloat)getAbstractViewHeightForFundInfo:(QMMyFundModel *)info;

- (void)configureWithFundInfo:(QMMyFundModel *)info;

@end
