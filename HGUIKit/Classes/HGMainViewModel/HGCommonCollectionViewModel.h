//
//  HGCommonCollectionViewModel.h
//  HGUIKit
//

#import "HGCommonViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HGCommonCollectionViewModel : HGCommonViewModel

/// 默认 scrollDirection-UICollectionViewScrollDirectionVertical minimumLineSpacing-10 minimumInteritemSpacing-10
@property (nonatomic, strong, readonly) UICollectionViewFlowLayout *layout;
/// 重用标识，默认为空（identifier需要为cell的类名）
@property (nonatomic, copy, readonly) NSString *identifier;
/// 默认 UIEdgeInsetsZero
@property (nonatomic, assign, readonly) UIEdgeInsets contentInset;
/// 空白文字, 默认 "暂无数据"
@property (nonatomic, copy, readonly) NSString *emptyTitle;
/// 空白图片, 默认为 HG_empty_default
@property (nonatomic, copy, readonly, nullable) NSString *emptyImage;
/// 默认20
@property (nonatomic, assign, readonly) NSUInteger pageSize;
/// 是否可以下拉刷新, 默认NO
@property (nonatomic, assign, readonly) BOOL hasHeaderRefresh;
/// 是否可以上拉加载, 默认NO
@property (nonatomic, assign, readonly) BOOL hasFooterRefresh;
/// 数据源绑定到的列表，在 HGCommonCollectionViewController 中的 initCollectionView 里会自动被赋值
@property(nonatomic, weak, readonly) UICollectionView *collectionView;

/// 默认1
@property (nonatomic, assign) NSUInteger pageNo;
/// 数据源
@property (nonatomic, copy, nullable) NSArray *dataSource;
/// 会自动在 collectionView:didSelectItemAtIndexPath: 里调用
@property(nonatomic, copy, nullable) void (^didSelectBlock)(UICollectionView *collectionView, NSIndexPath *indexPath);

@end

NS_ASSUME_NONNULL_END
