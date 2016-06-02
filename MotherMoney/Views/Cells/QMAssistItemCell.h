//
//  QMAssistItemCell.h
//  MotherMoney
//
//  Created by    on 14-8-10.
//  Copyright (c) 2014年   . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QMAssistItem.h"

@interface QMAssistItemCell : UICollectionViewCell

+ (CGFloat)getCellHeightForItem:(QMAssistItem *)item;

- (void)configureCellWithAssistItem:(QMAssistItem *)item;

@end
