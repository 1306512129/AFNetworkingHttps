//
//  CertificateConfiguration.h
//  AFNetworkingHttps
//
//  Copyright © 2019 iCodeee. All rights reserved.
//

#ifndef CertificateConfiguration_h
#define CertificateConfiguration_h

/************************证书配置***********************/
#define isTest NO      // 配置ssl证书类型 （测试YES 预发NO 生产NO）
#define caPassword      @"222222222" // 证书密码
#define caTest_Password @"1111111111" // 测试环境 证书密码
#define openHttpsSSL YES        // 是否打开ssl配置 （默认打开 不需要修改）

/************************基础请求地址***********************/
#define Base_Url       @"https://*****"


#endif /* CertificateConfiguration_h */
