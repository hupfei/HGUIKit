//
//  HGAppDelegate+HGUI.m
//  HGUIKit_Example
//

#import "HGAppDelegate+HGUI.h"

@interface HGAppDelegate()

@property (nonatomic, strong) YYReachability *reachability;

@end

@implementation HGAppDelegate (HGUI)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // 在 application:didFinishLaunchingWithOptions: 之后监听网络变化
        ExtendImplementationOfVoidMethodWithTwoArguments(HGAppDelegate.class, @selector(application:didFinishLaunchingWithOptions:), UIApplication *, NSDictionary *, ^(HGAppDelegate *selfObject, UIApplication *application, NSDictionary *launchOptions) {
            [selfObject checkNetworkStatus];
        });
    });
}

static char kAssociatedObjectKey_reachability;
- (void)setReachability:(YYReachability *)reachability {
    objc_setAssociatedObject(self, &kAssociatedObjectKey_reachability, reachability, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (YYReachability *)reachability {
    return objc_getAssociatedObject(self, &kAssociatedObjectKey_reachability);
}

static char kAssociatedObjectKey_networkStatus;
- (void)setNetworkStatus:(YYReachabilityStatus)networkStatus {
    objc_setAssociatedObject(self, &kAssociatedObjectKey_networkStatus, @(networkStatus), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (YYReachabilityStatus)networkStatus {
    return [((NSNumber *)objc_getAssociatedObject(self, &kAssociatedObjectKey_networkStatus)) integerValue];
}

- (void)checkNetworkStatus {
    self.reachability = [YYReachability reachability];
    @weakify(self)
    self.reachability.notifyBlock = ^(YYReachability * _Nonnull reachability) {
        @strongify(self)
        self.networkStatus = reachability.status;
    };
    
    self.networkStatus = self.reachability.status;
}

@end
