//
//  HGCommonViewController.h
//  HGUIKit
//

#import <UIKit/UIKit.h>
#import <QMUIKit/QMUIKit.h>
#import "HGCommonViewModel.h"

NS_ASSUME_NONNULL_BEGIN

/**
 *  可作为项目内所有 `UIViewController` 的基类
 *  可重写的方法：
 *  1. didInitialize：controller 初始化里面会自动调用
 *  2. initSubviews：负责初始化和设置 controller 里面的 view，不负责布局，布局相关的代码应该写在
 *                   viewDidLayoutSubviews，viewDidLoad 里面会自动调用
 *  3. setupNavigationItems：负责设置和更新 navigationItem，viewWillAppear 里面会自动调用
 *  4. setupToolbarItems：负责设置和更新 toolbarItem，viewWillAppear 里面自动调用
 *  5. bindViewModel：负责绑定数据，viewDidLoad 里面会自动调用
 */
@interface HGCommonViewController : QMUICommonViewController

@property (nonatomic, strong, readonly) HGCommonViewModel *viewModel;


- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

/// 默认初始化方式
- (instancetype)initWithViewModel:(HGCommonViewModel *)viewModel NS_DESIGNATED_INITIALIZER;

@end

@interface HGCommonViewController (HGSubclassingHooks)

/**
 *  负责绑定数据源
 *  viewDidLoad 之后会自动调用
 *  子类中需要调用 [super bindViewModel];
 */
- (void)bindViewModel NS_REQUIRES_SUPER;

@end

NS_ASSUME_NONNULL_END
