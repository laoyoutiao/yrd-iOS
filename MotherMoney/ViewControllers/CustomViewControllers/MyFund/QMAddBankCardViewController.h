//
//  QMAddBankCardViewController.h
//  MotherMoney
//

#import "QMViewController.h"

@interface QMAddBankCardViewController : QMViewController
@property (nonatomic, assign) BOOL isModel;

- (id)initViewControllerWithOrder:(QMOrderModel *)model;

@end
