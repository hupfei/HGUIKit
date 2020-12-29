//
//  HGCommonCollectionViewController.m
//  HGUIKit
//

#import "HGCommonCollectionViewController.h"
#import <QMUIKit/QMUIRuntime.h>
#import <ReactiveObjC/ReactiveObjC.h>
#import "HGUIMacros.h"
#import <MJRefresh/MJRefresh.h>
#import "HGUICollectionViewCell.h"
#import <YYKit/YYReachability.h>

@interface HGCommonCollectionViewModel()
@property(nonatomic, weak, readwrite) UICollectionView *collectionView;
@end

@interface HGCommonCollectionViewController ()
@property (nonatomic, strong, readwrite) HGCommonCollectionViewModel *viewModel;
@end

@implementation HGCommonCollectionViewController
@dynamic viewModel;

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ExtendImplementationOfVoidMethodWithoutArguments(HGCommonCollectionViewController.class, @selector(viewDidLoad), ^(HGCommonCollectionViewController *selfObject) {
            //开始请求第一页数据
            if (selfObject.viewModel.shouldRequestRemoteDataOnViewDidLoad) {
                [selfObject _startRequestData];
            }
        });
    });
}

- (void)dealloc {
    _collectionView.delegate = nil;
    _collectionView.dataSource = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.collectionView.backgroundColor) {
        self.view.backgroundColor = self.collectionView.backgroundColor;
    }
}

- (void)initSubviews {
    [super initSubviews];
    [self initCollectionView];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.collectionView.frame = self.view.bounds;
}

- (void)bindViewModel {
    [super bindViewModel];

    @weakify(self)
    // 占位图隐藏和显示
    [self.viewModel.requestRemoteDataCmd.executing subscribeNext:^(NSNumber *executing) {
        if (!executing.boolValue) {
            @strongify(self)
            if (YYReachability.reachability.reachable) {
                // 有网络
                if (self.viewModel.dataSource == nil || self.viewModel.dataSource.count == 0 || [self.viewModel.dataSource isKindOfClass:NSNull.class]) {
                    [self showEmptyViewWithImage:HGUIImageMake(self.viewModel.emptyImage) text:self.viewModel.emptyTitle detailText:nil buttonTitle:nil buttonAction:nil];
                } else {
                    [self hideEmptyView];
                }
            } else {
                // 无网络
                if (self.viewModel.dataSource.count > 0) {
                    // 无网络，但是 dataSource 不为空，此时不需要展示无网络界面
                    return;
                }

                [self showEmptyViewWithImage:HGUIImageMake(@"HG_empty_no_network") text:@"网络异常，请检查网络设置" detailText:nil buttonTitle:@"点击重试" buttonAction:@selector(_startRequestData)];
            }
        }
    }];
}

- (void) _startRequestData {
    if (!YYReachability.reachability.reachable) {
        return;
    }
    
    if (self.viewModel.hasHeaderRefresh) {
        [self.collectionView.mj_header beginRefreshing];
    } else {
        [self.viewModel.requestRemoteDataCmd execute:nil];
    }
}

#pragma mark- 工具方法

@synthesize collectionView = _collectionView;
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        [self loadViewIfNeeded];
    }
    return _collectionView;
}

- (void)setCollectionView:(UICollectionView * _Nonnull)collectionView {
    if (_collectionView == collectionView) {
        return;
    }

    if (_collectionView) {
        if (self.isViewLoaded && _collectionView.superview == self.view) {
            [_collectionView removeFromSuperview];
        }
    }
    
    _collectionView = collectionView;
    [self.view addSubview:_collectionView];
    
    self.viewModel.collectionView = _collectionView;
}

#pragma mark- collectionView delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.viewModel.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HGUICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:self.viewModel.identifier forIndexPath:indexPath];
    if ([cell respondsToSelector:@selector(bindViewModel:indexPath:)]) {
        [cell bindViewModel:self.viewModel indexPath:indexPath];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    if (self.viewModel.didSelectBlock) {
        self.viewModel.didSelectBlock(collectionView, indexPath);
    }
}

@end

@implementation HGCommonCollectionViewController (HGSubclassingHooks)

- (void)initCollectionView {
    if (_collectionView) {
        return;
    }
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.isViewLoaded ? self.view.bounds : CGRectZero collectionViewLayout:self.viewModel.layout];
    _collectionView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    if (@available(iOS 11.0, *)) {
        _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
            
    @weakify(self)
    if (self.viewModel.hasHeaderRefresh) {
        //下拉刷新
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            @strongify(self)
            self.viewModel.pageNo = 1;
            [[[self.viewModel.requestRemoteDataCmd execute:nil] deliverOnMainThread] subscribeNext:^(id x) {
                @strongify(self)
                [self.collectionView.mj_footer resetNoMoreData];
            } error:^(NSError *error) {
                @strongify(self)
                [self.collectionView.mj_header endRefreshing];
            } completed:^{
                @strongify(self)
                [self.collectionView.mj_header endRefreshing];
                if (self.viewModel.dataSource.count < self.viewModel.pageSize * self.viewModel.pageNo) {
                    [self.collectionView.mj_footer endRefreshingWithNoMoreData];
                }
            }];
        }];
        header.lastUpdatedTimeLabel.hidden = YES;
        header.stateLabel.textColor = UIColor.blackColor;
        _collectionView.mj_header = header;
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
                [self.collectionView.mj_footer endRefreshing];
            } completed:^{
                @strongify(self)
                if (self.viewModel.pageNo == 1) {
                    [self.collectionView.mj_footer resetNoMoreData];
                }
                if (self.viewModel.dataSource.count < self.viewModel.pageSize * self.viewModel.pageNo) {
                    [self.collectionView.mj_footer endRefreshingWithNoMoreData];
                } else {
                    [self.collectionView.mj_footer endRefreshing];
                }
            }];
        }];
        [footer setTitle:@"已经到底啦" forState:MJRefreshStateNoMoreData];
        footer.stateLabel.textColor = UIColor.blackColor;
        _collectionView.mj_footer = footer;
    }
}


@end

