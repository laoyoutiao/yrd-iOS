//
//  QMResetPasswordViewController.m
//  MotherMoney

#import "QMResetPasswordViewController.h"

@interface QMResetPasswordViewController ()

@end

@implementation QMResetPasswordViewController {
    UITextField *oldPwdField;
    UITextField *newPwdField;
    UITextField *confirmPwdField;
    
    UIButton *resetBtn;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = QM_COMMON_BACKGROUND_COLOR;
    // Do any additional setup after loading the view.
    
    [self setUpSubViews];
}

- (UIBarButtonItem *)leftBarButtonItem {
    return [QMNavigationBarItemFactory createNavigationBackItemWithTarget:self selector:@selector(goBack)];
}

- (void)goBack {
    if (self.isModel) {
        [self dismissViewControllerAnimated:YES
                                 completion:^{
                                     
                                 }];
    }else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)setUpSubViews {
    oldPwdField = [[UITextField alloc] initWithFrame:CGRectMake(10, 20, CGRectGetWidth(self.view.frame) - 2 * 10, 35)];
    oldPwdField.textColor = QM_COMMON_TEXT_COLOR;
    oldPwdField.secureTextEntry = YES;
    [oldPwdField setBackground:[QMImageFactory commonBackgroundImage]];
    oldPwdField.font = [UIFont systemFontOfSize:13];
    oldPwdField.placeholder = QMLocalizedString(@"qm_input_initial_pwd", @"请输入密码");
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, CGRectGetHeight(oldPwdField.frame))];
    oldPwdField.leftView = leftView;
    oldPwdField.leftViewMode = UITextFieldViewModeAlways;
    [self.view addSubview:oldPwdField];
    
    newPwdField = [[UITextField alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(oldPwdField.frame) + 5, CGRectGetWidth(self.view.frame) - 2 * 10, 35)];
    newPwdField.textColor = QM_COMMON_TEXT_COLOR;
    newPwdField.secureTextEntry = YES;
    [newPwdField setBackground:[QMImageFactory commonBackgroundImage]];
    newPwdField.font = [UIFont systemFontOfSize:13];
    newPwdField.placeholder = QMLocalizedString(@"qm_input_new_pwd", @"请输入新密码");
    
    leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, CGRectGetHeight(newPwdField.frame))];
    newPwdField.leftView = leftView;
    newPwdField.leftViewMode = UITextFieldViewModeAlways;
    [self.view addSubview:newPwdField];
    
    confirmPwdField = [[UITextField alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(newPwdField.frame) + 5, CGRectGetWidth(self.view.frame) - 2 * 10, 35)];
    confirmPwdField.textColor = QM_COMMON_TEXT_COLOR;
    confirmPwdField.secureTextEntry = YES;
    [confirmPwdField setBackground:[QMImageFactory commonBackgroundImage]];
    confirmPwdField.font = [UIFont systemFontOfSize:13];
    confirmPwdField.placeholder = QMLocalizedString(@"qm_input_new_pwd_again", @"请再次输入密码");
    
    leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, CGRectGetHeight(newPwdField.frame))];
    confirmPwdField.leftView = leftView;
    confirmPwdField.leftViewMode = UITextFieldViewModeAlways;
    [self.view addSubview:confirmPwdField];

    resetBtn = [QMControlFactory commonButtonWithSize:CGSizeMake(CGRectGetWidth(confirmPwdField.frame), 40) title:QMLocalizedString(@"qm_confirm_btn_title", @"确认") target:self selector:@selector(resetPwdBtnClicked:)];
    CGRect frame = resetBtn.frame;
    frame.origin = CGPointMake(CGRectGetMinX(confirmPwdField.frame), CGRectGetMaxY(confirmPwdField.frame) + 20);
    resetBtn.frame = frame;
    [self.view addSubview:resetBtn];
}

- (void)resetPwdBtnClicked:(id)sender {
    NSString *oldPwd = [self getPwdString];
    NSString *newPwd = [self getNewPwdString];
    NSString *confirmPwd = [self getConfirmPwdString];
    
    if (![newPwd isEqualToString:confirmPwd]) {
        [CMMUtility showNote:QMLocalizedString(@"qm_pay_password_not_equal", @"两次输入的密码不一致，请重新输入")];
        return;
    }

    if (newPwd.length<6||newPwd.length>12||confirmPwd.length<6||confirmPwd.length>12) {
        [CMMUtility showNote:@"请输入6-12位密码"];
        return;
    }
    
    [[NetServiceManager sharedInstance] resetPasswordWithOldPwd:oldPwd
                                                    newPassword:newPwd
                                                       delegate:self
                                                        success:^(id responseObject) {
                                                            // 重置成功
                                                            // 修改本地存储的内容
                                                            QMAccountInfo *curAccount = [QMAccountUtil sharedInstance].currentAccount;
                                                            curAccount.password = [self getPwdString];
                                                            [[QMAccountUtil sharedInstance] saveCurrentAccountInfo];
                                                            
                                                            if (QM_IS_DELEGATE_RSP_SEL(self.delegate, passwordDidResetSuccess:)) {
                                                                [self.delegate passwordDidResetSuccess:self];
                                                                [CMMUtility showNote:QMLocalizedString(@"qm_account_center_change_pwd_success", @"修改成功")];
                                                                
                                                            }
                                                        } failure:^(NSError *error) {
                                                            // 重置失败
                                                            [CMMUtility showNoteWithError:error];
                                                        }];
}

- (NSString *)getPwdString {
    return [oldPwdField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

- (NSString *)getNewPwdString {
    return [newPwdField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

- (NSString *)getConfirmPwdString {
    return [confirmPwdField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

#pragma mark -
#pragma mark Override
- (NSString *)title {
    return QMLocalizedString(@"qm_account_center_modify_login_pwd", @"修改登录密码");
}

@end
