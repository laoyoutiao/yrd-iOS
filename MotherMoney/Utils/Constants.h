//
//  Constants.h
//  MotherMoney
//

#ifndef MotherMoney_Constants_h
#define MotherMoney_Constants_h

#define UMKey  @"564467a567e58e6e9d003500"

// 网络访问baseURL

//#define URL_BASE @"http://112.124.11.227"
//#define URL_BASE @"http://112.124.11.227:9999"
//#define URL_BASE @"http://112.124.11.227:8090"
//#define URL_BASE @"http://123.57.51.29:7080/mobile"
//#define URL_BASE @"http://192.168.168.163:8081/mobile"
#define SHARE_PRODUCT_BASE @"http://m.yrdloan.com/wap/product/productInfo?productId="
#define ON_LINE 1

#if ON_LINE
//#define URL_BASE @"http://yrdloan.com/mobile"

#define URL_BASE @"http://192.168.11.32:7080/mobile"

//#define URL_BASE @"http://112.124.113.236/mobile/"

//#define URL_BASE @"http://cgt.vicp.net:7080/mobile"
#else
//#define URL_BASE @"http://cgt.vicp.net:7080/mobile"
#define URL_BASE @"http://yrdloan.com/mobile"
//#define URL_BASE @"http://192.168.168.163:8081/mobile"
////http://123.57.51.29:7080/mobile
//http://121.43.159.168:7080/mobile
#endif

#define URL_BASE_RESOURCE @"http://112.124.11.227:9999"

#define AppChannel @"1000"

//#define URL_BASE @"http://192.168.1.103:8080/qianmama/"

// basic 认证用户名
#define authBasicUserName @"user1"

// basic 认证密码
#define authBasicPassword @"user1"


// 成功
#define kNetworkSuccessCode             1

// 参数异常
#define kNetworkParametersInvalied      2

// 需要登录
#define kNetworkNeedLogin               3

// 系统内部异常
#define kNetworkInnerException          9

// 状态码
#define kNetWorkCode         @"code"
// 数据实体
#define kNetWorkDataBody     @"data"
// 列表实体
#define kNetWorkList         @"list"
// 错误信息
#define kNetWorErrorMsg      @"message"
// 错误域
#define kErrorCMMDomain      @"kNetWorkErrorDomain"

// 手机号的正则
//#define kPhoneReg            @"^[1][3,4,5,8][0-9]{9}$"
#define kPhoneReg            @"^[1][0-9][0-9]{9}$"

// 邮箱正则
#define CMMRegexEmail         @"\\w+([-+.]\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*"

// 身份证号正则
#define CMMRegexIdNumber      @"\\d{17}x|\\d{17}X|\\d{18}|\\d{15}"



#define kCustomerServer @"/rest/customerservice/target"

// 用户分享的标示
#define kShareInWebView @"appshareInWebview"
#endif
