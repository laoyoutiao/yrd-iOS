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
@property (assign, nonatomic) BOOL haveDefaultMessage;
@property (nonatomic, strong) NSString *userRealName;
@property (nonatomic, strong) NSString *userIdCard;
@property (nonatomic, assign) BOOL isOpenAccount;
@property (nonatomic, assign) BOOL isActivationAccount;
@property (nonatomic, assign) BOOL isChangeBandCard;
@end

@protocol QMIdentityAuthenticationViewControllerDelegate <NSObject>

- (void)authenticationViewController:(QMIdentityAuthenticationViewController *)controller didAuthenticateWithRealName:(NSString *)realName idCard:(NSString *)idCard;

@end
