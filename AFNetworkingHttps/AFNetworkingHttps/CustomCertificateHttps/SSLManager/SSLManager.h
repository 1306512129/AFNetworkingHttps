//
//  SSLManager.h
//  AFNetworkingHttps
//
//  Copyright © 2019 iCodeee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>
NS_ASSUME_NONNULL_BEGIN

@interface SSLManager : NSObject
+ (void)openSSLCertificatesWith:(AFHTTPSessionManager *)manager requesType:(NSString *)requesType;
@end

NS_ASSUME_NONNULL_END
