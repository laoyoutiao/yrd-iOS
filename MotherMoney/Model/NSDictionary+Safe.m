//
//  NSDictionary+Safe.m
//  Test
//
//  Created by 玉文辉 on 15/8/25.
//  Copyright (c) 2015年 玉文辉. All rights reserved.
//

#import "NSDictionary+Safe.h"

@implementation NSDictionary (Safe)

- (CGFloat)safeFloatForKey:(NSString *)key
{
    id value = [self valueForKey:key defaultsTo:nil];
    return (!value || value == NSNull.null) ? (CGFloat)0.0f : [value floatValue];
}

- (CGFloat)safeFloatForKeyPath:(NSString *)keypath
{
    id value = [self valueForKeyPath:keypath defaultsTo:nil];
    return (!value || value == NSNull.null) ? (CGFloat)0.0f : [value floatValue];
}

- (NSInteger)safeIntegerForKey:(NSString *)key
{
    id value = [self valueForKey:key defaultsTo:nil];
    return (!value || value == NSNull.null) ? (NSInteger)nil : [value integerValue];
}

- (NSInteger)safeIntegerForKeyPath:(NSString *)keypath
{
    id value = [self valueForKeyPath:keypath defaultsTo:nil];
    return (!value || value == NSNull.null) ? (NSInteger)nil : [value integerValue];
}

- (NSString *)safeStringForKey:(NSString *)key
{
    id value = [self valueForKey:key defaultsTo:@""];
    return (!value || value == NSNull.null) ? (NSString *)nil : value;
}

- (NSString *)safeStringorKeyPath:(NSString *)keypath
{
    id value = [self valueForKeyPath:keypath defaultsTo:@""];
    return (!value || value == NSNull.null) ? (NSString *)nil : value;
}

- (NSDictionary *)safeDictForKey:(NSString *)key
{
    id value = [self valueForKey:key defaultsTo:nil];
    return ([value isKindOfClass:NSDictionary.class]) ? nil : value;
}

- (NSDictionary *)safeDictForKeyPath:(NSString *)keypath
{
    id value = [self valueForKeyPath:keypath defaultsTo:nil];
    return ([value isKindOfClass:NSDictionary.class]) ? nil : value;
}

- (NSArray *)safeArrayForKey:(NSString *)key
{
    id value = [self valueForKey:key defaultsTo:nil];
    return ([value isKindOfClass:NSArray.class]) ? nil : value;
}
- (NSArray *)safeArrayForKeyPath:(NSString *)keypath
{
    id value = [self valueForKeyPath:keypath defaultsTo:nil];
    return ([value isKindOfClass:NSArray.class]) ? nil : value;
}

- (id)valueForKey:(NSString *)key defaultsTo:(NSString *)str
{
    id value;
    if (![key isEqualToString:str]) {
        value = [self objectForKey:key];
    }
    return value;
}

- (id)valueForKeyPath:(NSString *)key defaultsTo:(NSString *)str
{
    id value;
    if (![key isEqualToString:str]) {
        value = [self objectForKey:key];
    }
    return value;
}

@end
