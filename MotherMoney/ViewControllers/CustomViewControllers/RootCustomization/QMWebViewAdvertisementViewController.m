//
//  QMWebViewAdvertisementViewController.m
//  MotherMoney
//
//  Created by cgt cgt on 16/5/24.
//  Copyright © 2016年 cgt cgt. All rights reserved.
//

#import "QMWebViewAdvertisementViewController.h"

@interface QMWebViewAdvertisementViewController ()<UIWebViewDelegate>
{
    UIWebView *webview;
}

@end

@implementation QMWebViewAdvertisementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    webview = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 64)];
    [webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_advertUrlString]]];
    //    NSLog(@"%@",advertUrlString);
    webview.delegate = self;
    [self.view addSubview:webview];
    
    // Do any additional setup after loading the view.
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    NSString *url = [[request URL] absoluteString];
    
    NSLog(@"%@",url);
    
    if ([url rangeOfString:@"http://www.baidu.com"].location != NSNotFound) {
        NSLog(@"跳入百度");
        [QMLoginManagerUtil showLoginViewControllerFromViewController:self];
        return NO;
    }
    
    return YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    NSLog(@"出现");
    [webview reload];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
