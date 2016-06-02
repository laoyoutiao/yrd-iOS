//
//  QMProductImageCell.h
//  MotherMoney
//

#import <UIKit/UIKit.h>
#import "QMProductImageItemModel.h"

extern NSString *const PRODUCTIMAGECELL_IMAGE_DOWNLOAD_SUCCESS;

@interface QMProductImageCell : UICollectionViewCell

+ (CGSize)getCellSizeWithProductImageItem:(QMProductImageItemModel *)model isLastOne:(BOOL)lastOne;

- (void)configureCellWithProductImageItem:(QMProductImageItemModel *)model isLastOne:(BOOL)lastOne;

@end
