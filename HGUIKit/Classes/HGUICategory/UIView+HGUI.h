//
//  UIView+HGUI.h
//  HGUIKit
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_OPTIONS(NSUInteger, HGUIViewBorderPosition) {
    HGUIViewBorderPositionTop = 0,
    HGUIViewBorderPositionLeft,
    HGUIViewBorderPositionBottom,
    HGUIViewBorderPositionRight
};

@interface UIView (HGUI)

/// 为 UIView 某个边添加边框
/// @waring 需在 view 的 size 确定后才能调用
/// @param borderPosition 边框的位置
/// @param borderWidth 边框的大小，默认为1
/// @param borderColor 边框的颜色，默认为HGUIColorSeparator
/// @param offset 左右或者上下缩进
- (void)addBorderWithPosition:(HGUIViewBorderPosition)borderPosition
                  borderWidth:(CGFloat)borderWidth
                  borderColor:(UIColor *)borderColor
                       offset:(CGFloat)offset;

/// 设置部分圆角
/// @param corners 圆角方向
/// @param radius 圆角大小
- (void)addCornerWithRoundingCorners:(UIRectCorner)corners withRadius:(CGFloat)radius;

@end

NS_ASSUME_NONNULL_END
