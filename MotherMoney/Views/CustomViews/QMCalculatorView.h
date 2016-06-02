//
//  QMCalculatorView.h
//  MotherMoney
//

#import <UIKit/UIKit.h>
#import "QMProductInfo.h"

// 计算器
@interface QMCalculatorView : UIView

- (id)initWithFrame:(CGRect)frame andProductInfo:(QMProductInfo *)info;

- (void)show;

- (void)hide;

@end
