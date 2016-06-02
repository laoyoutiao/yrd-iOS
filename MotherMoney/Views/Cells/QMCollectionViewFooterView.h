//
//  QMCollectionViewFooterView.h
//  MotherMoney

#import <UIKit/UIKit.h>
#import "QMPageFooterView.h"
#import "QMBuyedProductResolveModel.h"
@interface QMCollectionViewFooterView : UICollectionReusableView
@property (nonatomic, strong) QMPageFooterView *pageFooterView;
+(BOOL)isProductBuyRecordSuccessful:(QMBuyedProductResolveModel *)model;
@end
