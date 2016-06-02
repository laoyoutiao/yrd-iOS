//
//  QMImageFactory.h
//  MotherMoney
//
//  Created by   on 14-8-13.
//  Copyright (c) 2014年  . All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QMImageFactory : NSObject

+ (UIImage *)commonBackgroundImage;
+ (UIImage *)commonBackgroundImagePressed;

+ (UIImage *)commonHorizontalLineImage;

+ (UIImage *)commonBackgroundImageTopPart;
+ (UIImage *)commonBackgroundImageTopPartPressed;

+ (UIImage *)commonBackgroundImageBottomPart;
+ (UIImage *)commonBackgroundImageBottomPartPressed;

+ (UIImage *)commonBackgroundImageCenterPart;
+ (UIImage *)commonBackgroundImageCenterPartPressed;

+ (UIImage *)commomBackgroundImageLeftPart;
+ (UIImage *)commomBackgroundImageLeftPartPressed;

+ (UIImage *)commomBackgroundImageRightPart;
+ (UIImage *)commomBackgroundImageRightPartPressed;

// normal button image
+ (UIImage *)commonBtnNmBackgroundImage;
+ (UIImage *)commonBtnHlBackgroundImage;
+ (UIImage *)commonBtnDisableBackgroundImage;

// bordered button image
+ (UIImage *)commonBorderedBtnNmBackgroundImage;
+ (UIImage *)commonBorderedBtnHlBackgroundImage;
//+ (UIImage *)commonBorderedBtnDisableBackgroundImage;

// text field
+ (UIImage *)commonTextFieldImage;
+ (UIImage *)commonTextFieldImageTopPart;
+ (UIImage *)commonTextFieldImageBottomPart;

+ (UIImage *)commonFullScreenBackgroundImage;
+ (UIImage *)commonScaledFullScreenBackgroundImage;

+ (UIImage *)commonNavigationBackgroundImageForCurrentFullScreenBackgroundImage;

@end
