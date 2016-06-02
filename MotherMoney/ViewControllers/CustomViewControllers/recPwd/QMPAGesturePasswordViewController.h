//
//  QMPAGesturePasswordViewController.h
//  MotherMoney
//

//

#import "QMViewController.h"
#import "NineGridUnlockView.h"

@interface QMPAGesturePasswordViewController : QMViewController {
    UIImageView *portraitImageView;
    UILabel *nickNameLabel;
    UILabel *noteLabel;
    NSInteger timesCount;
    BOOL isRoot;
    NineGridUnlockView *unlockView;
}

@property (nonatomic, strong) NineGridUnlockView *unlockView;
@property (nonatomic, strong) UILabel *noteLabel;
@property (nonatomic, strong) UIImageView *portraitImageView;
@property (nonatomic, strong) UILabel *nickNameLabel;
@property (nonatomic, assign) NSInteger timesCount;
@property (nonatomic, assign) BOOL isRoot;

@end