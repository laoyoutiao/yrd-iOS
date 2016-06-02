//
//  QMSearchItem.m
//  MotherMoney


#import "QMSearchItem.h"

@implementation QMSearchItem

- (id)initWithTitle:(NSString *)title subTitle:(NSString *)subTitle {
    if (self = [super init]) {
        self.itemTitle = title;
        self.itemSubTitle = subTitle;
    }
    
    return self;
}

@end
