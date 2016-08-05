//
//  QMWebViewController.m
//  MotherMoney
//
//

#import "QMWebViewController.h"
#define PROGRESSTINTCOLOR [UIColor colorWithRed:89.0f / 255.0f green:12.0f / 255.0f blue:4.0f / 255.0f alpha:1.0f]

@interface QMWebViewController ()<NJKWebViewProgressDelegate>

@end

@implementation QMWebViewController
{
    NJKWebViewProgress* webViewProgress;
    UIProgressView* progressView;
    UIWebView* webContentView;
}

+ (void)showWebViewWithRequest:(NSURLRequest *)request
                      navTitle:(NSString *)title
                       isModel:(BOOL)isModel
                          from:(UIViewController *)controller {
    QMWebViewController *con = [[QMWebViewController alloc] init];
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


+ (void)showWebViewWithContent:(NSString *)content
                      navTitle:(NSString *)title
                       isModel:(BOOL)isModel
                          from:(UIViewController *)controller {
    QMWebViewController *con = [[QMWebViewController alloc] init];
    con.isModel = isModel;
    con.content = content;
    con.navTitle = title;
    
    if (isModel) {
        QMNavigationController *nav = [[QMNavigationController alloc] initWithRootViewController:con];
        [controller presentViewController:nav animated:YES completion:nil];
    }else {
        [controller.navigationController pushViewController:con animated:YES];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = QM_COMMON_BACKGROUND_COLOR;
    webViewProgress=[[NJKWebViewProgress alloc] init];
    webViewProgress.progressDelegate=self;
    webViewProgress.currentController = self;
    [self customSubViews];
    
}

- (void)customSubViews {
   
    progressView=[[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    progressView.frame=CGRectMake(0, 0, self.view.frame.size.width,5);
    progressView.progressTintColor=PROGRESSTINTCOLOR;
    
        webContentView = [[UIWebView alloc] initWithFrame:CGRectMake(0,3, self.view.frame.size.width, self.view.frame.size.height-3)];
    webContentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    webContentView.delegate = webViewProgress;
    [self.view addSubview:webContentView];
    [self.view addSubview:progressView];
    
    if (self.request) {
        
        [webContentView loadRequest:self.request];
        webContentView.frame=self.view.bounds;
        
    }else if (!QM_IS_STR_NIL(self.content)) {
        progressView.hidden=YES;
        webContentView.frame=self.view.bounds;
        [webContentView loadHTMLString:self.content baseURL:nil];
    }
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
    if ([webContentView canGoBack]) {
        [webContentView goBack];
    }else
    {
        if (self.isModel) {
            [self dismissViewControllerAnimated:YES
                                     completion:^{
                                         
                                     }];
        }else {
            [self.navigationController popViewControllerAnimated:YES];
        }

    }
}

//#pragma mark -
//#pragma mark UIWebViewDelegate
//
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    NSString *url = [[request URL] parameterString];
    
    NSLog(@"%@",url);
    
    return YES;
}
//
//- (void)webViewDidStartLoad:(UIWebView *)webView {
//    
//}
//
//- (void)webViewDidFinishLoad:(UIWebView *)webView {
//    // 禁用用户选择
//    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitUserSelect='none';"];
//    
//    // 禁用长按弹出框
//    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitTouchCallout='none';"];
//}
//
//- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
//    
//}
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
@end
