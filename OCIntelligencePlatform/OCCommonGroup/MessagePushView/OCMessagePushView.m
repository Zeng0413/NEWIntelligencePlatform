//
//  OCMessagePushView.m
//  OCIntelligencePlatform
//
//  Created by Alan on 2019/8/17.
//  Copyright © 2019 OCZHKJ. All rights reserved.
//

#import "OCMessagePushView.h"

@interface OCMessagePushView ()

@property (copy, nonatomic) viewClickAction viewClick;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *message;
@end

@implementation OCMessagePushView

+(void)showMessagePushViewWithTitle:(NSString *)title messageText:(NSString *)message viewClick:(void (^)(void))viewClick{
    OCMessagePushView *pushView = [[OCMessagePushView alloc] initWithFrame:Rect(25*FITWIDTH, -40, kViewW-50*FITWIDTH, 40*FITWIDTH)];
    pushView.backgroundColor = CLEAR;
//    pushView.layer.cornerRadius = 20*FITWIDTH;
    
    pushView.title = title;
    pushView.message = message;
    pushView.viewClick = viewClick;
    
    [pushView initWithUI];
}

-(void)initWithUI{
    UIView *backView = [UIView viewWithBgColor:WHITE frame:Rect(5*FITWIDTH, 0, self.width-10*FITWIDTH, self.height)];
    backView.layer.cornerRadius = self.height/2;
    [self addSubview:backView];
    
    UILabel *topicLab = [UILabel labelWithText:self.title font:16*FITWIDTH textColor:WHITE frame:CGRectZero];
    topicLab.size = CGSizeMake(32*FITWIDTH, 32*FITWIDTH);
    topicLab.x = 4*FITWIDTH;
    topicLab.y = (self.height - topicLab.height)/2;
    topicLab.backgroundColor = arc4randomColor ;
    topicLab.layer.masksToBounds = YES;
    topicLab.layer.cornerRadius = 16*FITWIDTH;
    topicLab.textAlignment = NSTextAlignmentCenter;
    [backView addSubview:topicLab];
    
    UILabel *titleLab = [UILabel labelWithText:self.message font:12*FITWIDTH textColor:TEXT_COLOR_GRAY frame:CGRectZero];
    titleLab.size = [titleLab.text sizeWithFont:kFont(12*FITWIDTH)];
    titleLab.x = MaxX(topicLab)+12*FITWIDTH;
    titleLab.centerY = topicLab.centerY;
    [backView addSubview:titleLab];
    
    CALayer *shadowLayer = [UIView creatShadowLayer:backView.frame cornerRadius:self.height/2 backgroundColor:WHITE shadowColor:TEXT_COLOR_LIGHT_GRAY shadowOffset:CGSizeMake(3, 3) shadowOpacity:0.5 shadowRadius:5];
    [self.layer insertSublayer:shadowLayer below:backView.layer];
    
    [[[UIApplication sharedApplication] keyWindow] addSubview:self];
    [UIView animateWithDuration:0.5 animations:^{
        self.y = 28*FITWIDTH;
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick)];
    [backView addGestureRecognizer:tap];
    
    Weak;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [wself hidePushView];
    });
    
}

-(void)tapClick{
    [self hidePushView];
    if (self.viewClick) {
        self.viewClick();
    }
}

-(void)hidePushView{
    [UIView animateWithDuration:0.5 animations:^{
        self.y = -40*FITWIDTH;
    } completion:^(BOOL finished) {
        self.hidden = YES;
        [self removeFromSuperview];
    }];
    
}
@end
