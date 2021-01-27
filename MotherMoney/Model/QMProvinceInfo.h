//
//  QMProvinceInfo.h
//  MotherMoney
//
//  Created by cgt cgt on 2017/9/8.
//  Copyright © 2017年 cgt cgt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QMProvinceInfo : NSObject

+(QMProvinceInfo *)sharedInstance;

//处理字典数据
- (void)cutupProvince:(NSDictionary *)alldict;
//获取省名数组
- (NSArray *)getProvinceName;
//获取省名对应编号
- (NSString *)getProvinceNumWithProvinceName:(NSString *)provincename;
//获取某省城市数组
- (NSArray *)getCityNameWithProvinceName:(NSString *)provincename;
//获取某省城市对应编号
- (NSString *)getCityNumWithProvinceName:(NSString *)provincename CityName:(NSString *)cityname;


@end
