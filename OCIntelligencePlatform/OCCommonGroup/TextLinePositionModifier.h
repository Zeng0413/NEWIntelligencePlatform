//
//  TextLinePositionModifier.h
//  AttributeDemo
//
//  Created by April on 2019/12/9.
//  Copyright © 2019 zdx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YYKit.h"

NS_ASSUME_NONNULL_BEGIN

@interface TextLinePositionModifier : NSObject <YYTextLinePositionModifier>

@property (nonatomic, strong) UIFont *font; // 基准字体 (例如 Heiti SC/PingFang SC)
@property (nonatomic, assign) CGFloat paddingTop; //文本顶部留白
@property (nonatomic, assign) CGFloat paddingBottom; //文本底部留白
@property (nonatomic, assign) CGFloat lineHeightMultiple; //行距倍数
- (CGFloat)heightForLineCount:(NSUInteger)lineCount;

@end

NS_ASSUME_NONNULL_END
