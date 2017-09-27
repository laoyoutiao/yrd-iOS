//
//  QMBusinessAmountViewController.m
//  MotherMoney
//
//  Created by cgt cgt on 2017/8/10.
//  Copyright © 2017年 cgt cgt. All rights reserved.
//

#import "QMBusinessAmountViewController.h"
#import "QMBusinessCell.h"
#import "QMQRCodeOrActionViewController.h"
#import "QMBusinessViewController.h"

@interface QMBusinessAmountViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *busindessTable;
@property (nonatomic, strong) NSArray *textArray;
@end

@implementation QMBusinessAmountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = QM_COMMON_BACKGROUND_COLOR;

    NSString *customerNumber = [NSString stringWithFormat:@"当前客户数量 : %@",_customerCount];
    _textArray = [[NSArray alloc] initWithObjects:@"活动详情", @"推广明细", @"二维码/链接", customerNumber, nil];
    [self setupTableView];
    
    // Do any additional setup after loading the view.
}

- (void)setupTableView
{
    _busindessTable = [[UITableView alloc] initWithFrame:CGRectMake(10, 0, CGRectGetWidth(self.view.frame) - 2 * 10, CGRectGetHeight(self.view.frame)) style:UITableViewStylePlain];
    _busindessTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    _busindessTable.backgroundColor = [UIColor clearColor];
    _busindessTable.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _busindessTable.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_busindessTable.frame), 10)];
    _busindessTable.delegate = self;
    _busindessTable.dataSource = self;
    [self.view addSubview:_busindessTable];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"businessAmountCell";
    
    QMBusinessCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (nil == cell) {
        cell = [[QMBusinessCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.accessoryView = nil;
    
    if (indexPath.row <= 2)
    {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    UIImageView *horizontalLine = [[UIImageView alloc] initWithImage:[QMImageFactory commonHorizontalLineImage]];
    [horizontalLine setFrame:CGRectMake(0, 39, tableView.frame.size.width, 1)];
    [cell addSubview:horizontalLine];
    [cell setupBusinessText:[_textArray objectAtIndex:indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        [self gotoBusinessActionViewController];
    }else if (indexPath.row == 1)
    {
        [self gotoBusinessController];
    }else if (indexPath.row == 2)
    {
        [self gotoQRCodeViewController];
    }
}

- (void)gotoBusinessController {
    QMBusinessViewController *con = [[QMBusinessViewController alloc] init];
    [self.navigationController pushViewController:con animated:YES];
}

- (void)gotoBusinessActionViewController {
//    QMQRCodeOrActionViewController *con = [[QMQRCodeOrActionViewController alloc] init];
//    con.isQRCode = NO;
//    [self.navigationController pushViewController:con animated:YES];
    [QMWebViewController showWebViewWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/theme/assets/html/rule.html",URL_BASE]]] navTitle:@"活动规则" isModel:YES from:self];
}

- (void)gotoQRCodeViewController {
    QMQRCodeOrActionViewController *con = [[QMQRCodeOrActionViewController alloc] init];
    con.isQRCode = YES;
    con.channelID = _channelID;
    [self.navigationController pushViewController:con animated:YES];
}

- (NSString *)title
{
    return @"推广";
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
