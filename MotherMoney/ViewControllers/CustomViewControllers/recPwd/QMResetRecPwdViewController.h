//
//  QMResetRecPwdViewController.h
//  MotherMoney
//

//

#import "QMViewController.h"
#import "NineGridUnlockView.h"
#import "QMMiniLockView.h"

// 设置手势密码
@protocol QMResetRecPwdViewControllerDelegate;

@interface QMResetRecPwdViewController : QMViewController<NinGridUnlockViewDelegate> {
    QMMiniLockView *miniLockView;
    UILabel *noteLabel;
    UIButton *resetBt;
    NineGridUnlockView *lockView;
    NSMutableArray *lastPoints;
    BOOL showPass;
}
@property (nonatomic,retain)     UILabel *noteLabel;
@property (nonatomic,retain)    QMMiniLockView *miniLockView;
@property (nonatomic,retain)    UIButton *resetBt;
@property (nonatomic,retain)     NSMutableArray *lastPoints;
@property (nonatomic,retain)    NineGridUnlockView *lockView;
@property (nonatomic,assign)    BOOL showPass;
@property (nonatomic, weak) id<QMResetRecPwdViewControllerDelegate> delegate;

-(id)initWithShowPass:(BOOL)showPass;

@end

@protocol QMResetRecPwdViewControllerDelegate <NSObject>

- (void)rectPwdViewController:(QMResetRecPwdViewController *)controller didSetSuccessfully:(NSString *)newRecPwd;

@end

