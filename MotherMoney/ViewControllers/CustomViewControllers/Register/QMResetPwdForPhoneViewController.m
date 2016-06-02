//
//  QMResetPwdForPhoneViewController.m
//  MotherMoney
//

#import "QMResetPwdForPhoneViewController.h"
#import "QMConfirmPwdViewController.h"

@implementation QMResetPwdForPhoneViewController {
    UILabel *promptLabel;
    UITextField *phoneNumberField;
    UITextField *passCodeField;
    UIButton *getPassCodeBtn;
    UIButton *nextStepBtn;
    
    NSTimer *timeLimitTimer;
    
    NSInteger timeLimit;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self customSubViews];
    
    // notification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleTextDidChangeNotification:) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self invalidateTimer];
}

- (void)customSubViews {
    UIImage *image = [QMImageFactory commonScaledFullScreenBackgroundImage];
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:image];
    backgroundImageView.contentMode = UIViewContentModeBottom;
    backgroundImageView.clipsToBounds = YES;
    [self.view addSubview:backgroundImageView];
    [backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(UIEdgeInsetsZero);
    }];
    
    // 验证信息
    promptLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 20, CGRectGetWidth(self.view.frame) - 2 * 15, 20)];
    promptLabel.text = QMLocalizedString(@"qm_input_registered_phone_number_prompt", @"获取验证信息");
    promptLabel.font = [UIFont systemFontOfSize:14];
    promptLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:promptLabel];
    
    // 手机号码
    phoneNumberField = [QMControlFactory commonTextFieldWithPlaceholder:QMLocalizedString(@"qm_input_registered_phone_number_text", @"输入您注册的手机号") delegate:nil];
    phoneNumberField.keyboardType = UIKeyboardTypeNumberPad;
    phoneNumberField.textColor = QM_COMMON_TEXT_COLOR;
    [phoneNumberField setBackground:[QMImageFactory commonBackgroundImage]];
    [self.view addSubview:phoneNumberField];
    [phoneNumberField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(promptLabel.mas_left);
        make.top.equalTo(promptLabel.mas_bottom).offset(5);
        make.width.equalTo(promptLabel.mas_width);
        make.height.equalTo(40.0f);
    }];
    
    // passCode 按钮
    passCodeField = [QMControlFactory commonTextFieldWithPlaceholder:QMLocalizedString(@"qm_input_passcode_placeholder", @"请输入验证码") delegate:nil];
    passCodeField.background = [QMImageFactory commonBackgroundImage];
    passCodeField.keyboardType = UIKeyboardTypeNumberPad;
    passCodeField.textColor = QM_COMMON_TEXT_COLOR;
    [self.view addSubview:passCodeField];
    [passCodeField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(phoneNumberField.mas_left);
        make.top.equalTo(phoneNumberField.mas_bottom).offset(10);
        make.width.equalTo(phoneNumberField.mas_width).with.multipliedBy(2.0f / 3.0f);
    }];
    
    // 获取验证码
    getPassCodeBtn = [QMControlFactory commonBorderedButtonWithSize:CGSizeZero title:QMLocalizedString(@"qm_get_pass_code_btn_title", @"获取验证码") target:self selector:@selector(getPassCodeBtnClicked:)];
    [self.view addSubview:getPassCodeBtn];
    [getPassCodeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(passCodeField.mas_right).offset(10);
        make.top.equalTo(passCodeField.mas_top);
        make.right.equalTo(phoneNumberField.mas_right);
        make.height.equalTo(passCodeField.mas_height);
    }];
    [self updateGetPassCodeBtnState];
    
    nextStepBtn = [QMControlFactory commonBorderedButtonWithSize:CGSizeZero title:QMLocalizedString(@"qm_next_action_btn_title", @"下一步") target:self selector:@selector(nextStepBtnClicked:)];
    [self.view addSubview:nextStepBtn];
    [nextStepBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(phoneNumberField.mas_left);
        make.top.equalTo(getPassCodeBtn.mas_bottom).offset(15);
        make.width.equalTo(phoneNumberField.mas_width);
        make.height.equalTo(44);
    }];
    [self updateNextBtnState];
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

- (void)getPassCodeBtnClicked:(id)sender {
    if (![CMMUtility checkPhoneNumber:[self getPhoneNumber]]) {
        [CMMUtility showNote:QMLocalizedString(@"qm_phone_number_not_legal", @"请输入正确的手机号")];
        return;
    }
    
    [[NetServiceManager sharedInstance] getResetPwdPassCode:[self getPhoneNumber]
                                                   delegate:self
                                                    success:^(id responseObject) {
                                                        
                                                        
                                                        
                                                        [self setUpTimer];
                                                    } failure:^(NSError *error) {
                                                        
                                                        
                                                        
                                                        [CMMUtility showNoteWithError:error];
                                                    }];
}

- (void)updateGetPassCodeBtnState {
    NSString *phoneNumber = [self getPhoneNumber];
    if (!QM_IS_STR_NIL(phoneNumber)) {
        getPassCodeBtn.enabled = YES;
    }else {
        getPassCodeBtn.enabled = NO;
    }
}

- (void)updateNextBtnState {
    NSString *phoneNumber = [self getPhoneNumber];
    NSString *passCode = [self getPassCode];
    if (!QM_IS_STR_NIL(phoneNumber) && !QM_IS_STR_NIL(passCode)) {
        nextStepBtn.enabled = YES;
    }else {
        nextStepBtn.enabled = NO;
    }
}

- (NSString *)getPhoneNumber {
    return [self getTextFromTextField:phoneNumberField];
}

- (NSString *)getPassCode {
    return [self getTextFromTextField:passCodeField];
}

- (NSString *)getTextFromTextField:(UITextField *)textField {
    return [[textField text] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

#pragma mark -
#pragma mark Action
- (void)nextStepBtnClicked:(id)sender {
    [self invalidateTimer];
    QMConfirmPwdViewController *con = [[QMConfirmPwdViewController alloc] initViewControllerWithPhoneNumber:[self getPhoneNumber] passCode:[self getPassCode]];
    [self.navigationController pushViewController:con animated:YES];
}

- (void)handleTextDidChangeNotification:(NSNotification *)noti {
    [self updateNextBtnState];
    [self updateGetPassCodeBtnState];
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
