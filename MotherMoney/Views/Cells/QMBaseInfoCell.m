//
//  QMBaseInfoCell.m
//  MotherMoney
//
//  Created by liuyanfang on 15/8/11.
//  Copyright (c) 2015年 liuyanfang. All rights reserved.
//

#import "QMBaseInfoCell.h"

@implementation QMBaseInfoCell
{
    UILabel* userInfoTitleLabel;//个人中心标题
    UILabel* dealDeatailTitleLabel;//交易详细标题
    UILabel* investRecordTitleLabel;//投资记录标题
    UILabel* goodListTitleLabel;//我的钱豆标题
    UILabel* rechargeTitleLabel;//充值标题
    UILabel* withDrawTitleLabel;//体现标题
    
    
}
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame]) {

        self.layer.cornerRadius=5;
        self.layer.masksToBounds=YES;
        float width=(CGRectGetWidth(frame)-1)/3.0f;
        NSLog(@"************%f",width);
        //个人中心
        
        

        self.userInfoBtn=[self createBtnWithTitle:@"个人中心" frame:CGRectMake(0,1, width, 88) image:[UIImage imageNamed:@"home_person"]];
        
        
        //交易明细
        self.dealDetailBtn=[self createBtnWithTitle:@"交易明细" frame:CGRectMake(width+0.5,1, width, 88) image:[UIImage imageNamed:@"home_details"]];
        
        
        //投资记录
        self.investRecordBtn=[self createBtnWithTitle:@"投资记录" frame:CGRectMake((width+0.5)*2, 1, width, 88) image:[UIImage imageNamed:@"home_log"]];
        self.investRecordBtn.frame=CGRectMake((width+0.5)*2, 1, width, 88);
        
        //我的钱豆
        self.goodListBtn=[self createBtnWithTitle:@"我的奖励" frame:CGRectMake(0,89.5, width, 88) image:[UIImage imageNamed:@"home_cup"]];
      
        
        //充值
        
        self.rechargeBtn=[self createBtnWithTitle:@"充值" frame:CGRectMake(width+0.5,89.5,width , 88) image:[UIImage imageNamed:@"home_fill"]];
       
        
        //提现
        self.withDrawBtn=[self createBtnWithTitle:@"提现" frame:CGRectMake((width+0.5)*2, 89.5, width, 88) image:[UIImage imageNamed:@"home_bank"]];
        
        
        [self.contentView addSubview:self.userInfoBtn];
        [self.contentView addSubview:self.investRecordBtn];
        [self.contentView addSubview:self.dealDetailBtn];
        [self.contentView addSubview:self.goodListBtn];
        [self.contentView addSubview:self.rechargeBtn];
        [self.contentView addSubview:self.withDrawBtn];
        
    }
    return self;
}
- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}
-(UIButton*)createBtnWithTitle:(NSString*)title frame:(CGRect)frame image:(UIImage*)image
{
    
    UIButton* btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame=frame;
    [btn setBackgroundImage:[self imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [btn setBackgroundImage:[self imageWithColor:[UIColor colorWithRed:240.0f/255.0f green:240.0f/255.0f blue:240.0f/255.0f alpha:1]] forState:UIControlStateHighlighted];
    UILabel* label=[[UILabel alloc] initWithFrame:CGRectMake(0,50,frame.size.width,24)];
    label.text=title;
    label.textAlignment=NSTextAlignmentCenter;
    label.font=[UIFont systemFontOfSize:12];
    [btn addSubview:label];
    [btn setImage:image forState:UIControlStateNormal];
    [btn setImage:image forState:UIControlStateHighlighted];
    
    btn.imageEdgeInsets = UIEdgeInsetsMake(5, 0, 24, 0);
    return btn;
    
    
}
-(void)configureWithFundInfo:(QMMyFundModel *)info
{
    
}
+(CGFloat)getBaseInfoViewHeightForFundInfo:(QMMyFundModel *)info
{
    return 180;
}
@end
