//
//  HGUIMacros.h
//  HGTest
//
//  Created by apple on 2020/12/18.
//

#ifndef HGUIMacros_h
#define HGUIMacros_h

// 日志打印
#ifdef DEBUG
#define DebugLog(s, ...) NSLog(@"%s(%d): %@", __FUNCTION__, __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__])
#else
#define DebugLog(...)
#endif

#define HGAppDelegateInstance ((AppDelegate *)[UIApplication sharedApplication].delegate)
#define HGKeyWindow [UIApplication sharedApplication].keyWindow

#define HGUIImageMake(img) [UIImage imageNamed:img]
#define HGUIFontMake(font) [UIFont systemFontOfSize:font]
#define HGUIBoldFontMake(font) [UIFont boldSystemFontOfSize:font]

#define HGNavBarHeight 44.0
#define HGStatusBarHeight [[UIApplication sharedApplication] statusBarFrame].size.height
#define HGTabBarHeight (HGStatusBarHeight>20?83.0:49.0)
#define HGTopNavBarHeight (HGStatusBarHeight + HGNavBarHeight)

#define HGScreenWidth  [UIScreen mainScreen].bounds.size.width
#define HGScreenHeight [UIScreen mainScreen].bounds.size.height

#endif /* HGUIMacros_h */
