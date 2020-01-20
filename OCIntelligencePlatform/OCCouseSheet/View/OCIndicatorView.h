//
//  OCIndicatorView.h
//  OCIntelligencePlatform
//
//  Created by Alan on 2020/1/8.
//  Copyright © 2020 OCZHKJ. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface OCIndicatorView : UIView

/** 初始化快捷方法 */
-(instancetype)initWithView:(UIView *)mapView withScrollView:(UIScrollView *)myScrollview;

/** 滚动时更新 */
- (void)updateMiniIndicator;

/** 更新座位选中的图片 */
-(void)updateMiniImageView;

/** 隐藏 */
-(void)indicatorHidden;

@end

NS_ASSUME_NONNULL_END
