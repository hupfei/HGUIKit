//
//  HttpRequest.m
//  ysj
//
//  Created by hupfei on 2017/11/20.
//  Copyright © 2017年 Lannister. All rights reserved.
//

#import "HttpRequest.h"
#import <AFNetworking/AFHTTPSessionManager.h>
#import "HGAppDelegate+HGUI.h"

/* http请求成功状态码 **/
const NSInteger SUCCESS_STATUS = 1;
/* http token失效状态码 **/
const NSInteger TOKEN_EXPIRED  = 2;

@interface HttpRequest ()

@property (nonatomic, copy)   NSString *url;
@property (nonatomic, strong) NSDictionary *args;
@property (nonatomic, assign) YTKRequestMethod method;
@property (nonatomic, assign) NSInteger cacheTime;
@property (nonatomic, strong) NSArray *images;
@property (nonatomic, strong) NSArray *imageNames;

@end

@implementation HttpRequest

- (id)initWithGet:(NSString *)url args:(NSDictionary *)args {
    self = [super init];
    if (self) {
        _url = url;
        _method = YTKRequestMethodGET;
        _args = args;
        // 设为 YES 可以使得在网络请求时不读取缓存
        self.ignoreCache = YES;
        self.cacheTime = -1;
    }
    return self;
}

- (id)initWithCacheGet:(NSString *)url cacheTime:(NSInteger)cacheTimeInSeconds args:(NSDictionary *)args {
    self = [super init];
    if (self) {
        _url = url;
        _method = YTKRequestMethodGET;
        _args = args;
        self.ignoreCache = NO;
        self.cacheTime = cacheTimeInSeconds;
    }
    return self;
}

- (id)initWithPost:(NSString *)url args:(NSDictionary *)args {
    self = [super init];
    if (self) {
        _url = url;
        _method = YTKRequestMethodPOST;
        _args = args;
        self.ignoreCache = YES;
        self.cacheTime = -1;
    }
    return self;
}

- (id)initWithUrl:(NSString *)url args:(NSDictionary *)args image:(UIImage *)image imageName:(NSString *)imageName {
    NSAssert(image && [image isKindOfClass:[UIImage class]], @"image只能传图片");
    NSAssert(imageName.length > 0, @"图片名字不能为空");
    return [self initWithUrl:url args:args images:@[image] imageNames:@[imageName]];
}

- (id)initWithUrl:(NSString *)url args:(NSDictionary *)args images:(NSArray <UIImage *>*)images imageNames:(NSArray <NSString *>*)imageNames {
    self = [super init];
    if (self) {
        _url = url;
        _method = YTKRequestMethodPOST;
        _images = images;
        _imageNames = imageNames;
        _args = args;
        self.cacheTime = -1;
    }
    return self;
}

- (RACSignal *)startRequestWithClass:(Class)modelClass {
    return [self startRequestWithClass:modelClass hasFailureData:NO isArrayResult:NO showSuccessInfo:NO];
}

- (RACSignal *)startArrayRequestWithClass:(Class)modelClass {
    return [self startRequestWithClass:modelClass hasFailureData:NO isArrayResult:YES showSuccessInfo:NO];
}

- (RACSignal *)startRequestWithShowSuccessInfo {
    return [self startRequestWithClass:nil hasFailureData:NO isArrayResult:NO showSuccessInfo:YES];
}

- (RACSignal *)startRequestWithFaulureClass:(Class)modelClass {
    return [self startRequestWithClass:modelClass hasFailureData:YES isArrayResult:NO showSuccessInfo:NO];
}

- (RACSignal *)startArrayRequestWithFaulureClass:(Class)modelClass {
    return [self startRequestWithClass:modelClass hasFailureData:YES isArrayResult:YES showSuccessInfo:NO];
}

- (RACSignal *)startRequestWithClass:(Class)modelClass hasFailureData:(BOOL)hasFailureData isArrayResult:(BOOL)isArray showSuccessInfo:(BOOL)show {
    if (((HGAppDelegate *)[UIApplication sharedApplication].delegate).networkStatus == YYReachabilityStatusNone) {
        //无网络
        [QMUITips showError:@"网络异常，请检查网络设置"];
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            [subscriber sendError:nil];
            [subscriber sendCompleted];
            return [RACDisposable disposableWithBlock:^{}];
        }];
    }
    
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [self startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
            ResponseModel *responseModel = [ResponseModel mj_objectWithKeyValues:request.responseObject];
            NSInteger code = responseModel.status.integerValue;
            QMUILogInfo(@"HttpRequest", @"\n %@请求\n url:%@\n 参数：%@\n 数据:%@", self.requestMethod==0?@"GET":@"POST", self.requestUrl, self.requestArgument, responseModel);
            if (code == SUCCESS_STATUS) {
                if (show) {
                    [QMUITips showWithText:responseModel.info];
                }
                if (isArray) {
                    [subscriber sendNext:modelClass ? [modelClass mj_objectArrayWithKeyValuesArray:responseModel.data] : responseModel.data];
                } else {
                    [subscriber sendNext:modelClass ? [modelClass mj_objectWithKeyValues:responseModel.data] : responseModel.data];
                }
            } else if (code == TOKEN_EXPIRED) {
                // 登录过期
                QMUILogWarn(@"HttpRequest", @"登录过期");
//                [UserModel clearUserData];
//                [kAppDelegate toLoginVC];
            } else {
                if (hasFailureData) {
                    [subscriber sendNext:responseModel];
                } else {
                    [QMUITips showError:responseModel.info];
                    [subscriber sendError:nil];
                }
            }
            [subscriber sendCompleted];
        } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
            QMUILogWarn(@"HttpRequest", @"\n %@请求失败\n url:%@\n 参数：%@\n 错误信息:%@", self.requestMethod==0?@"GET":@"POST", self.requestUrl, self.requestArgument, request.error.description);
            [QMUITips showError:[self describeCode:request.error.code]];

            [subscriber sendError:request.error];
            [subscriber sendCompleted];
        }];
        return [RACDisposable disposableWithBlock:^{}];
    }];
}

- (NSString *)describeCode:(NSInteger)errorCode {
    NSString *errorDescription;
    switch (errorCode) {
        case NSURLErrorUnknown:
            errorDescription = @"未知网络错误";
            break;
        case NSURLErrorBadURL:
            errorDescription = @"无效的URL";
            break;
        case NSURLErrorTimedOut:
            errorDescription = @"请求超时";
            break;
        case NSURLErrorUnsupportedURL:
            errorDescription = @"不支持的URL";
            break;
        case NSURLErrorCannotFindHost:
            errorDescription = @"未能连接到服务器";
            break;
        case NSURLErrorCannotConnectToHost:
            errorDescription = @"连接服务器失败";
            break;
        case NSURLErrorNotConnectedToInternet:
            errorDescription = @"网络异常，请检查网络设置";
            break;
        default:
            errorDescription = @"网络请求失败，请稍后重试！";
            break;
    }
    return errorDescription;
}


#pragma mark ======== Override ========
- (NSString *)requestUrl {
    return _url;
}

- (YTKRequestMethod)requestMethod {
    return _method;
}

- (id)requestArgument {
    return _args;
}

//按时间缓存内容
- (NSInteger)cacheTimeInSeconds {
    return _cacheTime;
}

- (BOOL)statusCodeValidator {
    NSInteger statusCode = [self responseStatusCode];
    return (statusCode >= 0 && statusCode <= 299);
}

- (AFConstructingBlock)constructingBodyBlock {
    if (_images.count == 0 || _imageNames.count == 0) {
        return nil;
    }
    @weakify(self);
    return ^(id<AFMultipartFormData> formData) {
        @strongify(self);
        NSInteger i = 0;
        for (UIImage *image in self.images) {
            NSData *data = [self dataForUploadWithImage:image];
            [formData appendPartWithFileData:data name:self.imageNames[i] fileName:[self.imageNames[i] stringByAppendingString:@".png"] mimeType:@"image/jpeg/jpg/png"];
            
            i++;
        }
    };
}

- (NSData *)dataForUploadWithImage:(UIImage *)image {
    NSUInteger dataLength = 1024 * 1000;
    CGFloat compressionQuality = 1.0;
    NSData *data = UIImageJPEGRepresentation(image, compressionQuality);
    while (data.length > dataLength) {
        CGFloat mSize = data.length / (1024 * 1000.0);
        compressionQuality *= pow(0.7, log(mSize)/ log(3));//大概每压缩 0.7，mSize 会缩小为原来的三分之一
        data = UIImageJPEGRepresentation(image, compressionQuality);
    }
    return data;
}

@end


#pragma mark ======== 控制台打印中文 ========
@interface NSArray (Log)

@end

@interface NSDictionary (Log)

@end

@implementation NSArray (Log)

- (NSString *)descriptionWithLocale:(id)locale indent:(NSUInteger)level {
    NSMutableString *desc = [NSMutableString string];
    
    NSMutableString *tabString = [[NSMutableString alloc] initWithCapacity:level];
    for (NSUInteger i = 0; i < level; ++i) {
        [tabString appendString:@"\t"];
    }
    
    NSString *tab = @"";
    if (level > 0) {
        tab = tabString;
    }
    [desc appendString:@"[\n"];
    
    for (id obj in self) {
        if ([obj isKindOfClass:[NSDictionary class]]
            || [obj isKindOfClass:[NSArray class]]
            || [obj isKindOfClass:[NSSet class]]) {
            NSString *str = [((NSDictionary *)obj) descriptionWithLocale:locale indent:level + 1];
            [desc appendFormat:@"%@\t%@,\n", tab, str];
        } else if ([obj isKindOfClass:[NSString class]]) {
            [desc appendFormat:@"%@\t\"%@\",\n", tab, obj];
        } else if ([obj isKindOfClass:[NSData class]]) {
            // 如果是NSData类型，尝试去解析结果，以打印出可阅读的数据
            NSError *error = nil;
            NSObject *result =  [NSJSONSerialization JSONObjectWithData:obj
                                                                options:NSJSONReadingMutableContainers
                                                                  error:&error];
            // 解析成功
            if (error == nil && result != nil) {
                if ([result isKindOfClass:[NSDictionary class]]
                    || [result isKindOfClass:[NSArray class]]
                    || [result isKindOfClass:[NSSet class]]) {
                    NSString *str = [((NSDictionary *)result) descriptionWithLocale:locale indent:level + 1];
                    [desc appendFormat:@"%@\t%@,\n", tab, str];
                } else if ([obj isKindOfClass:[NSString class]]) {
                    [desc appendFormat:@"%@\t\"%@\",\n", tab, result];
                }
            } else {
                @try {
                    NSString *str = [[NSString alloc] initWithData:obj encoding:NSUTF8StringEncoding];
                    if (str != nil) {
                        [desc appendFormat:@"%@\t\"%@\",\n", tab, str];
                    } else {
                        [desc appendFormat:@"%@\t%@,\n", tab, obj];
                    }
                }
                @catch (NSException *exception) {
                    [desc appendFormat:@"%@\t%@,\n", tab, obj];
                }
            }
        } else {
            [desc appendFormat:@"%@\t%@,\n", tab, obj];
        }
    }
    
    [desc appendFormat:@"%@\t]", tab];
    
    return desc;
}

@end

@implementation NSDictionary (Log)

- (NSString *)descriptionWithLocale:(id)locale indent:(NSUInteger)level {
    NSMutableString *desc = [NSMutableString string];
    
    NSMutableString *tabString = [[NSMutableString alloc] initWithCapacity:level];
    for (NSUInteger i = 0; i < level; ++i) {
        [tabString appendString:@"\t"];
    }
    
    NSString *tab = @"";
    if (level > 0) {
        tab = tabString;
    }
    
    [desc appendString:@" {\n"];
    
    // 遍历数组,self就是当前的数组
    for (id key in self.allKeys) {
        id obj = [self objectForKey:key];
        
        if ([obj isKindOfClass:[NSString class]]) {
            [desc appendFormat:@"%@\t%@ : \"%@\",\n", tab, key, obj];
        } else if ([obj isKindOfClass:[NSArray class]]
                   || [obj isKindOfClass:[NSDictionary class]]
                   || [obj isKindOfClass:[NSSet class]]) {
            [desc appendFormat:@"%@\t%@ : %@,\n", tab, key, [obj descriptionWithLocale:locale indent:level + 1]];
        } else if ([obj isKindOfClass:[NSData class]]) {
            // 如果是NSData类型，尝试去解析结果，以打印出可阅读的数据
            NSError *error = nil;
            NSObject *result =  [NSJSONSerialization JSONObjectWithData:obj
                                                                options:NSJSONReadingMutableContainers
                                                                  error:&error];
            // 解析成功
            if (error == nil && result != nil) {
                if ([result isKindOfClass:[NSDictionary class]]
                    || [result isKindOfClass:[NSArray class]]
                    || [result isKindOfClass:[NSSet class]]) {
                    NSString *str = [((NSDictionary *)result) descriptionWithLocale:locale indent:level + 1];
                    [desc appendFormat:@"%@\t%@ : %@,\n", tab, key, str];
                } else if ([obj isKindOfClass:[NSString class]]) {
                    [desc appendFormat:@"%@\t%@ : \"%@\",\n", tab, key, result];
                }
            } else {
                @try {
                    NSString *str = [[NSString alloc] initWithData:obj encoding:NSUTF8StringEncoding];
                    if (str != nil) {
                        [desc appendFormat:@"%@\t%@ : \"%@\",\n", tab, key, str];
                    } else {
                        [desc appendFormat:@"%@\t%@ : %@,\n", tab, key, obj];
                    }
                }
                @catch (NSException *exception) {
                    [desc appendFormat:@"%@\t%@ : %@,\n", tab, key, obj];
                }
            }
        } else {
            [desc appendFormat:@"%@\t%@ : %@,\n", tab, key, obj];
        }
    }
    
    [desc appendFormat:@"%@ }", tab];
    
    return desc;
}

@end
