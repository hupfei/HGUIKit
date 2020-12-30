//
//  NSObject+HGUI.m
//  HGUIKit
//

#import "NSObject+HGUI.h"
#import <objc/runtime.h>
#import <Photos/Photos.h>
#import "UIViewController+HGUI.h"
#import <QMUIKit/QMUIKit.h>

@implementation NSObject (HGUI)

- (void)showAlertViewWithTitle:(NSString *)title {
    [self showAlertViewWithTitle:title message:nil cancelButtonTitle:@"确定" okButtonTitle:nil handler:nil];
}

- (void)showAlertViewWithTitle:(NSString *)title message:(nullable NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle okButtonTitle:(nullable NSString *)okButtonTitle handler:(void (^__nullable)(void))okBlock {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    if (cancelButtonTitle.length > 0) {
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:cancelAction];
    }
    
    if (okButtonTitle.length > 0) {
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:okButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (okBlock) {
                okBlock();
            }
        }];
        [alert addAction:okAction];
    }
    [[UIViewController visibleViewController] presentViewController:alert animated:YES completion:nil];
}

@end

@implementation NSObject (Sandbox)

// 存储用户偏好设置
+ (void)saveUserData:(id)data forKey:(NSString *)key {
    if (data == nil) {
        return;
    }
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

// 读取用户偏好设置
+ (id)readUserDataForKey:(NSString *)key {
    id obj = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
    return obj;
    
}

// 删除用户偏好设置
+ (void)removeUserDataForkey:(NSString *)key {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end

@implementation NSObject (GCD)

/**
 *  @brief  异步执行代码块
 *
 *  @param block 代码块
 */
- (void)performAsynchronous:(void(^)(void))block {
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, block);
}
/**
 *  @brief  GCD主线程执行代码块
 *
 *  @param block 代码块
 *  @param shouldWait  是否同步请求
 */
- (void)performOnMainThread:(void(^)(void))block wait:(BOOL)shouldWait {
    if (shouldWait) {
        // Synchronous
        dispatch_sync(dispatch_get_main_queue(), block);
    }
    else {
        // Asynchronous
        dispatch_async(dispatch_get_main_queue(), block);
    }
}
/**
 *  @brief  延迟执行代码块
 *
 *  @param seconds 延迟时间 秒
 *  @param block   代码块
 */
- (void)performAfter:(NSTimeInterval)seconds block:(void(^)(void))block {
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, seconds * NSEC_PER_SEC);
    //    dispatch_after(popTime, dispatch_get_current_queue(), block);
    dispatch_after(popTime, dispatch_get_main_queue(), block);
    
}

@end

@implementation NSObject (Helper)

+ (BOOL)checkPhotoLibraryAuthorizationStatus {
    if ([PHPhotoLibrary respondsToSelector:@selector(authorizationStatus)]) {
        PHAuthorizationStatus authStatus = [PHPhotoLibrary authorizationStatus];
        if (authStatus == PHAuthorizationStatusDenied || authStatus == PHAuthorizationStatusRestricted) {
            [self showAlertViewWithTitle:@"提示" message:@"请在iPhone的“设置->隐私->照片”中打开本应用的访问权限" cancelButtonTitle:@"取消" okButtonTitle:@"设置" handler:^{
                UIApplication *app = [UIApplication sharedApplication];
                NSURL *settingsURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                if ([app canOpenURL:settingsURL]) {
                    [app openURL:settingsURL options:@{} completionHandler:nil];
                }
            }];
            return NO;
        }
    }
    return YES;
}

+ (BOOL)checkCameraAuthorizationStatus {
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [QMUITips showError:@"该设备不支持拍照"];
        return NO;
    }
    
    if ([AVCaptureDevice respondsToSelector:@selector(authorizationStatusForMediaType:)]) {
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (AVAuthorizationStatusDenied == authStatus ||
            AVAuthorizationStatusRestricted == authStatus) {
            [self showAlertViewWithTitle:@"提示" message:@"请在iPhone的“设置->隐私->相机”中打开本应用的访问权限" cancelButtonTitle:@"取消" okButtonTitle:@"设置" handler:^{
                UIApplication *app = [UIApplication sharedApplication];
                NSURL *settingsURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                if ([app canOpenURL:settingsURL]) {
                    [app openURL:settingsURL options:@{} completionHandler:nil];
                }
            }];
            return NO;
        }
    }
    
    return YES;
}

@end
