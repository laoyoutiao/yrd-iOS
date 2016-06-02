//
//  QMProgressView.m
//  MotherMoney
//
//  Created by   on 14-8-13.
//  Copyright (c) 2014年  . All rights reserved.
//

#import "QMProgressView.h"
#import "UIImage+Gradient.h"

@implementation QMProgressView {
    UIImageView *backgroundImageView;
    UIImageView *currentProgressView;
    
    UIImageView *anchorPointView;
    UILabel *progressValueLabel;
    
    CGSize size;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        size = CGSizeMake(CGRectGetWidth(frame), CGRectGetHeight(frame));
        
        // Initialization code
        backgroundImageView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"common_progress_bar_bg.png"] stretchableImageWithLeftCapWidth:15 topCapHeight:6]];
        backgroundImageView.layer.cornerRadius = CGRectGetHeight(frame) / 2.0f;
        backgroundImageView.layer.masksToBounds = YES;
        [self addSubview:backgroundImageView];
        [backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(UIEdgeInsetsZero);
        }];
        
        currentProgressView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [backgroundImageView addSubview:currentProgressView];
        
        anchorPointView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"progress_bar_mark.png"]];
        anchorPointView.frame = CGRectMake(0, -40, 55, 40);
        [self addSubview:anchorPointView];
        
        progressValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 8, CGRectGetWidth(anchorPointView.frame), 16)];
        progressValueLabel.font = [UIFont boldSystemFontOfSize:14];
        progressValueLabel.textColor = QM_THEME_COLOR;
        progressValueLabel.textAlignment = NSTextAlignmentCenter;
        [anchorPointView addSubview:progressValueLabel];
        [anchorPointView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(currentProgressView.mas_right);
            make.centerY.equalTo(-20.0f);
            make.size.equalTo(CGSizeMake(55, 40));
        }];
    }
    
    return self;
}

- (void)setCurrentProgress:(CGFloat)progress {
    [currentProgressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.removeExisting = YES;
        make.left.equalTo(backgroundImageView.mas_left);
        make.top.equalTo(backgroundImageView.mas_top);
        make.height.equalTo(backgroundImageView.mas_height);
        make.width.equalTo(backgroundImageView.mas_width).multipliedBy(progress);
    }];

    currentProgressView.image = [UIImage gradientImageFromColors:[NSArray arrayWithObjects:[UIColor colorWithRed:255.0f / 255.0f green:145.0f / 255.0f blue:50.0f / 255.0f alpha:1.0f], [UIColor colorWithRed:251.0f green:118.0f / 255.0f blue:62.0f/255.0f alpha:1.0f], nil] withSize:CGSizeMake(size.width * progress, size.height)];
    
    progressValueLabel.text = [NSString stringWithFormat:@"%.1f%%", progress * 100];
}

@end
