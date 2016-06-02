//
//  QMBottomTitleBtn.m
//  MotherMoney
//
//  Created by 赵国辉 on 15/4/7.
//  Copyright (c) 2015年 赵国辉. All rights reserved.
//

#import "QMBottomTitleBtn.h"

@implementation QMBottomTitleBtn

- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    return CGRectMake(0, CGRectGetHeight(contentRect) - 16, CGRectGetWidth(contentRect), 16);
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    CGSize imageSize = CGSizeMake(40, 40);
    
    return CGRectMake((CGRectGetWidth(contentRect) - imageSize.width) / 2.0f, 0, imageSize.width, imageSize.height);
}

@end
