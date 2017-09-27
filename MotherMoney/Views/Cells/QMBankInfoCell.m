//
//  QMBankInfoCell.m
//  MotherMoney
//
//  Created by 赵国辉 on 15/5/21.
//  Copyright (c) 2015年 赵国辉. All rights reserved.
//

#import "QMBankInfoCell.h"
#import "UIImageView+AFNetworking.h"

@implementation QMBankInfoCell {
    UIImageView *bankIconImageView;
    UILabel *bankNameLable;
    UILabel *bankCardLabel;
    UILabel *promptLabel;
    UIImageView *checkImgView;
    UIView *cardContainerView;
    CGRect cellFrame;
}
@synthesize mPromptLabel = promptLabel;
@synthesize bankNameLable = bankNameLable;
@synthesize bankCardLabel = bankCardLabel;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        cellFrame = frame;
        self.actionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.actionBtn.titleLabel.font = [UIFont systemFontOfSize:16.0f];
        [self.actionBtn setTitle:@"点击添加银行卡" forState:UIControlStateNormal];
        [self.actionBtn setTitleColor:QM_COMMON_TEXT_COLOR forState:UIControlStateNormal];
        self.actionBtn.hidden = YES;
        [self.actionBtn setBackgroundImage:[QMImageFactory commonBackgroundImage] forState:UIControlStateNormal];
        [self.actionBtn setBackgroundImage:[QMImageFactory commonBackgroundImage] forState:UIControlStateHighlighted];
        [self.contentView addSubview:self.actionBtn];
        [self.actionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(0.0f);
            make.right.equalTo(self.contentView.mas_right).offset(-0.0f);
            make.top.equalTo(self.contentView.mas_top).offset(0.0f);
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-0.0f);
        }];
        
        cardContainerView = [[UIView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:cardContainerView];
        [cardContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(UIEdgeInsetsZero);
        }];
        
        // 银行卡图标
        bankIconImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [cardContainerView addSubview:bankIconImageView];
        [bankIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(10.0f);
            make.top.equalTo(10.0f);
            make.size.equalTo(CGSizeMake(50, 50));
        }];
        
        // 银行卡名字
        bankNameLable = [[UILabel alloc] initWithFrame:CGRectZero];
        bankNameLable.font = [UIFont systemFontOfSize:14.0f];
        bankNameLable.textColor = QM_COMMON_SUB_TITLE_COLOR;
        [cardContainerView addSubview:bankNameLable];
        [bankNameLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(bankIconImageView.mas_right).offset(15.0f);
            make.top.equalTo(bankIconImageView.mas_top).offset(7.0f);
        }];
        
        // 银行卡尾号
        bankCardLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        bankCardLabel.font = [UIFont systemFontOfSize:14.0f];
        bankCardLabel.textColor = QM_COMMON_SUB_TITLE_COLOR;
        [cardContainerView addSubview:bankCardLabel];
        [bankCardLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(bankNameLable.mas_right).offset(10.0f);
            make.top.equalTo(bankNameLable.mas_top);
        }];
        
        // 提示信息
        promptLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        promptLabel.textColor = QM_COMMON_SUB_TITLE_COLOR;
        promptLabel.font = [UIFont systemFontOfSize:10.0f];
        [cardContainerView addSubview:promptLabel];
        [promptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(bankNameLable.mas_left);
            make.top.equalTo(bankNameLable.mas_bottom).offset(5.0f);
        }];
    }
    
    return self;
}

- (void)configureCellWithBankCardModel:(QMBankCardModel *)model {
    if (nil == model) {// 没有银行卡
        cardContainerView.hidden = YES;
        self.actionBtn.hidden = NO;
        
        return;
    }
    
    self.actionBtn.hidden = YES;
    cardContainerView.hidden = NO;
    if (!QM_IS_STR_NIL(model.bankPicPath)) {
        [bankIconImageView setImageWithURL:[NSURL URLWithString:model.bankPicPath] placeholderImage:nil];
    }
    
    bankNameLable.text = model.bankName;
    bankCardLabel.text = [NSString stringWithFormat:@"尾号%@", model.bankCardNumber];
    if (self.withDraw) { // 提现
        if (self.withDrawCard) {
            promptLabel.text = @"已绑定的提现银行卡";
        }else
        {
            promptLabel.text = @"点击绑定提现银行卡";
        }
    }else { // 充值
        if (self.withOnlyCard)
        {
            promptLabel.text = @"默认充值银行卡";
        }else
        {
            promptLabel.text = @"点击选择充值银行卡";
        }
    }
}

- (void)addCheckBox
{
    checkImgView = [[UIImageView alloc] initWithFrame:CGRectZero];
    checkImgView.frame = CGRectMake(cellFrame.size.width - 70, cellFrame.size.height / 2 - 15, 30, 30);
    checkImgView.layer.cornerRadius = 5;
    checkImgView.layer.borderWidth = 1;
    checkImgView.layer.borderColor = [UIColor grayColor].CGColor;
    [self addSubview:checkImgView];
}

+ (CGFloat)getCellHeightWithBankCardModel:(QMBankCardModel *)model {
    return 70.0f;
}

@end
