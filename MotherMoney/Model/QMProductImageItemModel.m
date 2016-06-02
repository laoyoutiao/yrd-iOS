//
//  QMProductImageItemModel.m
//  MotherMoney
//

#import "QMProductImageItemModel.h"

@implementation QMProductImageItemModel

- (id)initWithDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        self.imagePath = [NSString stringWithFormat:@"%@", dict];
    }
    
    return self;
}

@end
