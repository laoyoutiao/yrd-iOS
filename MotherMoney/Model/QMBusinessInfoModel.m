//
//  QMBusinessInfoModel.m
//  MotherMoney
//
//  Created by cgt cgt on 2017/8/10.
//  Copyright © 2017年 cgt cgt. All rights reserved.
//

#import "QMBusinessInfoModel.h"

@implementation QMBusinessInfoModel

- (id)initWithDictionary:(NSDictionary *)dictionary {
    if (self = [super init]) {
        NSString *time = [NSString stringWithFormat:@"%@", [dictionary objectForKey:@"note"]];
        if ([CMMUtility isStringOk:time]) {
            self.time = time;
        }
        
        NSString *commission = [NSString stringWithFormat:@"%@", [dictionary objectForKey:@"commission"]];
        commission = [commission isEqualToString:@"<null>"]? @"0":commission;
        commission = commission.length? commission:@"0";
        if ([CMMUtility isStringOk:commission]) {
            self.commission = commission;
        }
        
        NSString *annualrat = [NSString stringWithFormat:@"%@", [dictionary objectForKey:@"annualizedAmountTotal"]];
        annualrat = annualrat.length? annualrat:@"0";
        if ([CMMUtility isStringOk:annualrat]) {
            self.annualrat = annualrat;
        }
        
        NSString *accountnumber = [NSString stringWithFormat:@"%@", [dictionary objectForKey:@"customerCount"]];
        if ([CMMUtility isStringOk:accountnumber]) {
            self.accountnumber = accountnumber;
        }
        
    }
    
    return self;
}

+ (NSArray *)instanceArrayDictFromArray:(NSArray *)array
{
    NSMutableArray *instanceArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < [array count]; i ++){
        [instanceArray  addObject:[[self alloc] initWithDictionary:[array objectAtIndex:i]]];
    }
    return [NSArray arrayWithArray:instanceArray];
}

@end
