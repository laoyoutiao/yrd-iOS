//
//  QMIntegralListHeaderView.m
//  MotherMoney
//

#import "QMIntegralListHeaderView.h"

@implementation QMIntegralListHeaderView {
    UILabel *nameTitleLabel;
    UILabel *timeTitleLabel;
    UILabel *stateTitleLabel;
    UIImageView *horizontalLine;
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        UIImageView *bgView = [[UIImageView alloc] initWithImage:[QMImageFactory commonBackgroundImageTopPart]];
        bgView.frame = CGRectMake(10, 10, CGRectGetWidth(self.frame) - 2 * 10, CGRectGetHeight(self.frame) - 10);
        [self addSubview:bgView];
        
        nameTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 10, 80, CGRectGetHeight(frame) - 10)];
        nameTitleLabel.font = [UIFont systemFontOfSize:12];
        nameTitleLabel.textColor = QM_COMMON_SUB_TITLE_COLOR;
        nameTitleLabel.textAlignment = NSTextAlignmentCenter;
        nameTitleLabel.text = QMLocalizedString(@"qm_name_title", @"名称");
        [self addSubview:nameTitleLabel];
        
        timeTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake((CGRectGetWidth(self.frame) - 100) / 2 + 5, 10, 100, CGRectGetHeight(self.frame) - 10)];
        timeTitleLabel.font = [UIFont systemFontOfSize:12];
        timeTitleLabel.textColor = QM_COMMON_SUB_TITLE_COLOR;
        timeTitleLabel.textAlignment = NSTextAlignmentCenter;
        timeTitleLabel.text = QMLocalizedString(@"qm_time_title", @"操作时间");
        [self addSubview:timeTitleLabel];
        
        stateTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(timeTitleLabel.frame) + 20, 10, 80, CGRectGetHeight(self.frame) - 10)];
        stateTitleLabel.font = [UIFont systemFontOfSize:12];
        stateTitleLabel.textColor = QM_COMMON_SUB_TITLE_COLOR;
        stateTitleLabel.textAlignment = NSTextAlignmentCenter;
        stateTitleLabel.text = QMLocalizedString(@"qm_state_title", @"状态");
        [self addSubview:stateTitleLabel];
        
        horizontalLine = [[UIImageView alloc] initWithImage:[QMImageFactory commonHorizontalLineImage]];
        horizontalLine.frame = CGRectMake(CGRectGetMinX(nameTitleLabel.frame), CGRectGetMaxY(self.frame) - 1, CGRectGetWidth(self.frame) - 2 * 25, 1);
        horizontalLine.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self addSubview:horizontalLine];
    }
    
    return self;
}

@end
