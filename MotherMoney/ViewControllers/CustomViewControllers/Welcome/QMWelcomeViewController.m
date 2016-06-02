//
//  QMWelcomeViewController.m
//  MotherMoney

#import "QMWelcomeViewController.h"
#import "QMDeviceUtil.h"
#import "QMFrameUtil.h"
#import "AppDelegate.h"

@interface QMWelcomeViewController ()<UIScrollViewDelegate>

@end

@implementation QMWelcomeViewController
@synthesize scrollView;
@synthesize control;

-(id)initWithStart:(BOOL) show {
    if (self = [super init]) {
        showStart = show;
    }
    return self;
}

- (NSArray *)welcomeImages {
    
    //同样的图片
    return [NSArray arrayWithObjects:@"welcome_page_1.png", @"welcome_page_2.png", @"welcome_page_3.png", nil];
//    if ([QMDeviceUtil is4Inch]) { // iPhone 5
//        return [NSArray arrayWithObjects:@"welcome_page_1.png", @"welcome_page_2.png", @"welcome_page_3.png", @"welcome_page_4.png", nil];
//    }else { // iPhone 4
//        return [NSArray arrayWithObjects:@"welcome_page_1.png", @"welcome_page_2.png", @"welcome_page_3.png", @"welcome_page_4.png", nil];
//    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView1 {
    CGPoint offset = scrollView1.contentOffset;
    NSInteger page = offset.x / CGRectGetWidth(scrollView.frame);
    control.currentPage = page;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSArray *imagesArray = [self welcomeImages];
    
    scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    scrollView.delegate = self;
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.bounces = NO;
    scrollView.contentSize = CGSizeMake(CGRectGetWidth([UIScreen mainScreen].bounds) * [imagesArray count], CGRectGetHeight([UIScreen mainScreen].bounds));
    [self.view addSubview:scrollView];
    
    CGFloat kDeviceWidth = CGRectGetWidth(self.view.frame);
    
    for (int i =0 ; i < imagesArray.count; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i*kDeviceWidth, 0, kDeviceWidth, CGRectGetHeight(self.view.frame))];
        NSString *imageName = [imagesArray objectAtIndex:i];
        UIImage *image1 = [UIImage imageNamed:imageName];
        imageView.image = image1;
        [scrollView addSubview:imageView];
    }
    
    scrollView.contentSize=CGSizeMake(imagesArray.count*kDeviceWidth, scrollView.bounds.size.height);
    if (showStart) {
        UIButton *startBtn = [QMControlFactory commonBorderedButtonWithSize:CGSizeMake(CGRectGetWidth(self.view.frame) - 2 * 20, 40) title:QMLocalizedString(@"qm_first_welcom_btn_title", @"开始使用") target:self selector:@selector(start)];
        CGRect frame = startBtn.frame;
        frame.origin = CGPointMake(20, CGRectGetHeight(self.view.frame) - 25 - 40);
        startBtn.frame = frame;
        startBtn.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        
        [self.view addSubview:startBtn];
    }else {
        UIButton *startBtn = [QMControlFactory commonBorderedButtonWithSize:CGSizeMake(CGRectGetWidth(self.view.frame) - 2 * 20, 40) title:QMLocalizedString(@"qm_review_welcome_btn_title", @"关闭") target:self selector:@selector(start)];
        CGRect frame = startBtn.frame;
        frame.origin = CGPointMake(20, CGRectGetHeight(self.view.frame) - 25 - 40);
        startBtn.frame = frame;
        startBtn.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        
        [self.view addSubview:startBtn];
    }
    
    // 添加pageControl
    control = [[UIPageControl alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.frame) - 100, CGRectGetWidth(self.view.frame), 10)];
    control.numberOfPages = [imagesArray count];
    [control addTarget:self action:@selector(pageChange:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:control];
}

-(void)pageChange:(UIPageControl*)pageControl
{
    
    
    CGFloat offsetX = pageControl.currentPage * self.scrollView.bounds.size.width;
    
    [scrollView setContentOffset:CGPointMake(offsetX, 0) animated:YES];

    
    
}
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

-(void)start {
    [self dismissViewControllerAnimated:YES completion:nil];
    [QMFrameUtil setHasShownWelcomepage];
//    if (showStart) { // 第一次显示，需要进入登录页面
//        UIViewController *firstViewController = [((UITabBarController *)[AppDelegate appDelegate].window.rootViewController).viewControllers firstObject];
//        [QMLoginManagerUtil showLoginViewControllerFromViewController:firstViewController];
//    }
}
#pragma xiugai

-(void)navBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

@end
