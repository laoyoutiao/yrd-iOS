//
//  QMFrameUtil.h
//  MotherMoney
//


#import <Foundation/Foundation.h>

@interface QMFrameUtil : NSObject<UIAlertViewDelegate>
//单例
+ (QMFrameUtil *)sharedInstance;

+ (BOOL)hasShownWelcomPage;

+ (void)setHasShownWelcomepage;

+ (BOOL)hasGesturePassword;

- (void)parsePush:(NSDictionary *)dict;

@end
