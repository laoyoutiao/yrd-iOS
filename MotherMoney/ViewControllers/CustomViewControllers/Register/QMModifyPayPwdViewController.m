//
//  QMModifyPayPwdViewController.m
//  MotherMoney
//

#import "QMModifyPayPwdViewController.h"

@interface QMModifyPayPwdViewController ()

@end

@implementation QMModifyPayPwdViewController {
    UITextField *oldPayPwdField;
    UITextField *newPayPwdField;
    UITextField *confirmPayPwdField;
    
    UIButton *modifyBtn;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self customSubViews];
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

- (void)handleTextDidChangeNotification:(NSNotification *)noti {
    NSString *pwd1 = [[newPayPwdField text] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *pwd2 = [[confirmPayPwdField text] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    NSString *oldPwd = [[oldPayPwdField text] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if (!QM_IS_STR_NIL(pwd1) && !QM_IS_STR_NIL(pwd2) && !QM_IS_STR_NIL(oldPwd)) {
        [modifyBtn setEnabled:YES];
    }else {
        [modifyBtn setEnabled:NO];
    }
}

- (void)setPayPasswordBtnClicked:(id)sender {
    NSString *oldPwd = [[oldPayPwdField text] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if (QM_IS_STR_NIL(oldPwd)) { // 输入初始支付密码
        [CMMUtility showNote:QMLocalizedString(@"qm_input_old_pay_pwd", @"请输入旧的支付密码")];
        return;
    }
    
    NSString *pwd1 = [[newPayPwdField text] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *pwd2 = [[confirmPayPwdField text] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if (QM_IS_STR_NIL(pwd1)) { // 输入新的支付密码
        [CMMUtility showNote:QMLocalizedString(@"qm_input_new_pay_pwd", @"请输入新的支付密码")];
        return;
    }
    
    if (QM_IS_STR_NIL(pwd2)) { // 再次输入新的支付密码
        [CMMUtility showNote:QMLocalizedString(@"qm_input_new_pay_pwd_again", @"请再次输入新的支付密码")];
        return;
    }
    
    if (![pwd1 isEqualToString:pwd2]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:QMLocalizedString(@"qm_check_update_alert_title", @"提示")
                                                            message:QMLocalizedString(@"qm_pay_password_not_equal", @"两次输入的密码不一致，请重新输入")
                                                           delegate:nil
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:QMLocalizedString(@"qm_ok_alert_btn_title", @"确定"), nil];
        [alertView show];
        return;
    }
    
    [[NetServiceManager sharedInstance] modifyPayPwdWithOldPwd:oldPwd
                                                newPayPassword:pwd1
                                                      delegate:self
                                                       success:^(id responseObject) {
                                                           [self handleSetSuccess:responseObject];
                                                       } failure:^(NSError *error) {
                                                           [self handleSetFailure:error];
                                                       }];
}

- (void)customSubViews {
    UIImage *image = [QMImageFactory commonScaledFullScreenBackgroundImage];
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:image];
    backgroundImageView.contentMode = UIViewContentModeBottom;
    backgroundImageView.clipsToBounds = YES;
    backgroundImageView.frame = self.view.bounds;
    backgroundImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:backgroundImageView];
    
    // 旧的支付密码
    oldPayPwdField = [[UITextField alloc] initWithFrame:CGRectMake(15, 20, CGRectGetWidth(self.view.frame) - 2 * 15, 35)];
    [oldPayPwdField setBackground:[QMImageFactory commonBackgroundImage]];
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, CGRectGetHeight(oldPayPwdField.frame))];
    oldPayPwdField.leftView = leftView;
    oldPayPwdField.secureTextEntry = YES;
    oldPayPwdField.keyboardType = UIKeyboardTypeNumberPad;
    oldPayPwdField.placeholder = QMLocalizedString(@"qm_input_old_pay_password", @"请输入旧的支付密码");
    oldPayPwdField.leftViewMode = UITextFieldViewModeAlways;
    [self.view addSubview:oldPayPwdField];
    
    // 支付密码
    newPayPwdField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMinX(oldPayPwdField.frame), CGRectGetMaxY(oldPayPwdField.frame) + 10, CGRectGetWidth(oldPayPwdField.frame), CGRectGetHeight(oldPayPwdField.frame))];
    [newPayPwdField setBackground:[QMImageFactory commonBackgroundImage]];
    leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, CGRectGetHeight(newPayPwdField.frame))];
    newPayPwdField.leftView = leftView;
    newPayPwdField.secureTextEntry = YES;
    newPayPwdField.keyboardType = UIKeyboardTypeNumberPad;
    newPayPwdField.placeholder = QMLocalizedString(@"qm_input_pay_password", @"请输入支付密码");
    newPayPwdField.leftViewMode = UITextFieldViewModeAlways;
    [self.view addSubview:newPayPwdField];
    
    // 身份证号
    confirmPayPwdField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMinX(newPayPwdField.frame), CGRectGetMaxY(newPayPwdField.frame) + 10, CGRectGetWidth(newPayPwdField.frame), CGRectGetHeight(newPayPwdField.frame))];
    leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, CGRectGetHeight(newPayPwdField.frame))];
    [confirmPayPwdField setBackground:[QMImageFactory commonBackgroundImage]];
    confirmPayPwdField.leftView = leftView;
    confirmPayPwdField.secureTextEntry = YES;
    confirmPayPwdField.keyboardType = UIKeyboardTypeNumberPad;
    confirmPayPwdField.leftViewMode = UITextFieldViewModeAlways;
    confirmPayPwdField.placeholder = QMLocalizedString(@"qm_input_pay_password_confirm", @"请再次输入支付密码");
    [self.view addSubview:confirmPayPwdField];
    modifyBtn = [QMControlFactory commonButtonWithSize:CGSizeMake(CGRectGetWidth(confirmPayPwdField.frame), 40.0f) title:QMLocalizedString(@"qm_modify_pay_password_btn_title", @"确定")
                                             target:self
                                           selector:@selector(setPayPasswordBtnClicked:)];
    CGRect frame = confirmPayPwdField.frame;
    frame.origin = CGPointMake(CGRectGetMinX(confirmPayPwdField.frame), CGRectGetMaxY(confirmPayPwdField.frame) + 30);
    modifyBtn.frame = frame;
    [self.view addSubview:modifyBtn];
}

- (NSString *)payPassword {
    NSString *pwd2 = [[confirmPayPwdField text] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    return pwd2;
}

- (void)handleSetSuccess:(id)responseObject {
    [self goBack];
    
    [self performSelector:@selector(showSuccessMessage) withObject:self afterDelay:0.2f];
    
    if (QM_IS_DELEGATE_RSP_SEL(self.delegate, modifyPayPwdViewControllerDidResetPayPasswordSuccess:)) {
        [self.delegate modifyPayPwdViewControllerDidResetPayPasswordSuccess:self];
    }
}

- (void)showSuccessMessage {
    [CMMUtility showSuccessMessage:QMLocalizedString(@"qm_pay_pwd_modify_success", @"支付密码修改成功")];
}

- (void)handleSetFailure:(NSError *)error {
    [CMMUtility showNoteWithError:error];
}

@end

