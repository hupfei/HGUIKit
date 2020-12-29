//
//  NSObject+HGUI.h
//  HGUIKit
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (HGUI)

+ (UIImage *)imageWithName:(NSString *)name;

- (void)showAlertViewWithTitle:(NSString *)title;
- (void)showAlertViewWithTitle:(NSString *)title message:(nullable NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle okButtonTitle:(nullable NSString *)okButtonTitle handler:(void (^__nullable)(void))okBlock;

@end

@interface NSObject (Sandbox)

/**
 *  存储用户偏好设置 到 NSUserDefults
 */
+ (void)saveUserData:(id)data forKey:(NSString *)key;

/**
 *  读取用户偏好设置
 */
+ (id)readUserDataForKey:(NSString *)key;

/**
 *  删除用户偏好设置
 */
+ (void)removeUserDataForkey:(NSString *)key;

@end

@interface NSObject (GCD)

/**
 *  @brief  异步执行代码块
 *
 *  @param block 代码块
 */
- (void)performAsynchronous:(void(^)(void))block;
/**
 *  @brief  GCD主线程执行代码块
 *
 *  @param block 代码块
 *  @param wait  是否同步请求
 */
- (void)performOnMainThread:(void(^)(void))block wait:(BOOL)wait;

/**
 *  @brief  延迟执行代码块
 *
 *  @param seconds 延迟时间 秒
 *  @param block   代码块
 */
- (void)performAfter:(NSTimeInterval)seconds block:(void(^)(void))block;

@end

@interface NSObject (Helper)

/**
 * 检查系统"照片"授权状态, 如果权限被关闭, 提示用户去隐私设置中打开.
 */
+ (BOOL)checkPhotoLibraryAuthorizationStatus;

/**
 * 检查系统"相机"授权状态, 如果权限被关闭, 提示用户去隐私设置中打开.
 */
+ (BOOL)checkCameraAuthorizationStatus;


@end

NS_ASSUME_NONNULL_END
