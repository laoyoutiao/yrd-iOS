//
//  QMMSplashViewController.m
//  MotherMoney
//

#import "QMMSplashViewController.h"
#import "QMInputPhoneNumberViewController.h"
#import "QMInputPasswordViewController.h"
#import "QMGesturePasswordViewController.h"

@interface QMMSplashViewController ()<QMGesturePasswordViewControllerDelegate, QMInputPasswordViewControllerDelegate>

@end

@implementation QMMSplashViewController {
    QMGesturePasswordViewController *gesturePwdViewController;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        __weak QMMSplashViewController *weakSelf = self;
        self.didFinishWithSuccess = ^(BOOL success, VENTouchLockSplashViewControllerUnlockType unlockType) {
            if (success) {
                switch (unlockType) {
                    case VENTouchLockSplashViewControllerUnlockTypeTouchID: {
                        [weakSelf attemptLoginToServerFromTouchID:YES];
                        break;
                    }
                    case VENTouchLockSplashViewControllerUnlockTypePasscode: {
                        
                        break;
                    }
                    default:
                        break;
                }
            }
            else {
                [[[UIAlertView alloc] initWithTitle:@"Limit Exceeded"
                                            message:@"You have exceeded the maximum number of passcode attempts"
                                           delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil] show];
            }
        };
    }
    return self;
}

// 其他账号登录
- (void)logInWithOtherAccount:(id)sender {
    QMInputPhoneNumberViewController *con = [[QMInputPhoneNumberViewController alloc] init];
    con.isModel = NO;
    con.showBackBtn = YES;
    [self.navigationController pushViewController:con animated:YES];
}

-(void)forgetRec {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)forgetRecPwd:(QMAccountInfo *)model {
    QMAccountInfo *accountInfo = [[QMAccountUtil sharedInstance] currentAccount];
    QMInputPasswordViewController *con = [[QMInputPasswordViewController alloc] initViewControllerWithAccountInfo:accountInfo shouldShowSwitch:YES];
    [self.navigationController pushViewController:con animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([QMAccountUtil sharedInstance].isUserUsingRectPwd) { // 正在使用手势密码，展示手势密码的界面
        
        QMAccountInfo *account = [QMAccountUtil sharedInstance].currentAccount;
        QMInputPasswordViewController *con = [[QMInputPasswordViewController alloc] initViewControllerWithAccountInfo:account shouldShowSwitch:YES];
        con.delegate = self;
        con.isModel = YES;
        con.showBackBtn = NO;
        
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];
        self.navigationItem.backBarButtonItem = item;
        
        
        gesturePwdViewController = [[QMGesturePasswordViewController alloc] init];
        [gesturePwdViewController.otherAccountBt addTarget:self action:@selector(logInWithOtherAccount:) forControlEvents:UIControlEventTouchUpInside];
        [gesturePwdViewController.forgetBt addTarget:self action:@selector(forgetRec) forControlEvents:UIControlEventTouchUpInside];
        gesturePwdViewController.delegate = self;

        NSArray *viewControllers = self.navigationController.viewControllers;
        NSMutableArray *array = [NSMutableArray arrayWithArray:viewControllers];
        [array addObject:con];
        [array addObject:gesturePwdViewController];
        [self.navigationController setViewControllers:array animated:NO];
    }else { // 没有使用手势密码，则展示登录的界面
        QMAccountInfo *account = [QMAccountUtil sharedInstance].currentAccount;
        QMInputPasswordViewController *con = [[QMInputPasswordViewController alloc] initViewControllerWithAccountInfo:account shouldShowSwitch:YES];
        con.delegate = self;
        con.isModel = YES;
        con.showBackBtn = NO;
        [self.navigationController pushViewController:con animated:NO];
    }

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
}

#pragma mark -
#pragma mark action
// 尝试登录操作
- (void)attemptLoginToServerFromTouchID:(BOOL)fromTouchID {
    // 尝试登录操作，成功则收起，否则做两外的处理，比如修改了密码
    QMAccountInfo *info = [[QMAccountUtil sharedInstance] currentAccount];
    NSString *accountName = info.phoneNumber;
    NSString *pwd = info.password;
    [[NetServiceManager sharedInstance] userLoginWithPhoneNumber:accountName
                                                             pwd:pwd
                                                        delegate:self
                                                         success:^(id responseObject) {
                                                             // 登录成功
                                                             [self dismissWithUnlockSuccess:YES unlockType:VENTouchLockSplashViewControllerUnlockTypePasscode animated:YES];
                                                         } failure:^(NSError *error) {
                                                             // 登录失败
                                                             // 说明密码错误，则需要用户修改密码，则需要用户清除一些信息
                                                             // 清除手势密码信息，清除Touch ID信息
                                                             if ([error code] == 7) {
                                                                 // 需要判断当前是手势密码，还是其他的
                                                                 if ([[QMAccountUtil sharedInstance] isUserUsingRectPwd]) {
                                                                     [[QMAccountUtil sharedInstance] closeRectPwd];
                                                                 }
                                                                 if (fromTouchID) {
                                                                     // 如果是从touchID过来的，则本页面已经收起，因此需要重新弹出一个页面
                                                                     QMAccountInfo *account = [[QMAccountUtil sharedInstance] currentAccount];
                                                                     QMInputPasswordViewController *con = [[QMInputPasswordViewController alloc] initViewControllerWithAccountInfo:account shouldShowSwitch:YES];
                                                                     con.isModel = YES;
                                                                     con.showBackBtn = YES;
                                                                     QMNavigationController *nav = [[QMNavigationController alloc] initWithRootViewController:con];
                                                                     [nav updateNavigationBarBgWithCurrentBackgroundImage];
                                                                     
                                                                     UIViewController *rootViewController = [[UIApplication sharedApplication].keyWindow rootViewController];
                                                                     [rootViewController presentViewController:nav animated:YES
                                                                                                    completion:^{
                                                                                                        [CMMUtility showNote:@"密码错误，请重新登录"];
                                                                                                    }];
                                                                 }else {
                                                                     [CMMUtility showNote:@"密码错误，请重新登录"];
                                                                     [self.navigationController popViewControllerAnimated:YES];
                                                                 }
                                                             }
                                                         }];
}

#pragma mark -
#pragma mark QMGesturePasswordViewControllerDelegate
- (void)gesturePasswordViewControllerDidSuccess:(QMGesturePasswordViewController *)viewController {
    if (viewController == gesturePwdViewController) {
        [self attemptLoginToServerFromTouchID:NO];
    }
}

- (void)gesturePasswordViewControllerDidFailed:(QMGesturePasswordViewController *)viewController {
    // 手势密码输入失败
    // 进入输入密码页面，进行手动输入密码登录的逻辑
    [self.navigationController popViewControllerAnimated:YES];
}


// 普通密码登录回调
#pragma mark -
#pragma mark QMInputPasswordViewControllerDelegate
- (void)passwordViewControllerDidLoginSuccess:(QMInputPasswordViewController *)viewController {
    // 登录成功
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)passwordViewControllerDidLoginFailed:(QMInputPasswordViewController *)viewController {
    // 登录失败怎么处理呢？
    // 暂时先什么都不做吧
}


@end

