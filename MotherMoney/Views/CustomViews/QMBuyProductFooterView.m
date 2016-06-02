//
//  QMBuyProductFooterView.m
//  MotherMoney

#import "QMBuyProductFooterView.h"

@implementation QMBuyProductFooterView {
    UILabel *principleLable;
    UIButton *viewPrincipleBtn;
    UIButton *confirmBtn;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        // 复选框
        self.checkBox = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.checkBox addTarget:self action:@selector(checkBoxBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        self.checkBox.selected = YES;
        self.checkBox.frame = CGRectMake(23, 15, 90, 40);
        self.checkBox.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        self.checkBox.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
        [self.checkBox setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.checkBox.titleLabel.font = [UIFont systemFontOfSize:11];
        self.checkBox.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
        [self.checkBox setTitle:QMLocalizedString(@"qm_product_buy_principle_ok", @"已阅读并同意") forState:UIControlStateNormal];
        [self.checkBox setImage:[UIImage imageNamed:@"check_box.png"] forState:UIControlStateNormal];
        [self.checkBox setImage:[UIImage imageNamed:@"check_box_2.png"] forState:UIControlStateSelected];
        [self addSubview:self.checkBox];
        
        // button
        viewPrincipleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        viewPrincipleBtn.frame = CGRectMake(CGRectGetMaxX(self.checkBox.frame), CGRectGetMinY(self.checkBox.frame) - 15, 150, 43);
        [viewPrincipleBtn addTarget:self action:@selector(viewPrincipleBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:viewPrincipleBtn];
        
        // label
        principleLable = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.checkBox.frame), CGRectGetMinY(self.checkBox.frame), 150, 13)];
        principleLable.font = [UIFont systemFontOfSize:11];
        principleLable.textColor = [UIColor colorWithRed:221.0f / 255.0f green:46.0f / 255.0f blue:28.0f / 255.0f alpha:1.0f];
        principleLable.text = QMLocalizedString(@"qm_register_phone_number_user_principle", @"<<粤融贷用户使用协议>>");
        
        [self addSubview:principleLable];

        confirmBtn = [QMControlFactory commonButtonWithSize:CGSizeMake(CGRectGetWidth(frame) - 2 * 23, 40) title:QMLocalizedString(@"qm_confirm_buy_btn_title", @"确认购买") target:self selector:@selector(nextStepBtnClicked:)];
        CGRect frame = confirmBtn.frame;
        frame.origin = CGPointMake(23, CGRectGetMaxY(self.checkBox.frame));
        confirmBtn.frame = frame;
        [self addSubview:confirmBtn];
    }

    return self;
}

- (void)viewPrincipleBtnClicked:(UIButton *)btn {
    if (QM_IS_DELEGATE_RSP_SEL(self.delegate, didSelectPrincipleBtn:)) {
        [self.delegate didSelectPrincipleBtn:btn];
    }
}

- (void)checkBoxBtnClicked:(UIButton *)btn {
    if (btn.selected) {
        btn.selected = NO;
    }else {
        btn.selected = YES;
    }
}

- (void)setProductName:(NSString *)name {
    if (QM_IS_STR_NIL(name)) {
        return;
    }
    
    principleLable.text = [NSString stringWithFormat:QMLocalizedString(@"qm_product_buy_principle_rule", @"<<联动优势扣款协议>>"), name];
}

- (void)nextStepBtnClicked:(UIButton *)btn {
    
    if (!self.checkBox.selected) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                            message:QMLocalizedString(@"am_principle_not_checked_alert_message", @"在进行下一步操作之前，请先同意相关协议")
                                                           delegate:self
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:QMLocalizedString(@"qm_alertview_ok_title", @"确定"), nil];
        [alertView show];
        return;
    }
    
    if (QM_IS_DELEGATE_RSP_SEL(self.delegate, didSelectConfirmBtn:)) {
        [self.delegate didSelectConfirmBtn:btn];
    }
}


@end
