//
//  QMPanicBuyViewController.m
//  MotherMoney
//
//  Created by cgt cgt on 16/8/11.
//  Copyright © 2016年 cgt cgt. All rights reserved.
//

#import "QMPanicBuyViewController.h"

typedef NS_ENUM(NSInteger, tableViewType) {
    TableViewTypePanicbuy = 0,
    TableViewTypeWinrocord = 1,
    TableViewTypeBuy = 2,
};

@interface QMPanicBuyViewController () <UITableViewDelegate,UITableViewDataSource>
{
    UIView *backview;
    UITableView *tableview;
    tableViewType tableViewSelectType;
}

@end

@implementation QMPanicBuyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的抢购";
    
    UIScreen *screen = [UIScreen mainScreen];
    
    backview = [[UIView alloc] initWithFrame:CGRectMake(0, 37, screen.bounds.size.width / 3, 3)];
    backview.backgroundColor = [UIColor redColor];
    [self.view addSubview:backview];
    
    UIView *buttonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screen.bounds.size.width, 37)];
    buttonView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:buttonView];
    
    UIButton *panicRecordButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, buttonView.bounds.size.width / 3, buttonView.bounds.size.height)];
    [panicRecordButton setTitle:@"抢购记录" forState:UIControlStateNormal];
    panicRecordButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [panicRecordButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [panicRecordButton addTarget:self action:@selector(clickPanicButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:panicRecordButton];
    
    UIButton *winRecordButton = [[UIButton alloc] initWithFrame:CGRectMake(panicRecordButton.bounds.size.width, 0, panicRecordButton.bounds.size.width, buttonView.bounds.size.height)];
    [winRecordButton setTitle:@"中奖记录" forState:UIControlStateNormal];
    winRecordButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [winRecordButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [winRecordButton addTarget:self action:@selector(clickWinButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:winRecordButton];
    
    UIButton *buyButton = [[UIButton alloc] initWithFrame:CGRectMake(panicRecordButton.bounds.size.width * 2, 0, panicRecordButton.bounds.size.width, buttonView.bounds.size.height)];
    [buyButton setTitle:@"购买产品" forState:UIControlStateNormal];
    buyButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [buyButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [buyButton addTarget:self action:@selector(clickBuyButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buyButton];
    
    tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 40, screen.bounds.size.width, screen.bounds.size.height - 40)];
    tableview.delegate = self;
    tableview.dataSource = self;
    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableview];
    // Do any additional setup after loading the view.
}

- (void)clickPanicButton
{
    [UIView animateWithDuration:0.5 animations:^{
        backview.frame = CGRectMake(0, backview.frame.origin.y, backview.bounds.size.width, backview.bounds.size.height);
    }];
    tableViewSelectType = TableViewTypePanicbuy;
    [tableview reloadData];
}

- (void)clickWinButton
{
    [UIView animateWithDuration:0.5 animations:^{
        backview.frame = CGRectMake(backview.bounds.size.width, backview.frame.origin.y, backview.bounds.size.width, backview.bounds.size.height);
    }];
    tableViewSelectType = TableViewTypeWinrocord;
    [tableview reloadData];
}

- (void)clickBuyButton
{
    [UIView animateWithDuration:0.5 animations:^{
        backview.frame = CGRectMake(backview.bounds.size.width * 2, backview.frame.origin.y, backview.bounds.size.width, backview.bounds.size.height);
    }];
    tableViewSelectType = TableViewTypeBuy;
    [tableview reloadData];
}

#pragma mark TableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 188;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.selected = NO;
    if (!cell) {
        return nil;
    }
    
    UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(10, 30, 70, 70)];
    imageview.image = [UIImage imageNamed:@"bean_icon"];
    [cell addSubview:imageview];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(85, 10, 250, 50)];
    titleLabel.text = @"iphone 6 Plus";
    titleLabel.numberOfLines = 0;
    titleLabel.font = [UIFont systemFontOfSize:18];
    [cell addSubview:titleLabel];
    
    UILabel *demandLabel = [[UILabel alloc] initWithFrame:CGRectMake(85, 65, 250, 20)];
    demandLabel.text = @"期号:xxxxxxxxx";
    demandLabel.font = [UIFont systemFontOfSize:13];
    [cell addSubview:demandLabel];
    
    UILabel *participateLabel = [[UILabel alloc] initWithFrame:CGRectMake(85, 95, 200, 20)];
    participateLabel.text = @"本期参与:xxxx人次";
    participateLabel.font = [UIFont systemFontOfSize:13];
    [cell addSubview:participateLabel];
    
    UIButton *calcuButton = [[UIButton alloc] initWithFrame:CGRectMake(300, 155, 70, 20)];
    [calcuButton setTitle:@"查看计算方式" forState:UIControlStateNormal];
    calcuButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [calcuButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [cell addSubview:calcuButton];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(10, 125, tableview.bounds.size.width - 20, 1)];
    [cell addSubview:line];
    
    
    
    if (tableViewSelectType == TableViewTypePanicbuy) {
        cell = [self panicBuyCellView:cell indexPathRow:indexPath.row];
    }else if (tableViewSelectType == TableViewTypeWinrocord)
    {
        cell = [self winrecordCellView:cell indexPathRow:indexPath.row];
    }else if (tableViewSelectType == TableViewTypeBuy)
    {
        cell = [self buyCellView:cell indexPathRow:indexPath.row];
    }
    
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell *)panicBuyCellView:(UITableViewCell *)cell indexPathRow:(NSInteger)row
{
    UIScreen *screen = [UIScreen mainScreen];
    
    return cell;
}

- (UITableViewCell *)winrecordCellView:(UITableViewCell *)cell indexPathRow:(NSInteger)row
{
    UIScreen *screen = [UIScreen mainScreen];

    return cell;
}

- (UITableViewCell *)buyCellView:(UITableViewCell *)cell indexPathRow:(NSInteger)row
{
    UIScreen *screen = [UIScreen mainScreen];
    
    return cell;
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
