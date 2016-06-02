//
//  QMMoreItemInfoCell.m
//  MotherMoney
//
//  Created by    on 14-8-10.
//  Copyright (c) 2014年   . All rights reserved.
//

#import "QMMoreItemInfoCell.h"

#define ICON_LEFT_PADDING 10
#define ICON_TOP_PADDING 10
#define ICON_SIZE_WIDTH 21
#define ICON_SIZE_HEIGHT 21

#define ICON_TITLE_PADDING 10

#define INDICATOR_RIGHT_PADDING 10
#define INDICATOR_SIZE_WIDTH 8
#define INDICATOR_SIZE_HEIGHT 12

@implementation QMMoreItemInfoCell {
    UIImageView *mIconImageView;
    UILabel *mTitleLabel;
    UILabel *mSubTitleLabel;
    UILabel *mDetailInfoLabel;
    UIImageView *mAccessoryImageView;
    
    UIFont *titleFont;
    UIFont *subTitleFont;
    
    BOOL mShowsIndicator;
    
    UIImageView *horizontalLineView;
    
    UIImageView *hasNewImageView;
}
@synthesize showsIndicator = mShowsIndicator;

@synthesize iconImageView = mIconImageView;
@synthesize titleLabel = mTitleLabel;
@synthesize subTitleLabel = mSubTitleLabel;
@synthesize detailInfoLabel = mDetailInfoLabel;
@synthesize accessoryImageView = mAccessoryImageView;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundView = [[UIImageView alloc] initWithFrame:self.bounds];
        self.selectedBackgroundView = [[UIImageView alloc] initWithFrame:self.bounds];
        
        
        // font
        titleFont = [UIFont systemFontOfSize:14];
        subTitleFont = [UIFont systemFontOfSize:10];
        
        // icon
        mIconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(ICON_LEFT_PADDING, (CGRectGetHeight(frame) - ICON_SIZE_HEIGHT) / 2.0f, ICON_SIZE_WIDTH, ICON_SIZE_HEIGHT)];
        [self.contentView addSubview:mIconImageView];
        
        // title
        mTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(mIconImageView.frame) + ICON_TITLE_PADDING, 0, 150, titleFont.lineHeight)];
        mTitleLabel.highlightedTextColor = QM_COMMON_CELL_HIGHLIGHTED_COLOR;
        mTitleLabel.font = titleFont;
        mTitleLabel.backgroundColor = [UIColor clearColor];
        mTitleLabel.textColor = [UIColor blackColor];
        [self.contentView addSubview:mTitleLabel];
        
        // sub title
        mSubTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(mTitleLabel.frame), 0, CGRectGetWidth(mTitleLabel.frame), subTitleFont.lineHeight)];
        mSubTitleLabel.textAlignment = NSTextAlignmentRight;
        mSubTitleLabel.font = subTitleFont;
        mSubTitleLabel.highlightedTextColor = QM_COMMON_CELL_HIGHLIGHTED_COLOR;
        mSubTitleLabel.textColor = QM_COMMON_SUB_TITLE_COLOR;
        [self.contentView addSubview:mSubTitleLabel];
        
        // indicator
        mAccessoryImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(frame) - INDICATOR_RIGHT_PADDING - INDICATOR_SIZE_WIDTH, (CGRectGetHeight(frame) - INDICATOR_SIZE_HEIGHT) / 2.0f, INDICATOR_SIZE_WIDTH, INDICATOR_SIZE_HEIGHT)];
        mAccessoryImageView.image = [UIImage imageNamed:@"arrow_right.png"];
        mAccessoryImageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        [self.contentView addSubview:mAccessoryImageView];
        
        // 有新消息
        hasNewImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        hasNewImageView.image = [UIImage imageNamed:@"new_message.png"];
        [self.contentView addSubview:hasNewImageView];
        [hasNewImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(mAccessoryImageView.mas_left).offset(-10.0f);
            make.size.equalTo(CGSizeMake(15, 15));
            make.centerY.equalTo(self.contentView.mas_centerY);
        }];
        
        horizontalLineView = [[UIImageView alloc] initWithImage:[QMImageFactory commonHorizontalLineImage]];
        horizontalLineView.frame = CGRectMake(ICON_LEFT_PADDING, CGRectGetHeight(frame) - 1, CGRectGetWidth(frame) - 2 * ICON_LEFT_PADDING, 1);
        horizontalLineView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self.contentView addSubview:horizontalLineView];
    }
    
    
    return self;
}

- (void)configureCellWithMoreItemInfo:(QMMoreItemInfo *)info {
    self.showsIndicator = info.showsIndicator;
    self.showsLine = info.showsLine;
    
    UIImageView *backgroundView = (UIImageView *)self.backgroundView;
    UIImageView *selectedBackgroundView = (UIImageView *)self.selectedBackgroundView;
    backgroundView.image = [[UIImage imageNamed:info.backgroundImageName] stretchableImageWithLeftCapWidth:info.imageSize.width / 2.0f topCapHeight:info.imageSize.height / 2.0f];
    selectedBackgroundView.image = [[UIImage imageNamed:info.selectedBgImageName] stretchableImageWithLeftCapWidth:info.imageSize.width / 2.0f topCapHeight:info.imageSize.height / 2.0f];
    
    // icon
    if (!QM_IS_STR_NIL(info.itemIconName)) {
        mIconImageView.image = [UIImage imageNamed:info.itemIconName];
    }else {
        mIconImageView.image = nil;
    }
    
    // title & subtitle
    if (!QM_IS_STR_NIL(info.itemTitle)) {
        mTitleLabel.text = info.itemTitle;
    }else {
        mTitleLabel.text = @"";
    }
    
    if (!QM_IS_STR_NIL(info.itemSubTitle)) {
        mSubTitleLabel.text = info.itemSubTitle;
    }else {
        mSubTitleLabel.text = @"";
    }
    
    if (!QM_IS_STR_NIL(info.itemSubTitle)) {
        // 两行
        CGRect frame = mTitleLabel.frame;
        frame.origin.y = (CGRectGetHeight(self.frame) - CGRectGetHeight(mTitleLabel.frame)) / 2.0f;
        mTitleLabel.frame = frame;
        
        mSubTitleLabel.frame = CGRectMake(CGRectGetMaxX(self.contentView.frame) - 123, (CGRectGetHeight(self.frame) - 20) / 2.0f, 100, 20);
    }else {
        // 单行
        CGRect frame = mTitleLabel.frame;
        frame.origin.y = (CGRectGetHeight(self.frame) - CGRectGetHeight(mTitleLabel.frame)) / 2.0f;
        mTitleLabel.frame = frame;
    }
    
    if (info.hasUnReadInfo) {
        hasNewImageView.hidden = NO;
    }else {
        hasNewImageView.hidden = YES;
    }
    
    if (self.showsLine) {
        horizontalLineView.hidden = NO;
    }else {
        horizontalLineView.hidden = YES;
    }
}

- (void)setShowsIndicator:(BOOL)showsIndicator {
    mShowsIndicator = showsIndicator;
    if (YES == mShowsIndicator) {
        mAccessoryImageView.hidden = NO;
    }else {
        mAccessoryImageView.hidden = YES;
    }
}

+ (CGFloat)getCellHeightForItemInfo:(QMMoreItemInfo *)info {
    return 50.0f;
}

@end
