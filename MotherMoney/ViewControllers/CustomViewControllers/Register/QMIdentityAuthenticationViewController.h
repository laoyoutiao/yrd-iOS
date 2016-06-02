//
//  QMIdentityAuthenticationViewController.h
//  MotherMoney
//

//

#import "QMViewController.h"

@protocol QMIdentityAuthenticationViewControllerDelegate;
@interface QMIdentityAuthenticationViewController : QMViewController
@property (nonatomic, assign) BOOL isModel;
@property (nonatomic, weak) id<QMIdentityAuthenticationViewControllerDelegate> delegate;

@end

@protocol QMIdentityAuthenticationViewControllerDelegate <NSObject>

- (void)authenticationViewController:(QMIdentityAuthenticationViewController *)controller didAuthenticateWithRealName:(NSString *)realName idCard:(NSString *)idCard;

@end
