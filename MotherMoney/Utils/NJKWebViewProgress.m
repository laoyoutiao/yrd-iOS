//
//  NJKWebViewProgress.m
//
//  Created by Satoshi Aasano on 4/20/13.
//  Copyright (c) 2013 Satoshi Asano. All rights reserved.
//

#import "NJKWebViewProgress.h"
#import "QMUMTookKitManager.h"
#import "BlockActionSheet.h"
#import "UMSocialDataService.h"
#import "UMSocialSnsPlatformManager.h"
#import "UMSocialConfig.h"
#import "WXApi.h"
#import "UMSocialAccountManager.h"
#import "QMWebViewController.h"
#import "NSString+url.h"
#import "JSONKit.h"


NSString *completeRPCURL = @"webviewprogressproxy:///complete";

static const float initialProgressValue = 0.1;
static const float beforeInteractiveMaxProgressValue = 0.5;
static const float afterInteractiveMaxProgressValue = 0.9;

@implementation NJKWebViewProgress
{
    NSUInteger _loadingCount;
    NSUInteger _maxLoadCount;
    NSURL *_currentURL;
    BOOL _interactive;
}

- (id)init
{
    self = [super init];
    if (self) {
        _maxLoadCount = _loadingCount = 0;
        _interactive = NO;
    }
    return self;
}

- (void)startProgress
{
    if (_progress < initialProgressValue) {
        [self setProgress:initialProgressValue];
    }
}

- (void)incrementProgress
{
    float progress = self.progress;
    float maxProgress = _interactive ? afterInteractiveMaxProgressValue : beforeInteractiveMaxProgressValue;
    float remainPercent = (float)_loadingCount / (float)_maxLoadCount;
    float increment = (maxProgress - progress) * remainPercent;
    progress += increment;
    progress = fmin(progress, maxProgress);
    [self setProgress:progress];
}

- (void)completeProgress
{
    [self setProgress:1.0];
}

- (void)setProgress:(float)progress
{
    // progress should be incremental only
    if (progress > _progress || progress == 0) {
        _progress = progress;
        if ([_progressDelegate respondsToSelector:@selector(webViewProgress:updateProgress:)]) {
            [_progressDelegate webViewProgress:self updateProgress:progress];
        }
        if (_progressBlock) {
            _progressBlock(progress);
        }
    }
}

- (void)reset
{
    _maxLoadCount = _loadingCount = 0;
    _interactive = NO;
    [self setProgress:0.0];
}

#pragma mark -
#pragma mark UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    
//    NSArray *cookies = [storage cookies];
//    NSHTTPCookie * cookie = [cookies lastObject];
//    NSLog(@"sessionId-----------------[%@]-------------%@------------",cookie.value,cookies);
    
    
    NSString *urlPath = [[request URL] path];
    NSString *url = [[request URL] absoluteString];
    NSLog(@"web view request urlPath:%@",urlPath);
    NSLog(@"web view request urlPath:%@",url);
    
    if([url rangeOfString:@"product_"].location != NSNotFound)
    {
        NSRange range = [url rangeOfString:@"#"];
        NSString *product = [url substringFromIndex:range.location];
        NSString *productid = [product substringWithRange:NSMakeRange(9, product.length - 9)];
        [[NetServiceManager sharedInstance] getProductDetailWithProductId:productid
                                                                 delegate:self
                                                                  success:^(id responseObject) {
                                                                      // 更新产品信息
                                                                      if ([responseObject isKindOfClass:[NSDictionary class]]) {
                                                                          NSDictionary *dict = [responseObject objectForKey:@"product"];
                                                                          if (QM_IS_DICT_NIL(dict)) {
                                                                              return;
                                                                          }
                                                                          QMProductInfo *productInfo = [[QMProductInfo alloc] initWithDictionary:dict];
                                                                          [_pushdelegate pushView:productInfo];
                                                                      }
                                                                  } failure:^(NSError *error) {
                                                                      [SVProgressHUD showErrorWithStatus:QMLocalizedString(@"qm_get_product_detail_failed", @"获取产品详情失败")];
                                                                  }];
        return NO;
    }
    
    if([urlPath rangeOfString:kShareInWebView].location !=NSNotFound){
        NSLog(@"need share");
        
        // TODO 这里调用第三方分享方法
        
        NSString *parametersString = [[request URL] query];
        
        NSString * decodeString = [NSString decodeString:parametersString];
        
        NSDictionary *dic = (NSDictionary *)[[decodeString dataUsingEncoding:NSUTF8StringEncoding] objectFromJSONData];
        NSLog(@"%@",dic);
        __block NSString *shareContent = @"";
        __block NSString *platform = nil;
        __block NSString *shareTitle = @"";
        UIImage *shareImage = nil;
        NSString *content = [dic objectForKey:@"shareContent"];
        NSString *url = [dic objectForKey:@"shareUrl"];
        shareContent = [NSString stringWithFormat:@"%@   %@",content,url];
        shareTitle = [dic objectForKey:@"shareTitle"];
        BlockActionSheet *sheet = [BlockActionSheet sheetWithTitle:@"分享到"];
        // 短信
        [sheet addButtonWithTitle:@"短信" imageName:@"message_icon.png" block:^{
            platform = UMShareToSms;

            [self shareTo:platform content:shareContent title:shareTitle image:shareImage shareUrl:url];
        }];
        
        // 微信好友
        [sheet addButtonWithTitle:@"微信好友" imageName:@"wechat_icon.png" block:^{

            platform = UMShareToWechatSession;
            [self shareTo:platform content:content title:shareTitle image:shareImage shareUrl:url];
        }];
        
        // 微信朋友圈
        [sheet addButtonWithTitle:@"微信朋友圈" imageName:@"wechat_favirate_icon.png" block:^{
            platform = UMShareToWechatTimeline;
            [self shareTo:platform content:content title:shareTitle image:shareImage shareUrl:url];
        }];
        
        // 新浪微博
        [sheet addButtonWithTitle:@"新浪微博" imageName:@"sina_icon.png" block:^{
            platform = UMShareToSina;
            [self shareTo:platform content:content title:shareTitle image:shareImage shareUrl:url];
        }];
        
        // QQ
        [sheet addButtonWithTitle:@"QQ" imageName:@"qq_icon.png" block:^{
            platform = UMShareToQQ;
            [self shareTo:platform content:content title:shareTitle image:shareImage shareUrl:url];
        }];
        
        [sheet setDestructiveButtonWithTitle:@"取消" block:^{
            
        }];
        
        [sheet showInView:webView];

        return NO;
    }
    
    
    
    BOOL ret = YES;
    if ([_webViewProxyDelegate respondsToSelector:@selector(webView:shouldStartLoadWithRequest:navigationType:)]) {
        ret = [_webViewProxyDelegate webView:webView shouldStartLoadWithRequest:request navigationType:navigationType];
    }
    
    if ([request.URL.absoluteString isEqualToString:completeRPCURL]) {
        [self completeProgress];
        return NO;
    }
    
    BOOL isFragmentJump = NO;
    if (request.URL.fragment) {
        NSString *nonFragmentURL = [request.URL.absoluteString stringByReplacingOccurrencesOfString:[@"#" stringByAppendingString:request.URL.fragment] withString:@""];
        isFragmentJump = [nonFragmentURL isEqualToString:webView.request.URL.absoluteString];
    }

    BOOL isTopLevelNavigation = [request.mainDocumentURL isEqual:request.URL];

    BOOL isHTTP = [request.URL.scheme isEqualToString:@"http"] || [request.URL.scheme isEqualToString:@"https"];
    if (ret && !isFragmentJump && isHTTP && isTopLevelNavigation && navigationType != UIWebViewNavigationTypeBackForward) {
        _currentURL = request.URL;
        [self reset];
    }
    return ret;
}
- (void)shareTo:(NSString *)platform
        content:(NSString *)content
          title:(NSString *)title
          image:(UIImage *)image
       shareUrl:(NSString *)shareUrl
{
    
    
    
//    [QMUMTookKitManager shareTo:platform title:title content:content image:image presentedController:self.currentController completion:^(UMSocialResponseEntity *response) {
//        // 提示用户分享成功
//    }];
    [QMUMTookKitManager shareTo:platform title:title content:content image:image shareUrl:shareUrl presentedController:self.currentController completion:^(UMSocialResponseEntity *response) {
        
    }];
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    if ([_webViewProxyDelegate respondsToSelector:@selector(webViewDidStartLoad:)]) {
        [_webViewProxyDelegate webViewDidStartLoad:webView];
    }

    _loadingCount++;
    _maxLoadCount = fmax(_maxLoadCount, _loadingCount);
    webView.scrollView.delegate = self;
    _webviewP = webView;
    [self startProgress];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (_scrollviewcontentoffsetY == 0 && scrollView.contentOffset.y < -50) {
        [_webViewProxyDelegate webViewDidStartLoad:_webviewP];
        _scrollviewcontentoffsetY = -1;
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    _scrollviewcontentoffsetY = scrollView.contentOffset.y;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{

    NSLog(@"UserAgent = %@", [webView stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"]);
    
    if ([_webViewProxyDelegate respondsToSelector:@selector(webViewDidFinishLoad:)]) {
        [_webViewProxyDelegate webViewDidFinishLoad:webView];
    }
    
    _loadingCount--;
    [self incrementProgress];
    
    NSString *readyState = [webView stringByEvaluatingJavaScriptFromString:@"document.readyState"];

    BOOL interactive = [readyState isEqualToString:@"interactive"];
    if (interactive) {
        _interactive = YES;
        NSString *waitForCompleteJS = [NSString stringWithFormat:@"window.addEventListener('load',function() { var iframe = document.createElement('iframe'); iframe.style.display = 'none'; iframe.src = '%@'; document.body.appendChild(iframe);  }, false);", completeRPCURL];
        [webView stringByEvaluatingJavaScriptFromString:waitForCompleteJS];
    }
    
    BOOL isNotRedirect = _currentURL && [_currentURL isEqual:webView.request.mainDocumentURL];
    BOOL complete = [readyState isEqualToString:@"complete"];
    if (complete && isNotRedirect) {
        [self completeProgress];
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    if ([_webViewProxyDelegate respondsToSelector:@selector(webView:didFailLoadWithError:)]) {
        [_webViewProxyDelegate webView:webView didFailLoadWithError:error];
    }
    
    _loadingCount--;
    [self incrementProgress];

    NSString *readyState = [webView stringByEvaluatingJavaScriptFromString:@"document.readyState"];

    BOOL interactive = [readyState isEqualToString:@"interactive"];
    if (interactive) {
        _interactive = YES;
        NSString *waitForCompleteJS = [NSString stringWithFormat:@"window.addEventListener('load',function() { var iframe = document.createElement('iframe'); iframe.style.display = 'none'; iframe.src = '%@'; document.body.appendChild(iframe);  }, false);", completeRPCURL];
        [webView stringByEvaluatingJavaScriptFromString:waitForCompleteJS];
    }
    
    BOOL isNotRedirect = _currentURL && [_currentURL isEqual:webView.request.mainDocumentURL];
    BOOL complete = [readyState isEqualToString:@"complete"];
    if (complete && isNotRedirect) {
        [self completeProgress];
    }
}

#pragma mark - 
#pragma mark Method Forwarding
// for future UIWebViewDelegate impl

- (NSMethodSignature *)methodSignatureForSelector:(SEL)selector
{
    NSMethodSignature *signature = [super methodSignatureForSelector:selector];
    if(!signature) {
        if([_webViewProxyDelegate respondsToSelector:selector]) {
            return [(NSObject *)_webViewProxyDelegate methodSignatureForSelector:selector];
        }
    }
    return signature;
}

- (void)forwardInvocation:(NSInvocation*)invocation
{
    if ([_webViewProxyDelegate respondsToSelector:[invocation selector]]) {
        [invocation invokeWithTarget:_webViewProxyDelegate];
    }
}



@end
