//
//  HGCommonCollectionViewModel.m
//  HGUIKit
//

#import "HGCommonCollectionViewModel.h"
#import "HGUICollectionViewCell.h"
#import "HGUIMacros.h"

@interface HGCommonCollectionViewModel ()

@property (nonatomic, strong, readwrite) UICollectionViewFlowLayout *layout;
@property (nonatomic, copy, readwrite) NSString *identifier;
@property (nonatomic, assign, readwrite) UIEdgeInsets contentInset;
@property (nonatomic, copy, readwrite) NSString *emptyTitle;
@property (nonatomic, copy, readwrite, nullable) NSString *emptyImage;
@property (nonatomic, assign, readwrite) NSUInteger pageSize;
@property (nonatomic, assign, readwrite) BOOL hasHeaderRefresh;
@property (nonatomic, assign, readwrite) BOOL hasFooterRefresh;

@end

@implementation HGCommonCollectionViewModel

- (void)didInitialize {
    [super didInitialize];
    
    self.layout = [[UICollectionViewFlowLayout alloc] init];
    self.layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.layout.itemSize = CGSizeZero;
    self.layout.minimumLineSpacing = 10.0;
    self.layout.minimumInteritemSpacing = 10.0;
    self.layout.sectionHeadersPinToVisibleBounds = YES;
    self.layout.sectionFootersPinToVisibleBounds = YES;
    self.layout.sectionInset = UIEdgeInsetsZero;
    
    self.identifier = NSStringFromClass(HGUICollectionViewCell.class);
    self.contentInset = UIEdgeInsetsMake(HGTopNavBarHeight, 0, 0, 0);
    self.emptyTitle = @"暂无数据";
    self.emptyImage = @"HG_empty_default";
    self.pageNo = 1;
    self.pageSize = 20;
    self.hasHeaderRefresh = NO;
    self.hasFooterRefresh = NO;
    
    //数据源有改动就刷新界面
    @weakify(self);
    [[[[RACObserve(self, dataSource) distinctUntilChanged] deliverOnMainThread] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id x) {
         @strongify(self)
         [self.collectionView reloadData];
    }];
    RAC(self, dataSource) = self.requestRemoteDataCmd.executionSignals.switchToLatest;
}

- (void)setCollectionView:(UICollectionView * _Nullable)collectionView {
    _collectionView = collectionView;
    if (collectionView == nil) {
        return;
    }
    
    collectionView.contentInset = _contentInset;
    
    NSString *nibPath = [[NSBundle mainBundle] pathForResource:self.identifier ofType:@"nib"];
    if (nibPath.length > 0) {
        [collectionView registerNib:[UINib nibWithNibName:self.identifier bundle:nil] forCellWithReuseIdentifier:self.identifier];
    } else {
        [collectionView registerClass:NSClassFromString(self.identifier) forCellWithReuseIdentifier:self.identifier];
    }
}

@end
