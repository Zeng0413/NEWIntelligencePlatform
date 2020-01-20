//
//  TSScreenShotView.m
//  RunningMan
//
//  Created by Seven Lv on 16/1/4.
//  Copyright © 2016年 Toocms. All rights reserved.
//

#import "TSScreenShotView.h"
#import "AppDelegate.h"

@implementation TSScreenShotView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.imageArray = [NSMutableArray array];
        self.backgroundColor = [UIColor blackColor];
        self.imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        
        self.maskView = [[UIView alloc] initWithFrame:self.bounds];
        self.maskView.backgroundColor = [UIColor colorWithHue:0 saturation:0 brightness:0 alpha:0.0];
        [self addSubview:self.imageView];
        [self addSubview:self.maskView];
    }
    return self;
}

- (void)layoutSubviews
{
    
    [super layoutSubviews];
}

- (void)showEffectChange:(CGPoint)pt
{
    if (pt.x > 0)
    {
        self.maskView.backgroundColor = [UIColor colorWithHue:0 saturation:0 brightness:0 alpha:-pt.x / 320.0 * 0.4 + 0.4];
        self.imageView.transform = CGAffineTransformMakeScale(0.95 + (pt.x / 320.0 * 0.05), 0.95 + (pt.x / 320.0 * 0.05));
    }
}

- (void)restore
{
    if (self.maskView && self.imageView)
    {
        self.maskView.backgroundColor = [UIColor colorWithHue:0 saturation:0 brightness:0 alpha:0.4];
        self.imageView.transform = CGAffineTransformMakeScale(0.95, 0.95);
    }
}

- (void)screenShot
{
        AppDelegate *appdelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(kViewW, kViewH), YES, 0);
        [appdelegate.window.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        CGImageRef imageRef = viewImage.CGImage;
        UIImage *sendImage = [[UIImage alloc] initWithCGImage:imageRef];
        self.imageView.image = sendImage;
        self.imageView.transform = CGAffineTransformMakeScale(0.95, 0.95);
}

@end
