//
//  HGCommonViewModel.m
//  HGUIKit
//

#import "HGCommonViewModel.h"
#import "HGCommonViewController.h"
#import "HGCommonTableViewController.h"
#import "UIViewController+HGUI.h"
#import "HGCommonNavigationController.h"

@interface HGCommonViewModel ()

@property (nonatomic, copy, readwrite) NSString *title;
/// 对应的 viewController
@property (nonatomic, strong) Class viewControllerClass;
@property (nonatomic, copy, readwrite) NSDictionary *params;
@property (nonatomic, strong, readwrite) RACCommand *requestRemoteDataCmd;

@end

@implementation HGCommonViewModel

- (instancetype)init {
    return [self initWithTitle:nil viewControllerClass:HGCommonViewController.class];
}

- (instancetype)initWithTitle:(nullable NSString *)title viewControllerClass:(Class)viewControllerClass {
    return [self initWithTitle:title viewControllerClass:viewControllerClass params:nil];
}

- (instancetype)initWithTitle:(nullable NSString *)title viewControllerClass:(Class)viewControllerClass params:(nullable NSDictionary *)params {
    self = [super init];
    if (self) {
        self.title = title;
        self.viewControllerClass = viewControllerClass;
        self.params = params;
        self.shouldRequestRemoteDataOnViewDidLoad = YES;
        
        [self didInitialize];
    }
    return self;
}

- (UIViewController *)currentViewController {
    NSParameterAssert([self.viewControllerClass isSubclassOfClass:HGCommonViewController.class] || [self.viewControllerClass isSubclassOfClass:HGCommonTableViewController.class]);
    return [[self.viewControllerClass alloc] initWithViewModel:self];
}

@end

@implementation HGCommonViewModel (HGSubclassingHooks)

- (void)didInitialize {
    @weakify(self)
    self.requestRemoteDataCmd = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        @strongify(self)
        return [[self requestRemoteData] takeUntil:self.rac_willDeallocSignal];
    }];
}

- (RACSignal *)requestRemoteData {
    return [RACSignal empty];
}

@end

@implementation HGCommonViewModel (HGUI)

- (void)pushViewModel:(HGCommonViewModel *)viewModel animated:(BOOL)animated {
    NSParameterAssert(viewModel != nil);
    NSParameterAssert(viewModel.viewControllerClass != nil);
    
    UIViewController *visibleVC = [UIViewController visibleViewController];
    if (visibleVC) {
        [visibleVC.navigationController pushViewController:[viewModel currentViewController] animated:animated];
    }
}

- (void)popViewModelAnimated:(BOOL)animated {
    UIViewController *visibleVC = [UIViewController visibleViewController];
    if (visibleVC) {
        [visibleVC.navigationController popViewControllerAnimated:animated];
    }
}

- (void)popToRootViewModelAnimated:(BOOL)animated {
    UIViewController *visibleVC = [UIViewController visibleViewController];
    if (visibleVC) {
        [visibleVC.navigationController popToRootViewControllerAnimated:animated];
    }
}

- (void)presentViewModel:(HGCommonViewModel *)viewModel animated:(BOOL)animated completion: (void (^ __nullable)(void))completion {
    [self presentViewModel:viewModel animated:animated modalPresentationStyle:UIModalPresentationFullScreen completion:completion];
}

- (void)presentViewModel:(HGCommonViewModel *)viewModel animated:(BOOL)animated modalPresentationStyle:(UIModalPresentationStyle)modalPresentationStyle completion: (void (^ __nullable)(void))completion {
    NSParameterAssert(viewModel != nil);
    NSParameterAssert(viewModel.viewControllerClass != nil);
    
    HGCommonNavigationController *navC = [[HGCommonNavigationController alloc] initWithRootViewController:[viewModel currentViewController]];
    UIViewController *visibleVC = [UIViewController visibleViewController];
    if (visibleVC) {
        [visibleVC presentViewController:navC animated:animated completion:completion];
    }
}

- (void)dismissViewModelAnimated:(BOOL)animated completion: (void (^ __nullable)(void))completion {
    UIViewController *visibleVC = [UIViewController visibleViewController];
    if (visibleVC) {
        [visibleVC dismissViewControllerAnimated:animated completion:completion];
    }
}

- (void)toPreviousVC:(BOOL)animated {
    UIViewController *visibleVC = [UIViewController visibleViewController];
    if (!visibleVC) {
        return;
    }
    
    if (visibleVC.isPresented) {
        [self dismissViewModelAnimated:animated completion:nil];
    } else {
        [self popViewModelAnimated:animated];
    }
}

@end
