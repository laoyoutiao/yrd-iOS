//
//  QMSelectLocationViewController.h
//  MotherMoney


#import "QMSelectItemViewController.h"

typedef enum {
    QMSelectLocationType_Province = 0,
    QMSelectLocationType_City
}QMSelectLocationType;

@interface QMSelectLocationViewController : QMSelectItemViewController
@property (nonatomic, assign) QMSelectLocationType currentType;

- (id)initViewControllerWithItems:(NSArray *)originItems type:(QMSelectLocationType)type;

@end
