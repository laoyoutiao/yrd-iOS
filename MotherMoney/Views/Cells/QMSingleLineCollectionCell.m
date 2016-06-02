//
//  QMSingleLineCollectionCell.m
//  MotherMoney
//

#import "QMSingleLineCollectionCell.h"

@implementation QMSingleLineCollectionCell

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundView = [[UIImageView alloc] initWithFrame:self.bounds];
        self.selectedBackgroundView = [[UIImageView alloc] initWithFrame:self.bounds];
        
        // text
        self.textLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, CGRectGetWidth(frame)-100, CGRectGetHeight(frame))];
        self.textLabel.font = [UIFont systemFontOfSize:13];
        self.textLabel.textColor = QM_COMMON_TEXT_COLOR;
        self.textLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        [self.contentView addSubview:self.textLabel];
        
        // detail
        self.detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(frame) - 150, CGRectGetMinY(self.textLabel.frame), 150, CGRectGetHeight(frame))];
        self.detailLabel.font = [UIFont systemFontOfSize:13];
        self.detailLabel.textColor = QM_COMMON_TEXT_COLOR;
        self.detailLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        self.detailLabel.hidden = YES;
        self.detailLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:self.detailLabel];
        
        // horizontal line
        self.horizontalLine = [[UIImageView alloc] initWithImage:[QMImageFactory commonHorizontalLineImage]];
        self.horizontalLine.frame = CGRectMake(CGRectGetMinX(self.textLabel.frame), CGRectGetHeight(frame) - 1, CGRectGetWidth(frame) - 2 * 15, 1);
        self.horizontalLine.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
        [self.contentView addSubview:self.horizontalLine];
        
        // indicator
        self.indicatorView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"shearhead_2.png"]];
        self.indicatorView.frame = CGRectMake(CGRectGetWidth(frame) - 15 - 15, (CGRectGetHeight(frame) - 15.0f) / 2.0f, 15, 15);
        self.indicatorView.hidden = YES;
        [self.contentView addSubview:self.indicatorView];
        [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.indicatorView.mas_left).offset(-5.0f);
            make.top.equalTo(self.textLabel.mas_top);
            make.bottom.equalTo(self.textLabel.mas_bottom);
            make.width.equalTo(200.0f);
        }];
    }
    
    return self;
}


@end
