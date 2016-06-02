//
//  UIImage+Clip.m
//  MotherMoney
//
//  Created by   on 14-8-14.
//  Copyright (c) 2014年  . All rights reserved.
//

#import "UIImage+Clip.h"

@implementation UIImage (Clip)

- (UIImage *)clipImageInRect:(CGRect)rect {
    CGImageRef imageRef = CGImageCreateWithImageInRect(self.CGImage, rect);
    
    UIImage *thumbScale = [UIImage imageWithCGImage:imageRef];
    
    CGImageRelease(imageRef);
    
    return thumbScale;
}

@end
