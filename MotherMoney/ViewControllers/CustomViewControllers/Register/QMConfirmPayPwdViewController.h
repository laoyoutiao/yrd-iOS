//
//  QMConfirmPayPwdViewController.h
//  MotherMoney

#import "QMViewController.h"

@protocol QMConfirmPayPwdViewControllerDelegate;
@interface QMConfirmPayPwdViewController : QMViewController
@property (nonatomic, weak) id<QMConfirmPayPwdViewControllerDelegate> delegate;
@property (nonatomic, assign) BOOL isModel;
@property (nonatomic, assign) BOOL isModify;

- (id)initViewControllerWithPhoneNumber:(NSString *)phoneNumber passCode:(NSString *)passCode;

@end

@protocol QMConfirmPayPwdViewControllerDelegate <NSObject>

- (void)confirmPayPwdViewControllerDidResetPayPasswordSuccess:(QMConfirmPayPwdViewController *)controller;

@end
