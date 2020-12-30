//
//  RequestModel.m
//  ysj
//
//  Created by hupfei on 2017/11/21.
//  Copyright © 2017年 Lannister. All rights reserved.
//

#import "ResponseModel.h"

@implementation ResponseModel

- (NSString *)description {
    return [[NSString alloc] initWithFormat:@"\n\tstatus : %@\n\tinfo : %@\n\tdata : %@", self.status, self.info, self.data];
}

@end
