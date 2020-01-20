//
//  NSString+Category.m
//  AFN
//
//  Created by toocmstoocms on 15/5/15.
//  Copyright (c) 2015年 toocmstoocms. All rights reserved.
//
#import <CommonCrypto/CommonDigest.h>
#import "NSString+Category.h"
#import "GTMBase64.h"
@implementation NSString (Category)

+ (NSString *)UUID{
    // create a new UUID which you own
    CFUUIDRef uuidref = CFUUIDCreate(kCFAllocatorDefault);
    
    // create a new CFStringRef (toll-free bridged to NSString)
    // that you own
    CFStringRef uuid = CFUUIDCreateString(kCFAllocatorDefault, uuidref);
    
    NSString *result = (__bridge NSString *)uuid;
    //release the uuidref
    CFRelease(uuidref);
    // release the UUID
    CFRelease(uuid);
    
    return result;
}
- (NSString *)encodeBase64 {
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    data = [GTMBase64 encodeData:data];
    NSString *base64String = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return base64String;
}

+ (NSString *)md5for32:(NSString *)str{
    
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
    
}

+ (NSString *)sha1:(NSString *)text {
    const char * cstr = [text cStringUsingEncoding:NSUTF8StringEncoding];
    
    NSData * data = [NSData dataWithBytes:cstr length:text.length];
    //使用对应的CC_SHA1,CC_SHA256,CC_SHA384,CC_SHA512的长度分别是20,32,48,64
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    //使用对应的CC_SHA256,CC_SHA384,CC_SHA512
    CC_SHA1(data.bytes, data.length, digest);
    
    NSMutableString * output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return output;
}


#pragma mark - 验证email
/** 验证email */
+ (BOOL) validateEmail:(NSString *)email
{
    return [email validateEmail];
}
/** 验证email */
- (BOOL) validateEmail
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:self];
}

#pragma mark - 验证手机
/** 验手机号码 */
+ (BOOL) validateMobile:(NSString *)mobile
{
    return [mobile validateMobile];
}
/** 验手机号码 */
- (BOOL) validateMobile
{
    NSString *phoneRegex = @"^((13[0-9])|(14[57])|(15[^4,\\D])|(17[0-9])|(18[0-9])|(19[0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:self];
}

#pragma mark - 车牌号验证
//车牌号验证
+ (BOOL) validateCarNo:(NSString *)carNo
{
    NSString *carRegex = @"^[\u4e00-\u9fa5]{1}[a-zA-Z]{1}[a-zA-Z_0-9]{4}[a-zA-Z_0-9_\u4e00-\u9fa5]$";
    NSPredicate *carTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",carRegex];
//    NSLog(@"carTest is %@",carTest);
    return [carTest evaluateWithObject:carNo];
}

#pragma mark - 车型
//车型
+ (BOOL) validateCarType:(NSString *)CarType
{
    NSString *CarTypeRegex = @"^[\u4E00-\u9FFF]+$";
    NSPredicate *carTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",CarTypeRegex];
    return [carTest evaluateWithObject:CarType];
}

#pragma mark - 用户名
//用户名
+ (BOOL) validateUserName:(NSString *)name
{
    NSString *userNameRegex = @"^[A-Za-z0-9]{6,20}+$";
    NSPredicate *userNamePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",userNameRegex];
    BOOL B = [userNamePredicate evaluateWithObject:name];
    return B;
}

#pragma mark - 密码
//密码
+ (BOOL) validatePassword:(NSString *)passWord
{

	NSString *passWordRegex = @"^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{6,15}$";//@"^[a-zA-z0-9][a-zA-Z0-9_]{5,14}$";
    NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",passWordRegex];
    return [passWordPredicate evaluateWithObject:passWord];
}
- (BOOL)validatePassword {
    return [NSString validatePassword:self];
}

+ (BOOL) validateString:(NSString *)passWord
{
	
	NSString *passWordRegex = @"^[0-9|A-Z|a-z|.|/|-|_]{5,20}$";
	NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",passWordRegex];
	
	return [passWordPredicate evaluateWithObject:passWord];
}

- (BOOL)validateString {
	return [NSString validateString:self];
}

#pragma mark - 昵称
//昵称
+ (BOOL) validateNickname:(NSString *)nickname
{
    NSString *nicknameRegex = @"([a-z0-9[^A-Za-z0-9_\n\t]]{1,8})";
    NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",nicknameRegex];
    return [passWordPredicate evaluateWithObject:nickname];
}

#pragma mark - 身份证号
//身份证号
+ (BOOL) validateIdentityCard: (NSString *)identityCard
{
    BOOL flag;
    if (identityCard.length <= 0) {
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [identityCardPredicate evaluateWithObject:identityCard];
}


//获取字符串高度
+ (CGSize)getStringRect:(NSString*)aString fontSize:(CGFloat)fontSize width:(int)stringWidth
{
    return [aString getStringRectWithfontSize:fontSize width:stringWidth];
}

- (CGSize)getStringRectWithfontSize:(CGFloat)fontSize width:(int)stringWidth
{
    CGSize size;
    UIFont *font = [UIFont systemFontOfSize:fontSize];
    NSDictionary* dic = @{NSFontAttributeName:font};
    size = [self boundingRectWithSize:CGSizeMake(stringWidth, 2000)  options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    return  size;
}


+ (NSMutableAttributedString *)setLineSpacingString:(NSString *)content lineSpacing:(CGFloat)LineSpacing {
    NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithString:content];
    
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentJustified;
    [paragraphStyle setLineSpacing:LineSpacing];
    
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [content length])];
    
    return attributedString;
}

/**
 *  根据字符串长度计算label的尺寸
 *
 *  @param text     要计算的字符串
 *  @param fontSize 字体大小
 *  @param maxSize  label允许的最大尺寸
 *
 *  @return label的尺寸
 */
+ (CGSize)labelAutoCalculateRectWith:(NSString*)text FontSize:(CGFloat)fontSize MaxSize:(CGSize)maxSize

{
    
    NSMutableParagraphStyle* paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    
    paragraphStyle.lineBreakMode=NSLineBreakByWordWrapping;
    
    NSDictionary* attributes =@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize],NSParagraphStyleAttributeName:paragraphStyle.copy};
    
    CGSize labelSize = [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading|NSStringDrawingTruncatesLastVisibleLine attributes:attributes context:nil].size;
    
    labelSize.height=ceil(labelSize.height);
    
    labelSize.width=ceil(labelSize.width);
    
    return labelSize;
    
}

- (NSString *)VerticalString {
    NSMutableString * str = [[NSMutableString alloc] initWithString:self];
    NSInteger count = str.length;
    for (int i = 1; i < count; i ++) {
        [str insertString:@"\n" atIndex:i * 2 - 1];
    }
    return str;
}

+ (BOOL)stringContainsEmoji:(NSString *)string {
	
	__block BOOL returnValue = NO;
	
	[string enumerateSubstringsInRange:NSMakeRange(0, [string length])
							   options:NSStringEnumerationByComposedCharacterSequences
							usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
								const unichar hs = [substring characterAtIndex:0];
								if (0xd800 <= hs && hs <= 0xdbff) {
									if (substring.length > 1) {
										const unichar ls = [substring characterAtIndex:1];
										const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
										if (0x1d000 <= uc && uc <= 0x1f77f) {
											returnValue = YES;
										}
									}
								} else if (substring.length > 1) {
									const unichar ls = [substring characterAtIndex:1];
									if (ls == 0x20e3) {
										returnValue = YES;
									}
								} else {
									if (0x2100 <= hs && hs <= 0x27ff) {
										returnValue = YES;
									} else if (0x2B05 <= hs && hs <= 0x2b07) {
										returnValue = YES;
									} else if (0x2934 <= hs && hs <= 0x2935) {
										returnValue = YES;
									} else if (0x3297 <= hs && hs <= 0x3299) {
										returnValue = YES;
									} else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
										returnValue = YES;
									}
								}
							}];
	
	return returnValue;
}

#pragma mark - 移除html标签
//转化html为字符串
+ (NSString *)removeHTML:(NSString *)html {
    
    NSScanner *theScanner;
    NSString *text = nil;
    
    theScanner = [NSScanner scannerWithString:html];
    
    while ([theScanner isAtEnd] == NO) {
        
        // find start of tag
        [theScanner scanUpToString:@"<" intoString:NULL] ;
        
        // find end of tag
        [theScanner scanUpToString:@">" intoString:&text] ;
        
        // replace the found tag with a space
        //(you can filter multi-spaces out later if you wish)
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>", text] withString:@""];
    }
    return html;
}

//转化html为字符串
+ (NSString *)removeHTML2:(NSString *)html{
    
    NSArray *components = [html componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    
    NSMutableArray *componentsToKeep = [NSMutableArray array];
    
    for (int i = 0; i < [components count]; i = i + 2) {
        [componentsToKeep addObject:[components objectAtIndex:i]];
    }
    
    NSString *plainText = [componentsToKeep componentsJoinedByString:@""];
    
    return plainText;
    
}

+ (NSString *)convertToJsonData:(id)obj {
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:obj options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString;
    if (!jsonData) {
        NSLog(@"%@",error);
    }else{
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    NSRange range = {0,jsonString.length};
    
    //去掉字符串中的空格
    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
    NSRange range2 = {0,mutStr.length};
    //去掉字符串中的换行符
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    
    return mutStr;
}

+ (NSDictionary *)stringConvertToDic:(NSString *)string {
    NSError *err;
    NSData *jsonData = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
    return dic;
}

#pragma mark - MD5加密
+ (NSString *)MD5String:(NSString *)string
{
    return [string MD5String];
}

- (NSString *)MD5String {
    
    NSString *str = [NSString stringWithFormat:@"%@", self];
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr,(unsigned)strlen(cStr), result);
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

- (NSString *)sha1String {
    if (kStringIsEmpty(self)) {
        NSLog(@"sha1待加密字符串为空");
        return @"";
    }
    return  [NSString sha1:self];
}

- (NSString *)formatNumber;
{
    int count = 0;
    long long int a = self.longLongValue;
    while (a != 0)
    {
        count++;
        a /= 10;
    }
    NSMutableString *string = [NSMutableString stringWithString:self];
    NSMutableString *newstring = [NSMutableString string];
    while (count > 3) {
        count -= 3;
        NSRange rang = NSMakeRange(string.length - 3, 3);
        NSString *str = [string substringWithRange:rang];
        [newstring insertString:str atIndex:0];
        [newstring insertString:@"," atIndex:0];
        [string deleteCharactersInRange:rang];
    }
    [newstring insertString:string atIndex:0];
    return newstring;
}

+ (NSString *)formatNumber:(NSString *)numberString
{
    return numberString.formatNumber;
}

#pragma mark Func
NSString * stringWithInt(int number) {
    return [NSString stringWithFormat:@"%d", number];
}
NSString * stringWithInteger(NSInteger number) {
    return [NSString stringWithFormat:@"%zd", number];
}
NSString * stringWithDouble(double number) {
    return [NSString stringWithFormat:@"%.2f", number];
}
NSString * stringWithDoubleAndDecimalCount(double number, unsigned int count) {
    
    switch (count) {
        case 0:
            return [NSString stringWithFormat:@"%.0f", number];
            break;
        case 1:
            return [NSString stringWithFormat:@"%.1f", number];
            break;
        case 2:
            return [NSString stringWithFormat:@"%.2f", number];
            break;
        case 3:
            return [NSString stringWithFormat:@"%.3f", number];
            break;
        case 4:
            return [NSString stringWithFormat:@"%.4f", number];
            break;
        case 5:
            return [NSString stringWithFormat:@"%.5f", number];
            break;
        default:
            return [NSString stringWithFormat:@"%f", number];
            break;
    }
}

+ (NSMutableAttributedString *)attrStrFrom:(NSString *)allString pointStr:(NSString *)pointStr color:(UIColor *)color font:(UIFont *)font {
    
    NSMutableAttributedString *arrString = [[NSMutableAttributedString alloc]initWithString:allString];
    
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentJustified;
    [paragraphStyle setLineSpacing:4];
    
    [arrString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [allString length])];
    // 设置格式:字号字体、颜色
    [arrString addAttributes:@{NSFontAttributeName:font,
                               NSForegroundColorAttributeName:color
                               }
                       range:[allString rangeOfString:pointStr]];
    
    return arrString;
}


+ (NSMutableArray*)calculateSubStringCount:(NSString *)content str:(NSString *)tab {
    int location = 0;
    NSMutableArray *locationArr = [NSMutableArray new];
    NSRange range = [content rangeOfString:tab];
    if (range.location == NSNotFound){
        return locationArr;
    }
    //声明一个临时字符串,记录截取之后的字符串
    NSString * subStr = content;
    while (range.location != NSNotFound) {
        if (location == 0) {
            location += range.location;
        } else {
            location += range.location + tab.length;
        }
        //记录位置
        NSNumber *number = [NSNumber numberWithUnsignedInteger:location];
        [locationArr addObject:number];
        //每次记录之后,把找到的字串截取掉
        subStr = [subStr substringFromIndex:range.location + range.length];
        range = [subStr rangeOfString:tab];
    }
    return locationArr;
}


//根据文字和字体的大小计算文字的容器的大小
+ (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxW:(CGFloat)maxW
{
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = font;
    CGSize maxSize = CGSizeMake(maxW, MAXFLOAT);
    //约束宽度
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

//根据文字和字体的大小计算文字的容器的大小
+ (CGRect)rectWithText:(NSString *)text font:(UIFont *)font size:(CGSize)size
{
   CGRect rect = [text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil] context:nil];
    return rect;
}

+ (NSString *)removeFloatAllZero:(id)value {
	
	NSString * testNumber = [NSString stringWithFormat:@"%@",value];
	NSString * outNumber = [NSString stringWithFormat:@"%@",@(testNumber.floatValue)];
	return outNumber;
}


- (BOOL)containLetter {
    NSRegularExpression *numberRegular = [NSRegularExpression regularExpressionWithPattern:@"[A-Za-z]" options:NSRegularExpressionCaseInsensitive error:nil];
    
    NSInteger count = -1;
    count = [numberRegular numberOfMatchesInString:self options:NSMatchingReportProgress range:NSMakeRange(0, self.length)];
    
    //count是str中包含[A-Za-z]数字的个数，只要count>0，说明str中包含数字
    if (count >= 0) {
        return YES;
    }
    return NO;
}

- (NSString *)deleteIllegalChar {
    NSString *replaceUnderline = [self stringByReplacingOccurrencesOfString:@"_"withString:@" "];//将下划线剔除出来
//    NSError *error = nil;
//
//    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[\\p{P}~^<>]" options:NSRegularExpressionCaseInsensitive error:&error];
//
//    NSString *modifiedString = [regex stringByReplacingMatchesInString:replaceUnderline options:0 range:NSMakeRange(0, [replaceUnderline length]) withTemplate:@""];
//
//    NSString *replaceBlank = modifiedString;
//    NSArray * replaceArray = @[@"'",@"\r",@"\n",@" ",@"　",@" "];
//    for (NSInteger index = 0; index < replaceArray.count; index ++) {
//         replaceBlank = [replaceBlank stringByReplacingOccurrencesOfString:replaceArray[index] withString:@""];
//    }
    
   NSString * regexStr = @"[^\u4e00-\u9fa5]";
    return [replaceUnderline stringByReplacingOccurrencesOfString:regexStr withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, replaceUnderline.length)];
    
//    return replaceBlank;
}

+ (NSString *)replacePunctuationFor:(NSString *)targetString {
    if (kStringIsEmpty(targetString)) {
        return @"";
    }
    //    [^a-zA-Z0-9\u4e00-\u9fa5]
    //去除标点符号,只保留字母和注音字母
    NSError *error = nil;
    NSString *pattern = @"";
    pattern = @"[^a-z|A-Z|ā|á|ǎ|à|ō|ó|ǒ|ò|ē|é|ě|è|ī|í|ǐ|ì|ū|ú|ǔ|ù|ǖ|ǘ|ǚ|ǜ|ü|ê||ń|ň|]";
    NSRegularExpression *regularExpress = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
    NSString *string = [regularExpress stringByReplacingMatchesInString:targetString options:0 range:NSMakeRange(0, [targetString length]) withTemplate:@" "];
    
    //去除多个连续空格符
    NSError * spaceError = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"\\s{2,}" options:NSRegularExpressionCaseInsensitive error:&spaceError];
    NSArray *arr = [regex matchesInString:string options:NSMatchingReportCompletion range:NSMakeRange(0, string.length)];
    arr = [[arr reverseObjectEnumerator] allObjects];
    for (NSTextCheckingResult *str in arr) {
        string = [string stringByReplacingCharactersInRange:[str range] withString:@" "];
    }
    
    //去除首尾空格及换行符
    NSString * result = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    return result;
}

- (NSString *)addForEverCharWith:(NSString *)string {
    NSString *doneString = @"";
    for (int i = 0; i < self.length; i++) {
        doneString = [doneString stringByAppendingString:[self substringWithRange:NSMakeRange(i, 1)]];
        if (i != self.length - 1) {
            doneString = [NSString stringWithFormat:@"%@%@", doneString,string];
        }
    }
    NSLog(@"%@", doneString);
    return doneString;
}

+ (NSString *)transformToPinyinWithString:(NSString *)str {
    if (kStringIsEmpty(str)) {
        return @"";
    }
    
    NSMutableString *mutableString = [NSMutableString stringWithString:str];
    CFStringTransform((CFMutableStringRef) mutableString, NULL, kCFStringTransformToLatin, false);
    
    NSArray * replaceArray = @[@"",@"　"];
    NSString * result = mutableString.copy;
    for (NSInteger index = 0; index < replaceArray.count; index ++) {
        result = [result stringByReplacingOccurrencesOfString:replaceArray[index] withString:@""];
    }
    
    return result;
}

+ (NSString *)numberChangeToHanzeWith:(NSString *)text {
    
    NSArray * oldArray1 = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"0"];
    NSArray * newArray1 = @[@"一",@"二",@"三",@"四",@"五",@"六",@"七",@"八",@"九",@"零"];
    for (NSInteger index = 0; index < oldArray1.count; index ++) {
        text = [text stringByReplacingOccurrencesOfString:oldArray1[index] withString:newArray1[index]];
    }

    return text;
}

+ (NSString *)numberPinyinChangeToPinyinWith:(NSString *)text {
    NSArray * oldArray1 = @[@"n1",@"n2",@"n3",@"n4",@"ng1",@"ng2",@"ng3",@"ng4",@"r1",@"r2",@"r3",@"r4"];
    NSArray * newArray1 = @[@"1n",@"2n",@"3n",@"4n",@"1ng",@"2ng",@"3ng",@"4ng",@"1r",@"2r",@"3r",@"4r"];
    for (NSInteger index = 0; index < oldArray1.count; index ++) {
        text = [text stringByReplacingOccurrencesOfString:oldArray1[index] withString:newArray1[index]];
    }
    
    NSArray * oldArray2 = @[@"ai1",@"ai2",@"ai3",@"ai4",@"ao1",@"ao2",@"ao3",@"ao4",@"ei1",@"ei2",@"ei3",@"ei4"];
    NSArray * newArray2 = @[@"a1i",@"a2i",@"a3i",@"a4i",@"a1o",@"a2o",@"a3o",@"a4o",@"e1i",@"e2i",@"e3i",@"e4i"];
    for (NSInteger index = 0; index < oldArray2.count; index ++) {
        text = [text stringByReplacingOccurrencesOfString:oldArray2[index] withString:newArray2[index]];
    }
    NSArray * oldArray3 = @[@"a1",@"a2",@"a3",@"a4",@"e1",@"e2",@"e3",@"e4",@"i1",@"i2",@"i3",@"i4",@"o1",@"o2",@"o3",@"o4",@"u1",@"u2",@"u3",@"u4",@"v1",@"v2",@"v3",@"v4"];
    NSArray * newArray3 = @[@"ā",@"á",@"ǎ",@"à",@"ē",@"é",@"ě",@"è",@"ī",@"í",@"ǐ",@"ì",@"ō",@"ó",@"ǒ",@"ò",@"ū",@"ú",@"ǔ",@"ù",@"ǜ",@"ǘ",@"ǚ",@"ǜ"];
    for (NSInteger index = 0; index < oldArray3.count; index ++) {
        text = [text stringByReplacingOccurrencesOfString:oldArray3[index] withString:newArray3[index]];
    }
    
    text = [text stringByReplacingOccurrencesOfString:@"0" withString:@""];
    
    return text;
}

- (BOOL)isChinese:(NSString *)str {
    if (kStringIsEmpty(str)) {
        str = self;
    }
    NSString *match = @"(^[\u4e00-\u9fa5]+$)";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF matches %@", match];
    return [predicate evaluateWithObject:str];
}


/********************************************************************
 *  计算富文本字体高度
 *
 *  lineSpeace 行高
 *  param font              字体
 *  param width            字体所占宽度
 *
 *  @return 富文本高度
 ********************************************************************/
- (CGFloat)HeightParagraphSpeace:(CGFloat)lineSpeace withFont:(UIFont*)font AndWidth:(CGFloat)width {
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    /** 行高 */
    paraStyle.lineSpacing = lineSpeace;
    // NSKernAttributeName字体间距
    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:@1.5f };
    CGSize size = [self boundingRectWithSize:CGSizeMake(width,MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    return size.height;
}


- (NSString *)safeSubstringFromIndex:(NSUInteger)from {
    if (from < self.length) {
        return [self substringFromIndex:from];
    }
    return @"";
}

-(CGSize)sizeWithFont:(UIFont *)font maxW:(CGFloat)maxW{
    NSMutableDictionary *atts = [NSMutableDictionary dictionary];
    atts[NSFontAttributeName] = font;
    CGSize maxSize = CGSizeMake(maxW, MAXFLOAT);
    return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:atts context:nil].size;
}

-(CGSize)sizeWithFont:(UIFont *)font{
    
    return [self sizeWithFont:font maxW:MAXFLOAT];
}


+(BOOL)checkIsChinese:(NSString *)string{
    for (int i = 0; i<string.length; i++) {
        unichar ch = [string characterAtIndex:i];
        if (0x4E00 <= ch  && ch <= 0x9FA5) {
            return YES;
        }
    }
    return NO;
}
@end
