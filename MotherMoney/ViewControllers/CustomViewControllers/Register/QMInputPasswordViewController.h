//
//  QMInputPasswordViewController.h
//  MotherMoney
//

#import "QMViewController.h"
#import "QMAccountInfo.h"

@protocol QMInputPasswordViewControllerDelegate;
@interface QMInputPasswordViewController : QMViewController <UIGestureRecognizerDelegate>
@property (nonatomic, assign) BOOL isModel;
@property (nonatomic, assign) BOOL showBackBtn;
@property (nonatomic, weak) id<QMInputPasswordViewControllerDelegate> delegate;

- (id)initViewControllerWithAccountInfo:(QMAccountInfo *)info shouldShowSwitch:(BOOL)shouldSwitch;

@end


@protocol QMInputPasswordViewControllerDelegate <NSObject>

- (void)passwordViewControllerDidLoginSuccess:(QMInputPasswordViewController *)viewController;
- (void)passwordViewControllerDidLoginFailed:(QMInputPasswordViewController *)viewController;
@end
