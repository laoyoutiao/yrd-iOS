//
//  QMGestureWindow.m
//  MotherMoney
//

//

#import "QMGestureWindow.h"
#import "QMFrameUtil.h"
#import "QMPAGesturePasswordViewController.h"
#import "QMResetRecPwdViewController.h"

@implementation QMGestureWindow {
    BOOL bPreparedGes;
    BOOL bShowGes;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        bPreparedGes = NO;
        bShowGes = NO;
    }
    
    return self;
}

- (void)becomeKeyWindow {
    [UIView animateWithDuration:0.5 animations:^{
        self.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    } completion:^(BOOL finished) {
        [[NSNotificationCenter defaultCenter] postNotificationName:NF_GESTUREWINDOW_AFTER_BECOME_KEYWINDOW object:nil];
    }];
}

- (void)resignKeyWindow {
    [UIView animateWithDuration:0.5 animations:^{
        self.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, self.frame.size.height);
    } completion:^(BOOL finished) {
        [[NSNotificationCenter defaultCenter] postNotificationName:NF_GESTUREWINDOW_AFTER_RESIGN_KEYWINDOW object:nil];
    }];
}

#pragma mark - gesture
- (void)prepareGesturePwdWindow {
    if (bShowGes) {
        return;
    }
    
    if ([QMFrameUtil hasGesturePassword]) {
        if (!bPreparedGes) {
            QMResetRecPwdViewController *gestureCon = [[QMResetRecPwdViewController alloc] initWithShowPass:NO];
            QMNavigationController *gestureNavCon = [[QMNavigationController alloc] initWithRootViewController:gestureCon];
            [self setRootViewController:gestureNavCon];
        }
        
        self.windowLevel = UIWindowLevelNormal - 1;
    }
}

- (void)tryShowGesturePwdWindow {
    if ([QMFrameUtil hasGesturePassword]) {
        
        
        
        if (!bPreparedGes) {
            bPreparedGes = YES;
            
            QMPAGesturePasswordViewController *gestureCon = [[QMPAGesturePasswordViewController alloc] init];
            
            QMNavigationController *gestureNavCon = [[QMNavigationController alloc] initWithRootViewController:gestureCon];
            [gestureNavCon updateNavigationBarBgWithCurrentBackgroundImage];
            [self setRootViewController:gestureNavCon];
        }
        
        bShowGes = YES;
        self.windowLevel = UIWindowLevelAlert + 1;
        [self makeKeyAndVisible];
    }
}

- (void)tryHideGesturePwdWindow:(BOOL)animated {
    bShowGes = NO; // 因为有动画，所以需要有一个变量来保存状态，而不能直接有
    if (animated) {
        [[AppDelegate appDelegate].window makeKeyWindow];
    }else{
        [[AppDelegate appDelegate].window makeKeyAndVisible];
    }
}

- (void)handleWindowDidBecomeKeyNotification:(NSNotification*)notification {

}


@end
