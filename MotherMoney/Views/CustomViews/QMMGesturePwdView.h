//
//  QMMGesturePwdView.h
//  MotherMoney

#import <UIKit/UIKit.h>

@protocol QMMGesturePwdViewDelegate;
@interface QMMGesturePwdView : UIView
@property (nonatomic, strong) UIButton *otherAccountBt;
@property (nonatomic, strong) UIButton *forgetBt;
@property (nonatomic, weak) id<QMMGesturePwdViewDelegate> delegate;


-(void)setUserInfo;

@end

@protocol QMMGesturePwdViewDelegate <NSObject>

- (void)gesturePwdViewDidSuccess:(QMMGesturePwdView *)gestureView;

- (void)gesturePwdViewDidFailed:(QMMGesturePwdView *)gesture;

@end


