//
//  QMProvinceInfo.m
//  MotherMoney
//
//  Created by cgt cgt on 2017/9/8.
//  Copyright © 2017年 cgt cgt. All rights reserved.
//

#import "QMProvinceInfo.h"

@implementation QMProvinceInfo
{
    NSDictionary *allDict;
    NSArray *provinceNameArray;
    NSArray *provinceNumArray;
}

+(QMProvinceInfo *)sharedInstance
{
    static QMProvinceInfo *sharedManager;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[QMProvinceInfo alloc] init];
    });
    
    return sharedManager;
}

- (void)cutupProvince:(NSDictionary *)alldict
{
    allDict = alldict;
    provinceNumArray = [alldict allKeys];
    NSMutableArray *nameArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < [provinceNumArray count]; i ++) {
        NSDictionary *namedict = [alldict objectForKey:[provinceNumArray objectAtIndex:i]];
        [nameArray addObject:[[namedict allKeys] objectAtIndex:0]];
    }
    provinceNameArray = nameArray;
    
}

- (NSArray *)getProvinceName
{
    return provinceNameArray;
}

- (NSString *)getProvinceNumWithProvinceName:(NSString *)provincename
{
    NSInteger num = [provinceNameArray indexOfObject:provincename];
    return [provinceNumArray objectAtIndex:num];
}

- (NSString *)getCityNumWithProvinceName:(NSString *)provincename CityName:(NSString *)cityname
{
    NSDictionary *provinceDict = [allDict objectForKey:[self getProvinceNumWithProvinceName:provincename]];
    NSDictionary *cityDict = [provinceDict objectForKey:provincename];
    NSArray *citynumArray = [cityDict allKeys];
    NSArray *namearray = [self getCityNameWithProvinceName:provincename];
    NSInteger num = [namearray indexOfObject:cityname];
    return [citynumArray objectAtIndex:num];
}

- (NSArray *)getCityNameWithProvinceName:(NSString *)provincename
{
    NSDictionary *provinceDict = [allDict objectForKey:[self getProvinceNumWithProvinceName:provincename]];
    NSDictionary *cityDict = [provinceDict objectForKey:provincename];
    NSArray *citynumArray = [cityDict allKeys];
    NSMutableArray *nameArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < [citynumArray count]; i ++) {
        NSString *name = [cityDict objectForKey:[citynumArray objectAtIndex:i]];
        [nameArray addObject:name];
    }
    return nameArray;
}

@end
