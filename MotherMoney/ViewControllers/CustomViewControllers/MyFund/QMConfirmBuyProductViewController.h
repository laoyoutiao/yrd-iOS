//
//  QMConfirmBuyProductViewController.h
//  MotherMoney

#import "QMViewController.h"
#import "QMAlertView.h"

@interface QMConfirmBuyProductViewController : QMViewController
@property (nonatomic,strong) QMAlertView *payAlertView;

- (id)initViewControllerWithProductOrder:(QMOrderModel *)model;

@end
