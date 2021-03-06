//
//  QMWebViewController3.h
//  MotherMoney
//
//  Created by liuyanfang on 15/8/19.
//  Copyright (c) 2015年 liuyanfang. All rights reserved.
//

#import "QMViewController.h"

@interface QMWebViewController3 : QMViewController
@property (nonatomic,strong)UIWebView* webContentView;
@property (nonatomic, strong) NSURLRequest *request;
@property (nonatomic, strong) NSString *navTitle;
@property (nonatomic, assign) BOOL isModel;
@property (nonatomic, strong) NSString *content;

+ (void)showWebViewWithRequest:(NSURLRequest *)request navTitle:(NSString *)title isModel:(BOOL)isModel from:(UIViewController *)controller;

+ (void)showWebViewWithContent:(NSString *)content navTitle:(NSString *)title isModel:(BOOL)isModel from:(UIViewController *)controller;
@end
