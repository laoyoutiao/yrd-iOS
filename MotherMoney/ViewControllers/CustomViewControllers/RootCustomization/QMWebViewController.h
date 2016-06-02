//
//  QMWebViewController.h
//  MotherMoney
//
//

#import "QMViewController.h"
#import "NJKWebViewProgress.h"
@interface QMWebViewController : QMViewController
@property (nonatomic, strong) NSURLRequest *request;
@property (nonatomic, strong) NSString *navTitle;
@property (nonatomic, assign) BOOL isModel;
@property (nonatomic, strong) NSString *content;

+ (void)showWebViewWithRequest:(NSURLRequest *)request navTitle:(NSString *)title isModel:(BOOL)isModel from:(UIViewController *)controller;

+ (void)showWebViewWithContent:(NSString *)content navTitle:(NSString *)title isModel:(BOOL)isModel from:(UIViewController *)controller;

@end
