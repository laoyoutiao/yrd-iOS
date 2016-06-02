//
//  QMIntegralExchangeListCell.h
//  MotherMoney

#import <UIKit/UIKit.h>
#import "QMIntegralExchangeListItem.h"

@interface QMIntegralExchangeListCell : UICollectionViewCell
@property (nonatomic, strong) UIImageView *horizontalLine;

+ (CGFloat)getCellHeightWithItem:(QMIntegralExchangeListItem *)item;

- (void)configureCellWithItem:(QMIntegralExchangeListItem *)item;

@end
