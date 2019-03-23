//
//  NetService.h
//  AFNetworkingHttps
//
//  Copyright © 2019 iCodeee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface NetService : NSObject
+ (NetService *)sharedNetworkService;


/**
 POST请求
 
 @param target 当前控制器
 @param url 请求地址
 @param parameters 请求参数字典
 @param HUD 是否菊花转圈
 @param block 返回信息
 */
- (void)postRequestWithTarget:(UIViewController *)target
                          url:(NSString *)url
                   parameters:(id)parameters
                          HUD:(BOOL)HUD
                        block:(void (^)(id responseObject,NSError *error))block;


- (void)getRequestWithTarget:(UIViewController *)target
                         url:(NSString *)url
                  parameters:(id)parameters
                         HUD:(BOOL)HUD
                       block:(void (^)(id responseObject,NSError *error))block;


- (void)putRequestWithTarget:(UIViewController *)target
                         url:(NSString *)url
                  parameters:(id)parameters
                         HUD:(BOOL)HUD
                       block:(void (^)(id responseObject,NSError *error))block;



@end

NS_ASSUME_NONNULL_END
