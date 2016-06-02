//
//  QMProductBuyResultViewController.h
//  MotherMoney

#import "QMViewController.h"

@interface QMProductBuyResultViewController : QMViewController

- (id)initViewControllerWithOrder:(QMOrderModel *)order result:(NSError *)error;

@end
