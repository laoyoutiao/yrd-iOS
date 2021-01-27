//
//  QMMoreInfoTableFooterView.m
//  MotherMoney
//
//  Created by    on 14-8-10.
//  Copyright (c) 2014年   . All rights reserved.
//

#import "QMMoreInfoTableFooterView.h"

#define ACTION_BUTTON_TOP_PADDING 50
#define ACTION_BUTTON_BOTTOM_PADDING 10
#define ACTION_BUTTON_HORIZON_PADDING 10

@implementation QMMoreInfoTableFooterView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.actionBtn = [QMControlFactory commonButtonWithSize:CGSizeMake(CGRectGetWidth(frame) - 2 * ACTION_BUTTON_HORIZON_PADDING, 40.0f) title:QMLocalizedString(@"qm_more_quit_btn_title", @"退出登录") target:self selector:nil];
        self.actionBtn.frame = CGRectMake(ACTION_BUTTON_HORIZON_PADDING, ACTION_BUTTON_TOP_PADDING, CGRectGetWidth(frame) - 2 * ACTION_BUTTON_HORIZON_PADDING, 40);

        [self addSubview:self.actionBtn];
        [self.actionBtn setTitle:QMLocalizedString(@"qm_more_quit_btn_title", @"退出登录") forState:UIControlStateNormal];
        
        _versionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, CGRectGetWidth(frame) - 2 * ACTION_BUTTON_HORIZON_PADDING, 15)];
        NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        _versionLabel.text = [NSString stringWithFormat:@"当前版本 V%@", version];
        _versionLabel.font = [UIFont systemFontOfSize:15];
        _versionLabel.textColor = [UIColor grayColor];
        _versionLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:_versionLabel];
    }
    
    return self;
}

@end
