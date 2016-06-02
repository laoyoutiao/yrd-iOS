//
//  QMMGesturePwdView.m
//  MotherMoney

#import "QMMGesturePwdView.h"
#import "NineGridUnlockView.h"

@interface QMMGesturePwdView ()<NinGridUnlockViewDelegate, UIAlertViewDelegate>
@property (nonatomic, strong) NineGridUnlockView *unlockView;
@property (nonatomic, strong) UILabel *noteLabel;
@property (nonatomic, strong) UIImageView *portraitImageView;
@property (nonatomic, strong) UILabel *nickNameLabel;
@property (nonatomic, assign) NSInteger timesCount;
@property (nonatomic, assign) BOOL isRoot;

@end

@implementation QMMGesturePwdView {
    UIImageView *portraitImageView;
    UILabel *nickNameLabel;
    UILabel *noteLabel;
    NSInteger timesCount;
    BOOL isRoot;
    NineGridUnlockView *unlockView;
    
    UIButton *otherAccountBt;
    UIButton *forgetBt;
}
@synthesize portraitImageView = portraitImageView;
@synthesize nickNameLabel = nickNameLabel;
@synthesize noteLabel = noteLabel;
@synthesize timesCount = timesCount;
@synthesize isRoot = isRoot;
@synthesize unlockView = unlockView;

@synthesize otherAccountBt = otherAccountBt;
@synthesize forgetBt = forgetBt;


- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithPatternImage:[QMImageFactory commonScaledFullScreenBackgroundImage]];
        
        nickNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 110 - [[AppDelegate appDelegate] navigationBarAndStatusBarHeight], CGRectGetWidth([UIScreen mainScreen].bounds), 25.0f)];
        nickNameLabel.text = @"";
        nickNameLabel.textColor = [UIColor whiteColor];
        nickNameLabel.backgroundColor = [UIColor clearColor];
        nickNameLabel.font = [UIFont systemFontOfSize:16.0f];
        nickNameLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:nickNameLabel];
        
        noteLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(nickNameLabel.frame) + 2.0f, CGRectGetWidth([UIScreen mainScreen].bounds) - 2 * 10, 20)];
        noteLabel.backgroundColor = [UIColor clearColor];
        noteLabel.textColor = [UIColor whiteColor];
        noteLabel.font = [UIFont systemFontOfSize:13.0f];
        noteLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:noteLabel];
        
        CGFloat size = [UIScreen mainScreen].bounds.size.width - 2 * 30;
        unlockView = [[NineGridUnlockView alloc] initWithFrame:CGRectMake(30, CGRectGetMaxY(noteLabel.frame) + 10, size, size)];
        unlockView.delegate = self;
        [self addSubview: unlockView];
        
        otherAccountBt = [UIButton buttonWithType:UIButtonTypeCustom];
        otherAccountBt.frame = CGRectMake(CGRectGetMinX(unlockView.frame), CGRectGetMaxY(unlockView.frame) + 10, 160, 30);
        otherAccountBt.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        otherAccountBt.titleLabel.font = [UIFont systemFontOfSize:13.0f];
        [otherAccountBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [otherAccountBt setTitle:QMLocalizedString(@"qm_login_with_other_account", @"其他账号登陆") forState:UIControlStateNormal];
        [self addSubview:otherAccountBt];
        
        forgetBt = [UIButton buttonWithType:UIButtonTypeCustom];
        forgetBt.frame = CGRectMake(CGRectGetMaxX(unlockView.frame) - 160, CGRectGetMinY(otherAccountBt.frame), 160, 30);
        forgetBt.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [forgetBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        forgetBt.titleLabel.font = [UIFont systemFontOfSize:13.0f];
        [forgetBt setTitle:QMLocalizedString(@"qm_forget_rec_pwd", @"忘记手势密码") forState:UIControlStateNormal];
        [self addSubview:forgetBt];
    }
    
    return self;
}

// 将用户信息显示在UI上
-(void)setUserInfo {
    // 显示手机号
    QMAccountInfo *account = [[QMAccountUtil sharedInstance] currentAccount];
    NSString *accountName = account.phoneNumber;
    if (!QM_IS_STR_NIL([QMStringUtil getPromptPhoneNumberWithPhoneNumber:accountName])) {
        self.nickNameLabel.text = [QMStringUtil getPromptPhoneNumberWithPhoneNumber:accountName];
    }
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
        
//        // 退出登录
//        [[NetServiceManager sharedInstance] userLogoutWithWithDelegate:self
//                                                               success:^(id responseObject) {
//                                                                   // 登出成功
//                                                                   [[NSNotificationCenter defaultCenter] postNotificationName:QM_LOGOUT_SUCCESS_NOTIFICATION_KEY object:nil];
//                                                               } failure:^(NSError *error) {
//                                                                   // 登出失败
//                                                                   [[NSNotificationCenter defaultCenter] postNotificationName:QM_LOGOUT_SUCCESS_NOTIFICATION_KEY object:nil];
//                                                               }];
        
        return;
    }
    NSString *userInput = [points componentsJoinedByString:@","];
    if ([userInput isEqualToString:info.recPwd]) {
        self.userInteractionEnabled = NO;
        
        // 手势密码登录成功，通知delegate
        if (QM_IS_DELEGATE_RSP_SEL(self.delegate, gesturePwdViewDidSuccess:)) {
            [self.delegate gesturePwdViewDidSuccess:self];
        }
    }else{
        //
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
//    [self forgetRecPwd:[[QMAccountUtil sharedInstance] currentAccount]];
}

@end
