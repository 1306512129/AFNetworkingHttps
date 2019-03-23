//
//  NetService.m
//  AFNetworkingHttps
//
//  Copyright © 2019 iCodeee. All rights reserved.
//

#import "NetService.h"

@implementation NetService
+ (NetService *)sharedNetworkService {
    static dispatch_once_t pred = 0;
    __strong static id _sharedNetworkService = nil;
    dispatch_once(&pred, ^{
        _sharedNetworkService = [[self alloc] init];
    });
    return _sharedNetworkService;
}

- (void)postRequestWithTarget:(UIViewController *)target
                          url:(NSString *)url
                   parameters:(id)parameters
                          HUD:(BOOL)HUD
                        block:(void (^)(id, NSError *))block {
    
    [[NetManager shareManager] postRequestWithTarget:(UIViewController *)target url:url parameters:parameters HUD:HUD block:block];
}

- (void)getRequestWithTarget:(UIViewController *)target
                         url:(NSString *)url
                  parameters:(id)parameters
                         HUD:(BOOL)HUD
                       block:(void (^)(id, NSError *))block {
    
    [[NetManager shareManager] getRequestWithTarget:(UIViewController *)target url:url parameters:parameters HUD:HUD block:block];
}

- (void)putRequestWithTarget:(UIViewController *)target
                         url:(NSString *)url
                  parameters:(id)parameters
                         HUD:(BOOL)HUD
                       block:(void (^)(id, NSError *))block {
    
    [[NetManager shareManager] putRequestWithTarget:(UIViewController *)target url:url parameters:parameters HUD:HUD block:block];
}

@end
