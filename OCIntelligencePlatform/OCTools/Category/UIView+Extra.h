//
//  UIView+Extra.h
//  中国银行
//
//  Created by rimi on 16/6/18.
//  Copyright © 2016年 WHM. All rights reserved.
//

#import <UIKit/UIKit.h>

//IB_DESIGNABLE
@interface UIView (Extra)

@property (nonatomic, assign) IBInspectable CGFloat cornerRadius;
@property (nonatomic, assign) IBInspectable CGFloat borderWidth;
@property (nonatomic, assign) IBInspectable UIColor * boderColor;
@property (nonatomic, assign) IBInspectable CGColorRef shadowColor;
@property (nonatomic, assign) IBInspectable CGFloat shadowOpcaity;
@property (nonatomic, assign) IBInspectable CGSize shadowOffset;
@property (nonatomic, assign) IBInspectable CGFloat shadowRadius;

@end
