//
//  QMProductIntroductionCellHeader.h
//  MotherMoney
//

#import <UIKit/UIKit.h>
#import "QMProductIntroductionModel.h"

@interface QMProductIntroductionCellHeader : UICollectionReusableView

+ (CGSize)getHeaderSizeWithWindControlModel:(QMProductIntroductionModel *)model;

- (void)configureHeaderWithWindControlModel:(QMProductIntroductionModel *)model;

@end
