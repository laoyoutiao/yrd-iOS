//
//  QMProgressView.h
//  MotherMoney
//
//  Created by   on 14-8-13.
//  Copyright (c) 2014年  . All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QMProgressView : UIView

- (void)setCurrentProgress:(CGFloat)progress;
- (void)overCurrentProgress:(CGFloat)progress;

@end
