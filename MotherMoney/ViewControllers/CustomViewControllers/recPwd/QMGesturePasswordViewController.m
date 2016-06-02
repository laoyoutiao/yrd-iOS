//
//  QMGesturePasswordViewController.m
//  MotherMoney
//

#import "QMGesturePasswordViewController.h"
#import "QMInputPhoneNumberViewController.h"
#import "QMInputPasswordViewController.h"


@interface QMGesturePasswordViewController ()<NinGridUnlockViewDelegate>

@end

@implementation QMGesturePasswordViewController {
    UILabel *nickNameLabel;
    UILabel *noteLabel;
    NSInteger timesCount;
    BOOL isRoot;
    NineGridUnlockView *unlockView;
    
    UIButton *otherAccountBt;
    UIButton *forgetBt;
}
@synthesize otherAccountBt = otherAccountBt;
@synthesize forgetBt = forgetBt;


- (id)init {
    if (self = [super init]) {
        otherAccountBt = [UIButton buttonWithType:UIButtonTypeCustom];
        
        forgetBt = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[QMImageFactory commonScaledFullScreenBackgroundImage]];
    
    nickNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 110 - [[AppDelegate appDelegate] navigationBarAndStatusBarHeight], CGRectGetWidth([UIScreen mainScreen].bounds), 25.0f)];
    nickNameLabel.text = @"";
    nickNameLabel.textColor = [UIColor whiteColor];
    nickNameLabel.backgroundColor = [UIColor clearColor];
    nickNameLabel.font = [UIFont systemFontOfSize:16.0f];
    nickNameLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:nickNameLabel];
    
    noteLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(nickNameLabel.frame) + 2.0f, CGRectGetWidth([UIScreen mainScreen].bounds) - 2 * 10, 20)];
    noteLabel.backgroundColor = [UIColor clearColor];
    noteLabel.textColor = [UIColor whiteColor];
    noteLabel.font = [UIFont systemFontOfSize:13.0f];
    noteLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:noteLabel];
    
    CGFloat size = [UIScreen mainScreen].bounds.size.width - 2 * 30;
    unlockView = [[NineGridUnlockView alloc] initWithFrame:CGRectMake(30, CGRectGetMaxY(noteLabel.frame) + 10, size, size)];
    unlockView.delegate = self;
    [self.view addSubview: unlockView];
    
    otherAccountBt.frame = CGRectMake(CGRectGetMinX(unlockView.frame), CGRectGetMaxY(unlockView.frame) + 10, 160, 30);
    otherAccountBt.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    otherAccountBt.titleLabel.font = [UIFont systemFontOfSize:13.0f];
    [otherAccountBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [otherAccountBt setTitle:QMLocalizedString(@"qm_login_with_other_account", @"其他账号登陆") forState:UIControlStateNormal];
    [self.view addSubview:otherAccountBt];
    
    forgetBt.frame = CGRectMake(CGRectGetMaxX(unlockView.frame) - 160, CGRectGetMinY(otherAccountBt.frame), 160, 30);
    forgetBt.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [forgetBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    forgetBt.titleLabel.font = [UIFont systemFontOfSize:13.0f];
    [forgetBt setTitle:QMLocalizedString(@"qm_forget_rec_pwd", @"忘记手势密码") forState:UIControlStateNormal];
    [self.view addSubview:forgetBt];
}

- (UIBarButtonItem *)leftBarButtonItem {
    return [QMNavigationBarItemFactory createNavigationItemWithTitle:@" "
                                                              target:nil
                                                            selector:nil
                                                              isLeft:YES];
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
        nickNameLabel.text = [QMStringUtil getPromptPhoneNumberWithPhoneNumber:accountName];
    }
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
        //5次机会用完
        info.isUsingRecPwd = NO;
        info.recPwd = nil;
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"5次机会全部用完,手势密码将自动关闭" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        alertView.delegate = self;
        [alertView show];
 
        return;
    }
    NSString *userInput = [points componentsJoinedByString:@","];
    if ([userInput isEqualToString:info.recPwd]) {
        self.view.userInteractionEnabled = NO;
        if (QM_IS_DELEGATE_RSP_SEL(self.delegate, gesturePasswordViewControllerDidSuccess:)) {
            [self.delegate gesturePasswordViewControllerDidSuccess:self];
        }
    }else{
        LNLogError(@"输入手势密码错误");
        timesCount++;
        NSString *noteStr = [NSString stringWithFormat:@"密码错误,还可以输入%@次",[NSNumber numberWithInteger:5-timesCount]];
        noteLabel.text = noteStr;
        [self shakeView:noteLabel];
        [unlockView resetView];
    }
}

#pragma mark -
#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (QM_IS_DELEGATE_RSP_SEL(self.delegate, gesturePasswordViewControllerDidFailed:)) {
        [self.delegate gesturePasswordViewControllerDidFailed:self];
    }
}

@end
