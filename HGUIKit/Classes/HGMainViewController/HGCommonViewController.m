//
//  HGCommonViewController.m
//  HGUIKit
//

#import "HGCommonViewController.h"
#import "NSObject+HGUI.h"
#import "UIViewController+HGUI.h"
#import <QMUIKit/QMUIKit.h>

@interface HGCommonViewController ()

@property (nonatomic, strong, readwrite) HGCommonViewModel *viewModel;

@end

@implementation HGCommonViewController

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ExtendImplementationOfVoidMethodWithoutArguments(HGCommonViewController.class, @selector(initSubviews), ^(HGCommonViewController *selfObject) {
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

- (void)setupNavigationItems {
    [super setupNavigationItems];
    
    if (self.qmui_isPresented) {
        // present 显示的，需要添加返回按钮
        if (self.navigationItem.leftBarButtonItem == nil) {
            self.navigationItem.leftBarButtonItem = [UIBarButtonItem qmui_itemWithImage:[NSObject imageWithName:@"HG_back"] target:self action:@selector(back)];
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
}

@end
