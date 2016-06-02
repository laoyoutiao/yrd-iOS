//
//  QMModifyPayPwdViewController.h
//  MotherMoney
//

#import "QMViewController.h"

@protocol QMModifyPayPwdViewControllerDelegate;
@interface QMModifyPayPwdViewController : QMViewController
@property (nonatomic, weak) id<QMModifyPayPwdViewControllerDelegate> delegate;
@property (nonatomic, assign) BOOL isModel;

@end

@protocol QMModifyPayPwdViewControllerDelegate <NSObject>

- (void)modifyPayPwdViewControllerDidResetPayPasswordSuccess:(QMModifyPayPwdViewController *)controller;

@end
