//
//  QMHeeWebViewController.m
//  MotherMoney
//
//  Created by cgt cgt on 16/6/3.
//  Copyright © 2016年 cgt cgt. All rights reserved.
//

#import "QMHeeWebViewController.h"
#import "NJKWebViewProgress.h"
#import "MyFundViewController.h"

@interface QMHeeWebViewController ()<UIWebViewDelegate, UITabBarControllerDelegate>
{
    NJKWebViewProgress* webViewProgress;
    UIProgressView* progressView;
    UIWebView* webContentView;
}
@property (nonatomic, strong) NSString *navTitle;
@property (nonatomic, assign) BOOL isModel;
@property (nonatomic, strong) NSURLRequest *request;
@end

@implementation QMHeeWebViewController

+ (void)showWebViewWithRequest:(NSURLRequest *)request
                      navTitle:(NSString *)title
                       isModel:(BOOL)isModel
                          from:(UIViewController *)controller {
    
    
    
    QMHeeWebViewController *con = [[QMHeeWebViewController alloc] init];
    con.isModel = isModel;
    con.navTitle = title;
    con.request = request;
    
    if (isModel) {
        QMNavigationController *nav = [[QMNavigationController alloc] initWithRootViewController:con];
        [controller presentViewController:nav animated:YES completion:nil];
    }else {
        [controller.navigationController pushViewController:con animated:YES];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self customSubViews];
    // Do any additional setup after loading the view.
}

- (void)customSubViews{

    webContentView = [[UIWebView alloc] initWithFrame:CGRectMake(0,0, self.view.frame.size.width, self.view.frame.size.height)];
    webContentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    webContentView.delegate = self;
    [self.view addSubview:webContentView];
    [webContentView loadRequest:self.request];
    webContentView.frame=self.view.bounds;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIBarButtonItem *)rightBarButtonItem{
    UIBarButtonItem* item2=[QMNavigationBarItemFactory createNavigationReloadItemWithTarget:self selector:@selector(close)];
    return item2;
    
}
-(UIBarButtonItem *)leftBarButtonItem
{
    UIBarButtonItem* item1=[QMNavigationBarItemFactory createNavigationBackItemWithTarget:self selector:@selector(goBack)];
    return item1;
}

- (void)close{
    if (self.isModel) {
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}
- (void)goBack {
    
    if (self.isModel) {
        [self dismissViewControllerAnimated:YES
                                 completion:^{
                                     
                                 }];
    }else {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    
}

#pragma mark -
#pragma mark UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *url = [[request URL] absoluteString];
    NSLog(@"%@",url);
    if ([url rangeOfString:@"http://m.yrdloan.com/wap/product4bid"].location != NSNotFound) {
        [self presentToMyFundView];
        return NO;
    }
    return YES;
}

- (void)presentToMyFundView
{
    QMTabBarController *tabbarController = [QMTabBarConfigure configuredTabBarController];
    tabbarController.selectedIndex = 2;
    tabbarController.delegate = self;
    [self presentViewController:tabbarController animated:YES completion:nil];
}


#pragma mark NJKWebViewProgressDelegate
-(void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress
{
    if (progress == 0.0) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        progressView.progress = 0;
        [UIView animateWithDuration:0.27 animations:^{
            progressView.alpha = 1.0;
        }];
    }
    if (progress == 1.0) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        [UIView animateWithDuration:0.27 delay:progress - progressView.progress options:0 animations:^{
            progressView.alpha = 0.0;
        } completion:nil];
    }
    
    [progressView setProgress:progress animated:NO];
    
}

#pragma mark -
#pragma mark Override
- (NSString *)title {
    if (!QM_IS_STR_NIL(self.navTitle)) {
        return self.navTitle;
    }
    
    return @"";
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
