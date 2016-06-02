//
//  QMAlertView.h
//  MotherMoney
//

#import <UIKit/UIKit.h>
#import "QMPayPwdView.h"

@protocol QMAlertViewDelegate <NSObject>

- (void)alertForgetPwd;
- (void)alertConfirmCheckWithPwd:(NSString *)pwd;

@optional
- (void)userCancelTransAction;

@end

@interface QMAlertView : UIView <UITextFieldDelegate, UIAlertViewDelegate> {
    BOOL isVisible;
}
@property (nonatomic, weak) id<QMAlertViewDelegate> delegate;

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIView *alertView;

@property (nonatomic, strong) UITextField *payTextField;
@property (nonatomic, strong) QMPayPwdView *payPwdView;

@property (nonatomic, strong) UIButton *confirmButton;
@property (nonatomic, strong) UIButton *forgetButton;

@property (nonatomic, strong) UILabel *tipLabel;

@property (nonatomic, assign, readonly) BOOL isVisible;

// 清除密码
- (void)clearTextField;

// show
- (void)show;
- (void)dismiss;

- (void)showErrorMSG:(NSString *)msg;
- (void)clearErrorMSG;

@end
