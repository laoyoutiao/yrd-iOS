////
//  AFHTTPClient+xiangshang.m
//

#import "AFHTTPClient+xiangshang.h"
#import "AFURLConnectionOperation.h"
@implementation AFHTTPClient (xiangshang)




- (void)xsGetPath:(NSString *)path
         delegate:(id)delegate
           params:(NSDictionary *)params
          success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
          failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    
    [self setAuthorizationHeaderWithUsername:authBasicUserName password:authBasicPassword];
    
    NSURLRequest *request = [self requestWithMethod:@"GET" path:path parameters:params];
    AFHTTPRequestOperation *operation = [self HTTPRequestOperationWithRequest:request success:success failure:failure];
    [self enqueueHTTPRequestOperation:operation];
}

- (void)xsPostPath:(NSString *)path
          delegate:(id)delegate
            params:(NSDictionary *)params
           success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
   // [self setAuthorizationHeaderWithUsername:authBasicUserName password:authBasicPassword];
#ifdef DBUG
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    
    NSArray *cookies = [storage cookies];
    NSHTTPCookie * cookie = [cookies lastObject];
//    NSLog(@"sessionId-----------------[%@]-------------------------",cookie.value);
#endif
//    NSLog(@"请求发送数据【%@】",params);
    NSURLRequest *request = [self requestWithMethod:@"POST" path:path parameters:params];
    
	AFHTTPRequestOperation *operation = [self HTTPRequestOperationWithRequest:request success:success failure:failure];
    [self enqueueHTTPRequestOperation:operation];
}

@end
