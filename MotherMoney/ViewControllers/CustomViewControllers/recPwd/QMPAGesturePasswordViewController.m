//
//  QMPAGesturePasswordViewController.m

//

#import "QMPAGesturePasswordViewController.h"
#import "NineGridUnlockView.h"
#import "UIImageView+AFNetworking.h"
#import "QMInputPhoneNumberViewController.h"
#import "QMInputPasswordViewController.h"

@interface QMPAGesturePasswordViewController ()<NinGridUnlockViewDelegate>

@end

@implementation QMPAGesturePasswordViewController {
    NineGridUnlockView *nineView;
}
@synthesize portraitImageView = portraitImageView;
@synthesize nickNameLabel = nickNameLabel;
@synthesize noteLabel = noteLabel;
@synthesize timesCount = timesCount;
@synthesize isRoot = isRoot;
@synthesize unlockView = unlockView;

- (void)viewDidLoad {
    [super viewDidLoad];
//    UIView *superView = self.view;
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[QMImageFactory commonScaledFullScreenBackgroundImage]];
    
    nickNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 110 - [[AppDelegate appDelegate] navigationBarAndStatusBarHeight], CGRectGetWidth([UIScreen mainScreen].bounds), 25.0f)];
    nickNameLabel.text = @"";
    nickNameLabel.textColor = [UIColor whiteColor];
    nickNameLabel.backgroundColor = [UIColor clearColor];
    nickNameLabel.font = [UIFont systemFontOfSize:16.0f];
    nickNameLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:nickNameLabel];
//    [nickNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(superView.mas_left);
//        make.top.equalTo(superView.mas_top).offset(110 - [[AppDelegate appDelegate] navigationBarAndStatusBarHeight]);
//        make.width.equalTo(superView.mas_width);
//        make.height.equalTo(25.0f);
//    }];
    
    noteLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(nickNameLabel.frame) + 2.0f, CGRectGetWidth([UIScreen mainScreen].bounds) - 2 * 10, 20)];
    noteLabel.backgroundColor = [UIColor clearColor];
    noteLabel.textColor = [UIColor whiteColor];
    noteLabel.font = [UIFont systemFontOfSize:13.0f];
    noteLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:noteLabel];
//    [noteLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(superView.mas_left).offset(10);
//        make.right.equalTo(superView.mas_right).offset(-10.0f);
//        make.top.equalTo(nickNameLabel.mas_bottom).offset(2.0f);
//        make.height.equalTo(20.0f);
//    }];

    CGFloat size = [UIScreen mainScreen].bounds.size.width - 2 * 30;
    unlockView = [[NineGridUnlockView alloc] initWithFrame:CGRectMake(30, CGRectGetMaxY(noteLabel.frame) + 10, size, size)];
    unlockView.delegate = self;
    [self.view addSubview: unlockView];
    
    UIButton *otherAccountBt = [UIButton buttonWithType:UIButtonTypeCustom];
    otherAccountBt.frame = CGRectMake(CGRectGetMinX(unlockView.frame), CGRectGetMaxY(unlockView.frame) + 10, 160, 30);
    otherAccountBt.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    otherAccountBt.titleLabel.font = [UIFont systemFontOfSize:13.0f];
    [otherAccountBt addTarget:self action:@selector(logInWithOtherAccount:) forControlEvents:UIControlEventTouchUpInside];
    [otherAccountBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [otherAccountBt setTitle:QMLocalizedString(@"qm_login_with_other_account", @"其他账号登陆") forState:UIControlStateNormal];
    [self.view addSubview:otherAccountBt];
    
    UIButton *forgetBt = [UIButton buttonWithType:UIButtonTypeCustom];
    forgetBt.frame = CGRectMake(CGRectGetMaxX(unlockView.frame) - 160, CGRectGetMinY(otherAccountBt.frame), 160, 30);
    forgetBt.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [forgetBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    forgetBt.titleLabel.font = [UIFont systemFontOfSize:13.0f];
    [forgetBt addTarget:self action:@selector(forgetRec) forControlEvents:UIControlEventTouchUpInside];
    [forgetBt setTitle:QMLocalizedString(@"qm_forget_rec_pwd", @"忘记手势密码") forState:UIControlStateNormal];
    [self.view addSubview:forgetBt];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setUserInfo];
}

// 将用户信息显示在UI上
-(void)setUserInfo {
    // 显示手机号
    QMAccountInfo *account = [[QMAccountUtil sharedInstance] currentAccount];
    NSString *accountName = account.phoneNumber;
    if (!QM_IS_STR_NIL([QMStringUtil getPromptPhoneNumberWithPhoneNumber:accountName])) {
        self.nickNameLabel.text = [QMStringUtil getPromptPhoneNumberWithPhoneNumber:accountName];
    }
    
    [self loginWithUserInfo:account];
}

// 其他账号登录
- (void)logInWithOtherAccount:(id)sender {
    QMInputPhoneNumberViewController *con = [[QMInputPhoneNumberViewController alloc] init];
    con.isModel = NO;
    con.showBackBtn = YES;
    [self.navigationController pushViewController:con animated:YES];
}

// 尝试自动登录
-(void)loginWithUserInfo:(QMAccountInfo *)info {
    NSString *accountName = info.phoneNumber;
    NSString *pwd = info.password;
    [[NetServiceManager sharedInstance] userLoginWithPhoneNumber:accountName
                                                             pwd:pwd
                                                        delegate:self
                                                         success:^(id responseObject) {

                                                         } failure:^(NSError *error) {

                                                         }];
}

-(void)forgetRec {
    [self forgetRecPwd:[[QMAccountUtil sharedInstance] currentAccount]];
}

-(void)forgetRecPwd:(QMAccountInfo *)model {
    QMAccountInfo *accountInfo = [[QMAccountUtil sharedInstance] currentAccount];
    QMInputPasswordViewController *con = [[QMInputPasswordViewController alloc] initViewControllerWithAccountInfo:accountInfo shouldShowSwitch:YES];
    [self.navigationController pushViewController:con animated:YES];
}

// 更新用户信息
-(void)updateUserInfo:(NSDictionary *)info {
    QMAccountInfo *model = [[QMAccountUtil sharedInstance] currentAccount];
    if (model == nil) {
        model = [[QMAccountInfo alloc] init];
    }
    
    LNLogInfo(@"手势解锁更新用户信息%@",info);
    
    NSNumber *userIdStr  = [info objectForKey:@"userId"];
    model.userId = [NSString stringWithFormat:@"%@", userIdStr];
    NSString *avar = [info objectForKey:@"headpath"];
    model.iconUrl = avar;
    NSString *nick = [info objectForKey:@"nickname"];
    model.userNickName = nick;
    BOOL hasPayPwd = [[info objectForKey:@"haspaypassword"] boolValue];
    model.isHasPayPwd = hasPayPwd;
    
    [[QMAccountUtil sharedInstance] saveCurrentAccountInfo];
    
}

-(void)shakeView:(UIView *)view {
    CALayer *lbl = [view layer];
    CGPoint posLbl = [lbl position];
    CGPoint y = CGPointMake(posLbl.x-10, posLbl.y);
    CGPoint x = CGPointMake(posLbl.x+10, posLbl.y);
    CABasicAnimation * animation = [CABasicAnimation animationWithKeyPath:@"position"];
    [animation setTimingFunction:[CAMediaTimingFunction
                                  functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [animation setFromValue:[NSValue valueWithCGPoint:x]];
    [animation setToValue:[NSValue valueWithCGPoint:y]];
    [animation setAutoreverses:YES];
    [animation setDuration:0.08];
    [animation setRepeatCount:3];
    [lbl addAnimation:animation forKey:nil];
}

#pragma mark -
#pragma mark delegate methods
- (void)unlockerView:(NineGridUnlockView*)unlockerView didFinished:(NSArray*)points {
    QMAccountInfo *info = [[QMAccountUtil sharedInstance] currentAccount];
    if (info == nil) {
        LNLogInfo(@"用户未开启滑动解锁");
        assert(NO);
    }
    if (4-timesCount == 0) {
        // 先将手势密码页面关闭
        [[AppDelegate appDelegate] tryHideGesturePwdWindow:NO];
        
        //5次机会用完
        info.isUsingRecPwd = NO;
        info.recPwd = nil;
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"5次机会全部用完,手势密码将自动关闭" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        alertView.delegate = self;
        [alertView show];
        
        // 退出登录
        [[NetServiceManager sharedInstance] userLogoutWithWithDelegate:self
                                                               success:^(id responseObject) {
                                                                   // 登出成功
                                                                   [[NSNotificationCenter defaultCenter] postNotificationName:QM_LOGOUT_SUCCESS_NOTIFICATION_KEY object:nil];
                                                               } failure:^(NSError *error) {
                                                                   // 登出失败
                                                                   [[NSNotificationCenter defaultCenter] postNotificationName:QM_LOGOUT_SUCCESS_NOTIFICATION_KEY object:nil];
                                                               }];
        
        return;
    }
    NSString *userInput = [points componentsJoinedByString:@","];
    if ([userInput isEqualToString:info.recPwd]) {
        self.view.userInteractionEnabled = NO;
        [[AppDelegate appDelegate] tryHideGesturePwdWindow:YES];
    }else{
        LNLogError(@"输入手势密码错误");
        self.timesCount++;
        NSString *noteStr = [NSString stringWithFormat:@"密码错误,还可以输入%@次",[NSNumber numberWithInteger:5-timesCount]];
        noteLabel.text = noteStr;
        [self shakeView:noteLabel];
        [unlockView resetView];
    }
}

#pragma mark -
#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [self forgetRecPwd:[[QMAccountUtil sharedInstance] currentAccount]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end


