//
//  QMBusinessViewController.m
//  MotherMoney
//
//  Created by cgt cgt on 2017/8/9.
//  Copyright © 2017年 cgt cgt. All rights reserved.
//

#import "QMBusinessViewController.h"
#import "QMBusinessCell.h"
#import "QMBusinessInfoModel.h"

@interface QMBusinessViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *accountInfoTable;
@property (nonatomic, strong) NSArray *businessInfoArray;
@property (nonatomic, assign) float footerviewHeight;
@property (nonatomic, assign) NSInteger showNumber;
@property (nonatomic, assign) NSInteger total;
@property (nonatomic, strong) NSIndexPath *showIndexPath;
@end

@implementation QMBusinessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = QM_COMMON_BACKGROUND_COLOR;
    
//    _businessInfoArray = [[NSMutableArray alloc] init];
    _showNumber = 3;
    _footerviewHeight = 0;
    [self setupTableView];
    [self updateTable];

    // Do any additional setup after loading the view.
}

- (void)setupTableView
{
    _accountInfoTable = [[UITableView alloc] initWithFrame:CGRectMake(10, 10, CGRectGetWidth(self.view.frame) - 2 * 10, CGRectGetHeight(self.view.frame) - 20) style:UITableViewStylePlain];
    _accountInfoTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    _accountInfoTable.backgroundColor = [UIColor clearColor];
    _accountInfoTable.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
//    _accountInfoTable.sectionHeaderHeight = 10.0f;
//    _accountInfoTable.sectionFooterHeight = 0;
//    _accountInfoTable.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_accountInfoTable.frame), 40)];
    _accountInfoTable.delegate = self;
    _accountInfoTable.dataSource = self;
    [self.view addSubview:_accountInfoTable];
}

- (void)updateTable
{
    [CMMUtility showWaitingAlertView];
    [[NetServiceManager sharedInstance] getBusinessAmount:self success:^(id responseObject) {
        _businessInfoArray = [QMBusinessInfoModel instanceArrayDictFromArray:[responseObject objectForKey:@"list"]];
        _total = [[responseObject objectForKey:@"total"] integerValue];
        NSLog(@"%@",_businessInfoArray);
        if ([_businessInfoArray count] > 3) {
            _footerviewHeight = 30;
        }
        [CMMUtility hideWaitingAlertView];
        [_accountInfoTable reloadData];
    } failure:^(NSError *error) {
        
    }];
}

- (UILabel *)setupLbl:(CGRect)rect :(NSString *)text
{
    UILabel *label = [[UILabel alloc] initWithFrame:rect];
    label.text = text;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor colorWithRed:72.0f/255.0f green:188.0f/255.0f blue:255.0f/255.0f alpha:1];
    return label;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 40)];
    
    UILabel *peopleNumberLbl = [self setupLbl:CGRectMake(tableView.frame.size.width / 4 * 1, 0, tableView.frame.size.width / 8, 40) :@"客户数"];
    UILabel *annualRateLbl = [self setupLbl:CGRectMake(tableView.frame.size.width / 4 * 1.5, 0, tableView.frame.size.width / 4 * 1.5, 40) :@"年化金额(元)"];
    UILabel *commissionLbl = [self setupLbl:CGRectMake(tableView.frame.size.width / 4 * 3 , 0, tableView.frame.size.width / 4, 40) :@"佣金(元)"];
    UILabel *timeLbl = [self setupLbl:CGRectMake(0, 0, tableView.frame.size.width / 4, 40) :@"时间(月)"];
    
    [view addSubview:peopleNumberLbl];
    [view addSubview:annualRateLbl];
    [view addSubview:commissionLbl];
    [view addSubview:timeLbl];
    
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, _footerviewHeight)];
    view.backgroundColor = [UIColor whiteColor];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 0.5)];
    line.backgroundColor = QM_COMMON_BACKGROUND_COLOR;
    [view addSubview:line];
    
    UIButton *updateMoreBtn = [[UIButton alloc] initWithFrame:view.frame];
    [updateMoreBtn addTarget:self action:@selector(clickMore) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:updateMoreBtn];
    
    UILabel *textLabel = [[UILabel alloc] initWithFrame:view.frame];
    textLabel.text = @"点击查看更多";
    textLabel.textAlignment = NSTextAlignmentCenter;
    textLabel.textColor = [UIColor colorWithRed:255.0f/255.0f green:127.0f/255.0f blue:80.0f/255.0f alpha:1];
    [view addSubview:textLabel];
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return _footerviewHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([_businessInfoArray count] < _showNumber) {
        return [_businessInfoArray count];
    }else
    {
        return _showNumber;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"businessCell";
    
    QMBusinessCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (nil == cell) {
        cell = [[QMBusinessCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.accessoryView = nil;
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    
    [cell setupFrame:tableView.frame];
    QMBusinessInfoModel *info = [_businessInfoArray objectAtIndex:indexPath.row];
    [cell configureCellWithItemInfo:info];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 0.5)];
    line.backgroundColor = QM_COMMON_BACKGROUND_COLOR;
    [cell addSubview:line];
    
    _showIndexPath = indexPath;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)clickMore
{
    _showNumber = [_businessInfoArray count];
//    if (_showNumber >= _total)
//    {
        _footerviewHeight = 0;
//    }
    [_accountInfoTable reloadData];
    [_accountInfoTable scrollToRowAtIndexPath:_showIndexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
}

- (NSString *)title
{
    return @"业务佣金明细";
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
