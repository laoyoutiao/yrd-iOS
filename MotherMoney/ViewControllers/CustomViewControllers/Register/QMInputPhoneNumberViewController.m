//
//  QMInputPhoneNumberViewController.m
//  MotherMoney
//
//

#import "QMInputPhoneNumberViewController.h"
#import "UIImage+Gradient.h"
#import "QMGetPassCodeViewController.h"
#import "QMInputPasswordViewController.h"
#import "QMNumberPromptView.h"
#import "QMWebViewController3.h"
#import "NTESVerifyCodeManager.h"
#define CHECKBOX_SELECTED_ALERT_VIEW_TAG 5001

@interface QMInputPhoneNumberViewController ()<UITextFieldDelegate,NTESVerifyCodeManagerDelegate>
@property(nonatomic,strong) NTESVerifyCodeManager *manager;
@end

@implementation QMInputPhoneNumberViewController {
    UITextField *phoneNumberField;
    
    UILabel *phoneNumberSecureLabel;
    UIButton *checkBox;
    
    UIButton *nextStepBtn;
    
    UIButton *clearBtn;
    
    QMNumberPromptView *phoneNumberPromptView;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    UIImage *image = [QMImageFactory commonScaledFullScreenBackgroundImage];
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:image];
    backgroundImageView.contentMode = UIViewContentModeBottom;
    backgroundImageView.clipsToBounds = YES;
    [self.view addSubview:backgroundImageView];
    [backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(UIEdgeInsetsZero);
    }];
    
    [self customSubViews];
    
    // tap gesture
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    [self.view addGestureRecognizer:tap];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleTextChangeNotification:) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)handleTapGesture:(UIGestureRecognizer *)tap {
    [phoneNumberField resignFirstResponder];
}
//textFile协议
- (void)handleTextChangeNotification:(NSNotification *)noti {
    if (!QM_IS_STR_NIL(phoneNumberField.text)) {
        clearBtn.hidden = NO;
        phoneNumberPromptView.hidden = NO;
        phoneNumberSecureLabel.hidden = YES;
        nextStepBtn.enabled = YES;
    }else {
        clearBtn.hidden = YES;
        phoneNumberPromptView.hidden = YES;
        phoneNumberSecureLabel.hidden = NO;
        nextStepBtn.enabled = NO;
    }
    
    [self updatePhoneNumberPromptForNumber:phoneNumberField.text];
}

- (void)updatePhoneNumberPromptForNumber:(NSString *)phoneNumber {
    phoneNumberPromptView.text = [QMStringUtil formattedPhoneNumberFromPhoneNumber:phoneNumber];
}

- (void)customSubViews {
    UIView *superView = self.view;
    //输入手机号码文本框
    phoneNumberField = [QMControlFactory commonTextFieldWithPlaceholder:QMLocalizedString(@"qm_register_input_phone_number_placeholder", @"请您输入手机号码") delegate:self];
    phoneNumberField.keyboardType = UIKeyboardTypeNumberPad;
    phoneNumberField.background = [QMImageFactory commonTextFieldImage];
    [self.view addSubview:phoneNumberField];
    [phoneNumberField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(superView.mas_top).offset(20);
        make.left.equalTo(superView.mas_left).offset(20);
        make.right.equalTo(superView.mas_right).offset(-20);
        make.height.equalTo(35);
    }];
    
    // prompt label,提示框
    phoneNumberPromptView = [[QMNumberPromptView alloc] initWithFrame:CGRectZero];

    phoneNumberPromptView.hidden = YES;
    [self.view addSubview:phoneNumberPromptView];
    [phoneNumberPromptView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(phoneNumberField.mas_left);
        make.top.equalTo(phoneNumberField.mas_bottom).offset(5);
        make.width.equalTo(phoneNumberField.mas_width);
        make.height.equalTo(40);
    }];
    
    // clear button
    clearBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [clearBtn addTarget:self action:@selector(clearTextBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    clearBtn.hidden = YES;
    clearBtn.frame = CGRectMake(CGRectGetMaxX(phoneNumberField.frame) - 40, CGRectGetMaxY(phoneNumberField.frame), 40, CGRectGetHeight(phoneNumberField.frame));
    [clearBtn setImage:[UIImage imageNamed:@"delete_icon.png"] forState:UIControlStateNormal];
    [self.view addSubview:clearBtn];
    [clearBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(phoneNumberField.mas_right).offset(-40);
        make.top.equalTo(phoneNumberField.mas_top);
        make.right.equalTo(phoneNumberField.mas_right);
        make.bottom.equalTo(phoneNumberField.mas_bottom);
    }];
    
    // 安全声明
    phoneNumberSecureLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    phoneNumberSecureLabel.textAlignment = NSTextAlignmentCenter;
    phoneNumberSecureLabel.font = [UIFont systemFontOfSize:10];
    phoneNumberSecureLabel.textColor = [UIColor colorWithWhite:1.0f alpha:0.3f];
    phoneNumberSecureLabel.text = QMLocalizedString(@"qm_register_phone_number_secure_text", @"粤融贷不会在任何地方泄漏您的号码");
    [self.view addSubview:phoneNumberSecureLabel];
    [phoneNumberSecureLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(superView.mas_left);
        make.top.equalTo(phoneNumberField.mas_bottom).offset(10);
        make.right.equalTo(superView.mas_right);
        make.height.equalTo(12);
    }];
    
    // 复选框
    checkBox = [QMControlFactory commonCheckBoxButtonWithTitle:QMLocalizedString(@"qm_register_phone_number_agree", @"我同意") target:self selector:@selector(checkBoxBtnClicked:)];
    checkBox.selected = YES;
    [self.view addSubview:checkBox];
    [checkBox mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(phoneNumberField.mas_left);
        make.top.equalTo(phoneNumberSecureLabel.mas_bottom).offset(45);
        make.size.equalTo(CGSizeMake(60, 40));
    }];
    
    // 协议按钮
    UIButton *principleBtn1 = [QMControlFactory commonTextButtonWithTitle:QMLocalizedString(@"qm_register_phone_number_user_principle", @"<<粤融贷用户使用协议>>") target:self selector:@selector(gotoUserUsePrinciple)];
    [self.view addSubview:principleBtn1];
    [principleBtn1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(checkBox.mas_right);
        make.top.equalTo(checkBox.mas_top).offset(-2);
        make.size.equalTo(CGSizeMake(150, 20));
    }];
    
    UIButton *principleBtn2 = [QMControlFactory commonTextButtonWithTitle:QMLocalizedString(@"qm_register_phone_number_principle", @"<<使用条款和隐私政策协议>>") target:self selector:@selector(gotoPrivacyPrinciple)];
    [self.view addSubview:principleBtn2];
    [principleBtn2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(principleBtn1.mas_left);
        make.top.equalTo(principleBtn1.mas_bottom).offset(5);
        make.width.equalTo(principleBtn1.mas_width);
        make.height.equalTo(principleBtn1.mas_height);
    }];
    
    UIButton *riskAgreementBtn = [QMControlFactory commonTextButtonWithTitle:QMLocalizedString(@"qm_register_phone_number_riskAgreement", @"<<粤融贷风险提示>>") target:self selector:@selector(gotoRiskAgreement)];
    [self.view addSubview:riskAgreementBtn];
    [riskAgreementBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(principleBtn2.mas_left);
        make.top.equalTo(principleBtn2.mas_bottom).offset(5);
        make.width.equalTo(principleBtn2.mas_width);
        make.height.equalTo(principleBtn2.mas_height);
    }];
    
    // 下一步
    nextStepBtn = [QMControlFactory commonBorderedButtonWithSize:CGSizeZero title:QMLocalizedString(@"qm_next_action_btn_title", @"下一步") target:self selector:@selector(nextStepBtnClicked:)];
    nextStepBtn.titleLabel.textColor = [UIColor colorWithRed:246.0f/255.0f green:144.0f/255.0f blue:52.0f/255.0f alpha:1];
    nextStepBtn.enabled = NO;
    [self.view addSubview:nextStepBtn];
    [nextStepBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(riskAgreementBtn.mas_bottom).offset(25);
        make.left.equalTo(checkBox.mas_left);
        make.right.equalTo(superView.mas_right).offset(-20);
        make.height.equalTo(40);
    }];
}

// 进入用户使用协议
- (void)gotoUserUsePrinciple {
    // 使用条款和隐私政策协议
    [[NetServiceManager sharedInstance] getRegisterAgreementWithDelegate:self
                                                                 success:^(id responseObject) {
                                                                     [self gotoPrincipleViewControllerWithResponse:responseObject optionTitle:QMLocalizedString(@"qm_user_use_nav_title", @"粤融贷用户使用协议")];
                                                                 } failure:^(NSError *error) {
                                                                     [CMMUtility showNoteWithError:error];
                                                                 }];
}

// 隐私政策协议
- (void)gotoPrivacyPrinciple {
    [[NetServiceManager sharedInstance] getPrivacyAgreementWithDelegate:self
                                                                success:^(id responseObject) {
                                                                    [self gotoPrincipleViewControllerWithResponse:responseObject optionTitle:QMLocalizedString(@"qm_privacy_principle_nav_title", @"使用条款和隐私政策协议")];
                                                                } failure:^(NSError *error) {
                                                                    [CMMUtility showNoteWithError:error];
                                                                }];
}

- (void)gotoRiskAgreement
{
    [[NetServiceManager sharedInstance] getRiskAgreementWithDelegate:self
                                                             success:^(id responseObject) {
                                                                 [self gotoPrincipleViewControllerWithResponse:responseObject optionTitle:QMLocalizedString(@"qm_privacy_riskAgreement_nav_title", @"粤融贷风险提示")];
                                                             } failure:^(NSError *error) {
                                                                 [CMMUtility showNoteWithError:error];
                                                             }];
}

- (void)gotoPrincipleViewControllerWithResponse:(NSDictionary *)respoinse optionTitle:(NSString *)title {
    if (!QM_IS_DICT_NIL(respoinse)) {
        NSDictionary *agreement = [respoinse objectForKey:@"agreement"];
        NSString *agreementContent = [agreement objectForKey:@"agreementContent"];
        
        NSString *name = [agreement objectForKey:@"name"];
        NSString *navTitle = name;
        if (QM_IS_STR_NIL(navTitle)) {
            navTitle = title;
        }
        
        [QMWebViewController3 showWebViewWithContent:agreementContent
                                           navTitle:navTitle
                                            isModel:YES
                                               from:self];
    }
}

- (void)clearTextBtnClicked:(UIButton *)btn {
    phoneNumberField.text = @"";
    [self handleTextChangeNotification:nil];
}

- (void)checkBoxBtnClicked:(UIButton *)btn {
    if (btn.selected) {
        btn.selected = NO;
    }else {
        btn.selected = YES;
    }
}

- (void)nextStepBtnClicked:(UIButton *)btn {
    // 检查电话号码是否合法
    if (![CMMUtility checkPhoneNumber:phoneNumberField.text]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                            message:QMLocalizedString(@"qm_phone_number_invalid", @"手机号不合法，请重新输入")
                                                           delegate:nil
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:QMLocalizedString(@"qm_alertview_ok_title", @"确定"), nil];
        [alertView show];
        
        return;
    }
    
    if (!checkBox.selected) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                            message:QMLocalizedString(@"am_principle_not_checked_alert_message", @"在进行下一步操作之前，请先同意相关协议")
                                                           delegate:self
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:QMLocalizedString(@"qm_alertview_ok_title", @"确定"), nil];
        alertView.tag = CHECKBOX_SELECTED_ALERT_VIEW_TAG;
        [alertView show];
        return;
    }
    
    // 暂时用发送验证码来代替了
//    [[NetServiceManager sharedInstance] sendUserRegisterMsgCodeWithPhoneNumber:phoneNumberField.text
//                                                                      delegate:self
//                                                                       success:^(id responseObject) {
//                                                                           // 没有注册
//                                                                           [self gotoGetPassCodeViewController];
//                                                                       } failure:^(NSError *error) {
//                                                                           // 已经注册
//                                                                           [self executeGetPassCode:error];
//                                                                       }];
    
    [[NetServiceManager sharedInstance] getMobileResgist:phoneNumberField.text Delegate:self success:^(id responseObject) {
        NSString *registed = [responseObject objectForKey:@"registered"];
        if (registed.integerValue == 1) {
            [self gotoLoginViewController];
        }else
        {
            [self gotoGetPassCodeViewController];
        }
    } failure:^(NSError *error) {
        [AlertMessageShow showAlertViewOnlyChoiceWithTitle:@"网络错误" Message:@"请检查网络"];
    }];
}

- (NSString *)getPhoneNumber {
    return [phoneNumberField text];
}

- (QMAccountInfo *)getAccountInfo {
    QMAccountInfo *accountInfo = [[QMAccountInfo alloc] init];
    accountInfo.phoneNumber = [self getPhoneNumber];
    
    return accountInfo;
}

// 如果已经注册过，则直接输入密码，执行登录操作
- (void)gotoLoginViewController {
    QMInputPasswordViewController *con = [[QMInputPasswordViewController alloc] initViewControllerWithAccountInfo:[self getAccountInfo] shouldShowSwitch:NO];
    
    [self.navigationController pushViewController:con animated:YES];
}

- (void)executeGetPassCode:(NSError *)error {
    NSInteger code = [error code];
    
    if (QM_PHONE_NUMBER_REGISTERED == code) {
        // 已经注册
       [self gotoLoginViewController]; 
    }
}

- (void)gotoGetPassCodeViewController {
    //添加验证码验证(易道)
    [phoneNumberField resignFirstResponder];
    nextStepBtn.enabled = NO;
    self.manager =  [NTESVerifyCodeManager sharedInstance];
    if (self.manager) {
        
        // 如果需要了解组件的执行情况,则实现回调
        self.manager.delegate = self;
        
        // captchaid的值是每个产品从后台生成的
//        NSString *captchaid = @"0b193ca5423b417e8e5cf28cff33a49e";
        [self.manager configureVerifyCode:YiDaoCaptchaid timeout:10.0];
        
        [self.manager openVerifyCodeView];
        
    }
}

- (void)onBack {
    if (self.isModel) {
        [self.navigationController dismissViewControllerAnimated:YES completion:^{
            
        }];
    }else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (UIBarButtonItem *)leftBarButtonItem {
    if (self.isModel) {
        if (self.showBackBtn) {
            return [QMNavigationBarItemFactory createNavigationBackItemWithTarget:self selector:@selector(onBack)];
        }else {
            return nil;
        }
    }else {
        return nil;
    }
}

#pragma mark - NTESVerifyCodeManagerDelegate
/**
 * 验证码组件初始化完成
 */
- (void)verifyCodeInitFinish{
    NSLog(@"收到初始化完成的回调");
}

/**
 * 验证码组件初始化出错
 *
 * @param message 错误信息
 */
- (void)verifyCodeInitFailed:(NSString *)message{
    NSLog(@"收到初始化失败的回调:%@",message);
}

/**
 * 完成验证之后的回调
 *
 * @param result 验证结果 BOOL:YES/NO
 * @param validate 二次校验数据，如果验证结果为false，validate返回空
 * @param message 结果描述信息
 *
 */
- (void)verifyCodeValidateFinish:(BOOL)result validate:(NSString *)validate message:(NSString *)message{
    nextStepBtn.enabled = YES;
    NSLog(@"收到验证结果的回调:(%d,%@,%@)", result, validate, message);
    [[NetServiceManager sharedInstance] sendVerifyCodeMessage:validate Mobile:phoneNumberField.text Delegate:self success:^(id responseObject) {
        NSString *success = [responseObject objectForKey:@"success"];
        if(success.integerValue == 1)
        {
            QMGetPassCodeViewController *con = [[QMGetPassCodeViewController alloc] initViewControllerWithAccountInfo:[self getAccountInfo]];
            [self.navigationController pushViewController:con animated:YES];
        }else
        {
            [AlertMessageShow showAlertViewOnlyChoiceWithTitle:@"验证失败" Message:@"请再次验证"];
        }
    } failure:^(NSError *error) {
        [AlertMessageShow showAlertViewOnlyChoiceWithTitle:@"验证失败" Message:@"请再次验证"];
    }];

}

/**
 * 关闭验证码窗口后的回调
 */
- (void)verifyCodeCloseWindow{
    //用户关闭验证后执行的方法
    nextStepBtn.enabled = YES;
    NSLog(@"收到关闭验证码视图的回调");
}

/**
 * 网络错误
 *
 * @param error 网络错误信息
 */
- (void)verifyCodeNetError:(NSError *)error{
    //用户关闭验证后执行的方法
    nextStepBtn.enabled = YES;
    NSLog(@"收到网络错误的回调:%@(%ld)", [error localizedDescription], (long)error.code);
}

#pragma mark -
#pragma mark UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    // 保证是数字
    for (int i = 0; i < [string length]; i++) {
        char c = [string characterAtIndex:i];
        if (c < '0' || c > '9') {
            return NO;
        }
    }
    
    // 保证长度是合法的
    NSString *nowText = [textField text];
    if ([nowText length] >= 11 && range.length < [string length]) {
        return NO;
    }
    
    return YES;
}

#pragma mark -
#pragma mark Override
- (NSString *)title {
    return QMLocalizedString(@"qm_register_input_phone_number_nav_title", @"填写手机号");
}

@end
