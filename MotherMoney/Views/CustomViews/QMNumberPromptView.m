//
//  QMNumberPromptView.m
//  MotherMoney
//
//  Created by 赵国辉 on 15/3/1.
//  Copyright (c) 2015年 赵国辉. All rights reserved.
//

#import "QMNumberPromptView.h"
//电话号码提示框
@implementation QMNumberPromptView {
    UIImageView *backgroundImageView;
    UILabel *textLabel;
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        backgroundImageView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"common_input_number.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:23]];
    
        textLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        textLabel.textAlignment = NSTextAlignmentCenter;
        textLabel.font = [UIFont systemFontOfSize:18];
        textLabel.textColor = [UIColor colorWithRed:96.0f / 255.0f green:60.0f / 255.0f blue:25.0f / 255.0f alpha:1.0f];
        
        [self addSubview:backgroundImageView];
        [self addSubview:textLabel];
        [backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(UIEdgeInsetsZero);
        }];
        [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(UIEdgeInsetsZero);
        }];
    }
    
    return self;
}

- (NSString *)text {
    return textLabel.text;
}

- (void)setText:(NSString *)text {
    textLabel.text = text;
}

@end
