//
//  QMProductRecommendGuideView.m
//  MotherMoney
//
//

#import "QMProductRecommendGuideView.h"

@implementation QMProductRecommendGuideView {
    UIImageView *guideImageView;
    UIButton *buyBtn;
}
@synthesize buyBtn = buyBtn;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8f];
        
        buyBtn = [QMControlFactory commonButtonWithSize:CGSizeZero title:QMLocalizedString(@"qm_recommendation_buy_btn_title", @"购买") target:nil selector:nil];
        [self addSubview:buyBtn];
        //iphone4以下版本
        if (CGRectGetHeight([UIScreen mainScreen].bounds) <= 480) {
            [buyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.mas_left).offset(8 + 15);
                make.right.equalTo(self.mas_right).offset(-8 - 15);
                make.top.equalTo(self.mas_top).offset(400.0f);
                make.height.equalTo(40.0f);
            }];
        }else {
            [buyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.mas_left).offset(8 + 15);
                make.right.equalTo(self.mas_right).offset(-8 - 15);
                make.top.equalTo(self.mas_top).offset(455.0f);
                make.height.equalTo(40.0f);
            }];
        }
        
        guideImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        guideImageView.image = [UIImage imageNamed:@"recommend_guide_icon.png"];
        [self addSubview:guideImageView];
        [guideImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(buyBtn.mas_top).offset(-25.0f);
            make.centerX.equalTo(self.mas_centerX);
            make.size.equalTo(CGSizeMake(173, 126));
        }];
        
    }
    
    return self;
}

@end
