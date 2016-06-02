//
//  QMWindControlHeaderCellHeader.h
//  MotherMoney
//

#import <UIKit/UIKit.h>
#import "QMProductWindControlModel.h"

@interface QMWindControlHeaderCellHeader : UICollectionReusableView

+ (CGSize)getHeaderSizeWithWindControlModel:(QMProductWindControlModel *)model;

- (void)configureHeaderWithWindControlModel:(QMProductWindControlModel *)model;

@end
