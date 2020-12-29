//
//  HGCommonViewController.h
//  HGUIKit
//

#import <UIKit/UIKit.h>
#import <QMUIKit/QMUIKit.h>
#import "HGCommonViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HGCommonViewController : QMUICommonViewController

@property (nonatomic, strong, readonly) HGCommonViewModel *viewModel;

- (instancetype)initWithViewModel:(HGCommonViewModel *)viewModel;

@end

@interface HGCommonViewController (HGSubclassingHooks)

/**
 *  负责绑定数据源
 *  initSubviews 之后会自动调用
 *  子类中需要调用 [super bindViewModel];
 */
- (void)bindViewModel NS_REQUIRES_SUPER;

@end

NS_ASSUME_NONNULL_END
