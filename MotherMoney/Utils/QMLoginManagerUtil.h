//
//  QMLoginManagerUtil.h
//  MotherMoney
//

#import <Foundation/Foundation.h>
#import "QMAccountInfo.h"

@interface QMLoginManagerUtil : NSObject

+ (void)showLoginViewControllerFromViewController:(UIViewController *)controller;

+ (void)showLoginViewControllerFromViewController:(UIViewController *)controller completion:(void (^ __nullable)(void))completion;

@end
