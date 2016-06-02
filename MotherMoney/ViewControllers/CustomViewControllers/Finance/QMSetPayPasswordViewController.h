//
//  QMSetPayPasswordViewController.h
//  MotherMoney
//

#import "QMViewController.h"

@protocol QMSetPayPasswordViewControllerDelegate;
@interface QMSetPayPasswordViewController : QMViewController
@property (nonatomic, assign) BOOL isModel;
@property (nonatomic, weak) id<QMSetPayPasswordViewControllerDelegate> delegate;

@end

@protocol QMSetPayPasswordViewControllerDelegate <NSObject>

- (void)payPasswordViewController:(QMSetPayPasswordViewController *)controller didSetPayPassword:(NSString *)payPassword;

@end
