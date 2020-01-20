//
//  OCPublicMethodManager.m
//  OCIntelligencePlatform
//
//  Created by Alan on 2019/8/19.
//  Copyright © 2019 OCZHKJ. All rights reserved.
//

#import "OCPublicMethodManager.h"
#import "OCUserPermissionModel.h"
#import <CoreText/CoreText.h>

@implementation OCPublicMethodManager

+ (UIImage *)reduceImage:(UIImage *)image percent:(float)percent {
    NSData *imageData = UIImageJPEGRepresentation(image, percent);
    UIImage *newImage = [UIImage imageWithData:imageData];
    
    return newImage;
}

+ (UIViewController *)jsd_getRootViewController{
    
    UIWindow* window = [[[UIApplication sharedApplication] delegate] window];
    NSAssert(window, @"The window is empty");
    return window.rootViewController;
}

+ (UIViewController*)topViewControllerWithRootViewController:(UIViewController*)rootViewController {
    
    if ([rootViewController isKindOfClass:[UITabBarController class]]) {
        
        UITabBarController* tabBarController = (UITabBarController*)rootViewController;
        
        return [self topViewControllerWithRootViewController:tabBarController.selectedViewController];
    } else if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        
        UINavigationController* nav = (UINavigationController*)rootViewController;
        
        return [self topViewControllerWithRootViewController:nav.visibleViewController];
    } else if (rootViewController.presentedViewController) {
        
        UIViewController* presentedViewController = rootViewController.presentedViewController;
        return [self topViewControllerWithRootViewController:presentedViewController];
    } else {
        return rootViewController;
    }
}

+ (UIViewController *)getCurrentVC {
    return [self topViewControllerWithRootViewController:[UIApplication sharedApplication].keyWindow.rootViewController];
//    UIViewController* currentViewController = [self jsd_getRootViewController];
//    BOOL runLoopFind = YES;
//    while (runLoopFind) {
//        if (currentViewController.presentedViewController) {
//
//            currentViewController = currentViewController.presentedViewController;
//        } else if ([currentViewController isKindOfClass:[UINavigationController class]]) {
//
//            UINavigationController* navigationController = (UINavigationController* )currentViewController;
//            currentViewController = [navigationController.childViewControllers lastObject];
//
//        } else if ([currentViewController isKindOfClass:[UITabBarController class]]) {
//
//            UITabBarController* tabBarController = (UITabBarController* )currentViewController;
//            currentViewController = tabBarController.selectedViewController;
//        } else {
//
//            NSUInteger childViewControllerCount = currentViewController.childViewControllers.count;
//            if (childViewControllerCount > 0) {
//
//                currentViewController = currentViewController.childViewControllers.lastObject;
//
//                return currentViewController;
//            } else {
//
//                return currentViewController;
//            }
//        }
//
//    }
//    return currentViewController;

}

+ (BOOL)theVCIsShow:(UIViewController *)viewController {
    return (viewController.isViewLoaded && viewController.view.window);
}

+ (void)retureToViewcontroller:(UIViewController *)vc fromVC:(UIViewController *)fromVC {
    for (UIViewController * controller in fromVC.navigationController.viewControllers) {
        if ([controller isKindOfClass:[vc class]]) {
            [fromVC.navigationController popToViewController:controller animated:YES];
        }
    }
}

/**版本**/
+ (BOOL)isProduct {
#ifdef RELEASE
    return YES;
#endif
    return NO;
}

+ (CAShapeLayer *)setupLayerWithView:(UIView *)view withBottomDirection:(UIRectCorner)bottomDirection withTopDirection:(UIRectCorner)topDirection{
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:bottomDirection | topDirection cornerRadii:CGSizeMake(view.height, view.height)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = view.bounds;
    maskLayer.path = maskPath.CGPath;
    return maskLayer;
}

+(BOOL)date:(NSDate*)date isBetweenDate:(NSDate*)beginDate andDate:(NSDate*)endDate{
    if ([date compare:beginDate] == NSOrderedAscending)
        return NO;
    
    if ([date compare:endDate] == NSOrderedDescending)
        return NO;
    
    return YES;
}

+ (void)checkWersion {
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString * app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    app_Version = [app_Version stringByReplacingOccurrencesOfString:@"." withString:@""];
    
    [APPRequest getRequestWithUrl:NSStringFormat(@"%@/%@v1/app/new",kURL,APIUserURL) parameters:@{} success:^(id responseObject) {
        NSString * service_version = NSStringFormat(@"%@",responseObject[@"version"]);
        
        if ([app_Version integerValue] < [service_version integerValue]) {
            NSInteger isMust = [responseObject[@"isMust"] integerValue];
            
            [UIAlertController bme_alertWithTitle:@"有新的版本！" message:NSStringFormat(@"%@",responseObject[@"content"]) sureTitle:@"去更新" cancelTitle:isMust==1?nil:@"取消" sureHandler:^(UIAlertAction * _Nonnull action) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:NSStringFormat(@"%@",responseObject[@"url"])]];
            } cancelHandler:^(UIAlertAction * _Nonnull action) {}];
        }
    } stateError:^(id responseObject) {
        
    } failure:^(NSError *error) {
    } viewController:nil needCache:NO];
}

+ (void)checkWordsWithContent:(NSString *)content complete:(void (^)(id result))complete{
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    [param setValue:content forKey:@"content"];
    NSString *url = [[NSString alloc]initWithFormat:@"%@/%@v1/app/checkSensitiveWords",kURL,APIUserURL];
    [APPRequest postRequestWithUrl:url parameters:param success:^(id responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            complete(responseObject);
        });
    } stateError:^(id responseObject) {
        [MBProgressHUD showError:responseObject[@"msg"]];
    } failure:^(NSError *error) {
    } viewController:nil];
}

+ (NSMutableAttributedString *)changeWithString:(NSString *)string withChangeString:(NSString *)changeString{
    NSMutableAttributedString *atring = [[NSMutableAttributedString alloc] initWithString:string];
    
    NSRange rang = [string rangeOfString:changeString];
    [atring addAttribute:NSFontAttributeName value:kBoldFont(18) range:rang];
    return atring;
}

+(BOOL)suibian:(NSArray  *)array{
    
    NSMutableArray *tempArr = [NSMutableArray array];
    NSMutableArray *tempArr2 = [NSMutableArray array];
    
    for (int i = 1; i < array.count; i ++) {
        if ([array[i] integerValue] > [array[i - 1] integerValue] ) {
            
            NSInteger max = [array[i] integerValue];
            NSInteger min = [array[i - 1] integerValue];
            if (max - min == 1) {
                [tempArr addObject:@"yes"];
            }
            
        }
    }
    for (int i = 1; i < array.count; i ++) {
        if ([array[i] integerValue] < [array[i - 1] integerValue]  ) {
            
            NSInteger max = [array[i - 1] integerValue];
            NSInteger min = [array[i] integerValue];
            if (max - min == 1) {
                [tempArr2 addObject:@"yes"];
            }
            
        }
    }
    if (tempArr.count == array.count-1 || tempArr2.count == array.count-1) {
        return YES;
    }else{
        
        return NO;
    }
    
}

+(BOOL)checkUserPermission:(OCUserPermissionType)permissionType{
    NSArray *permissionArr = SINGLE.userModel.permissionList;
    for (OCUserPermissionModel *model in permissionArr) {
        if ([model.url integerValue] == permissionType) {
            return YES;
        }
    }
    return NO;
}


/**
 *  将阿拉伯数字转换为中文数字
 */
+(NSString *)translationArabicNum:(NSInteger)arabicNum
{
    NSString *arabicNumStr = [NSString stringWithFormat:@"%ld",(long)arabicNum];
    NSArray *arabicNumeralsArray = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"0"];
    NSArray *chineseNumeralsArray = @[@"一",@"二",@"三",@"四",@"五",@"六",@"七",@"八",@"九",@"零"];
    NSArray *digits = @[@"个",@"十",@"百",@"千",@"万",@"十",@"百",@"千",@"亿",@"十",@"百",@"千",@"兆"];
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjects:chineseNumeralsArray forKeys:arabicNumeralsArray];
    
    if (arabicNum < 20 && arabicNum > 9) {
        if (arabicNum == 10) {
            return @"十";
        }else{
            NSString *subStr1 = [arabicNumStr substringWithRange:NSMakeRange(1, 1)];
            NSString *a1 = [dictionary objectForKey:subStr1];
            NSString *chinese1 = [NSString stringWithFormat:@"十%@",a1];
            return chinese1;
        }
    }else{
        NSMutableArray *sums = [NSMutableArray array];
        for (int i = 0; i < arabicNumStr.length; i ++)
        {
            NSString *substr = [arabicNumStr substringWithRange:NSMakeRange(i, 1)];
            NSString *a = [dictionary objectForKey:substr];
            NSString *b = digits[arabicNumStr.length -i-1];
            NSString *sum = [a stringByAppendingString:b];
            if ([a isEqualToString:chineseNumeralsArray[9]])
            {
                if([b isEqualToString:digits[4]] || [b isEqualToString:digits[8]])
                {
                    sum = b;
                    if ([[sums lastObject] isEqualToString:chineseNumeralsArray[9]])
                    {
                        [sums removeLastObject];
                    }
                }else
                {
                    sum = chineseNumeralsArray[9];
                }
                
                if ([[sums lastObject] isEqualToString:sum])
                {
                    continue;
                }
            }
            
            [sums addObject:sum];
        }
        NSString *sumStr = [sums  componentsJoinedByString:@""];
        NSString *chinese = [sumStr substringToIndex:sumStr.length-1];
        return chinese;
    }
}

+(CIImage *)getCodeImage:(NSString *)code{
    /**
     *  2.生成CIFilter(滤镜)对象
     */
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];

    /**
     *  3.恢复滤镜默认设置
     */
    [filter setDefaults];

    /**
     *  4.设置数据(通过滤镜对象的KVC)
     */
    //存放的信息
    NSString *info = @"hahahahhahahaha";
    //把信息转化为NSData
    NSData *infoData = [info dataUsingEncoding:NSUTF8StringEncoding];
    //滤镜对象kvc存值
    [filter setValue:infoData forKeyPath:@"inputMessage"];

    /**
     *  5.生成二维码
     */
    CIImage *outImage = [filter outputImage];
    return outImage;
}

+(NSArray *)getLinesArrayOfStringInLabel:(NSString *)contentStr withLabSize:(CGFloat)labFloat{
    UILabel *label = [UILabel labelWithText:contentStr font:labFloat textColor:TEXT_COLOR_BLACK frame:CGRectZero];
    label.size = [contentStr sizeWithFont:kFont(labFloat) maxW:kViewW - 50*FITWIDTH];
    
    NSString *text = [label text];
    UIFont *font = [label font];
    CGRect rect = [label frame];

    CTFontRef myFont = CTFontCreateWithName(( CFStringRef)([font fontName]), [font pointSize], NULL);
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:text];
    [attStr addAttribute:(NSString *)kCTFontAttributeName value:(__bridge  id)myFont range:NSMakeRange(0, attStr.length)];
    CFRelease(myFont);
    CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString(( CFAttributedStringRef)attStr);
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, CGRectMake(0,0,rect.size.width,100000));
    CTFrameRef frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, 0), path, NULL);
    NSArray *lines = ( NSArray *)CTFrameGetLines(frame);
    NSMutableArray *linesArray = [[NSMutableArray alloc]init];
    for (id line in lines) {
        CTLineRef lineRef = (__bridge  CTLineRef )line;
        CFRange lineRange = CTLineGetStringRange(lineRef);
        NSRange range = NSMakeRange(lineRange.location, lineRange.length);
        NSString *lineString = [text substringWithRange:range];
        CFAttributedStringSetAttribute((CFMutableAttributedStringRef)attStr, lineRange, kCTKernAttributeName, (CFTypeRef)([NSNumber numberWithFloat:0.0]));
        CFAttributedStringSetAttribute((CFMutableAttributedStringRef)attStr, lineRange, kCTKernAttributeName, (CFTypeRef)([NSNumber numberWithInt:0.0]));
        //NSLog(@"''''''''''''''''''%@",lineString);
        [linesArray addObject:lineString];
    }

    CGPathRelease(path);
    CFRelease( frame );
    CFRelease(frameSetter);
    return (NSArray *)linesArray;
}
@end
