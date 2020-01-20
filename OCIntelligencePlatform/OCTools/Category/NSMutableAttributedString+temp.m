//
//  NSMutableAttributedString+temp.m
//  AttributeDemo
//
//  Created by April on 2019/12/9.
//  Copyright © 2019 zdx. All rights reserved.
//

#import "NSMutableAttributedString+temp.h"
#import "YYKit.h"

@implementation NSMutableAttributedString (temp)

+(instancetype)textWithStr:(NSString *)contentStr fontSize:(NSInteger)fontSize textColor:(UIColor *)textColor withHightStrArr:(NSArray *)hightStrArr{
    NSString *string = contentStr.mutableCopy;
    
    UIFont *font = [UIFont systemFontOfSize:fontSize];

    // 高亮状态的背景
    YYTextBorder *highlightBorder = [YYTextBorder new];
    highlightBorder.insets = UIEdgeInsetsMake(-2, 0, -2, 0);
    highlightBorder.cornerRadius = 3;
    highlightBorder.fillColor = CLEAR;
    
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:string];
    text.font = font;
    text.color = textColor;
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"@[-_a-zA-Z0-9\u4E00-\u9FA5]+" options:kNilOptions error:NULL];
    NSArray *atResults = [regex matchesInString:text.string options:kNilOptions range:text.rangeOfAll];
    for (NSTextCheckingResult *at in atResults) {
        if (at.range.location == NSNotFound && at.range.length <= 1) continue;
        if ([text attribute:YYTextHighlightAttributeName atIndex:at.range.location] == nil) {
            [text setColor:kAPPCOLOR range:at.range];
            
            // 高亮状态
            YYTextHighlight *highlight = [YYTextHighlight new];
            [highlight setBackgroundBorder:highlightBorder];
            // 数据信息，用于稍后用户点击
            highlight.userInfo = @{@"at" : [text.string substringWithRange:NSMakeRange(at.range.location + 1, at.range.length - 1)]};
            [text setTextHighlight:highlight range:at.range];
        }
    }
    
    NSRegularExpression *topsRegex = [NSRegularExpression regularExpressionWithPattern:@"#[-_a-zA-Z0-9\u4E00-\u9FA5]+" options:kNilOptions error:NULL];
    NSArray *topsAtResults = [topsRegex matchesInString:text.string options:kNilOptions range:text.rangeOfAll];
    for (NSTextCheckingResult *at in topsAtResults) {
        if (at.range.location == NSNotFound && at.range.length <= 1) continue;
        if ([text attribute:YYTextHighlightAttributeName atIndex:at.range.location] == nil) {
            [text setColor:kAPPCOLOR range:at.range];
            
            // 高亮状态
            YYTextHighlight *highlight = [YYTextHighlight new];
            [highlight setBackgroundBorder:highlightBorder];
            // 数据信息，用于稍后用户点击
            highlight.userInfo = @{@"at" : [text.string substringWithRange:NSMakeRange(at.range.location + 1, at.range.length - 1)]};
            [text setTextHighlight:highlight range:at.range];
        }
    }
    
    if (hightStrArr.count>0) {
        for (NSString *hightStr in hightStrArr) {
            if (hightStr.length>0) {
                NSRange hightRange = [contentStr rangeOfString:hightStr];
                [text setColor:kAPPCOLOR range:hightRange];
                
                // 高亮状态
                YYTextHighlight *highlight = [YYTextHighlight new];
                [highlight setBackgroundBorder:highlightBorder];
                // 数据信息，用于稍后用户点击
                highlight.userInfo = @{@"at" : [text.string substringWithRange:NSMakeRange(hightRange.location + 1, hightRange.length - 1)]};
                [text setTextHighlight:highlight range:hightRange];
            }
        }
    }
    
    
    
    return text;

}\


+(instancetype)textWithStr:(NSString *)contenStr withChangeStr:(NSString *)changeStr withFont:(UIFont *)labelFont{
    NSRange range = [contenStr rangeOfString:changeStr];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:contenStr];
    [str addAttribute:NSFontAttributeName value:labelFont range:range];
    return str;
}
@end
