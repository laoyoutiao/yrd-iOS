//
//  QMGoodsListItem.m
//  MotherMoney
//

#import "QMGoodsListItem.h"

@implementation QMGoodsListItem

- (id)initWithDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        NSString *prizeId = [NSString stringWithFormat:@"%@", [dict objectForKey:@"id"]];
        if ([CMMUtility isStringOk:prizeId]) {
            self.prizeId = prizeId;
        }
        
        NSString *prizeName = [NSString stringWithFormat:@"%@", [dict objectForKey:@"prizeName"]];
        if ([CMMUtility isStringOk:prizeName]) {
            self.prizeName = prizeName;
        }
        
        NSString *prizeAmount = [NSString stringWithFormat:@"%@", [dict objectForKey:@"prizeAmount"]];
        if ([CMMUtility isStringOk:prizeAmount]) {
            self.prizeAmount = prizeAmount;
        }
        
        NSString *prizeDesc = [NSString stringWithFormat:@"%@", [dict objectForKey:@"prizeDesc"]];
        if ([CMMUtility isStringOk:prizeDesc]) {
            self.prizeDesc = prizeDesc;
        }
        
        NSString *fixedNumber = [NSString stringWithFormat:@"%@", [dict objectForKey:@"fixedNumber"]];
        if ([CMMUtility isStringOk:fixedNumber]) {
            self.fixedNumber = fixedNumber;
        }
        
        NSString *level =[NSString stringWithFormat:@"%@", [dict objectForKey:@"level"]];
        if ([CMMUtility isStringOk:level]) {
            self.level = level;
        }
        
        NSString *status = [NSString stringWithFormat:@"%@", [dict objectForKey:@"status"]];
        if ([CMMUtility isStringOk:status]) {
            self.status = status;
        }
        
        NSString *total = [NSString stringWithFormat:@"%@", [dict objectForKey:@"total"]];
        if ([CMMUtility isStringOk:total]) {
            self.total = total;
        }
        
        NSString *leaveNum = [NSString stringWithFormat:@"%@", [dict objectForKey:@"leaveNum"]];
        if ([CMMUtility isStringOk:leaveNum]) {
            self.leaveNum = leaveNum;
        }
        
        NSString *totalWinnerNum = [NSString stringWithFormat:@"%@", [dict objectForKey:@"totalWinnerNum"]];
        if ([CMMUtility isStringOk:totalWinnerNum]) {
            self.totalWinnerNum = totalWinnerNum;
        }
        
        NSString *activityId = [NSString stringWithFormat:@"%@", [dict objectForKey:@"activityId"]];
        if ([CMMUtility isStringOk:status]) {
            self.activityId = activityId;
        }
        
        NSString *exchange = [NSString stringWithFormat:@"%@", [dict objectForKey:@"exchange"]];
        if ([CMMUtility isStringOk:exchange]) {
            self.exchange = exchange;
        }
        
        NSString *needScore = [NSString stringWithFormat:@"%@", [dict objectForKey:@"needScore"]];
        if ([CMMUtility isStringOk:needScore]) {
            self.needScore = needScore;
        }
    }
    
    return self;
}

@end
