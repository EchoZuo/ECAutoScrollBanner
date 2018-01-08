//
//  ECAutoScrollBanner.m
//  ECAutoScrollBanner
//
//  Created by EchoZuo on 2017/11/21.
//  Copyright © 2017年 Echo.Z. All rights reserved.
//

#define     DefaultPageInterval     3.0f    // 默认自动翻页时间
#define     StartPageTimeInterval   1.5f    // 默认开始翻页时间


#import "ECAutoScrollBanner.h"
#import "YYWebImage.h"

typedef NS_ENUM(NSUInteger, BannerType) {
    BannerType_TextBanner         = 0,      // 文本banner
    BannerType_LocalImageBanner   = 1,      // 本地文本图片banner
    BannerType_UrlImageBanner     = 2,      // url图片banner
    BannerType_ViewsBanner        = 3,      // 文本banner
};

@interface ECAutoScrollBanner () <UIScrollViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, strong) UIPageControl *pageControl;

@property (nonatomic, assign) ECAutoScrollBannerScrollDirection bannerScrollDirection;

@property (nonatomic, strong) NSMutableArray *mainDataSource;
@property (nonatomic, strong) UIImage *placeholderImage;

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) BOOL isLock;

@property (nonatomic, assign) BannerType bannerType;


@end

@implementation ECAutoScrollBanner

#pragma mark -
#pragma mark -------------------- init --------------------

- (void)dealloc {
    [self.timer invalidate];
    self.timer = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

+ (instancetype)initTextBannerWithFrame:(CGRect)frame withTextDataSource:(NSArray *)textDataSource withBannerScrollDirection:(ECAutoScrollBannerScrollDirection)bannerScrollDirection {
    return [[ECAutoScrollBanner alloc] initTextBannerWithFrame:frame withTextDataSource:textDataSource withBannerScrollDirection:bannerScrollDirection];
}

- (instancetype)initTextBannerWithFrame:(CGRect)frame withTextDataSource:(NSArray *)textDataSource withBannerScrollDirection:(ECAutoScrollBannerScrollDirection)bannerScrollDirection {
    self = [super initWithFrame:frame];
    if (self) {
        [self addNSNotification];
        [self.mainDataSource addObjectsFromArray:textDataSource];
        self.bannerType = BannerType_TextBanner;
        self.bannerScrollDirection = bannerScrollDirection;
        [self configUI];
    }
    return self;
}

+ (instancetype)initLocalImageBannerWithFrame:(CGRect)frame withImageDataSource:(NSArray *)imageDataSource withBannerScrollDirection:(ECAutoScrollBannerScrollDirection)bannerScrollDirection {
    return [[ECAutoScrollBanner alloc] initLocalImageBannerWithFrame:frame withImageDataSource:imageDataSource withBannerScrollDirection:bannerScrollDirection];
}

- (instancetype)initLocalImageBannerWithFrame:(CGRect)frame withImageDataSource:(NSArray *)imageDataSource withBannerScrollDirection:(ECAutoScrollBannerScrollDirection)bannerScrollDirection {
    self = [super initWithFrame:frame];
    if (self) {
        [self addNSNotification];
        [self.mainDataSource addObjectsFromArray:imageDataSource];
        self.bannerType = BannerType_LocalImageBanner;
        self.bannerScrollDirection = bannerScrollDirection;
        [self configUI];
    }
    return self;
}

+ (instancetype)initOnlineImageBannerWithFrame:(CGRect)frame withImageUrlDataSource:(NSArray *)imageUrlDataSource withPlaceholderImage:(UIImage *)placeholderImage withBannerScrollDirection:(ECAutoScrollBannerScrollDirection)bannerScrollDirection {
    return [[ECAutoScrollBanner alloc] initOnlineImageBannerWithFrame:frame withImageUrlDataSource:imageUrlDataSource withPlaceholderImage:placeholderImage withBannerScrollDirection:bannerScrollDirection];
}

- (instancetype)initOnlineImageBannerWithFrame:(CGRect)frame withImageUrlDataSource:(NSArray *)imageUrlDataSource withPlaceholderImage:(UIImage *)placeholderImage withBannerScrollDirection:(ECAutoScrollBannerScrollDirection)bannerScrollDirection {
    self = [super initWithFrame:frame];
    if (self) {
        [self addNSNotification];
        [self.mainDataSource addObjectsFromArray:imageUrlDataSource];
        self.bannerType = BannerType_UrlImageBanner;
        self.placeholderImage = placeholderImage;
        self.bannerScrollDirection = bannerScrollDirection;
        [self configUI];
    }
    return self;
}

+ (instancetype)initViewBannerWithFrame:(CGRect)frame withViewsDataSouce:(NSArray *)viewsDataSouce withBannerScrollDirection:(ECAutoScrollBannerScrollDirection)bannerScrollDirection {
    return [[ECAutoScrollBanner alloc] initViewBannerWithFrame:frame withViewsDataSouce:viewsDataSouce withBannerScrollDirection:bannerScrollDirection];
}

- (instancetype)initViewBannerWithFrame:(CGRect)frame withViewsDataSouce:(NSArray *)viewsDataSouce withBannerScrollDirection:(ECAutoScrollBannerScrollDirection)bannerScrollDirection {
    self = [super initWithFrame:frame];
    if (self) {
        [self addNSNotification];
        [self.mainDataSource addObjectsFromArray:viewsDataSouce];
        self.bannerType = BannerType_ViewsBanner;
        self.bannerScrollDirection = bannerScrollDirection;
        [self configUI];
    }
    return self;
}

- (NSMutableArray *)mainDataSource {
    if (_mainDataSource == nil) {
        _mainDataSource = [[NSMutableArray alloc] init];
    }
    return _mainDataSource;
}



#pragma mark -
#pragma mark -------------------- configUI --------------------

- (void)addNSNotification
{
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self
                      selector:@selector(applicationDidEnterBackground:)
                          name:UIApplicationDidEnterBackgroundNotification
                        object:nil];
    [defaultCenter addObserver:self
                      selector:@selector(applicationWillEnterForeground:)
                          name:UIApplicationWillEnterForegroundNotification
                        object:nil];
}

- (void)configUI
{
    // 默认的banner是一个没有无限循环，非自动播放，并且展示pageControl的banner
    self.isLock = NO;
    self.isHavePageControl = YES;
    self.userInteractionEnabled = YES;
    self.backgroundColor = [UIColor clearColor];
    [self addSubview:self.collectionView];
    [self addSubview:self.pageControl];
    
    [self reloadCollectionView];
}

- (UICollectionView *)collectionView {
    if (_collectionView == nil) {
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:self.flowLayout];
        _collectionView.backgroundColor = [UIColor lightGrayColor];
        _collectionView.pagingEnabled = YES;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.scrollsToTop = YES;
        _collectionView.scrollEnabled = YES;
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([self class])];
    }
    
    return _collectionView;
}

- (UICollectionViewFlowLayout *)flowLayout {
    if (_flowLayout == nil) {
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _flowLayout.minimumLineSpacing = 0;
        _flowLayout.minimumInteritemSpacing = 0;
        if (self.bannerScrollDirection == ECAutoScrollBannerScrollDirectionHorizontal) {
            self.flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        } else {
            self.flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        }
        _flowLayout.itemSize = self.frame.size;
    }
    return _flowLayout;
}

- (UIPageControl *)pageControl {
    if (_pageControl == nil) {
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 20, self.frame.size.width, 20)];
        _pageControl.pageIndicatorTintColor = [UIColor darkGrayColor];
        _pageControl.currentPageIndicatorTintColor = [UIColor lightGrayColor];
        _pageControl.currentPage = 0;
        _pageControl.numberOfPages = self.mainDataSource.count;
    }
    return _pageControl;
}

- (void)reloadCollectionView
{
    // 无限循环
    if (self.isInfinitePaging) {
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    } else {
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    }

    [self.collectionView reloadData];
    
    // 自动翻页
    if (self.isAutoPaging) {
        
        if (self.autoPageInterval == 0) {
            self.autoPageInterval = DefaultPageInterval;
        }
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(StartPageTimeInterval * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.timer setFireDate:[NSDate distantPast]];
        });
    }
}


#pragma mark -
#pragma mark -------------------- setters --------------------
- (void)setIsAutoPaging:(BOOL)isAutoPaging {
    _isAutoPaging = isAutoPaging;
    [self reloadCollectionView];
}

- (void)setIsHavePageControl:(BOOL)isHavePageControl {
    _isHavePageControl = isHavePageControl;
    // 展示pageControl
    self.pageControl.hidden = !_isHavePageControl;
}

- (void)setIsInfinitePaging:(BOOL)isInfinitePaging {
    _isInfinitePaging = isInfinitePaging;
    // 无限循环
    if (self.isInfinitePaging) {
        [self.mainDataSource insertObject:self.mainDataSource[self.mainDataSource.count - 1] atIndex:0];
        [self.mainDataSource insertObject:self.mainDataSource[0 + 1] atIndex:self.mainDataSource.count];
        self.pageControl.numberOfPages = self.mainDataSource.count - 2;
    } else {
        self.pageControl.numberOfPages = self.mainDataSource.count;
    }
    [self reloadCollectionView];
}

- (void)setPageControlFrame:(CGRect)pageControlFrame {
    _pageControlFrame = pageControlFrame;
   [self.pageControl setFrame:_pageControlFrame];
}

- (void)setIsEnabledPanGestureRecognizer:(BOOL)isEnabledPanGestureRecognizer {
    _isEnabledPanGestureRecognizer = isEnabledPanGestureRecognizer;
}

- (void)setAutoPageInterval:(CGFloat)autoPageInterval {
    _autoPageInterval = autoPageInterval;
}

- (void)setBannerType:(BannerType)bannerType {
    _bannerType = bannerType;
}

- (void)setBannerScrollDirection:(ECAutoScrollBannerScrollDirection)bannerScrollDirection {
    _bannerScrollDirection = bannerScrollDirection;
}



#pragma mark -
#pragma mark -------------------- private methods --------------------

- (NSTimer *)timer {
    if (_timer == nil) {

        _timer = [NSTimer timerWithTimeInterval:self.autoPageInterval target:self selector:@selector(nextPage:) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
        [_timer setFireDate:[NSDate distantFuture]];
    }
    return _timer;
}

- (void)startTimer
{
    self.isLock = NO;
    [self.timer setFireDate:[NSDate distantPast]];
}

- (void)stopTimer
{
    [self.timer setFireDate:[NSDate distantFuture]];
}

- (void)tapScrollBannerItemAction:(UITapGestureRecognizer *)sender
{
    if ([self.delegate respondsToSelector:@selector(tapScrollBannerItem:withObject:)]) {
        [self.delegate tapScrollBannerItem:sender.view.tag withObject:self];
    }
}

- (void)nextPage:(id)sender
{
    int page = 0;
    if (self.bannerScrollDirection == ECAutoScrollBannerScrollDirectionHorizontal) {
        page = self.collectionView.contentOffset.x / self.collectionView.frame.size.width;
    } else {
        page = self.collectionView.contentOffset.y / self.collectionView.frame.size.height;
    }

    page ++;

    // 如果不是无限循环的话，翻页到最后一页的时候需要回到首页page = 0
    if (!self.isInfinitePaging) {
        if (page == self.mainDataSource.count) {
            page = 0;
        }
    }

    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:page inSection:0];
    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
}



#pragma mark -
#pragma mark -------------------- UICollectionViewDelegate, UICollectionViewDataSource --------------------
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.mainDataSource) {
        return self.mainDataSource.count;
    } else {
        return 1;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([self class]) forIndexPath:indexPath];
    cell.selectedBackgroundView = [UIView new];
    
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    
    if (self.mainDataSource.count > 0) {
        if (self.bannerType == BannerType_TextBanner) {
            [self setTextBannerCellWithCell:cell withIndexPath:indexPath];
        } else if (self.bannerType == BannerType_LocalImageBanner || self.bannerType == BannerType_UrlImageBanner) {
            [self setImageBannerCellWithCell:cell withIndexPath:indexPath];
        } else {
            [self setViewsBannerCellWithCell:cell withIndexPath:indexPath];
        }
    } else {
        // 传入数据有问题，直接展示空view
        cell.contentView.backgroundColor = [UIColor orangeColor];
    }
    
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    // didSelectItem
    [collectionView deselectItemAtIndexPath:indexPath animated:NO];
    if (self.delegate && [self.delegate respondsToSelector:@selector(tapScrollBannerItem:withObject:)]) {
        if (self.isAutoPaging) {
            [self.delegate tapScrollBannerItem:indexPath.item - 1 withObject:nil];
        } else {
            [self.delegate tapScrollBannerItem:indexPath.item withObject:nil];
        }
    }
}

// BannerType_TextBanner
- (void)setTextBannerCellWithCell:(UICollectionViewCell *)cell withIndexPath:(NSIndexPath *)indexPath {
    if (self.bannerType == BannerType_TextBanner) {
        // textBanner 自定义文本效果
        UILabel *label = [[UILabel alloc] initWithFrame:cell.contentView.bounds];
        label.backgroundColor = [UIColor orangeColor];
        label.textColor = [UIColor purpleColor];
        label.userInteractionEnabled = YES;
        if (@available(iOS 8.2, *)) {
            label.font = [UIFont systemFontOfSize:16 weight:UIFontWeightLight];
        } else {
            label.font = [UIFont systemFontOfSize:16];
        }
        
        if (self.mainDataSource[indexPath.item] || [self.mainDataSource[indexPath.item] isKindOfClass:[NSString class]]) {
            label.text = self.mainDataSource[indexPath.item];
        }
        [cell.contentView addSubview:label];
    }
}

// BannerType_LocalImageBanner || BannerType_UrlImageBanner
- (void)setImageBannerCellWithCell:(UICollectionViewCell *)cell withIndexPath:(NSIndexPath *)indexPath {
    if (self.bannerType == BannerType_LocalImageBanner) {
        // 本地图片展示
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:cell.contentView.bounds];
        imageView.backgroundColor = [UIColor lightGrayColor];
        imageView.userInteractionEnabled = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        [cell.contentView addSubview:imageView];
        
        if ([self.mainDataSource[indexPath.item] isKindOfClass:[UIImage class]]) {
            [imageView setImage:self.mainDataSource[indexPath.item]];
        }
    } else {
        // 网络图片展示
        UIImageView *imageView = [YYAnimatedImageView new];
        imageView.frame = cell.contentView.bounds;
        imageView.backgroundColor = [UIColor lightGrayColor];
        imageView.userInteractionEnabled = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        [cell.contentView addSubview:imageView];
        if ([self.mainDataSource[indexPath.item] isKindOfClass:[NSString class]]) {
            [imageView yy_setImageWithURL:[NSURL URLWithString:self.mainDataSource[indexPath.item]] options:YYWebImageOptionProgressiveBlur | YYWebImageOptionSetImageWithFadeAnimation];
        }
    }
}

// BannerType_ViewsBanner
- (void)setViewsBannerCellWithCell:(UICollectionViewCell *)cell withIndexPath:(NSIndexPath *)indexPath {
    if (self.bannerType == BannerType_ViewsBanner) {
        if ([self.mainDataSource[indexPath.item] isKindOfClass:[UIView class]]) {
            [cell.contentView addSubview:self.mainDataSource[indexPath.item]];
        }
    }
}



#pragma mark -
#pragma mark -------------------- UIScrollViewDelegate --------------------

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    // 用户开始拖拽
    if (self.isAutoPaging) {
        [self stopTimer];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    // 用户停止拖拽
    if (decelerate) {
        if (self.isAutoPaging) {
            if (!self.isLock) {
                [self performSelector:@selector(startTimer) withObject:nil afterDelay:StartPageTimeInterval];
                self.isLock = YES;
            }
        }
    }
}

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



#pragma mark -
#pragma mark -------------------- system observe --------------------
/*
 UIApplicationDidEnterBackgroundNotification
 UIApplicationWillEnterForegroundNotification   
 */

- (void)applicationDidEnterBackground:(NSNotification *)notification {
    if (self.isAutoPaging) {
        [self stopTimer];
    }
}

- (void)applicationWillEnterForeground:(NSNotification *)notification {
    if (self.isAutoPaging) {
        if (!self.isLock) {
            [self performSelector:@selector(startTimer) withObject:nil afterDelay:StartPageTimeInterval];
            self.isLock = YES;
        }
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
