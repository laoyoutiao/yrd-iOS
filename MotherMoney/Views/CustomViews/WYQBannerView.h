//
//  WYQBannerView.h
//  WYQBannerVew
//

#import <UIKit/UIKit.h>
#import "QFHttpDownload.h"
@class WYQBannerView;
@protocol WYQBannerViewDelegate <NSObject>

- (void)bannerDataDidLoadSuccess:(WYQBannerView *)banner;
- (void)bannerDataDidLoadFailed:(WYQBannerView *)banner;
- (void)bannerViewClosed:(WYQBannerView *)banner;

@end

@interface WYQBannerView : UICollectionReusableView
<QFHttpDownloadDelegate>

@property (nonatomic, strong)  NSTimer  *timer;//定时器

@property (nonatomic, assign)id<WYQBannerViewDelegate>delegate;

@end
