//
//  QMSelectBankViewController.h
//  MotherMoney
//

#import "QMSelectItemViewController.h"
#import "QMOrderModel.h"
//添加银行
@interface QMAddBankViewController : QMSelectItemViewController

- (id)initViewControllerWithProduct:(QMOrderModel *)order;

@end
