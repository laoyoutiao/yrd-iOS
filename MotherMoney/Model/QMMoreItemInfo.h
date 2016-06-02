//
//  QMMoreItemInfo.h
//  MotherMoney
//
//  Created by    on 14-8-10.
//  Copyright (c) 2014年   . All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QMMoreItemInfo : NSObject
@property (nonatomic, strong) NSString *itemIconName;
@property (nonatomic, strong) NSString *itemTitle;
@property (nonatomic, strong) NSString *itemSubTitle;
@property (nonatomic) SEL selector;
@property (nonatomic, assign) BOOL showsIndicator;
@property (nonatomic, assign) BOOL showsLine;
@property (nonatomic, strong) NSString *backgroundImageName;
@property (nonatomic, strong) NSString *selectedBgImageName;
@property (nonatomic, assign) CGSize imageSize;
@property (nonatomic, assign) BOOL hasUnReadInfo;


- (id)initWithDictionary:(NSDictionary *)dict;

@end
