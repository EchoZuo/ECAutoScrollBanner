 ```Objective-C
 + (void)load {
    [super registerPlusButton];
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
 ```
