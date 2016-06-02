//
//  QMSetPayPasswordViewController.m
//  MotherMoney
//

#import "QMSetPayPasswordViewController.h"

@interface QMSetPayPasswordViewController ()

@end

@implementation QMSetPayPasswordViewController {
    UITextField *cardIdField;
    UITextField *confirmCardIdField;
    
    UIButton *setBtn;
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

- (void)viewDidLoad {
    [super viewDidLoad];

    [self customSubViews];
}

- (void)handleTextDidChangeNotification:(NSNotification *)noti {
    NSString *pwd1 = [[cardIdField text] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *pwd2 = [[confirmCardIdField text] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if (!QM_IS_STR_NIL(pwd1) && !QM_IS_STR_NIL(pwd2)) {
        [setBtn setEnabled:YES];
    }else {
        [setBtn setEnabled:NO];
    }
}

- (void)setPayPasswordBtnClicked:(id)sender {
    NSString *pwd1 = [[cardIdField text] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *pwd2 = [[confirmCardIdField text] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (![pwd1 isEqualToString:pwd2]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:QMLocalizedString(@"qm_check_update_alert_title", @"提示")
                                                            message:QMLocalizedString(@"qm_pay_password_not_equal", @"两次输入的密码不一致，请重新输入")
                                                           delegate:nil
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:QMLocalizedString(@"qm_ok_alert_btn_title", @"确定"), nil];
        [alertView show];
        return;
    }
    
    [[NetServiceManager sharedInstance] setPayPassword:pwd1
                                              delegate:self
                                               success:^(id responseObject) {
                                                   [self handleSetSuccess:responseObject];
                                               } failure:^(NSError *error) {
                                                   [self handleSetFailure:error];
                                               }];
}

- (NSString *)payPassword {
    NSString *pwd2 = [[confirmCardIdField text] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    return pwd2;
}

- (void)handleSetSuccess:(id)responseObject {
    [CMMUtility showNote:@"设置成功"];
    [self goBack];
    
    if (QM_IS_DELEGATE_RSP_SEL(self.delegate, payPasswordViewController:didSetPayPassword:)) {
        [self.delegate payPasswordViewController:self didSetPayPassword:[self payPassword]];
    }
}

- (void)handleSetFailure:(NSError *)error {
    [CMMUtility showNoteWithError:error];
}

- (void)customSubViews {
    UIImage *image = [QMImageFactory commonScaledFullScreenBackgroundImage];
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:image];
    backgroundImageView.contentMode = UIViewContentModeBottom;
    backgroundImageView.clipsToBounds = YES;
    backgroundImageView.frame = self.view.bounds;
    backgroundImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:backgroundImageView];
    
    // 支付密码
    cardIdField = [[UITextField alloc] initWithFrame:CGRectMake(15, 20, CGRectGetWidth(self.view.frame) - 2 * 15, 35)];
    [cardIdField setBackground:[QMImageFactory commonBackgroundImage]];
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, CGRectGetHeight(cardIdField.frame))];
    cardIdField.leftView = leftView;
    cardIdField.secureTextEntry = YES;
    cardIdField.keyboardType = UIKeyboardTypeNumberPad;
    cardIdField.placeholder = QMLocalizedString(@"qm_input_pay_password", @"请输入支付密码");
    cardIdField.leftViewMode = UITextFieldViewModeAlways;
    [self.view addSubview:cardIdField];
    
    // 身份证号
    confirmCardIdField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMinX(cardIdField.frame), CGRectGetMaxY(cardIdField.frame) + 10, CGRectGetWidth(cardIdField.frame), CGRectGetHeight(cardIdField.frame))];
    leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, CGRectGetHeight(cardIdField.frame))];
    [confirmCardIdField setBackground:[QMImageFactory commonBackgroundImage]];
    confirmCardIdField.leftView = leftView;
    confirmCardIdField.secureTextEntry = YES;
    confirmCardIdField.keyboardType = UIKeyboardTypeNumberPad;
    confirmCardIdField.leftViewMode = UITextFieldViewModeAlways;
    confirmCardIdField.placeholder = QMLocalizedString(@"qm_input_pay_password_confirm", @"请再次输入支付密码");
    [self.view addSubview:confirmCardIdField];
    
    setBtn = [QMControlFactory commonButtonWithSize:CGSizeMake(CGRectGetWidth(confirmCardIdField.frame), 40.0f) title:QMLocalizedString(@"qm_pay_password_set", @"设置")
                                                  target:self
                                                selector:@selector(setPayPasswordBtnClicked:)];
    CGRect frame = confirmCardIdField.frame;
    frame.origin = CGPointMake(CGRectGetMinX(confirmCardIdField.frame), CGRectGetMaxY(confirmCardIdField.frame) + 30);
    setBtn.frame = frame;
    [self.view addSubview:setBtn];
}

@end
