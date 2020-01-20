//
//  WGHCountDownButton.m
//  HSHShangcheng
//
//  Created by Alan on 2017/10/24.
//  Copyright © 2017年 luobao. All rights reserved.
//

#import "WGHCountDownButton.h"

@interface WGHCountDownButton ()

@property (nonatomic, strong) dispatch_source_t timer;

@end

@implementation WGHCountDownButton

- (void)countDownFromTime:(NSInteger)startTime unitTitle:(NSString *)unitTitle completion:(Completion)completion {
    
    self.titleColor = self.titleLabel.textColor;
    
    __weak typeof(self) weakSelf = self;
    // 剩余的时间（必须用__block修饰，以便在block中使用）
    _remainTime = startTime;
    // 获取全局队列
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    // 每隔1s钟执行一次
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    // 在queue中执行event_handler事件
    WeakSelf(self);
    dispatch_source_set_event_handler(timer, ^{
        StrongSelf(weakSelf);
        if (strongweakSelf.remainTime <= 0) { // 倒计时结束
			
            dispatch_source_cancel(timer);
            // 回到主线程
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.enabled = YES;
                completion(weakSelf);
            });
        } else {
            NSString *timeStr = [NSString stringWithFormat:@"%ld", strongweakSelf.remainTime];
            // 回到主线程更新UI
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf setTitle:[NSString stringWithFormat:@"%@%@",timeStr,unitTitle] forState:UIControlStateDisabled];
            [weakSelf setBackgroundImage:[self createImageWithColor:WHITE] forState:UIControlStateDisabled];
                weakSelf.enabled = NO;
            });
            strongweakSelf.remainTime--;
        }
    });
    dispatch_resume(timer);
}

- (UIImage *)createImageWithColor:(UIColor *)color {
    // 画布大小
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    // 在当前画布上开启绘图上下文
    UIGraphicsBeginImageContext(rect.size);
    // 画笔
    CGContextRef context = UIGraphicsGetCurrentContext();
    // 设置画笔颜色
    CGContextSetFillColorWithColor(context, [color CGColor]);
    // 填充画布
    CGContextFillRect(context, rect);
    // 取得画布中的图片
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    // 结束绘图上下文
    UIGraphicsEndImageContext();
    return theImage;
}

- (void)cancelCountDown {
    if (_timer) {
        dispatch_source_cancel(_timer);
    }
}

@end
