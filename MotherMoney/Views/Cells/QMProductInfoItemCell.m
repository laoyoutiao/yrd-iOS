//
//  QMProductInfoItemCell.m
//  MotherMoney
//
//  Created by   on 14-8-16.
//  Copyright (c) 2014年  . All rights reserved.
//

#import "QMProductInfoItemCell.h"

@implementation QMProductInfoItemCell {
    UIImageView *indicatorView;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundView = [[UIImageView alloc] initWithImage:[QMImageFactory commonBackgroundImageCenterPart]];
        
        // title
        self.itemTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 100, CGRectGetHeight(frame))];
        self.itemTitleLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        self.itemTitleLabel.font = [UIFont systemFontOfSize:13];
        self.itemTitleLabel.textColor = QM_COMMON_TEXT_COLOR;
        [self.contentView addSubview:self.itemTitleLabel];
        
        // value
        self.itemValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(frame) - 100 - 15, 0, 100, CGRectGetHeight(frame))];
        self.itemValueLabel.textAlignment = NSTextAlignmentRight;
        self.itemValueLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        self.itemValueLabel.font = [UIFont systemFontOfSize:13];
        self.itemValueLabel.textColor = QM_COMMON_TEXT_COLOR;
        [self.contentView addSubview:self.itemValueLabel];
        
        // indicator
        indicatorView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"shearhead_2.png"]];
        indicatorView.frame = CGRectMake(CGRectGetWidth(frame) - 15 - 15, (CGRectGetHeight(frame) - 15.0f) / 2.0f, 15, 15);
        [self.contentView addSubview:indicatorView];
        
        UIImageView *horizontalLine = [[UIImageView alloc] initWithImage:[QMImageFactory commonHorizontalLineImage]];
        horizontalLine.frame = CGRectMake(15, CGRectGetHeight(frame) - 1, CGRectGetWidth(frame) - 2 * 15, 1);
        [self.contentView addSubview:horizontalLine];
    }
    return self;
}

- (void)setShowsIndicator:(BOOL)showsIndicator {
    if (YES == showsIndicator) {
        // 显示
        indicatorView.hidden = NO;
        CGRect frame = self.itemValueLabel.frame;
        frame.origin.x = CGRectGetMinX(indicatorView.frame) - CGRectGetWidth(frame);
        self.itemValueLabel.frame = frame;
    }else {
        // 隐藏
        indicatorView.hidden = YES;
        CGRect frame = self.itemValueLabel.frame;
        frame.origin.x = CGRectGetWidth(self.frame) - CGRectGetWidth(frame) - 15;
        self.itemValueLabel.frame = frame;
    }
}

+ (CGFloat)getCellHeightForProductInfo:(QMProductInfo *)info {
    return 44.0f;
}

+ (CGFloat)getCellHeightForCreditorsInfo:(QMCreditorsInfo *)info {
    return 44.0f;
}

@end
