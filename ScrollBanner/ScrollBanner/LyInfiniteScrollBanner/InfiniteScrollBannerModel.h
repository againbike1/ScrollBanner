//
//  InfiniteScrollBannerModel.h
//  InfiniteScrollBanner
//
//  Created by Lying on 16/6/26.
//  Copyright © 2016年 Lying. All rights reserved.
//

/**
 *  无限轮播器的model
 */
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface InfiniteScrollBannerModel : NSObject

@property (nonatomic, copy) NSString *bannerID;
@property (nonatomic, copy) NSString *imageURLStr;
@property (nonatomic, strong) UIImage *image;
@end
