//
//  NSString+HGUI.h
//  HGUIKit
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (HGUI)

/// 获取当前时间戳  （以秒为单位）
+ (NSString *)getNowTimeTimestamp;

/// 转换字节
+ (NSString *)stringWithbytes:(NSUInteger)bytes;

/// 转换时间戳，默认为 yyyy-MM-dd HH:mm
+ (NSString *)formatTimeInterval:(NSTimeInterval)secs;
+ (NSString *)formatTimeInterval:(NSTimeInterval)secs dateFormat:(nullable NSString *)dateFormat;

@end

NS_ASSUME_NONNULL_END
