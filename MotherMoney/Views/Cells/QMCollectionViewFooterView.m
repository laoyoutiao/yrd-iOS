//
//  QMCollectionViewFooterView.m
//  MotherMoney

#import "QMCollectionViewFooterView.h"

@implementation QMCollectionViewFooterView {
    QMPageFooterView *footerView;
}
@synthesize pageFooterView = footerView;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        footerView = [[QMPageFooterView alloc] initWithFrame:self.bounds];
        [self addSubview:footerView];
        self.pageFooterView = footerView;
    }
    return self;
}

@end
