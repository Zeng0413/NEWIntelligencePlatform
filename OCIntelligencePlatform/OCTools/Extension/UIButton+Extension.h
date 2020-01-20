//
//  UIButton+SL.h
//  Sushi
//
//  Created by toocmstoocms on 15/5/8.
//  Copyright (c) 2015年 Seven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (Extension)
/** 文字*/
@property (nonatomic, copy) NSString * title;
/** 文字大小*/
@property (nonatomic , assign) CGFloat titleFont;
/** 富文本*/
@property (nonatomic, copy) NSAttributedString * attributeTitle;
/** 图片*/
@property (nonatomic, copy) NSString * image;
/** 高亮图片*/
@property (nonatomic, copy) NSString * highlightImage;
/** 选中*/
@property (nonatomic, copy) NSString * selectImage;
/** 文字颜色*/
@property (nonatomic, strong) UIColor * titleColor;
/** 选中文字颜色 */
@property (nonatomic, strong) UIColor * selectTitleColor;



/**
 *  添加监听
 */
- (void)addTarget:(id)target action:(SEL)action;
/// 倒计时
///
/// @param timeLine 共计时间（单位：秒）
/// @param title    正常文字
/// @param subTitle 倒计时的文字（传入时间之后的文字，例如：“s后重新获取”）
/// @param mColor   正常的背景颜色
/// @param color    倒计时背景颜色
- (void)countDownWithTime:(NSInteger)timeLine title:(NSString *)title countDownTitle:(NSString *)subTitle backgroundColor:(UIColor *)mColor disabledColor:(UIColor *)color;

/// 快速创建button
+ (UIButton *)buttonWithTitle:(NSString *)title
                   titleColor:(UIColor *)titleColor
              backgroundColor:(UIColor *)bgColor
                         font:(CGFloat)fontSize
                        image:(NSString *)imageName
                        frame:(CGRect)frame;

/// 快速创建button,带监听
+ (UIButton *)buttonWithTitle:(NSString *)title
                   titleColor:(UIColor *)titleColor
              backgroundColor:(UIColor *)bgColor
                         font:(CGFloat)fontSize
                        image:(NSString *)imageName
                       target:(id)target
                       action:(SEL)action
                        frame:(CGRect)frame;
@end
