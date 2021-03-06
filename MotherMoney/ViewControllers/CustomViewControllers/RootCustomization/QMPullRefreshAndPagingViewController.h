//
//  QMPullRefreshAndPagingViewController.h
//  MotherMoney
//
//

#import "QMViewController.h"
#import "EGORefreshTableHeaderView.h"
#import "QMPageFooterView.h"

@interface QMPullRefreshAndPagingViewController : QMViewController<EGORefreshTableHeaderDelegate> {
    EGORefreshTableHeaderView *mRefreshHeaderView;
    QMPageFooterView *footView;
    UIScrollView *mScrollView;
    BOOL mIsLoading; // 正在下拉刷新或正在分页
    QMPageFootViewState footerLoadingState;
}
@property (nonatomic, strong) UIScrollView *scrollView;

- (UIScrollView *)customScrollView;
- (void)reloadData;
- (void)doneLoadingTableViewData;

- (void)didTriggerLoadNextPageData;

- (BOOL)isAllDataLoaded;

@end

