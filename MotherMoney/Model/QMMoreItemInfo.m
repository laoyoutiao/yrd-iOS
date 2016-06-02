//
//  QMMoreItemInfo.m
//  MotherMoney
//
//  Created by    on 14-8-10.
//  Copyright (c) 2014年   . All rights reserved.
//

#import "QMMoreItemInfo.h"

@implementation QMMoreItemInfo

- (id)initWithDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        self.itemIconName = [dict objectForKey:@"itemIconName"];
        self.itemTitle = QMLocalizedString([dict objectForKey:@"itemTitle"], nil);
        NSString *str = [dict objectForKey:@"itemSubTitle"];
        if (!QM_IS_STR_NIL(str)) {
            self.itemSubTitle = [NSString stringWithFormat:QMLocalizedString(str, nil), [self currentAppVersion]];
        }
        self.selector = NSSelectorFromString([dict objectForKey:@"selector"]);
        self.showsIndicator = [[dict objectForKey:@"showsIndicator"] boolValue];
        self.showsLine = [[dict objectForKey:@"showsLine"] boolValue];
        self.backgroundImageName = [dict objectForKey:@"backgroundImageName"];
        self.selectedBgImageName = [dict objectForKey:@"selectedBgImageName"];
        self.imageSize = CGSizeFromString([dict objectForKey:@"imageSize"]);
    }
    
    return self;
}

-(NSString *)currentAppVersion {
    NSString *strCurrentAppVersion = [[NSDictionary dictionaryWithContentsOfFile:[[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent: @"Info.plist"]] objectForKey: @"CFBundleVersion"];
    
    return strCurrentAppVersion;
}

@end
