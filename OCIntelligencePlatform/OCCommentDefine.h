//
//  OCCommentDefine.h
//  OCIntelligencePlatform
//
//  Created by Alan on 2019/8/13.
//  Copyright © 2019 OCZHKJ. All rights reserved.
//

#ifndef OCCommentDefine_h
#define OCCommentDefine_h


/********************************************** 接口 *********************************************/
#ifdef DEBUG
    #define kEnv @"DEV_"
//    #define kURL @"http://47.103.149.37:6123"
    #define kURL @"http://www.oczhkj.com:6123"
//    #define kURL @"http://192.168.10.157:6123"
//    #define kURL @"http://192.168.10.127:6123"
    #define kInsideURL @"KInsideURL"
    #define kBaseUrl @"www.debug.com"
    #define kChatUrl @"47.103.149.37"
    #define kChatPort 6129

#elif TEST
    #define kEnv @"TEST_"
    #define kURL @"http://47.100.1.232:6123"
    #define kInsideURL @"KInsideURL"
    #define kBaseUrl @"www.test.com"
    #define kChatUrl @"47.100.1.232"
    #define kChatPort 6129

#else
    #define kEnv @""
    #define kURL @"http://www.oczhkj.com:6123"
    #define kInsideURL @"KInsideURL"
    #define kBaseUrl @"www.OCIntelligencePlatform.com"
    #define kChatUrl @"www.oczhkj.com"
    #define kChatPort 6129

#endif


/********************************************* 宽高大小 *********************************************/
#define kViewW [[UIScreen mainScreen] bounds].size.width
#define kViewH [[UIScreen mainScreen] bounds].size.height
#define kDockH (kViewH >= 812 ? (83) : 60)
#define kNavH ([[UIApplication sharedApplication] statusBarFrame].size.height + 44)
#define kBottomH (kViewH >= 812 ? (24) : 0)
#define kEdgeW20 20
#define kEdgeW15 15
#define kEdgeW10 10
#define kStatusH [[UIApplication sharedApplication] statusBarFrame].size.height

// 日历头的高度
#define kCalendarHeaderViewHeight 113*FITWIDTH + kStatusH

#define FITWIDTH [UIScreen mainScreen].bounds.size.width/375
#define kServiceStr @"serviceStr"
// CGRect
#define Rect(x, y, w, h) CGRectMake((x), (y), (w), (h))
// CGRectGetMaxX
#define MaxX(view) CGRectGetMaxX(view.frame)
// CGRectGetMaxY
#define MaxY(view) CGRectGetMaxY(view.frame)

/********************************************* 字体大小 *********************************************/
#define kFont(size) [UIFont systemFontOfSize:size]
#define kBoldFont(size) [UIFont boldSystemFontOfSize:size]
/********************************************* 颜色 *********************************************/
#define RGBA(r,g,b,a)   [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

#define WHITE [UIColor whiteColor]
#define CLEAR [UIColor clearColor]

//主色
#define kAPPCOLOR RGBA(27, 122, 255, 1)
//主绿色
#define kGreenCOLOR RGBA(238, 247, 247, 1)

//背景色
#define kBACKCOLOR RGBA(241, 245, 249, 1)
//文字主色（黑）
#define TEXT_COLOR_BLACK RGBA(51, 51, 51, 1)
//文字主色（灰）
#define TEXT_COLOR_GRAY RGBA(102, 102, 102, 1)
//一次性文字提示色（浅灰）
#define TEXT_COLOR_LIGHT_GRAY RGBA(208, 208, 208, 1)
//随机颜色
#define arc4randomColor @[RGBA(134, 199, 71, 1),RGBA(69, 197, 202, 1),RGBA(69, 93, 202, 1),RGBA(255, 141, 148, 1),RGBA(255, 119, 27, 1)][arc4random()%5]

/********************************************* 弱引用 *********************************************/
#define Weak __weak typeof(self) wself = self;
#define WeakSelf(type) __weak typeof(type) weak##type = type
#define StrongSelf(type) __strong typeof(type) strong##type = type

/********************************************* 全局单例 *********************************************/
//用户个人信息存储
#define kUserDefaults [NSUserDefaults standardUserDefaults]
//通知中心
#define kNotificationCenter [NSNotificationCenter defaultCenter]
//本地单例
#define SINGLE [OCSingletonManager shared]

/********************************************* 方法封装定义 *********************************************/
//全局键盘隐藏
#define kHideKeyBoard [[UIApplication sharedApplication].keyWindow endEditing:YES]

//判断字符串是否为空
#define kStringIsEmpty(str) ([str isKindOfClass:[NSNull class]] || str == nil || [str length] < 1  || [str isEqualToString:@"(null)"] || [str isEqualToString:@"<null>"] ? YES : NO )

//转字符串（可多个）
#define NSStringFormat(format,...) [NSString stringWithFormat:format,##__VA_ARGS__]

//获取本地图片资源
#define GetImage(imageName) [UIImage imageNamed:[NSString stringWithFormat:@"%@",imageName]]

#define PermissionAlertString @"您还没有这个权限"

#define kNetWorkAlertStr @"isNetWoking"
//结束刷新
#define SLEndRefreshing(__ScrollView)\
if ([__ScrollView.mj_footer isRefreshing]) {\
[__ScrollView.mj_footer endRefreshing];\
}\
if ([__ScrollView.mj_header isRefreshing]) {\
[__ScrollView.mj_header endRefreshing];\
}
#endif /* OCCommentDefine_h */
