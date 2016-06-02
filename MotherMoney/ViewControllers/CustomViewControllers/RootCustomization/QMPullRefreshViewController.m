//
//  QMPullRefreshViewController.m
//  MotherMoney
//
//  Created by   on 14-8-6.
//  Copyright (c) 2014年  . All rights reserved.
//

#import "QMPullRefreshViewController.h"

@interface QMPullRefreshViewController ()

@end

@implementation QMPullRefreshViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.scrollView = [self customScrollView];
    [self.view addSubview:self.scrollView];

    [self setUpRefreshHeaderView];
}

- (void)reloadData {
    
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

- (UIScrollView *)customScrollView {
    if (nil == mScrollView) {
        mScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        mScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    
    return mScrollView;
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
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
	
	[mRefreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	
	[mRefreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
}

#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
	if (mIsLoading) {
        return;
    }
    
    [self reloadData];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
	
	return mIsLoading; // should return if data source model is reloading
	
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
	
	return [NSDate date]; // should return date data source was last changed
	
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
