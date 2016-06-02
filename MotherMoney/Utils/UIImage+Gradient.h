//
//  UIImage+Gradient.h
//  MotherMoney
//
//  Created by   on 14-8-13.
//  Copyright (c) 2014年  . All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Gradient)

+ (UIImage*)gradientImageFromColors:(NSArray*)colors withSize:(CGSize)size;

+ (UIImage*)leanGradientImageFromColors:(NSArray*)colors withSize:(CGSize)size;

@end
