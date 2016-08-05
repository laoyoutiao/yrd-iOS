
#import "NetServiceManager.h"
#import "CMMUtility.h"
#import "QMTokenInfo.h"
@interface NetServiceManager()
@property (nonatomic, strong) AFHTTPClient *httpRequest;

-(void)catchNetResWithResInfo:(id )info
                      success:(void(^)(id resBody)) success
                        error:(void(^)(NSError* error)) failure
                     delegate:(UIViewController *) delegate
                         path:(NSString *)path;

-(NSMutableDictionary *)buildParametersDic;

@end



@implementation NetServiceManager

+(NetServiceManager *)sharedInstance
{
    static dispatch_once_t  onceToken;
    static NetServiceManager * sSharedInstance;
    
    dispatch_once(&onceToken, ^{
        sSharedInstance = [[NetServiceManager alloc] init];
    });
    return sSharedInstance;
}

- (id)init {
    if (self = [super init]) {
        _httpRequest = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:URL_BASE]];
    }
    
    return self;
}

-(void)testServiceWithURL:(NSString *)url
                 delegate:(id)delegate
                   params:(NSDictionary *)params
                  success:(void (^)( id responseObject))success
                  failure:(void (^)( NSError *error))failure
{
    [_httpRequest xsPostPath:url delegate:delegate params:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
       // NSLog(@"响应：%@",str);
        success(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //
        failure(error);
    }];
}

/**
 统一的数据处理
 @param info 网络返回的data
 */
-(void)catchNetResWithResInfo:(id )info
                      success:(void(^)(id resBody)) success
                        error:(void(^)(NSError* error)) failure
                     delegate:(UIViewController *) delegate
                         path:(NSString *)path
{

    if (delegate == nil) {
        return;
    }
    if ([delegate isKindOfClass:[UIViewController class]]) {
        [CMMUtility hideWaitingAlertView];
    }
    //网络请求成功
    NSDictionary *dic = (NSDictionary *)[info objectFromJSONData];
    
//      NSLog(@"网络响应数据【%@】",dic);
    
    NSNumber *resCode = [dic objectForKey:kNetWorkCode];
    
    switch (resCode.integerValue) {
        case 1:
            //成功
        {
            NSDictionary *data = [dic objectForKey:kNetWorkDataBody];
            if (success) {
                
                success(data);
            }
        }
            break;
        case 2:
            //失败，参数异常
            [CMMUtility showNote:@"提交的参数异常,请检查后重新提交!"];
            break;
        case 3:
            //失败，用户未登录
        {
            [CMMUtility showTMPLogin];
            //登陆异常
            NSError *error = [NSError errorWithDomain:kErrorCMMDomain code:resCode.integerValue userInfo:nil];
            if (failure) {
                failure(error);
            }
        }
            break;
        case 9:
            //失败，系统异常
        {
            NSDictionary *data = [dic objectForKey:kNetWorkDataBody];
            if (data && [data isKindOfClass:[NSDictionary class]]) {
                NSString *msg = [data objectForKey:kNetWorErrorMsg];
               // NSLog(@"errorMSG:%@",msg);
                if (msg) {
                    NSError *error = [NSError errorWithDomain:kErrorCMMDomain code:kNetworkInnerException userInfo:[NSDictionary dictionaryWithObject:msg forKey:kNetWorErrorMsg]];
                    failure(error);
                }else {
                    [CMMUtility showNote:@"抱歉,系统异常,请稍候重试!"];
                }
            }
            failure([NSError errorWithDomain:kErrorCMMDomain code:resCode.intValue userInfo:nil]);
        }
            
            break;
        default:
        {
            NSString *errorMSG = [dic objectForKey:kNetWorErrorMsg];
            if (errorMSG && [errorMSG isKindOfClass:[NSString class]]) {
                NSMutableDictionary *errorData = [NSMutableDictionary dictionaryWithCapacity:1];
                [errorData setObject:errorMSG forKey:kNetWorErrorMsg];
                // NSLog(@"msg:%@",errorMSG);
                failure([NSError errorWithDomain:kErrorCMMDomain code:resCode.intValue userInfo:errorData]);
            }else {
                failure([NSError errorWithDomain:kErrorCMMDomain code:resCode.intValue userInfo:nil]);
            }
        }
            break;
    }
}

-(void)sendUserRegisterMsgCodeWithPhoneNumber:(NSString *)phoneNumber
                                     delegate:(id)delegate
                                      success:(void (^)( id responseObject))success
                                      failure:(void (^)( NSError *error))failure
{
    assert(phoneNumber);
    [CMMUtility showWaitingAlertView];
    NSDictionary *param = [NSDictionary dictionaryWithObject:phoneNumber forKey:@"mobile"];
    [_httpRequest xsPostPath:kSendRegisterCode delegate:delegate params:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //
        [self catchNetResWithResInfo:responseObject success:success error:failure delegate:delegate path:kSendRegisterCode];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //
        failure(error);
        [CMMUtility hideWaitingAlertView];
        [self showNoNetworkErrorPrompt:error];
    }];
}

/**
 用户手机号是否已经存在
 @param phoneNumber 手机号码
 @param delegate 代理
 @returns void
 */
-(void)checkUserExitingWithPhoneNumber:(NSString *)phoneNumber
                              delegate:(id)delegate
                               success:(void (^)( id responseObject))success
                               failure:(void (^)( NSError *error))failure
{
    assert(phoneNumber);
    [CMMUtility showWaitingAlertView];
    NSMutableDictionary *param = [self buildParametersDic];
    [param setObject:phoneNumber forKey:@"phoneNumber"];
    
    [_httpRequest xsPostPath:kUserRegisteredCheck delegate:delegate params:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //
        [self catchNetResWithResInfo:responseObject success:success error:failure delegate:delegate path:kUserRegisteredCheck];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //
        failure(error);
        [CMMUtility hideWaitingAlertView];
        [self showNoNetworkErrorPrompt:error];
    }];
}

/**
 用户登录
 */
-(void)userLoginWithPhoneNumber:(NSString *)phoneNumber
                            pwd:(NSString *)pwd
                       delegate:(id)delegate
                        success:(void (^)( id responseObject))success
                        failure:(void (^)( NSError *error))failure
{
    assert(phoneNumber);
    assert(pwd);
    [CMMUtility showWaitingAlertView];
    NSMutableDictionary *param = [self buildParametersDic];
    [param setObject:phoneNumber forKey:@"mobile"];
    [param setObject:pwd forKey:@"password"];
    
    [_httpRequest xsPostPath:kUserLogin delegate:delegate params:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [self catchNetResWithResInfo:responseObject success:success error:failure delegate:delegate path:kUserLogin];
        
        NSDictionary *dict = (NSDictionary *)[responseObject objectFromJSONData];
//        NSLog(@"Test --------- %@", dict);
        if([dict objectForKey:@"success"])
        {
            QMTokenInfo *tokeninfo = [QMTokenInfo sharedInstance];
            NSString *token = tokeninfo.tokenString;
            NSLog(@"token ------ %@",token);
            [self postTokenWithPhoneNumber:phoneNumber Token:token StatuNumber:@"1"];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        failure(error);
        [CMMUtility hideWaitingAlertView];
        [self showNoNetworkErrorPrompt:error];
    }];
}

- (void)postTokenWithPhoneNumber:(NSString *)phoneNumber
                            Token:(NSString *)mobiletoken
                           StatuNumber:(NSString *)statuNumber
{
    NSMutableDictionary *param = [self buildParametersDic];
    //endType机型 安卓0 苹果1
    //status状态 登录1 退出0
    NSString *token = mobiletoken;
    NSLog(@"token ------ %@",token);
    [param setObject:phoneNumber forKey:@"mobile"];
    [param setObject:token? token:@"" forKey:@"token"];
    [param setObject:@"1" forKey:@"endType"];
    [param setObject:statuNumber forKey:@"status"];
    [_httpRequest xsPostPath:kPostToken delegate:self params:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
    }];
}

/**
 * 用户登出
 **/
- (void)userLogoutWithWithDelegate:(id)delegate
                           success:(void (^)( id responseObject))success
                           failure:(void (^)( NSError *error))failure {
    [CMMUtility showWaitingAlertView];
    NSMutableDictionary *param = [self buildParametersDic];
    [_httpRequest xsPostPath:kUserLogOut delegate:delegate params:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [self catchNetResWithResInfo:responseObject success:success error:failure delegate:delegate path:kUserLogin];
        [CMMUtility hideWaitingAlertView];
        if (success) {
            success(nil);
        }
        NSDictionary *dict = (NSDictionary *)[responseObject objectFromJSONData];
        NSLog(@"Test --------- %@", dict);
//        NSDictionary *dict = (NSDictionary *)[responseObject objectFromJSONData];
//        NSLog(@"Test --------- %@", dict);
//        if([[dict objectForKey:@"success"] isEqualToString:@"1"])
//        {
//            NSData *token = [QMTokenInfo sharedInstance].mobileToken;
//            [self postTokenWithPhoneNumber:phoneNumber Token:token StatuNumber:@"0"];
//        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        failure(error);
        [CMMUtility hideWaitingAlertView];
        [self showNoNetworkErrorPrompt:error];
    }];
}

// 检查客户端更新
- (void)checkUpdateWithVersionString:(NSString *)version
                              delete:(id)delegate
                             success:(void (^)(id responseObject))success
                             failure:(void(^)(NSError *error))failure {
    assert(version);
    [CMMUtility showWaitingAlertView];
    NSMutableDictionary *param = [self buildParametersDic];
    [param setObject:@"OS_IOS" forKey:@"osType"];
    [param setObject:version forKey:@"versionNumber"];
    [_httpRequest xsPostPath:kUPdate delegate:delegate params:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [self catchNetResWithResInfo:responseObject success:success error:failure delegate:delegate path:kUPdate];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        failure(error);
        [CMMUtility hideWaitingAlertView];
        [self showNoNetworkErrorPrompt:error];
    }];
}

// 活动中心
- (void)activityCenterListWithPageSize:(NSNumber *)pageSize
                            pageNumber:(NSNumber *)pageNumber
                              delegate:(id)delegate
                               success:(void (^)(id responseObject))success
                               failure:(void(^)(NSError *error))failure {
    assert(pageSize);
    assert(pageNumber);
    if ([pageNumber intValue]==1) {
    [CMMUtility showWaitingAlertView];
    }

    NSMutableDictionary *param = [self buildParametersDic];
    [param setObject:pageSize forKey:@"pageSize"];
    [param setObject:pageNumber forKey:@"pageNow"];
    [_httpRequest xsPostPath:kMsgList delegate:delegate params:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [self catchNetResWithResInfo:responseObject success:success error:failure delegate:delegate path:kMsgList];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        failure(error);
        [CMMUtility hideWaitingAlertView];
        [self showNoNetworkErrorPrompt:error];
    }];
}

// 精品推荐
- (void)recommendedProductInfo:(NSString *)platform
                      delegate:(id)delegate
                       success:(void (^)(id responseObject))success
                       failure:(void(^)(NSError *error))failure {
    assert(platform);
    
    [CMMUtility showWaitingAlertView];
    
    NSMutableDictionary *param = [self buildParametersDic];
    //产品通道Id，钱宝宝的productChannelId
    [param setObject:@"2" forKey:@"productChannelId"];
    
    [_httpRequest xsPostPath:kRecommend delegate:delegate params:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [self catchNetResWithResInfo:responseObject success:success error:failure delegate:delegate path:kRecommend];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        failure(error);
        [CMMUtility hideWaitingAlertView];
        [self showNoNetworkErrorPrompt:error];
    }];
}

// 产品列表
- (void)getProductListWithWithChannelId:(NSString *)channelId
                                 offset:(NSInteger)offset
                               pageSize:(NSInteger)pageSize
                               delegate:(id)delegate
                                success:(void (^)(id responseObject))success
                                failure:(void(^)(NSError *error))failure {
    
            if (offset==1) {
               [CMMUtility showWaitingAlertView];
    }

    NSMutableDictionary *param = [self buildParametersDic];
    [param setValue:[NSNumber numberWithInteger:offset] forKey:@"pageNow"];
    [param setValue:[NSNumber numberWithInteger:pageSize] forKey:@"pageSize"];
    [param setValue:channelId forKey:@"productChannelId"];
    
    [_httpRequest xsPostPath:kProductList delegate:delegate params:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [self catchNetResWithResInfo:responseObject success:success error:failure delegate:delegate path:kProductList];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        failure(error);
        [CMMUtility hideWaitingAlertView];
        [self showNoNetworkErrorPrompt:error];
    }];
}

// 消息中心
- (void)messageCenterListWithPageSize:(NSNumber *)pageSize
                           pageNumber:(NSNumber *)pageNumber
                             delegate:(id)delegate
                              success:(void (^)(id responseObject))success
                              failure:(void(^)(NSError *error))failure {
    assert(pageSize);
    assert(pageNumber);
    if ([pageNumber intValue]==1) {
      [CMMUtility showWaitingAlertView];        
    }

    NSMutableDictionary *param = [self buildParametersDic];
    [param setObject:pageSize forKey:@"pageSize"];
    [param setObject:pageNumber forKey:@"pageNow"];
    [_httpRequest xsPostPath:kMessageList delegate:delegate params:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [self catchNetResWithResInfo:responseObject success:success error:failure delegate:delegate path:kMessageList];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        failure(error);
        [CMMUtility hideWaitingAlertView];
        [self showNoNetworkErrorPrompt:error];
    }];
}

// 我的资产
- (void)getMyAssertInfoWithDelegate:(id)delegate
                            success:(void (^)(id responseObject))success
                            failure:(void(^)(NSError *error))failure {
    [CMMUtility showWaitingAlertView];
    NSMutableDictionary *param = [self buildParametersDic];
    
    [_httpRequest xsPostPath:kMyAssert delegate:delegate params:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [self catchNetResWithResInfo:responseObject success:success error:failure delegate:delegate path:kMyAssert];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        failure(error);
        [CMMUtility hideWaitingAlertView];
        [self showNoNetworkErrorPrompt:error];
    }];
}

// 获得产品详情
- (void)getProductDetailWithProductId:(NSString *)productId
                             delegate:(id)delegate
                              success:(void (^)(id responseObject))success
                              failure:(void(^)(NSError *error))failure {
    assert(productId);
    
    [CMMUtility showWaitingAlertView];
    NSMutableDictionary *param = [self buildParametersDic];
    [param setObject:productId forKey:@"productId"];
    [_httpRequest xsPostPath:kProductDetail delegate:delegate params:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [self catchNetResWithResInfo:responseObject success:success error:failure delegate:delegate path:kProductDetail];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        failure(error);
        [CMMUtility hideWaitingAlertView];
        [self showNoNetworkErrorPrompt:error];
    }];
}

// 注册账号
- (void)registerAccountWithPhoneNumber:(NSString *)phoneNumber
                              password:(NSString *)password
                                mcCode:(NSString *)mcCode
                              delegate:(id)delegate
                               success:(void (^)(id responseObject))success
                               failure:(void(^)(NSError *error))failure {
    assert(phoneNumber);
    assert(password);
    assert(mcCode);
    
    [CMMUtility showWaitingAlertView];
    NSMutableDictionary *param = [self buildParametersDic];
    [param setObject:phoneNumber forKey:@"mobile"];
    [param setObject:mcCode forKey:@"code"];
    [param setObject:password forKey:@"password"];
    [param setObject:password forKey:@"passwordAgain"];
    [param setObject:AppChannel forKey:@"channelId"];
    [param setObject:[CMMUtility obtainDeviceIDFA] forKey:@"idfa"];
    [param setObject:[CMMUtility macaddress] forKey:@"mac"];
    
    [_httpRequest xsPostPath:kRegister delegate:delegate params:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [self catchNetResWithResInfo:responseObject success:success error:failure delegate:delegate path:kRegister];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        failure(error);
        [CMMUtility hideWaitingAlertView];
        [self showNoNetworkErrorPrompt:error];
    }];
}

// 找回密码
- (void)resetPwsswordWithPhoneNumber:(NSString *)phoneNumber
                            passCode:(NSString *)passCode
                            passWord:(NSString *)password
                            delegate:(id)delegate
                             success:(void (^)(id responseObject))success
                             failure:(void(^)(NSError *error))failure {
    assert(phoneNumber);
    assert(password);
    assert(passCode);
    
    [CMMUtility showWaitingAlertView];
    NSMutableDictionary *param = [self buildParametersDic];
    [param setObject:phoneNumber forKey:@"mobile"];
    [param setObject:password forKey:@"password"];
    [param setObject:passCode forKey:@"code"];
    [param setObject:password forKey:@"passwordAgain"];
    
    [_httpRequest xsPostPath:kResetPwdKey delegate:delegate params:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [self catchNetResWithResInfo:responseObject success:success error:failure delegate:delegate path:kResetPwdKey];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        failure(error);
        [CMMUtility hideWaitingAlertView];
        [self showNoNetworkErrorPrompt:error];
    }];
}

// 帮助中心
- (void)helpCenterListWithPageSize:(NSNumber *)pageSize
                        pageNumber:(NSNumber *)pageNumber
                          delegate:(id)delegate
                           success:(void (^)(id responseObject))success
                           failure:(void(^)(NSError *error))failure {
    assert(pageSize);
    assert(pageNumber);
    if ([pageNumber intValue]==1) {
       [CMMUtility showWaitingAlertView];
    }

    NSMutableDictionary *param = [self buildParametersDic];
    [param setObject:pageSize forKey:@"pageSize"];
    [param setObject:pageNumber forKey:@"pageNow"];
    [_httpRequest xsPostPath:kHelpList delegate:delegate params:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [self catchNetResWithResInfo:responseObject success:success error:failure delegate:delegate path:kHelpList];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        failure(error);
        [CMMUtility hideWaitingAlertView];
        [self showNoNetworkErrorPrompt:error];
    }];
}

// 实名认证
- (void)authDictionary:(NSDictionary *)dict
            delegate:(id)delegate
             success:(void (^)(id responseObject))success
             failure:(void(^)(NSError *error))failure {
    
    [CMMUtility showWaitingAlertView];
//    NSMutableDictionary *param = [self buildParametersDic];
    NSMutableDictionary *param = [[NSMutableDictionary alloc] initWithDictionary:dict];
    [_httpRequest xsPostPath:kRealNameAuthenticate delegate:delegate params:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",(NSDictionary *)[responseObject objectFromJSONData]);
        
        [self catchNetResWithResInfo:responseObject success:success error:failure delegate:delegate path:kRealNameAuthenticate];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        failure(error);
        [CMMUtility hideWaitingAlertView];
        [self showNoNetworkErrorPrompt:error];
    }];
}

// 设置支付密码
- (void)setPayPassword:(NSString *)payPassword
              delegate:(id)delegate
               success:(void (^)(id responseObject))success
               failure:(void(^)(NSError *error))failure {
    assert(payPassword);
    
    [CMMUtility showWaitingAlertView];
    NSMutableDictionary *param = [self buildParametersDic];
    [param setObject:payPassword forKey:@"password"];
    [param setObject:payPassword forKey:@"passwordAgain"];
    
    [_httpRequest xsPostPath:kSetPayPass delegate:delegate params:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [self catchNetResWithResInfo:responseObject success:success error:failure delegate:delegate path:kSetPayPass];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        failure(error);
        [CMMUtility hideWaitingAlertView];
        [self showNoNetworkErrorPrompt:error];
    }];
}

// 我的银行卡
- (void)getMyBankCardWithProductId:(NSString *)productId
                          delegate:(id)delegate
                           success:(void (^)(id responseObject))success
                           failure:(void(^)(NSError *error))failure {
    assert(productId);
    
    [CMMUtility showWaitingAlertView];
    NSMutableDictionary *param = [self buildParametersDic];
    [param setObject:productId forKey:@"productId"];
    [_httpRequest xsPostPath:kMyBankCard delegate:delegate params:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [self catchNetResWithResInfo:responseObject success:success error:failure delegate:delegate path:kMyBankCard];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        failure(error);
        [CMMUtility hideWaitingAlertView];
        [self showNoNetworkErrorPrompt:error];
    }];
}

// 可用银行列表
- (void)getAvailableBankListWithProductChannelId:(NSString *)channelId
                                        delegate:(id)delegate
                                 success:(void (^)(id responseObject))success
                                 failure:(void(^)(NSError *error))failure {
    assert(channelId);
    
    [CMMUtility showWaitingAlertView];
    NSMutableDictionary *param = [self buildParametersDic];
    [param setObject:channelId forKey:@"productChannelId"];
    
    [_httpRequest xsPostPath:kAvailableCardList delegate:delegate params:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [self catchNetResWithResInfo:responseObject success:success error:failure delegate:delegate path:kAvailableCardList];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        failure(error);
        [CMMUtility hideWaitingAlertView];
        [self showNoNetworkErrorPrompt:error];
    }];
}

// 绑定银行卡
- (void)bindBankCardWithBankId:(NSString *)bankId
                bankCardNumber:(NSString *)bankCardNumber
              bankCardProvince:(NSString *)bankCardProvince
                  bankCardCity:(NSString *)bankCardCity
                bankBranchName:(NSString *)bankBranchName
            reservePhoneNumber:(NSString *)reservePhoneNumber
              productChannelId:(NSString *)productChannelId
                      delegate:(id)delegate
                       success:(void (^)(id responseObject))success
                       failure:(void(^)(NSError *error))failure {
    assert(bankId);
    assert(bankCardNumber);
    assert(bankCardProvince);
    assert(bankCardCity);
    assert(bankBranchName);
    assert(reservePhoneNumber);
    assert(productChannelId);
    
    [CMMUtility showWaitingAlertView];
    NSMutableDictionary *param = [self buildParametersDic];
    [param setObject:bankId forKey:@"bankId"];
    [param setObject:bankCardNumber forKey:@"bankCardNumber"];
    [param setObject:bankCardProvince forKey:@"bankCardProvince"];
    [param setObject:bankCardCity forKey:@"bankCardCity"];
    [param setObject:bankBranchName forKey:@"bankBranchName"];
    [param setObject:reservePhoneNumber forKey:@"reservePhoneNumber"];
    [param setObject:productChannelId forKey:@"productChannelId"];
    
    [_httpRequest xsPostPath:kRealNameAuthenticate delegate:delegate params:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [self catchNetResWithResInfo:responseObject success:success error:failure delegate:delegate path:kRealNameAuthenticate];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        failure(error);
        [CMMUtility hideWaitingAlertView];
        [self showNoNetworkErrorPrompt:error];
    }];
}

// 购买产品
- (void)buyProductWithProductId:(NSString *)productId
                         amount:(NSString *)amount
                 bankCardNumber:(NSString *)bankCardNumber
                    payPassword:(NSString *)payPassword
                       delegate:(id)delegate
                        success:(void (^)(id responseObject))success
                        failure:(void(^)(NSError *error))failure {
    assert(productId);
    assert(amount);
    assert(payPassword);
    
    [CMMUtility showWaitingAlertView];
    NSMutableDictionary *param = [self buildParametersDic];
    [param setObject:productId forKey:@"productId"];
    [param setObject:amount forKey:@"amount"];
    if (!QM_IS_STR_NIL(bankCardNumber)) {
        [param setObject:bankCardNumber forKey:@"userBankCardId"];
    }
    [param setObject:payPassword forKey:@"payPassword"];
    
    [_httpRequest xsPostPath:kBuyProduct delegate:delegate params:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [self catchNetResWithResInfo:responseObject success:success error:failure delegate:delegate path:kBuyProduct];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        failure(error);
        [CMMUtility hideWaitingAlertView];
        [self showNoNetworkErrorPrompt:error];
    }];
}

// 已购产品详情
- (void)getOrderResolveWithProductId:(NSString *)productId
                            delegate:(id)delegate
                             success:(void (^)(id responseObject))success
                             failure:(void(^)(NSError *error))failure {
    assert(productId);
    
    [CMMUtility showWaitingAlertView];
    NSMutableDictionary *param = [self buildParametersDic];
    [param setObject:productId forKey:@"productAccountId"];
    
    [_httpRequest xsPostPath:kOrderResolve delegate:delegate params:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [self catchNetResWithResInfo:responseObject success:success error:failure delegate:delegate path:kOrderResolve];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        failure(error);
        [CMMUtility hideWaitingAlertView];
        [self showNoNetworkErrorPrompt:error];
    }];
}

// 发送忘记密码验证码
- (void)getResetPwdPassCode:(NSString *)phoneNumber
                   delegate:(id)delegate
                    success:(void (^)(id responseObject))success
                    failure:(void(^)(NSError *error))failure {
    assert(phoneNumber);
    
    [CMMUtility showWaitingAlertView];
    NSMutableDictionary *param = [self buildParametersDic];
    [param setObject:phoneNumber forKey:@"mobile"];
    
    [_httpRequest xsPostPath:kSendBackPassCode delegate:delegate params:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [self catchNetResWithResInfo:responseObject success:success error:failure delegate:delegate path:kSendBackPassCode];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        failure(error);
        [CMMUtility hideWaitingAlertView];
        [self showNoNetworkErrorPrompt:error];
    }];
}

// 发送支付密码验证码
- (void)getResetPayPwdPassCodeWithDelegate:(id)delegate
                                   success:(void (^)(id responseObject))success
                                   failure:(void(^)(NSError *error))failure {
    
    [CMMUtility showWaitingAlertView];
    NSMutableDictionary *param = [self buildParametersDic];
    
    [_httpRequest xsPostPath:kSendBackPayPassCode delegate:delegate params:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [self catchNetResWithResInfo:responseObject success:success error:failure delegate:delegate path:kSendBackPassCode];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        failure(error);
        [CMMUtility hideWaitingAlertView];
        [self showNoNetworkErrorPrompt:error];
    }];
}

// 设置新的支付密码
- (void)setNewPayPasswordWithNewPayPassword:(NSString *)newPayPassword
                                      mCode:(NSString *)mCode
                               idCardNumber:(NSString *)idCardNumber
                                   delegate:(id)delegate
                                    success:(void (^)(id responseObject))success
                                    failure:(void(^)(NSError *error))failure {
    assert(newPayPassword);
    assert(mCode);
    assert(idCardNumber);
    
    [CMMUtility showWaitingAlertView];
    NSMutableDictionary *param = [self buildParametersDic];
    [param setObject:newPayPassword forKey:@"password"];
    [param setObject:newPayPassword forKey:@"passwordAgain"];
    [param setObject:mCode forKey:@"code"];
    [param setObject:idCardNumber forKey:@"idCardNumber"];
    
    [_httpRequest xsPostPath:kSetNewPayPass delegate:delegate params:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [self catchNetResWithResInfo:responseObject success:success error:failure delegate:delegate path:kSetNewPayPass];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        failure(error);
        [CMMUtility hideWaitingAlertView];
        [self showNoNetworkErrorPrompt:error];
    }];
}

// 积分相关
// 得到我的积分
- (void)getIntegralWithDelegate:(id)delegate
                        success:(void (^)(id responseObject))success
                        failure:(void(^)(NSError *error))failure {
    [CMMUtility showWaitingAlertView];
    NSMutableDictionary *param = [self buildParametersDic];
    
    [_httpRequest xsPostPath:kGetMyScore delegate:delegate params:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [self catchNetResWithResInfo:responseObject success:success error:failure delegate:delegate path:kGetMyScore];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        failure(error);
        [CMMUtility hideWaitingAlertView];
        [self showNoNetworkErrorPrompt:error];
    }];
}

// 得到兑换礼品列表信息
- (void)getGoodsListWithPageSize:(NSNumber *)pageSize
                      pageNumber:(NSNumber *)pageNumber
                        delegate:(id)delegate
                         success:(void (^)(id responseObject))success
                         failure:(void(^)(NSError *error))failure {
    [CMMUtility showWaitingAlertView];
    NSMutableDictionary *param = [self buildParametersDic];
    [param setObject:pageSize forKey:@"pageSize"];
    [param setObject:pageNumber forKey:@"pageNow"];
    
    [_httpRequest xsPostPath:kGoodsList delegate:delegate params:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [self catchNetResWithResInfo:responseObject success:success error:failure delegate:delegate path:kGoodsList];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        failure(error);
        [CMMUtility hideWaitingAlertView];
        [self showNoNetworkErrorPrompt:error];
    }];
}

// 使用积分兑换礼品
- (void)addIntegralExchangeWithGoodId:(NSString *)goodId
                             delegate:(id)delegate
                              success:(void (^)(id responseObject))success
                              failure:(void(^)(NSError *error))failure {
    assert(goodId);
    
    [CMMUtility showWaitingAlertView];
    NSMutableDictionary *param = [self buildParametersDic];
    [param setObject:goodId forKey:@"prizeId"];
    
    [_httpRequest xsPostPath:kAddIntegralExchange delegate:delegate params:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [self catchNetResWithResInfo:responseObject success:success error:failure delegate:delegate path:kAddIntegralExchange];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        failure(error);
        [CMMUtility hideWaitingAlertView];
        [self showNoNetworkErrorPrompt:error];
    }];
}

// 得到我的礼品兑换记录
- (void)myIntegralExchangeListWithPageSize:(NSNumber *)pageSize
                                pageNumber:(NSNumber *)pageNumber
                                  delegate:(id)delegate
                                   success:(void (^)(id responseObject))success
                                   failure:(void(^)(NSError *error))failure {
    assert(pageSize);
    assert(pageNumber);
    
    [CMMUtility showWaitingAlertView];
    NSMutableDictionary *param = [self buildParametersDic];
    [param setObject:pageSize forKey:@"pageSize"];
    [param setObject:pageNumber forKey:@"pageNow"];
    
    [_httpRequest xsPostPath:kMyIntegralExchangeList delegate:delegate params:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [self catchNetResWithResInfo:responseObject success:success error:failure delegate:delegate path:kMyIntegralExchangeList];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        failure(error);
        [CMMUtility hideWaitingAlertView];
        [self showNoNetworkErrorPrompt:error];
    }];
}

// 重置密码
- (void)resetPasswordWithOldPwd:(NSString *)oldPwd
                    newPassword:(NSString *)newPwd
                       delegate:(id)delegate
                        success:(void (^)(id responseObject))success
                        failure:(void(^)(NSError *error))failure {
    assert(oldPwd);
    assert(newPwd);
    
    [CMMUtility showWaitingAlertView];
    NSMutableDictionary *param = [self buildParametersDic];
    [param setObject:oldPwd forKey:@"oldPassword"];
    [param setObject:newPwd forKey:@"newPassword"];
    [param setObject:newPwd forKey:@"newPasswordAgain"];
    
    [_httpRequest xsPostPath:kResetPassword delegate:delegate params:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [self catchNetResWithResInfo:responseObject success:success error:failure delegate:delegate path:kResetPassword];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        failure(error);
        [CMMUtility hideWaitingAlertView];
        [self showNoNetworkErrorPrompt:error];
    }];
}

// 风险控制
- (void)getProductWindControlWithProductId:(NSString *)productId
                                  delegate:(id)delegate
                                   success:(void (^)(id responseObject))success
                                   failure:(void(^)(NSError *error))failure {
    assert(productId);
    
    [CMMUtility showWaitingAlertView];
    NSMutableDictionary *param = [self buildParametersDic];
    [param setObject:productId forKey:@"productId"];
    
    [_httpRequest xsPostPath:kProductWindControl delegate:delegate params:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [self catchNetResWithResInfo:responseObject success:success error:failure delegate:delegate path:kProductWindControl];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        failure(error);
        [CMMUtility hideWaitingAlertView];
        [self showNoNetworkErrorPrompt:error];
    }];
}

// 项目介绍
- (void)getProductIntroductionWithProductId:(NSString *)productId
                                   delegate:(id)delegate
                                    success:(void (^)(id responseObject))success
                                    failure:(void(^)(NSError *error))failure {
    assert(productId);
    
    [CMMUtility showWaitingAlertView];
    NSMutableDictionary *param = [self buildParametersDic];
    [param setObject:productId forKey:@"productId"];
    
    [_httpRequest xsPostPath:kProductIntroduction delegate:delegate params:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [self catchNetResWithResInfo:responseObject success:success error:failure delegate:delegate path:kProductIntroduction];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        failure(error);
        [CMMUtility hideWaitingAlertView];
        [self showNoNetworkErrorPrompt:error];
    }];
}

// 是否可以购买
- (void)checkProductCanBuyWithProductId:(NSString *)productId
                               delegate:(id)delegate
                                success:(void (^)(id responseObject))success
                                failure:(void(^)(NSError *error))failure {
    assert(productId);
    
    [CMMUtility showWaitingAlertView];
    NSMutableDictionary *param = [self buildParametersDic];
    [param setObject:productId forKey:@"productId"];
    
    [_httpRequest xsPostPath:kProductCanBuy delegate:delegate params:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [self catchNetResWithResInfo:responseObject success:success error:failure delegate:delegate path:kProductCanBuy];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        failure(error);
        [CMMUtility hideWaitingAlertView];
        [self showNoNetworkErrorPrompt:error];
    }];
}

// 修改支付密码
- (void)modifyPayPwdWithOldPwd:(NSString *)oldPwd
                newPayPassword:(NSString *)newPayPassword
                      delegate:(id)delegate
                       success:(void (^)(id responseObject))success
                       failure:(void(^)(NSError *error))failure {
    assert(oldPwd);
    assert(newPayPassword);
    
    [CMMUtility showWaitingAlertView];
    NSMutableDictionary *param = [self buildParametersDic];
    [param setObject:oldPwd forKey:@"oldPassword"];
    [param setObject:newPayPassword forKey:@"newPassword"];
    [param setObject:newPayPassword forKey:@"newPasswordAgain"];
    
    [_httpRequest xsPostPath:kModifyPayPass delegate:delegate params:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [self catchNetResWithResInfo:responseObject success:success error:failure delegate:delegate path:kModifyPayPass];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        failure(error);
        [CMMUtility hideWaitingAlertView];
        [self showNoNetworkErrorPrompt:error];
    }];
}

- (void)getContractTemplateForProduct:(NSString *)productId
                             delegate:(id)delegate
                              success:(void (^)(id responseObject))success
                              failure:(void(^)(NSError *error))failure {
    assert(productId);
    
    [CMMUtility showWaitingAlertView];
    NSMutableDictionary *param = [self buildParametersDic];
    [param setObject:productId forKey:@"productId"];
    
    [_httpRequest xsPostPath:kProductAgreementTemplate delegate:delegate params:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [self catchNetResWithResInfo:responseObject success:success error:failure delegate:delegate path:kProductAgreementTemplate];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        failure(error);
        [CMMUtility hideWaitingAlertView];
        [self showNoNetworkErrorPrompt:error];
    }];
}

// 购买后的产品合同
- (void)getBuyedProductAgreementTemplateWithAccountId:(NSString *)accountId
                                             delegate:(id)delegate
                                              success:(void (^)(id responseObject))success
                                              failure:(void(^)(NSError *error))failure {
    assert(accountId);
    
    [CMMUtility showWaitingAlertView];
    NSMutableDictionary *param = [self buildParametersDic];
    [param setObject:accountId forKey:@"productSubAccountId"];
    
    [_httpRequest xsPostPath:kBuyedProductAgreementTemplate delegate:delegate params:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [self catchNetResWithResInfo:responseObject success:success error:failure delegate:delegate path:kBuyedProductAgreementTemplate];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        failure(error);
        [CMMUtility hideWaitingAlertView];
        [self showNoNetworkErrorPrompt:error];
    }];
}

// @new 查看产品详细信息
- (void)getDetailProductInfoWithProductId:(NSString *)productId
                                 delegate:(id)delegate
                                  success:(void (^)(id responseObject))success
                                  failure:(void(^)(NSError *error))failure {
    //assert(productId);
    
    [CMMUtility showWaitingAlertView];
    NSMutableDictionary *param = [self buildParametersDic];
    [param setObject:productId forKey:@"productId"];
    
    [_httpRequest xsPostPath:kDetailProduct delegate:delegate params:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [self catchNetResWithResInfo:responseObject success:success error:failure delegate:delegate path:kDetailProduct];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        failure(error);
        [CMMUtility hideWaitingAlertView];
        [self showNoNetworkErrorPrompt:error];
    }];
}

- (void)openProductAccountWithProductChannelId:(NSString *)channelId
                                      delegate:(id)delegate
                                       success:(void (^)(id responseObject))success
                                       failure:(void(^)(NSError *error))failure {
    assert(channelId);
    
    [CMMUtility showWaitingAlertView];
    NSMutableDictionary *param = [self buildParametersDic];
    [param setObject:channelId forKey:@"productChannelId"];
    
    [_httpRequest xsPostPath:kOpenProductAccount delegate:delegate params:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [self catchNetResWithResInfo:responseObject success:success error:failure delegate:delegate path:kOpenProductAccount];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        failure(error);
        [CMMUtility hideWaitingAlertView];
        [self showNoNetworkErrorPrompt:error];
    }];
}

// 注册服务协议
- (void)getRegisterAgreementWithDelegate:(id)delegate
                                 success:(void (^)(id responseObject))success
                                 failure:(void(^)(NSError *error))failure {
    [CMMUtility showWaitingAlertView];
    NSMutableDictionary *param = [self buildParametersDic];
    
    [_httpRequest xsPostPath:kRegisterAgreement delegate:delegate params:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [self catchNetResWithResInfo:responseObject success:success error:failure delegate:delegate path:kRegisterAgreement];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        failure(error);
        [CMMUtility hideWaitingAlertView];
        [self showNoNetworkErrorPrompt:error];
    }];
}

// 隐私条款
- (void)getPrivacyAgreementWithDelegate:(id)delegate
                                success:(void (^)(id responseObject))success
                                failure:(void(^)(NSError *error))failure {
    [CMMUtility showWaitingAlertView];
    NSMutableDictionary *param = [self buildParametersDic];
    
    [_httpRequest xsPostPath:kPrivacyAgreement delegate:delegate params:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [self catchNetResWithResInfo:responseObject success:success error:failure delegate:delegate path:kPrivacyAgreement];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        failure(error);
        [CMMUtility hideWaitingAlertView];
        [self showNoNetworkErrorPrompt:error];
    }];
}

//@new 安全
- (void)getSecurityTemplateWithDelegate:(id)delegate
                                success:(void (^)(id responseObject))success
                                failure:(void(^)(NSError *error))failure {
    [CMMUtility showWaitingAlertView];
    NSMutableDictionary *param = [self buildParametersDic];
    
    [_httpRequest xsPostPath:kSecurityTemplate delegate:delegate params:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [self catchNetResWithResInfo:responseObject success:success error:failure delegate:delegate path:kSecurityTemplate];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        failure(error);
        [CMMUtility hideWaitingAlertView];
        [self showNoNetworkErrorPrompt:error];
    }];
}

//@new 支付
- (void)getSequestrateAgreementWithDelegate:(id)delegate
                                    success:(void (^)(id responseObject))success
                                    failure:(void(^)(NSError *error))failure {
    [CMMUtility showWaitingAlertView];
    NSMutableDictionary *param = [self buildParametersDic];
    
    [_httpRequest xsPostPath:kSequestrateAgreement delegate:delegate params:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [self catchNetResWithResInfo:responseObject success:success error:failure delegate:delegate path:kSequestrateAgreement];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        failure(error);
        [CMMUtility hideWaitingAlertView];
        [self showNoNetworkErrorPrompt:error];
    }];
}

// 活动和消息的最后创建时间
- (void)getMsgActivityLastUpdateTimeWithDelegate:(id)delegate
                                         success:(void (^)(id responseObject))success
                                         failure:(void(^)(NSError *error))failure {
    NSMutableDictionary *param = [self buildParametersDic];
    
    [_httpRequest xsPostPath:kMsgActivityLastUpdateTime delegate:delegate params:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [self catchNetResWithResInfo:responseObject success:success error:failure delegate:delegate path:kMsgActivityLastUpdateTime];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
}

// 获取省份列表
- (void)getProvinceListWithDelegate:(id)delegate
                            success:(void (^)(id responseObject))success
                            failure:(void(^)(NSError *error))failure {
    [CMMUtility showWaitingAlertView];
    NSMutableDictionary *param = [self buildParametersDic];
    [_httpRequest xsPostPath:kProvinceList delegate:delegate params:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [self catchNetResWithResInfo:responseObject success:success error:failure delegate:delegate path:kProvinceList];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
        [CMMUtility hideWaitingAlertView];
        [self showNoNetworkErrorPrompt:error];
    }];
}

// 获取城市列表
- (void)getCityListWithProvinceCode:(NSString *)code
                           delegate:(id)delegate
                            success:(void (^)(id responseObject))success
                            failure:(void(^)(NSError *error))failure {
    [CMMUtility showWaitingAlertView];
    
    NSMutableDictionary *param = [self buildParametersDic];
    [param setObject:code forKey:@"provinceCode"];
    [_httpRequest xsPostPath:kCityList delegate:delegate params:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [self catchNetResWithResInfo:responseObject success:success error:failure delegate:delegate path:kCityList];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
        [CMMUtility hideWaitingAlertView];
        [self showNoNetworkErrorPrompt:error];
    }];
}

// 获取支行信息
- (void)getBankBranchInfoWithCardNumber:(NSString *)cardNumber
                             branchName:(NSString *)branchName
                               cityCode:(NSString *)cityCode
                               delegate:(id)delegate
                                success:(void (^)(id responseObject))success
                                failure:(void(^)(NSError *error))failure {
    [CMMUtility showWaitingAlertView];
    NSMutableDictionary *param = [self buildParametersDic];
    [param setObject:cardNumber forKey:@"cardNumber"];
    [param setObject:branchName forKey:@"branch"];
    [param setObject:cityCode forKey:@"cityCode"];
    
    [_httpRequest xsPostPath:kBankBranchInfo delegate:delegate params:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [self catchNetResWithResInfo:responseObject success:success error:failure delegate:delegate path:kBankBranchInfo];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
        [CMMUtility hideWaitingAlertView];
        [self showNoNetworkErrorPrompt:error];
    }];
}

// 支付申请发起
-(void)rechargeRequestWithDelegate:(id) delegate userBankCardId:(NSString *)userBankCardId amount:(NSString *) amount
                           success:(void (^)(id responseObject))success
                           failure:(void(^)(NSError *error))failure{
    
    NSMutableDictionary *param = [self buildParametersDic];
    [param setObject:userBankCardId forKey:@"userBankCardId"];
        [param setObject:amount forKey:@"amount"];
        [param setObject:@"2" forKey:@"productChannelId"];
    
    [_httpRequest xsPostPath:kRechargeRequest delegate:delegate params:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [self catchNetResWithResInfo:responseObject success:success error:failure delegate:delegate path:kRechargeRequest];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];

}

// SDK 充值结果回传
- (void)sendRechargeResultWithParam:(NSDictionary *)param1
                           delegate:(id)delegate
                            success:(void (^)(id responseObject))success
                            failure:(void(^)(NSError *error))failure {
    NSMutableDictionary *param = [self buildParametersDic];
    
    NSData *json = [NSJSONSerialization dataWithJSONObject:param1 options:NSJSONWritingPrettyPrinted error:nil];
    NSString *str = [[NSString alloc] initWithData:json encoding:NSUTF8StringEncoding];
    if (!QM_IS_STR_NIL(str)) {
        [param setObject:str forKey:@"response"];
    }
    
    [_httpRequest xsPostPath:kRechargeResult delegate:delegate params:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [self catchNetResWithResInfo:responseObject success:success error:failure delegate:delegate path:kRechargeResult];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
}

// 充值记录查询
- (void)getRechargeRecordListWithChannelId:(NSString *)channelId
                                  pageSize:(NSNumber *)pageSize
                                pageNumber:(NSNumber *)pageNumber
                                  delegate:(id)delegate
                                   success:(void (^)(id responseObject))success
                                   failure:(void(^)(NSError *error))failure {
    assert(channelId);
    assert(pageSize);
    assert(pageNumber);
    
    NSMutableDictionary *param = [self buildParametersDic];
    [param setObject:channelId forKey:@"productChannelId"];
    [param setObject:pageSize forKey:@"pageSize"];
    [param setObject:pageNumber forKey:@"pageNow"];
    
    [_httpRequest xsPostPath:kListRechargeRecord delegate:delegate params:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [self catchNetResWithResInfo:responseObject success:success error:failure delegate:delegate path:kListRechargeRecord];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
}

// 提现申请
- (void)withWithDrawApplyWithChannelId:(NSString *)channelId
                                   pwd:(NSString *)pwd
                            bankCardId:(NSString *)cardId
                                amount:(NSString *)amount
                              delegate:(id)delegate
                               success:(void (^)(id responseObject))success
                               failure:(void(^)(NSError *error))failure {
    assert(channelId);
    assert(cardId);
    assert(amount);
        [CMMUtility showWaitingAlertView];
    
    NSMutableDictionary *param = [self buildParametersDic];
    [param setObject:cardId forKey:@"userBankCardId"];
    [param setObject:amount forKey:@"amount"];
    [param setObject:channelId forKey:@"productChannelId"];
    [param setObject:pwd forKey:@"payPassword"];
    
    [_httpRequest xsPostPath:kWithdrawApply delegate:delegate params:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [self catchNetResWithResInfo:responseObject success:success error:failure delegate:delegate path:kWithdrawApply];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
}

// 提现记录
- (void)getWithDrawRecordListWithChannelId:(NSString *)channelId
                                  pageSize:(NSNumber *)pageSize
                                pageNumber:(NSNumber *)pageNumber
                                  delegate:(id)delegate
                                   success:(void (^)(id responseObject))success
                                   failure:(void(^)(NSError *error))failure {
    assert(channelId);
    assert(pageSize);
    assert(pageNumber);
    
    NSMutableDictionary *param = [self buildParametersDic];
    [param setObject:channelId forKey:@"productChannelId"];
    [param setObject:pageSize forKey:@"pageSize"];
    [param setObject:pageNumber forKey:@"pageNow"];
    
    [_httpRequest xsPostPath:kListWithdrawalRecord delegate:delegate params:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [self catchNetResWithResInfo:responseObject success:success error:failure delegate:delegate path:kListWithdrawalRecord];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
}

// 添加银行卡
- (void)newAddBankCardWithChannelId:(NSString *)channelId
                             bankId:(NSString *)bankId
                     bankCardNumber:(NSString *)cardNumber
                       provinceCode:(NSString *)provinceCode
                           cityCode:(NSString *)cityCode
                         branchName:(NSString *)branchName
                        phoneNumber:(NSString *)phoneNumbaer
                           delegate:(id)delegate
                            success:(void (^)(id responseObject))success
                            failure:(void(^)(NSError *error))failure {
    assert(channelId);
    assert(bankId);
    assert(cardNumber);
    assert(provinceCode);
    assert(cityCode);
    assert(branchName);
//    assert(prcptcd);
    
    NSMutableDictionary *param = [self buildParametersDic];
    [param setObject:bankId forKey:@"bankId"];
    [param setObject:cardNumber forKey:@"bankCardNum"];
    [param setObject:provinceCode forKey:@"provinceCode"];
    [param setObject:phoneNumbaer forKey:@"mobile"];
    [param setObject:cityCode forKey:@"cityCode"];
    [param setObject:branchName forKey:@"branch"];
    [param setObject:channelId forKey:@"productChannelId"];
//    [param setObject:prcptcd forKey:@"prcptcd"];
    
    [_httpRequest xsPostPath:kRealNameAuthenticate delegate:delegate params:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [self catchNetResWithResInfo:responseObject success:success error:failure delegate:delegate path:kRealNameAuthenticate];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
}

// 获取当前余额
- (void)getAvailableMoneyWithDelegate:(id)delegate
                              success:(void (^)(id responseObject))success
                              failure:(void(^)(NSError *error))failure {
    NSMutableDictionary *param = [self buildParametersDic];
    [param setObject:@"2" forKey:@"productChannelId"];
    
    [_httpRequest xsPostPath:kAvailableMoney delegate:delegate params:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [self catchNetResWithResInfo:responseObject success:success error:failure delegate:delegate path:kAvailableMoney];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
}

// 投资记录
- (void)getProductAccountListWithDelegate:(id)delegate
                                  success:(void (^)(id responseObject))success
                                  failure:(void(^)(NSError *error))failure {
    NSMutableDictionary *param = [self buildParametersDic];
    
    [_httpRequest xsPostPath:kProductAccountList delegate:delegate params:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [self catchNetResWithResInfo:responseObject success:success error:failure delegate:delegate path:kProductAccountList];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
}

// 获取银行卡列表
- (void)getBankCardListByChannelId:(NSString *)channelId
                          delegate:(id)delegate
                           success:(void (^)(id responseObject))success
                           failure:(void(^)(NSError *error))failure {
    NSMutableDictionary *param = [self buildParametersDic];
    [param setValue:channelId forKey:@"productChannelId"];
    [_httpRequest xsPostPath:kUserBankCardListByChannelId delegate:delegate params:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [self catchNetResWithResInfo:responseObject success:success error:failure delegate:delegate path:kUserBankCardListByChannelId];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
}


// 利率计算
- (void)getProductCountInterestWithProductId:(NSString *)productId
                                      amount:(NSString *)amount
                                    delegate:(id)delegate
                                     success:(void (^)(id responseObject))success
                                     failure:(void(^)(NSError *error))failure {
    assert(productId);
    assert(amount);
    NSMutableDictionary *param = [self buildParametersDic];
    [param setValue:productId forKey:@"productId"];
    [param setValue:amount forKey:@"amount"];
    [_httpRequest xsPostPath:kCountInterest delegate:delegate params:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [self catchNetResWithResInfo:responseObject success:success error:failure delegate:delegate path:kCountInterest];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
    
}
//交易明细
- (void)getDealDetailWithoffset:(NSInteger)offset
                       pageSize:(NSInteger)pageSize
                       delegate:(id)delegate
                        success:(void (^)(id responseObject))success
                        failure:(void(^)(NSError *error))failure{
    if (offset==1) {
    [CMMUtility showWaitingAlertView];
    }
    
    NSMutableDictionary *param = [self buildParametersDic];
    [param setValue:[NSNumber numberWithInteger:offset] forKey:@"pageNow"];
    [param setValue:[NSNumber numberWithInteger:pageSize] forKey:@"pageSize"];

    [_httpRequest xsPostPath:kDealDetail delegate:delegate params:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [self catchNetResWithResInfo:responseObject success:success error:failure delegate:delegate path:kDealDetail];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        failure(error);
        [CMMUtility hideWaitingAlertView];
        [self showNoNetworkErrorPrompt:error];
    }];

}
//钱豆明细
- (void)getGoodListDetailWithoffset:(NSInteger)offset
                           pageSize:(NSInteger)pageSize
                           delegate:(id)delegate
                            success:(void (^)(id responseObject))success
                            failure:(void(^)(NSError *error))failure{
    if (offset==1) {
     [CMMUtility showWaitingAlertView];
    }
    NSMutableDictionary *param = [self buildParametersDic];
    [param setValue:[NSNumber numberWithInteger:offset] forKey:@"pageNow"];
    [param setValue:[NSNumber numberWithInteger:pageSize] forKey:@"pageSize"];
    
    [_httpRequest xsPostPath:kGoodListDetail delegate:delegate params:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [self catchNetResWithResInfo:responseObject success:success error:failure delegate:delegate path:kGoodListDetail];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        failure(error);
        [CMMUtility hideWaitingAlertView];
        [self showNoNetworkErrorPrompt:error];
    }];
}
//用户可用于购买某个产品的代金券
- (void)getUsableDJQWithProductId:(NSString *)productId
                         delegate:(id)delegate
                          success:(void (^)(id responseObject))success
                          failure:(void(^)(NSError *error))failure{
    [CMMUtility showWaitingAlertView];
    NSMutableDictionary *param = [self buildParametersDic];
    [param setValue:productId forKey:@"productId"];
    
    [_httpRequest xsPostPath:kUsableDJQ delegate:delegate params:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [self catchNetResWithResInfo:responseObject success:success error:failure delegate:delegate path:kUsableDJQ];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        failure(error);
        [CMMUtility hideWaitingAlertView];
        [self showNoNetworkErrorPrompt:error];
    }];

    
}
//使用代金券购买
- (void)getButTicketwithProductId:(NSString *)productId
                            share:(NSInteger)share
                      payPassword:(NSString *)payPassword
                       ticketCode:(NSString *)ticketCode
                         delegate:(id)delegate
                          success:(void (^)(id responseObject))success
                          failure:(void(^)(NSError *error))failure{
    
    
    [CMMUtility showWaitingAlertView];
    NSMutableDictionary *param = [self buildParametersDic];
    [param setValue:productId forKey:@"productId"];
    [param setValue:[NSNumber numberWithInteger:share] forKey:@"share"];
    [param setValue:payPassword forKey:@"payPassword"];
    [param setValue:ticketCode forKey:@"ticketCode"];
    [_httpRequest xsPostPath:kBuyTicket delegate:delegate params:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [self catchNetResWithResInfo:responseObject success:success error:failure delegate:delegate path:kBuyTicket];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        failure(error);
        [CMMUtility hideWaitingAlertView];
        [self showNoNetworkErrorPrompt:error];
    }];
}
//我的可用代金券
- (void)getMyUseCouponListWithdelegate:(id)delegate
                               success:(void (^)(id responseObject))success
                               failure:(void(^)(NSError *error))failure{
    
    
    
    [CMMUtility showWaitingAlertView];
    NSMutableDictionary *param = [self buildParametersDic];
    [_httpRequest xsPostPath:kCanUseCoupon delegate:delegate params:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [self catchNetResWithResInfo:responseObject success:success error:failure delegate:delegate path:kCanUseCoupon];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        failure(error);
        [CMMUtility hideWaitingAlertView];
        [self showNoNetworkErrorPrompt:error];
    }];
    
}

//我的已使用代金券列表
- (void)getDidUseCouponListWithdelegate:(id)delegate
                                success:(void (^)(id responseObject))success
                                failure:(void(^)(NSError *error))failure{
    [CMMUtility showWaitingAlertView];
    NSMutableDictionary *param = [self buildParametersDic];
    [_httpRequest xsPostPath:kDidUseCoupon delegate:delegate params:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [self catchNetResWithResInfo:responseObject success:success error:failure delegate:delegate path:kDidUseCoupon];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        failure(error);
        [CMMUtility hideWaitingAlertView];
        [self showNoNetworkErrorPrompt:error];
    }];

    
}

//我的奖励列表
- (void)getMyAwardListWithdelegate:(id)delegate
                           success:(void (^)(id responseObject))success
                           failure:(void(^)(NSError *error))failure{
    [CMMUtility showWaitingAlertView];
    NSMutableDictionary *param = [self buildParametersDic];
    [_httpRequest xsPostPath:kMyAward delegate:delegate params:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [self catchNetResWithResInfo:responseObject success:success error:failure delegate:delegate path:kMyAward];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        failure(error);
        [CMMUtility hideWaitingAlertView];
        [self showNoNetworkErrorPrompt:error];
    }];

    
}
//购买产品详情
- (void)getBuyProductDetailWithProductId:(NSString *)productId
                               ChannelId:(NSString *)channelId
                                delegate:(id)delegate
                                 success:(void (^)(id responseObject))success
                                 failure:(void(^)(NSError *error))failure{
    [CMMUtility showWaitingAlertView];
    NSMutableDictionary *param = [self buildParametersDic];
    [param setValue:channelId forKey:@"productChannelId"];
    [param setValue:productId forKey:@"productId"];
    [_httpRequest xsPostPath:kBuyProductDetail delegate:delegate params:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [self catchNetResWithResInfo:responseObject success:success error:failure delegate:delegate path:kBuyProductDetail];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];

    
}
// 获取支付方式
- (void)getRechargeRouteWithUserBankCardId:(NSString *)userBankCardId
                                    amount:(NSString *)amount
                          productChannelId:(NSString *)productChannelId
                                  delegate:(id)delegate
                                   success:(void (^)(id responseObject))success
                                   failure:(void(^)(NSError *error))failure {
    assert(userBankCardId);
    assert(amount);
    assert(productChannelId);
    
    NSMutableDictionary *param = [self buildParametersDic];
    [param setValue:userBankCardId forKey:@"userBankCardId"];
    [param setValue:amount forKey:@"amount"];
    [param setValue:productChannelId forKey:@"productChannelId"];
    
    [_httpRequest xsPostPath:kRechargeRounte delegate:delegate params:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",(NSDictionary *)[responseObject objectFromJSONData]);
        [self catchNetResWithResInfo:responseObject success:success error:failure delegate:delegate path:kRechargeRounte];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
}
- (void)getAboutMessageWithdelegate:(id)delegate
                            success:(void (^)(id responseObject))success
                            failure:(void(^)(NSError *error))failure{
    [_httpRequest xsPostPath:kAbout delegate:delegate params:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [self catchNetResWithResInfo:responseObject success:success error:failure delegate:delegate path:kAbout];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];

}
- (void)showNoNetworkErrorPrompt:(NSError *)error {
    if ([error code] == -1004) {
        [CMMUtility showNote:QMLocalizedString(@"qm_no_network_error", @"未检测到网络，请检查网络配置")];
    }
}

-(NSMutableDictionary *)buildParametersDic {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    return dic;
}

@end
