#import <Foundation/Foundation.h>
#import "AFHTTPClient+xiangshang.h"
#import "QMAccountInfo.h"

//@new 活动中心
#define kMsgList                @"activity/list"

//@new 消息中心
#define kMessageList            @"message/list"

//@new 帮助中心
#define kHelpList               @"help/list"

//@new 精品推荐
#define kRecommend              @"recommend"

//@new 产品列表
#define kProductList            @"product/list"

// 债权转让产品列表
#define kCreditorsList          @"trproduct/list"

//@new 注册验证码
#define kSendRegisterCode       @"registerCode"

//@new 设置登录密码
#define kResetPwdKey            @"account/resetLoginPassword"

//@new 用户登录
#define kUserLogin              @"login"

//@new 用户登出
#define kUserLogOut             @"logout"

//@new 检查更新
#define kUPdate                 @"version/check"

// 积分相关
//@new 得到我的积分
#define kGetMyScore             @"customerScore/score"

//@new 得到兑换礼品列表信息
#define kGoodsList              @"prize/listNew"

//@new 使用积分兑换礼品
#define kAddIntegralExchange    @"winners/exchange"

//@new 得到我的礼品兑换记录
#define kMyIntegralExchangeList @"winners/list"

// @new 是否可以购买
#define kProductCanBuy          @"product/isCanBuy"

//@new 获得产品详情
#define kProductDetail          @"product/productInfo"

//债权转让产品详情
#define kCreditorsDetail        @"trproduct/productInfo"

//@new 重置密码
#define kResetPassword          @"account/updateLoginPassword"

//@new 我的资产
#define kMyAssert               @"account/indexNew"

//@new 设置支付密码
#define kSetPayPass             @"account/addPayPassword"

//@new 实名认证
//#define kRealNameAuthenticate @"account/identityVerification"
#define kRealNameAuthenticate   @"account/identityVerification2"

//@new 我的银行卡
#define kMyBankCard             @"userBankCard/list"

//@new 可用银行列表
#define kAvailableCardList      @"bank/listByProductChannel"

//@new 发送忘记密码验证码
#define kSendBackPassCode       @"resetLoginPasswordCode"

//@new 发送支付密码验证码
#define kSendBackPayPassCode    @"account/resetPayPasswordCode"

//@new 重置支付密码
#define kSetNewPayPass          @"account/resetPayPassword"

//@new 修改支付密码
#define kModifyPayPass          @"account/updatePayPassword"

//@new 已购产品详情
#define kOrderResolve           @"account/productAccount"

// @new 合同模版
#define kProductAgreementTemplate @"product/productAgreementTemplate"

//@new 购买后的产品合同
#define kBuyedProductAgreementTemplate @"account/productAgreement"

//@new 风险控制
#define kProductWindControl     @"product/productRisk"

//@new 项目介绍
#define kProductIntroduction    @"product/productDesc"

//@new 查看产品详细信息
#define kDetailProduct          @"product/detailProduct"

//@new 购买产品
#define kBuyProduct             @"product/buy"

//@new 绑定银行卡
#define kBindBankCard           @"userBankCard/bindBankCard"

//@new 注册账号
#define kRegister               @"registerForIos"

//@new 开通渠道账户
#define kOpenProductAccount     @"account/openProductAccount"

//@new 注册服务协议
#define kRegisterAgreement      @"agreement/registerAgreement"

//@new 隐私条款
#define kPrivacyAgreement       @"agreement/privacyAgreement"

//@new 风险提示
#define KRiskAgreement          @"agreement/riskAgreement"

//@new 安全
#define kSecurityTemplate       @"template/securityTemplate"

//@new 支付
#define kSequestrateAgreement   @"agreement/sequestrateAgreement"


#define kAvailableMoney         @"account/available"


////////////////////
//用户是否已经注册
#define kUserRegisteredCheck    @"isRegistered"

// 活动和消息的最后创建时间
#define kMsgActivityLastUpdateTime @"more/dot"

// 省份列表
#define kProvinceList           @"province/list"

// 城市
#define kCityList               @"city/list"

// 查询支行信息
#define kBankBranchInfo         @"bank/branchQuery"

// 支付充值发起
#define kRechargeRequest        @"account/rechargeRequest"

// SDK 充值结果回传
#define kRechargeResult         @"account/rechargeResult"

// 充值记录查询
#define kListRechargeRecord     @"account/listRechargeRecord"

// 提现申请
#define kWithdrawApply          @"account/withdrawApply"

// 提现记录
#define kListWithdrawalRecord   @"account/listWithdrawalRecord"

// 添加银行卡
#define kBankCardAdd            @"bankCard/addWithoutPrcptcd"

// 投资记录
#define kProductAccountList     @"account/productAccountList"

// 获取银行卡列表
#define kUserBankCardListByChannelId @"userBankCard/listByChannelId"

// 利率计算
#define kCountInterest          @"product/countInterest"

// 交易明细
#define kDealDetail             @"account/customerPointHistory"

//钱豆明细
#define kGoodListDetail         @"customerScore/scoreRecordlist"

//ticket/usableDJQ
//用户可用于购买某个产品的代金券
#define kUsableDJQ              @"ticket/usableDJQ"

//使用代金券进行购买
#define kBuyTicket              @"product/buyWithTicket"

//我的可用代金券
#define kCanUseCoupon           @"ticket/listAllUsableDJQ"

//我的已使用代金券列表
#define kDidUseCoupon           @"ticket/listAllOverDJQ"

//我的奖励列表
#define kMyAward                @"customer/listMyAward"

//购买产品详情
#define kBuyProductDetail       @"product/availableAndDjqCount"

// 获取支付方式
#define kRechargeRounte         @"pay/rechargeRounte"

//about
#define kAbout                  @"rest/qianmamabout"

//广告图片获取
#define kAdvertisement          @"V2/activity/recommend"

//上传token
#define kPostToken              @"V2/updateCustomerMobileToken"

//获取首页运行数据
#define kGetHomedata            @"index/yunyingdata"

//首页中心活动图
#define kHomeMiddleLink         @"index/middlelink"

//设置绑定银行卡
#define kSetWithDrawCard        @"bankCard/setWithdrawCard"

//验证码回调数据
#define kSendVerifyCodeMessage  @"checkImageCode"

//检验手机是否注册
#define kMobileRegisted         @"mobileRegistered"

//即将过期的积分
#define kWillTimeOutScore       @"customerScore/cleanScore"

//获取银行卡限额
#define kGetBankQuota           @"bank/bankInfo"

//业务员佣金详情
#define kGetBusinessAmount      @"inviter/mydata"

//省份信息列表
#define kGetProvinceInfo        @"theme/assets/json/city.json"

//贵州银行存管短信验证码
#define kGetBankMessageCode     @"chinapnr/sendsms"

//用户开户接口
#define kOpenAccount            @"chinapnr/openAcctForm"

//用户激活接口
#define kActivationAccount      @"chinapnr/acctActivation"

//用户换绑卡接口
#define kChangeBankCard         @"chinapnr/changeCard"

//新充值接口
#define kNewRecharge            @"chinapnr/recharge"

//新提现接口
#define kNewWithDraw            @"chinapnr/withdraw"

//获取提现限额
#define kGetWithDrawPermitAmt   @"chinapnr/withdraw/getPermitAmt"

/**
 网络访问的服务类
 */
@interface NetServiceManager : NSObject

typedef enum {
    RebindBankMessageTypeOldCard     = 0,
    RebindBankMessageTypeNewCard     = 1,
} RebindBankMessageType;

+(NetServiceManager *)sharedInstance;

-(void)testServiceWithURL:(NSString *)url
                 delegate:(id)delegate
                   params:(NSDictionary *)params
                  success:(void (^)( id responseObject))success
                  failure:(void (^)( NSError *error))failure;


/**
 发送注册验证码
 @param phoneNumber 手机号码
 @param delegate 代理
 @returns void
 */
-(void)sendUserRegisterMsgCodeWithPhoneNumber:(NSString *)phoneNumber
                                     delegate:(id)delegate
                                      success:(void (^)( id responseObject))success
                                      failure:(void (^)( NSError *error))failure;

/**
 用户手机号是否已经存在
 @param phoneNumber 手机号码
 @param delegate 代理
 @returns void
 */
-(void)checkUserExitingWithPhoneNumber:(NSString *)phoneNumber
                              delegate:(id)delegate
                               success:(void (^)( id responseObject))success
                               failure:(void (^)( NSError *error))failure;

/**
 用户登录
 */
-(void)userLoginWithPhoneNumber:(NSString *)phoneNumber
                            pwd:(NSString *)pwd
                       delegate:(id)delegate
                        success:(void (^)( id responseObject))success
                        failure:(void (^)( NSError *error))failure;

/**
 * 用户登出
 **/
- (void)userLogoutWithWithDelegate:(id)delegate
                           success:(void (^)( id responseObject))success
                           failure:(void (^)( NSError *error))failure;

// 检查客户端更新
- (void)checkUpdateWithVersionString:(NSString *)version
                              delete:(id)delegate
                             success:(void (^)(id responseObject))success
                             failure:(void(^)(NSError *error))failure;

// 活动中心
- (void)activityCenterListWithPageSize:(NSNumber *)pageSize
                            pageNumber:(NSNumber *)pageNumber
                              delegate:(id)delegate
                               success:(void (^)(id responseObject))success
                               failure:(void(^)(NSError *error))failure;

// 精品推荐
- (void)recommendedProductInfo:(NSString *)platform
                      delegate:(id)delegate
                       success:(void (^)(id responseObject))success
                       failure:(void(^)(NSError *error))failure;

// 产品列表
- (void)getProductListWithWithChannelId:(NSString *)channelId
                                 offset:(NSInteger)offset
                               pageSize:(NSInteger)pageSize
                               delegate:(id)delegate
                                success:(void (^)(id responseObject))success
                                failure:(void(^)(NSError *error))failure;

//债权转让产品列表
- (void)getCreditorsListWithWithChannelId:(NSString *)channelId
                                   offset:(NSInteger)offset
                                 pageSize:(NSInteger)pageSize
                                 delegate:(id)delegate
                                  success:(void (^)(id responseObject))success
                                  failure:(void(^)(NSError *error))failure;

// 设置支付密码
- (void)setPayPassword:(NSString *)payPassword
              delegate:(id)delegate
               success:(void (^)(id responseObject))success
               failure:(void(^)(NSError *error))failure;

// 消息中心
- (void)messageCenterListWithPageSize:(NSNumber *)pageSize
                           pageNumber:(NSNumber *)pageNumber
                             delegate:(id)delegate
                              success:(void (^)(id responseObject))success
                              failure:(void(^)(NSError *error))failure;

// 我的资产
- (void)getMyAssertInfoWithDelegate:(id)delegate
                            success:(void (^)(id responseObject))success
                            failure:(void(^)(NSError *error))failure;

// 获得产品详情
- (void)getProductDetailWithProductId:(NSString *)productId
                             delegate:(id)delegate
                              success:(void (^)(id responseObject))success
                              failure:(void(^)(NSError *error))failure;

// 获得债权转让产品详情
- (void)getCreditorsDetailWithProductId:(NSString *)productId
                               delegate:(id)delegate
                                success:(void (^)(id responseObject))success
                                failure:(void(^)(NSError *error))failure;

// 注册账号
- (void)registerAccountWithPhoneNumber:(NSString *)phoneNumber
                              password:(NSString *)password
                                mcCode:(NSString *)mcCode
                              delegate:(id)delegate
                               success:(void (^)(id responseObject))success
                               failure:(void(^)(NSError *error))failure;

// 找回密码
- (void)resetPwsswordWithPhoneNumber:(NSString *)phoneNumber
                            passCode:(NSString *)passCode
                            passWord:(NSString *)password
                            delegate:(id)delegate
                             success:(void (^)(id responseObject))success
                             failure:(void(^)(NSError *error))failure;

// 帮助中心
- (void)helpCenterListWithPageSize:(NSNumber *)pageSize
                        pageNumber:(NSNumber *)pageNumber
                          delegate:(id)delegate
                           success:(void (^)(id responseObject))success
                           failure:(void(^)(NSError *error))failure;

// 实名认证
- (void)authDictionary:(NSDictionary *)dict
              delegate:(id)delegate
               success:(void (^)(id responseObject))success
               failure:(void(^)(NSError *error))failure;

// 我的银行卡
- (void)getMyBankCardWithProductId:(NSString *)productId
                          delegate:(id)delegate
                           success:(void (^)(id responseObject))success
                           failure:(void(^)(NSError *error))failure;

// 可用银行列表
- (void)getAvailableBankListWithProductChannelId:(NSString *)channelId
                                        delegate:(id)delegate
                                         success:(void (^)(id responseObject))success
                                         failure:(void(^)(NSError *error))failure;

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
                       failure:(void(^)(NSError *error))failure;

// 购买产品
- (void)buyProductWithProductId:(NSString *)productId
                         amount:(NSString *)amount
                 bankCardNumber:(NSString *)bankCardNumber
                    payPassword:(NSString *)payPassword
                       delegate:(id)delegate
                        success:(void (^)(id responseObject))success
                        failure:(void(^)(NSError *error))failure;

// 已购产品详情
- (void)getOrderResolveWithProductId:(NSString *)productId
                            delegate:(id)delegate
                             success:(void (^)(id responseObject))success
                             failure:(void(^)(NSError *error))failure;

// 发送忘记密码验证码
- (void)getResetPwdPassCode:(NSString *)phoneNumber
                   delegate:(id)delegate
                    success:(void (^)(id responseObject))success
                    failure:(void(^)(NSError *error))failure;

// 发送支付密码验证码
- (void)getResetPayPwdPassCodeWithDelegate:(id)delegate
                                   success:(void (^)(id responseObject))success
                                   failure:(void(^)(NSError *error))failure;

// 设置新的支付密码
- (void)setNewPayPasswordWithNewPayPassword:(NSString *)newPayPassword
                                      mCode:(NSString *)mCode
                               idCardNumber:(NSString *)idCardNumber
                                   delegate:(id)delegate
                                    success:(void (^)(id responseObject))success
                                    failure:(void(^)(NSError *error))failure;

// 积分相关
// 得到我的积分
- (void)getIntegralWithDelegate:(id)delegate
                        success:(void (^)(id responseObject))success
                        failure:(void(^)(NSError *error))failure;

// 得到兑换礼品列表信息
- (void)getGoodsListWithPageSize:(NSNumber *)pageSize
                      pageNumber:(NSNumber *)pageNumber
                        delegate:(id)delegate
                         success:(void (^)(id responseObject))success
                         failure:(void(^)(NSError *error))failure;

// 使用积分兑换礼品
- (void)addIntegralExchangeWithGoodId:(NSString *)goodId
                             delegate:(id)delegate
                              success:(void (^)(id responseObject))success
                              failure:(void(^)(NSError *error))failure;

// 得到我的礼品兑换记录
- (void)myIntegralExchangeListWithPageSize:(NSNumber *)pageSize
                                pageNumber:(NSNumber *)pageNumber
                                  delegate:(id)delegate
                                   success:(void (^)(id responseObject))success
                                   failure:(void(^)(NSError *error))failure;

// 重置密码
- (void)resetPasswordWithOldPwd:(NSString *)oldPwd
                    newPassword:(NSString *)newPwd
                       delegate:(id)delegate
                        success:(void (^)(id responseObject))success
                        failure:(void(^)(NSError *error))failure;

// 风险控制
- (void)getProductWindControlWithProductId:(NSString *)productId
                                  delegate:(id)delegate
                                   success:(void (^)(id responseObject))success
                                   failure:(void(^)(NSError *error))failure;

// 项目介绍
- (void)getProductIntroductionWithProductId:(NSString *)productId
                                   delegate:(id)delegate
                                    success:(void (^)(id responseObject))success
                                    failure:(void(^)(NSError *error))failure;

// 是否可以购买
- (void)checkProductCanBuyWithProductId:(NSString *)productId
                               delegate:(id)delegate
                                success:(void (^)(id responseObject))success
                                failure:(void(^)(NSError *error))failure;

// 修改支付密码
- (void)modifyPayPwdWithOldPwd:(NSString *)oldPwd
                newPayPassword:(NSString *)newPayPassword
                      delegate:(id)delegate
                       success:(void (^)(id responseObject))success
                       failure:(void(^)(NSError *error))failure;

// 合同模版
- (void)getContractTemplateForProduct:(NSString *)productId
                             delegate:(id)delegate
                              success:(void (^)(id responseObject))success
                              failure:(void(^)(NSError *error))failure;

// 购买后的产品合同
- (void)getBuyedProductAgreementTemplateWithAccountId:(NSString *)accountId
                                             delegate:(id)delegate
                                              success:(void (^)(id responseObject))success
                                              failure:(void(^)(NSError *error))failure;

// 查看产品详细信息
- (void)getDetailProductInfoWithProductId:(NSString *)productId
                                 delegate:(id)delegate
                                  success:(void (^)(id responseObject))success
                                  failure:(void(^)(NSError *error))failure;

// 开通渠道账户
- (void)openProductAccountWithProductChannelId:(NSString *)channelId
                                      delegate:(id)delegate
                                       success:(void (^)(id responseObject))success
                                       failure:(void(^)(NSError *error))failure;

// 注册服务协议
- (void)getRegisterAgreementWithDelegate:(id)delegate
                                 success:(void (^)(id responseObject))success
                                 failure:(void(^)(NSError *error))failure;

// 隐私条款
- (void)getPrivacyAgreementWithDelegate:(id)delegate
                                success:(void (^)(id responseObject))success
                                failure:(void(^)(NSError *error))failure;

// 风险提示
- (void)getRiskAgreementWithDelegate:(id)delegate
                                success:(void (^)(id responseObject))success
                                failure:(void(^)(NSError *error))failure;

//@new 安全
- (void)getSecurityTemplateWithDelegate:(id)delegate
                                success:(void (^)(id responseObject))success
                                failure:(void(^)(NSError *error))failure;

//@new 支付
- (void)getSequestrateAgreementWithDelegate:(id)delegate
                                    success:(void (^)(id responseObject))success
                                    failure:(void(^)(NSError *error))failure;

// 活动和消息的最后创建时间
- (void)getMsgActivityLastUpdateTimeWithDelegate:(id)delegate
                                         success:(void (^)(id responseObject))success
                                         failure:(void(^)(NSError *error))failure;

// 获取省份列表
- (void)getProvinceListWithDelegate:(id)delegate
                            success:(void (^)(id responseObject))success
                            failure:(void(^)(NSError *error))failure;

// 获取城市列表
- (void)getCityListWithProvinceCode:(NSString *)code
                           delegate:(id)delegate
                            success:(void (^)(id responseObject))success
                            failure:(void(^)(NSError *error))failure;

// 获取支行信息
- (void)getBankBranchInfoWithCardNumber:(NSString *)cardNumber
                             branchName:(NSString *)branchName
                               cityCode:(NSString *)cityCode delegate:(id)delegate
                                success:(void (^)(id responseObject))success
                                failure:(void(^)(NSError *error))failure;

// 支付申请发起
-(void)rechargeRequestWithDelegate:(id) delegate userBankCardId:(NSString *)userBankCardId amount:(NSString *) amount
                           success:(void (^)(id responseObject))success
                           failure:(void(^)(NSError *error))failure;

// SDK 充值结果回传
- (void)sendRechargeResultWithParam:(NSDictionary *)param
                           delegate:(id)delegate
                            success:(void (^)(id responseObject))success
                            failure:(void(^)(NSError *error))failure;

// 充值记录查询
- (void)getRechargeRecordListWithChannelId:(NSString *)channelId
                                  pageSize:(NSNumber *)pageSize
                                pageNumber:(NSNumber *)pageNumber
                                  delegate:(id)delegate
                                   success:(void (^)(id responseObject))success
                                   failure:(void(^)(NSError *error))failure;


// 提现申请
- (void)withWithDrawApplyWithChannelId:(NSString *)channelId
                                   pwd:(NSString *)pwd
                            bankCardId:(NSString *)cardId
                                amount:(NSString *)amount
                              delegate:(id)delegate
                               success:(void (^)(id responseObject))success
                               failure:(void(^)(NSError *error))failure;


// 提现记录
- (void)getWithDrawRecordListWithChannelId:(NSString *)channelId
                                  pageSize:(NSNumber *)pageSize
                                pageNumber:(NSNumber *)pageNumber
                                  delegate:(id)delegate
                                   success:(void (^)(id responseObject))success
                                   failure:(void(^)(NSError *error))failure;

// 添加银行卡
- (void)newAddBankCardWithChannelId:(NSString *)channelId
                             bankId:(NSString *)bankId
                     bankCardNumber:(NSString *)cardNumber
                       provinceCode:(NSString *)provinceCode
                           cityCode:(NSString *)cityCode
                         branchName:(NSString *)branchName
                        phoneNumber:(NSString *)phoneNumber
                           delegate:(id)delegate
                            success:(void (^)(id responseObject))success
                            failure:(void(^)(NSError *error))failure;

// 获取当前余额
- (void)getAvailableMoneyWithDelegate:(id)delegate
                              success:(void (^)(id responseObject))success
                              failure:(void(^)(NSError *error))failure;


// 投资记录
- (void)getProductAccountListWithDelegate:(id)delegate
                                  success:(void (^)(id responseObject))success
                                  failure:(void(^)(NSError *error))failure;

// 获取银行卡列表
- (void)getBankCardListByChannelId:(NSString *)channelId
                          delegate:(id)delegate
                           success:(void (^)(id responseObject))success
                           failure:(void(^)(NSError *error))failure;

// 利率计算
- (void)getProductCountInterestWithProductId:(NSString *)productId
                                      amount:(NSString *)amount
                                    delegate:(id)delegate
                                     success:(void (^)(id responseObject))success
                                     failure:(void(^)(NSError *error))failure;
//交易明细
- (void)getDealDetailWithoffset:(NSInteger)offset
                       pageSize:(NSInteger)pageSize
                       delegate:(id)delegate
                        success:(void (^)(id responseObject))success
                        failure:(void(^)(NSError *error))failure;
//钱豆明细
- (void)getGoodListDetailWithoffset:(NSInteger)offset
                           pageSize:(NSInteger)pageSize
                           delegate:(id)delegate
                            success:(void (^)(id responseObject))success
                            failure:(void(^)(NSError *error))failure;
//用户可用于购买某个产品的代金券
- (void)getUsableDJQWithProductId:(NSString *)productId
                         delegate:(id)delegate
                          success:(void (^)(id responseObject))success
                          failure:(void(^)(NSError *error))failure;
//使用代金券购买
- (void)getButTicketwithProductId:(NSString *)productId
                            share:(NSInteger)share
                      payPassword:(NSString *)payPassword
                       ticketCode:(NSString *)ticketCode
                         delegate:(id)delegate
                          success:(void (^)(id responseObject))success
                          failure:(void(^)(NSError *error))failure;
//我的可用代金券
- (void)getMyUseCouponListWithdelegate:(id)delegate
                               success:(void (^)(id responseObject))success
                               failure:(void(^)(NSError *error))failure;

//我的已使用代金券列表
- (void)getDidUseCouponListWithdelegate:(id)delegate
                                success:(void (^)(id responseObject))success
                                failure:(void(^)(NSError *error))failure;

//我的奖励列表
- (void)getMyAwardListWithdelegate:(id)delegate
                           success:(void (^)(id responseObject))success
                           failure:(void(^)(NSError *error))failure;

//购买产品详情
- (void)getBuyProductDetailWithProductId:(NSString *)productId
                               ChannelId:(NSString *)channelId
                                delegate:(id)delegate
                                 success:(void (^)(id responseObject))success
                                 failure:(void(^)(NSError *error))failure;

// 获取支付方式
- (void)getRechargeRouteWithUserBankCardId:(NSString *)userBankCardId
                                    amount:(NSString *)amount
                          productChannelId:(NSString *)productChannelId
                                  delegate:(id)delegate
                                   success:(void (^)(id responseObject))success
                                   failure:(void(^)(NSError *error))failure;
//about
- (void)getAboutMessageWithdelegate:(id)delegate
                            success:(void (^)(id responseObject))success
                            failure:(void(^)(NSError *error))failure;

//获取首页运行数据
- (void)getHomeDataWithDelegate:(id)delegate
                        success:(void (^)(id responseObject))success
                        failure:(void(^)(NSError *error))failure;

//首页中心活动图
- (void)getHomeMiddleLinkDelegate:(id)delegate
                          success:(void (^)(id responseObject))success
                          failure:(void(^)(NSError *error))failure;

//设置绑定提现银行卡
- (void)setWithDrawCardWithCardID:(NSString *)cardid
                         Delegate:(id)delegate
                          success:(void (^)(id responseObject))success
                          failure:(void(^)(NSError *error))failure;

//发送验证码回调信息
- (void)sendVerifyCodeMessage:(NSString *)verify
                       Mobile:(NSString *)mobile
                     Delegate:(id)delegate
                      success:(void (^)(id responseObject))success
                      failure:(void(^)(NSError *error))failure;

//检验手机是否注册
- (void)getMobileResgist:(NSString *)mobile
                Delegate:(id)delegate
                 success:(void (^)(id responseObject))success
                 failure:(void(^)(NSError *error))failure;

//即将过期的积分
- (void)getWillTimeOutScore:(NSString *)mobile
               Delegate:(id)delegate
                success:(void (^)(id responseObject))success
                failure:(void(^)(NSError *error))failure;

//获取银行卡限额
- (void)getBankQuotaDelegate:(id)delegate
                     success:(void (^)(id responseObject))success
                     failure:(void(^)(NSError *error))failure;
//业务员佣金详情
- (void)getBusinessAmount:(id)delegate
                  success:(void (^)(id responseObject))success
                  failure:(void(^)(NSError *error))failure;

//获得省份信息
- (void)getProvinceInfo:(id)delegate
                success:(void (^)(id responseObject))success
                failure:(void(^)(NSError *error))failure;

//贵州银行存管短信验证码
- (void)getBankMessageCode:(id)delegate
                    BankCardID:(NSString *)bankcardid
                    Mobile:(NSString *)mobile
                   SmsType:(RebindBankMessageType)smstype
                   success:(void (^)(id responseObject))success
                   failure:(void(^)(NSError *error))failure;

//用户开户接口
- (void)PersonOpenAccount:(id)delegate
                 RealName:(NSString *)realname
                   IdCard:(NSString *)idcard
               BankCardID:(NSString *)bankcardid
                   Mobile:(NSString *)mobile
                 BankCode:(NSString *)bankcode
             ProvinceCode:(NSString *)provincecode
                 CityCode:(NSString *)citycode
                  success:(void (^)(id responseObject))success
                  failure:(void(^)(NSError *error))failure;

//用户激活接口
- (void)PersonActivationAccount:(id)delegate
               BankCardID:(NSString *)bankcardid
                   Mobile:(NSString *)mobile
                 BankCode:(NSString *)bankcode
             ProvinceCode:(NSString *)provincecode
                 CityCode:(NSString *)citycode
                  success:(void (^)(id responseObject))success
                  failure:(void(^)(NSError *error))failure;

//用户换绑卡接口
- (void)PersonChangeBankCard:(id)delegate
               OldBankCardID:(NSString *)oldbankcardid
                   OldMobile:(NSString *)oldmobile
                  OldSmsCode:(NSString *)oldsmscode
               NewBankCardID:(NSString *)newbankcardid
                   NewMobile:(NSString *)newmobile
                  NewSmsCode:(NSString *)newsmscode
                    BankCode:(NSString *)bankcode
                ProvinceCode:(NSString *)provincecode
                    CityCode:(NSString *)citycode
                     success:(void (^)(id responseObject))success
                     failure:(void(^)(NSError *error))failure;

//用户充值接口(新)
- (void)PersonRecharge:(id)delegate
                Amount:(NSString *)amount
              BankCode:(NSString *)bankcode
               success:(void (^)(id responseObject))success
               failure:(void(^)(NSError *error))failure;

//用户提现接口(新)
- (void)PersonWithDraw:(id)delegate
                Amount:(NSString *)amount
           paypassword:(NSString *)password
               success:(void (^)(id responseObject))success
               failure:(void(^)(NSError *error))failure;

//获取提现限额
- (void)PersonWithDrawPermitAmt:(id)delegate
                        success:(void (^)(id responseObject))success
                        failure:(void (^)(NSError *error))failure;
@end
