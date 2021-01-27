//
//  QMInputPasswordViewController.m
//  MotherMoney
//

#import "QMInputPasswordViewController.h"
#import "QMInputPhoneNumberViewController.h"
#import "QMGestureWindow.h"
#import "QMResetPwdForPhoneViewController.h"
#import "QMTokenInfo.h"
#import "UIImageView+WebCache.h"

@implementation QMInputPasswordViewController {
    QMAccountInfo *accountInfo;
    UITextField *passwordField;
    UIButton *loginBtn;
    BOOL mShouldSwitchAccount;
    UIView *graybackView;
    UIImageView *imageView;
    UIButton *cancleBtn;
}

- (id)initViewControllerWithAccountInfo:(QMAccountInfo *)info
                       shouldShowSwitch:(BOOL)shouldSwitch {
    if (self = [super init]) {
        accountInfo = info;
        mShouldSwitchAccount = shouldSwitch;
    }
    
    return self;
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
    
    [self setUpSubViews];
}

- (void)setUpSubViews {
    UIView *superView = self.view;
    //手机号码label,账户名字
    UILabel *accountNameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    accountNameLabel.textColor = [UIColor whiteColor];
    accountNameLabel.font = [UIFont boldSystemFontOfSize:17.0f];
    accountNameLabel.textAlignment = NSTextAlignmentCenter;
    accountNameLabel.text = [QMStringUtil getPromptPhoneNumberWithPhoneNumber:accountInfo.phoneNumber];
    [self.view addSubview:accountNameLabel];
    
    [accountNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(superView.mas_left);
        make.top.equalTo(superView.mas_top).offset(50);
        make.right.equalTo(superView.mas_right);
        
        if (nil != accountInfo) {
            make.height.equalTo(19.0);
        }else {
            make.height.equalTo(0.1f);
        }
    }];
    
    // password
    passwordField = [QMControlFactory commonTextFieldWithPlaceholder:QMLocalizedString(@"qm_register_input_password_placeholder", @"请填写登录密码") delegate:nil];
    [passwordField setBackground:[QMImageFactory commonBackgroundImage]];
    //密码保护式
    passwordField.secureTextEntry = YES;
    [self.view addSubview:passwordField];
    [passwordField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(superView.mas_left).offset(15.0f);
        make.top.equalTo(accountNameLabel.mas_bottom).offset(25.0f);
        make.right.equalTo(superView.mas_right).offset(-15.0f);
        make.height.equalTo(35.0f);
    }];
    
    // 忘记密码按钮
    UIButton *forgetPwdBtn = [QMControlFactory forgetPwdBtnWithTarget:self selector:@selector(forgetPwdBtnClicked:)];
    [self.view addSubview:forgetPwdBtn];
    [forgetPwdBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(passwordField.mas_bottom);
        make.right.equalTo(passwordField.mas_right);
        make.size.equalTo(CGSizeMake(100, 35));
    }];
    
    // login
    loginBtn = [QMControlFactory commonBorderedButtonWithSize:CGSizeZero title:QMLocalizedString(@"qm_recommendation_login_btn_title", @"登录") target:self selector:@selector(loginBtnClicked:)];
    [self.view addSubview:loginBtn];
    [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(forgetPwdBtn.mas_bottom).offset(-10.0f);
        make.left.equalTo(passwordField.mas_left);
        make.width.equalTo(passwordField.mas_width);
        make.height.equalTo(35.0f);
    }];
}

- (UIBarButtonItem *)rightBarButtonItem {
    if (YES == mShouldSwitchAccount) {
        return [QMNavigationBarItemFactory createNavigationItemWithTitle:QMLocalizedString(@"qm_register_switch_account_btn_title", @"切换账户") target:self selector:@selector(switchAccountBtnClicked:) isLeft:NO];
    }
    
    return nil;
}

- (void)setShouldSwitchAccount:(BOOL)shouldSwitchAccount {
    mShouldSwitchAccount = shouldSwitchAccount;
    if (YES == mShouldSwitchAccount) {
        self.navigationItem.rightBarButtonItem = [self rightBarButtonItem];
    }else {
        self.navigationItem.rightBarButtonItem = nil;
    }
}

- (void)onBack {
    if (self.isModel) {
        QMTabBarController *controller = [[AppDelegate appDelegate] rootViewController];
        controller.selectedIndex = 0;
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
            return [QMNavigationBarItemFactory createNavigationItemWithTitle:@" "target:nil selector:nil isLeft:YES];
        }
    }else {
        return nil;
    }
}

// 忘记密码
- (void)forgetPwdBtnClicked:(UIButton *)btn {
    QMResetPwdForPhoneViewController *con = [[QMResetPwdForPhoneViewController alloc] init];
    [self.navigationController pushViewController:con animated:YES];
}

- (NSString *)getPassword {
    return [passwordField text];
}

// 登录
- (void)loginBtnClicked:(UIButton *)btn {
    if (QM_IS_STR_NIL(accountInfo.phoneNumber) || QM_IS_STR_NIL([self getPassword])) {
        return;
    }
    [passwordField resignFirstResponder];
    // 用户登录
    [[NetServiceManager sharedInstance] userLoginWithPhoneNumber:accountInfo.phoneNumber
                                                             pwd:[self getPassword]
                                                        delegate:self
                                                         success:^(id responseObject) {
                                                             [self handleLoginSuccess:responseObject];
                                                             QMTokenInfo *tokeninfo = [QMTokenInfo sharedInstance];
                                                             [tokeninfo setPhoneNumber:accountInfo.phoneNumber];
                                                         } failure:^(NSError *error) {
                                                             [self handleLoginFailure:error];
                                                         }];
}

// 登录成功
- (void)handleLoginSuccess:(id)responseObject {
    if (!QM_IS_STR_NIL([self getPassword])) {
        NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithObjectsAndKeys:[self getPassword], QM_USER_PASSWORD_KEY, nil];
        if (!QM_IS_STR_NIL(accountInfo.phoneNumber)) {
            [userInfo setObject:accountInfo.phoneNumber forKey:QM_PHONE_NUMBER_KEY];
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:QM_LOGIN_SUCCESS_NOTIFICATION_KEY
                                                            object:nil
                                                          userInfo:userInfo];
    }
    
    if (QM_IS_DELEGATE_RSP_SEL(self.delegate, passwordViewControllerDidLoginSuccess:)) {
        [self.delegate passwordViewControllerDidLoginSuccess:self];
    }else {
        // 退出登录页面
        if ([self.navigationController.view.window isKindOfClass:[QMGestureWindow class]]) {
            // 通过手势页面登录成功
            [[AppDelegate appDelegate] tryHideGesturePwdWindow:YES];
        }else {
            // 普通登录成功
            NSLog(@"%@",responseObject);
            if ([[responseObject objectForKey:@"popup"] integerValue])
            {
                graybackView = [[UIView alloc] initWithFrame:[[UIApplication sharedApplication].keyWindow bounds]];
                graybackView.backgroundColor = [UIColor blackColor];
                graybackView.alpha = 0.3;
                [[UIApplication sharedApplication].keyWindow addSubview:graybackView];
                
                imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [[UIApplication sharedApplication].keyWindow bounds].size.width * 2.75 / 4, [[UIApplication sharedApplication].keyWindow bounds].size.height / 2)];
                imageView.center = CGPointMake([[UIApplication sharedApplication].keyWindow bounds].size.width / 2, [[UIApplication sharedApplication].keyWindow bounds].size.height / 2);
                [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[responseObject objectForKey:@"popuplink"]]]];
                [[UIApplication sharedApplication].keyWindow addSubview:imageView];
                
                cancleBtn = [[UIButton alloc] initWithFrame:[[UIApplication sharedApplication].keyWindow bounds]];
                cancleBtn.backgroundColor = [UIColor clearColor];
                [cancleBtn addTarget:self action:@selector(clickCancle) forControlEvents:UIControlEventTouchUpInside];
                [self.view addSubview:cancleBtn];
                
//                NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:[[responseObject objectForKey:@"time"] integerValue] repeats:NO block:^(NSTimer * _Nonnull timer) {
//                    [graybackView removeFromSuperview];
//                    [imageView removeFromSuperview];
//                    [cancleBtn removeFromSuperview];
//                    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
//                    [[NSNotificationCenter defaultCenter] postNotificationName:noticeLoginPeopleMessage object:nil];
//                }];
                NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:[[responseObject objectForKey:@"time"] integerValue] target:self selector:@selector(removeView) userInfo:nil repeats:NO];
                NSLog(@"%@",timer);
            }
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:noticeLoginPeopleMessage object:nil];
//            else
//            {
//                [self.navigationController dismissViewControllerAnimated:YES completion:nil];
//                [[NSNotificationCenter defaultCenter] postNotificationName:noticeLoginPeopleMessage object:nil];
//            }
        }
    }
}

- (void)removeView
{
    [graybackView removeFromSuperview];
    [imageView removeFromSuperview];
    [cancleBtn removeFromSuperview];
//    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
//    [[NSNotificationCenter defaultCenter] postNotificationName:noticeLoginPeopleMessage object:nil];
}

-(void)clickCancle
{
    //处理单击操作
    [graybackView removeFromSuperview];
    [imageView removeFromSuperview];
    [cancleBtn removeFromSuperview];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:noticeLoginPeopleMessage object:nil];
}

// 登录失败
- (void)handleLoginFailure:(NSError *)error {
    // 暂时什么也不做
    [CMMUtility showNoteWithError:error];
    if (QM_IS_DELEGATE_RSP_SEL(self.delegate, passwordViewControllerDidLoginFailed:)) {
        [self.delegate passwordViewControllerDidLoginFailed:self];
    }
}

// 切换账号
- (void)switchAccountBtnClicked:(id)sender {
    QMInputPhoneNumberViewController *con = [[QMInputPhoneNumberViewController alloc] init];
    con.isModel = NO;
    con.showBackBtn = YES;
//    [self.navigationController setViewControllers:[NSArray arrayWithObjects:con, nil] animated:YES];
    [self.navigationController pushViewController:con animated:YES];
}

#pragma mark -
#pragma mark Override
- (NSString *)title {
    return QMLocalizedString(@"qm_register_input_password_nav_title", @"填写登录密码");
}

@end
