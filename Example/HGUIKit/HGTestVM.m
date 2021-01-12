//
//  HGTestVM.m
//  HGUIKit_Example
//

#import "HGTestVM.h"

@implementation HGTestVM

- (void)didInitialize {
    [super didInitialize];
        
    self.pushCmd = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        HGCommonViewModel *vm = [[HGCommonViewModel alloc] initWithTitle:nil params:@{@"url":@"https://www.baidu.com"}];
        HGCommonWebViewController *vc = [[HGCommonWebViewController alloc] initWithViewModel:vm];
        [self.viewController.navigationController pushViewController:vc animated:YES];
        return [RACSignal empty];
    }];
}

@end
