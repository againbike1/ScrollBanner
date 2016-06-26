//
//  InfiniteScrollBanner.h
//  InfiniteScrollBanner
//
//  Created by Lying on 16/6/26.
//  Copyright © 2016年 Lying. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InfiniteScrollBannerModel.h"

@protocol InfiniteScrollBannerDelegate <NSObject>

@optional
- (void)handleClickBannerImageViewWithModel:(InfiniteScrollBannerModel *)itemModel;
// 点击图片，item 即所点的图的indexPath
- (void)handleClickBannerImageView:(NSInteger)item;

@end


@interface InfiniteScrollBanner : UIView <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, assign) id <InfiniteScrollBannerDelegate> delegate;

@property (nonatomic, strong) UICollectionView *contentCollectionView;
@property (nonatomic, strong) UIPageControl    *pageControl;
@property (nonatomic, strong) NSTimer          *timer;

@property (nonatomic, strong) UIImage          *loadingImage;           // 加载图
@property (nonatomic, assign) float            durationOfScrollTime;    // 滚动的时间间隔, 默认为2.0f
@property (nonatomic, assign) NSInteger        currentIndex;            // 当前页码，默认为0
@property (nonatomic, assign) BOOL             isDragBanner;            // 开关变量。是否在拖动, 默认为NO

@property (nonatomic, strong) NSMutableArray   *cellDataArr;            // index item class -> SingleImageModel

/**
 *  初始化
 *  @param dataArr obj class -> InfiniteScrollBannerModel
 */
+ (instancetype)setupBannerWithFrame:(CGRect)frame DataSource:(NSArray *)dataArr;

/**
 *  更新UI
 *  e.g.duration or loading image 参数改变后调用更新
 */
- (void)updateViewLayout;

/**
 *  数据改变并更新UI
 *
 *  @param dataArr obj class -> InfiniteScrollBannerModel
 */
- (void)updateViewLayoutWithDataArray:(NSArray *)dataArr;

@end


@interface InfiniteScrollBannerCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *bannerImageView;

@end