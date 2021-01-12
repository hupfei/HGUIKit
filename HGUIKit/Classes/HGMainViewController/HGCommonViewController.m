//
//  HGCommonViewController.m
//  HGUIKit
//

#import "HGCommonViewController.h"
#import "UIViewController+HGUI.h"

@interface HGCommonViewModel ()
@property (nonatomic, strong, readwrite) UIViewController *viewController;
@end

@interface HGCommonViewController ()

@property (nonatomic, strong, readwrite) HGCommonViewModel *viewModel;

@end

@implementation HGCommonViewController

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ExtendImplementationOfVoidMethodWithoutArguments(HGCommonViewController.class, @selector(viewDidLoad), ^(HGCommonViewController *selfObject) {
            //绑定数据
            [selfObject bindViewModel];
            
            //开始请求第一页数据
            if (selfObject.viewModel.shouldRequestRemoteDataOnViewDidLoad) {
                [selfObject.viewModel.requestRemoteDataCmd execute:nil];
            }
        });
    });
}

- (instancetype)initWithViewModel:(nonnull HGCommonViewModel *)viewModel {
    self = [super init];
    if (self) {
        self.viewModel = viewModel;
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.viewModel = [[HGCommonViewModel alloc] initWithTitle:@""];
    }
    return self;
}

- (void)setupNavigationItems {
    [super setupNavigationItems];
    
    if (self.qmui_isPresented) {
        // present 显示的，需要添加返回按钮
        if (self.navigationItem.leftBarButtonItem == nil) {
            self.navigationItem.leftBarButtonItem = [UIBarButtonItem qmui_itemWithImage:[UIImage qmui_imageWithShape:QMUIImageShapeNavBack size:CGSizeMake(12, 20) tintColor:NavBarTintColor] target:self action:@selector(back)];
        }
    }
}

- (void)back {
    [self toPreviousVC:YES];
}

- (BOOL)shouldCustomizeNavigationBarTransitionIfHideable {
    return YES;
}

@end

@implementation HGCommonViewController (HGSubclassingHooks)

- (void)bindViewModel {
    if (self.navigationItem) {
        RAC(self, self.titleView.title) = RACObserve(self.viewModel, title);
    }
    
    // 此时为 viewmodel 中的 viewController 赋值
    self.viewModel.viewController = self;
}

@end
