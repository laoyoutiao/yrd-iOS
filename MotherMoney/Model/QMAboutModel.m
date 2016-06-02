//
//  QMAboutModel.m
//  MotherMoney
//
//  Created by liuyanfang on 15/12/8.
//  Copyright (c) 2015年 liuyanfang. All rights reserved.
//

#import "QMAboutModel.h"

@implementation QMAboutModel
- (id)initWithDictionary:(NSDictionary *)dic{
    if (self= [super initWithDictionary:dic]) {
        self.phoneNumber = [dic objectForKey:@"tel"];
        self.email = [dic objectForKey:@"email"];
        self.url = [dic objectForKey:@"url"];
        self.introduce = [dic objectForKey:@"jieshao"];
    }
    return self;
}
@end
