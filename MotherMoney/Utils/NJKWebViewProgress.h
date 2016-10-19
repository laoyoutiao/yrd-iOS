//
//  NJKWebViewProgress.h
//
//  Created by Satoshi Aasano on 4/20/13.
//  Copyright (c) 2013 Satoshi Asano. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QMProductInfo.h"

#undef njk_weak
#if __has_feature(objc_arc_weak)
#define njk_weak weak
#else
#define njk_weak unsafe_unretained
#endif

typedef void (^NJKWebViewProgressBlock)(float progress);

@protocol NJKWebViewPushDelegate <NSObject>
- (void)pushView:(QMProductInfo *)info;
@end

@protocol NJKWebViewProgressDelegate;
@interface NJKWebViewProgress : NSObject<UIWebViewDelegate,NSURLSessionDelegate,UIScrollViewDelegate>
@property (nonatomic, njk_weak) id<NJKWebViewProgressDelegate>progressDelegate;
@property (nonatomic, njk_weak) id<UIWebViewDelegate>webViewProxyDelegate;
@property (nonatomic, copy) NJKWebViewProgressBlock progressBlock;
@property (nonatomic, readonly) float progress; // 0.0..1.0
@property (assign, nonatomic) id<NJKWebViewPushDelegate> pushdelegate;
@property (nonatomic,assign) UIViewController *currentController;
@property (strong, nonatomic) UIWebView *webviewP;
@property (assign, nonatomic) float scrollviewcontentoffsetY;
- (void)reset;
@end

@protocol NJKWebViewProgressDelegate <NSObject>
- (void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress;
@end


