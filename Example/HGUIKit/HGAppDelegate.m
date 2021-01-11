//
//  HGAppDelegate.m
//  HGUIKit
//

#import "HGAppDelegate.h"
#import "HGTestVM.h"
#import "HGTestVC.h"
#import "HGTestTableVC.h"
#import "HGTestCollectionVC.h"

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
    QMUITabBarViewController *tabBarViewController = [[QMUITabBarViewController alloc] init];
    
    HGTestVM *testVM = [[HGTestVM alloc] initWithTitle:@"HGCommonViewController"];
    HGTestVC *testVC = [[HGTestVC alloc] initWithViewModel:testVM];
    testVC.hidesBottomBarWhenPushed = NO;
    HGCommonNavigationController *testNavC = [[HGCommonNavigationController alloc] initWithRootViewController:testVC];
    testNavC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"view" image:nil tag:0];
    
    HGCommonTableViewModel *testTableVM = [[HGCommonTableViewModel alloc] initWithTitle:@"HGCommonTableViewController"];
    HGTestTableVC *testTableVC = [[HGTestTableVC alloc] initWithViewModel:testTableVM];
    testTableVC.hidesBottomBarWhenPushed = NO;
    HGCommonNavigationController *testTableNavC = [[HGCommonNavigationController alloc] initWithRootViewController:testTableVC];
    testTableNavC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"tableView" image:nil tag:1];
    
    HGCommonCollectionViewModel *testCollectionVM = [[HGCommonCollectionViewModel alloc] initWithTitle:@"HGCommonCollectionViewController"];
    HGTestCollectionVC *testCollectionVC = [[HGTestCollectionVC alloc] initWithViewModel:testCollectionVM];
    testCollectionVC.hidesBottomBarWhenPushed = NO;
    HGCommonNavigationController *testCollectionNavC = [[HGCommonNavigationController alloc] initWithRootViewController:testCollectionVC];
    testCollectionNavC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"collectionView" image:nil tag:2];
    
    tabBarViewController.viewControllers = @[testNavC, testTableNavC, testCollectionNavC];
    return tabBarViewController;
}

@end
