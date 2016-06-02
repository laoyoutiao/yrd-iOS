//
//  QMBuyedProductResolveModel.m
//  MotherMoney
//

#import "QMBuyedProductResolveModel.h"

@implementation QMBuyedProductResolveModel

- (id)initWithDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        // 1
        NSString *bankCardNumer = [NSString stringWithFormat:@"%@", [dict objectForKey:@"bankCardNumer"]];
        if ([CMMUtility isStringOk:bankCardNumer]) {
            self.bankCardNumer = bankCardNumer;
        }
        
        // 2
        NSString *bankIco = [NSString stringWithFormat:@"%@", [dict objectForKey:@"bankIco"]];
        if ([CMMUtility isStringOk:bankIco]) {
            self.bankIco = bankIco;
        }
        
        // 3
        NSString *buyTime = [NSString stringWithFormat:@"%@", [dict objectForKey:@"buyTime"]];
        if ([CMMUtility isStringOk:buyTime]) {
            self.buyTime = buyTime;
        }
        
        // 4
        NSString *status = [NSString stringWithFormat:@"%@", [dict objectForKey:@"status"]];
        if ([CMMUtility isStringOk:status]) {
            self.status = status;
        }
        
        // 5
        NSString *statusValue = [NSString stringWithFormat:@"%@", [dict objectForKey:@"statusValue"]];
        if ([CMMUtility isStringOk:statusValue]) {
            self.statusValue = statusValue;
        }
        
        // 6
        NSString *todayTotalEarnings = [NSString stringWithFormat:@"%@", [dict objectForKey:@"todayTotalEarnings"]];
        if ([CMMUtility isStringOk:todayTotalEarnings]) {
            self.todayTotalEarnings = todayTotalEarnings;
        }
        
        // 7
        NSString *totalBuyAmount = [NSString stringWithFormat:@"%@", [dict objectForKey:@"totalBuyAmount"]];
        if ([CMMUtility isStringOk:totalBuyAmount]) {
            CGFloat buyAmount = [totalBuyAmount floatValue];
            self.totalBuyAmount = [NSString stringWithFormat:@"%.2f", buyAmount];
        }
        
        // 8
        NSString *totalEarnings = [NSString stringWithFormat:@"%@", [dict objectForKey:@"totalEarnings"]];
        if ([CMMUtility isStringOk:totalEarnings]) {
            CGFloat earnings = [totalEarnings floatValue];
            self.totalEarnings = [NSString stringWithFormat:@"%.2f", earnings];
        }
        
        
        
        //  9
        NSString *productId = [NSString stringWithFormat:@"%@", [dict objectForKey:@"productId"]];
        if ([CMMUtility isStringOk:productId]) {
            self.productId = productId;
        }
        
        // 10
        NSString *productName = [NSString stringWithFormat:@"%@", [dict objectForKey:@"productName"]];
        if ([CMMUtility isStringOk:productName]) {
            self.productName = productName;
        }
        
        // 11
        NSString *resolveModelId = [NSString stringWithFormat:@"%@", [dict objectForKey:@"id"]];
        if ([CMMUtility isStringOk:resolveModelId]) {
            self.resolveModelId = resolveModelId;
        }
        
        // 12
        NSString *errorMsg = [NSString stringWithFormat:@"%@", [dict objectForKey:@"errorMsg"]];
        if ([CMMUtility isStringOk:errorMsg]) {
            self.errorMsg = errorMsg;
        }
        
        // 是否购买成功
        NSString *isSuccess = [NSString stringWithFormat:@"%@", [dict objectForKey:@"success"]];
        if ([CMMUtility isStringOk:isSuccess]) {
            self.isSuccess = [isSuccess boolValue];
        }
    }
    
    return self;
}

@end
