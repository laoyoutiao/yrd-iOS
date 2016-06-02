//
//  AFHTTPClient+xiangshang.h
//

#import "AFHTTPClient.h"

@interface AFHTTPClient (xiangshang)

/**
	网络访问的get方法
	@param path 访问的路径
	@param delegate 回调方法的代理
	@param params 网络请求的参数
 */
- (void)xsGetPath:(NSString *)path
         delegate:(id)delegate
           params:(NSDictionary *)params
          success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
          failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;


/**
	网络访问的post方法
	@param path 访问的路径
	@param delegate 回调方法的代理
	@param params 网络访问的参数
 */
- (void)xsPostPath:(NSString *)path
          delegate:(id)delegate
            params:(NSDictionary *)params
           success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

@end
