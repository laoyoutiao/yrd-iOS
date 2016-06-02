//
//  QMBuyProductBottomView.m
//  MotherMoney
//

//

#import "QMBuyProductBottomView.h"

@implementation QMBuyProductBottomView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(8 + 15, 4, 150, 13)];
        self.infoLabel.font = [UIFont systemFontOfSize:11];
        self.infoLabel.textColor = QM_COMMON_SUB_TITLE_COLOR;
        self.money = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.frame)-8-15-200, 4, 200, 13)];
        self.money.font = [UIFont systemFontOfSize:11];
        self.money.textAlignment = NSTextAlignmentRight;
        self.money.textColor = QM_COMMON_SUB_TITLE_COLOR;
        [self addSubview:self.money];
        [self addSubview:self.infoLabel];
        
        self.actionBtn = [QMControlFactory commonButtonWithSize:CGSizeMake(CGRectGetWidth(frame) - 2 * (15 + 8), 40.0f) title:QMLocalizedString(@"qm_next_action_btn_title", @"下一步") target:nil selector:nil];
        self.actionBtn.frame = CGRectMake(8 + 15, CGRectGetMaxY(self.infoLabel.frame) + 10, CGRectGetWidth(frame) - 2 * (15 + 8), 40.0f);
        [self addSubview:self.actionBtn];
    }

    return self;
}

@end
