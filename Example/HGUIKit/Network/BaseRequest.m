//
//  BaseRequest.m
//  ysj
//
//  Created by hupfei on 2017/11/21.
//  Copyright © 2017年 Lannister. All rights reserved.
//

#import "BaseRequest.h"
#import "YYKeychain.h"

static NSString *const kYYeTs_service = @"com.hupfei.hupfei";
static NSString *const kYYeTs_service_account = @"did";

@implementation BaseRequest

//超时时间
- (NSTimeInterval)requestTimeoutInterval {
    return 20;
}

//请求头
//- (NSDictionary *)requestHeaderFieldValueDictionary {
//    NSString *token = [UserModel sharedInstance].token;
//    return @{@"Accept" : @"application/json",
//             @"Authorization" : token.isNotBlank ? token : @""};
//}

#pragma mark- public
+ (NSString *)did {
    NSString * deviceidStr = [YYKeychain getPasswordForService:kYYeTs_service account:kYYeTs_service_account];
    if (deviceidStr == nil) {
        deviceidStr = [UIDevice currentDevice].identifierForVendor.UUIDString;
        [YYKeychain setPassword:deviceidStr forService:kYYeTs_service account:kYYeTs_service_account];
    }
    return deviceidStr;
}

@end
