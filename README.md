
# ECAutoScrollBanner
轮播图封装。可以实现自动定时翻页、手动翻页；垂直和水平滚动等。支持纯文本、本地图片、网络图片以及其他view试图。

#### bug fix：
1. 创建view试图类的轮播图优化修复。（注意：view视图类的轮播中，view的坐标是相对于cell.contentView的坐标，是contentView的子视图）


### [Navigation 导航](https://github.com/EchoZuo/ECAutoScrollBanner/blob/master/README.md#navigation-%E5%AF%BC%E8%88%AA)
- [Abstract 概要](https://github.com/EchoZuo/ECAutoScrollBanner/blob/master/README.md#abstract-%E6%A6%82%E8%A6%81)
    - [简介&特性](https://github.com/EchoZuo/ECAutoScrollBanner/blob/master/README.md#%E7%AE%80%E4%BB%8B%E7%89%B9%E6%80%A7)
    - [效果图](https://github.com/EchoZuo/ECAutoScrollBanner/blob/master/README.md#%E6%95%88%E6%9E%9C%E5%9B%BE)
- [Explain 说明](https://github.com/EchoZuo/ECAutoScrollBanner/blob/master/README.md#explain-%E8%AF%B4%E6%98%8E)
    - [实现方式](https://github.com/EchoZuo/ECAutoScrollBanner/blob/master/README.md#%E5%AE%9E%E7%8E%B0%E6%96%B9%E5%BC%8F)
    - [详细介绍](https://github.com/EchoZuo/ECAutoScrollBanner/blob/master/README.md#%E8%AF%A6%E7%BB%86%E4%BB%8B%E7%BB%8D)
- [Usage 使用](https://github.com/EchoZuo/ECAutoScrollBanner/blob/master/README.md#usage-%E4%BD%BF%E7%94%A8)
    - [使用示例](https://github.com/EchoZuo/ECAutoScrollBanner/blob/master/README.md#%E4%BD%BF%E7%94%A8%E7%A4%BA%E4%BE%8B)
- [More 更多](https://github.com/EchoZuo/ECAutoScrollBanner/blob/master/README.md#more-%E6%9B%B4%E5%A4%9A)
    

## Abstract 概要

### 简介&特性
#### 轮播图封装，网上有很多现成的demo，也没什么难度。这个是很早之前写过的轮播图封装，这次正好需要就重新整理一下发出来，希望能帮助到需要的人。
- 支持手动翻页、自动定时翻页
- 支持垂直和水平滚动
- 支持本地图片、网络图片、纯文本以及其他View视图，如图文混合排版的视图等。
- 支持设置展示和隐藏pageControl和自定义pageControl的frame
- 可以做简便修改，将需要的特定属性开放使用

### 效果图
![image](https://note.youdao.com/yws/public/resource/5a3dec8d14237d5e34e77b2ad11315d0/xmlnote/WEBRESOURCE9d7fbe514ad6605143c4c228d6c2756d/12562)

## Explain 说明

### 实现方式
###### 轮播图基本实现思路有如下几种，本次封装使用的是第一种方式，用UICollectionView实现。
1. 基于UICollectionView的封装（推荐使用）
    1. 实现简便，使用方便，并且实现代码也不复杂；
    2. 大量加载和滚动或者自动轮播的时候基本不需要考虑重用性能等问题
2. 用UIScrollView+UIImageView的方式实现A
    1. 用户看到的是多个UIImageView的实现方式；
    2. 如果数据太多，需要考虑到重用等性能问题；
    3. 如果底层是UITableView并且轮播图是作为cell的话，更需要考虑到tableView嵌套scrollView的滚动性能问题。
3. 用UIScrollView+UIImageView的方式实现B
    1. 只需要创建3个UIImageView，不需要考虑重用问题；
    2. 与第二种不同的就是用户永远看到的是中间那个UIImageView，只是上面的内容再不断变化，其内部实现其实是在不断的改变那个轮播数组。
4. 只有一个UIImageView
    1. 这种实现方式不再基于ScrollView，同样不存在重用等的问题。这种实现方式跟第三种有相似之处，但是它跟第三种的区别是不再使用scrollView的图片切换方式。还是不停地去改变这个数组的内容。这种实现方式的核心在于切换的时候使用自定义的layer层的转场动画。模拟scrollView的滑动效果。

###### 本次封装实现思路
- 底层采用UICollectionView当控制器。给原数据源下标0位添加原数据源末尾数据，给元数据源下标末尾添加原数据源0位的数据。以此形成一个新的数据源。可以参考下图
![image](https://note.youdao.com/yws/public/resource/5a3dec8d14237d5e34e77b2ad11315d0/xmlnote/WEBRESOURCE4121478c45a2dc739c21d924f3c3e760/12680)

###### 支持手动翻页和定时翻页
- 手动翻页没什么可说的。自动翻页其实就是一个简单的定时器（用NSTimer和GCD都ok）实现定时调用对应的翻页方法即可。

###### 支持竖向垂直翻页和水平翻页
```Objective-C
typedef NS_ENUM(NSInteger, ECAutoScrollBannerScrollDirection){
    ECAutoScrollBannerScrollDirectionVertical       = 1,    // 竖向滚动
    ECAutoScrollBannerScrollDirectionHorizontal     = 0,    // 横向滚动
};
```


### 详细介绍
###### 开放的一些设置属性（代码中注释都很详细，也可以直接翻看源码即可）
```Objective-C
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
```

###### 主要的一些计算
```Objective-C
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.isAutoPaging) {
        scrollView.panGestureRecognizer.enabled = self.isEnabledPanGestureRecognizer;
    }
    
    NSInteger page = 0;
    
    // 是否无限循环
    if (!self.isInfinitePaging) {
        if (self.bannerScrollDirection == ECAutoScrollBannerScrollDirectionHorizontal) {
            page = scrollView.contentOffset.x / scrollView.frame.size.width;
        } else {
            page = scrollView.contentOffset.y / scrollView.frame.size.height;
        }
        self.pageControl.currentPage = page;
    } else {
        if (self.bannerScrollDirection == ECAutoScrollBannerScrollDirectionHorizontal) {
            page = scrollView.contentOffset.x / scrollView.frame.size.width;
            
            // 第一张
            if ((page == 0) && (scrollView.contentOffset.x <= 30)) {
                page = self.mainDataSource.count - 2;
                
                NSIndexPath *indexPath = [NSIndexPath indexPathForItem:page inSection:0];
                [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
            } else if ((page == self.mainDataSource.count - 1) && (scrollView.contentOffset.x >= scrollView.contentSize.width - scrollView.frame.size.width - 30)) {
                // 最后一张
                page = 0 + 1;
                NSIndexPath *indexPath = [NSIndexPath indexPathForItem:page inSection:0];
                [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
            }
        } else {
            page = scrollView.contentOffset.y / scrollView.frame.size.height;
            
            // 第一张
            if ((page == 0) && (scrollView.contentOffset.y <= 30)) {
                page = self.mainDataSource.count - 2;
                
                NSIndexPath *indexPath = [NSIndexPath indexPathForItem:page inSection:0];
                [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
            } else if ((page == self.mainDataSource.count - 1) && (scrollView.contentOffset.y >= scrollView.contentSize.height - scrollView.frame.size.height - 30)) {
                // 最后一张
                page = 0 + 1;
                NSIndexPath *indexPath = [NSIndexPath indexPathForItem:page inSection:0];
                [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
            }
        }
        self.pageControl.currentPage = page - 1;
    }
}
```


## Usage 使用

### 使用方式
1. 将ECAutoScrollBanner文件夹直接拖入项目中，导入头文件#import "ECAutoScrollBanner.h"
2. CocoaPods：pod 'ECAutoScrollBanner'

### 使用示例
#### 其实使用起来很便捷很简单。只需要初始化，然后设置相关属性即可。支持先默认初始化，在需要的时候设置其样式和翻页效果翻页时间等。
#### 纯文本滚动条，适用于广告、新闻资讯等
```Objective-C
- (ECAutoScrollBanner *)textBannerView {
    if (_textBannerView == nil) {
        _textBannerView = [ECAutoScrollBanner initTextBannerWithFrame:self.topView.bounds withTextDataSource:self.textDataArray withBannerScrollDirection:ECAutoScrollBannerScrollDirectionVertical];
        _textBannerView.delegate = self;
        _textBannerView.isAutoPaging = YES;
        _textBannerView.isHavePageControl = NO;
        _textBannerView.isInfinitePaging = YES;
        _textBannerView.isEnabledPanGestureRecognizer = NO;
        _textBannerView.autoPageInterval = 4.0f;
    }
    return _textBannerView;
}
```

###### 如果需要点击跳转等，实现协议和协议方法即可，下同。
```Objective-C
- (void)tapScrollBannerItem:(NSInteger)itemTag withObject:(id)object {
    NSLog(@"文本banner。点击了第%ld个子item，下标%ld", (long)itemTag + 1, (long)itemTag);
}
```

#### 手动翻页的图片banner，本地图片
```Objective-C
- (ECAutoScrollBanner *)imageBannerView {
    if (_imageBannerView == nil) {
        _imageBannerView = [ECAutoScrollBanner initLocalImageBannerWithFrame:CGRectMake(0, 30, self.bottomView.frame.size.width, 180) withImageDataSource:self.imageDataArray withBannerScrollDirection:ECAutoScrollBannerScrollDirectionHorizontal];
        _imageBannerView.isAutoPaging = NO;
    }
    return _imageBannerView;
}
```

#### 自动翻页的图片banner，url图片
```Objective-C
- (ECAutoScrollBanner *)urlImageBannerVeiw {
    if (_urlImageBannerVeiw == nil) {
        UIImageView *placehodelImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 50 + 50 + 10 + 180 + 10, self.view.frame.size.width, 180)];
        placehodelImage.backgroundColor = [UIColor lightGrayColor];
        _urlImageBannerVeiw = [ECAutoScrollBanner initOnlineImageBannerWithFrame:CGRectMake(0, 50 + 50 + 10 + 180 + 10, self.view.frame.size.width, 180) withImageUrlDataSource:self.imageUrlDataArray withPlaceholderImage:placehodelImage.image withBannerScrollDirection:ECAutoScrollBannerScrollDirectionHorizontal];
        _urlImageBannerVeiw.isAutoPaging = YES;
        _urlImageBannerVeiw.isEnabledPanGestureRecognizer = YES;
        _urlImageBannerVeiw.isInfinitePaging = YES;
    }
    return _urlImageBannerVeiw;
}
```

#### 手动翻页的view视图轮播
###### （注意：view视图类的轮播中，view的坐标是相对于cell.contentView的坐标，是contentView的子视图）
```Objective-C
- (ECAutoScrollBanner *)viewBannerView {
    if (_viewBannerView == nil) {
        _viewBannerView = [[ECAutoScrollBanner alloc] initViewBannerWithFrame:CGRectMake(0, 20 + 180 + 20 + 180 + 20, self.view.frame.size.width, 180) withViewsDataSouce:self.viewDataArray withBannerScrollDirection:ECAutoScrollBannerScrollDirectionHorizontal];
        _viewBannerView.isAutoPaging = NO;
    }
    return _viewBannerView;
}
```


## More 更多
- https://github.com/EchoZuo
- Email: zuoqianheng@foxmail.com || QQ:615125175 
- 简书：[@EchoZuo](http://www.jianshu.com/u/3390ce71084e)
