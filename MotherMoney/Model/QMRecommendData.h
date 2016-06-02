//
//  QMRecommendData.h
//  MotherMoney
//
//  Created by   on 14-8-6.
//  Copyright (c) 2014年  . All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QMProductInfo.h"
//精品推荐数据源
@interface QMRecommendData : NSObject
@property (nonatomic, strong) NSArray *banners;
@property (nonatomic, assign) BOOL canProductBuy;
@property (nonatomic, strong) QMProductInfo *productionInfo;

@end
