//
//  QMProductWindControlModel.m
//  MotherMoney
//

#import "QMProductWindControlModel.h"
#import "QMProductImageItemModel.h"

@implementation QMProductWindControlModel

- (id)initWithDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        NSDictionary *productRiskControl = [dict objectForKey:@"productRiskControl"];
        
        if ([productRiskControl isKindOfClass:[NSDictionary class]]) {
            NSString *productId = [NSString stringWithFormat:@"%@", [productRiskControl objectForKey:@"productId"]];
            if ([CMMUtility isStringOk:productId]) {
                self.productId = productId;
            }
            
            NSString *windControlIntroduction = [NSString stringWithFormat:@"%@", [productRiskControl objectForKey:@"riskControlDescription"]];
            if ([CMMUtility isStringOk:windControlIntroduction]) {
                self.windControlIntroduction = windControlIntroduction;
            }
        }
        
        NSArray *array = [dict objectForKey:@"picUrls"];
        NSMutableArray *mutableArray = [NSMutableArray arrayWithCapacity:0];
        
        if (!QM_IS_ARRAY_NIL(array)) {
            for (NSDictionary *dict in array) {
                QMProductImageItemModel *obj = [[QMProductImageItemModel alloc] initWithDictionary:dict];
                [mutableArray addObject:obj];
            }
            
            self.imageList = [NSArray arrayWithArray:mutableArray];
        }
        
        self.productTitle = @"风控措施";
    }
    
    return self;
}

@end


