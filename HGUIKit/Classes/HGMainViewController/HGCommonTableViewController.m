//
//  HGCommonTableViewController.m
//  HGUIKit
//

#import "HGCommonTableViewController.h"
#import <MJRefresh/MJRefresh.h>
#import <HGUITableViewCell.h>
#import "UIViewController+HGUI.h"
#import <QMUIKit/QMUIKit.h>

@interface HGCommonViewModel ()
@property (nonatomic, strong, readwrite) UIViewController *viewController;
@end

@interface HGCommonTableViewModel()
@property(nonatomic, weak, readwrite) UITableView *tableView;
@end

@interface HGCommonTableViewController ()
@property (nonatomic, strong, readwrite) HGCommonTableViewModel *viewModel;
@end

@implementation HGCommonTableViewController

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ExtendImplementationOfVoidMethodWithoutArguments(HGCommonTableViewController.class, @selector(initSubviews), ^(HGCommonTableViewController *selfObject) {
            //绑定数据
            [selfObject bindViewModel];
            
            //开始请求第一页数据
            if (selfObject.viewModel.shouldRequestRemoteDataOnViewDidLoad) {
                [selfObject _startRequestData];
            }
        });
    });
}

- (instancetype)initWithViewModel:(HGCommonTableViewModel *)viewModel; {
    self = [super initWithStyle:viewModel.style];
    if (self) {
        self.viewModel = viewModel;
        self.viewModel.viewController = self;
    }
    return self;
}

- (void)setupNavigationItems {
    [super setupNavigationItems];
    
    if (self.qmui_isPresented) {
        // present 显示的，需要添加返回按钮
        if (self.navigationItem.leftBarButtonItem == nil) {
            self.navigationItem.leftBarButtonItem = [UIBarButtonItem qmui_itemWithImage:[self.viewModel imageWithName:@"HG_back"] target:self action:@selector(back)];
        }
    }
}

- (void)back {
    [self toPreviousVC:YES];
}

- (void)initSubviews {
    [super initSubviews];
    
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    self.viewModel.tableView = self.tableView;

    @weakify(self)
    if (self.viewModel.hasHeaderRefresh) {
        //下拉刷新
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            @strongify(self)
            self.viewModel.pageNo = 1;
            [[[self.viewModel.requestRemoteDataCmd execute:nil] deliverOnMainThread] subscribeNext:^(id x) {
                @strongify(self)
                [self.tableView.mj_footer resetNoMoreData];
            } error:^(NSError *error) {
                @strongify(self)
                [self.tableView.mj_header endRefreshing];
            } completed:^{
                @strongify(self)
                [self.tableView.mj_header endRefreshing];
                if (self.viewModel.dataSource.count < self.viewModel.pageSize * self.viewModel.pageNo) {
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                }
            }];
        }];
        header.lastUpdatedTimeLabel.hidden = YES;
        header.stateLabel.textColor = UIColor.blackColor;
        self.tableView.mj_header = header;
    }
    
    if (self.viewModel.hasFooterRefresh) {
        //上拉加载
        MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            @strongify(self)
            self.viewModel.pageNo++;
            [[[self.viewModel.requestRemoteDataCmd execute:nil] deliverOnMainThread] subscribeNext:^(id  _Nullable x) {
                @strongify(self)
                if (x == nil) {
                    self.viewModel.pageNo--;
                }
            } error:^(NSError *error) {
                @strongify(self)
                self.viewModel.pageNo--;
                [self.tableView.mj_footer endRefreshing];
            } completed:^{
                @strongify(self)
                if (self.viewModel.pageNo == 1) {
                    [self.tableView.mj_footer resetNoMoreData];
                }
                if (self.viewModel.dataSource.count < self.viewModel.pageSize * self.viewModel.pageNo) {
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                } else {
                    [self.tableView.mj_footer endRefreshing];
                }
            }];
        }];
        [footer setTitle:@"已经到底啦" forState:MJRefreshStateNoMoreData];
        footer.stateLabel.textColor = UIColor.blackColor;
        self.tableView.mj_footer = footer;
    }
}

- (void) _startRequestData {
//    if (!YYReachability.reachability.reachable) {
//        return;
//    }
    
    if (self.viewModel.hasHeaderRefresh) {
        [self.tableView.mj_header beginRefreshing];
    } else {
        [self.viewModel.requestRemoteDataCmd execute:nil];
    }
}

- (BOOL)shouldCustomizeNavigationBarTransitionIfHideable {
    return YES;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.viewModel.hasMoreSections ? self.viewModel.dataSource.count : 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.hasMoreSections ? [self.viewModel.dataSource[section] count] : self.viewModel.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HGUITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.viewModel.identifier forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[HGUITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:self.viewModel.identifier];
    }
    if ([cell respondsToSelector:@selector(bindViewModel:indexPath:)]) {
        [cell bindViewModel:self.viewModel indexPath:indexPath];
    }
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (self.viewModel.didSelectBlock) {
        self.viewModel.didSelectBlock(tableView, indexPath);
    }
}

@end

@implementation HGCommonTableViewController (HGSubclassingHooks)

- (void)bindViewModel {
    if (self.navigationItem) {
        RAC(self, self.titleView.title) = RACObserve(self.viewModel, title);
    }
    
    @weakify(self)
    // 占位图隐藏和显示
    [self.viewModel.requestRemoteDataCmd.executing subscribeNext:^(NSNumber *executing) {
        if (!executing.boolValue) {
            @strongify(self)
//            if (YYReachability.reachability.reachable) {
//                // 有网络
                if (self.viewModel.dataSource == nil || self.viewModel.dataSource.count == 0 || [self.viewModel.dataSource isKindOfClass:NSNull.class]) {
                    [self showEmptyViewWithImage:[self.viewModel imageWithName:self.viewModel.emptyImage] text:self.viewModel.emptyTitle detailText:nil buttonTitle:nil buttonAction:nil];
                } else {
                    [self hideEmptyView];
                }
//            } else {
//                // 无网络
//                if (self.viewModel.dataSource.count > 0) {
//                    // 无网络，但是 dataSource 不为空，此时不需要展示无网络界面
//                    return;
//                }
//
//                [self showEmptyViewWithImage:[NSObject imageWithName:@"HG_empty_no_network"] text:@"网络异常，请检查网络设置" detailText:nil buttonTitle:@"点击重试" buttonAction:@selector(_startRequestData)];
//            }
        }
    }];
}

@end
