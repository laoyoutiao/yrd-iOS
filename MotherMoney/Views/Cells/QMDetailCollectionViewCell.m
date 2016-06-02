//
//  QMDetailCollectionViewCell.m
//  MotherMoney
//
//  Created by liuyanfang on 15/8/19.
//  Copyright (c) 2015年 liuyanfang. All rights reserved.
//

#import "QMDetailCollectionViewCell.h"
#import "NetServiceManager.h"
#import "QMCoreMacros.h"
//活动名称
#define ACTIONTITLECOLOR [UIColor colorWithRed:112.0f/255.0f green:112.0f/255.0f blue:112.0f/255.0f alpha:1]
//收入图标
#define INIOCONCOLOR [UIColor colorWithRed:88.0f/255.0f green:168.0f/255.0f blue:245.0f/255.0f alpha:1]
//收入图标
#define OUTICONCOLOR [UIColor colorWithRed:243.0f/255.0f green:86.0f/255.0f blue:101.0f/255.0f alpha:1]
//滞留图标
#define STAYICONCOLOR [UIColor colorWithRed:134.0f/255.0f green:134.0f/255.0f blue:134.0f/255.0f alpha:1]
//活动日期
#define DATECOLOR [UIColor colorWithRed:182.0f/255.0f green:182.0f/255.0f blue:182.0f/255.0f alpha:1]
//活动花费
#define OUTNUMBERCOLOR [UIColor colorWithRed:243.0f/255.0f green:103.0f/255.0f blue:116.0f/255.0f alpha:1]
//活动收入
#define INNUMBERCOLOR [UIColor colorWithRed:74.0f/255.0f green:158.0f/255.0f blue:239.0f/255.0f alpha:1]
//活动余额
#define STAYNUMBERCOLOR [UIColor colorWithRed:119.0f/255.0f green:119.0f/255.0f blue:119.0f/255.0f alpha:1]
//活动滞留
#define REMAINCOLOR [UIColor colorWithRed:119.0f/255.0f green:119.0.0f/255.0f blue:119.0.0f/255.0f alpha:1]
//账户余额
#define NEWSTAYNUMBERCOLOR [UIColor colorWithRed:236.0f/255.0f green:71.0.0f/255.0f blue:59.0.0f/255.0f alpha:1]
@implementation QMDetailCollectionViewCell
{
    NSMutableArray *dataList;
}
-(instancetype)initWithFrame:(CGRect)frame
{
    
    if (self=[super initWithFrame:frame]) {
        self.backgroundColor=[UIColor whiteColor];
        float width=(frame.size.width-30)/2;
        //左边小图片
        self.leftIconView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 5, frame.size.height)];
        [self.contentView addSubview:self.leftIconView];
        
        //活动名
        self.actionTitleLabel=[[UILabel alloc] initWithFrame:CGRectMake(20, 5, width, 20)];
        self.actionTitleLabel.font=[UIFont systemFontOfSize:15];
        self.actionTitleLabel.textAlignment=NSTextAlignmentLeft;
        [self.contentView addSubview:self.actionTitleLabel];
        
        self.actionNumberLabel=[[UILabel alloc] initWithFrame:CGRectMake(20+width, 3, width, 25)];
        self.actionNumberLabel.textAlignment=NSTextAlignmentRight;
        self.actionNumberLabel.font=[UIFont systemFontOfSize:16];
        
        [self.contentView addSubview:self.actionNumberLabel];
        
        //日期
        self.dateLabel=[[UILabel alloc] initWithFrame:CGRectMake(20, 25, width,20)];
        self.dateLabel.textAlignment=NSTextAlignmentLeft;
        self.dateLabel.font=[UIFont systemFontOfSize:13];
        [self.contentView addSubview:self.dateLabel];
        
        //剩余钱数
        self.remainingLabel=[[UILabel alloc] initWithFrame:CGRectMake(20+width, 25, width, 20)];
        self.remainingLabel.textAlignment=NSTextAlignmentRight;
        self.remainingLabel.font=[UIFont systemFontOfSize:13];
        [self.contentView addSubview:self.remainingLabel];
        dataList = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)configureDetailCell
{
    //活动类型
    self.actionTitleLabel.text=self.detailCellModel.customerPointTypeName;
    self.actionTitleLabel.textColor =ACTIONTITLECOLOR;
    
    //活动花费
    NSString *amountStr =[CMMUtility formatterNumberWithComma:self.detailCellModel.amount];
    if ([self.detailCellModel.plus intValue]==1) {
        
        
        NSString *str = [NSString stringWithFormat:@"+%@元",amountStr];
        
        self.actionNumberLabel.text = str;
//        self.actionNumberLabel.textColor = OUTNUMBERCOLOR;
//        self.leftIconView.backgroundColor = OUTNUMBERCOLOR;
        
    }else{
        NSString *str = [NSString stringWithFormat:@"-%@元",amountStr];
        
        self.actionNumberLabel.text = str;
//        self.actionNumberLabel.textColor = INNUMBERCOLOR;
//        self.leftIconView.backgroundColor = INIOCONCOLOR;
    }
   
    //活动日期
    self.dateLabel.text=self.detailCellModel.createTime;
    self.dateLabel.textColor = DATECOLOR;
    
    //活动余额
    NSString *str1 = [CMMUtility formatterNumberWithComma:self.detailCellModel.availableAmount];
    NSString *str = [NSString stringWithFormat:@"剩余%@元",str1];
    self.remainingLabel.text=str;
    self.remainingLabel.textColor= [UIColor colorWithRed:119.0f/255.0f green:119.0f/255.0f blue:119.0f/255.0f alpha:1];

    switch ([self.detailCellModel.pointColorType intValue]) {
        case 1:
            self.actionNumberLabel.textColor = OUTNUMBERCOLOR;
            self.leftIconView.backgroundColor = OUTNUMBERCOLOR;
            break;
        case 2:
            self.actionNumberLabel.textColor = INNUMBERCOLOR;
            self.leftIconView.backgroundColor = INIOCONCOLOR;
            break;
            
        default:
            self.actionNumberLabel.textColor = STAYNUMBERCOLOR;
            self.leftIconView.backgroundColor = STAYICONCOLOR;
            break;
    }
  
    
}
- (void)doneLoadingTableViewData{
    
}
+(float)getDetailCellHeight
{
    return 44;
}
@end
