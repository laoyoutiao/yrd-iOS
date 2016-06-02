//
//  QMBuyedProductRecordInfoHeaderView.h
//  MotherMoney

#import <UIKit/UIKit.h>

@interface QMBuyedProductRecordInfoHeaderView : UICollectionReusableView

@property (nonatomic, strong) UILabel *productNameLabel;
@property (nonatomic, strong) UILabel *principalLabel;
@property (nonatomic, strong) UILabel *earningsLabel;
@property (nonatomic, strong) UILabel *bankCardLabel;

+ (CGFloat)getProductInfoHeaderHeight;

@end
