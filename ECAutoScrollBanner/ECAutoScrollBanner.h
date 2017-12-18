//
//  ECAutoScrollBanner.h
//  ECAutoScrollBanner
//
//  Created by EchoZuo on 2017/11/21.
//  Copyright © 2017年 Echo.Z. All rights reserved.
//

//  ********************** 轮播图封装 ********************** //
 // 轮播图封装。可以实现自动定时翻页、手动翻页；垂直和水平滚动等。支持纯文本、本地图片、网络图片以及其他view试图。


@import UIKit;

typedef NS_ENUM(NSInteger, ECAutoScrollBannerScrollDirection){
    ECAutoScrollBannerScrollDirectionVertical       = 1,    // 竖向滚动
    ECAutoScrollBannerScrollDirectionHorizontal     = 0,    // 横向滚动
};

@protocol ECAutoScrollBannerDelegate <NSObject>

@optional
/**
 点击banner
 
 @param itemTag tag
 @param object object
 */
- (void)tapScrollBannerItem:(NSInteger)itemTag withObject:(id)object;

@end

@interface ECAutoScrollBanner : UIView


/**
 * delegate，非必
 */
@property (nonatomic, weak) id<ECAutoScrollBannerDelegate> delegate;

/**
 * 是否自动翻页，默认NO，非必
 */
@property (nonatomic, assign) BOOL isAutoPaging;

/**
 * 是否展示PageControl，默认YES，非必
 */
@property (nonatomic, assign) BOOL isHavePageControl;

/**
 * 是否无限循环，默认NO，非必
 */
@property (nonatomic, assign) BOOL isInfinitePaging;

/**
 * 自动翻页的时候知否支持手动滑动，必须在isAutoPaging=YES时候设置才有效果，if isAutoPaging=YES，则这个必须设置
 */
@property (nonatomic, assign) BOOL isEnabledPanGestureRecognizer;

/**
 * collectionView backgroundColor，默认lightGrayColor，非必
 */
@property (nonatomic, strong) UIColor *collectionViewBgColor;

/**
 * 可以自定义pageControl的frame（相对于self），必须isHavePageControl=YES，如果没有设置新坐标，则取默认坐标，非必
 */
@property (nonatomic, assign) CGRect pageControlFrame;

/**
 * 自动翻页间隔时间。需isAutoPaging=YES才需要设置，否则设置什么效果。默认3.0f
 */
@property (nonatomic, assign) CGFloat  autoPageInterval;




/**
 初始化一个文本轮播banner
 默认是一个没有无限循环，非自动播放，并且展示pageControl的banner
 
 @param frame frame
 @param textDataSource dataSource
 @param bannerScrollDirection ECAutoScrollBannerScrollDirection
 @return id
 */
+ (instancetype)initTextBannerWithFrame:(CGRect)frame withTextDataSource:(NSArray *)textDataSource withBannerScrollDirection:(ECAutoScrollBannerScrollDirection)bannerScrollDirection;
- (instancetype)initTextBannerWithFrame:(CGRect)frame withTextDataSource:(NSArray *)textDataSource withBannerScrollDirection:(ECAutoScrollBannerScrollDirection)bannerScrollDirection;


/**
 初始化一个本地图片轮播banner
 默认是一个没有无限循环，非自动播放，并且展示pageControl的banner

 @param frame frame
 @param imageDataSource imageDataSource
 @param bannerScrollDirection ECAutoScrollBannerScrollDirection
 @return id
 */
+ (instancetype)initLocalImageBannerWithFrame:(CGRect)frame withImageDataSource:(NSArray *)imageDataSource withBannerScrollDirection:(ECAutoScrollBannerScrollDirection)bannerScrollDirection;
- (instancetype)initLocalImageBannerWithFrame:(CGRect)frame withImageDataSource:(NSArray *)imageDataSource withBannerScrollDirection:(ECAutoScrollBannerScrollDirection)bannerScrollDirection;


/**
 初始化一个url图片轮播banner
 默认是一个没有无限循环，非自动播放，并且展示pageControl的banner

 @param frame frame
 @param imageUrlDataSource imageUrlDataSource
 @param bannerScrollDirection ECAutoScrollBannerScrollDirection
 @return id
 */
+ (instancetype)initOnlineImageBannerWithFrame:(CGRect)frame withImageUrlDataSource:(NSArray *)imageUrlDataSource withPlaceholderImage:(UIImage *)placeholderImage withBannerScrollDirection:(ECAutoScrollBannerScrollDirection)bannerScrollDirection;
- (instancetype)initOnlineImageBannerWithFrame:(CGRect)frame withImageUrlDataSource:(NSArray *)imageUrlDataSource withPlaceholderImage:(UIImage *)placeholderImage withBannerScrollDirection:(ECAutoScrollBannerScrollDirection)bannerScrollDirection;


/**
 初始化一个view试图轮播banner

 @param frame frame
 @param viewsDataSouce viewsDataSouce
 @param bannerScrollDirection ECAutoScrollBannerScrollDirection
 @return id
 */
+ (instancetype)initViewBannerWithFrame:(CGRect)frame withViewsDataSouce:(NSArray *)viewsDataSouce withBannerScrollDirection:(ECAutoScrollBannerScrollDirection)bannerScrollDirection;
- (instancetype)initViewBannerWithFrame:(CGRect)frame withViewsDataSouce:(NSArray *)viewsDataSouce withBannerScrollDirection:(ECAutoScrollBannerScrollDirection)bannerScrollDirection;


@end

