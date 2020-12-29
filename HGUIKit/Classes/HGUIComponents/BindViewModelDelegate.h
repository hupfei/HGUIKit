//
//  BindViewModelDelegate.h
//  HGUIKit
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol BindViewModelDelegate <NSObject>

@optional
- (void)bindViewModel:(id)viewModel;
- (void)bindViewModel:(id)viewModel indexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
