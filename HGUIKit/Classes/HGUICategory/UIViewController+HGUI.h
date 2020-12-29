//
//  UIViewController+HGUI.h
//  HGUIKit
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (HGUI)

/**
 *  获取当前controller里的最高层可见viewController
 *
 *  @see 如果要获取当前App里的可见viewController，请使用 [UIViewController visibleViewController]
 */
- (nullable UIViewController *)visibleViewControllerIfExist;

/**
 *  当前 viewController 是否是被以 present 的方式显示的，是则返回 YES，否则返回 NO
 */
- (BOOL)isPresented;

/**
 * 获取当前应用里最顶层的可见viewController
 * @warning 返回值可能为nil
 */
+ (nullable UIViewController *)visibleViewController;

/// 返回上一个 vc （自动 pop 或者 dismiss）
- (void)toPreviousVC:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
