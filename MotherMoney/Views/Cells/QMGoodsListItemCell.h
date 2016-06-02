//
//  QMGoodsListItemCell.h
//  MotherMoney
//

#import <UIKit/UIKit.h>
#import "QMGoodsListItem.h"

@interface QMGoodsListItemCell : UICollectionViewCell
@property (nonatomic, strong) UIButton *exchangeGoodBtn;
@property (nonatomic, strong) QMGoodsListItem *goodsItem;
@property (nonatomic, strong) UIImageView *prizeIcon;

+ (CGFloat)getGoodsItemCellHeightWithGoodsListItem:(QMGoodsListItem *)item;

- (void)configureCellWithGoodsListItem:(QMGoodsListItem *)item;

@end
