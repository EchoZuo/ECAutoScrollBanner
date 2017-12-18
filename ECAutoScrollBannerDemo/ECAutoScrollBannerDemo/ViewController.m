//
//  ViewController.m
//  ECAutoScrollBannerDemo
//
//  Created by EchoZuo on 2017/11/27.
//  Copyright © 2017年 Echo.Z. All rights reserved.
//

#import "ViewController.h"
#import "ECAutoScrollBanner.h"

@interface ViewController ()<ECAutoScrollBannerDelegate>


@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) ECAutoScrollBanner *textBannerView;
@property (nonatomic, strong) ECAutoScrollBanner *imageBannerView;
@property (nonatomic, strong) ECAutoScrollBanner *urlImageBannerVeiw;

@property (nonatomic, strong) NSMutableArray *textDataArray;
@property (nonatomic, strong) NSMutableArray *imageDataArray;
@property (nonatomic, strong) NSMutableArray *imageUrlDataArray;

@end

@implementation ViewController


#pragma mark -
#pragma mark -------------------- lifecycle --------------------

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    [self initData];
    [self configUI];
}



#pragma mark -
#pragma mark -------------------- init data --------------------

- (void)initData
{
    self.textDataArray = [[NSMutableArray alloc] initWithObjects:
                          @"习近平履职“满月”观察：落子开局新时代",
                          @"世界互联网大会6天后登场：乌镇更贴心,也更智能了",
                          @"国资划转社保预估超10万亿 谁将入围试点企业",
                          @"中央候补委员、中石化总经理戴厚良当选工程院院士",
                          @"央视披露东风-41细节：部分技术超美俄 试射无失败",
                          @"2020年中国高铁将达3万公里 铁总负债4.8万亿",
                          @"外媒首曝:中国轰-6K已进入全天24小时警戒值班！",
                          @"警方通报：宁波爆炸排除人为故意制造爆炸可能",
                          @"一家两代接力赡养无腿邻居35年 只为当年一句承诺",
                          @"澳公寓取名“翰林院” 当地居民不满：是让我们滚吗",nil];
    
    self.imageDataArray = [[NSMutableArray alloc] init];
    
    for (int i = 1; i < 10; i++) {
        @autoreleasepool {
            NSString *imagePath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"image%d",i] ofType:@"png"];
            UIImage *image = [[UIImage alloc] initWithContentsOfFile:imagePath];
            [self.imageDataArray addObject:image];
        }
    }
    
    self.imageUrlDataArray = [[NSMutableArray alloc] initWithObjects:
                              @"https://ss0.bdstatic.com/94oJfD_bAAcT8t7mm9GUKT-xh_/timg?image&quality=100&size=b4000_4000&sec=1511947863&di=06a96dd31237a86e7ebd4ccd407bf95d&src=http://www.dabaoku.com/sucai/dongwulei/dongwuhj1/0055.jpg",
                              @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1511957963138&di=3d8c7377ec28d6919d72ad3acde5ddb4&imgtype=0&src=http%3A%2F%2Fimg2.3lian.com%2F2014%2Ff3%2F71%2Fd%2F1.jpg",
                              @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1511957963137&di=c5a6eac2e4cb2216e795c158e0e47f96&imgtype=0&src=http%3A%2F%2Fimgsrc.baidu.com%2Fimage%2Fc0%253Dshijue1%252C0%252C0%252C294%252C40%2Fsign%3D99842a2f566034a83defb0c2a37a2321%2F5fdf8db1cb13495409824b4a5c4e9258d1094a7b.jpg",
                              @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1511957963137&di=aa6981998c261f77a9a7d0e880571e19&imgtype=0&src=http%3A%2F%2Fimgsrc.baidu.com%2Fimage%2Fc0%253Dshijue1%252C0%252C0%252C294%252C40%2Fsign%3D0b5c871d7acf3bc7fc0dc5afb969d0d4%2F9e3df8dcd100baa1a1443cab4d10b912c8fc2eb1.jpg",
                              @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1511957963137&di=031f8c11fc3aeac811ba5b48c49c48c0&imgtype=0&src=http%3A%2F%2Fimgsrc.baidu.com%2Fimage%2Fc0%253Dshijue1%252C0%252C0%252C294%252C40%2Fsign%3D1e9a831171ec54e755e1125dd151f125%2F37d12f2eb9389b507067ee7d8f35e5dde7116e00.jpg",
                              @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1511957963136&di=a77d78b73f1dcb5809e5a6bda6a78570&imgtype=0&src=http%3A%2F%2Fimg1.3lian.com%2F2015%2Fa1%2F91%2Fd%2F58.jpg",
                              @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1511957963136&di=20f1db9a214f5e8028c0645326c07803&imgtype=0&src=http%3A%2F%2Fimg2.3lian.com%2F2014%2Ff5%2F1%2Fd%2F118.jpg",
                              @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1511957963133&di=3b125c6e4fae93948edf1c53cead4a38&imgtype=0&src=http%3A%2F%2Fpic5.nipic.com%2F20091223%2F2839526_205415110354_2.jpg",
                              @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1511957963132&di=362e8ded4cbf66179b6309e93c620b40&imgtype=0&src=http%3A%2F%2Fimg1.3lian.com%2F2015%2Fa1%2F26%2Fd%2F27.jpg",
                              @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1511958066618&di=9e478cc87951a0a990039fb96c84b846&imgtype=0&src=http%3A%2F%2Fimg1.3lian.com%2F2015%2Fa1%2F91%2Fd%2F44.jpg",
                              nil];
    
}


#pragma mark -
#pragma mark -------------------- configUI --------------------

- (void)configUI
{
    [self.view addSubview:self.scrollView];
    
    [self.topView addSubview:self.textBannerView];
    [self.bottomView addSubview:self.imageBannerView];
    [self.bottomView addSubview:self.urlImageBannerVeiw];
}

- (UIScrollView *)scrollView {
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        _scrollView.backgroundColor = [UIColor clearColor];
        _scrollView.scrollEnabled = YES;
        _scrollView.scrollsToTop = YES;
        [_scrollView addSubview:self.topView];
        [_scrollView addSubview:self.bottomView];
        _scrollView.contentSize = CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height);
    }
    return _scrollView;
}

- (UIView *)topView {
    if (_topView == nil) {
        _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 50, self.view.bounds.size.width, 50)];
        _topView.userInteractionEnabled = YES;
        _topView.backgroundColor = [UIColor clearColor];
    }
    return _topView;
}

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

- (UIView *)bottomView {
    if (_bottomView == nil) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 50 + self.topView.frame.size.height + 10, self.view.bounds.size.width, self.view.frame.size.height - 50 - self.topView.frame.size.height - 10)];
        _bottomView.userInteractionEnabled = YES;
        _bottomView.backgroundColor = [UIColor clearColor];
    }
    return _bottomView;
}

- (ECAutoScrollBanner *)imageBannerView {
    if (_imageBannerView == nil) {
        _imageBannerView = [ECAutoScrollBanner initLocalImageBannerWithFrame:CGRectMake(0, 30, self.bottomView.frame.size.width, 180) withImageDataSource:self.imageDataArray withBannerScrollDirection:ECAutoScrollBannerScrollDirectionHorizontal];
        _imageBannerView.isAutoPaging = NO;
    }
    return _imageBannerView;
}

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



#pragma mark -
#pragma mark -------------------- ECAutoScrollBannerDelegate --------------------

- (void)tapScrollBannerItem:(NSInteger)itemTag withObject:(id)object {
    if (object == self.textBannerView) {
        NSLog(@"文本banner。点击了第%ld个子item，下标%ld", (long)itemTag + 1, (long)itemTag);
    } else {
        NSLog(@"图片视图banner。点击了第%ld个子item，下标%ld", (long)itemTag + 1, (long)itemTag);
    }
}









- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
