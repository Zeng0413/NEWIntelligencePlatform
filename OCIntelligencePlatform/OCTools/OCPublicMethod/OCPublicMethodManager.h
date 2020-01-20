//
//  OCPublicMethodManager.h
//  OCIntelligencePlatform
//
//  Created by Alan on 2019/8/19.
//  Copyright © 2019 OCZHKJ. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum {
    OCUserPermissionClassroomLook = 10001, /** 教室查看 */
    OCUserPermissionTourClass = 10002, /** 巡课*/
    OCUserPermissionClassroomApply = 10003,  /** 教室申请 */
    OCUserPermissionClassroomApproved = 10004,  /** 教室审批 */
    OCUserPermissionTourClassRecord = 10005, /** 巡课记录 */
    
    OCUserPermissionLive = 20001, /** 直播 */
    OCUserPermissionCourseVideo = 20002, /** 课程 */
    OCUserPermissionCourseBigData = 20003,  /** 课堂大数据 */
    
    OCUserPermissionLooperContent = 30001, /** 轮播内容 */
    OCUserPermissionNotificationNotice = 30002, /** 通知公告*/
    OCUserPermissionLooperNotification = 30003,  /** 滚动通知 */
    OCUserPermissionFullScreenInfo = 30004,  /** 全屏信息 */
    OCUserPermissionIntroduceManger = 30005, /** 介绍管理 */
    
    OCUserPermissionCourseSheetDetail = 40001, /** 课表详情 */
    
    OCUserPermissionUserManager = 50001, /** 用户管理 */
    OCUserPermissionRoleManager = 50002, /** 角色管理 */
    OCUserPermissionAcademyManager = 50003, /** 院系管理 */
    OCUserPermissionTermManager = 50004, /** 学期管理 */
    
    OCUserPermissionYWSystemHone = 80001, /** 系统首页 */
    OCUserPermissionYWMyOrder = 80002, /** 我的工单 */
    OCUserPermissionYWAllOrder = 80003,  /** 所有工单 */
    OCUserPermissionYWOrderRecycle = 80004,  /** 工单回收站 */
    OCUserPermissionYWOrderStatistics = 80005, /** 工单量统计 */
    OCUserPermissionYWGroupLeader = 80006, /** 运维组长 */

} OCUserPermissionType; //用户权限

@interface OCPublicMethodManager : NSObject
/*
 *判断是否是正式环境
 */
+ (BOOL)isProduct;

/*
 *图片压缩
 @param image:图片对象
 @param percent:图片压缩比例 1最大，0最小
 */
+ (UIImage *)reduceImage:(UIImage *)image percent:(float)percent;

/*
 *获取当前显示控制器
 */
+ (UIViewController *)getCurrentVC;

/*
 *判断控制器是否正在显示
 @param viewController:待判断控制器
 */
+ (BOOL)theVCIsShow:(UIViewController *)viewController;

/*
 *返回到指定控制器
 @param vc:目标控制器  fromVC:来源控制器
 */
+ (void)retureToViewcontroller:(UIViewController *)vc fromVC:(UIViewController *)fromVC;


// 设置控件一边圆角
+ (CAShapeLayer *)setupLayerWithView:(UIView *)view withBottomDirection:(UIRectCorner)bottomDirection withTopDirection:(UIRectCorner)topDirection;

// 判断某一日期是否在一日期区间
+(BOOL)date:(NSDate*)date isBetweenDate:(NSDate*)beginDate andDate:(NSDate*)endDate;

// 检查更新
+ (void)checkWersion;

// 检查敏感词
+ (void)checkWordsWithContent:(NSString *)content complete:(void (^)(id result))complete;

// 显示不同字体大小
+ (NSMutableAttributedString *)changeWithString:(NSString *)string withChangeString:(NSString *)changeString;

// 判断数组中数字是否连续
+(BOOL)suibian:(NSArray *)array;

+(BOOL)checkUserPermission:(OCUserPermissionType)permissionType;

/**
 *  将阿拉伯数字转换为中文数字
 */
+(NSString *)translationArabicNum:(NSInteger)arabicNum;


/**
    二维码生成
 */
+(CIImage *)getCodeImage:(NSString *)code;

// 字符串有几行
+(NSArray *)getLinesArrayOfStringInLabel:(NSString *)contentStr withLabSize:(CGFloat)labFloat;
@end

NS_ASSUME_NONNULL_END
