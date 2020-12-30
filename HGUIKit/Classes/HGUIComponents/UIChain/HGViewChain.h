//
//  HGViewChain.h
//
//  Created by hupfei.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class HGViewChain;

NS_ASSUME_NONNULL_BEGIN

typedef HGViewChain *_Nonnull(^ChainColor)(id color);
typedef HGViewChain *_Nonnull(^ChainImage)(UIImage *image);
typedef HGViewChain *_Nonnull(^ChainFont)(UIFont *font);
typedef HGViewChain *_Nonnull(^ChainString)(NSString *string);
typedef HGViewChain *_Nonnull(^ChainAttributedString)(NSAttributedString *attStr);
typedef HGViewChain *_Nonnull(^ChainInteger)(NSInteger value);
typedef HGViewChain *_Nonnull(^ChainFloat)(CGFloat value);
typedef HGViewChain *_Nonnull(^ChainBool)(BOOL value);
typedef HGViewChain *_Nonnull(^ChainCornerRadius)(CGFloat radius);
typedef HGViewChain *_Nonnull(^ChainCornerRadiusAndColor)(CGFloat radius, UIColor *borderColor);
typedef HGViewChain *_Nonnull(^ChainCorner)(CGFloat radius, CGFloat borderWidth, UIColor *borderColor);
typedef HGViewChain *_Nonnull(^ChainEdgeInsets)(UIEdgeInsets edge);
typedef HGViewChain *_Nonnull(^ChainView)(UIView *view);
typedef HGViewChain *_Nonnull(^ChainFrame)(CGRect frame);

@interface HGViewChain : NSObject

#pragma mark- view
@property (nonatomic, strong) UIView *view;

@property (nonatomic, copy, readonly) ChainColor backgroundColor;
@property (nonatomic, copy, readonly) ChainInteger tag;
@property (nonatomic, copy, readonly) ChainFloat alpha;
/// 设置圆角（大小、宽度、颜色）
@property (nonatomic, copy, readonly) ChainCorner corner;
/// 设置圆角（大小、颜色，宽度默认为 1）
@property (nonatomic, copy, readonly) ChainCornerRadiusAndColor cornerRadiusAndColor;
/// 设置圆角（大小，宽度默认为 1，颜色默认为 UIColor.clearColor）
@property (nonatomic, copy, readonly) ChainCornerRadius cornerRadius;
/// UIViewContentMode
@property (nonatomic, copy, readonly) ChainInteger contentMode;

@property (nonatomic, copy, readonly) ChainFrame frame;
@property (nonatomic, copy, readonly) ChainView addToSuperView;

#pragma mark- label
@property (nonatomic, strong) UILabel *label;

@property (nonatomic, copy, readonly) ChainString text;
@property (nonatomic, copy, readonly) ChainAttributedString attributedText;

@property (nonatomic, copy, readonly) ChainColor textColor;

@property (nonatomic, copy, readonly) ChainFloat fontValue;
@property (nonatomic, copy, readonly) ChainFloat boldFontValue;
@property (nonatomic, copy, readonly) ChainFont font;

@property (nonatomic, copy, readonly) ChainInteger textAlignment;
@property (nonatomic, copy, readonly) ChainInteger lineBreakMode;
@property (nonatomic, copy, readonly) ChainInteger numberOfLines;

#pragma mark- button
@property (nonatomic, strong) UIButton *btn;

@property (nonatomic, copy, readonly) ChainFloat labelFontValue;
@property (nonatomic, copy, readonly) ChainFloat labelBoldFontValue;

@property (nonatomic, copy, readonly) ChainString titleNormal;
@property (nonatomic, copy, readonly) ChainString titleSelected;

@property (nonatomic, copy, readonly) ChainAttributedString attributedTitleNormal;
@property (nonatomic, copy, readonly) ChainAttributedString attributedTitleSelected;

@property (nonatomic, copy, readonly) ChainColor titleColorNormal;
@property (nonatomic, copy, readonly) ChainColor titleColorSelected;

@property (nonatomic, copy, readonly) ChainImage imageNormal;
@property (nonatomic, copy, readonly) ChainImage imageSelected;

@property (nonatomic, copy, readonly) ChainImage backgroundImageNormal;
@property (nonatomic, copy, readonly) ChainImage backgroundImageSelected;

@property (nonatomic, copy, readonly) ChainEdgeInsets contentEdgeInsets;

#pragma mark- UIImageView
@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, copy, readonly) ChainImage image;

@end


NS_ASSUME_NONNULL_END
