//
//  UIView+HGChain.m
//
//  Created by hupfei.
//

#import "UIView+HGChain.h"
#import <objc/runtime.h>

@implementation UIView (HGChain)

static const char HGViewChainKey = '\0';
- (void)setChain:(HGViewChain *)chain {
    objc_setAssociatedObject(self, &HGViewChainKey, chain, OBJC_ASSOCIATION_RETAIN);
}

- (HGViewChain *)chain {
    HGViewChain *c = objc_getAssociatedObject(self, &HGViewChainKey);
    if (c == nil) {
        c = [[HGViewChain alloc] init];
        c.view = self;
        if ([self isKindOfClass:UILabel.class]) {
            c.label = (UILabel *)self;
        } else if ([self isKindOfClass:UIButton.class]) {
            c.btn = (UIButton *)self;
        } else if ([self isKindOfClass:UIImageView.class]) {
            c.imageView = (UIImageView *)self;
        }
    }
    return c;
}

@end
