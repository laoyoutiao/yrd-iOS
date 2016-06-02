//
//  QMDeviceUtil.m
//  MotherMoney

#import "QMDeviceUtil.h"

@implementation QMDeviceUtil

+ (BOOL) is4Inch {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        CGRect frame = [UIScreen mainScreen].bounds;
        //判断屏幕高度，>=568即iphone5及以后的版本
        if (CGRectGetHeight(frame) >= 568.0f) {
            return YES;
        }else {
            return NO;
        }
    }else {
        return NO;
    }
}

@end
