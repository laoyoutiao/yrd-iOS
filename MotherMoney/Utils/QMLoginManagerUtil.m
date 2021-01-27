//
//  QMLoginManagerUtil.m
//  MotherMoney
//

#import "QMLoginManagerUtil.h"
#import "QMInputPhoneNumberViewController.h"
#import "QMInputPasswordViewController.h"

@implementation QMLoginManagerUtil

+ (QMAccountInfo *)getCurrentAccountInfo; {
    return [[QMAccountUtil sharedInstance] currentAccount];
}

+ (void)showLoginViewControllerFromViewController:(UIViewController *)controller {
    QMAccountInfo *account = [self getCurrentAccountInfo];
    if (NO == [account isLogin]) {
        // 没有账号，直接注册
        QMInputPhoneNumberViewController *con = [[QMInputPhoneNumberViewController alloc] init];

        con.isModel = YES;
//        con.showBackBtn = NO;
        con.showBackBtn = YES;
        QMNavigationController *nav = [[QMNavigationController alloc] initWithRootViewController:con];
        [nav updateNavigationBarBgWithCurrentBackgroundImage];
        [controller presentViewController:nav animated:YES completion:^{
            
        }];
//        [controller showViewController:nav sender:nil];
    }else {
        // 已经有账号了，填写密码登录
        QMInputPasswordViewController *con = [[QMInputPasswordViewController alloc] initViewControllerWithAccountInfo:account shouldShowSwitch:YES];
        con.isModel = YES;
//        con.showBackBtn = NO;
        con.showBackBtn = YES;
        QMNavigationController *nav = [[QMNavigationController alloc] initWithRootViewController:con];
        [nav updateNavigationBarBgWithCurrentBackgroundImage];
        [controller presentViewController:nav animated:YES
                        completion:^{
                            
                        }];
    }
}

+ (void)showLoginViewControllerFromViewController:(UIViewController *)controller completion:(void (^ __nullable)(void))completion{
    QMAccountInfo *account = [self getCurrentAccountInfo];
    if (NO == [account isLogin]) {
        // 没有账号，直接注册
        QMInputPhoneNumberViewController *con = [[QMInputPhoneNumberViewController alloc] init];
        
        con.isModel = YES;
        //        con.showBackBtn = NO;
        con.showBackBtn = YES;
        QMNavigationController *nav = [[QMNavigationController alloc] initWithRootViewController:con];
        [nav updateNavigationBarBgWithCurrentBackgroundImage];
        [controller presentViewController:nav animated:YES completion:^{
            
        }];
        //        [controller showViewController:nav sender:nil];
    }else {
        // 已经有账号了，填写密码登录
        QMInputPasswordViewController *con = [[QMInputPasswordViewController alloc] initViewControllerWithAccountInfo:account shouldShowSwitch:YES];
        con.isModel = YES;
        //        con.showBackBtn = NO;
        con.showBackBtn = YES;
        QMNavigationController *nav = [[QMNavigationController alloc] initWithRootViewController:con];
        [nav updateNavigationBarBgWithCurrentBackgroundImage];
        [controller presentViewController:nav animated:YES
                               completion:^{
                                   
                               }];
    }
    completion();
}

@end
