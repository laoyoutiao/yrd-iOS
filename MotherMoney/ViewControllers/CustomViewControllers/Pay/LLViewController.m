#import "LLViewController.h"
#import "LLPayUtil.h"



@interface LLViewController () <LLPaySdkDelegate, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
@property (nonatomic, retain) LLPaySdk *sdk;
@property (nonatomic,retain)  NSDictionary * param;
@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, assign) BOOL  bTestServer;

@property (nonatomic, assign) BOOL  bModelSmS;

@property (nonatomic, assign) BOOL  bVerifyPayState;
@property (nonatomic, assign) BOOL  bPreCardPay;
@property (nonatomic, assign) BOOL  bPayNewCard;

@property (nonatomic, strong) UITextField *cardNumField;
@property (nonatomic, strong) UITextField *agreeNumField;
@property (nonatomic, strong) UITextField *nameField;
@property (nonatomic, strong) UITextField *idNumField;
@property (nonatomic, strong) UITextField *userIdField;
@property (nonatomic, retain) NSMutableDictionary *orderParam;
@end

@implementation LLViewController

-(id)initWithDicParam:(NSDictionary *) param{
    if(self = [super init]){
        self.param = param;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.bTestServer = NO;
    self.bVerifyPayState = NO;
    self.bModelSmS = YES;
    
//    [LLPaySdk switchToTestServer:self.bTestServer];
    _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 300)];
    self.cardNumField = [[UITextField alloc] initWithFrame:CGRectMake(20, 5, 220, 40)];
    _cardNumField.placeholder = @"请输入卡号";
    _cardNumField.returnKeyType = UIReturnKeyDone;
    _cardNumField.delegate = self;
    _cardNumField.textColor = [UIColor redColor];
    
    
    //卡前置历次卡支付，传入协议号即可
    self.agreeNumField = [[UITextField alloc] initWithFrame:CGRectMake(20, 0, 300, 40)];
    _agreeNumField.placeholder = @"协议号no_agree";
    _agreeNumField.returnKeyType = UIReturnKeyDone;
    _agreeNumField.delegate = self;
    _agreeNumField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    _agreeNumField.textColor = [UIColor redColor];
    
    _nameField = [[UITextField alloc] initWithFrame:CGRectMake(20, 0, 220, 40)];
    _nameField.placeholder = @"请输入姓名";
    _nameField.returnKeyType = UIReturnKeyDone;
    _nameField.delegate = self;
    _nameField.textColor = [UIColor redColor];
    [headerView addSubview:_nameField];
    
    _idNumField = [[UITextField alloc] initWithFrame:CGRectMake(20, 0, 220, 40)];
    _idNumField.placeholder = @"请输入身份证号";
    _idNumField.returnKeyType = UIReturnKeyDone;
    _idNumField.delegate = self;
    _idNumField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    _idNumField.textColor = [UIColor redColor];
    [headerView addSubview:_idNumField];
    
    _userIdField = [[UITextField alloc] initWithFrame:CGRectMake(20, 0, 300, 40)];
    _userIdField.placeholder = @"user_id,不懂意思请查看源代码说明";
    _userIdField.returnKeyType = UIReturnKeyDone;
    _userIdField.delegate = self;
    _userIdField.textColor = [UIColor redColor];
    [headerView addSubview:_userIdField];
    
    [self.view addSubview:_tableView];

    [self createOrder];
    [self.tableView reloadData];
}

// 生成订单参数
- (void)createOrder {
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
    [dateFormater setDateFormat:@"yyyyMMddHHmmss"];
    
    NSString *simOrder = [dateFormater stringFromDate:[NSDate date]];
    NSString *partnerPrefix = @"LL";
    NSString *signType = @"MD5";    // MD5 || RSA
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setDictionary:@{
                           @"sign_type":signType,
                           @"busi_partner":@"101001",
                           @"dt_order":simOrder,
                           @"notify_url":@"http://www.baidu.com",
                           @"no_order":[NSString stringWithFormat:@"%@%@",partnerPrefix,  simOrder],
                           @"name_goods":@"订单名",
                           @"info_order":simOrder,
                           @"valid_order":@"10080",
                           @"risk_item" : [LLPayUtil jsonStringOfObj:@{@"user_info_dt_register":@"20131030122130"}],
                           }];
    
    
    param[@"money_order"] = @"0.01";
    
    self.orderParam = param;
}

#pragma -mark table delegate & source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 3;
    }else if (section == 1) {
        if (self.bPreCardPay){
            return 4;
        }
        return 2;
    }else if (section == 2) {
        return 3;
    }else if (section == 3) {
        return 2;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellID = @"cellid";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    [self removeAllSubview:cell.contentView];
    cell.textLabel.text = @"";
    cell.detailTextLabel.text = @"";
    
    
    if (indexPath.section == 0) {
        [self orderInfoCell:cell forRowAtIndexPath:indexPath];
    }else if (indexPath.section == 1) {
        [self payMethodCell:cell forRowAtIndexPath:indexPath];
    }else if (indexPath.section == 2) {
        [self userInfoCell:cell forRowAtIndexPath:indexPath];
    }else if (indexPath.section == 3) {
        [self payCell:cell forRowAtIndexPath:indexPath];
    }
    
    return cell;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSArray *array = @[@"订单信息", @"订单支付方式", @"用户信息", @"订单支付"];
    
    return array[section];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0){

    }else if (indexPath.section == 1) {
        [self payMethodCelldidSelectRowAtIndexPath:indexPath];
    }else if (indexPath.section == 2) {
        [self userInfoCelldidSelectRowAtIndexPath:indexPath];
    }else if (indexPath.section == 3) {
        [self payCelldidSelectRowAtIndexPath:indexPath];
    }
    return;
}

#pragma -mark UITextFieldDelegate Methods
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    self.tableView.contentSize = CGSizeMake(self.tableView.frame.size.width, self.tableView.contentSize.height + 300);
    
    CGPoint textfieldPoint = [textField convertPoint:CGPointMake(0, 70) toView:self.tableView];
    NSIndexPath *textIndex = [self.tableView indexPathForRowAtPoint:textfieldPoint];
    CGRect rect = [self.tableView rectForRowAtIndexPath:textIndex];
    
    self.tableView.contentOffset = CGPointMake(0, rect.origin.y - 200);
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    self.tableView.contentSize = CGSizeMake(self.tableView.frame.size.width, self.tableView.contentSize.height - 300);
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [_cardNumField resignFirstResponder];
    [_agreeNumField resignFirstResponder];
    [_nameField resignFirstResponder];
    [_idNumField resignFirstResponder];
    [_userIdField resignFirstResponder];
    
    return YES;
}

#pragma -mark common method
- (void)removeAllSubview:(UIView*)parentView{
    while (parentView.subviews.count > 0) {
        UIView *subview = parentView.subviews[0];
        [subview removeFromSuperview];
    }
}

- (void)reloadSection:(int)section{
    [_tableView reloadSections:[NSIndexSet indexSetWithIndex:section]
              withRowAnimation:UITableViewRowAnimationNone];
}

#pragma -mark 订单信息
- (void)orderInfoCell:(UITableViewCell*)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *title = @"";
    
    switch (indexPath.row)  {
        case 0:
            title = [NSString stringWithFormat:@"订单号: %@", self.orderParam[@"no_order"]];
            break;
        case 1:
            title = [NSString stringWithFormat:@"订单名称: %@", self.orderParam[@"name_goods"]];
            break;
        case 2:
            title = [NSString stringWithFormat:@"支付价格 : %@", self.orderParam[@"money_order"]];
            break;
        default:
            break;
    }
    
    cell.textLabel.text = title;
}

#pragma -mark 选择支付方式
- (void)payMethodCell:(UITableViewCell*)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *title = @"";
    
    [self removeAllSubview: cell.contentView];
    
    switch (indexPath.row)  {
        case 0:
            title = [NSString stringWithFormat:@"当前支付方式：%@", @"认证支付"];
            break;
        case 1:
            title = [NSString stringWithFormat:@"当前卡前置模式是：%@", self.bPreCardPay ? @"卡前置支付" : @"非卡前置支付"];
            break;
        case 2:
            title = [NSString stringWithFormat:@"当前支付卡类型是：%@", self.bPayNewCard ? @"卡号支付" : @"已绑定卡支付"];
            if (!self.bPayNewCard){
                cell.detailTextLabel.text = @"协议号是支付成功以后，连连系统内取代卡号的编号，可以通过查询得到。";
            }
            break;
        case 3:
            if (self.bPayNewCard){
                [cell.contentView addSubview:_cardNumField];
            }else{
                [cell.contentView addSubview:_agreeNumField];
            }
            break;
            
        default:// 2015042964123934
            break;
    }
    
    cell.textLabel.text = title;
}

- (void)payMethodCelldidSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
            break;
        case 1:
            self.bPreCardPay = !self.bPreCardPay;
            break;
        case 2:
            self.bPayNewCard = !self.bPayNewCard;
            break;
        case 3:
            break;
            
        default:
            break;
    }
    
    [self.tableView reloadData];
}

#pragma -mark 用户信息
- (void)userInfoCell:(UITableViewCell*)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [self removeAllSubview: cell.contentView];
    
    switch (indexPath.row) {
        case 0:
            [cell.contentView addSubview:_userIdField];
            break;
        case 1:
            [cell.contentView addSubview:_nameField];
            break;
        case 2:
            [cell.contentView addSubview:_idNumField];
            break;
        case 3:
            break;
            
        default:
            break;
    }
}

- (void)userInfoCelldidSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

#pragma -mark 订单支付
- (void)payCell:(UITableViewCell*)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *title = @"";
    
    switch (indexPath.row) {
        case 0:
            title = @"使用连连支付支付订单";
            break;
        case 1:
            title = self.bTestServer ?  @"正在测试环境，支付信息无法查看log": @"当前环境是正式环境支付";
            if (self.bTestServer){
                cell.detailTextLabel.text = @"仅供连连内部调试使用，任何出现的问题，不负责解释";
            }
            
            break;
            
        default:
            break;
    }
    
    cell.textLabel.text = title;
}

- (void)payCelldidSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 1) {
        self.bTestServer = !self.bTestServer;
        [self reloadSection:3];
        return;
    }
    
    NSString *fillInfo = [self fillOrderMethodAndUserinfo];
    
    if (fillInfo == nil){
        
        LLPayUtil *payUtil = [[LLPayUtil alloc] init];
        
        NSDictionary *signedOrder = [payUtil signedOrderDic:self.orderParam andSignKey:[self partnerKey:self.orderParam[@"oid_partner"]]];
        
        [self payWithSignedOrder: signedOrder];
    } else{
        
        [[[UIAlertView alloc] initWithTitle:@"订单校验"
                                    message:fillInfo
                                   delegate:nil
                          cancelButtonTitle:@"确认"
                          otherButtonTitles:nil] show];
    }
}

- (NSString*)fillOrderMethodAndUserinfo{
    if (self.bTestServer) {
        self.orderParam[@"oid_partner"] = self.bModelSmS ?  @"201307232000003510" : @"201407032000003742";
    }else {
        self.orderParam[@"oid_partner"] = @"201408071000001543";//201306261000001017
    }
    
    if (_nameField.text.length > 0) {
        self.orderParam[@"acct_name"] = _nameField.text;
    }else{
        return @"认证支付必须传递用户姓名";
    }
    if (_idNumField.text.length > 0) {
        self.orderParam[@"id_no"] = _idNumField.text;
    }else{
        return @"认证支付必须传递用户身份证";
    }
    
    if (self.bPreCardPay) {
        if (self.bPayNewCard) {
            if (_cardNumField.text.length > 0 ) {
                self.orderParam[@"card_no"] = _cardNumField.text;
            }
        }
        else{
            
            if (_agreeNumField.text.length > 0) {
                self.orderParam[@"no_agree"] = _agreeNumField.text;
            }
        }
    }
    
    if (_userIdField.text.length == 0) {
        return @"user_id是必传项，需要关联商户里的用户编号，一个user_id下的所有支付银行卡，身份证必须相同";
    }
    else
    {
        self.orderParam[@"user_id"] = _userIdField.text;
    }
    
    return nil;
    
}


- (void)payWithSignedOrder:(NSDictionary*)signedOrder {
    self.sdk = [[LLPaySdk alloc] init];
    self.sdk.sdkDelegate = self;
    /*
    // 切换认证支付与快捷支付，假如并不需要切换，可以不调用这个方法（此方法为老版本使用）
    [LLPaySdk setVerifyPayState:self.bVerifyPayState];
    */
    
    //认证支付、快捷支付、预授权切换，0快捷 1认证 2预授权。假如不需要切换，可以不调用这个方法
    [LLPaySdk setLLsdkPayState:1];
    
    
//    [self.sdk presentPaySdkInViewController:self withTraderInfo:signedOrder];
    
    
        [self.sdk presentPaySdkInViewController:self withTraderInfo:self.param];
}

- (NSString*)partnerKey:(NSString*)oid_partner{
    
    NSString *pay_md5_key = @"yintong1234567890";
    
    
    if (self.bTestServer) {
        pay_md5_key = @"201103171000000000";//201103171000000000
    }
    else{
        if ([oid_partner isEqualToString:@"201408071000001543"]) {
            pay_md5_key = @"201408071000001543test_20140812";
        }
        else if ([oid_partner isEqualToString:@"201408071000001546"]) {
            pay_md5_key = @"201408071000001546_test_20140815";
        }
        else if ([oid_partner isEqualToString:@"201504071000272504"]){
            pay_md5_key = @"201504071000272504_test_20150417";
        }
    }
    
    return pay_md5_key;
}


#pragma -mark 支付结果 LLPaySdkDelegate
// 订单支付结果返回，主要是异常和成功的不同状态
- (void)paymentEnd:(LLPayResult)resultCode withResultDic:(NSDictionary *)dic {
    NSString *msg = @"支付异常";
    switch (resultCode) {
        case kLLPayResultSuccess: {
            msg = @"支付成功";
            
            NSString* result_pay = dic[@"result_pay"];
            if ([result_pay isEqualToString:@"SUCCESS"]) {
                //
                NSString *payBackAgreeNo = dic[@"agreementno"];
                _agreeNumField.text = payBackAgreeNo;
            } else if ([result_pay isEqualToString:@"PROCESSING"]) {
                msg = @"支付单处理中";
            }else if ([result_pay isEqualToString:@"FAILURE"]) {
                msg = @"支付单失败";
            }else if ([result_pay isEqualToString:@"REFUND"]) {
                msg = @"支付单已退款";
            }
        }
            break;
        case kLLPayResultFail: {
            msg = @"支付失败";
        }
            break;
        case kLLPayResultCancel: {
            msg = @"支付取消";
        }
            break;
        case kLLPayResultInitError: {
            msg = @"sdk初始化异常";
        }
            break;
        case kLLPayResultInitParamError: {
            msg = dic[@"ret_msg"];
        }
            break;
        default:
            break;
    }
    [[[UIAlertView alloc] initWithTitle:@"结果"
                                message:msg
                               delegate:nil
                      cancelButtonTitle:@"确认"
                      otherButtonTitles:nil] show];
}
@end
