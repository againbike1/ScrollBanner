//
//  ViewController.m
//  ScrollBanner
//
//  Created by Lying on 16/6/26.
//  Copyright © 2016年 Lying. All rights reserved.
//

#define ScreenWidth        ([ UIScreen mainScreen ].applicationFrame.size.width)

#import "ViewController.h"
//轮播
#import "InfiniteScrollBannerModel.h"
#import "InfiniteScrollBanner.h"

@interface ViewController ()<InfiniteScrollBannerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSArray *arr = [NSArray arrayWithObjects:
                    @"http://img3.fengniao.com/forum/attachpics/558/125/22304814.jpg",
                    @"http://img5.duitang.com/uploads/item/201409/18/20140918142427_iiXcB.jpeg",
                    @"http://cdn.duitang.com/uploads/item/201301/15/20130115130926_UGvAY.thumb.700_0.jpeg",
                    @"http://pic.baike.soso.com/p/20130816/20130816131745-2060560599.jpg", nil];
    [self SetScrollViewWithArray:arr];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)SetScrollViewWithArray:(NSArray*)array{
    
    //设置scroll图片
    CGFloat imageX = 0;
    CGFloat imageY = 0;
    CGFloat imageW = ScreenWidth;
    CGFloat imageH = ScreenWidth * 2/3;
     
    NSMutableArray *tempArr = [NSMutableArray new];
    for (int i = 0; i < array.count; i++)
    {
        InfiniteScrollBannerModel *tempModel = [InfiniteScrollBannerModel new];
        tempModel.bannerID = [NSString stringWithFormat:@"%i", i];
        //tempModel.image = [UIImage imageNamed:[NSString stringWithFormat:@"%i.jpg", i]];
        tempModel.imageURLStr = array[i];
        [tempArr addObject:tempModel];
    }
    InfiniteScrollBanner *view = [InfiniteScrollBanner setupBannerWithFrame:CGRectMake(imageX, imageY, imageW, imageH)
                                                                 DataSource:tempArr];
    view.durationOfScrollTime  = 3.0f;
    view.loadingImage          = [UIImage imageNamed:@"loading.jpg"];
    view.delegate              = self;
    [self.view addSubview:view];
    
}


#pragma mark - 首页轮播器点击
//-(void)scrollViewDidClickedAtPage:(NSInteger)pageNumber
- (void)handleClickBannerImageView:(NSInteger)pageNumber{
 
    NSLog(@"Click %d",pageNumber);

}


@end
