//
//  QMRefreshButton.m
//  MotherMoney
//
//

#import "QMRefreshButton.h"

@implementation QMRefreshButton {
    BOOL _isAnimating;
    NSTimer *_timer;
}
@synthesize type;

- (BOOL)isAnimating {
    return _isAnimating;
}

- (void)startAnimation {
    if (!_isAnimating) {
        if (self.type == 1) {
            [self setImage:[UIImage imageNamed:@"all_top_icon_loading"] forState:UIControlStateNormal];
        } else {
            [self setImage:[UIImage imageNamed:@"all_top_icon_loading2"] forState:UIControlStateNormal];
        }
        _timer = [NSTimer timerWithTimeInterval:1.0f target:self selector:@selector(rotation) userInfo:nil repeats:YES];
        [_timer fire];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
        _isAnimating = YES;
    }
}

- (void)rotation {
    [self.layer addAnimation:[self rotationAnimation] forKey:@"rotation"];
}

- (CAKeyframeAnimation *)rotationAnimation {
    CAKeyframeAnimation *rotateAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotateAnimation.values = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0.0f],[NSNumber numberWithFloat:M_PI * 2], nil];
    rotateAnimation.duration = 1.0f;
    rotateAnimation.keyTimes = [NSArray arrayWithObjects:
                                [NSNumber numberWithFloat:.0],
                                [NSNumber numberWithFloat:1.0],nil];
    rotateAnimation.fillMode = kCAFillModeForwards;
    rotateAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    return rotateAnimation;
}

- (void)stopAnimation {
    if (_isAnimating) {
        [_timer invalidate];
        _isAnimating = NO;
    }
}


@end
