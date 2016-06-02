//
//  QMSingleLineTextCell.m
//  MotherMoney
//
//  Created by 赵国辉 on 15/5/19.
//  Copyright (c) 2015年 赵国辉. All rights reserved.
//

#import "QMSingleLineTextCell.h"

@implementation QMSingleLineTextCell

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundView = [[UIImageView alloc] initWithFrame:self.bounds];
        self.selectedBackgroundView = [[UIImageView alloc] initWithFrame:self.bounds];
        
        // text
        self.textLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, CGRectGetWidth(frame), CGRectGetHeight(frame))];
        self.textLabel.font = [UIFont systemFontOfSize:13];
        self.textLabel.textColor = QM_COMMON_TEXT_COLOR;
        self.textLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        [self.contentView addSubview:self.textLabel];
        
        // detail
        self.detailField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetWidth(frame) - 175, CGRectGetMinY(self.textLabel.frame), 170, CGRectGetHeight(frame))];
        self.detailField.font = [UIFont systemFontOfSize:13];
        self.detailField.textColor = QM_COMMON_TEXT_COLOR;
        self.detailField.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        self.detailField.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:self.detailField];
    }
    
    return self;
}

@end

