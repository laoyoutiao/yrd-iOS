//
//  QMAssistItem.h
//  MotherMoney
//
//  Created by    on 14-8-10.
//  Copyright (c) 2014年   . All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QMAssistItem : NSObject
@property (nonatomic, strong) NSString *assistId;
@property (nonatomic, strong) NSString *createTime;
@property (nonatomic, strong) NSString *updateTime;
@property (nonatomic, strong) NSString *enable;
@property (nonatomic, strong) NSString *helpContent;
@property (nonatomic, strong) NSString *helpTitle;
@property (nonatomic, strong) NSString *sortParameter;


- (id)initWithDictionary:(NSDictionary *)dict;

@end
