//
//  QMConfirmPayPwdViewController.m
//  MotherMoney

#import "QMConfirmPayPwdViewController.h"

@interface QMConfirmPayPwdViewController ()

@end

@implementation QMConfirmPayPwdViewController {
    NSString *strPhoneNumber;
    NSString *strPassCode;
    
    UITextField *passCodeField;
    UIButton *getPassCodeBtn;
    UILabel *promptLabel;
    UITextField *idCardNumberField;
    UITextField *passWordField;
    UITextField *confirmPwdField;
    
    UIButton *finishBtn;
    
    UIScrollView *containerView;
    
    NSTimer *timeLimitTimer;
    
    NSInteger timeLimit;
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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self registerKeybaordNotification];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self unRegisterKeyboardNotification];
    
    [self invalidateTimer];
}

- (void)handleKeyboardWillShowNotification:(NSNotification *)noti {
    CGRect endRect = [[[noti userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    containerView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - CGRectGetHeight(endRect));
    containerView.contentSize = CGSizeMake(CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
}

- (void)handleKeyboardWillHideNotification:(NSNotification *)noti {
    containerView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
    containerView.contentSize = CGSizeMake(CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
}



- (void)registerKeybaordNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardWillShowNotification:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardWillHideNotification:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)unRegisterKeyboardNotification {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)customSubViews {
    UIImage *image = [QMImageFactory commonScaledFullScreenBackgroundImage];
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:image];
    backgroundImageView.contentMode = UIViewContentModeBottom;
    backgroundImageView.clipsToBounds = YES;
    backgroundImageView.frame = self.view.bounds;
    backgroundImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:backgroundImageView];
    
    containerView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    containerView.alwaysBounceVertical = YES;
    containerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:containerView];
    
    // prompt
    promptLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 30, CGRectGetWidth(self.view.frame) - 2 * 15, 20)];
    promptLabel.font = [UIFont systemFontOfSize:14];
    promptLabel.textColor = [UIColor whiteColor];
    promptLabel.text = QMLocalizedString(@"qm_reset_pwd_text", @"重设密码");
    [containerView addSubview:promptLabel];
    
    // passCode 按钮
    passCodeField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMinX(promptLabel.frame), CGRectGetMaxY(promptLabel.frame) + 10, (CGRectGetWidth(promptLabel.frame) * 2) / 3, 35)];
    passCodeField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    passCodeField.keyboardType = UIKeyboardTypeNumberPad;
    passCodeField.textColor = QM_COMMON_TEXT_COLOR;
    [passCodeField setBackground:[QMImageFactory commonBackgroundImage]];
    passCodeField.font = [UIFont systemFontOfSize:13];
    passCodeField.placeholder = QMLocalizedString(@"qm_input_passcode_placeholder", @"请输入验证码");
    
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, CGRectGetHeight(passCodeField.frame))];
    passCodeField.leftView = leftView;
    passCodeField.leftViewMode = UITextFieldViewModeAlways;
    [containerView addSubview:passCodeField];
    
    // 获取验证码
    getPassCodeBtn = [QMControlFactory commonBorderedButtonWithSize:CGSizeMake(CGRectGetWidth(promptLabel.frame) / 3 - 10, CGRectGetHeight(passCodeField.frame)) title:QMLocalizedString(@"qm_get_pass_code_btn_title", @"获取验证码") target:self selector:@selector(getPassCodeBtnClicked:)];
    CGRect frame = getPassCodeBtn.frame;
    frame.origin = CGPointMake(CGRectGetMaxX(passCodeField.frame) + 10, CGRectGetMinY(passCodeField.frame));
    getPassCodeBtn.frame = frame;
    [containerView addSubview:getPassCodeBtn];
    [self updateGetPassCodeBtnState];
    
    // 身份证号码
    idCardNumberField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMinX(passCodeField.frame), CGRectGetMaxY(passCodeField.frame) + 10, CGRectGetWidth(promptLabel.frame), 35)];
    idCardNumberField.keyboardType = UIKeyboardTypeASCIICapable;
    idCardNumberField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    idCardNumberField.textColor = QM_COMMON_TEXT_COLOR;
    [idCardNumberField setBackground:[QMImageFactory commonBackgroundImage]];
    idCardNumberField.font = [UIFont systemFontOfSize:13];
    idCardNumberField.placeholder = QMLocalizedString(@"qm_identify_idcard_field_text", nil);
    
    leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, CGRectGetHeight(passWordField.frame))];
    idCardNumberField.leftView = leftView;
    idCardNumberField.leftViewMode = UITextFieldViewModeAlways;
    [containerView addSubview:idCardNumberField];
    
    
    // password field
    passWordField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMinX(idCardNumberField.frame), CGRectGetMaxY(idCardNumberField.frame) + 10, CGRectGetWidth(idCardNumberField.frame), 35)];
    passWordField.keyboardType = UIKeyboardTypeNumberPad;
    passWordField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    passWordField.textColor = QM_COMMON_TEXT_COLOR;
    passWordField.secureTextEntry = YES;
    [passWordField setBackground:[QMImageFactory commonBackgroundImage]];
    passWordField.font = [UIFont systemFontOfSize:13];
    passWordField.placeholder = QMLocalizedString(@"qm_input_6_pay_pwd", @"请输入6位支付密码");
    
    leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, CGRectGetHeight(passWordField.frame))];
    passWordField.leftView = leftView;
    passWordField.leftViewMode = UITextFieldViewModeAlways;
    [containerView addSubview:passWordField];
    
    confirmPwdField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMinX(passWordField.frame), CGRectGetMaxY(passWordField.frame) + 10, CGRectGetWidth(promptLabel.frame), 35)];
    confirmPwdField.secureTextEntry = YES;
    confirmPwdField.keyboardType = UIKeyboardTypeNumberPad;
    confirmPwdField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    confirmPwdField.textColor = QM_COMMON_TEXT_COLOR;
    [confirmPwdField setBackground:[QMImageFactory commonBackgroundImage]];
    confirmPwdField.font = [UIFont systemFontOfSize:13];
    confirmPwdField.placeholder = QMLocalizedString(@"qm_input_confirm_pwd_text", @"请再次输入密码");
    
    leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, CGRectGetHeight(confirmPwdField.frame))];
    confirmPwdField.leftView = leftView;
    confirmPwdField.leftViewMode = UITextFieldViewModeAlways;
    [containerView addSubview:confirmPwdField];
    
    finishBtn = [QMControlFactory commonBorderedButtonWithSize:passWordField.frame.size title:QMLocalizedString(@"qm_finish_btn_title", @"完成") target:self selector:@selector(finishBtnClicked:)];
    CGRect finishFrame = finishBtn.frame;
    finishFrame.origin = CGPointMake(CGRectGetMinX(confirmPwdField.frame), CGRectGetMaxY(confirmPwdField.frame) + 30);
    finishBtn.frame = finishFrame;
    [containerView addSubview:finishBtn];
    [self updateFinishBtnState];
    [self updateGetPassCodeBtnState];
}

- (void)updateResentPasscodeBtnTitle {
    timeLimit--;
    
    if (timeLimit <= 0) {
        [self invalidateTimer];
        [getPassCodeBtn setTitle:QMLocalizedString(@"qm_resent_passcode_btn_title", @"获取验证码") forState:UIControlStateNormal];
        getPassCodeBtn.userInteractionEnabled = YES;
    }else {
        getPassCodeBtn.userInteractionEnabled = NO;
        [getPassCodeBtn setTitle:[NSString stringWithFormat:QMLocalizedString(@"qm_resent_passcode_time_out", @"剩余%d秒"), timeLimit] forState:UIControlStateNormal];
    }
}

- (void)setUpTimer {
    timeLimit = 60.0f;
    [self invalidateTimer];
    
    timeLimitTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(updateResentPasscodeBtnTitle) userInfo:nil repeats:YES];
}

- (void)invalidateTimer {
    if (timeLimitTimer) {
        [timeLimitTimer invalidate];
        timeLimitTimer = nil;
        
        timeLimit = 0;
        [self updateResentPasscodeBtnTitle];
    }
}

- (void)updateGetPassCodeBtnState {

}

- (void)updateFinishBtnState {
    if (!QM_IS_STR_NIL(passWordField.text) && !QM_IS_STR_NIL(confirmPwdField.text) && !QM_IS_STR_NIL(passCodeField.text) && !QM_IS_STR_NIL(idCardNumberField.text)) {
        finishBtn.enabled = YES;
    }else {
        finishBtn.enabled = NO;
    }
}

- (BOOL)isIDCardValid {
    NSString *idCard = [idCardNumberField text];
    BOOL result = [CMMUtility checkIdNumber:idCard];
    
    return result;
}

- (void)finishBtnClicked:(id)sender {
    if (![self isIDCardValid]) {
        // 身份证号码不合法
        [CMMUtility showNote:QMLocalizedString(@"qm_idcard_number_invalid", @"身份证号码不合法")];
        
        return;
    }
    
    if (![[passWordField text] isEqualToString:[confirmPwdField text]]) {
        [CMMUtility showNote:QMLocalizedString(@"qm_password_not_equal", @"两次密码不一致")];
        return;
    }
    
    [[NetServiceManager sharedInstance] setNewPayPasswordWithNewPayPassword:[passWordField text]
                                                                      mCode:[passCodeField text]
                                                               idCardNumber:[idCardNumberField text]
                                                                   delegate:self
                                                                    success:^(id responseObject) {
                                                                        [self handleResetPasswordSuccess:responseObject];
                                                                    } failure:^(NSError *error) {
                                                                        [self handleResetPasswordFailure:error];
                                                                    }];
    
    [self invalidateTimer];
}

- (void)handleResetPasswordSuccess:(id)responseObject {
    // 提示重置成功
    [self performSelector:@selector(showSuccessInfo) withObject:nil afterDelay:0.2f];
    
    if (QM_IS_DELEGATE_RSP_SEL(self.delegate, confirmPayPwdViewControllerDidResetPayPasswordSuccess:)) {
        [self.delegate confirmPayPwdViewControllerDidResetPayPasswordSuccess:self];
    }
}

- (void)showSuccessInfo {
    [CMMUtility showSuccessMessage:QMLocalizedString(@"qm_pay_pwd_reset_success", @"支付密码重置成功")];
}

- (void)getPassCodeBtnClicked:(id)sender {
    [[NetServiceManager sharedInstance] getResetPayPwdPassCodeWithDelegate:self
                                                                   success:^(id responseObject) {
                                                                       [self setUpTimer];
                                                                   } failure:^(NSError *error) {
                                                                       [CMMUtility showNoteWithError:error];
                                                                   }];
}

- (void)handleResetPasswordFailure:(NSError *)error {
    [CMMUtility showNoteWithError:error];
}

- (void)handleTextFieldTextDidChangeNotification:(NSNotification *)noti {
    [self updateFinishBtnState];
    [self updateGetPassCodeBtnState];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
}

#pragma mark -
#pragma mark Override
- (NSString *)title {
    return QMLocalizedString(@"qm_pay_pwd_reset_nav_title", @"重置支付密码");
    /*
    if (self.isModify) {
        return QMLocalizedString(@"qm_forget_pay_pwd_title", @"忘记交易密码");
    }else {
        
    }
     */
}

@end

