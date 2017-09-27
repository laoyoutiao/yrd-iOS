//
//  QMAdvertisementModel.m
//  MotherMoney
//
//  Created by cgt cgt on 16/5/24.
//  Copyright © 2016年 cgt cgt. All rights reserved.
//

#import "QMAdvertisementModel.h"

@implementation QMAdvertisementModel

- (id)initWithDictionary:(NSDictionary *)dic
{
    if (self= [super initWithDictionary:dic]) {
        self.AdverID = [dic safeIntegerForKey:@"id"];
        self.AdverName = [dic safeStringForKey:@"name"];
        self.AdverUrl = [dic safeStringForKey:@"url"];
        self.AdverPath = [dic safeStringForKey:@"picPath"];
        self.AdverHomePath = [dic safeStringForKey:@"picPath"];
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
