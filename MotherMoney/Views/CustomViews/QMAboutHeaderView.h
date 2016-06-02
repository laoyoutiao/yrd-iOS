//
//  QMAboutHeaderView.h
//  MotherMoney
//

#import <UIKit/UIKit.h>

@interface QMAboutHeaderView : UICollectionReusableView
@property (nonatomic, strong) NSString *aboutInfo;


+ (CGSize)sizeForHeaderView:(NSString *)info;

@end
