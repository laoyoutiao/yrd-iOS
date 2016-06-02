//
//  NSDictionary+Safe.h
//  Test
//
//  Created by 玉文辉 on 15/8/25.
//  Copyright (c) 2015年 玉文辉. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSDictionary (Safe)

- (CGFloat)safeFloatForKey:(NSString *)key;
- (CGFloat)safeFloatForKeyPath:(NSString *)keypath;

- (NSInteger)safeIntegerForKey:(NSString *)key;
- (NSInteger)safeIntegerForKeyPath:(NSString *)keypath;

- (NSString *)safeStringForKey:(NSString *)key;
- (NSString *)safeStringorKeyPath:(NSString *)keypath;

- (NSDictionary *)safeDictForKey:(NSString *)key;
- (NSDictionary *)safeDictForKeyPath:(NSString *)keypath;

- (NSArray *)safeArrayForKey:(NSString *)key;
- (NSArray *)safeArrayForKeyPath:(NSString *)keypath;

@end
