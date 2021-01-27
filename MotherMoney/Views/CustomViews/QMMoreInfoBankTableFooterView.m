//
//  QMMoreInfoTableFooterView.m
//  MotherMoney
//
//  Created by    on 14-8-10.
//  Copyright (c) 2014年   . All rights reserved.
//

#import "QMMoreInfoBankTableFooterView.h"

#define ACTION_BUTTON_TOP_PADDING 50
#define ACTION_BUTTON_BOTTOM_PADDING 10
#define ACTION_BUTTON_HORIZON_PADDING 10

@implementation QMMoreInfoBankTableFooterView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.actionBtn = [QMControlFactory commonButtonWithSize:CGSizeMake(CGRectGetWidth(frame) - 2 * ACTION_BUTTON_HORIZON_PADDING, 40.0f) title:QMLocalizedString(@"qm_more_quit_btn_title", @"退出登录") target:self selector:nil];
        self.actionBtn.frame = CGRectMake(ACTION_BUTTON_HORIZON_PADDING, ACTION_BUTTON_TOP_PADDING, CGRectGetWidth(frame) - 2 * ACTION_BUTTON_HORIZON_PADDING, 40);

        [self addSubview:self.actionBtn];
        [self.actionBtn setTitle:QMLocalizedString(@"qm_more_quit_btn_title", @"退出登录") forState:UIControlStateNormal];
    }
    
    return self;
}

@end
