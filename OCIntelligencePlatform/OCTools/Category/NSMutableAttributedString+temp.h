//
//  NSMutableAttributedString+temp.h
//  AttributeDemo
//
//  Created by April on 2019/12/9.
//  Copyright © 2019 zdx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface NSMutableAttributedString (temp)

+(instancetype)textWithStr:(NSString *)contentStr fontSize:(NSInteger)fontSize textColor:(UIColor *)textColor withHightStrArr:(NSArray *)hightStrArr;

+(instancetype)textWithStr:(NSString *)contenStr withChangeStr:(NSString *)changeStr withFont:(UIFont *)labelFont;

@end

NS_ASSUME_NONNULL_END
