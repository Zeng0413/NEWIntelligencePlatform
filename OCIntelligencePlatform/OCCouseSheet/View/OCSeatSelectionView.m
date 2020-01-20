//
//  OCSeatSelectionView.m
//  OCIntelligencePlatform
//
//  Created by Alan on 2020/1/8.
//  Copyright © 2020 OCZHKJ. All rights reserved.
//

#import "OCSeatSelectionView.h"
#import "OCSeatsView.h"
#import "OCIndicatorView.h"
@interface OCSeatSelectionView ()<UIScrollViewDelegate>
/**seatScrollView*/
@property (nonatomic, weak) UIScrollView *seatScrollView;

/**按钮父控件*/
@property (nonatomic, weak)  OCSeatsView *seatView;

/**指示框*/
@property (nonatomic, weak)  OCIndicatorView *indicator;

@property (nonatomic,copy) void (^actionBlock)(OCSeatButton *);

@end

@implementation OCSeatSelectionView

-(instancetype)initWithFrame:(CGRect)frame seatsArray:(NSArray *)seatsArray seatBtnActionBlock:(void (^)(OCSeatButton * _Nonnull))actionBlock{
    if (self = [super initWithFrame:frame]) {
        self.actionBlock = actionBlock;
        [self initScrollView];
        [self initSeatsView:seatsArray];
        [self initindicator:seatsArray];
    }
    return self;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    
    return self.seatView;
}

-(void) initSeatsView:(NSArray *)seatsArray{
//   [seatsArray removeObjectAtIndex:10];
   __weak typeof(self) weakSelf = self;
    
    OCSeatsView *seatsView = [[OCSeatsView alloc] initWithSeatsArray:seatsArray maxNomarHeight:self.height seatBtnActionBlock:^(OCSeatButton * _Nonnull seatBtn, OCSeatsAreaView * _Nonnull seatsAreaView) {
        [weakSelf.indicator updateMiniImageView];
        if (weakSelf.actionBlock) weakSelf.actionBlock(seatBtn);
        if (weakSelf.seatScrollView.maximumZoomScale - weakSelf.seatScrollView.zoomScale < 0.1) return;//设置座位放大
        CGFloat maximumZoomScale = weakSelf.seatScrollView.maximumZoomScale;
        
        UIWindow *window = [[UIApplication sharedApplication] keyWindow];
        CGRect reatBtnRect = [seatBtn convertRect:seatBtn.bounds toView:window];
        
        UIView *tempView = [[UIView alloc] initWithFrame:Rect(seatsAreaView.x+seatBtn.x, seatsAreaView.y+seatBtn.y, seatBtn.width, seatBtn.height)];
        CGRect zoomRect = [weakSelf _zoomRectInView:weakSelf.seatScrollView forScale:maximumZoomScale withCenter:CGPointMake(tempView.centerX, tempView.centerY)];
        [weakSelf.seatScrollView zoomToRect:zoomRect animated:YES];
    }];
    
//    seatsView.backgroundColor = RGBA(241, 245, 249, 1)
    self.seatView = seatsView;
    seatsView.frame = self.bounds;
    [self.seatScrollView insertSubview:seatsView atIndex:0];
    self.seatScrollView.maximumZoomScale = 40*FITWIDTH / 17*FITWIDTH;
}

-(void)initScrollView{
    UIScrollView *seatScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    self.seatScrollView = seatScrollView;
    self.seatScrollView.decelerationRate = UIScrollViewDecelerationRateFast;
    self.seatScrollView.delegate = self;
    self.seatScrollView.backgroundColor = RGBA(241, 245, 249, 1);
    self.seatScrollView.showsHorizontalScrollIndicator = NO;
    self.seatScrollView.showsVerticalScrollIndicator = NO;
    self.seatScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.seatScrollView.contentSize = CGSizeMake(self.width, self.height);
    [self addSubview:self.seatScrollView];
}

-(void)initindicator:(NSArray *)seatsArray{
    
    OCIndicatorView *indicator = [[OCIndicatorView alloc]initWithView:self.seatView withScrollView:self.seatScrollView];
    indicator.x = 0;
    indicator.y = 36*FITWIDTH;
    indicator.width = 115*FITWIDTH;
    indicator.height = 191*FITWIDTH + 30*FITWIDTH;
    indicator.hidden = YES;
    self.indicator = indicator;
    [self addSubview:indicator];
    
}

#pragma mark - <UIScrollViewDelegate>
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    
    //更新indicator大小位置
    [self.indicator updateMiniIndicator];
    if (!self.indicator.hidden || self.seatScrollView.isZoomBouncing)return;
    self.indicator.alpha = 1;
    self.indicator.hidden = NO;
    
}

#pragma mark - <UIScrollViewDelegate>
-(void)scrollViewDidZoom:(UIScrollView *)scrollView{
    
    [[self class] cancelPreviousPerformRequestsWithTarget:self.indicator selector:@selector(indicatorHidden) object:nil];
    [self.indicator updateMiniIndicator];
    [self scrollViewDidEndDecelerating:scrollView];
}

-(void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale{
    
    [self.indicator updateMiniIndicator];
    [self scrollViewDidEndDecelerating:scrollView];
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    if (!decelerate) {
        [self scrollViewDidEndDecelerating:scrollView];
    }
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    [[self class] cancelPreviousPerformRequestsWithTarget:self.indicator selector:@selector(indicatorHidden) object:nil];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    [self.indicator performSelector:@selector(indicatorHidden) withObject:nil afterDelay:2];
    
}

- (CGRect)_zoomRectInView:(UIView *)view forScale:(CGFloat)scale withCenter:(CGPoint)center {
    CGRect zoomRect;
    zoomRect.size.height = view.bounds.size.height / scale;
    zoomRect.size.width = view.bounds.size.width / scale;
    zoomRect.origin.x = center.x - (zoomRect.size.width / 2.0);
    zoomRect.origin.y = center.y - (zoomRect.size.height / 2.0);
    return zoomRect;
}
@end
