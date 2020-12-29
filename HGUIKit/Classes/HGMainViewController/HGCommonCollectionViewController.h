//
//  HGCommonCollectionViewController.h
//  HGUIKit
//

#import "HGCommonViewController.h"
#import "HGCommonCollectionViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HGCommonCollectionViewController : HGCommonViewController<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong, readonly) UICollectionView *collectionView;

@end

@interface HGCommonCollectionViewController (HGSubclassingHooks)

/**
 *  初始化 collectionView，在 collectionView getter 被调用时会触发，可重写这个方法并通过 self.collectionView = xxx 来指定自定义的 collectionView class，注意需要自行指定 dataSource 和 delegate，但不需要手动 add 到 self.view 上。
 */
- (void)initCollectionView;

@end

NS_ASSUME_NONNULL_END
