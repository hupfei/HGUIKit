//
//  HGCommonCollectionViewModel.m
//  HGUIKit
//

#import "HGCommonCollectionViewModel.h"

@interface HGCommonCollectionViewModel ()

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
    
    self.identifier = @"";
    self.contentInset = UIEdgeInsetsZero;
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
    
    if (self.identifier.length > 0) {
        NSString *nibPath = [[NSBundle mainBundle] pathForResource:self.identifier ofType:@"nib"];
        if (nibPath.length > 0) {
            [collectionView registerNib:[UINib nibWithNibName:self.identifier bundle:nil] forCellWithReuseIdentifier:self.identifier];
        } else {
            [collectionView registerClass:NSClassFromString(self.identifier) forCellWithReuseIdentifier:self.identifier];
        }
    }
}

@end
