//
//  QMResetPasswordViewController.h
//  MotherMoney


#import "QMViewController.h"

@protocol QMResetPasswordViewControllerDelegate;
@interface QMResetPasswordViewController : QMViewController
@property (nonatomic, assign) BOOL isModel;
@property (nonatomic, weak) id<QMResetPasswordViewControllerDelegate> delegate;

@end

@protocol QMResetPasswordViewControllerDelegate <NSObject>

- (void)passwordDidResetSuccess:(QMResetPasswordViewController *)controller;

@end
