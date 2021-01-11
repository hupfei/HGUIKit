//
//  HGCommonWebViewController.h
//  HGUIKit
//

#import "HGCommonViewController.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * viewModel 中的 params 必须包含加载网页的 url
 * self.url = self.viewModel.params[@"url"];
 */
@interface HGCommonWebViewController : HGCommonViewController

@end

NS_ASSUME_NONNULL_END
