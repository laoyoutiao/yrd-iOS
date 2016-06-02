//
//  QMWebViewController3.m
//  MotherMoney
//
//  Created by liuyanfang on 15/8/19.
//  Copyright (c) 2015年 liuyanfang. All rights reserved.
//

#import "QMWebViewController3.h"
#import "EGORefreshTableHeaderView.h"
@interface QMWebViewController3 ()<EGORefreshTableHeaderDelegate,UIWebViewDelegate,UIScrollViewDelegate>
{
    //下拉视图
    EGORefreshTableHeaderView * refreshHeaderView;
    //刷新标识，是否正在刷新过程中
    BOOL reloading;
    NSString* currentUrl;

}

@end

@implementation QMWebViewController3

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the vi
        //初始化refreshView，添加到webview 的 scrollView子视图中
    [self customSubViews];
//    if (refreshHeaderView == nil) {
//        refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0, 0-self.webContentView.scrollView.bounds.size.height, self.webContentView.scrollView.frame.size.width, self.webContentView.scrollView.bounds.size.height)];
//        refreshHeaderView.delegate = self;
//        [self.webContentView.scrollView addSubview:refreshHeaderView];
//    }
//    [refreshHeaderView refreshLastUpdatedDate];
}
- (void)customSubViews {
    self.webContentView=[[UIWebView alloc] initWithFrame:self.view.bounds];
    self.webContentView.delegate=self;
    self.webContentView.scrollView.delegate=self;

    self.webContentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.webContentView];
    
    if (self.request) {
        
        [self.webContentView loadRequest:self.request];
        
    }else if (!QM_IS_STR_NIL(self.content)) {
        
       
        [self.webContentView loadHTMLString:self.content baseURL:nil];
    }
}

+ (void)showWebViewWithRequest:(NSURLRequest *)request
                      navTitle:(NSString *)title
                       isModel:(BOOL)isModel
                          from:(UIViewController *)controller {
    QMWebViewController3 *con = [[QMWebViewController3 alloc] init];
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
    
    QMWebViewController3 *con = [[QMWebViewController3 alloc] init];
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
-(UIBarButtonItem *)leftBarButtonItem
{
    UIBarButtonItem* item1=[QMNavigationBarItemFactory createNavigationBackItemWithTarget:self selector:@selector(goBack)];
    return item1;
}
-(void)goBack
{
    if ([self.webContentView canGoBack]) {
        [self.webContentView goBack];
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
-(void)loadCurrentPage
{
    
    
    
    NSURL* url=[NSURL URLWithString:currentUrl];
    NSURLRequest* request=[NSURLRequest requestWithURL:url];
    
    NSLog(@"%@",currentUrl);
    
    
    [self.webContentView loadRequest:request];
}
#pragma mark - webview delegate

- (void)webViewDidStartLoad:(UIWebView *)webView {
    reloading = YES;
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    reloading = NO;
    [refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.webContentView.scrollView];
    currentUrl=self.webContentView.request.URL.absoluteString;
    
    // 禁用用户选择
    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitUserSelect='none';"];
    
    // 禁用长按弹出框
    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitTouchCallout='none';"];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    NSLog(@"load page error:%@", [error description]);
    reloading = NO;
    [refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.webContentView.scrollView];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    return YES;
}




#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
}

-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    [refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
}

#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
    
    [self loadCurrentPage];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
    
    return reloading; // should return if data source model is reloading
    
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
    
    return [NSDate date]; // should return date data source was last changed
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
