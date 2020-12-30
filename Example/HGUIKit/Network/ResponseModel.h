//
//  RequestModel.h
//  ysj
//
//  Created by hupfei on 2017/11/21.
//  Copyright © 2017年 Lannister. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ResponseModel : NSObject

/** 1：接口无异常 2：未登录 */
@property (nonatomic, strong) NSNumber *status;
/** 数据内容，为空时可以没有结点或者为null */
@property (nonatomic, strong) id data;
/** 返回为成功或者错误信息 */
@property (nonatomic, copy) NSString *info;


@end
