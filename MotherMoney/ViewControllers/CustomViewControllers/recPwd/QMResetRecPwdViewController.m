
#import "QMResetRecPwdViewController.h"

@interface QMResetRecPwdViewController ()

@end

@implementation QMResetRecPwdViewController {
    UIImageView *containerView;
    UIImageView *horizontalLine;
    
    UILabel *securePromptLabel;
}
@synthesize miniLockView;
@synthesize noteLabel;
@synthesize resetBt;
@synthesize lastPoints;
@synthesize lockView;
@synthesize showPass;

-(id)initWithShowPass:(BOOL)showPass1 {
    if (self = [super init]) {
        self.showPass = showPass1;
    }
    return self;
}

//////
- (void)onBack {
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        
    }];
}


- (UIBarButtonItem *)leftBarButtonItem {
    if (self.showPass) {
        return [QMNavigationBarItemFactory createNavigationBackItemWithTarget:self selector:@selector(onBack)];
    }
    
    return nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpContainerView];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:QMLocalizedString(@"", @"") style:UIBarButtonItemStyleBordered target:self action:@selector(cancelBtnClicked:)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    //设置视图的背景颜色
    self.view.backgroundColor = QM_COMMON_BACKGROUND_COLOR;
    
    resetBt = [UIButton buttonWithType:UIButtonTypeCustom];
    resetBt.frame = CGRectMake(110, CGRectGetHeight(self.view.frame) - 40 - 64 , 100, 30);
    [resetBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    resetBt.titleLabel.font = [UIFont systemFontOfSize:13];
    resetBt.hidden = YES;
    [resetBt addTarget:self action:@selector(resetRecPwd) forControlEvents:UIControlEventTouchUpInside];
    [resetBt setTitle:@"重新绘制" forState:UIControlStateNormal];
    [self.view addSubview:resetBt];
}

- (void)setUpContainerView {
    containerView = [[UIImageView alloc] initWithImage:[QMImageFactory commonBackgroundImage]];
    containerView.userInteractionEnabled = YES;
    containerView.frame = CGRectMake(8, 8, CGRectGetWidth(self.view.frame) - 2 * 8, 390);
    [self.view addSubview:containerView];
    
    // mini lock
    miniLockView = [[QMMiniLockView alloc] initWithFrame:CGRectMake((CGRectGetWidth(containerView.frame) - 38.0f) / 2.0f, 23, 30, 30)];
    [containerView addSubview:miniLockView];
    
    // 文案
    noteLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(miniLockView.frame) + 10, CGRectGetWidth(containerView.frame), 13)];
    noteLabel.font = [UIFont systemFontOfSize:11];
    noteLabel.textColor = QM_COMMON_SUB_TITLE_COLOR;
    noteLabel.textAlignment = NSTextAlignmentCenter;
    noteLabel.text = QMLocalizedString(@"qm_gesture_password_draw_gesture", @"绘制手势密码");
    noteLabel.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    [containerView addSubview:noteLabel];
    
    // horizontal line
    horizontalLine = [[UIImageView alloc] initWithImage:[QMImageFactory commonHorizontalLineImage]];
    horizontalLine.frame = CGRectMake(15, CGRectGetMaxY(noteLabel.frame) + 10, CGRectGetWidth(containerView.frame) - 2 * 15, 1);
    [containerView addSubview:horizontalLine];
    
    // lock view
    CGFloat size = 230;
    lockView = [[NineGridUnlockView alloc] initWithFrame:CGRectMake((CGRectGetWidth(containerView.frame) - size) / 2.0f, CGRectGetMaxY(horizontalLine.frame) + 20
                                                                    , size, size)];
    lockView.delegate = self;
    [containerView addSubview:lockView];
    
    // prompt
    securePromptLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(lockView.frame) + 15, CGRectGetWidth(containerView.frame), 13)];
    securePromptLabel.textColor = QM_COMMON_SUB_TITLE_COLOR;
    securePromptLabel.font = [UIFont systemFontOfSize:11];
    securePromptLabel.textAlignment = NSTextAlignmentCenter;
    securePromptLabel.text = QMLocalizedString(@"qm_gesture_password_prompt_text", @"设置手势密码，防止他人未经授权查看");
    [containerView addSubview:securePromptLabel];
}

-(void)cancelBtnClicked:(id)sender {

}

-(void)baseBack {

}

- (void)unlockerView:(NineGridUnlockView*)unlockerView didFinished:(NSArray*)points {
    //记住第一次的密码
    if (self.lastPoints == nil || self.lastPoints.count == 0) {
        [miniLockView refreshWithInfo:points];
        if (![self rememberLastPoints:points]) {
            return;
        }
        [lockView resetView];
        noteLabel.text = QMLocalizedString(@"qm_gesture_password_draw_again", @"再次绘制手势密码");
        [self shakeView:noteLabel];
    }else {
        NSString *lastStr = [self.lastPoints componentsJoinedByString:@","];
        NSString *secStr = [points componentsJoinedByString:@","];
        //两次是一样的密码
        if ([lastStr isEqualToString:secStr]) {
            [self userSetRecPwdSuccess:points];
        }else {
            [self userInputDiffPwd];
        }
        
        
    }
}


-(BOOL)rememberLastPoints:(NSArray *)points {
    if (points.count < 4) {
        self.noteLabel.text = QMLocalizedString(@"qm_gesture_password_too_short", @"输入的密码不能少于4位");
        [self shakeView:self.noteLabel];
        return NO;
    }
    
    if (self.lastPoints == nil) {
        self.lastPoints = [NSMutableArray arrayWithCapacity:5];
    }
    if (self.lastPoints.count > 0 ) {
        [self.lastPoints removeAllObjects];
    }
    //记录上次的记录
    [self.lastPoints addObjectsFromArray:points];
    return YES;
}

-(void)userInputDiffPwd {
    self.resetBt.hidden = NO;
    self.noteLabel.text = QMLocalizedString(@"qm_gesture_password_diff_prompt_text", @"与上次绘制不一致，请重新绘制");
    [self shakeView:self.noteLabel];
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


-(void)resetRecPwd {
    [self.lockView resetView];
    [self.miniLockView refreshWithInfo:nil];
    self.resetBt.hidden = YES;
    self.noteLabel.text = QMLocalizedString(@"qm_gesture_password_draw_gesture", @"绘制手势密码");
    if (self.lastPoints.count > 0) {
        [self.lastPoints removeAllObjects];
    }
}


-(void)userSetRecPwdSuccess:(NSArray *)points {
    NSString *rectPwd = [points componentsJoinedByString:@","];
    
    [[QMAccountUtil sharedInstance] openRectPwd:rectPwd];
    
    if (QM_IS_DELEGATE_RSP_SEL(self.delegate, rectPwdViewController:didSetSuccessfully:)) {
        [self.delegate rectPwdViewController:self didSetSuccessfully:rectPwd];
    }
}

#pragma mark -
#pragma mark Override
- (NSString *)title {
    return QMLocalizedString(@"qm_gesture_password_reset_nav_title", @"设置手势密码");
}


@end
