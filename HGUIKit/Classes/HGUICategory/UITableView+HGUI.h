//
//  UITableView+HGUI.h
//  HGUIKit
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITableView (HGUI)

/**
 *  获取某个 view 在 tableView 里的 indexPath
 */
- (nullable NSIndexPath *)indexPathForRowAtView:(nullable UIView *)view;

/**
 *  为cell添加线条
 */
- (void)addLineforPlainCell:(UITableViewCell *)cell
          forRowAtIndexPath:(NSIndexPath *)indexPath
              withLeftSpace:(CGFloat)leftSpace;
- (void)addLineforPlainCell:(UITableViewCell *)cell
          forRowAtIndexPath:(NSIndexPath *)indexPath
              withLeftSpace:(CGFloat)leftSpace
                  lineColor:(UIColor *)hexColor;
- (void)addLineforPlainCell:(UITableViewCell *)cell
          forRowAtIndexPath:(NSIndexPath *)indexPath
              withLeftSpace:(CGFloat)leftSpace
             hasSectionLine:(BOOL)hasSectionLine;

- (void)hg_registerCellWithClass:(Class)cla;
- (void)hg_registerHeaderFooterViewWithClass:(Class)cla;

@end

NS_ASSUME_NONNULL_END
