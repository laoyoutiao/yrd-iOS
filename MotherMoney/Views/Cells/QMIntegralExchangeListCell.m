//
//  QMIntegralExchangeListCell.m
//  MotherMoney

#import "QMIntegralExchangeListCell.h"
#define kWidthScreen [[UIScreen mainScreen] bounds].size.width
@implementation QMIntegralExchangeListCell {
    UILabel *nameLabel;
    UILabel *timeLabel;
    UILabel *stateLabel;
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundView = [[UIImageView alloc] initWithFrame:frame];
        
        // name
        nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 70, CGRectGetHeight(self.frame))];
        nameLabel.font = [UIFont systemFontOfSize:13];
        nameLabel.numberOfLines = 2;
        nameLabel.textColor = [UIColor blackColor];
        [self.contentView addSubview:nameLabel];
        
//        timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(nameLabel.frame) + 15, 0, 100, CGRectGetHeight(nameLabel.frame))];
        timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(kWidthScreen/2-50, 0, 100, CGRectGetHeight(nameLabel.frame))];
        
        timeLabel.font = [UIFont systemFontOfSize:13];
        timeLabel.numberOfLines = 2;
        timeLabel.textAlignment = NSTextAlignmentCenter;
        timeLabel.textColor = QM_COMMON_SUB_TITLE_COLOR;
        [self.contentView addSubview:timeLabel];
        
//        stateLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(timeLabel.frame) + 15, 0, 60, CGRectGetHeight(nameLabel.frame))];
        stateLabel = [[UILabel alloc] initWithFrame:CGRectMake(kWidthScreen-25-60, 0, 60, CGRectGetHeight(nameLabel.frame))];
        stateLabel.font = [UIFont systemFontOfSize:13];
        stateLabel.numberOfLines = 2;
        stateLabel.textAlignment = NSTextAlignmentCenter;
        stateLabel.textColor = [UIColor blackColor];
        [self.contentView addSubview:stateLabel];
        
//        self.horizontalLine = [[UIImageView alloc] initWithImage:[QMImageFactory commonHorizontalLineImage]];
//        self.horizontalLine.frame = CGRectMake(CGRectGetMinX(nameLabel.frame), CGRectGetHeight(self.frame) - 1, CGRectGetWidth(self.frame) - 2 * 15, 1);
        [self.contentView addSubview:self.horizontalLine];
    }
    
    return self;
}

+ (CGFloat)getCellHeightWithItem:(QMIntegralExchangeListItem *)item {
    return 50.0f;
}

- (void)prepareForReuse {
    nameLabel.text = @"";
    timeLabel.text = @"";
    stateLabel.text = @"";
}

- (void)configureCellWithItem:(QMIntegralExchangeListItem *)item {
    if (!QM_IS_STR_NIL(item.prizeName)) {
        nameLabel.text = item.prizeName;

    }

    if (!QM_IS_STR_NIL(item.prizeTime)) {
        NSString *time = [item.prizeTime stringByReplacingOccurrencesOfString:@" " withString:@"\n"];
        timeLabel.text = time;
    }

    if (!QM_IS_STR_NIL(item.status)) {
        stateLabel.text = item.status;
    }
    
//    if (!QM_IS_STR_NIL(item.state)) {
//        if ([item.state isEqualToString:@"0"]) {
//            stateLabel.text = QMLocalizedString(@"qm_goods_trade_unchecked", @"处理中");
//            stateLabel.textColor = QM_THEME_COLOR;
//        }else if ([item.state isEqualToString:@"1"]) {
//            stateLabel.text = QMLocalizedString(@"qm_goods_trade_checked", @"已处理");
//            stateLabel.textColor = [UIColor blackColor];
//        }
//    }
}

@end
