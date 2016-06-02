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
