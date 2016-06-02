//
//  QMIntegralExchangeListItem.m
//  MotherMoney

#import "QMIntegralExchangeListItem.h"

@implementation QMIntegralExchangeListItem

- (id)initWithDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        NSString *prizeUniqueId = [NSString stringWithFormat:@"%@", [dict objectForKey:@"id"]];
        if ([CMMUtility isStringOk:prizeUniqueId]) {
            self.prizeUniqueId = prizeUniqueId;
        }
        
        NSString *customerId = [NSString stringWithFormat:@"%@", [dict objectForKey:@"customerId"]];
        if ([CMMUtility isStringOk:customerId]) {
            self.customerId = customerId;
        }
        
        NSString *acitivityId = [NSString stringWithFormat:@"%@", [dict objectForKey:@"acitivityId"]];
        if ([CMMUtility isStringOk:acitivityId]) {
            self.acitivityId = acitivityId;
        }
        
        NSString *prizeId = [NSString stringWithFormat:@"%@", [dict objectForKey:@"prizeId"]];
        if ([CMMUtility isStringOk:prizeId]) {
            self.prizeId = prizeId;
        }
        
        NSString *prizeName = [NSString stringWithFormat:@"%@", [dict objectForKey:@"prizeName"]];
        if ([CMMUtility isStringOk:prizeName]) {
            self.prizeName = prizeName;
        }
        
        NSString *prizeTime = [NSString stringWithFormat:@"%@", [dict objectForKey:@"prizeTime"]];
        if ([CMMUtility isStringOk:prizeTime]) {
            self.prizeTime = prizeTime;
        }
        
        NSString *status = [NSString stringWithFormat:@"%@", [dict objectForKey:@"status"]];
        if ([CMMUtility isStringOk:status]) {
            self.status = status;
        }
        
        NSString *updateTime = [NSString stringWithFormat:@"%@", [dict objectForKey:@"updateTime"]];
        if ([CMMUtility isStringOk:updateTime]) {
            self.updateTime = updateTime;
        }
        
        NSString *score = [NSString stringWithFormat:@"%@", [dict objectForKey:@"score"]];
        if ([CMMUtility isStringOk:score]) {
            self.score = score;
        }
    }
    
    return self;
}

@end

