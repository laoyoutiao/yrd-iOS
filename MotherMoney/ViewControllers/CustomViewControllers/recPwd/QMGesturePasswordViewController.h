//
//  QMGesturePasswordViewController.h
//  MotherMoney
//

#import "QMViewController.h"
#import "NineGridUnlockView.h"

@protocol QMGesturePasswordViewControllerDelegate;
@interface QMGesturePasswordViewController : QMViewController
@property (nonatomic, weak) id<QMGesturePasswordViewControllerDelegate> delegate;
@property (nonatomic, strong) UIButton *otherAccountBt;
@property (nonatomic, strong) UIButton *forgetBt;

@end


@protocol QMGesturePasswordViewControllerDelegate <NSObject>

- (void)gesturePasswordViewControllerDidSuccess:(QMGesturePasswordViewController *)viewController;

- (void)gesturePasswordViewControllerDidFailed:(QMGesturePasswordViewController *)viewController;

@end


