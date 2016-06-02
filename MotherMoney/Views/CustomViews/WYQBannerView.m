//
//  WYQBannerView.m
//  WYQBannerVew
//

#import "WYQBannerView.h"
#import "UIImageView+AFNetworking.h"
#import <AdSupport/AdSupport.h>
#import "QFHttpDownload.h"
@implementation WYQBannerView
{
    UIImageView     *_imageView;  //广告条
    UIButton        *_button;     //关闭广告条按钮
    NSDictionary    *_dataDict;   //存储数据字典
}

- (id)initWithFrame:(CGRect)frame 
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.clipsToBounds = YES;
        _dataDict = [[NSDictionary alloc] init];
        [self addBannerView];
}
    return self;
}
- (NSString *)publisherId
{
    return  @"fcbd900b";
}

#pragma mark - BannerView
- (void)addBannerView
{

}

#pragma mark -点击广告条

- (void)didAdImpressed{
    
    NSLog(@"didadImpressed");
}
#pragma mark - 广告关闭


@end
