//
//  QMMyIntegralExchangeListViewController.h
//  MotherMoney

#import "QMViewController.h"
#import "QMPullRefreshAndPagingViewController.h"
//这个类已废弃请查找 QMMyIntegralExchangeListViewController2
@interface QMMyIntegralExchangeListViewController :QMPullRefreshAndPagingViewController
@property (nonatomic, assign) BOOL isModel;
@property (nonatomic, assign) BOOL isAllDataLoaded;
@end
