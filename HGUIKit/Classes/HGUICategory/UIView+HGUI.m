//
//  UIView+HGUI.m
//  HGUIKit
//

#import "UIView+HGUI.h"

@implementation UIView (HGUI)

- (void)addBorderWithPosition:(HGUIViewBorderPosition)borderPosition borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor offset:(CGFloat)offset {
    if (borderWidth == 0 || CGSizeEqualToSize(self.frame.size, CGSizeZero)) {
        return;
    }
    
    CGRect borderFrame = CGRectZero;
    if (borderPosition == HGUIViewBorderPositionTop) {
        borderFrame = CGRectMake(0, 0, self.frame.size.width - offset * 2, borderWidth);
    } else if (borderPosition == HGUIViewBorderPositionLeft) {
        borderFrame = CGRectMake(0, 0, borderWidth, self.frame.size.height - offset * 2);
    } else if (borderPosition == HGUIViewBorderPositionBottom) {
        borderFrame = CGRectMake(0, self.frame.size.height - borderWidth, self.frame.size.width - offset * 2, borderWidth);
    } else if (borderPosition == HGUIViewBorderPositionRight) {
        borderFrame = CGRectMake(self.frame.size.width - borderWidth, 0, borderWidth, self.frame.size.height - offset * 2);
    }
    CALayer *border = [CALayer layer];
    border.frame = borderFrame;
    [border setBackgroundColor:borderColor.CGColor];
    [self.layer addSublayer:border];
}

- (void)addCornerWithRoundingCorners:(UIRectCorner)corners withRadius:(CGFloat)radius {
    UIBezierPath *rounded = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corners cornerRadii:CGSizeMake(radius, radius)];
    CAShapeLayer *shape = [[CAShapeLayer alloc]init];
    shape.path = rounded.CGPath;
    self.layer.mask = shape;
}

@end
