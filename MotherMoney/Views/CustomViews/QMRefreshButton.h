//
//  QMRefreshButton.h
//  MotherMoney
//

#import <UIKit/UIKit.h>

@interface QMRefreshButton : UIButton
@property(nonatomic) NSInteger type;

- (BOOL)isAnimating;
- (void)startAnimation;
- (void)stopAnimation;

@end
