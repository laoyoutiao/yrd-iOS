//
//  QMPersonalCenterViewController.h
//  MotherMoney
//
//  Created by    on 14-8-10.
//  Copyright (c) 2014年   . All rights reserved.
//

#import "QMViewController.h"
//个人信息中心

@interface QMPersonalCenterViewController : QMViewController

@property (nonatomic,strong)NSString* currentAvailabelScore;

- (id)initViewControllerWithAccountInf:(QMAccountInfo *)info;
@end
