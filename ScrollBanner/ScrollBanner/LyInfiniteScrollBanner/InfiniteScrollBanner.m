//
//  InfiniteScrollBanner.m
//  InfiniteScrollBanner
//
//  Created by Lying on 16/6/26.
//  Copyright © 2016年 Lying. All rights reserved.
//

#import "InfiniteScrollBanner.h"

#import "UIImageView+WebCache.h"

/**
 *  some parameters
 */
static NSString *identifier = @"cell";
#define SpacingOfPageControlToBottom 5.0f   // page control 距底部的距离

@implementation InfiniteScrollBanner

+ (instancetype)setupBannerWithFrame:(CGRect)frame DataSource:(NSArray *)dataArr
{
    InfiniteScrollBanner *banner = [[InfiniteScrollBanner alloc] initWithFrame:frame];
    if (banner.durationOfScrollTime == 0.0f)
    {
        banner.durationOfScrollTime = 2.0f;
    }
    banner.isDragBanner = NO;
    /**
     *  分别多添加一次第一个数据和最后一个数据
     *  用于模拟无限滚动的效果
     */
    if (dataArr)
    {
        if (dataArr.count > 1)
        {
            [banner.cellDataArr addObjectsFromArray:dataArr];                           // 图片内容
            [banner.cellDataArr insertObject:dataArr[dataArr.count - 1] atIndex:0];     // 数组中的第一个
            [banner.cellDataArr addObject:dataArr[0]];                                  // 数组中的最后一个
        }
        else
        {
            [banner.cellDataArr addObjectsFromArray:dataArr];
        }
    }
    else
    {
        // 加入默认的加载图
        InfiniteScrollBannerModel *tempModel = [InfiniteScrollBannerModel new];
        tempModel.bannerID                   = @"1";
        tempModel.image                      = [UIImage imageNamed:@"loading"];
        [banner.cellDataArr addObject:tempModel];
    }
    [banner updateViewLayout];
    return banner;
}

#pragma mark - life cycle
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.currentIndex = 0;
    }
    return self;
}

// 更新UI
- (void)updateViewLayout
{
    // view
    if (self.contentCollectionView.superview != self) [self addSubview:self.contentCollectionView];
    if (self.pageControl.superview != self) [self addSubview:self.pageControl];
    
    [self.contentCollectionView reloadData];
    
    /**
     *  如果为一张
     */
    if (self.cellDataArr.count == 1)
    {
        // 如果只有一个数据
        if ([self.contentCollectionView numberOfSections] && [self.contentCollectionView numberOfItemsInSection:0])
        {
            [self.contentCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]
                                               atScrollPosition:UICollectionViewScrollPositionNone
                                                       animated:NO];
        }
        
        self.pageControl.numberOfPages = 1;
        return;
    }
    
    /**
     *  如果图片大于一张, 即cellDataArr里有3个以上的数据时
     */
    // collectionView 的初始位置 默认为第二个item
    if ([self.contentCollectionView numberOfSections])
    {
        if ([self.contentCollectionView numberOfItemsInSection:0] > 1)
        {
            [self.contentCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0]
                                               atScrollPosition:UICollectionViewScrollPositionNone
                                                       animated:NO];
        }
    }
    
    NSInteger count = self.cellDataArr.count - 2;   // 实际数量, 即pageControl显示的数量
    
    self.pageControl.currentPage   = self.currentIndex;
    self.pageControl.numberOfPages = count;
    CGSize size                    = [self.pageControl sizeForNumberOfPages:count];
    self.pageControl.bounds        = CGRectMake(0, 0, size.width, size.height);
    self.pageControl.center        = CGPointMake(self.center.x, self.frame.size.height - size.height / 2 - SpacingOfPageControlToBottom);
    
    // 延时开启轮播
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.durationOfScrollTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self addTimer];
    });
}

// 更新UI & 数据
- (void)updateViewLayoutWithDataArray:(NSArray *)dataArr
{
    if (self.cellDataArr.count)
    {
        self.cellDataArr = nil;
    }
    if (dataArr)
    {
        if (dataArr.count > 1)
        {
            [self.cellDataArr addObjectsFromArray:dataArr];                             // 内容
            [self.cellDataArr insertObject:dataArr[dataArr.count - 1] atIndex:0];       // 第一个
            [self.cellDataArr addObject:dataArr[0]];                                    // 最后一个
        }
        else
        {
            [self.cellDataArr addObjectsFromArray:dataArr];
        }
    }
    else
    {
        InfiniteScrollBannerModel *tempModel = [InfiniteScrollBannerModel new];
        tempModel.bannerID                   = @"1";
        tempModel.image                      = [UIImage imageNamed:@"loading"];
        [self.cellDataArr addObject:tempModel];
    }
    
    [self.contentCollectionView removeFromSuperview];
    [self.pageControl removeFromSuperview];
    
    // view重载
    if (self.contentCollectionView.superview != self) [self addSubview:self.contentCollectionView];
    if (self.pageControl.superview != self) [self addSubview:self.pageControl];
    
    [self.contentCollectionView reloadData];
    
    if (self.cellDataArr.count == 1)
    {
        // 如果只有一个数据
        if ([self.contentCollectionView numberOfSections])
        {
            if ([self.contentCollectionView numberOfItemsInSection:0])
            {
                [self.contentCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]
                                                   atScrollPosition:UICollectionViewScrollPositionNone
                                                           animated:NO];
            }
        }
        self.pageControl.numberOfPages = 1;
        return;
    }
    
    // collectionView 的初始位置 默认为第二个item
    if ([self.contentCollectionView numberOfSections])
    {
        if ([self.contentCollectionView numberOfItemsInSection:0] > 1)
        {
            [self.contentCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0]
                                               atScrollPosition:UICollectionViewScrollPositionNone
                                                       animated:NO];
        }
    }
    NSInteger count = self.cellDataArr.count - 2;
    
    self.pageControl.currentPage   = self.currentIndex;
    self.pageControl.numberOfPages = count;
    CGSize size                    = [self.pageControl sizeForNumberOfPages:count];
    self.pageControl.bounds        = CGRectMake(0, 0, size.width, size.height);
    self.pageControl.center        = CGPointMake(self.center.x, self.frame.size.height - size.height / 2 - SpacingOfPageControlToBottom);
    
    [self removeTimer];
    // 延时
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.durationOfScrollTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self addTimer];
    });
}

#pragma mark - event response

#pragma mark - private method
// 自动滚动到下一张
- (void)autoScrollNextPage
{
    if (self.cellDataArr.count == 1) return; // 如果只有一张图, 不滚动
    
    if (self.isDragBanner) return;  // 如果正在拖动, 请叫我守门员
    
    NSInteger currentNumber = self.pageControl.currentPage; // 当前页码
    NSInteger totalNumbers  = self.cellDataArr.count;       // 图片的总数
    
    // 计算
    CGFloat width  = self.contentCollectionView.bounds.size.width;
    CGFloat x      = ((currentNumber + 1) % totalNumbers) * width;
    NSInteger page = x / self.contentCollectionView.bounds.size.width;
    
    self.pageControl.currentPage = page;
    
    if (page <= totalNumbers)
    {
        if ([self.contentCollectionView numberOfSections] && [self.contentCollectionView numberOfItemsInSection:0] > page + 1)
            [self.contentCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:page + 1 inSection:0]
                                               atScrollPosition:UICollectionViewScrollPositionNone
                                                       animated:YES];
    }
    else
    {
        if ([self.contentCollectionView numberOfSections] && [self.contentCollectionView numberOfItemsInSection:0] > page)
            [self.contentCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:page inSection:0]
                                               atScrollPosition:UICollectionViewScrollPositionNone
                                                       animated:YES];
    }
}

// 加入计时器
- (void)addTimer
{
    [self.timer fire];
    self.isDragBanner = NO;
}

// 移除计时器
- (void)removeTimer
{
    [self.timer invalidate];
    self.timer        = nil;
    self.isDragBanner = YES;
}

#pragma mark - UIScrollView Delegate
//当用户开始拖拽的时候就调用
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self removeTimer];
}

//当用户停止拖拽的时候调用
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self addTimer];
}

//设置页码
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSInteger page = (int)(scrollView.contentOffset.x / scrollView.frame.size.width) % self.cellDataArr.count;
    
    if (page == self.cellDataArr.count - 1)
        page = 0;   // 如果滚动到了数组的最后一个数据，重置到第一张图片， 正向滚动到最后
    else if (page == 0)
        page = self.pageControl.numberOfPages; // 逆向滚动到最前
    
    self.pageControl.currentPage = page - 1;
    
    CGFloat offsetX = scrollView.contentOffset.x;
    if (self.pageControl.currentPage == 0 && (offsetX >= (self.cellDataArr.count - 2) * self.contentCollectionView.bounds.size.width))
    {
        // 如果正向滚动到数组的最后一个数据。 即显示第一张图
        if ([self.contentCollectionView numberOfSections] && [self.contentCollectionView numberOfItemsInSection:0] > 1)
        {
            NSIndexPath *tempIndexPath = [NSIndexPath indexPathForItem:1 inSection:0];  // 显示第一张图。即数组中的第二个数据
            [self.contentCollectionView scrollToItemAtIndexPath:tempIndexPath
                                               atScrollPosition:UICollectionViewScrollPositionNone
                                                       animated:NO];
        }
    }
    else if ((self.pageControl.currentPage == (self.pageControl.numberOfPages - 1)) && (offsetX == 0.0f))
    {
        // 如果反像滚动到数组的第一个数据。 即显示最后一张图
        if ([self.contentCollectionView numberOfSections] && [self.contentCollectionView numberOfItemsInSection:0] > self.cellDataArr.count - 2)
        {
            NSIndexPath *tempIndexPath = [NSIndexPath indexPathForItem:self.cellDataArr.count - 2 inSection:0];
            [self.contentCollectionView scrollToItemAtIndexPath:tempIndexPath
                                               atScrollPosition:UICollectionViewScrollPositionNone
                                                       animated:NO];
        }
    }
}

#pragma mark - UICollectionView Delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.cellDataArr.count > 1)
    {
        if ([self.delegate respondsToSelector:@selector(handleClickBannerImageView:)])
        {
            NSInteger index;
            if (indexPath.item == self.cellDataArr.count - 1)
                // 如果点击的是最后一个item，即没有滚动完成就点击了
                index = 0;
            else if (indexPath.item == 0)
                // 如果点击的是第一个item
                index = self.cellDataArr.count - 2;
            else
                // 正常的, 即第二个item开始 到 最后一个item前的item
                index = indexPath.item - 1;
            
            [self.delegate handleClickBannerImageView:index];
        }
    }
    else
    {
        if ([self.delegate respondsToSelector:@selector(handleClickBannerImageView:)])
        {
            [self.delegate handleClickBannerImageView:indexPath.item];
        }
    }
    
    if ([self.delegate respondsToSelector:@selector(handleClickBannerImageViewWithModel:)])
    {
        [self.delegate handleClickBannerImageViewWithModel:self.cellDataArr[indexPath.item]];
    }
}

- (InfiniteScrollBannerCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    InfiniteScrollBannerCell *cell = (InfiniteScrollBannerCell *)[collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    cell.backgroundColor           = [UIColor whiteColor];
    
    InfiniteScrollBannerModel *tempModel = self.cellDataArr[indexPath.item];
    
    if (tempModel.imageURLStr.length)
    {
        // 如果是网络图片URL
//        NSLog(@"imagee %@", self.loadingImage);
        if (!self.loadingImage)
        {
            NSLog(@"inexssssss");
        }
        
        [cell.bannerImageView sd_setImageWithURL:[NSURL URLWithString:tempModel.imageURLStr]
                                placeholderImage:self.loadingImage
                                         options:SDWebImageRetryFailed
                                       completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                           
                                       }];
    }
    else if (tempModel.image)
    {
        // 如果是本地图片
        [cell.bannerImageView setImage:tempModel.image];
    }
    else
    {
        // loading image
        [cell.bannerImageView setImage:self.loadingImage];
    }
    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.cellDataArr.count;
}

#pragma mark - setter & getter
- (UICollectionView *)contentCollectionView
{
    if (!_contentCollectionView)
    {
        UICollectionViewFlowLayout *flowLayout = [UICollectionViewFlowLayout new];
        flowLayout.itemSize                    = CGSizeMake(self.frame.size.width, self.frame.size.height);
        flowLayout.scrollDirection             = UICollectionViewScrollDirectionHorizontal;
        flowLayout.minimumInteritemSpacing     = 0;
        flowLayout.minimumLineSpacing          = 0;
        
        CGRect rect = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        UICollectionView *view = [[UICollectionView alloc] initWithFrame:rect
                                                    collectionViewLayout:flowLayout];
        view.delegate   = self;
        view.dataSource = self;
        
        view.backgroundColor                = [UIColor clearColor];
        view.pagingEnabled                  = YES;
        view.bounces                        = NO;
        view.showsVerticalScrollIndicator   = NO;
        view.showsHorizontalScrollIndicator = NO;
        view.contentSize                    = CGSizeMake(view.bounds.size.width, 0);
        
        [view registerClass:[InfiniteScrollBannerCell class] forCellWithReuseIdentifier:identifier];
        
        _contentCollectionView = view;
    }
    return _contentCollectionView;
}

- (UIPageControl *)pageControl
{
    if (!_pageControl)
    {
        UIPageControl *view = [UIPageControl new];
        
        view.userInteractionEnabled        = NO;
        
        view.currentPageIndicatorTintColor = [UIColor colorWithRed:1 green:0.42 blue:0.13 alpha:1];
        view.pageIndicatorTintColor        = [UIColor colorWithRed:0.8 green:0.78 blue:0.73 alpha:1];
        
        view.numberOfPages                 = 2;
        CGSize size                        = [view sizeForNumberOfPages:2];
        view.bounds                        = CGRectMake(0, 0, size.width, size.height);
        view.center                        = CGPointMake(self.center.x, self.frame.size.height - size.height / 2 - SpacingOfPageControlToBottom);
        
        _pageControl = view;
    }
    return _pageControl;
}

- (NSTimer *)timer
{
    if (!_timer)
    {
        _timer = [NSTimer scheduledTimerWithTimeInterval:self.durationOfScrollTime
                                                  target:self
                                                selector:@selector(autoScrollNextPage)
                                                userInfo:nil
                                                 repeats:YES];
        //        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
    return _timer;
}

// model
- (NSMutableArray *)cellDataArr
{
    if (!_cellDataArr)
    {
        NSMutableArray *arr = [NSMutableArray new];
        _cellDataArr        = arr;
    }
    return _cellDataArr;
}

@end

/**************** cell *****************/
/**
 *   imageView ContentMode 默认为 UIViewContentModeScaleToFill
 */
@implementation InfiniteScrollBannerCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self.contentView addSubview:self.bannerImageView];
    }
    return self;
}

- (UIImageView *)bannerImageView
{
    if (!_bannerImageView)
    {
        UIImageView *view        = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        view.contentMode         = UIViewContentModeScaleToFill;
        view.layer.masksToBounds = YES;
        _bannerImageView         = view;
    }
    return _bannerImageView;
}

@end


