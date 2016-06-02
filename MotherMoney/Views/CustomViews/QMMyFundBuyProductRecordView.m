//
//  QMMyFundBuyProductRecordView.m
//  MotherMoney
//
//  Created by liuyanfang on 15/8/18.
//  Copyright (c) 2015年 liuyanfang. All rights reserved.
//

#import "QMMyFundBuyProductRecordView.h"
#import "QMWebViewController3.h"
@class QMProductInfoViewController;
#define FONTCOLOR [UIColor colorWithRed:69.0f/255.0f green:69.0f/255.0f blue:69.0f/255.0f alpha:1]
@implementation QMMyFundBuyProductRecordView
{
    UILabel* buyTimeLabel;
    UILabel* buyTimeValueLabel;
    UILabel*endTimeLabel;
    UILabel* endTimeValueLabel;
    UILabel* pricipalLabel;
    UILabel* pricipalValueLabel;
    UILabel* earningLabel;
    UILabel* earningValueLabel;
    UILabel* statusLabel;
    UILabel* statusValueLabel;
    UIButton* templateBtn;
    QMBuyedProductResolveModel* resolveModel;
    
}
@synthesize principalLabel=pricipalLabel;
@synthesize principalValueLabel=pricipalValueLabel;
@synthesize buyTimeLabel=buyTimeLabel;
@synthesize buyTimeValueLabel=buyTimeValueLabel;
@synthesize endTimeLabel=endTimeLabel;
@synthesize endTimeValueLabel=endTimeValueLabel;
@synthesize earningLabel=earningLabel;
@synthesize earningValueLabel=earningValueLabel;
@synthesize statusLabel=statusLabel;
@synthesize statusValueLabel=statusValueLabel;
@synthesize templateBtn=templateBtn;
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame]) {
        float width=(frame.size.width-10*2)/2;
        //购买时间
        buyTimeLabel=[[UILabel alloc] initWithFrame:CGRectMake(10, 0, width, 29)];
        buyTimeLabel.text=@"购买时间";
        buyTimeLabel.textColor=FONTCOLOR;
        buyTimeLabel.textAlignment=NSTextAlignmentLeft;
        buyTimeLabel.font=[UIFont systemFontOfSize:11];
        [self addSubview:buyTimeLabel];
        
        buyTimeValueLabel=[[UILabel alloc] initWithFrame:CGRectMake(width+10, 0,width, 29)];
        buyTimeValueLabel.textAlignment=NSTextAlignmentRight;
        buyTimeValueLabel.font=[UIFont systemFontOfSize:11];
        buyTimeValueLabel.textColor=FONTCOLOR;
        [self addSubview:buyTimeValueLabel];
        UIImageView* horizontalView1=[[UIImageView alloc] initWithImage:[QMImageFactory commonHorizontalLineImage]];
        horizontalView1.frame=CGRectMake(10, 29, frame.size.width-10*2, 1);
        [self addSubview:horizontalView1];
        
        //结束时间
        endTimeLabel=[[UILabel alloc] initWithFrame:CGRectMake(10, 30, width, 29)];
        endTimeLabel.textColor=FONTCOLOR;
        endTimeLabel.text=@"结束时间";
        endTimeLabel.textAlignment=NSTextAlignmentLeft;
        endTimeLabel.font=[UIFont systemFontOfSize:11];
        [self addSubview:endTimeLabel];
        
        endTimeValueLabel=[[UILabel alloc] initWithFrame:CGRectMake(width+10, 30,width , 29)];
        endTimeValueLabel.textAlignment=NSTextAlignmentRight;
        endTimeValueLabel.textColor=FONTCOLOR;
        endTimeValueLabel.font=[UIFont systemFontOfSize:11];
        [self addSubview:endTimeValueLabel];
        
        UIImageView* horizontalView2=[[UIImageView alloc] initWithImage:[QMImageFactory commonHorizontalLineImage]];
        horizontalView2.frame=CGRectMake(10, 59, frame.size.width-2*10, 1);
        [self addSubview:horizontalView2];
        
        //本金
        pricipalLabel=[[UILabel alloc] initWithFrame:CGRectMake(10, 60, width, 29)];
        pricipalLabel.textColor=FONTCOLOR;
        pricipalLabel.textAlignment=NSTextAlignmentLeft;
        pricipalLabel.text=@"本金（元）";
        pricipalLabel.font=[UIFont systemFontOfSize:11];
        [self addSubview:pricipalLabel];
        pricipalValueLabel=[[UILabel alloc] initWithFrame:CGRectMake(width+10, 60, width, 29)];
        pricipalValueLabel.textAlignment=NSTextAlignmentRight;
        pricipalValueLabel.textColor=FONTCOLOR;
        pricipalValueLabel.font=[UIFont systemFontOfSize:11];
        [self addSubview:pricipalValueLabel];
        UIImageView* horizontalView3=[[UIImageView alloc] initWithImage:[QMImageFactory commonHorizontalLineImage]];
        horizontalView3.frame=CGRectMake(10,89, frame.size.width-2*10, 1);
        [self addSubview:horizontalView3];
        
        //收益
        earningLabel=[[UILabel alloc] initWithFrame:CGRectMake(10, 90, width, 29)];
        earningLabel.textColor=FONTCOLOR;
        earningLabel.text=@"收益（元）";
        earningLabel.textAlignment=NSTextAlignmentLeft;
        earningLabel.font=[UIFont systemFontOfSize:11];
        [self addSubview:earningLabel];
        earningValueLabel=[[UILabel alloc] initWithFrame:CGRectMake(width+10, 90, width, 29)];
        earningValueLabel.textAlignment=NSTextAlignmentRight;
        earningValueLabel.font=[UIFont systemFontOfSize:11];
        earningValueLabel.textColor=FONTCOLOR;
        [self addSubview:earningValueLabel];
        UIImageView* horizontalView4=[[UIImageView alloc] initWithImage:[QMImageFactory commonHorizontalLineImage]];
        horizontalView4.frame=CGRectMake(10, 119, frame.size.width-2*10, 1);
        [self addSubview:horizontalView4];
        
        //状态
        statusLabel=[[UILabel alloc] initWithFrame:CGRectMake(10, 120, width, 29)];
        statusLabel.textColor=FONTCOLOR;
        statusLabel.text=@"状态";
        statusLabel.font=[UIFont systemFontOfSize:11];
        statusValueLabel.textAlignment=NSTextAlignmentLeft;
        [self addSubview:statusLabel];
        
        statusValueLabel=[[UILabel alloc] initWithFrame:CGRectMake(width+10, 120, width, 29)];
        statusValueLabel.textAlignment=NSTextAlignmentRight;
        statusValueLabel.font=[UIFont systemFontOfSize:11];
        [self addSubview:statusValueLabel];
        UIImageView* horizontalView5=[[UIImageView alloc] initWithImage:[QMImageFactory commonHorizontalLineImage]];
        horizontalView5.frame=CGRectMake(10,149, frame.size.width-2*10, 1);
        [self addSubview:horizontalView5];
        
        templateBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        templateBtn.titleLabel.font=[UIFont systemFontOfSize:11];
        templateBtn.frame=CGRectMake(30, 160, frame.size.width-60, 20);
        [self addSubview:templateBtn];
    }
    return self;
}
-(void)configureView:(QMBuyedProductResolveModel *)model
{
    resolveModel=[[QMBuyedProductResolveModel alloc] init];
    resolveModel=model;
    if (!QM_IS_STR_NIL(model.buyTime)) {
        buyTimeValueLabel.text=model.buyTime;
    }
    else{
        buyTimeValueLabel.text=@"";
    }
    if (!QM_IS_STR_NIL(model.totalBuyAmount)) {
        earningValueLabel.text=model.totalEarnings;
    }else
    {
        earningValueLabel.text=@"";
    }
    if (!QM_IS_STR_NIL(model.totalEarnings)) {
        pricipalValueLabel.text=model.totalBuyAmount;
        
    }else
    {
        pricipalValueLabel.text=@"";
    }
    if (!QM_IS_STR_NIL(model.status)) {
        statusValueLabel.text=model.status;
    }
    else
    {
        statusValueLabel.text=@"";
    }
    if ([self productBuyPromptString:model]) {
        [templateBtn setTitle:[self productBuyPromptString:model] forState:UIControlStateNormal];
        
        
            [templateBtn addTarget:self action:@selector(templateBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
}
-(void)configureCurrentViewController:(UIViewController *)controller
{
    self.controller=controller;
}
-(void)templateBtnClick
{
    
    if (resolveModel.isSuccess) {
        [[NetServiceManager sharedInstance] getBuyedProductAgreementTemplateWithAccountId:resolveModel.resolveModelId
                                                                                 delegate:self
                                                                                  success:^(id responseObject) {
                                                                                      if ([responseObject isKindOfClass:[NSDictionary class]]) {
                                                                                          NSDictionary *template = [responseObject objectForKey:@"agreementTemplate"];
                                                                                          
                                                                                          NSString *agreementContent = [template objectForKey:@"agreementContent"];
                                                                                          
                                                                                          [QMWebViewController3 showWebViewWithContent:agreementContent
                                                                                                                             navTitle:QMLocalizedString(@"qm_buyed_product_contract_template", @"合同")
                                                                                                                              isModel:YES
                                                                                                                                 from:self.controller];
                                                                                      }
                                                                                  } failure:^(NSError *error) {
                                                                                      [CMMUtility showNoteWithError:error];
                                                                                  }];
    }else {
        [CMMUtility showNote:resolveModel.errorMsg];
    }

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

@end
