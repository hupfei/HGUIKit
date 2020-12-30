//
//  HGCommonViewModel.h
//  HGUIKit
//

#import <Foundation/Foundation.h>
#import <ReactiveObjC/ReactiveObjC.h>

NS_ASSUME_NONNULL_BEGIN

@interface HGCommonViewModel : NSObject

/// 对应的 viewController 的title
@property (nonatomic, copy, readonly, nullable) NSString *title;
/// 当前 VC
@property (nonatomic, strong, readonly) UIViewController *viewController;
/**
 *  通过字典的方式给 viewModel 传参
 */
@property (nonatomic, copy, readonly) NSDictionary *params;

/// ViewDidLoad完成后是否开始请求远程数据
@property (nonatomic, assign) BOOL shouldRequestRemoteDataOnViewDidLoad;

/// 请求数据
@property (nonatomic, strong, readonly) RACCommand *requestRemoteDataCmd;


/// 初始化
/// @param title viewController 标题
- (instancetype)initWithTitle:(nullable NSString *)title;

/// 初始化
/// @param title viewController 标题
/// @param params 其他参数
- (instancetype)initWithTitle:(nullable NSString *)title
                       params:(nullable NSDictionary *)params;

- (UIImage *)imageWithName:(NSString *)name;

@end

@interface HGCommonViewModel (HGSubclassingHooks)

/**
 *  初始化
 *  init 之后会自动调用
 *  @warning 子类中需要调用 [super didInitialize];
 */
- (void)didInitialize NS_REQUIRES_SUPER;

/**
 *  开始请求远程数据
 *  requestRemoteDataCmd 执行后会自动调用。
 *  在viewController中的viewDidLoad之后会根据shouldRequestRemoteDataOnViewDidLoad来决定是否执行
 *  子类中不需要调用 [super requestRemoteData];
 */
- (RACSignal *)requestRemoteData;

@end


NS_ASSUME_NONNULL_END
