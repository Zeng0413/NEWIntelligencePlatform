//
//  TSScreenShotView.h
//  RunningMan
//
//  Created by Seven Lv on 16/1/4.
//  Copyright © 2016年 Toocms. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TSScreenShotView : UIView

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) NSMutableArray *imageArray;

- (void)showEffectChange:(CGPoint)pt;
- (void)restore;
- (void)screenShot;
@end
