//
//  QMTwoLineCollectionCell.m
//  MotherMoney
//
//

#import "QMTwoLineCollectionCell.h"

@implementation QMTwoLineCollectionCell

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundView = [[UIImageView alloc] initWithFrame:self.bounds];
        self.selectedBackgroundView = [[UIImageView alloc] initWithFrame:self.bounds];
        
        self.textLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 200, 16)];
        self.textLabel.font = [UIFont boldSystemFontOfSize:14];
        self.textLabel.textColor = [UIColor blackColor];
        [self.contentView addSubview:self.textLabel];
        
        self.detailTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.textLabel.frame), CGRectGetMaxY(self.textLabel.frame), CGRectGetWidth(self.textLabel.frame), 16)];
        self.detailTextLabel.font = [UIFont systemFontOfSize:15];
        self.detailTextLabel.textColor = QM_COMMON_TEXT_COLOR;
        [self.contentView addSubview:self.detailTextLabel];
        
        self.horizontalLine = [[UIImageView alloc] initWithImage:[QMImageFactory commonHorizontalLineImage]];
        self.horizontalLine.frame = CGRectMake(CGRectGetMinX(self.textLabel.frame), CGRectGetHeight(frame) - 1, CGRectGetWidth(frame) - 2 * 15, 1);
        [self.contentView addSubview:self.horizontalLine];
    }
    
    return self;
}

@end
