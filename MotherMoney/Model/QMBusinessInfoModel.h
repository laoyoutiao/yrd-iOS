//
//  QMBusinessInfoModel.h
//  MotherMoney
//
//  Created by cgt cgt on 2017/8/10.
//  Copyright © 2017年 cgt cgt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QMBusinessInfoModel : NSObject

@property (nonatomic, strong) NSString *time;
@property (nonatomic, strong) NSString *accountnumber;
@property (nonatomic, strong) NSString *annualrat;
@property (nonatomic, strong) NSString *commission;

- (id)initWithDictionary:(NSDictionary *)dictionary;
+ (NSArray *)instanceArrayDictFromArray:(NSArray *)array;

@end
