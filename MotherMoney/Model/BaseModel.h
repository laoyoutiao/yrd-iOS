//
//  BaseModel.h
//  Project1
//
//  Created by 贝沃it on 15/6/9.
//  Copyright (c) 2015年 贝沃it. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSDictionary+Safe.h"

@interface BaseModel : NSObject

-(id)initWithDictionary:(NSDictionary *)dic;

-(void)setAttritute:(NSDictionary *)dic;

@property (nonatomic ,copy)NSDictionary *map;

@end
