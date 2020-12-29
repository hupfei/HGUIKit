//
//  HGCommonTableViewModel.m
//  HGUIKit
//

#import "HGCommonTableViewModel.h"
#import "HGUITableViewCell.h"
#import "UITableView+HGUI.h"

@interface HGCommonTableViewModel ()

@property (nonatomic, copy, readwrite) NSString *identifier;
@property (nonatomic, assign, readwrite) UITableViewStyle style;
@property (nonatomic, assign, readwrite) UIEdgeInsets contentInset;
@property (nonatomic, copy, readwrite) NSString *emptyTitle;
@property (nonatomic, copy, readwrite, nullable) NSString *emptyImage;
@property (nonatomic, assign, readwrite) NSUInteger pageSize;
@property (nonatomic, assign, readwrite) BOOL hasHeaderRefresh;
@property (nonatomic, assign, readwrite) BOOL hasFooterRefresh;
@property (nonatomic, assign, readwrite) BOOL hasMoreSections;

@end

@implementation HGCommonTableViewModel

- (void)didInitialize {
    [super didInitialize];
    
    self.identifier = NSStringFromClass(HGUITableViewCell.class);
    self.style = UITableViewStylePlain;
    self.contentInset = UIEdgeInsetsZero;
    self.emptyTitle = @"暂无数据";
    self.emptyImage = @"HG_empty_default";
    self.hasHeaderRefresh = NO;
    self.hasFooterRefresh = NO;
    self.pageSize = 20;
    self.pageNo = 1;
    self.hasMoreSections = NO;
    
    //数据源有改动就刷新界面
    @weakify(self);
    [[[[RACObserve(self, dataSource) distinctUntilChanged] deliverOnMainThread] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id x) {
         @strongify(self)
         [self.tableView reloadData];
    }];
    RAC(self, dataSource) = self.requestRemoteDataCmd.executionSignals.switchToLatest;
}

- (void)setDataSource:(NSArray *)dataSource {
    _dataSource = dataSource;
    
    if (dataSource.count > 0) {
        self.hasMoreSections = [dataSource.firstObject isKindOfClass:NSArray.class];
    }    
}

- (void)setTableView:(UITableView * _Nullable)tableView {
    _tableView = tableView;
    if (tableView == nil) {
        return;
    }
    
    tableView.contentInset = _contentInset;
    [tableView hg_registerCellWithClass:NSClassFromString(self.identifier)];
}

@end
