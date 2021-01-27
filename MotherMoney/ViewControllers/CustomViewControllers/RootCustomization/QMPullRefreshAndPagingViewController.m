//
//  QMPullRefreshAndPagingViewController.m
//  MotherMoney
//

#import "QMPullRefreshAndPagingViewController.h"

@interface QMPullRefreshAndPagingViewController ()

@end

@implementation QMPullRefreshAndPagingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.scrollView = [self customScrollView];
    [self.view addSubview:self.scrollView];
//    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(UIEdgeInsetsZero);
//    }];

    [self.scrollView setFrame:self.view.bounds];
    
    [self setUpRefreshHeaderView];
    [self setUppageFooterView];
}

- (void)productListViewChangeFrame
{
    [self.scrollView setFrame:CGRectMake(self.scrollView.frame.origin.x, self.scrollView.frame.origin.y + 50, self.scrollView.frame.size.width, self.scrollView.frame.size.height - 100)];
    
    self.view.backgroundColor = QM_COMMON_BACKGROUND_COLOR;
    
    productListButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, (self.view.frame.size.width - 25) / 2, 40)];
    productListButton.backgroundColor = QM_COMMON_HEADBUTTON_COLOR;
    [productListButton setTitle:@"投资精选" forState:UIControlStateNormal];
    [productListButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    productListButton.layer.cornerRadius = 3;
    [self.view addSubview:productListButton];
//
    creditorsListBUtton = [[UIButton alloc] initWithFrame:CGRectMake((self.view.frame.size.width + 5) / 2, 10, (self.view.frame.size.width - 25) / 2, 40)];
    creditorsListBUtton.backgroundColor = [UIColor whiteColor];
    [creditorsListBUtton setTitle:@"债权转让" forState:UIControlStateNormal];
    [creditorsListBUtton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    creditorsListBUtton.layer.cornerRadius = 3;
    [self.view addSubview:creditorsListBUtton];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(10, 49, self.view.frame.size.width - 20, 2)];
    line.backgroundColor = QM_COMMON_HEADBUTTON_COLOR;
    [self.view addSubview:line];
}

- (void)setUpRefreshHeaderView {
	if (nil == mRefreshHeaderView) {
		
		mRefreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - CGRectGetHeight([self scrollView].frame), CGRectGetWidth([self scrollView].frame), CGRectGetHeight([self scrollView].frame))];
        mRefreshHeaderView.backgroundColor = QM_COMMON_BACKGROUND_COLOR;
		mRefreshHeaderView.delegate = self;
		[self.scrollView addSubview:mRefreshHeaderView];
	}
	
	//  update the last update date
	[mRefreshHeaderView refreshLastUpdatedDate];
}

- (void)setUppageFooterView {
    if (nil == footView) {
        footView = [[QMPageFooterView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.scrollView.frame) - 40, CGRectGetWidth(self.scrollView.frame), 40.0f)];
        footView.backgroundColor = [UIColor redColor];
        footView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
        footerLoadingState = QMPageFootViewNormalState;
        [footView setQMPageFootViewState:footerLoadingState];
    }
}

- (UIScrollView *)customScrollView {
    if (nil == mScrollView) {
        mScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        mScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    
    return mScrollView;
}

- (void)reloadData {
    
}

#pragma mark -
#pragma mark Data Source Loading / Reloading Methods
- (void)reloadTableViewDataSource{
	//  should be calling your tableviews data source model to reload
	//  put here just for demo
	mIsLoading = YES;
}

- (void)doneLoadingTableViewData{
	
	//  model should call this when its done loading
	mIsLoading = NO;
	[mRefreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.scrollView];
    if ([self isAllDataLoaded]) {
        footerLoadingState = QMPageFootViewNullDataState;
    }else {
        footerLoadingState = QMPageFootViewNormalState;
    }
}

- (BOOL)isAllDataLoaded {
    return NO;
}

- (void)didTriggerLoadNextPageData {
    
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
	[mRefreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if ((scrollView.contentSize.height - scrollView.contentOffset.y < CGRectGetHeight(scrollView.frame)) && !mIsLoading && ![self isAllDataLoaded] && scrollView.contentOffset.y > 0) {
        footerLoadingState = QMPageFootViewLoadingState;
        [footView setQMPageFootViewState:footerLoadingState];
        mIsLoading = YES;
        [self didTriggerLoadNextPageData];
    }
	[mRefreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
}

#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
	if (mIsLoading) {
        return;
    }
    
    mIsLoading = YES;
    
    [self reloadData];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
	
	return mIsLoading; // should return if data source model is reloading
	
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
	
	return [NSDate date]; // should return date data source was last changed
	
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

