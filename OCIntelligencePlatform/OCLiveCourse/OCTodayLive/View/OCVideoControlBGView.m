//
//  OCVideoControlBGView.m
//  OCPhoenix
//
//  Created by Alan on 2019/5/5.
//  Copyright © 2019 OCZHKJ. All rights reserved.
//

#import "OCVideoControlBGView.h"

//#import "OCSlider.h"
//#import "OCVideoListView.h"
//#import "OCVideoDataManager.h"

#import <ZFPlayer/ZFSliderView.h>
#import <ZFPlayer/ZFSpeedLoadingView.h>
#import <ZFPlayer/ZFVolumeBrightnessView.h>

#define OCPlayer_Image(file)                 [UIImage imageNamed:OCPlayer_SrcName(file)] ? :[UIImage imageNamed:OCPlayer_FrameworkSrcName(file)]
#define OCPlayer_SrcName(file)               [@"ZFPlayer.bundle" stringByAppendingPathComponent:file]
#define OCPlayer_FrameworkSrcName(file)      [@"Frameworks/ZFPlayer.framework/ZFPlayer.bundle" stringByAppendingPathComponent:file]

@interface OCVideoControlBGView ()

/// 底部
@property (nonatomic, strong) UIView * bottomView;
@property (nonatomic, strong) UIView * playBackView;

@property (nonatomic, strong) UIButton * playButton;
@property (nonatomic, strong) UIButton * nextButton;
//@property (nonatomic, strong) OCSlider * slider;
@property (nonatomic, strong) UIButton * zoomControlBtn;

@property (nonatomic, strong) UIButton * quitFullViewBtn;

/// 快进快退View
@property (nonatomic, strong) UIView *fastView;
@property (nonatomic, strong) ZFSliderView *fastProgressView;
@property (nonatomic, strong) UILabel *fastTimeLabel;
@property (nonatomic, strong) UIImageView *fastImageView;
@property (nonatomic, assign) BOOL fastViewAnimated;

@property (nonatomic, strong) ZFSliderView * bottomProgress;

@property (nonatomic, strong) ZFSpeedLoadingView *activity;

//@property (nonatomic, strong) OCVideoListView * listView;

//音量
@property (nonatomic, strong) ZFVolumeBrightnessView *volumeBrightnessView;

@property (nonatomic, assign) BOOL controlViewAppeared;
/// 如果是暂停状态，seek完是否播放，默认YES
@property (nonatomic, assign) BOOL seekToPlay;
@property (nonatomic, strong) dispatch_block_t afterBlock;
@property (nonatomic, assign) NSTimeInterval sumTime;

@property (strong, nonatomic) UIView *backView;
@property (strong, nonatomic) UIButton *playBtn;
@property (strong, nonatomic) UILabel *titleLab;
@property (strong, nonatomic) UILabel *nameLab;
@property (strong, nonatomic) UILabel *lookPersonNumLab;
@property (strong, nonatomic) UIButton *backBtn;
@property (strong, nonatomic) UIButton *collectBtn;
@property (assign, nonatomic) BOOL isFromStudy;

//@property (strong, nonatomic) OCLiveVideoModel *liveModel;

@end



@implementation OCVideoControlBGView

@synthesize player = _player;

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addAllSubviews];
    }
    
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame withLiveModel:(OCLiveVideoModel *)liveModel{
    self = [super initWithFrame:frame];
    if (self) {
        self.liveModel = liveModel;
        [self addAllSubviews];
    }
    
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame withIsFromStudy:(BOOL)isFromStudy{
    self = [super initWithFrame:frame];
    if (self) {
        self.isFromStudy = isFromStudy;
        [self addAllSubviews];
        self.seekToPlay = YES;
        self.fastViewAnimated = YES;
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(volumeChanged:)
                                                     name:@"AVSystemController_SystemVolumeDidChangeNotification"
                                                   object:nil];
        [self hideControlViewWithAnimated:NO];
    }
    
    return self;
}

- (void)layoutSubviews {
    _bottomView.frame = Rect(0, self.height - 46*FITWIDTH, self.width, 46*FITWIDTH);
    _playBackView.size = CGSizeMake(40*FITWIDTH, 40*FITWIDTH);
    _playBackView.centerY = self.centerY;
    _playBackView.centerX = self.centerX;
    
    
    self.nameLab.frame = Rect(15*FITWIDTH, self.bottomView.height - 12*FITWIDTH - 11*FITWIDTH, 120*FITWIDTH, 11*FITWIDTH);
    self.titleLab.frame = Rect(self.nameLab.x, CGRectGetMinY(self.nameLab.frame) - 8*FITWIDTH - 15*FITWIDTH, 200*FITWIDTH, 15*FITWIDTH);
    self.lookPersonNumLab.size = [self.lookPersonNumLab.text sizeWithFont:kFont(11*FITWIDTH)];
    self.lookPersonNumLab.centerY = self.nameLab.centerY;
    self.lookPersonNumLab.centerX = self.centerX;
    
    self.zoomControlBtn.frame = Rect(self.width - 10 - 35*FITWIDTH, 0, 35*FITWIDTH, 35*FITWIDTH);
    self.zoomControlBtn.centerY = self.bottomView.height/2;
    
    _playButton.frame = self.playBackView.bounds;

//    if (self.player.isFullScreen) {
//    } else {
//        _zoomControlBtn.image = @"play_btn_full screen_white";
//    }

}


- (void)addAllSubviews {
    if (self.isFromStudy) {
        self.backView = [UIView viewWithBgColor:RGBA(0, 0, 0, 0.3) frame:self.bounds];
        self.backView.userInteractionEnabled = YES;
        self.backView.alpha = 0;
        [self addSubview:self.backView];
        
        self.playBtn = [UIButton buttonWithTitle:@"" titleColor:nil backgroundColor:nil font:0 image:@"common_btn_play_max" frame:CGRectZero];
        self.playBtn.selectImage = @"common_btn_pause_max";
        [self.playBtn addTarget:self action:@selector(videoPlayButtonClickAction:) forControlEvents:UIControlEventTouchUpInside];
        self.playBtn.size = CGSizeMake(60, 60);
        self.playBtn.centerX = self.centerX;
        self.playBtn.centerY = self.centerY;
        self.playBtn.selected = YES;
        [self.backView addSubview:self.playBtn];
    }else{
        [self addSubview:self.bottomView];
        [self addSubview:self.playBackView];
//
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [self.player enterFullScreen:YES animated:YES];
//        });
        
    }
    
    
}


/// 音量改变的通知
- (void)volumeChanged:(NSNotification *)notification {
    float volume = [[[notification userInfo] objectForKey:@"AVSystemController_AudioVolumeNotificationParameter"] floatValue];
    if (self.player.isFullScreen) {
        [self.volumeBrightnessView updateProgress:volume withVolumeBrightnessType:ZFVolumeBrightnessTypeVolume];
    } else {
        [self.volumeBrightnessView addSystemVolumeView];
    }
}
#pragma mark ------------------------------------------------------- 交互事件
- (void)videoPlayButtonClickAction:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    sender.isSelected? [self.player.currentPlayerManager play]: [self.player.currentPlayerManager pause];
}

- (void)fullScreenButtonClickAction:(UIButton *)sender {
    if (self.player.isFullScreen) {
        [self.player enterFullScreen:NO animated:YES];
    }else {
        [self.player enterFullScreen:YES animated:YES];
    }
}

- (void)quitFullScreenButtonClickAction {
    [self.player enterFullScreen:NO animated:YES];
    [self hideControlViewWithAnimated:YES];
}


#pragma mark ------------------------------------------------------- 协议代理
#pragma mark ---- ZFPlayerControlViewDelegate

/// 手势筛选，返回NO不响应该手势
- (BOOL)gestureTriggerCondition:(ZFPlayerGestureControl *)gestureControl gestureType:(ZFPlayerGestureType)gestureType gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer touch:(nonnull UITouch *)touch {
    CGPoint point = [touch locationInView:self];
    if (self.player.isSmallFloatViewShow && !self.player.isFullScreen && gestureType != ZFPlayerGestureTypeSingleTap) {
        return NO;
    }
    if (self.player.isFullScreen) {
        /// 不禁用滑动方向
        self.player.disablePanMovingDirection = ZFPlayerDisablePanMovingDirectionNone;
        return [self shouldResponseGestureWithPoint:point withGestureType:gestureType touch:touch];
    } else {
        if (self.player.scrollView) {  /// 列表时候禁止左右滑动
            self.player.disablePanMovingDirection = ZFPlayerDisablePanMovingDirectionVertical;
        } else { /// 不禁用滑动方向
            self.player.disablePanMovingDirection = ZFPlayerDisablePanMovingDirectionNone;
        }
        return [self shouldResponseGestureWithPoint:point withGestureType:gestureType touch:touch];
    }
    return YES;
}

- (BOOL)shouldResponseGestureWithPoint:(CGPoint)point withGestureType:(ZFPlayerGestureType)type touch:(nonnull UITouch *)touch {
//    if (self.player.isFullScreen) {
//        CGRect sliderRect = [self convertRect:self.listView.frame toView:self];
//        if (CGRectContainsPoint(sliderRect, point)) {
//            return NO;
//        }
//        return YES;
//    }else {
//        CGRect sliderRect = [self convertRect:self.bottomView.frame toView:self];
//        if (CGRectContainsPoint(sliderRect, point)) {
//            return NO;
//        }
//        return YES;
//    }
    return YES;
}

/// 单击手势事件
- (void)gestureSingleTapped:(ZFPlayerGestureControl *)gestureControl {
    if (!self.player) return;
    if (self.player.isSmallFloatViewShow && !self.player.isFullScreen) {
        [self.player enterFullScreen:YES animated:YES];
    } else {
        if (self.controlViewAppeared) {
            [self hideControlViewWithAnimated:YES];
        } else {
//            [self hiddenListView];
            /// 显示之前先把控制层复位，先隐藏后显示
            [self hideControlViewWithAnimated:NO];
            [self showControlViewWithAnimated:YES];
        }
    }
}

/// 双击手势事件
- (void)gestureDoubleTapped:(ZFPlayerGestureControl *)gestureControl {
    //    if (self.player.isFullScreen) {
    //        [self.landScapeControlView playOrPause];
    //    } else {
    //        [self.portraitControlView playOrPause];
    //    }
}

/// 开始滑动手势事件
- (void)gestureBeganPan:(ZFPlayerGestureControl *)gestureControl panDirection:(ZFPanDirection)direction panLocation:(ZFPanLocation)location {
    if (direction == ZFPanDirectionH) {
        self.sumTime = self.player.currentTime;
    }
}

/// 滑动中手势事件
- (void)gestureChangedPan:(ZFPlayerGestureControl *)gestureControl panDirection:(ZFPanDirection)direction panLocation:(ZFPanLocation)location withVelocity:(CGPoint)velocity {
    if (direction == ZFPanDirectionH) {
        // 每次滑动需要叠加时间
        self.sumTime += velocity.x / 200;
        // 需要限定sumTime的范围
        NSTimeInterval totalMovieDuration = self.player.totalTime;
        if (totalMovieDuration == 0) return;
        if (self.sumTime > totalMovieDuration) self.sumTime = totalMovieDuration;
        if (self.sumTime < 0) self.sumTime = 0;
        BOOL style = NO;
        if (velocity.x > 0) style = YES;
        if (velocity.x < 0) style = NO;
        if (velocity.x == 0) return;
        [self sliderValueChangingValue:self.sumTime/totalMovieDuration isForward:style];
    } else if (direction == ZFPanDirectionV) {
        if (location == ZFPanLocationLeft) { /// 调节亮度
            self.player.brightness -= (velocity.y) / 10000;
            [self.volumeBrightnessView updateProgress:self.player.brightness withVolumeBrightnessType:ZFVolumeBrightnessTypeumeBrightness];
        } else if (location == ZFPanLocationRight) { /// 调节声音
            self.player.volume -= (velocity.y) / 10000;
            if (self.player.isFullScreen) {
                [self.volumeBrightnessView updateProgress:self.player.volume withVolumeBrightnessType:ZFVolumeBrightnessTypeVolume];
            }
        }
    }
}

/// 滑动结束手势事件
- (void)gestureEndedPan:(ZFPlayerGestureControl *)gestureControl panDirection:(ZFPanDirection)direction panLocation:(ZFPanLocation)location {
    @weakify(self)
    if (direction == ZFPanDirectionH && self.sumTime >= 0 && self.player.totalTime > 0) {
        [self.player seekToTime:self.sumTime completionHandler:^(BOOL finished) {
            @strongify(self)
            /// 左右滑动调节播放进度
            //            [self.portraitControlView sliderChangeEnded];
            //            [self.landScapeControlView sliderChangeEnded];
            [self autoFadeOutControlView];
        }];
        if (self.seekToPlay) {
            [self.player.currentPlayerManager play];
        }
        self.sumTime = 0;
    }
}

/// 捏合手势事件，这里改变了视频的填充模式
- (void)gesturePinched:(ZFPlayerGestureControl *)gestureControl scale:(float)scale {
    //    if (scale > 1) {
    //        self.player.currentPlayerManager.scalingMode = ZFPlayerScalingModeAspectFill;
    //    } else {
    //        self.player.currentPlayerManager.scalingMode = ZFPlayerScalingModeAspectFit;
    //    }
}

/// 准备播放
- (void)videoPlayer:(ZFPlayerController *)videoPlayer prepareToPlay:(NSURL *)assetURL {
    [self hideControlViewWithAnimated:NO];
}

/// 播放状态改变
- (void)videoPlayer:(ZFPlayerController *)videoPlayer playStateChanged:(ZFPlayerPlaybackState)state {
    if (state == ZFPlayerPlayStatePlaying) {
        WGHLog(@"ZFPlayerPlayStatePlaying");
        self.playButton.selected = YES;
        //        [self.portraitControlView playBtnSelectedState:YES];
        //        [self.landScapeControlView playBtnSelectedState:YES];
        //        self.failBtn.hidden = YES;
        //        /// 开始播放时候判断是否显示loading
        if (videoPlayer.currentPlayerManager.loadState == ZFPlayerLoadStateStalled) {
            [self.activity startAnimating];
        }
    } else if (state == ZFPlayerPlayStatePaused) {
        WGHLog(@"ZFPlayerPlayStatePaused");
        self.playButton.selected = NO;
        //        [self.portraitControlView playBtnSelectedState:NO];
        //        [self.landScapeControlView playBtnSelectedState:NO];
        //        /// 暂停的时候隐藏loading
        [self.activity stopAnimating];
        //        self.failBtn.hidden = YES;
    } else if (state == ZFPlayerPlayStatePlayFailed) {
        WGHLog(@"ZFPlayerPlayStatePlayFailed");
        //        self.failBtn.hidden = NO;
        [self.activity stopAnimating];
    }
}

/// 加载状态改变
- (void)videoPlayer:(ZFPlayerController *)videoPlayer loadStateChanged:(ZFPlayerLoadState)state {
    if (state == ZFPlayerLoadStatePrepare) {
        //        self.coverImageView.hidden = NO;
    } else if (state == ZFPlayerLoadStatePlaythroughOK || state == ZFPlayerLoadStatePlayable) {
        //        self.coverImageView.hidden = YES;
        //        if (self.effectViewShow) {
        //            self.effectView.hidden = NO;
        //        } else {
        //            self.effectView.hidden = YES;
        //            self.player.currentPlayerManager.view.backgroundColor = [UIColor blackColor];
        //        }
    }
    if (state == ZFPlayerLoadStateStalled && videoPlayer.currentPlayerManager.isPlaying) {
        [self.activity startAnimating];
    } else {
        [self.activity stopAnimating];
    }
}

/// 播放进度改变回调
- (void)videoPlayer:(ZFPlayerController *)videoPlayer currentTime:(NSTimeInterval)currentTime totalTime:(NSTimeInterval)totalTime {
    //    [self.portraitControlView videoPlayer:videoPlayer currentTime:currentTime totalTime:totalTime];
    //[self.landScapeControlView videoPlayer:videoPlayer currentTime:currentTime totalTime:totalTime];
//    if (_slider.isDragging) {
//        return;
//    }
//
//    self.bottomProgress.value = videoPlayer.progress;
//    self.slider.value = videoPlayer.progress;
//    NSString * currentTimeText = [OCTimeManager getMMSS:NSStringFormat(@"%.lf",currentTime) type:@"1"];
//    NSString * totalTimeText = [OCTimeManager getMMSS:NSStringFormat(@"%.lf",totalTime) type:@"1"];
//
//    self.slider.sliderText = NSStringFormat(@"%@/%@",currentTimeText,totalTimeText);
}

/// 缓冲改变回调
- (void)videoPlayer:(ZFPlayerController *)videoPlayer bufferTime:(NSTimeInterval)bufferTime {
    //    [self.portraitControlView videoPlayer:videoPlayer bufferTime:bufferTime];
    //    [self.landScapeControlView videoPlayer:videoPlayer bufferTime:bufferTime];
//    self.bottomProgress.bufferValue = videoPlayer.bufferProgress;
//    self.slider.bufferValue = videoPlayer.bufferProgress;
}

- (void)videoPlayer:(ZFPlayerController *)videoPlayer presentationSizeChanged:(CGSize)size {
    //    [self.landScapeControlView videoPlayer:videoPlayer presentationSizeChanged:size];
}

/// 视频view即将旋转
- (void)videoPlayer:(ZFPlayerController *)videoPlayer orientationWillChange:(ZFOrientationObserver *)observer {
    //    self.portraitControlView.hidden = observer.isFullScreen;
    //    self.landScapeControlView.hidden = !observer.isFullScreen;
    if (videoPlayer.isSmallFloatViewShow) {
        //        self.floatControlView.hidden = observer.isFullScreen;
        //        self.portraitControlView.hidden = YES;
        if (observer.isFullScreen) {
            self.controlViewAppeared = NO;
            [self cancelAutoFadeOutControlView];
        }
    }
    if (self.controlViewAppeared) {
        [self showControlViewWithAnimated:NO];
    } else {
        [self hideControlViewWithAnimated:NO];
    }
    
    if (observer.isFullScreen) {
        [self.volumeBrightnessView removeSystemVolumeView];
    } else {
        [self.volumeBrightnessView addSystemVolumeView];
    }
}

/// 视频view已经旋转
- (void)videoPlayer:(ZFPlayerController *)videoPlayer orientationDidChanged:(ZFOrientationObserver *)observer {
    if (self.controlViewAppeared) {
        [self showControlViewWithAnimated:NO];
    } else {
        [self hideControlViewWithAnimated:NO];
    }
}

/// 锁定旋转方向
- (void)lockedVideoPlayer:(ZFPlayerController *)videoPlayer lockedScreen:(BOOL)locked {
    [self showControlViewWithAnimated:YES];
}

/// 列表滑动时视频view已经显示
- (void)playerDidAppearInScrollView:(ZFPlayerController *)videoPlayer {
    //    if (!self.player.stopWhileNotVisible && !videoPlayer.isFullScreen) {
    //        self.floatControlView.hidden = YES;
    //        self.portraitControlView.hidden = NO;
    //    }
}

/// 列表滑动时视频view已经消失
- (void)playerDidDisappearInScrollView:(ZFPlayerController *)videoPlayer {
    //    if (!self.player.stopWhileNotVisible && !videoPlayer.isFullScreen) {
    //        self.floatControlView.hidden = NO;
    //        self.portraitControlView.hidden = YES;
    //    }
}

#pragma mark ---- OCSliderDelegate

- (void)sliderValueChanged:(float)value {
    NSString * totalSeconds = NSStringFormat(@"%.lf",self.player.totalTime);
    NSString * currentSeconds = NSStringFormat(@"%.lf",self.player.totalTime * value);
    
//    self.slider.sliderText = NSStringFormat(@"%@/%@",[OCTimeManager getMMSS:currentSeconds type:@"1"],[OCTimeManager getMMSS:totalSeconds type:@"1"]);
}

- (void)sliderTouchEnded:(float)value {
    [self setPlayerProgress:value];
    [self autoFadeOutControlView];
}

- (void)sliderTapped:(float)value {
    [self setPlayerProgress:value];
}

- (void)setPlayerProgress:(CGFloat)value {
    @weakify(self)
    [self.player seekToTime:self.player.totalTime * value completionHandler:^(BOOL finished) {
        @strongify(self)
        if (finished) {
            [self.player.currentPlayerManager play];
        }
    }];
}


#pragma mark ------------------------------------------------------- 私有方法
- (void)autoFadeOutControlView {
    self.controlViewAppeared = YES;
    [self cancelAutoFadeOutControlView];
    @weakify(self)
    self.afterBlock = dispatch_block_create(0, ^{
        @strongify(self)
        [self hideControlViewWithAnimated:YES];
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4 * NSEC_PER_SEC)), dispatch_get_main_queue(),self.afterBlock);
}

- (void)cancelAutoFadeOutControlView {
    if (self.afterBlock) {
        dispatch_block_cancel(self.afterBlock);
        self.afterBlock = nil;
    }
}

/// 隐藏控制层
- (void)hideControlViewWithAnimated:(BOOL)animated {
    //拖动slider时不自动隐藏
//    if (_slider.isDragging) {
//        return;
//    }
    self.controlViewAppeared = NO;
    Weak
    [UIView animateWithDuration:0.5 animations:^{
        wself.backView.alpha = 0;
        wself.bottomView.y = wself.height;
        wself.bottomView.alpha = 0;
        
        wself.playBackView.alpha = 0;
    }completion:^(BOOL finished) {
        wself.bottomProgress.hidden = NO;
    }];
}

/// 显示控制层
- (void)showControlViewWithAnimated:(BOOL)animated {
    self.controlViewAppeared = YES;
    //    if (self.controlViewAppearedCallback) {
    //        self.controlViewAppearedCallback(YES);
    //    }
    [self autoFadeOutControlView];
    Weak
    [UIView animateWithDuration:animated ? 0.5 : 0 animations:^{
        wself.backView.alpha = 1.0;
        wself.bottomView.y = wself.height - wself.bottomView.height;
        wself.bottomView.alpha = 1;
        wself.playBackView.alpha = 1;
    } completion:^(BOOL finished) {
        wself.bottomProgress.hidden = YES;
    }];
}

- (void)sliderValueChangingValue:(CGFloat)value isForward:(BOOL)forward {
    self.fastProgressView.value = value;
    /// 显示控制层
    [self showControlViewWithAnimated:NO];
    [self cancelAutoFadeOutControlView];
    
    self.fastView.hidden = NO;
    self.fastView.alpha = 1;
    if (forward) {
        self.fastImageView.image = OCPlayer_Image(@"ZFPlayer_fast_forward");
    } else {
        self.fastImageView.image = OCPlayer_Image(@"ZFPlayer_fast_backward");
    }
//    NSString *draggedTime = [OCTimeManager getMMSS:NSStringFormat(@"%.lf",self.player.totalTime * value) type:@"1"];//[ZFUtilities convertTimeSecond:self.player.totalTime * value];
//    NSString *totalTime = [OCTimeManager getMMSS:NSStringFormat(@"%.lf",self.player.totalTime) type:@"1"];//[ZFUtilities convertTimeSecond:self.player.totalTime];
//    self.fastTimeLabel.text = [NSString stringWithFormat:@"%@ / %@",draggedTime,totalTime];
    /// 更新滑杆
    //    [self.portraitControlView sliderValueChanged:value currentTimeString:draggedTime];
    //    [self.landScapeControlView sliderValueChanged:value currentTimeString:draggedTime];
    
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideFastView) object:nil];
    [self performSelector:@selector(hideFastView) withObject:nil afterDelay:0.1];
    
    if (self.fastViewAnimated) {
        [UIView animateWithDuration:0.4 animations:^{
            self.fastView.transform = CGAffineTransformMakeTranslation(forward?8:-8, 0);
        }];
    }
}

/// 隐藏快进视图
- (void)hideFastView {
    [UIView animateWithDuration:0.4 animations:^{
        self.fastView.transform = CGAffineTransformIdentity;
        self.fastView.alpha = 0;
    } completion:^(BOOL finished) {
        self.fastView.hidden = YES;
    }];
}


-(void)stopVideo{
    [self videoPlayButtonClickAction:self.playBtn];
}

#pragma mark ------------------------------------------------------- 懒加载

- (UIView *)bottomView {
    if (_bottomView) {
        return _bottomView;
    }
    
    _bottomView = [UIView viewWithBgColor:RGBA(0, 0, 0, 0.3) frame:CGRectZero];
    _bottomView.userInteractionEnabled = YES;
    
    self.nameLab = [UILabel labelWithText:NSStringFormat(@"授课讲师：%@",self.liveModel.speaker) font:11*FITWIDTH textColor:RGBA(221, 223, 225, 1) frame:CGRectZero];
    [_bottomView addSubview:self.nameLab];
    
    self.titleLab = [UILabel labelWithText:self.liveModel.title font:15*FITWIDTH textColor:WHITE frame:CGRectZero];
    self.titleLab.font = kBoldFont(15*FITWIDTH);
    [_bottomView addSubview:self.titleLab];
    
    self.lookPersonNumLab = [UILabel labelWithText:@"观看人数：92" font:11*FITWIDTH textColor:RGBA(221, 223, 225, 1) frame:CGRectZero];
    self.lookPersonNumLab.size = [self.lookPersonNumLab.text sizeWithFont:kFont(11*FITWIDTH)];
    self.lookPersonNumLab.centerY = self.nameLab.centerY;
    self.lookPersonNumLab.centerX = self.centerX;
    [_bottomView addSubview:self.lookPersonNumLab];
    
    _zoomControlBtn = [UIButton buttonWithTitle:@"" titleColor:WHITE backgroundColor:CLEAR font:14 image:@"play_btn_full screen_white" target:self action:@selector(fullScreenButtonClickAction:) frame:CGRectZero];
    [_bottomView addSubview:_zoomControlBtn];
    return _bottomView;
}

-(UIView *)playBackView{
    if (_playBackView) {
        return _playBackView;
    }
    _playBackView = [UIView viewWithBgColor:CLEAR frame:CGRectZero];
    _playBackView.userInteractionEnabled = YES;
    
    _playButton = [UIButton buttonWithTitle:@"" titleColor:CLEAR backgroundColor:CLEAR font:14 image:@"course_btn_play" target:self action:@selector(videoPlayButtonClickAction:) frame:CGRectZero];
    _playButton.selectImage = @"course_btn_pause";
    [_playBackView addSubview:_playButton];
    
    return _playBackView;
}



- (UIButton *)quitFullViewBtn {
    if (_quitFullViewBtn) {
        return _quitFullViewBtn;
    }
    
    _quitFullViewBtn = [UIButton buttonWithTitle:@"" titleColor:CLEAR backgroundColor:CLEAR font:14 image:@"common_btn_back" target:self action:@selector(quitFullScreenButtonClickAction) frame:CGRectZero];
    [self addSubview:_quitFullViewBtn];
    return _quitFullViewBtn;
}

- (ZFSliderView *)bottomProgress {
    if (!_bottomProgress) {
        _bottomProgress = [[ZFSliderView alloc] init];
        _bottomProgress.maximumTrackTintColor = [UIColor clearColor];
        _bottomProgress.minimumTrackTintColor = kAPPCOLOR;
        _bottomProgress.bufferTrackTintColor  = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.5];
        _bottomProgress.sliderHeight = 2;
        _bottomProgress.isHideSliderBlock = NO;
    }
    return _bottomProgress;
}

- (ZFSpeedLoadingView *)activity {
    if (!_activity) {
        _activity = [[ZFSpeedLoadingView alloc] init];
    }
    return _activity;
}

- (UIView *)fastView {
    if (!_fastView) {
        _fastView = [[UIView alloc] init];
        _fastView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
        _fastView.layer.cornerRadius = 4;
        _fastView.layer.masksToBounds = YES;
        _fastView.hidden = YES;
    }
    return _fastView;
}

- (UIImageView *)fastImageView {
    if (!_fastImageView) {
        _fastImageView = [[UIImageView alloc] init];
    }
    return _fastImageView;
}

- (UILabel *)fastTimeLabel {
    if (!_fastTimeLabel) {
        _fastTimeLabel = [[UILabel alloc] init];
        _fastTimeLabel.textColor = [UIColor whiteColor];
        _fastTimeLabel.textAlignment = NSTextAlignmentCenter;
        _fastTimeLabel.font = [UIFont systemFontOfSize:14.0];
        _fastTimeLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _fastTimeLabel;
}

- (ZFSliderView *)fastProgressView {
    if (!_fastProgressView) {
        _fastProgressView = [[ZFSliderView alloc] init];
        _fastProgressView.maximumTrackTintColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.4];
        _fastProgressView.minimumTrackTintColor = [UIColor whiteColor];
        _fastProgressView.sliderHeight = 2;
        _fastProgressView.isHideSliderBlock = NO;
    }
    return _fastProgressView;
}

- (ZFVolumeBrightnessView *)volumeBrightnessView {
    if (!_volumeBrightnessView) {
        _volumeBrightnessView = [[ZFVolumeBrightnessView alloc] init];
    }
    return _volumeBrightnessView;
}


-(void)setLiveModel:(OCLiveVideoModel *)liveModel{
    _liveModel = liveModel;
    self.titleLab.text = liveModel.title;
    self.nameLab.text = NSStringFormat(@"授课讲师：%@",liveModel.speaker);
}

-(void)setVideoModel:(OCCourseVideoListModel *)videoModel{
    _videoModel = videoModel;
    self.titleLab.text = videoModel.name;
    self.nameLab.text = NSStringFormat(@"授课讲师：%@",videoModel.speaker);
}

-(void)setDataDict:(NSDictionary *)dataDict{
    _dataDict = dataDict;
    self.titleLab.text = dataDict[@"title"];
    self.nameLab.text = NSStringFormat(@"授课讲师：%@",dataDict[@"speaker"]);

}
@end
