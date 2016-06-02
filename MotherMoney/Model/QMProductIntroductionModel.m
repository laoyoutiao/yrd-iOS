//
//  QMProductIntroductionModel.m
//  MotherMoney
//

#import "QMProductIntroductionModel.h"
#import "QMProductImageItemModel.h"

@implementation QMProductIntroductionModel

- (id)initWithDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        NSDictionary *productInfo = [dict objectForKey:@"productInfo"];
        self.introlTitle = @"项目介绍";
        
        if ([productInfo isKindOfClass:[NSDictionary class]]) {
            NSString *accountId = [NSString stringWithFormat:@"%@", [productInfo objectForKey:@"id"]];
            if ([CMMUtility isStringOk:accountId]) {
                self.accountId = accountId;
            }
            
            NSString *mortgageDesc = [NSString stringWithFormat:@"%@", [productInfo objectForKey:@"mortgageDesc"]];
            if ([CMMUtility isStringOk:mortgageDesc]) {
                self.mortgageDesc = mortgageDesc;
            }
            
            NSString *productId = [NSString stringWithFormat:@"%@", [productInfo objectForKey:@"productId"]];
            if ([CMMUtility isStringOk:productId]) {
                self.productId = productId;
            }
            
            NSString *productDescription = [NSString stringWithFormat:@"%@", [productInfo objectForKey:@"desciption"]];
            if ([CMMUtility isStringOk:productDescription]) {
                self.productDescription = productDescription;
            }
            
            NSString *productDesciptionTitle = [NSString stringWithFormat:@"%@", [productInfo objectForKey:@"desciptionTitle"]];
            if ([CMMUtility isStringOk:productDesciptionTitle]) {
                self.productDesciptionTitle = productDesciptionTitle;
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
    }
    
    return self;
}

@end
