//
//  HGViewChain.m
//
//  Created by hupfei.
//

#import "HGViewChain.h"
#import <QMUIKit/QMUIKit.h>

@implementation HGViewChain

#pragma mark- view
@synthesize backgroundColor = _backgroundColor;
@synthesize tag = _tag;
@synthesize alpha = _alpha;
@synthesize corner = _corner;
@synthesize cornerRadius = _cornerRadius;
@synthesize cornerRadiusAndColor = _cornerRadiusAndColor;
@synthesize contentMode = _contentMode;
@synthesize addToSuperView = _addToSuperView;
@synthesize frame = _frame;

- (ChainColor)backgroundColor {
    if (!_backgroundColor) {
        __weak typeof(self) weakSelf = self;
        _backgroundColor = ^(id color) {
            weakSelf.view.backgroundColor = [weakSelf id2Color:color];
            return weakSelf;
        };
    }
    return _backgroundColor;
}

- (ChainInteger)tag {
    if (!_tag) {
        __weak typeof(self) weakSelf = self;
        _tag = ^(NSInteger tag) {
            weakSelf.view.tag = tag;
            return weakSelf;
        };
    }
    return _tag;
}

- (ChainFloat)alpha {
    if (!_alpha) {
        __weak typeof(self) weakSelf = self;
        _alpha = ^(CGFloat alpha) {
            weakSelf.view.alpha = alpha;
            return weakSelf;
        };
    }
    return _alpha;
}

- (ChainCorner)corner {
    if (!_corner) {
        __weak typeof(self) weakSelf = self;
        _corner = ^(CGFloat radius, CGFloat borderWidth, UIColor *borderColor) {
            weakSelf.view.layer.cornerRadius = radius;
            weakSelf.view.layer.borderWidth = borderWidth;
            weakSelf.view.layer.borderColor = borderColor.CGColor;
            weakSelf.view.layer.masksToBounds = YES;
            return weakSelf;
        };
    }
    return _corner;
}

- (ChainCornerRadius)cornerRadius {
    if (!_cornerRadius) {
        __weak typeof(self) weakSelf = self;
        _cornerRadius = ^(CGFloat radius) {
            weakSelf.corner(radius, 1, UIColor.clearColor);
            return weakSelf;
        };
    }
    return _cornerRadius;
}

- (ChainCornerRadiusAndColor)cornerRadiusAndColor {
    if (!_cornerRadiusAndColor) {
        __weak typeof(self) weakSelf = self;
        _cornerRadiusAndColor = ^(CGFloat radius, UIColor *borderColor) {
            weakSelf.corner(radius, 1, borderColor);
            return weakSelf;
        };
    }
    return _cornerRadiusAndColor;
}

- (ChainInteger)contentMode {
    if (!_contentMode) {
        __weak typeof(self) weakSelf = self;
        _contentMode = ^(UIViewContentMode contentMode) {
            weakSelf.view.contentMode = contentMode;
            return weakSelf;
        };
    }
    return _contentMode;
}

- (ChainFrame)frame {
    if (!_frame) {
        __weak typeof(self) weakSelf = self;
        _frame = ^(CGRect frame) {
            weakSelf.view.frame = frame;
            return weakSelf;
        };
    }
    return _frame;
}

- (ChainView)addToSuperView {
    if (!_addToSuperView) {
        __weak typeof(self) weakSelf = self;
        _addToSuperView = ^(UIView *superView) {
            [superView addSubview:weakSelf.view];
            return weakSelf;
        };
    }
    return _addToSuperView;
}

#pragma mark- label
@synthesize text = _text;
@synthesize attributedText = _attributedText;
@synthesize fontValue = _fontValue;
@synthesize boldFontValue = _boldFontValue;
@synthesize font = _font;
@synthesize textColor = _textColor;
@synthesize textAlignment = _textAlignment;
@synthesize lineBreakMode = _lineBreakMode;
@synthesize numberOfLines = _numberOfLines;

- (ChainString)text {
    NSAssert([self isMemberOfClass:UILabel.class], @"UILabel专用");
    
    if (!_text) {
        __weak typeof(self) weakSelf = self;
        _text = ^(NSString *text) {
            weakSelf.label.text = text;
            return weakSelf;
        };
    }
    return _text;
}

- (ChainAttributedString)attributedText {
    NSAssert([self isMemberOfClass:UILabel.class], @"UILabel专用");

    if (!_attributedText) {
        __weak typeof(self) weakSelf = self;
        _attributedText = ^(NSAttributedString *attributedText) {
            weakSelf.label.attributedText = attributedText;
            return weakSelf;
        };
    }
    return _attributedText;
}

- (ChainFloat)fontValue {
    NSAssert([self isMemberOfClass:UILabel.class], @"UILabel专用");

    if (!_fontValue) {
        __weak typeof(self) weakSelf = self;
        _fontValue = ^(CGFloat font) {
            weakSelf.label.font = [UIFont systemFontOfSize:font];
            return weakSelf;
        };
    }
    return _fontValue;
}

- (ChainFloat)boldFontValue {
    NSAssert([self isMemberOfClass:UILabel.class], @"UILabel专用");

    if (!_boldFontValue) {
        __weak typeof(self) weakSelf = self;
        _boldFontValue = ^(CGFloat font) {
            weakSelf.label.font = [UIFont boldSystemFontOfSize:font];
            return weakSelf;
        };
    }
    return _boldFontValue;
}

- (ChainFont)font {
    NSAssert([self isMemberOfClass:UILabel.class], @"UILabel专用");

    if (!_font) {
        __weak typeof(self) weakSelf = self;
        _font = ^(UIFont *font) {
            weakSelf.label.font = font;
            return weakSelf;
        };
    }
    return _font;
}

- (ChainColor)textColor {
    NSAssert([self isMemberOfClass:UILabel.class], @"UILabel专用");

    if (!_textColor) {
        __weak typeof(self) weakSelf = self;
        _textColor = ^(id color) {
            weakSelf.label.textColor = [weakSelf id2Color:color];
            return weakSelf;
        };
    }
    return _textColor;
}

- (ChainInteger)textAlignment {
    NSAssert([self isMemberOfClass:UILabel.class], @"UILabel专用");

    if (!_textAlignment) {
        __weak typeof(self) weakSelf = self;
        _textAlignment = ^(NSTextAlignment textAlignment) {
            weakSelf.label.textAlignment = textAlignment;
            return weakSelf;
        };
    }
    return _textAlignment;
}

- (ChainInteger)lineBreakMode {
    NSAssert([self isMemberOfClass:UILabel.class], @"UILabel专用");

    if (!_lineBreakMode) {
        __weak typeof(self) weakSelf = self;
        _lineBreakMode = ^(NSLineBreakMode lineBreakMode) {
            weakSelf.label.lineBreakMode = lineBreakMode;
            return weakSelf;
        };
    }
    return _lineBreakMode;
}

- (ChainInteger)numberOfLines {
    NSAssert([self isMemberOfClass:UILabel.class], @"UILabel专用");

    if (!_numberOfLines) {
        __weak typeof(self) weakSelf = self;
        _numberOfLines = ^(NSInteger numberOfLines) {
            weakSelf.label.numberOfLines = numberOfLines;
            return weakSelf;
        };
    }
    return _numberOfLines;
}

#pragma mark- button
@synthesize labelFontValue = _labelFontValue;
@synthesize labelBoldFontValue = _labelBoldFontValue;
@synthesize titleNormal = _titleNormal;
@synthesize titleSelected = _titleSelected;
@synthesize attributedTitleNormal = _attributedTitleNormal;
@synthesize attributedTitleSelected = _attributedTitleSelected;
@synthesize titleColorNormal = _titleColorNormal;
@synthesize titleColorSelected = _titleColorSelected;
@synthesize imageNormal = _imageNormal;
@synthesize imageSelected = _imageSelected;
@synthesize backgroundImageNormal = _backgroundImageNormal;
@synthesize backgroundImageSelected = _backgroundImageSelected;
@synthesize contentEdgeInsets = _contentEdgeInsets;

- (ChainFloat)labelFontValue {
    NSAssert([self isMemberOfClass:UIButton.class], @"UIButton专用");

    if (!_labelFontValue) {
        __weak typeof(self) weakSelf = self;
        _labelFontValue = ^(CGFloat value) {
            weakSelf.btn.titleLabel.font = [UIFont systemFontOfSize:value];
            return weakSelf;
        };
    }
    return _labelFontValue;
}

- (ChainFloat)labelBoldFontValue {
    NSAssert([self isMemberOfClass:UIButton.class], @"UIButton专用");

    if (!_labelBoldFontValue) {
        __weak typeof(self) weakSelf = self;
        _labelBoldFontValue = ^(CGFloat value) {
            weakSelf.btn.titleLabel.font = [UIFont boldSystemFontOfSize:value];
            return weakSelf;
        };
    }
    return _labelBoldFontValue;
}

- (ChainString)titleNormal {
    NSAssert([self isMemberOfClass:UIButton.class], @"UIButton专用");

    if (!_titleNormal) {
        __weak typeof(self) weakSelf = self;
        _titleNormal = ^(NSString *title){
            [weakSelf.btn setTitle:title forState:UIControlStateNormal];
            return weakSelf;
        };
    }
    return _titleNormal;
}

- (ChainString)titleSelected {
    NSAssert([self isMemberOfClass:UIButton.class], @"UIButton专用");

    if (!_titleSelected) {
        __weak typeof(self) weakSelf = self;
        _titleSelected = ^(NSString *title){
            [weakSelf.btn setTitle:title forState:UIControlStateSelected];
            return weakSelf;
        };
    }
    return _titleSelected;
}

- (ChainAttributedString)attributedTitleNormal {
    NSAssert([self isMemberOfClass:UIButton.class], @"UIButton专用");

    if (!_attributedTitleNormal) {
        __weak typeof(self) weakSelf = self;
        _attributedTitleNormal = ^(NSAttributedString *attStr){
            [weakSelf.btn setAttributedTitle:attStr forState:UIControlStateNormal];
            return weakSelf;
        };
    }
    return _attributedTitleNormal;
}

- (ChainAttributedString)attributedTitleSelected {
    NSAssert([self isMemberOfClass:UIButton.class], @"UIButton专用");

    if (!_attributedTitleSelected) {
        __weak typeof(self) weakSelf = self;
        _attributedTitleSelected = ^(NSAttributedString *attStr){
            [weakSelf.btn setAttributedTitle:attStr forState:UIControlStateSelected];
            return weakSelf;
        };
    }
    return _attributedTitleSelected;
}

- (ChainColor)titleColorNormal {
    NSAssert([self isMemberOfClass:UIButton.class], @"UIButton专用");

    if (!_titleColorNormal) {
        __weak typeof(self) weakSelf = self;
        _titleColorNormal = ^(UIColor *color){
            [weakSelf.btn setTitleColor:color forState:UIControlStateNormal];
            return weakSelf;
        };
    }
    return _titleColorNormal;
}

- (ChainColor)titleColorSelected {
    NSAssert([self isMemberOfClass:UIButton.class], @"UIButton专用");

    if (!_titleColorSelected) {
        __weak typeof(self) weakSelf = self;
        _titleColorSelected = ^(UIColor *color){
            [weakSelf.btn setTitleColor:color forState:UIControlStateSelected];
            return weakSelf;
        };
    }
    return _titleColorSelected;
}

- (ChainImage)imageNormal {
    NSAssert([self isMemberOfClass:UIButton.class], @"UIButton专用");

    if (!_imageNormal) {
        __weak typeof(self) weakSelf = self;
        _imageNormal = ^(UIImage *image){
            [weakSelf.btn setImage:image forState:UIControlStateNormal];
            return weakSelf;
        };
    }
    return _imageNormal;
}

- (ChainImage)imageSelected {
    NSAssert([self isMemberOfClass:UIButton.class], @"UIButton专用");

    if (!_imageSelected) {
        __weak typeof(self) weakSelf = self;
        _imageSelected = ^(UIImage *image){
            [weakSelf.btn setImage:image forState:UIControlStateSelected];
            return weakSelf;
        };
    }
    return _imageSelected;
}

- (ChainImage)backgroundImageNormal {
    NSAssert([self isMemberOfClass:UIButton.class], @"UIButton专用");

    if (!_backgroundImageNormal) {
        __weak typeof(self) weakSelf = self;
        _backgroundImageNormal = ^(UIImage *image){
            [weakSelf.btn setImage:image forState:UIControlStateNormal];
            return weakSelf;
        };
    }
    return _backgroundImageNormal;
}

- (ChainImage)backgroundImageSelected {
    NSAssert([self isMemberOfClass:UIButton.class], @"UIButton专用");

    if (!_backgroundImageSelected) {
        __weak typeof(self) weakSelf = self;
        _backgroundImageSelected = ^(UIImage *image){
            [weakSelf.btn setImage:image forState:UIControlStateSelected];
            return weakSelf;
        };
    }
    return _backgroundImageSelected;
}

- (ChainEdgeInsets)contentEdgeInsets {
    NSAssert([self isMemberOfClass:UIButton.class], @"UIButton专用");

    if (!_contentEdgeInsets) {
        __weak typeof(self) weakSelf = self;
        _contentEdgeInsets = ^(UIEdgeInsets edge){
            weakSelf.contentEdgeInsets(edge);
            return weakSelf;
        };
    }
    return _contentEdgeInsets;
}

#pragma mark- UIImageView
@synthesize image = _image;

- (ChainImage)image {
    NSAssert([self isMemberOfClass:UIImageView.class], @"UIImageView专用");

    if (!_image) {
        __weak typeof(self) weakSelf = self;
        _image = ^(UIImage *image){
            weakSelf.imageView.image = image;
            return weakSelf;
        };
    }
    return _image;
}

#pragma mark- common
- (UIColor *)id2Color:(id)value {
    NSAssert([value isMemberOfClass:NSString.class] || [value isMemberOfClass:UIColor.class], @"value必须为NSString或者UIColor类型");

    if ([value isMemberOfClass:NSString.class]) {
        return [UIColor qmui_colorWithHexString:value];
    }
    return value;
}

@end
