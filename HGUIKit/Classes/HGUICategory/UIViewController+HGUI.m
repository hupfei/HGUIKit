//
//  UIViewController+HGUI.m
//  HGUIKit
//

#import "UIViewController+HGUI.h"

@implementation UIViewController (HGUI)

- (UIViewController *)visibleViewControllerIfExist {
    if (self.presentedViewController) {
        return [self.presentedViewController visibleViewControllerIfExist];
    }
    
    if ([self isKindOfClass:[UINavigationController class]]) {
        return [((UINavigationController *)self).visibleViewController visibleViewControllerIfExist];
    }
    
    if ([self isKindOfClass:[UITabBarController class]]) {
        return [((UITabBarController *)self).selectedViewController visibleViewControllerIfExist];
    }
    
    if (self.isViewLoaded) {
        return self;
    } else {
        return nil;
    }
}

- (BOOL)isPresented {
    UIViewController *viewController = self;
    if (self.navigationController) {
        if (self.navigationController.viewControllers.firstObject != self) {
            return NO;
        }
        viewController = self.navigationController;
    }
    BOOL result = viewController.presentingViewController.presentedViewController == viewController;
    return result;
}

+ (nullable UIViewController *)visibleViewController {
    UIViewController *rootViewController = UIApplication.sharedApplication.delegate.window.rootViewController;
    UIViewController *visibleViewController = [rootViewController visibleViewControllerIfExist];
    return visibleViewController;
}

- (void)toPreviousVC:(BOOL)animated {
    if (self.isPresented) {
        [self dismissViewControllerAnimated:animated completion:nil];
    } else {
        [self.navigationController popViewControllerAnimated:animated];
    }
}

@end
