//
//  QMFundEmptyCell.m
//  MotherMoney


#import "QMFundEmptyCell.h"

@implementation QMFundEmptyCell {
    UIButton *earningBtn;
    UIImageView *icon2;
    
    UIButton *mEarningMoneyBtn;
}
@synthesize earningMoneyBtn = mEarningMoneyBtn;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundView = [[UIImageView alloc] initWithImage:[QMImageFactory commonBackgroundImageCenterPart]];
        
        earningBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        earningBtn.frame = CGRectMake(0, 30, CGRectGetWidth(frame), 28);
        earningBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [earningBtn setTitleColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.6] forState:UIControlStateNormal];
        [earningBtn setTitle:QMLocalizedString(@"qm_earning_money_start", @"财富积累从这开始") forState:UIControlStateNormal];
        [earningBtn setImage:[UIImage imageNamed:@"coin_icon.png"] forState:UIControlStateDisabled];
        earningBtn.enabled = NO;
        earningBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 5);
        earningBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 5, 0, -5);
        [self.contentView addSubview:earningBtn];
        
        icon2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"coin_jiantou_icon.png"]];
        icon2.frame = CGRectMake((CGRectGetWidth(frame) - 18) / 2, CGRectGetMaxY(earningBtn.frame) + 10, 18, 12);
        [self.contentView addSubview:icon2];
        
        mEarningMoneyBtn = [QMControlFactory commonButtonWithSize:CGSizeMake(CGRectGetWidth(frame) - 2 * 15, 44) title:QMLocalizedString(@"qm_start_earning_money", @"开始赚钱") target:self selector:nil];
        CGRect rect = mEarningMoneyBtn.frame;
        rect.origin = CGPointMake(15, CGRectGetMaxY(icon2.frame) + 25);
        mEarningMoneyBtn.frame = rect;
        [self.contentView addSubview:mEarningMoneyBtn];
        
        UIImageView *line = [[UIImageView alloc] initWithImage:[QMImageFactory commonHorizontalLineImage]];
        [self.contentView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left);
            make.right.equalTo(self.contentView.mas_right);
            make.height.equalTo(1.0f);
            make.bottom.equalTo(self.contentView.mas_bottom);
        }];
    }
    
    return self;
}

+ (CGFloat)getCellHeight {
    return 40 + 20 + 15 + 12 + 25 + 44 + 15;
}

@end
