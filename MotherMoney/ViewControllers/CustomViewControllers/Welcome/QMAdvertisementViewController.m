//
//  QMAdvertisementViewController.m
//  MotherMoney
//
//  Created by cgt cgt on 2017/9/25.
//  Copyright © 2017年 cgt cgt. All rights reserved.
//

#import "QMAdvertisementViewController.h"
#import "QMAdvertisementModel.h"
#import "QMFrameUtil.h"
#import "QMWebViewAdvertisementViewController.h"

@interface QMAdvertisementViewController ()<UITabBarControllerDelegate>
{
    NSString *advertUrlString;
    UIImageView *advinimageview;
    UIView *backgroundView;
    UIButton *passbutton;
    NSTimer *distimer;
}
@end

@implementation QMAdvertisementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self postAdvertisementInterface];
    [self showAdvertisementPicture:[UIImage imageNamed:@"启动页"]];
    // Do any additional setup after loading the view.
}

//请求广告接口
- (void)postAdvertisementInterface
{
    NSString *mobile =[NSString stringWithFormat:kAdvertisement];
    NSString *base_string = [NSString stringWithFormat:@"%@",URL_BASE];
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",base_string,mobile];
    AFHTTPClient *httpClient = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:base_string]];
    __weak __typeof(self) bself = self;
    [httpClient xsPostPath:urlString delegate:self params:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = (NSDictionary *)[responseObject objectFromJSONData];
        NSLog(@"%@",dic);
        NSArray *advertArray = [QMAdvertisementModel instanceArrayDictFromArray:[[dic objectForKey:@"data"] objectForKey:@"list"]];;
        [bself getPictures:advertArray];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [bself getPictures:nil];
    }];
    
}

//加载广告图片
- (void)downAdvertisementPicture:(NSArray *)advertArray
{
    for (int i = 0; i < [advertArray count]; i ++) {
        
        QMAdvertisementModel *model = [advertArray objectAtIndex:i];
        NSURL *url = [NSURL URLWithString:model.AdverHomePath];
        NSData *data = [[NSData alloc]initWithContentsOfURL:url];
        UIImage *image = [[UIImage alloc]initWithData:data];
        
        if (i == 0 && [QMFrameUtil hasShownWelcomPage])
        {
            [self showAdvertisementPicture:image];
            advertUrlString = model.AdverUrl;
        }
        
        if (data != nil) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSFileManager *fileManager = [NSFileManager defaultManager];
                NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
                NSString *documentsDirectory = [paths objectAtIndex:0];
                NSString *myDirectory = [documentsDirectory stringByAppendingPathComponent:@"test"];
                NSString *filePath = [myDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%ld",model.AdverID]];
                NSLog(@"documentsDirectory --- %@",filePath);
                [UIImagePNGRepresentation(image)writeToFile:filePath atomically:YES];
                [fileManager createDirectoryAtPath:myDirectory withIntermediateDirectories:YES attributes:nil error:nil];
            });
        }
    }
}

//取出沙盒的图片
-(void)getPictures:(NSArray *)advertArray
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSFileManager *fileManage = [NSFileManager defaultManager];
    NSString *myDirectory = [documentsDirectory stringByAppendingPathComponent:@"test"];
    NSArray *file = [fileManage subpathsOfDirectoryAtPath: myDirectory error:nil];
    
    NSMutableArray *pictureArray = [NSMutableArray array];
    
    BOOL havePicture = NO;
    for (int i = 0;i < [file count];i ++) {
        for (int m = 0;m < [advertArray count]; m ++)
        {
            QMAdvertisementModel *model = [advertArray objectAtIndex:m];
            if ([[file objectAtIndex:i] isEqualToString:[NSString stringWithFormat:@"%ld",model.AdverID]]) {
                [pictureArray addObject:[file objectAtIndex:i]];
            }
        }
    }
    
    if ([pictureArray count] == [advertArray count] && [pictureArray count] != 0) {
        havePicture = YES;
    }
    
    if (!havePicture) {
        [self downAdvertisementPicture:advertArray];
        //        [self updataView];
    }else
    {
        NSInteger randnum = arc4random() % [pictureArray count];
        NSString *idstr = [pictureArray objectAtIndex:!([pictureArray count] - 1)? 0:(randnum > 0? randnum:0)];
        NSString *fullPath = [[documentsDirectory stringByAppendingPathComponent:@"test"] stringByAppendingPathComponent:idstr];
        UIImage *savedImage = [[UIImage alloc] initWithContentsOfFile:fullPath];
        [self showAdvertisementPicture:savedImage];
        
        for (int n = 0;n < [advertArray count]; n ++)
        {
            QMAdvertisementModel *model = [advertArray objectAtIndex:n];
            if ([idstr isEqualToString:[NSString stringWithFormat:@"%ld",model.AdverID]])
            {
                advertUrlString = model.AdverUrl;
            }
        }
    }
}

//显示广告页
- (void)showAdvertisementPicture:(UIImage *)advinimage
{
    if (!advinimage)
    {
        return;
    }
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, window.frame.size.width, window.frame.size.height)];
    backgroundView.alpha = 0.5;
    backgroundView.backgroundColor = [UIColor blackColor];
    [window addSubview:backgroundView];
    
    advinimageview = [[UIImageView alloc] initWithFrame:window.frame];
    [advinimageview setImage:advinimage];
    advinimageview.center = CGPointMake(window.frame.size.width / 2, window.frame.size.height / 2);
    advinimageview.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickAdvertisement)];
    [advinimageview addGestureRecognizer:tapGestureRecognizer];
    [window addSubview:advinimageview];
    
    passbutton = [[UIButton alloc] initWithFrame:CGRectMake(window.frame.size.width - 70, 30, 60, 30)];
    passbutton.backgroundColor = [UIColor grayColor];
    [passbutton setTitle:@"跳过" forState:UIControlStateNormal];
    [passbutton setTintColor:[UIColor whiteColor]];
    [passbutton addTarget:self action:@selector(dismissAdvin) forControlEvents:UIControlEventTouchUpInside];
    passbutton.layer.cornerRadius = passbutton.frame.size.height / 2;
    passbutton.titleLabel.font = [UIFont systemFontOfSize:15];
    passbutton.alpha = 0.8;
    [window addSubview:passbutton];
    
    distimer = [NSTimer scheduledTimerWithTimeInterval:3.05 target:self selector:@selector(dismissAdvin) userInfo:nil repeats:NO];
}

- (void)clickAdvertisement
{
    advinimageview.userInteractionEnabled = NO;
    
    QMWebViewAdvertisementViewController *advertwebview = [[QMWebViewAdvertisementViewController alloc] init];
    advertwebview.advertUrlString = advertUrlString;
    [advertwebview setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:advertwebview animated:YES];
    
    [QMWebViewController showWebViewWithRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:advertUrlString]] navTitle:nil isModel:YES from:self];
    
    
    [passbutton removeFromSuperview];
    [backgroundView removeFromSuperview];
    [self close];
}

- (void)dismissAdvin
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [passbutton removeFromSuperview];
    [backgroundView removeFromSuperview];
    [UIView beginAnimations:@"Curl"context:nil];//动画开始
    [UIView setAnimationDuration:1];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(close)];
    advinimageview.bounds = CGRectMake(0, 0, window.frame.size.width / 2 * 3, window.frame.size.height / 2 * 3);
    advinimageview.center = window.center;
    advinimageview.alpha = 0;
    [UIView commitAnimations];
}

- (void)close
{
    [advinimageview removeFromSuperview];
    [distimer invalidate];
//    QMTabBarController *tabbarController = [QMTabBarConfigure configuredTabBarController];
//    tabbarController.delegate = self;
//    _tab = [QMTabBarConfigure configuredTabBarController];
    [self dismissViewControllerAnimated:YES completion:nil];
//    [self showViewController:tabbarController sender:nil];
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    
    //    if (viewController == [[tabBarController viewControllers] objectAtIndex:2] && ![[QMAccountUtil sharedInstance] userHasLogin]) {
    //        [QMLoginManagerUtil showLoginViewControllerFromViewController:tabBarController.selectedViewController];
    //        return NO;
    //    }
    
    return YES;
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
