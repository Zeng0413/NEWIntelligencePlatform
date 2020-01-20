//
//  NSString+Category.h
//  AFN
//
//  Created by seven on 15/5/15.
//  Copyright (c) 2015年 toocms. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (Category)
+ (NSString *)UUID;
/**
 *  将长数字以3位用逗号隔开表示（例如：18000 -> 18,000）
 *
 *  @param numberString 数字字符串 （例如：@"124234")
 *
 *  @return 以3位用逗号隔开的数字符串（例如：124,234）
 */
+ (NSString *)formatNumber:(NSString *)numberString;
- (NSString *)formatNumber;

/** md5加密（并且对加密后的字符打乱顺序） */
+ (NSString *)MD5String:(NSString *)string;
- (NSString *)MD5String;

+ (NSString *)sha1:(NSString *)text;
+ (NSString *)md5for32:(NSString *)str;

/** 移除html标签 */
+ (NSString *)removeHTML:(NSString *)html;
+ (NSString *)removeHTML2:(NSString *)html;

/** 验证email */
+ (BOOL)validateEmail:(NSString *)email;
- (BOOL)validateEmail;

/** 手机号码验证 */
+ (BOOL)validateMobile:(NSString *)mobile;
- (BOOL)validateMobile;

//判斷是否包含表情
+ (BOOL)stringContainsEmoji:(NSString *)string;

+ (BOOL)validateString:(NSString *)passWord;
- (BOOL)validateString;

/** (由英文、数字和下划线构成，6-18位，首字母只能是英文和数字) */
+ (BOOL)validatePassword:(NSString *)passWord;
- (BOOL)validatePassword;

/// 将int类型转成NSString
FOUNDATION_EXTERN NSString * stringWithInt(int number);
/// 将NSInteger类型转成NSString
FOUNDATION_EXTERN NSString * stringWithInteger(NSInteger number);
/// 将double类型转成NSString，默认2位小数
FOUNDATION_EXTERN NSString * stringWithDouble(double number);
/// 将double类型转成NSString并带上小数位数
FOUNDATION_EXTERN NSString * stringWithDoubleAndDecimalCount(double number, unsigned int count);


/**
 *  计算文字尺寸
 *
 *  @param aString     文字
 *  @param fontSize    文字大小
 *  @param stringWidth 所在控件的宽度
 *
 *  @return 文字尺寸
 */
+ (CGSize)getStringRect:(NSString*)aString fontSize:(CGFloat)fontSize width:(float)stringWidth;

/**
 *  计算文字尺寸
 *
 *  @param fontSize    文字大小
 *  @param stringWidth 所在控件的宽度
 *
 *  @return 文字尺寸
 */
- (CGSize)getStringRectWithfontSize:(CGFloat)fontSize width:(float)stringWidth;

/**
 *  生成包含颜色和字体大小的富文本
 *
 *  @param allString  所有文字
 *  @param pointStr 目标文字
 *
 *  @return 文字尺寸
 */
+ (NSMutableAttributedString *)attrStrFrom:(NSString *)allString pointStr:(NSString *)pointStr color:(UIColor *)color font:(UIFont *)font;

+ (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxW:(CGFloat)maxW;

/**
 *  设置行间距
 *
 *  @param content  目标文字
 *  @param LineSpacing 行间距
 *
 *  @return 富文本
 */
+ (NSMutableAttributedString *)setLineSpacingString:(NSString *)content lineSpacing:(CGFloat)LineSpacing;

/**
 *  根据字符串长度计算label的尺寸
 *
 *  @param text     要计算的字符串
 *  @param fontSize 字体大小
 *  @param maxSize  label允许的最大尺寸
 *
 *  @return label的尺寸
 */
+ (CGSize)labelAutoCalculateRectWith:(NSString*)text FontSize:(CGFloat)fontSize MaxSize:(CGSize)maxSize;

//根据文字和字体的大小计算文字的容器的大小
+ (CGRect)rectWithText:(NSString *)text font:(UIFont *)font size:(CGSize)size;

//竖排文字
- (NSString *)VerticalString;

//去掉小数点后的末位0
+ (NSString *)removeFloatAllZero:(id)value;


//是否包含字母
- (BOOL)containLetter;

//去掉所有符号
- (NSString *)deleteIllegalChar;

+ (NSString *)replacePunctuationFor:(NSString *)targetString;

/*给字符串每个字符后添加字符
 *  @param string:添加的字符
 */
- (NSString *)addForEverCharWith:(NSString *)string;

//汉字转拼音
+ (NSString *)transformToPinyinWithString:(NSString *)str;
//拼音加数字 转拼音
+ (NSString *)numberPinyinChangeToPinyinWith:(NSString *)text;
//数字转汉字
+ (NSString *)numberChangeToHanzeWith:(NSString *)text;
/**
 为字符串进行 base64 编码
 **/
- (NSString *)encodeBase64;
/**
 sha1 加密
 **/
- (NSString *)sha1String;

//对象转json字符串
+ (NSString *)convertToJsonData:(id)obj;

//字符串转字典
+ (NSDictionary *)stringConvertToDic:(NSString *)string;

- (BOOL)isChinese:(NSString *)str;
//查找字符串中相同子字符串的不同位置
+ (NSMutableArray*)calculateSubStringCount:(NSString *)content str:(NSString *)tab;

- (CGFloat)HeightParagraphSpeace:(CGFloat)lineSpeace withFont:(UIFont*)font AndWidth:(CGFloat)width;

- (NSString *)safeSubstringFromIndex:(NSUInteger)from;


-(CGSize)sizeWithFont:(UIFont *)font maxW:(CGFloat)maxW;

-(CGSize)sizeWithFont:(UIFont *)font;

+ (BOOL)checkIsChinese:(NSString *)string;
@end
