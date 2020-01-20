//
//  UIView+directionBorder.m
//  OCIntelligencePlatform
//
//  Created by Alan on 2019/8/28.
//  Copyright © 2019 OCZHKJ. All rights reserved.
//

#import "UIView+directionBorder.h"

@implementation UIView (directionBorder)
- (void)setDirectionBorderWithTop:(BOOL)hasTopBorder left:(BOOL)hasLeftBorder bottom:(BOOL)hasBottomBorder right:(BOOL)hasRightBorder borderColor:(UIColor *)borderColor withBorderWidth:(CGFloat)borderWidth{
    
    float height = self.height;
    
    float width = self.width;
    
    CALayer *topBorder = [CALayer layer];
    
    topBorder.frame = CGRectMake(0, 0, width, borderWidth);
    
    topBorder.backgroundColor = borderColor.CGColor;
    
    CALayer *leftBorder = [CALayer layer];
    
    leftBorder.frame = CGRectMake(0, 0, 1, height);
    
    leftBorder.backgroundColor = borderColor.CGColor;
    
    CALayer *bottomBorder = [CALayer layer];
    
    bottomBorder.frame = CGRectMake(0, height, width, borderWidth);
    
    bottomBorder.backgroundColor = borderColor.CGColor;
    
    CALayer *rightBorder = [CALayer layer];
    rightBorder.frame = CGRectMake(width, 0, borderWidth, height);
    
    rightBorder.backgroundColor = borderColor.CGColor;
    
    
    if (hasTopBorder) {
        [self.layer addSublayer:topBorder];
    }
    if (hasLeftBorder) {
        [self.layer addSublayer:leftBorder];
    }
    if (hasBottomBorder) {
        [self.layer addSublayer:bottomBorder];
    }
    if (hasRightBorder) {
        [self.layer addSublayer:rightBorder];
    }
    
}
@end
