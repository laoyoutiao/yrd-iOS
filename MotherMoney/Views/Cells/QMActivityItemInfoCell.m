//
//  QMActivityItemInfoCell.m
//  MotherMoney
//
//  Created by    on 14-8-10.
//  Copyright (c) 2014年   . All rights reserved.
//

#import "QMActivityItemInfoCell.h"
#import "UIImageView+WebCache.h"

@implementation QMActivityItemInfoCell {
    UIImageView *activityImageView;
    UILabel *activityTitleLabel;
    
    UIView *containerView;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundView = [[UIImageView alloc] initWithImage:[QMImageFactory commonBackgroundImage]];
        
        containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame))];
        containerView.layer.cornerRadius = 5.0f;
        containerView.layer.masksToBounds = YES;
        
        // image view
        activityImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.5, 0.5, CGRectGetWidth(frame) - 1, 100 * CGRectGetWidth([UIScreen mainScreen].bounds) / 320)];
        activityImageView.contentMode = UIViewContentModeScaleToFill;
        [containerView addSubview:activityImageView];
        
        // title
        activityTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(activityImageView.frame), CGRectGetWidth(frame) - 2 * 10, 40)];
        activityTitleLabel.font = [UIFont systemFontOfSize:13];
        activityTitleLabel.textColor = [UIColor colorWithRed:56.0f / 255.0f green:56.0f / 255.0f blue:56.0f / 255.0f alpha:1.0f];
        [containerView addSubview:activityTitleLabel];
        
        [self.contentView addSubview:containerView];
    }
    
    return self;
}

+ (CGFloat)getCellHeightForActivityInfo:(QMActivityItemInfo *)info {
    return 100.0f * CGRectGetWidth([UIScreen mainScreen].bounds) / 320 + 40;
}

- (void)configureCellWithItemInfo:(QMActivityItemInfo *)info {
    [activityImageView sd_setImageWithURL:[NSURL URLWithString:info.picPath] placeholderImage:nil];
    
    activityTitleLabel.text = info.name;
}

@end
