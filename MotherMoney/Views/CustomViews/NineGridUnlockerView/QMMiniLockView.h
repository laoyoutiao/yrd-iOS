
/**
 手势解锁上方的mini九宫格
 */

#import <UIKit/UIKit.h>

@interface QMMiniLockView : UIView
{
    NSMutableArray *dotArray;
}

@property (nonatomic,retain)    NSMutableArray *dotArray;


-(void)refreshWithInfo:(NSArray *)info;


@end
