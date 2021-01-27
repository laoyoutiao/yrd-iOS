//
//  QMTextFieldCollectionCell.m
//  MotherMoney
//

#import "QMTextFieldCollectionCell.h"

@implementation QMTextFieldCollectionCell

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundView = [[UIImageView alloc] initWithFrame:self.bounds];
        self.selectedBackgroundView = [[UIImageView alloc] initWithFrame:self.bounds];
        
        self.textField = [[UITextField alloc] initWithFrame:CGRectMake(15, 0, CGRectGetWidth(frame) - 2 * 15, CGRectGetHeight(frame))];

        [self.contentView addSubview:self.textField];
    }
    return self;
}


@end

@implementation QMTSelectBankCollectionCell

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundView = [[UIImageView alloc] initWithFrame:self.bounds];
        self.selectedBackgroundView = [[UIImageView alloc] initWithFrame:self.bounds];
        
        self.selectBankBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.selectBankBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame))];
        [self.selectBankBtn setBackgroundImage:[QMImageFactory commonTextFieldImage] forState:UIControlStateNormal];
        [self.selectBankBtn setBackgroundImage:[QMImageFactory commonTextFieldImage] forState:UIControlStateHighlighted];
        [self.selectBankBtn setImage:[UIImage imageNamed:@"shearhead.png"] forState:UIControlStateNormal];
        self.selectBankBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [self.selectBankBtn setTitleColor:QM_COMMON_TEXT_COLOR forState:UIControlStateNormal];
        
//        self.selectBankBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        self.selectBankBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        self.selectBankBtn.imageEdgeInsets = UIEdgeInsetsMake(0, CGRectGetWidth(self.selectBankBtn.frame) - 30, 0, 0);
        [self.contentView addSubview:self.selectBankBtn];

    }
    return self;
}


@end
