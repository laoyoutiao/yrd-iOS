//
//  QMImageFactory.m
//  MotherMoney
//
//  Created by   on 14-8-13.
//  Copyright (c) 2014年  . All rights reserved.
//

#import "QMImageFactory.h"
#import "UIImage+Clip.h"
#import "QMDeviceUtil.h"

@implementation QMImageFactory

+ (UIImage *)commonBackgroundImage {
    UIImage *image = [[UIImage imageNamed:@"common_bg.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:22];
    
    return image;
}

+ (UIImage *)commonBackgroundImagePressed {
    UIImage *image = [[UIImage imageNamed:@"common_bg_pressed.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:22];
    
    return image;
}

+ (UIImage *)commonHorizontalLineImage {
    UIImage *image = [[UIImage imageNamed:@"common_line.png"] resizableImageWithCapInsets:UIEdgeInsetsZero resizingMode:UIImageResizingModeTile];
    
    return image;
}

+ (UIImage *)commonBtnNmBackgroundImage {
    UIImage *image = [[UIImage imageNamed:@"common_btn.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:12];
    
    return image;
}

+ (UIImage *)commonBtnHlBackgroundImage {
    UIImage *image = [[UIImage imageNamed:@"common_btn_pressed.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:12];
    
    return image;
}

+ (UIImage *)commonBtnDisableBackgroundImage {
    UIImage *image = [[UIImage imageNamed:@"common_btn_disable.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:12];
    
    return image;
}

// top
+ (UIImage *)commonBackgroundImageTopPart {
    return [[UIImage imageNamed:@"common_bg_on.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:30];
}

+ (UIImage *)commonBackgroundImageTopPartPressed {
    return [[UIImage imageNamed:@"common_bg_on_pressed.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:30];
}

// bottom
+ (UIImage *)commonBackgroundImageBottomPart {
    return [[UIImage imageNamed:@"common_bg_down.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:10];
}

+ (UIImage *)commonBackgroundImageBottomPartPressed {
    return [[UIImage imageNamed:@"common_bg_down_pressed.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:10];
}

// middle
+ (UIImage *)commonBackgroundImageCenterPart {
    return [[UIImage imageNamed:@"common_bg_middle.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:22];
}

+ (UIImage *)commonBackgroundImageCenterPartPressed {
    return [[UIImage imageNamed:@"common_bg_middle_pressed.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:22];
}

// left
+ (UIImage *)commomBackgroundImageLeftPart {
    return [[UIImage imageNamed:@"common_bg_l.png"] stretchableImageWithLeftCapWidth:15 topCapHeight:22];
}

+ (UIImage *)commomBackgroundImageLeftPartPressed {
    return [[UIImage imageNamed:@"common_bg_l_pressed.png"] stretchableImageWithLeftCapWidth:15 topCapHeight:22];
}

// right
+ (UIImage *)commomBackgroundImageRightPart {
    return [[UIImage imageNamed:@"common_bg_r.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:22];
}

+ (UIImage *)commomBackgroundImageRightPartPressed {
    return [[UIImage imageNamed:@"common_bg_r_pressed.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:22];
}

// bordered button image
+ (UIImage *)commonBorderedBtnNmBackgroundImage {
    return [[UIImage imageNamed:@"common_line_btn.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:21];
}

+ (UIImage *)commonBorderedBtnHlBackgroundImage {
    return [[UIImage imageNamed:@"common_line_btn_pressed.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:21];
}

//+ (UIImage *)commonBorderedBtnDisableBackgroundImage {
//    
//}

+ (UIImage *)commonTextFieldImage {
    return [[UIImage imageNamed:@"common_input_box.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:22];
}

+ (UIImage *)commonTextFieldImageTopPart {
    return [[UIImage imageNamed:@"common_input_box_on.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:22];
}

+ (UIImage *)commonTextFieldImageBottomPart {
    return [[UIImage imageNamed:@"common_input_box_down.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:22];
}

+ (UIImage *)commonFullScreenBackgroundImage {
    UIImage *backgroundImage = nil;
    if ([QMDeviceUtil is4Inch]) {
        // iPhone5 以上设备
        backgroundImage = [UIImage imageNamed:@"common_bg_full_2.png"];
    }else {
        // iPhone5以下设备
        backgroundImage = [UIImage imageNamed:@"common_bg_full_1.png"];
    }
    
    return backgroundImage;
}

+ (UIImage *)commonScaledFullScreenBackgroundImage {
    UIImage *backgroundImage = [self commonFullScreenBackgroundImage];
    
    CGSize size = [UIScreen mainScreen].bounds.size;
    // 裁剪得到navigation bar的背景图片
    UIGraphicsBeginImageContextWithOptions(size, YES, 0.0f);
    
    [backgroundImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    backgroundImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return backgroundImage;
}

+ (UIImage *)commonNavigationBackgroundImageForCurrentFullScreenBackgroundImage {
    CGSize size = CGSizeMake([UIScreen mainScreen].bounds.size.width, 64);
    
    UIImage *backgroundImage = [self commonFullScreenBackgroundImage];
    
    CGImageRef navImageRef = CGImageCreateWithImageInRect(backgroundImage.CGImage, CGRectMake(0, 0, backgroundImage.size.width * backgroundImage.scale, size.height * backgroundImage.scale));
    
    backgroundImage = [UIImage imageWithCGImage:navImageRef];
    
    // 裁剪得到navigation bar的背景图片
    UIGraphicsBeginImageContextWithOptions(size, YES, 0.0f);
    
    [backgroundImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    UIImage *navigationBarBackgroundImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return navigationBarBackgroundImage;
}

@end

