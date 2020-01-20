//
//  UIView+Extra.m
//  中国银行
//
//  Created by rimi on 16/6/18.
//  Copyright © 2016年 WHM. All rights reserved.
//

#import "UIView+Extra.h"

@implementation UIView (Extra)

- (void)setCornerRadius:(CGFloat)cornerRadius {
    self.layer.cornerRadius = cornerRadius;
    self.layer.masksToBounds = cornerRadius > 0;
}


- (CGFloat)cornerRadius {
    return self.layer.cornerRadius;
}


- (void)setBorderWidth:(CGFloat)borderWidth {
    self.layer.borderWidth = borderWidth;
}


- (CGFloat)borderWidth {
    return self.layer.borderWidth;
}


- (void)setBoderColor:(UIColor *)boderColor {
	self.layer.borderColor = boderColor.CGColor;
}

- (UIColor *)boderColor {
    return [UIColor colorWithCGColor:self.layer.borderColor];
}


- (void)setShadowColor:(CGColorRef)shadowColor {
    self.layer.shadowColor = shadowColor;
}


- (CGColorRef)shadowColor {
    return self.layer.shadowColor;
}


- (void)setShadowOffset:(CGSize)shadowOffset {
    self.layer.shadowOffset = shadowOffset;
}


- (CGSize)shadowOffset {
    return self.layer.shadowOffset;
}


- (void)setShadowOpcaity:(CGFloat)shadowOpcaity {
    self.layer.shadowOpacity = shadowOpcaity;
}


- (CGFloat)shadowOpcaity {
    return self.layer.shadowOpacity;
}


- (void)setShadowRadius:(CGFloat)shadowRadius{
    self.layer.shadowRadius = shadowRadius;
}


- (CGFloat)shadowRadius {
    return self.layer.shadowRadius;
}


@end
