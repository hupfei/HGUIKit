//
//  HGCommonTableViewController.h
//  HGUIKit
//

#import <QMUIKit/QMUIKit.h>
#import "HGCommonTableViewModel.h"

NS_ASSUME_NONNULL_BEGIN

/**
 *  可作为项目内所有 `UITableViewController` 的基类
 *  可重写的方法：
 *  同 HGCommonViewController
 */
@interface HGCommonTableViewController : QMUICommonTableViewController

@property (nonatomic, strong, readonly) HGCommonTableViewModel *viewModel;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

/// 默认初始化方式
- (instancetype)initWithViewModel:(HGCommonTableViewModel *)viewModel NS_DESIGNATED_INITIALIZER;

@end

@interface HGCommonTableViewController (HGSubclassingHooks)

/**
 *  负责绑定数据源
 *  viewDidLoad 之后会自动调用
 *  子类中需要调用 [super bindViewModel];
 */
- (void)bindViewModel NS_REQUIRES_SUPER;

@end

NS_ASSUME_NONNULL_END
