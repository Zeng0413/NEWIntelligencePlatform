//
//  UIButton+SL.m
//  Sushi
//
//  Created by toocmstoocms on 15/5/8.
//  Copyright (c) 2015年 Seven. All rights reserved.
//
#import <UIKit/UIKit.h>

#import "UIButton+Extension.h"
#import <objc/runtime.h>
static dispatch_source_t timer = NULL;

@implementation UIButton (Extension)
- (void)setTitle:(NSString *)title
{
    [self setTitle:title forState:UIControlStateNormal];
}
- (void)setAttributeTitle:(NSAttributedString *)attributeTitle
{
    [self setAttributedTitle:attributeTitle forState:normal];
}

- (NSString *)title
{
    return self.currentTitle;
}
- (void)setImage:(NSString *)image
{
    [self setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
}
- (NSString *)image
{
    return nil;
}
-(void)addTarget:(id)target action:(SEL)action {
    [self addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}
- (void)setTitleColor:(UIColor *)titleColor
{
    [self setTitleColor:titleColor forState:UIControlStateNormal];
}
- (UIColor *)titleColor
{
    return self.currentTitleColor;
}
- (NSString *)highlightImage
{
    return nil;
}
- (void)setHighlightImage:(NSString *)highlightImage
{
    [self setImage:[UIImage imageNamed:highlightImage] forState:UIControlStateHighlighted];
}
- (NSString *)selectImage
{
    return nil;
}
- (void)setSelectImage:(NSString *)selectImage
{
    [self setImage:[UIImage imageNamed:selectImage] forState:UIControlStateSelected];
}
- (CGFloat)titleFont
{
    return 0;
}
- (void)setTitleFont:(CGFloat)titleFont
{
    self.titleLabel.font = [UIFont systemFontOfSize:titleFont];
}
- (UIColor *)selectTitleColor
{
    return nil;
}
- (void)setSelectTitleColor:(UIColor *)selectTitleColor
{
    [self setTitleColor:selectTitleColor forState:UIControlStateSelected];
}
+ (UIButton *)buttonWithTitle:(NSString *)title titleColor:(UIColor *)titleColor backgroundColor:(UIColor *)bgColor font:(CGFloat)fontSize image:(NSString *)imageName frame:(CGRect)frame
{
    return [UIButton buttonWithTitle:title titleColor:titleColor backgroundColor:bgColor font:fontSize image:imageName target:nil action:nil frame:frame];
}

+ (UIButton *)buttonWithTitle:(NSString *)title
                   titleColor:(UIColor *)titleColor
              backgroundColor:(UIColor *)bgColor
                         font:(CGFloat)fontSize
                        image:(NSString *)imageName
                       target:(id)target
                       action:(SEL)action
                        frame:(CGRect)frame {
    
    UIButton * button = [[UIButton alloc] initWithFrame:frame];
    button.adjustsImageWhenDisabled = NO;
    button.adjustsImageWhenHighlighted = NO;
    if (title) button.title = title;
    if (titleColor) button.titleColor = titleColor;
    if (bgColor) button.backgroundColor = bgColor;
    if (fontSize) button.titleFont = fontSize;
    if (imageName) {
        button.image = imageName;
        button.contentMode = UIViewContentModeCenter;
    }
    if (target && action) {
        [button addTarget:target action:action];
    }
    return button;
}

- (void)countDownWithTime:(NSInteger)timeLine title:(NSString *)title countDownTitle:(NSString *)subTitle backgroundColor:(UIColor *)mColor disabledColor:(UIColor *)color {
    
    if (timer) {
        dispatch_source_cancel(timer);
        timer = NULL;
    }
    
    //倒计时时间
    __block NSInteger timeOut = timeLine;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    timer = _timer;
    //每秒执行一次
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(_timer, ^{
        
        if (![self superview]) {
            dispatch_source_cancel(_timer);
            return ;
        }
        
        //倒计时结束，关闭
        if (timeOut <= 0) {
            dispatch_source_cancel(_timer);
            timer = NULL;
            dispatch_async(dispatch_get_main_queue(), ^{
                self.backgroundColor = mColor;
                [self setTitle:title forState:UIControlStateNormal];
                self.userInteractionEnabled = YES;
            });
        } else {
            NSInteger seconds = timeOut;
            NSString *timeStr = [NSString stringWithFormat:@"%ld", (long)seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.backgroundColor = color;
                [self setTitle:[NSString stringWithFormat:@"%@%@",timeStr,subTitle] forState:UIControlStateNormal];
                self.userInteractionEnabled = NO;
            });
            timeOut--;
        }
    });
    dispatch_resume(_timer);
}


@end
