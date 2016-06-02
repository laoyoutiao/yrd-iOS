//
//  QMMyProductBuyRecordCell.m
//  MotherMoney
//

#import "QMMyProductBuyRecordCell.h"
#import "QMBankInfoView.h"
#import "QMMyFundBuyProductRecordView.h"


@implementation QMMyProductBuyRecordCell
{
    UIScrollView* scrollView;
    UIPageControl* pageControl;
    
}

@synthesize scrollView=scrollView;
@synthesize pageControl=pageControl;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {

       
        self.layer.cornerRadius=5.0f;
        self.layer.masksToBounds=YES;
        self.backgroundColor=[UIColor whiteColor];
        scrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height-20)];
        scrollView.backgroundColor=[UIColor orangeColor];
        scrollView.pagingEnabled=YES;
        scrollView.showsHorizontalScrollIndicator=NO;
    
        [self addSubview:scrollView];
        pageControl=[[UIPageControl alloc] initWithFrame:CGRectMake(20, frame.size.height-20, frame.size.width, 20)];
        pageControl.currentPageIndicatorTintColor = [UIColor redColor];
        pageControl.pageIndicatorTintColor = QM_COMMON_BACKGROUND_COLOR;
        
        [self addSubview:pageControl];
        
    
    }
    return self;
}

-(void)configureBuyedProductResolves:(NSArray *)productResolves
{
    self.productResolves=productResolves;
    [scrollView setContentSize:CGSizeMake(self.productResolves.count*self.frame.size.width, self.frame.size.height-20)];
    NSLog(@"%f",self.frame.size.height);
    float width=scrollView.frame.size.width;
    float height=scrollView.frame.size.height;
    for (int i=0;i<self.productResolves.count; i++) {
        QMMyFundBuyProductRecordView* recordView=[[QMMyFundBuyProductRecordView alloc] initWithFrame:CGRectMake(i*width, 0,width, height)];
        QMBuyedProductResolveModel* model=self.productResolves[i];
        [recordView configureView:model];
        [recordView configureCurrentViewController:self.controller];
        [scrollView addSubview:recordView];
    }
    pageControl.numberOfPages=self.productResolves.count;
    

}
-(void)configureCurrentController:(UIViewController *)controller
{
    self.controller=controller;
}
- (NSString *)productBuyPromptString:(QMBuyedProductResolveModel *)model {
    BOOL success = [[self class] isProductBuyRecordSuccessful:model];
    
    if (success) {
        return QMLocalizedString(@"qm_product_buy_status_success", @"点击查看购买合同");
    }else {
        return QMLocalizedString(@"qm_product_buy_status_failure", @"点击查看订单失败原因");
    }
}

+ (BOOL)isProductBuyRecordSuccessful:(QMBuyedProductResolveModel *)model {
//    NSArray *successStatus = [NSArray arrayWithObjects:@"已投标", @"已赎回", @"已提现", @"回款中", @"等待银行处理", nil];
//    
//    NSString *status = model.status;
//    
//    if (!QM_IS_STR_NIL(status)) {
//        return [successStatus containsObject:status];
//    }
//    
//    return NO;
    
    return model.isSuccess;
}


+ (CGFloat)getCellHeightForProductInfo:(QMBuyedProductResolveModel *)info {
    return 200.0f;
}
-(void)scrollViewDidScroll:(UIScrollView*)scrollView
{
    
}
@end

