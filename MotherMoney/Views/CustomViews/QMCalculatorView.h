//
//  QMCalculatorView.h
//  MotherMoney
//

#import <UIKit/UIKit.h>
#import "QMProductInfo.h"
#import "QMCreditorsInfo.h"
// 计算器
@interface QMCalculatorView : UIView

- (id)initWithFrame:(CGRect)frame andProductInfo:(QMProductInfo *)info;

- (id)initWithFrame:(CGRect)frame andCreditorsInfo:(QMCreditorsInfo *)info;

- (void)show;

- (void)hide;

@end
