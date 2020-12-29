//
//  HGAppDelegate.m
//  HGUIKit
//

#import "HGAppDelegate.h"
#import "HGViewController.h"

@implementation HGAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // 界面
    self.window = [[UIWindow alloc] init];
    self.window.rootViewController = [self generateWindowRootViewController];
    self.window.backgroundColor = UIColor.whiteColor;
    [self.window makeKeyAndVisible];

    return YES;
}

- (UIViewController *)generateWindowRootViewController {
    HGCommonTableViewModel *mainVM = [[HGCommonTableViewModel alloc] initWithTitle:@"main" viewControllerClass:HGViewController.class];
    HGCommonNavigationController *mainNavController = [[HGCommonNavigationController alloc] initWithRootViewController:mainVM.currentViewController];
    return mainNavController;
}

@end
