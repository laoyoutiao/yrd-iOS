//
//  QMGetPassCodeViewController.m
//  MotherMoney
//

#import "QMGetPassCodeViewController.h"
#import "UIImage+Gradient.h"
#import "QMGestureWindow.h"
#import "QMTokenInfo.h"

@interface QMGetPassCodeViewController ()

@end

@implementation QMGetPassCodeViewController {
    UIScrollView *containerView;
    
    UILabel *passCodePromptLabel;
    UITextField *passCodeField;
    UIButton *reGetPasscodeBtn;
    
    // 密码
    UITextField *passwordField;
    UILabel *passwordRuleLabel;
    UITextField *confirmPassCodeField;
    
    // 完成按钮
    UIButton *finishBtn;
    
    NSTimer *timeLimitTimer;
    
    NSInteger timeLimit;
    
    QMAccountInfo *mAccountInfo;
}

- (id)initViewControllerWithAccountInfo:(QMAccountInfo *)info {
    if (self = [super init]) {
        mAccountInfo = info;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //初始化界面子view
    [self setUpSubViews];
    //改动，，，，
//    timeLimit = 60.0f;
//    [self updateResentPasscodeBtnTitle];
    [self setUpTimer];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    [self.view addGestureRecognizer:tap];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardWillShowNotification:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardWillHideNotification:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
    [self invalidateTimer];
}

- (NSString *)getPromptPhoneNumber {
    return [QMStringUtil getPromptPhoneNumberWithPhoneNumber:mAccountInfo.phoneNumber];
}

- (void)setUpSubViews {    
    UIImage *image = [QMImageFactory commonScaledFullScreenBackgroundImage];
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:image];
    backgroundImageView.contentMode = UIViewContentModeBottom;
    backgroundImageView.clipsToBounds = YES;
    backgroundImageView.frame = self.view.bounds;
    backgroundImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:backgroundImageView];
    
    containerView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    containerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:containerView];
    
    passCodePromptLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, CGRectGetWidth(self.view.frame), 40)];
    passCodePromptLabel.textAlignment = NSTextAlignmentCenter;
    passCodePromptLabel.textColor = [UIColor colorWithWhite:1.0f alpha:0.3f];
    passCodePromptLabel.font = [UIFont systemFontOfSize:16];
    passCodePromptLabel.numberOfLines = 2.0f;
    NSString *promptPhoneNumber = [self getPromptPhoneNumber];
    if (!QM_IS_STR_NIL(promptPhoneNumber)) {
        passCodePromptLabel.text = [NSString stringWithFormat:QMLocalizedString(@"qm_passcode_sent_prompt", @"已向%@发送短信，\n请在输入框中填写验证码完成注册"), promptPhoneNumber];
    }
    [containerView addSubview:passCodePromptLabel];
    
    // passcode field
    passCodeField = [[UITextField alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(passCodePromptLabel.frame) + 12.0f, CGRectGetWidth(self.view.frame) - 2 * 15, 35.0f)];
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, CGRectGetHeight(passwordField.frame))];
    passCodeField.leftView = leftView;
    passCodeField.keyboardType = UIKeyboardTypeNumberPad;
    passCodeField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    passCodeField.leftViewMode = UITextFieldViewModeAlways;
    [passCodeField setBackground:[QMImageFactory commonBackgroundImage]];
    [containerView addSubview:passCodeField];
    
    // vertical lin
    UILabel *verticalLine = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(passCodeField.frame) - 85.0f, CGRectGetMinY(passCodeField.frame) + 1.0f, 1.0f, 33.0f)];
    verticalLine.backgroundColor = [UIColor colorWithRed:0xe5 / 255.0f green:0xe5 / 255.0f blue:0xe5 / 255.0f alpha:1.0f];
    [containerView addSubview:verticalLine];
    
    // right view
    reGetPasscodeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    reGetPasscodeBtn.frame = CGRectMake(0, 0, 85.0f, CGRectGetHeight(passCodeField.frame));
    [reGetPasscodeBtn addTarget:self action:@selector(reGetPassCodeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [reGetPasscodeBtn setTitleColor:[UIColor colorWithRed:0x66 /255.0f green:0x66 /255.0f blue:0x66 /255.0f alpha:1.0f] forState:UIControlStateNormal];
    reGetPasscodeBtn.titleLabel.font = [UIFont systemFontOfSize:9.0f];
    passCodeField.rightView = reGetPasscodeBtn;
    passCodeField.rightViewMode = UITextFieldViewModeAlways;
    
    // password
    passwordField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMinX(passCodeField.frame), CGRectGetMaxY(passCodeField.frame) + 24.0f, CGRectGetWidth(passCodeField.frame), CGRectGetHeight(passCodeField.frame))];
    leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, CGRectGetHeight(passwordField.frame))];
    passwordField.leftView = leftView;
    passwordField.secureTextEntry = YES;
    passwordField.leftViewMode = UITextFieldViewModeAlways;
    [passwordField setBackground:[QMImageFactory commonBackgroundImage]];
    passwordField.placeholder = QMLocalizedString(@"qm_login_password_placeholder", @"登录密码");
    [containerView addSubview:passwordField];
    
    // prompt
    passwordRuleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(passwordField.frame), CGRectGetMaxY(passwordField.frame) + 10, CGRectGetWidth(passwordField.frame), 17.0f)];
    passwordRuleLabel.textColor = [UIColor colorWithWhite:1.0f alpha:0.3f];
    passwordRuleLabel.font = [UIFont systemFontOfSize:15.0f];
    passwordRuleLabel.textAlignment = NSTextAlignmentCenter;
    passwordRuleLabel.text = QMLocalizedString(@"qm_login_password_rule_prompt", @"密码由6-12个字符组成，字母区分大小写");
    [containerView addSubview:passwordRuleLabel];
    
    // confirm
    confirmPassCodeField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMinX(passwordField.frame), CGRectGetMaxY(passwordRuleLabel.frame) + 10, CGRectGetWidth(passwordField.frame), CGRectGetHeight(passwordField.frame))];
    leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, CGRectGetHeight(passwordField.frame))];
    confirmPassCodeField.leftView = leftView;
    confirmPassCodeField.secureTextEntry = YES;
    confirmPassCodeField.leftViewMode = UITextFieldViewModeAlways;
    confirmPassCodeField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [confirmPassCodeField setBackground:[QMImageFactory commonBackgroundImage]];
    confirmPassCodeField.font = [UIFont systemFontOfSize:15.0f];
    confirmPassCodeField.placeholder = QMLocalizedString(@"qm_login_password_confirm_placeholder", @"登录密码确认");
    [containerView addSubview:confirmPassCodeField];
    
    // finish btn
    finishBtn = [QMControlFactory commonBorderedButtonWithSize:CGSizeMake(CGRectGetWidth(confirmPassCodeField.frame), 40.0f) title:QMLocalizedString(@"qm_finish_btn_title", @"完成") target:self selector:@selector(finishBtnClicked:)];
    CGRect frame = finishBtn.frame;
    frame.origin = CGPointMake(CGRectGetMinX(confirmPassCodeField.frame), CGRectGetMaxY(confirmPassCodeField.frame) + 20.0f);
    finishBtn.frame = frame;
    [containerView addSubview:finishBtn];
}

- (void)updateResentPasscodeBtnTitle {
    timeLimit--;
    
    if (timeLimit <= 0) {
        [self invalidateTimer];
        [reGetPasscodeBtn setTitle:QMLocalizedString(@"qm_resent_passcode_btn_title", @"获取验证码") forState:UIControlStateNormal];
        reGetPasscodeBtn.userInteractionEnabled = YES;
    }else {
        reGetPasscodeBtn.userInteractionEnabled = NO;
        [reGetPasscodeBtn setTitle:[NSString stringWithFormat:QMLocalizedString(@"qm_resent_passcode_time_out", @"剩余%d秒"), timeLimit] forState:UIControlStateNormal];
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

- (void)reGetPassCodeBtnClicked:(UIButton *)btn {
    // 打点
    [QMUMTookKitManager event:USEROBTAIN_REGISTERCODE_KEY label:@"用户获取注册验证吗"];
    
    [[NetServiceManager sharedInstance] sendUserRegisterMsgCodeWithPhoneNumber:mAccountInfo.phoneNumber
                                                                      delegate:self
                                                                       success:^(id responseObject) {
                                                                          [self setUpTimer];
                                                                       } failure:^(NSError *error) {
                                                                           
                                                                       }];
}

- (void)finishBtnClicked:(UIButton*)btn {
    [self invalidateTimer];
    [self registerFinished];
}

- (NSString *)passwordText {
    return [passwordField text];
}

- (NSString *)passCodeText {
    return [passCodeField text];
}

- (void)registerFinished {
    // 打点
    [QMUMTookKitManager event:USER_REGISTER_KEY label:@"用户注册"];
    
    // 根据注册信息进行注册
    NSString *phoneNumber = mAccountInfo.phoneNumber;
    NSString *password = [self passwordText];
    NSString *mcCode = [self passCodeText];
    if (QM_IS_STR_NIL(phoneNumber) || QM_IS_STR_NIL(password) || QM_IS_STR_NIL(mcCode)) {
        [CMMUtility showNote:QMLocalizedString(@"qm_register_item_empty", @"请将信息填写完整")];
    }
    [[NetServiceManager sharedInstance] registerAccountWithPhoneNumber:phoneNumber
                                                              password:password
                                                                mcCode:mcCode
                                                              delegate:self
                                                               success:^(id responseObject) {
                                                                    // 注册成功
                                                                   [self handleRegisterSuccess:responseObject];
                                                               } failure:^(NSError *error) {
                                                                   // 注册失败
                                                                   [self handleRegisterFailure:error];
                                                               }];
}

- (void)handleRegisterSuccess:(id)responseObject {
    [SVProgressHUD showSuccessWithStatus:QMLocalizedString(@"qm_register_success_text", @"注册成功")];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:0];
    if (!QM_IS_STR_NIL(mAccountInfo.phoneNumber)) {
        [dict setObject:mAccountInfo.phoneNumber forKey:QM_PHONE_NUMBER_KEY];
    }
    
    if (!QM_IS_STR_NIL([self passwordText])) {
        [dict setObject:[self passwordText] forKey:QM_USER_PASSWORD_KEY];
    }
    
    // 尝试做一次登录
    [[NetServiceManager sharedInstance] userLoginWithPhoneNumber:mAccountInfo.phoneNumber
                                                             pwd:[self passwordText]
                                                        delegate:self
                                                         success:^(id responseObject) {
                                                             QMTokenInfo *tokeninfo = [QMTokenInfo sharedInstance];
                                                             [tokeninfo setPhoneNumber:mAccountInfo.phoneNumber];
                                                             NSLog(@"登录成功");
                                                         } failure:^(NSError *error) {
                                                             NSLog(@"登录失败");
                                                         }];
    
    // 发送通知，更新信息
    [[NSNotificationCenter defaultCenter] postNotificationName:QM_REGISTER_SUCCESS_NOTIFICATION_KEY
                                                        object:nil
                                                      userInfo:dict];
    
    if ([self.view.window isKindOfClass:[QMGestureWindow class]]) {
        [[AppDelegate appDelegate] tryHideGesturePwdWindow:YES];
    }else {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)handleRegisterFailure:(NSError *)error {
    [CMMUtility showNoteWithError:error];
}

// 重新发送验证码
- (void)resentPassword {
    
}

- (void)hideKeyboard {
    [passCodeField resignFirstResponder];
    [passwordField resignFirstResponder];
    [confirmPassCodeField resignFirstResponder];
}

- (void)handleTapGesture:(UITapGestureRecognizer *)tap {
    [self hideKeyboard];
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

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark -
#pragma mark Override
- (NSString *)title {
    return QMLocalizedString(@"qm_register_input_phone_number_nav_title", @"填写手机号");
}

@end
