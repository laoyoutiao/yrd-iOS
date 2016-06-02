#import "UIViewController+VENTouchLock.h"
#import "QMNavigationController.h"

@implementation UIViewController (VENTouchLock)

- (UINavigationController *)ventouchlock_embeddedInNavigationControllerWithNavigationBarClass:(Class)navigationBarClass
{
    QMNavigationController *navigationController = [[QMNavigationController alloc] initWithNavigationBarClass:navigationBarClass toolbarClass:nil];
    [navigationController updateNavigationBarBgWithCurrentBackgroundImage];
    [navigationController pushViewController:self animated:NO];
    return navigationController;
}

+ (UIViewController*)ventouchlock_topMostController
{
    UIViewController *topController = [UIApplication sharedApplication].keyWindow.rootViewController;

    while (topController.presentedViewController) {
        topController = topController.presentedViewController;
    }

    return topController;
}

@end