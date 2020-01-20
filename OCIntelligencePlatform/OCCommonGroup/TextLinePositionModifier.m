//
//  TextLinePositionModifier.m
//  AttributeDemo
//
//  Created by April on 2019/12/9.
//  Copyright © 2019 zdx. All rights reserved.
//

#import "TextLinePositionModifier.h"

@implementation TextLinePositionModifier

- (CGFloat)heightForLineCount:(NSUInteger)lineCount {
    if (lineCount == 0) return 0;
//    CGFloat ascent = _font.ascender;
//    CGFloat descent = -_font.descender;
    CGFloat ascent = _font.pointSize * 0.86;
    CGFloat descent = _font.pointSize * 0.14;
    CGFloat lineHeight = _font.pointSize * _lineHeightMultiple;
    return _paddingTop + _paddingBottom + ascent + descent + (lineCount - 1) * lineHeight;
}

- (nonnull id)copyWithZone:(nullable NSZone *)zone {
    TextLinePositionModifier *one = [self.class new];
    one->_font = _font;
    one->_paddingTop = _paddingTop;
    one->_paddingBottom = _paddingBottom;
    one->_lineHeightMultiple = _lineHeightMultiple;
    return one;
}

- (void)modifyLines:(nonnull NSArray<YYTextLine *> *)lines fromText:(nonnull NSAttributedString *)text inContainer:(nonnull YYTextContainer *)container {
    //CGFloat ascent = _font.ascender;
    CGFloat ascent = _font.pointSize * 0.86;
    
    CGFloat lineHeight = _font.pointSize * _lineHeightMultiple;
    for (YYTextLine *line in lines) {
        CGPoint position = line.position;
        position.y = _paddingTop + ascent + line.row  * lineHeight;
        line.position = position;
    }

}

@end
