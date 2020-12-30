//
//  HGViewController.m
//  HGUIKit
//

#import "HGViewController.h"

@interface HGViewController ()

@end

@implementation HGViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:kReachabilityChangedNotification object:nil] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSNotification * _Nullable x) {
        Reachability *r = (Reachability *)x.object;
        NSLog(@"%@", r.currentReachabilityString);
    }];
//
//    Reachability *reachability = [Reachability reachabilityForInternetConnection];
//    [reachability startNotifier];
    
    NSLog(@"%d", [Reachability reachabilityForInternetConnection].isReachable);
}

@end
