//
//  QMAccountOpViewController.m
//  MotherMoney
//
//  Created by 赵国辉 on 15/5/18.
//  Copyright (c) 2015年 赵国辉. All rights reserved.
//

#import "QMAccountOpViewController.h"
#import "QMRechargeRecordListViewController.h"
#import "QMWithDrawRecordListViewController.h"
#import "QMRechargeViewController.h"
#import "QMWithDrawViewController.h"
#import "QMAccountOpHeaderView.h"

#define HAS_ENTERED_OP_VIEW @"HAS_ENTERED_OP_VIEW"

@interface QMAccountOpViewController ()<UITableViewDataSource, UITableViewDelegate>

@end

@implementation QMAccountOpViewController {
    UITableView *mTableView;
    QMAccountOpHeaderView *header;
    BOOL isAllDataLoaded;
    double available;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = QM_COMMON_BACKGROUND_COLOR;
    
    // Do any additional setup after loading the view.
    
    [self setUpSubViews];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self reloadData];
    
    // 提示用户
//    if (![QMPreferenceUtil getGlobalBoolKey:HAS_ENTERED_OP_VIEW]) {
//        [QMPreferenceUtil setGlobalBoolKey:HAS_ENTERED_OP_VIEW value:YES syncWrite:YES];
//        [CMMUtility showNote:@"账户中的余额只能购买产品"];
//    }
}

#pragma mark -
#pragma mark Override mthoeds
- (UIScrollView *)customScrollView {
    mTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    mTableView.delegate = self;
    mTableView.dataSource = self;
    mTableView.sectionFooterHeight = 0;
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"balance_money.jpg"]];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), CGRectGetHeight([UIScreen mainScreen].bounds) - 50 - 64 - 2 * 44 - 100)];
    footer.backgroundColor = [UIColor whiteColor];
    
    [footer addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(CGSizeMake(128, 128));
        make.centerX.equalTo(footer.mas_centerX);
        make.centerY.equalTo(footer.mas_centerY);
    }];
    
    mTableView.tableFooterView = footer;
    
    CGRect rect = [[UIScreen mainScreen] bounds];
    header = [[QMAccountOpHeaderView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(rect), 100)];
    header.amount = 0.00;
    mTableView.tableHeaderView = header;
    
    return mTableView;
}

- (void)setUpSubViews {
    // 底部按钮
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectZero];
    containerView.backgroundColor = QM_COMMON_BACKGROUND_COLOR;
    [self.view addSubview:containerView];
    [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
        make.height.equalTo(50.0f);
    }];
    //充值按钮
    UIButton *rechargeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rechargeBtn.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    [rechargeBtn setTitleColor:QM_COMMON_TEXT_COLOR forState:UIControlStateNormal];
    [rechargeBtn setTitle:@"充值" forState:UIControlStateNormal];
    [rechargeBtn setImage:[UIImage imageNamed:@"recharge_icon"] forState:UIControlStateNormal];
    [rechargeBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -5, 0, 5)];
    [rechargeBtn addTarget:self action:@selector(rechargeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [containerView addSubview:rechargeBtn];
    
    //体现按钮
    UIButton *withDrawBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    withDrawBtn.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    [withDrawBtn setImage:[UIImage imageNamed:@"withdraw_icon"] forState:UIControlStateNormal];
    [withDrawBtn setTitleColor:QM_COMMON_TEXT_COLOR forState:UIControlStateNormal];
    [withDrawBtn setTitle:@"提现" forState:UIControlStateNormal];
    [withDrawBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -5, 0, 5)];
    [withDrawBtn addTarget:self action:@selector(withDrawBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [containerView addSubview:withDrawBtn];
    
    [rechargeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(containerView.mas_left);
        make.top.equalTo(containerView.mas_top);
        make.bottom.equalTo(containerView.mas_bottom);
        make.right.equalTo(withDrawBtn.mas_left);
    }];
    
    [withDrawBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(rechargeBtn.mas_right);
        make.right.equalTo(containerView.mas_right);
        make.top.equalTo(containerView.mas_top);
        make.bottom.equalTo(containerView.mas_bottom);
        make.width.equalTo(rechargeBtn.mas_width);
    }];
    
    UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectZero];
    line.backgroundColor = [UIColor colorWithRed:240.0f / 255.0f green:240.0f / 255.0f blue:240.0f / 255.0f alpha:1.0f];
    [containerView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(containerView.mas_centerX);
        make.top.equalTo(containerView.mas_top);
        make.bottom.equalTo(containerView.mas_bottom);
        make.width.equalTo(0.5f);
    }];
}

- (void)rechargeBtnClicked:(id)sender {
    QMRechargeViewController *con = [[QMRechargeViewController alloc] init];
    con.isModel = YES;
    QMNavigationController *nav = [[QMNavigationController alloc] initWithRootViewController:con];
    [self.navigationController presentViewController:nav animated:YES completion:nil];
}

- (void)withDrawBtnClicked:(id)sender {
    if (available <= 0) {
        [CMMUtility showNote:@"没有余额可提现"];
        
        return;
    }
    
    QMWithDrawViewController *con = [[QMWithDrawViewController alloc] init];
    con.isModel = YES;
    QMNavigationController *nav = [[QMNavigationController alloc] initWithRootViewController:con];
    [self.navigationController presentViewController:nav animated:YES completion:nil];
}

#pragma mark -
#pragma mark UITableViewDataSource 
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (nil == cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.textLabel.textColor = QM_COMMON_SUB_TITLE_COLOR;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    if (indexPath.row == 0) {
        cell.textLabel.text = @"充值记录";
    }else if (indexPath.row == 1) {
        cell.textLabel.text = @"提现记录";
    }
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
        // 充值记录
        [self gotoRechargeRecordListViewController];
    }else if (indexPath.row == 1) {
        // 提现记录
        [self gotowithDrawApplyListViewController];
    }
}

// 充值记录
- (void)gotoRechargeRecordListViewController {
    QMRechargeRecordListViewController *con = [[QMRechargeRecordListViewController alloc] init];
    [self.navigationController pushViewController:con animated:YES];
}

// 提现记录
- (void)gotowithDrawApplyListViewController {
    QMWithDrawRecordListViewController *con = [[QMWithDrawRecordListViewController alloc] init];
    [self.navigationController pushViewController:con animated:YES];
}

- (NSString *)title {
    return QMLocalizedString(@"qm_account_balance_nav_title", @"总资产");
}

- (void)reloadData {
    // 获取剩余金额
    [[NetServiceManager sharedInstance] getAvailableMoneyWithDelegate:self success:^(id responseObject) {
        if (!QM_IS_DICT_NIL(responseObject)) {
            // 显示当前余额
            available = [[responseObject objectForKey:@"available"] doubleValue];
            header.amount = available;
        }
        
        [self doneLoadingTableViewData];
    } failure:^(NSError *error) {
        [CMMUtility showNoteWithError:error];
    }];
}

- (void)doneLoadingTableViewData {
    [super doneLoadingTableViewData];
    [(UICollectionView *)self.scrollView reloadData];
}

- (void)didTriggerLoadNextPageData {
    [self reloadData];
}

- (BOOL)isAllDataLoaded {
    return isAllDataLoaded;
}


@end
