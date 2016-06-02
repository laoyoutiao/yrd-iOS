//
//  QMMyProductInfoAbstractCell.h
//  MotherMoney
#import <UIKit/UIKit.h>
#import "QMBuyedProductInfo.h"

@interface QMMyProductInfoAbstractCell : UICollectionViewCell

+ (CGFloat)getAbstractViewHeightForFundInfo:(QMBuyedProductInfo *)info;

- (void)configureWithFundInfo:(QMBuyedProductInfo *)info;

@end
