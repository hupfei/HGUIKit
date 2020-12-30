//
//  HttpRequest.h
//  ysj
//
//  Created by hupfei on 2017/11/20.
//  Copyright © 2017年 Lannister. All rights reserved.
//

#import "BaseRequest.h"
#import "ResponseModel.h"

@interface HttpRequest : BaseRequest

/**
 get请求
 */
- (id)initWithGet:(NSString *)url args:(NSDictionary *)args;
- (id)initWithCacheGet:(NSString *)url cacheTime:(NSInteger)cacheTimeInSeconds args:(NSDictionary *)args;

/**
 post请求
 */
- (id)initWithPost:(NSString *)url args:(NSDictionary *)args;

/**
 参数带一张图片
 */
- (id)initWithUrl:(NSString *)url args:(NSDictionary *)args image:(UIImage *)image imageName:(NSString *)imageName;

/**
 参数带多张图片
 */
- (id)initWithUrl:(NSString *)url args:(NSDictionary *)args images:(NSArray <UIImage *>*)images imageNames:(NSArray <NSString *>*)imageNames;

/**
 只包含status=1的返回
 */
- (RACSignal *)startRequestWithClass:(Class)modelClass;
- (RACSignal *)startArrayRequestWithClass:(Class)modelClass;


/**
 info信息会显示出来
 */
- (RACSignal *)startRequestWithShowSuccessInfo;

/**
 包含status!=1和=1的返回
 */
- (RACSignal *)startRequestWithFaulureClass:(Class)modelClass;
- (RACSignal *)startArrayRequestWithFaulureClass:(Class)modelClass;

@end
