//
//  QMGestureWindow.h
//  MotherMoney
//

//

#import <UIKit/UIKit.h>

#define NF_GESTUREWINDOW_AFTER_BECOME_KEYWINDOW   @"nf_gesturewindow_after_become_keywindow"
#define NF_GESTUREWINDOW_AFTER_RESIGN_KEYWINDOW   @"nf_gesturewindow_after_resign_keywindow"

@interface QMGestureWindow : UIWindow

- (void)tryShowGesturePwdWindow;
- (void)tryHideGesturePwdWindow:(BOOL)animated;
- (void)handleWindowDidBecomeKeyNotification:(NSNotification*)notification;

- (void)prepareGesturePwdWindow;

@end
