//
//  QMPersonalCenterItemInfo.h
//  MotherMoney
//
//  Created by   on 14-8-15.
//  Copyright (c) 2014年  . All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QMPersonalCenterItemInfo : NSObject
@property (nonatomic, strong) NSString *iconImageName;
@property (nonatomic, strong) NSString *itemName;
@property (nonatomic, strong) NSString *itemSubName;

@property (nonatomic, assign) UITableViewCellAccessoryType accessoryType;
@property (nonatomic, assign) UITableViewCellSelectionStyle selectionStyle;

@property (nonatomic, strong) NSString *selectorName;
@property (nonatomic, assign) BOOL isUsingSwitch;

@property (nonatomic, assign) BOOL switchValue;

@end
