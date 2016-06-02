//
//  QMBuyedProductInfo.m
//  MotherMoney
//

#import "QMBuyedProductInfo.h"

@implementation QMBuyedProductInfo

- (id)initWithDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        // 1
        NSString *buyedId = [NSString stringWithFormat:@"%@", [dict objectForKey:@"id"]];
        if ([CMMUtility isStringOk:buyedId]) {
            self.buyedId = buyedId;
        }
        
        // 2
        NSString *productId = [NSString stringWithFormat:@"%@", [dict objectForKey:@"productId"]];
        if ([CMMUtility isStringOk:productId]) {
            self.productId = productId;
        }
        
        // 3
        NSString *productName = [NSString stringWithFormat:@"%@", [dict objectForKey:@"productName"]];
        if ([CMMUtility isStringOk:productName]) {
            self.productName = productName;
        }
        
        // 4
        NSString *todayTotalEarnings = [NSString stringWithFormat:@"%@", [dict objectForKey:@"todayTotalEarnings"]];
        if ([CMMUtility isStringOk:todayTotalEarnings]) {
            self.todayTotalEarnings = todayTotalEarnings;
        }
        
        // 5
        NSString *totalBuyAmount = [NSString stringWithFormat:@"%@", [dict objectForKey:@"totalBuyAmount"]];
        if ([CMMUtility isStringOk:totalBuyAmount]) {
            CGFloat buyAmount = [totalBuyAmount floatValue];
            self.totalBuyAmount = [NSString stringWithFormat:@"%.2f", buyAmount];
        }
        
        // 6
        NSString *totalEarnings = [NSString stringWithFormat:@"%@", [dict objectForKey:@"totalEarnings"]];
        if ([CMMUtility isStringOk:totalEarnings]) {
            CGFloat earnings = [totalEarnings floatValue];
            self.totalEarnings = [NSString stringWithFormat:@"%.2f", earnings];
        }
        
        NSString *bankPicPath = [NSString stringWithFormat:@"%@", [dict objectForKey:@"bankPicPath"]];
        if (![CMMUtility isStringOk:bankPicPath]) {
            bankPicPath = @"";
        }
    }
    
    return self;
}

@end
