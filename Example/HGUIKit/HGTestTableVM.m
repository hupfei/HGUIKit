//
//  HGTestTableVM.m
//  HGUIKit_Example
//
//  Created by hupengfei on 2021/1/12.
//  Copyright © 2021 hupfei. All rights reserved.
//

#import "HGTestTableVM.h"

@implementation HGTestTableVM

- (void)didInitialize {
    [super didInitialize];
    
    self.style = UITableViewStyleGrouped;
    self.hasHeaderRefresh = YES;
}

@end
