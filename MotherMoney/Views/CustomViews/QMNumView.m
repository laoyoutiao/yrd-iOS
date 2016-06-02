//
//  QMNumView.m
//  MotherMoney
//
//  Created by   on 14-8-16.
//  Copyright (c) 2014年  . All rights reserved.
//

#import "QMNumView.h"

@implementation QMNumView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // value
        self.numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, CGRectGetWidth(frame), 15)];
        self.numberLabel.textAlignment = NSTextAlignmentCenter;
        self.numberLabel.font = [UIFont systemFontOfSize:13];
        self.numberLabel.textColor = [UIColor blackColor];
        [self addSubview:self.numberLabel];
        
        // title
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.numberLabel.frame) + 2, CGRectGetWidth(frame), 13)];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.font = [UIFont systemFontOfSize:11];
        self.titleLabel.textColor = QM_COMMON_SUB_TITLE_COLOR;
        [self addSubview:self.titleLabel];
    }
    return self;
}


@end
