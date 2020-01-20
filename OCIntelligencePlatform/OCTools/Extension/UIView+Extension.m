//
//  UIVew+SL.m
//  SPAHOME
//
//  Created by 吕超 on 15/4/7.
//  Copyright (c) 2015年 TooCMS. All rights reserved.
//
#import "UIView+Extension.h"
#import <objc/runtime.h>

#pragma mark - UIView (Extension)

static NSString * const kCornerRadiusKey = @"cornerRadius";
static NSString * const kBorderColorKey = @"borderColorKey";

@implementation UIView (Extension)
- (void)setX:(CGFloat)x
{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

-(CGFloat)x
{
    return self.frame.origin.x;
}

- (void)setY:(CGFloat)y
{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)y
{
    return self.frame.origin.y;
}

- (void)setWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)width {
    return self.frame.size.width;
}

- (void)setHeight:(CGFloat)height
{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGFloat)height {
    return self.frame.size.height;
}
- (void)setSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}
- (CGSize)size {
    return self.frame.size;
}

- (void)setOrigin:(CGPoint)origin
{
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}
- (CGPoint)origin {
    return self.frame.origin;
}

- (CGFloat)halfWidth {
    return self.width * 0.5;
}

- (CGFloat)halfHeight {
    return self.height * 0.5;
}

- (CGFloat)cornerRadius
{
    return [objc_getAssociatedObject(self, &kCornerRadiusKey) floatValue];
}


- (void)setCornerRadius:(CGFloat)cornerRadius
{
//    CAShapeLayer *layer = [CAShapeLayer layer];
//    layer.path = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(cornerRadius, cornerRadius)].CGPath;
//    self.layer.cornerRadius = cornerRadius;
//    self.layer.masksToBounds = YES;
//    objc_setAssociatedObject(self, &kCornerRadiusKey, @(cornerRadius), OBJC_ASSOCIATION_ASSIGN);
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(cornerRadius, cornerRadius)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

- (CGFloat)centerX
{
    return self.center.x;
}

- (void)setCenterX:(CGFloat)centerX
{
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}
- (CGFloat)centerY
{
    return self.center.y;
}

- (void)setCenterY:(CGFloat)centerY
{
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}

- (UIColor *)borderColor
{
    return objc_getAssociatedObject(self, &kBorderColorKey);
}

- (void)setBorderColor:(UIColor *)borderColor
{
    self.layer.borderColor = borderColor.CGColor;
    objc_setAssociatedObject(self, &kBorderColorKey, borderColor, OBJC_ASSOCIATION_ASSIGN);
}

- (CGFloat)borderWidth
{
    return self.layer.borderWidth;
}

- (void)setBorderWidth:(CGFloat)borderWidth
{
    self.layer.borderWidth = borderWidth;
}

- (CGFloat)maxX
{
    return CGRectGetMaxX(self.frame);
}
- (void)setMaxX:(CGFloat)maxX
{
    self.x = maxX - self.width;
}

- (CGFloat)maxY
{
    return CGRectGetMaxY(self.frame);
}
- (void)setMaxY:(CGFloat)maxY
{
    self.y = maxY - self.height;
}



- (CGFloat)oc_left {
    return self.frame.origin.x;
}

- (void)setOc_left:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)oc_top {
    return self.frame.origin.y;
}

- (void)setOc_top:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)oc_right {
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setoc_right:(CGFloat)right {
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}

- (CGFloat)oc_bottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setoc_bottom:(CGFloat)bottom {
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}











+ (UIView *)viewWithBgColor:(UIColor *)bgColor frame:(CGRect)frame {
    UIView * view = [[UIView alloc] initWithFrame:frame];
    if (!bgColor) {
        view.backgroundColor = [UIColor clearColor];
    } else {
        view.backgroundColor = bgColor;
    }
    return view;
}

+ (instancetype)creatView { return nil; }
///  从xib中加载和类名一样的xib
+ (instancetype)creatViewFromNib {
    return [self creatViewFromNibName:NSStringFromClass([self class]) atIndex:0];
}

+ (instancetype)creatViewFromNibName:(NSString *)aName atIndex:(NSInteger)index {
    return [[[NSBundle mainBundle] loadNibNamed:aName owner:nil options:nil] objectAtIndex:index];
}

- (void)addRoundingCorners:(UIRectCorner)corners cornerRadii:(CGSize)cornerRadii {
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corners cornerRadii:cornerRadii];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
    [self.layer setMasksToBounds:YES];
}

+ (void)addRoundingForView:(UIView *)view Corners:(UIRectCorner)corners frame:(CGRect)frame cornerRadii:(CGSize)cornerRadii {
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:frame byRoundingCorners:corners cornerRadii:cornerRadii];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = frame;
    maskLayer.path = maskPath.CGPath;
    view.layer.mask = maskLayer;
    [view.layer setMasksToBounds:YES];
}

+ (CALayer *)creatShadowLayer:(CGRect)frame cornerRadius:(CGFloat)cornerRadius backgroundColor:(UIColor *)backgroundColor shadowColor:(UIColor *)shadowColor shadowOffset:(CGSize)size shadowOpacity:(CGFloat)shadowOpacity shadowRadius:(CGFloat)shadowRadius {
    
    CALayer *subLayer = [CALayer layer];
    subLayer.frame = frame;
    subLayer.cornerRadius = cornerRadius;
    subLayer.backgroundColor = backgroundColor.CGColor;
    subLayer.masksToBounds = NO;
    subLayer.shadowColor = shadowColor.CGColor;
    subLayer.shadowOffset = size;
    subLayer.shadowOpacity = 0.5;
    subLayer.shadowRadius = 8;
    
    return subLayer;
}

- (void)creatShaplayer:(UIColor *)shapColor lineWidth:(CGFloat)lineWidth lineDashPattern:(NSArray *)lineDashPattern {
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.position = CGPointMake(1, 2);
    shapeLayer.fillColor = nil;
    shapeLayer.strokeColor = shapColor.CGColor;
    // 3.0f设置虚线的宽度
    shapeLayer.lineWidth = lineWidth;
    shapeLayer.lineJoin = kCALineJoinRound;
    // 2=线的宽度 3=每条线的间距
    shapeLayer.lineDashPattern = lineDashPattern;
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0, 0);
    CGPathAddLineToPoint(path, NULL, self.width, 0);
    shapeLayer.path = path;
    CGPathRelease(path);
    [self.layer addSublayer:shapeLayer];
}

- (CAGradientLayer *)addGradientLayerWithCGColors:(NSArray *)Colors locations:(NSArray *)locations startPoint:(CGPoint)start endPoint:(CGPoint)end {
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = self.bounds;
    gradientLayer.colors = Colors;
        gradientLayer.locations = locations;
    gradientLayer.startPoint = start;
    gradientLayer.endPoint = end;
    [self.layer addSublayer:gradientLayer];
    
    return gradientLayer;
}

- (UIImage *)imageFromView:(UIView *)view {
    
    CGSize size = view.bounds.size;
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end


#pragma mark - UILabel (Extension)
@implementation UILabel (Extension)

+ (UILabel *)_label
{
    return [[self alloc] init];
}

+ (UILabel *)labelWithText:(NSString *)text font:(CGFloat)fontSize textColor:(UIColor *)color frame:(CGRect)frame
{
    UILabel * label = [[self alloc] initWithFrame:frame];
    label.font = [UIFont systemFontOfSize:fontSize];
    if (text) label.text = NSStringFormat(@"%@",text);
    if (color) label.textColor = color;
    return label;
}
static NSString * key = @"phone";
- (void)callWithPhone:(NSString *)phone {
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapView)]];
    objc_setAssociatedObject(self, &key, phone, OBJC_ASSOCIATION_ASSIGN);
}
- (void)tapView {
    NSString * phone = objc_getAssociatedObject(self, &key);
    
}


+(id)setSomeTextChangeColor:(UILabel *)label SetSelectArray:(NSArray *)arrray SetChangeColor:(UIColor *)color
{
	if (label.text.length == 0) {
		return 0;
	}
	int i;
	NSMutableAttributedString *attributeString  = [[NSMutableAttributedString alloc]initWithString:label.text];
	for (i = 0; i < label.text.length; i ++) {
		NSString *a = [label.text substringWithRange:NSMakeRange(i, 1)];
		NSArray *number = arrray;
		if ([number containsObject:a]) {
			[attributeString setAttributes:@{NSForegroundColorAttributeName:color} range:NSMakeRange(i, 1)];
		}
	}
	label.attributedText = attributeString;
	return label;
}

+ (void)changeLineSpaceForLabel:(UILabel *)label WithSpace:(float)space {
	
	NSString *labelText = label.text;
	NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText];
	
	NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
	[paragraphStyle setLineSpacing:space];
	[attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
	label.attributedText = attributedString;
}

+ (void)changeWordSpaceForLabel:(UILabel *)label WithSpace:(float)space {
	
	NSString *labelText = label.text;
	NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText attributes:@{NSKernAttributeName:@(space)}];
	NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
	[attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
	label.attributedText = attributedString;
	[label sizeToFit];
	
}

@end


#pragma mark - UIImageView
@implementation UIImageView (Extension)

+ (UIImageView *)imageViewWithImage:(UIImage *)image frame:(CGRect)frame {
    UIImageView * imageView = [[UIImageView alloc] initWithFrame:frame];
    if (image && [image isKindOfClass:[UIImage class]]) {
        [imageView setImage:image];
    }
    return imageView;
}

+ (UIImageView *)imageViewWithUrl:(NSURL *)url frame:(CGRect)frame {
    
    return [self imageViewWithUrl:url placeHolder:nil frame:frame];
}

+ (UIImageView *)imageViewWithUrl:(NSURL *)url placeHolder:(UIImage *)placeHolder frame:(CGRect)frame {
    
    UIImageView * imageView = [[UIImageView alloc] initWithFrame:frame];
    [imageView sd_setImageWithURL:url placeholderImage:placeHolder];
    
    return imageView;
}

+ (UIImage *)image:(UIImage*)image scaleToSize:(CGSize)size {
    
    UIGraphicsBeginImageContext(size);//size为CGSize类型，即你所需要的图片尺寸
    [image drawInRect:CGRectMake(0,0, size.width, size.height)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return scaledImage;
}

@end

#pragma mark - UIScrollView
@implementation UIScrollView (Extension)

+ (UIScrollView *)scrollViewWithBgColor:(UIColor *)bgColor frame:(CGRect)frame
{
    UIScrollView * scrollView = [[UIScrollView alloc] initWithFrame:frame];
    if (bgColor) {
        scrollView.backgroundColor = bgColor;
    } else {
        scrollView.backgroundColor = [UIColor clearColor];
    }
	
	scrollView.showsVerticalScrollIndicator = NO;
	scrollView.showsHorizontalScrollIndicator = NO;
	
    return scrollView;
}


@end



