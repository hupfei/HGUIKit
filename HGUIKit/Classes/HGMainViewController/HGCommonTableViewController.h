//
//  HGCommonTableViewController.h
//  HGUIKit
//

#import <QMUIKit/QMUIKit.h>
#import "HGCommonTableViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HGCommonTableViewController : QMUICommonTableViewController

@property (nonatomic, strong, readonly) HGCommonTableViewModel *viewModel;

- (instancetype)initWithViewModel:(HGCommonTableViewModel *)viewModel;

@end

@interface HGCommonTableViewController (HGSubclassingHooks)

/**
 *  负责绑定数据源
 *  initSubviews 之后会自动调用
 *  子类中需要调用 [super bindViewModel];
 */
- (void)bindViewModel NS_REQUIRES_SUPER;

@end

NS_ASSUME_NONNULL_END
