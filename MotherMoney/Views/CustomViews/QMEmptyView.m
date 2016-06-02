//
//  QMEmptyView.m
//  MotherMoney
//

#import "QMEmptyView.h"

@implementation QMEmptyView {
    UIImageView *mFlagImageView;
    UILabel *mTextLabel;
}
@synthesize flagImageView = mFlagImageView;
@synthesize textLabel = mTextLabel;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        mFlagImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"no_news.png"]];
        mFlagImageView.frame = CGRectMake((CGRectGetWidth(self.frame) - 95) / 2.0f, CGRectGetHeight(self.frame) / 3.0f, 95, 95);
        mFlagImageView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        [self addSubview:mFlagImageView];
        
        // 文案
        mTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(mFlagImageView.frame) + 15, CGRectGetWidth(self.frame), 17.0f)];
        mTextLabel.font = [UIFont systemFontOfSize:15];
        mTextLabel.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3f];
        mTextLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:mTextLabel];
    }
    
    return self;
}

@end
