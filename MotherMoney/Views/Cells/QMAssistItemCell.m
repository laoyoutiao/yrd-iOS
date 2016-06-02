//
//  QMAssistItemCell.m
//  MotherMoney
//
//  Created by    on 14-8-10.
//  Copyright (c) 2014年   . All rights reserved.
//

#import "QMAssistItemCell.h"

@implementation QMAssistItemCell {
    UILabel *assistNameLabel;
    UILabel *assistContentLabel;
    UIImageView *horizontalLine;
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundView = [[UIImageView alloc] initWithImage:[QMImageFactory commonBackgroundImage]];
        self.selectedBackgroundView = [[UIImageView alloc] initWithImage:[QMImageFactory commonBackgroundImagePressed]];
        
        assistNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 200, 16)];
        assistNameLabel.font = [UIFont systemFontOfSize:14];
        assistNameLabel.highlightedTextColor = QM_COMMON_CELL_HIGHLIGHTED_COLOR;
        assistNameLabel.numberOfLines = 1;
        assistNameLabel.textColor = QM_COMMON_TEXT_COLOR;
        [self.contentView addSubview:assistNameLabel];
        
        horizontalLine = [[UIImageView alloc] initWithImage:[QMImageFactory commonHorizontalLineImage]];
        horizontalLine.frame = CGRectMake(10, CGRectGetMaxY(assistNameLabel.frame) + 5, CGRectGetWidth(self.frame) - 2 * 10, 1);
        horizontalLine.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self.contentView addSubview:horizontalLine];
        
        assistContentLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(horizontalLine.frame), CGRectGetMaxY(horizontalLine.frame) + 5, CGRectGetWidth(horizontalLine.frame), 10)];
        assistContentLabel.numberOfLines = 0;
        assistContentLabel.highlightedTextColor = QM_COMMON_CELL_HIGHLIGHTED_COLOR;
        assistContentLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        assistContentLabel.font = [UIFont systemFontOfSize:12];
        assistContentLabel.textColor = QM_COMMON_SUB_TITLE_COLOR;
        [self.contentView addSubview:assistContentLabel];
    }
    
    return self;
}

+ (CGFloat)getCellHeightForItem:(QMAssistItem *)item {
    CGRect rect = [[UIScreen mainScreen] bounds];
    CGSize size = [item.helpContent boundingRectWithSize:CGSizeMake(CGRectGetWidth(rect) - 2 * 10 - 2 * 10, 100000)
                                                   options:NSStringDrawingUsesLineFragmentOrigin
                                                attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:12], NSFontAttributeName, nil]
                                                   context:nil].size;
    
    
    return size.height + 5 + 16 + 5 + 1 + 5 + 5;
}

- (void)configureCellWithAssistItem:(QMAssistItem *)item {
    if (!QM_IS_STR_NIL(item.helpTitle)) {
        assistNameLabel.text = item.helpTitle;
    }else {
        assistNameLabel.text = @"";
    }
    
    if (!QM_IS_STR_NIL(item.helpContent)) {
        assistContentLabel.text = item.helpContent;
    }else {
        assistContentLabel.text = @"";
    }
    
    CGSize size = [item.helpContent boundingRectWithSize:CGSizeMake(CGRectGetWidth(self.frame) - 2 * 10, 100000)
                                                   options:NSStringDrawingUsesLineFragmentOrigin
                                                attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:12], NSFontAttributeName, nil]
                                                   context:nil].size;
    CGRect frame = assistContentLabel.frame;
    frame.size.height = size.height;
    assistContentLabel.frame = frame;
}

@end
