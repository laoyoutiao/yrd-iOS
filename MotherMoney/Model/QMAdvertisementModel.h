//
//  QMAdvertisementModel.h
//  MotherMoney
//
//  Created by cgt cgt on 16/5/24.
//  Copyright © 2016年 cgt cgt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"

@interface QMAdvertisementModel : BaseModel

@property (nonatomic, assign) NSInteger AdverID;
@property (nonatomic, strong) NSString *AdverName;
@property (nonatomic, strong) NSString *AdverUrl;
@property (nonatomic, strong) NSString *AdverPath;
@property (nonatomic, strong) NSString *AdverHomePath;

+ (NSArray *)instanceArrayDictFromArray:(NSArray *)array;
@end
