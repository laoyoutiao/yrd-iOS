//
//  QMMyFundGoodListHeaderView.h
//  MotherMoney
//
//  Created by liuyanfang on 15/8/12.
//  Copyright (c) 2015年 liuyanfang. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface QMMyFundGoodListHeaderView : UICollectionReusableView

@property (nonatomic,strong)UITapGestureRecognizer* tapGes;
-(void)configCurrentScoreValue:(NSString*)currentScoreValue :(NSString *)currentWillTimeOutScoreValue :(NSString *)willEndTime;

@end
