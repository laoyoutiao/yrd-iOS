//
//  QMSelectLocationViewControllerV2.h
//  MotherMoney
//
//  Created by 赵国辉 on 15/5/5.
//  Copyright (c) 2015年 赵国辉. All rights reserved.
//

#import "QMSelectItemViewController.h"
//选择省的视图
typedef enum {
    QMSelectLocationTypeV2_Province = 0,
    QMSelectLocationTypeV2_City
}QMSelectLocationTypeV2;

@interface QMSelectLocationViewControllerV2 : QMSelectItemViewController
@property (nonatomic, assign) QMSelectLocationTypeV2 currentType;
@property (nonatomic, strong) NSString *provinceCode;
@property (nonatomic, strong) NSString *provinceName;

- (id)initViewControllerWithType:(QMSelectLocationTypeV2)type;

@end

