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
/// @param viewControllerClass 对应的 viewController
- (instancetype)initWithTitle:(nullable NSString *)title
           viewControllerClass:(Class)viewControllerClass;

/// 初始化
/// @param title viewController 标题
/// @param viewControllerClass 对应的 viewController
/// @param params 其他参数
- (instancetype)initWithTitle:(nullable NSString *)title
          viewControllerClass:(Class)viewControllerClass
                       params:(nullable NSDictionary *)params;

/**
 获取当前viewModel对应的ViewController
 */
- (UIViewController *)currentViewController;

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

@interface HGCommonViewModel (HGUI)

- (void)pushViewModel:(HGCommonViewModel *)viewModel animated:(BOOL)animated;
- (void)popViewModelAnimated:(BOOL)animated;
- (void)popToRootViewModelAnimated:(BOOL)animated;

- (void)presentViewModel:(HGCommonViewModel *)viewModel animated:(BOOL)animated completion: (void (^ __nullable)(void))completion;
- (void)presentViewModel:(HGCommonViewModel *)viewModel animated:(BOOL)animated modalPresentationStyle:(UIModalPresentationStyle)modalPresentationStyle completion: (void (^ __nullable)(void))completion;
- (void)dismissViewModelAnimated:(BOOL)animated completion: (void (^ __nullable)(void))completion;

/// 返回上一个viewController（自动判断 pop 还是 dismiss）
- (void)toPreviousVC:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
