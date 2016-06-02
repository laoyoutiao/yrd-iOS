//
//  QMMyProductBuyRecordCell.h
//  MotherMoney
//

#import <UIKit/UIKit.h>
#import "QMBuyedProductResolveModel.h"

@interface QMMyProductBuyRecordCell : UICollectionViewCell
@property (nonatomic,strong)UIScrollView* scrollView;
@property (nonatomic,strong)UIPageControl* pageControl;
@property (nonatomic,strong) NSArray* productResolves;
@property (nonatomic,strong)UIViewController* controller;
+ (CGFloat)getCellHeightForProductInfo:(QMBuyedProductResolveModel *)info;

+ (BOOL)isProductBuyRecordSuccessful:(QMBuyedProductResolveModel *)model;
-(void)configureBuyedProductResolves:(NSArray*)productResolves;
-(void)configureCurrentController:(UIViewController*)controller;
@end
