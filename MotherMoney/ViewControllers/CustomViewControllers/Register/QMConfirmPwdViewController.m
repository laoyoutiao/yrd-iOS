//
//  QMConfirmPwdViewController.m
//  MotherMoney
//

#import "QMConfirmPwdViewController.h"
#import "QMGestureWindow.h"
#import "QMInputPasswordViewController.h"
#import "QMPersonalCenterViewController.h"

@interface QMConfirmPwdViewController ()

@end

@implementation QMConfirmPwdViewController {
    NSString *strPhoneNumber;
    NSString *strPassCode;
    
    UILabel *promptLabel;
    UITextField *passWordField;
    UITextField *confirmPwdField;
    
    UIButton *finishBtn;
}

- (id)initViewControllerWithPhoneNumber:(NSString *)phoneNumber passCode:(NSString *)passCode {
    if (self = [super init]) {
        strPassCode = passCode;
        strPhoneNumber = phoneNumber;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self customSubViews];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleTextFieldTextDidChangeNotification:) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)customSubViews {
    UIImage *image = [QMImageFactory commonScaledFullScreenBackgroundImage];
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:image];
    backgroundImageView.contentMode = UIViewContentModeBottom;
    backgroundImageView.clipsToBounds = YES;
    backgroundImageView.frame = self.view.bounds;
    backgroundImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:backgroundImageView];
    
    // prompt
    promptLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 30, CGRectGetWidth(self.view.frame) - 2 * 15, 20)];
    promptLabel.font = [UIFont systemFontOfSize:14];
    promptLabel.textColor = [UIColor whiteColor];
    promptLabel.text = QMLocalizedString(@"qm_reset_pwd_text", @"重设密码");
    [self.view addSubview:promptLabel];
    
    // password field
    passWordField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMinX(promptLabel.frame), CGRectGetMaxY(promptLabel.frame), CGRectGetWidth(promptLabel.frame), 35)];
    passWordField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    passWordField.textColor = QM_COMMON_TEXT_COLOR;
    passWordField.secureTextEntry = YES;
    [passWordField setBackground:[QMImageFactory commonBackgroundImage]];
    passWordField.font = [UIFont systemFontOfSize:13];
    passWordField.placeholder = QMLocalizedString(@"qm_input_pwd_text", @"请输入6-12位密码");
    
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, CGRectGetHeight(passWordField.frame))];
    passWordField.leftView = leftView;
    passWordField.leftViewMode = UITextFieldViewModeAlways;
    [self.view addSubview:passWordField];
    
    confirmPwdField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMinX(passWordField.frame), CGRectGetMaxY(passWordField.frame) + 10, CGRectGetWidth(promptLabel.frame), 35)];
    confirmPwdField.secureTextEntry = YES;
    confirmPwdField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    confirmPwdField.textColor = QM_COMMON_TEXT_COLOR;
    [confirmPwdField setBackground:[QMImageFactory commonBackgroundImage]];
    confirmPwdField.font = [UIFont systemFontOfSize:13];
    confirmPwdField.placeholder = QMLocalizedString(@"qm_input_confirm_pwd_text", @"请再次输入密码");
    
    leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, CGRectGetHeight(confirmPwdField.frame))];
    confirmPwdField.leftView = leftView;
    confirmPwdField.leftViewMode = UITextFieldViewModeAlways;
    [self.view addSubview:confirmPwdField];
    
    finishBtn = [QMControlFactory commonBorderedButtonWithSize:passWordField.frame.size title:QMLocalizedString(@"qm_finish_btn_title", @"完成") target:self selector:@selector(finishBtnClicked:)];
    CGRect frame = finishBtn.frame;
    frame.origin = CGPointMake(CGRectGetMinX(confirmPwdField.frame), CGRectGetMaxY(confirmPwdField.frame) + 30);
    finishBtn.frame = frame;
    [self.view addSubview:finishBtn];
    [self updateFinishBtnState];
}

- (void)updateFinishBtnState {
    if (!QM_IS_STR_NIL(passWordField.text) && !QM_IS_STR_NIL(confirmPwdField.text)) {
        finishBtn.enabled = YES;
    }else {
        finishBtn.enabled = NO;
    }
}

- (void)finishBtnClicked:(id)sender {
    if (![[passWordField text] isEqualToString:[confirmPwdField text]]) {
        [CMMUtility showNote:QMLocalizedString(@"qm_password_not_equal", @"两次密码不一致")];
        return;
    }
    
    [[NetServiceManager sharedInstance] resetPwsswordWithPhoneNumber:strPhoneNumber
                                                            passCode:strPassCode
                                                            passWord:[passWordField text]
                                                            delegate:self success:^(id responseObject) {
                                                                [self handleResetPasswordSuccess:responseObject];
                                                            } failure:^(NSError *error) {
                                                                [self handleResetPasswordFailure:error];
                                                            }];
}

- (void)handleResetPasswordSuccess:(id)responseObject {
    // 保存密码信息
    
    // 回到
    NSArray *viewControllers = [self.navigationController viewControllers];
    for (UIViewController *con in viewControllers) {
        if ([con isKindOfClass:[QMInputPasswordViewController class]]) {
            [self.navigationController popToViewController:con animated:YES];
            // 提示设置成功
            [CMMUtility showNote:QMLocalizedString(@"qm_password_reset_success", @"密码设置成功")];
        }
    }
    
    // 没有找到
    for (UIViewController *con in viewControllers) {
        if ([con isKindOfClass:[QMPersonalCenterViewController class]]) {
            // 提示设置成功
            [self.navigationController popToViewController:con animated:YES];
            [CMMUtility showNote:QMLocalizedString(@"qm_password_reset_success", @"密码设置成功")];
        }
    }
}

- (void)handleResetPasswordFailure:(NSError *)error {
    [CMMUtility showNoteWithError:error];
}

- (void)handleTextFieldTextDidChangeNotification:(NSNotification *)noti {
    [self updateFinishBtnState];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
}

#pragma mark -
#pragma mark Override
- (NSString *)title {
    return QMLocalizedString(@"qm_register_forget_password_btn_title", @"忘记密码");
}

@end
