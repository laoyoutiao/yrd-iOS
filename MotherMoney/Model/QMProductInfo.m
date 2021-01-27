//
//  QMProductInfo.m
//  MotherMoney
//
//  Created by   on 14-8-6.
//  Copyright (c) 2014年  . All rights reserved.
//

#import "QMProductInfo.h"

@implementation QMProductInfo

- (id)initWithDictionary:(NSDictionary *)dictionary {
    if (self = [super init]) {
        NSString *productId = [NSString stringWithFormat:@"%d", [[dictionary objectForKey:@"id"] intValue]];
        
        if ([CMMUtility isStringOk:productId]) {
            self.product_id = productId;
        }
        
        NSString *productName = [dictionary objectForKey:@"productName"];
        if ([CMMUtility isStringOk:productName]) {
            self.productName = productName;
        }
        
        NSString *isRecommended = [NSString stringWithFormat:@"%@", [dictionary objectForKey:@"recommend"]];
        if ([CMMUtility isStringOk:isRecommended]) {
            self.isRecommended = [isRecommended boolValue];
        }
        
        NSString *interest = [NSString stringWithFormat:@"%@", [dictionary objectForKey:@"interest"]];
        if ([CMMUtility isStringOk:interest]) {
            self.interest = interest;
        }
        
        NSString *maturityDuration = [NSString stringWithFormat:@"%@", [dictionary objectForKey:@"maturityDuration"]];
        if ([CMMUtility isStringOk:maturityDuration]) {
            self.maturityDuration = maturityDuration;
        }
        
        NSString *maxAmount = [NSString stringWithFormat:@"%@", [dictionary objectForKey:@"maxAmount"]];
        if ([CMMUtility isStringOk:maxAmount]) {
            self.maxAmount = maxAmount;
        }
        
        NSString *minAmount = [NSString stringWithFormat:@"%@", [dictionary objectForKey:@"minAmount"]];
        if ([CMMUtility isStringOk:minAmount]) {
            self.minAmount = minAmount;
        }
        
        NSString *maxInterest = [NSString stringWithFormat:@"%@", [dictionary objectForKey:@"maxInterest"]];
        if ([CMMUtility isStringOk:maxInterest]) {
            self.maxInterest = maxInterest;
        }
        
        NSString *minInterest = [NSString stringWithFormat:@"%@", [dictionary objectForKey:@"minInterest"]];
        if ([CMMUtility isStringOk:minInterest]) {
            self.minInterest = minInterest;
        }
        
        NSString *productChannelId = [NSString stringWithFormat:@"%@", [dictionary objectForKey:@"productChannelId"]];
        if ([CMMUtility isStringOk:productChannelId]) {
            self.productChannelId = productChannelId;
        }
        
        NSString *productInterestType = [NSString stringWithFormat:@"%@", [dictionary objectForKey:@"productInterestType"]];
        if ([CMMUtility isStringOk:productInterestType]) {
            self.productInterestType = productInterestType;
        }
        
        NSString *productStatus = [NSString stringWithFormat:@"%@", [dictionary objectForKey:@"productStatus"]];
        if ([CMMUtility isStringOk:productStatus]) {
            self.productStatus = productStatus;
        }
        
        NSString *productStatusValue = [NSString stringWithFormat:@"%@", [dictionary objectForKey:@"productStatusValue"]];
        if ([CMMUtility isStringOk:productStatusValue]) {
            self.productStatusValue = productStatusValue;
        }
        
        NSString *remainingAmount = [NSString stringWithFormat:@"%@", [dictionary objectForKey:@"remainingAmount"]];
        if ([CMMUtility isStringOk:remainingAmount]) {
            self.remainingAmount = remainingAmount;
        }
        
        NSString *saleAmount = [NSString stringWithFormat:@"%@", [dictionary objectForKey:@"saleAmount"]];
        if ([CMMUtility isStringOk:saleAmount]) {
            self.saleAmount = saleAmount;
        }
        
        NSString *saleEndTime = [NSString stringWithFormat:@"%@", [dictionary objectForKey:@"saleEndTime"]];
        if ([CMMUtility isStringOk:saleEndTime]) {
            self.saleEndTime = saleEndTime;
        }
        
        NSString *saleStartTime = [NSString stringWithFormat:@"%@", [dictionary objectForKey:@"saleStartTime"]];
        if ([CMMUtility isStringOk:saleStartTime]) {
            self.saleStartTime = saleStartTime;
        }
        
        NSString *startBuyTime = [NSString stringWithFormat:@"%@", [dictionary objectForKey:@"startBuyTime"]];
        if ([CMMUtility isStringOk:startBuyTime]) {
            self.startBuyTime = startBuyTime;
        }
        
        NSString *totalAmount = [NSString stringWithFormat:@"%@", [dictionary objectForKey:@"totalAmount"]];
        if ([CMMUtility isStringOk:totalAmount]) {
            self.totalAmount = totalAmount;
        }
        
        NSString *finishRatio = [NSString stringWithFormat:@"%@", [dictionary objectForKey:@"finishRatio"]];
        if ([CMMUtility isStringOk:finishRatio]) {
            self.finishRatio = finishRatio;
        }
        
        NSString *totalBuyNumber = [NSString stringWithFormat:@"%@", [dictionary objectForKey:@"totalBuyNumber"]];
        if ([CMMUtility isStringOk:totalBuyNumber]) {
            self.totalBuyNumber = totalBuyNumber;
        }
        
        NSString *baseAmount = [NSString stringWithFormat:@"%@", [dictionary objectForKey:@"baseAmount"]];
        if ([CMMUtility isStringOk:baseAmount]) {
            self.baseAmount = baseAmount;
        }
        
        NSString *startInterestDate = [NSString stringWithFormat:@"%@", [dictionary objectForKey:@"startInterestDate"]];
        if ([CMMUtility isStringOk:startInterestDate]) {
            self.startInterestDate = startInterestDate;
        }
        
        NSString *endInterestDate = [NSString stringWithFormat:@"%@", [dictionary objectForKey:@"endInterestDate"]];
        if ([CMMUtility isStringOk:endInterestDate]) {
            self.endInterestDate = endInterestDate;
        }
        
        // corner type
        NSString *cornerType = [NSString stringWithFormat:@"%@", [dictionary objectForKey:@"cornerType"]];
        if ([CMMUtility isStringOk:cornerType]) {
            self.cornerType = cornerType;
        }
        
        // 新增字段
        // 标题
        NSString *productText = [NSString stringWithFormat:@"%@", [dictionary objectForKey:@"descriptionTitle"]];
        if ([CMMUtility isStringOk:productText]) {
            self.productText = productText;
        }

        // 描述
        NSString *activityDescription = [NSString stringWithFormat:@"%@", [dictionary objectForKey:@"activityDescription"]];
        if ([CMMUtility isStringOk:activityDescription]) {
            self.productDescription = activityDescription;
        }
        
        NSString *productDetail = [NSString stringWithFormat:@"%@", [dictionary objectForKey:@"remark"]];
        if ([CMMUtility isStringOk:productDetail]) {
//            NSLog(@"%@",productDetail);
            self.productDetailText = productDetail;
        }
        
        NSString *date = [[self maturityDuration] stringByReplacingOccurrencesOfString:@"天" withString:@""];
        self.maturityDurationValue = [date integerValue];
        
        NSString *normalInterest = [NSString stringWithFormat:@"%@", [dictionary objectForKey:@"normalInterest"]];
        if ([CMMUtility isStringOk:normalInterest]) {
            self.normalInterest = normalInterest;
        }
        
        NSString *awardInterest = [NSString stringWithFormat:@"%@", [dictionary objectForKey:@"awardInterest"]];
        if ([CMMUtility isStringOk:awardInterest]) {
            self.awardInterest = awardInterest;
        }
        NSString *descriptionTitle = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"descriptionTitle"]];
        
        if ([CMMUtility isStringOk:descriptionTitle]) {
            self.descriptionTitle = descriptionTitle;
        }
        NSString *isMonthlySettlement = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"isMonthlySettlement"]];
        
        if ([CMMUtility isStringOk:isMonthlySettlement]) {
            self.isMonthlySettlement = isMonthlySettlement;
        }
    }
    
    return self;
}

- (NSString *)expectedRateStr {
    NSString *expectRateStr = nil;
    if ([self.interest integerValue] <= 0) {
        expectRateStr = [NSString stringWithFormat:@"%.1f%% ~ %.1f%%", [self.minInterest floatValue], [self.maxInterest floatValue]];
    }else {
        expectRateStr = [NSString stringWithFormat:@"%.1f%%", [self.interest floatValue]];
    }
    
    return expectRateStr;
}

- (CGFloat)expectedRateForCalculator {
    CGFloat expectedRate = 0.0f;
    if ([self.interest floatValue] > 0) {
        expectedRate = [self.interest floatValue];
    }else if ([self.maxInterest floatValue] > 0) {
        expectedRate = [self.maxInterest floatValue];
    }
    
    return expectedRate / 100;
}

- (id)initWithRecommandDictionary:(NSDictionary *)dictionary {
    if (self = [self initWithDictionary:dictionary]) {
        
    }
    
    return self;
}

- (NSString *)calculateMinAmount {
    if ([self.productChannelId integerValue] == 1) {
        return self.minAmount;
    }else if ([self.productChannelId integerValue] == 2) {
        NSInteger amount = [self.minAmount integerValue] * [self.baseAmount integerValue];
        return [NSString stringWithFormat:@"%@", [NSNumber numberWithInteger:amount]];
    }
    
    return @"";
}

@end
