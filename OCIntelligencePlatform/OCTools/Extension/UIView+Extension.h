//
//  UIVew+SL.h
//  SPAHOME
//
//  Created by 吕超 on 15/4/7.
//  Copyright (c) 2015年 TooCMS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Extension)

@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGSize  size;
@property (nonatomic, assign) CGPoint origin;
@property (nonatomic, assign) CGFloat cornerRadius;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;

@property (nonatomic, assign, readonly) CGFloat halfHeight;
@property (nonatomic, assign, readonly) CGFloat halfWidth;
/** 边框颜色 */
@property (nonatomic, strong) UIColor * borderColor;
/** 边框宽度 */
@property (nonatomic, assign) CGFloat borderWidth;
/** 最大 X */
@property (nonatomic, assign) CGFloat maxX;
/** 最大 Y */
@property (nonatomic, assign) CGFloat maxY;


@property (nonatomic,assign)CGFloat oc_top;

@property (nonatomic,assign)CGFloat oc_left;

@property (nonatomic,assign)CGFloat oc_right;

@property (nonatomic,assign)CGFloat oc_bottom;

+ (UIView *)viewWithBgColor:(UIColor *)bgColor frame:(CGRect)frame;



///  创建view
///  由子类实现
+ (instancetype)creatView;

///  从xib中加载和类名一样的xib
+ (instancetype)creatViewFromNib;
///  从xib中加载view
///  @param aName xib名字
///  @param index 在xib数组中的索引
+ (instancetype)creatViewFromNibName:(NSString *)aName atIndex:(NSInteger)index;
/*
 * corners:需要添加圆角的方向
 * cornerRadii：每个圆角的大小
 */
- (void)addRoundingCorners:(UIRectCorner)corners cornerRadii:(CGSize)cornerRadii;

+ (void)addRoundingForView:(UIView *)view Corners:(UIRectCorner)corners frame:(CGRect)frame cornerRadii:(CGSize)cornerRadii;

/*
 * colors:渐变颜色数组，CGColor
 * locations：颜色位置，和颜色数组对应
 */
- (CAGradientLayer *)addGradientLayerWithCGColors:(NSArray *)Colors locations:(NSArray *)locations startPoint:(CGPoint)start endPoint:(CGPoint)end;
/*
 * 阴影
 */
+ (CALayer *)creatShadowLayer:(CGRect)frame cornerRadius:(CGFloat)cornerRadius backgroundColor:(UIColor *)backgroundColor shadowColor:(UIColor *)shadowColor shadowOffset:(CGSize)size shadowOpacity:(CGFloat)shadowOpacity shadowRadius:(CGFloat)shadowRadius;
/*
 * 虚线
 */
- (void)creatShaplayer:(UIColor *)shapColor lineWidth:(CGFloat)lineWidth lineDashPattern:(NSArray *)lineDashPattern;

//生成image
- (UIImage *)imageFromView:(UIView *)view;

@end


@interface UILabel (Extension)

+ (UILabel *)_label;
+ (UILabel *)labelWithText:(NSString *)text font:(CGFloat)fontSize textColor:(UIColor *)color frame:(CGRect)frame;

//label 改变行间距
+ (void)changeLineSpaceForLabel:(UILabel *)label WithSpace:(float)space ;
//label 改变字间距
+ (void)changeWordSpaceForLabel:(UILabel *)label WithSpace:(float)space;

//部分文字改变颜色
+(id)setSomeTextChangeColor:(UILabel *)label SetSelectArray:(NSArray *)arrray SetChangeColor:(UIColor *)color;

- (void)callWithPhone:(NSString *)phone;

@end


@interface UIImageView (Extension)
+ (UIImageView *)imageViewWithUrl:(NSURL *)url frame:(CGRect)frame;
+ (UIImageView *)imageViewWithUrl:(NSURL *)url placeHolder:(UIImage *)placeHolder frame:(CGRect)frame;
+ (UIImageView *)imageViewWithImage:(UIImage *)image frame:(CGRect)frame;
+ (UIImage *)image:(UIImage*)image scaleToSize:(CGSize)size;
@end

@interface UIScrollView (Extension)
+ (UIScrollView *)scrollViewWithBgColor:(UIColor *)bgColor frame:(CGRect)frame;
@end

