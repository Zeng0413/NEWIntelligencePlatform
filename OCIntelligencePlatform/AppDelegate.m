//
//  AppDelegate.m
//  OCIntelligencePlatform
//
//  Created by Alan on 2019/8/13.
//  Copyright © 2019 OCZHKJ. All rights reserved.
//

#import "AppDelegate.h"
#import "loginViewController.h"
#import <IQKeyboardManager/IQKeyboardManager.h>
#import "OCMessagePushView.h"
#import "OCChooseTypeQuestionViewController.h"
#import "OCSolutionTypeQuestionViewController.h"
#import "OCRootViewControllerViewController.h"
#import "OCPersonInfoViewController.h"
#import "OCSubObjQuestionModel.h"
#import "OCInteractionAnswerQuestionViewController.h"
// 引入 JPush 功能所需头文件
#import "JPUSHService.h"
// iOS10 注册 APNs 所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#import "AFNetworkReachabilityManager.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "AFHTTPSessionManager.h"
#import "Reachability.h"



#endif

@interface AppDelegate ()<JPUSHRegisterDelegate>

@property (strong, nonatomic) NSDictionary *lastDict;

@property (nonatomic) Reachability *hostReachability;
@property (nonatomic) Reachability *internetReachability;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [kUserDefaults setValue:@"1" forKey:kNetWorkAlertStr];

    
    NSDictionary *userData = [NSDictionary bg_valueForKey:@"userInfoData"];
    
    SINGLE.userModel = [OCUserModel objectWithKeyValues:userData];
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    
    
    // 网络监测
    [self networkMonitoring];
    
    [self userStateJudge];
    
    if (userData.allKeys.count!=0) {
        [[SocketRocketUtility instance] SRSocketOpen];
    }
    
    [kNotificationCenter addObserver:self selector:@selector(receiveMessage:) name:@"socktReceiveMessageNotification" object:nil];
    
    /**
        添加初始化 APNs 代码
     */
    //Required
    //notice: 3.0.0 及以后版本注册可以这样写，也可以继续用之前的注册方式
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    if (@available(iOS 12.0, *)) {
        entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound|JPAuthorizationOptionProvidesAppNotificationSettings;
    } else {
        entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    }
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        // 可以添加自定义 categories
        // NSSet<UNNotificationCategory *> *categories for iOS10 or later
        // NSSet<UIUserNotificationCategory *> *categories for iOS8 and iOS9
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    
    /**
        添加初始化 JPush 代码
     */
    
    [JPUSHService setupWithOption:launchOptions appKey:@"3776fc814696ad6c8b6ccd16" channel:@"App Store" apsForProduction:false];
    
    
    return YES;
}

-(void)userStateJudge{
    NSString * userId = NSStringFormat(@"%@",[kUserDefaults objectForKey:@"userId"]);
    NSString * token = NSStringFormat(@"%@",[kUserDefaults objectForKey:@"token"]);
    
    NSDictionary *userData = [NSDictionary bg_valueForKey:@"userInfoData"];
    SINGLE.userModel = [OCUserModel objectWithKeyValues:userData];
    
    if (!kStringIsEmpty(userId) && !kStringIsEmpty(token)) {
        [loginViewController checkToken:^(BOOL success) {
            if (success) {
                if ([SINGLE.userModel.isNewUser integerValue] == 1) {
                    [self makeRootController:[loginViewController new]];
                }else{
                    [self makeRootController:[OCRootViewControllerViewController new]];
                }
            }else{
                [self makeRootController:[loginViewController new]];
            }
        }];
        
        
    }else{
        [self makeRootController:[loginViewController new]];
    }
}

-(void)receiveMessage:(NSNotification *)notification{
    
    NSDictionary *messageDic =  notification.userInfo;
    if ([messageDic[@"type"] integerValue] == 8) {
        return;
    }
    if (![messageDic isEqual:self.lastDict]) {
        dispatch_sync(dispatch_get_main_queue(), ^{
            UIViewController *current = [OCPublicMethodManager getCurrentVC];
            if ([current isKindOfClass:[OCInteractionAnswerQuestionViewController class]] || [current isKindOfClass:[loginViewController class]] || [current isKindOfClass:[OCPersonInfoViewController class]]) {
                return;
            }
            
            NSInteger questionType = [messageDic[@"question_type"] integerValue];
            
            
            if ([messageDic[@"type"] integerValue] != 5) {
                
                if ([messageDic[@"type"] integerValue] == 3) {
                    NSDictionary *contentDic = [NSString stringConvertToDic:messageDic[@"content"]];
                    
                    NSString *titleStr = contentDic[@"title"];
                    NSString *firstStr = [titleStr substringToIndex:1];
                    
                    [OCMessagePushView showMessagePushViewWithTitle:firstStr messageText:titleStr viewClick:^{
                        OCInteractionAnswerQuestionViewController *vc = [[OCInteractionAnswerQuestionViewController alloc] init];
                        vc.classID = [contentDic[@"clazz_id"] integerValue];
                        vc.questionID = [messageDic[@"question_id"] integerValue];
                        if (questionType == 1 || questionType == 2 || questionType == 3) {
                            if (questionType == 2) {
                                vc.isMoreChoose = YES;
                            }
                            vc.isObj = YES;
                        }else{
                            vc.isObj = NO;
                        }
                        [current.navigationController pushViewController:vc animated:YES];
                        
                        
                    }];
                }
            }
        });
    }
    if ([messageDic[@"type"] integerValue] != 5) {
        self.lastDict = messageDic;
    }else{
        self.lastDict = nil;
    }
    
    
}


- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [JPUSHService registerDeviceToken:deviceToken];
}

-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

-(BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options{
    if (url) {
        NSString *fileNameStr = [url lastPathComponent];
//        NSString *Doc = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/localFile"] stringByAppendingPathComponent:fileNameStr];
        Weak;
        [UIAlertController bme_alertWithTitle:@"提示" message:NSStringFormat(@"是否上传%@?",fileNameStr) sureTitle:@"确定" cancelTitle:@"取消" sureHandler:^(UIAlertAction * _Nonnull action) {
            [wself uploadFileWithFileName:fileNameStr urlStr:url];
        } cancelHandler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        
    }
    return YES;
}

-(void)uploadFileWithFileName:(NSString *)fileNameStr urlStr:(NSURL *)urlStr{
    UIViewController *current = [OCPublicMethodManager getCurrentVC];
    [MBProgressHUD showMessage:@""];
    [APPRequest postFileRequest:NSStringFormat(@"%@/%@v1/cloudDisk/add/file/0",kURL,APIUserURL) fileName:@[fileNameStr] parameter:@{} postFileUrlArray:@[urlStr] progress:^(NSString *count) {
    
    } success:^(id responseObject) {
        [MBProgressHUD showSuccess:@"上传成功，请在个人空间查看"];
    } stateError:^(id responseObject) {
    } failure:^(NSError *error) {
    } controller:current];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {

    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    [[SocketRocketUtility instance]SRSocketClose];
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    // Required, iOS 7 Support
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    // Required, For systems with less than or equal to iOS 6
    [JPUSHService handleRemoteNotification:userInfo];
}

- (void)makeRootController:(UIViewController *)rootTab {
    TSNavigationController *tabNav = [[TSNavigationController alloc] initWithRootViewController:rootTab];
    self.window.rootViewController = tabNav;
}



#pragma mark - 网络监控
-(void)networkMonitoring{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    // 设置网络检测的站点
    NSString *remoteHostName = @"www.baidu.com";
    
    self.hostReachability = [Reachability reachabilityWithHostName:remoteHostName];
    [self.hostReachability startNotifier];
    [self updateInterfaceWithReachability:self.hostReachability];
    
    self.internetReachability = [Reachability reachabilityForInternetConnection];
    [self.internetReachability startNotifier];
    [self updateInterfaceWithReachability:self.internetReachability];
}

- (void) reachabilityChanged:(NSNotification *)note
{
    Reachability* curReach = [note object];
    [self updateInterfaceWithReachability:curReach];
}

- (void)updateInterfaceWithReachability:(Reachability *)reachability
{
    
    NetworkStatus netStatus = [reachability currentReachabilityStatus];
    switch (netStatus) {
        case 0:
            NSLog(@"NotReachable----无网络");
            [kUserDefaults setValue:@"0" forKey:kNetWorkAlertStr];

            break;
            
        case 1:
            [kUserDefaults setValue:@"1" forKey:kNetWorkAlertStr];

            NSLog(@"ReachableViaWiFi----WIFI");
            break;
            
        case 2:
            [kUserDefaults setValue:@"1" forKey:kNetWorkAlertStr];

            NSLog(@"ReachableViaWWAN----蜂窝网络");
            break;
            
        default:
            break;
    }
    
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];
}

#pragma mark- JPUSHRegisterDelegate
// iOS 12 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center openSettingsForNotification:(UNNotification *)notification{
    if (@available(iOS 10.0, *)) {
        if (notification && [notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
            //从通知界面直接进入应用
        }else{
            //从通知设置界面进入应用
        }
    } else {
        if (notification) {
            //从通知界面直接进入应用
        }else{
            //从通知设置界面进入应用
        }
        
    }
}

- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger options))completionHandler {
//    NSDictionary * userInfo = notification.request.content.userInfo;
    
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
//    if (@available(iOS 10.0, *)) {
        if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
            [JPUSHService handleRemoteNotification:userInfo];
        } completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以设置
}

- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)(void))completionHandler {
    
    [JPUSHService setBadge:10];

    
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    UNNotificationRequest *request = response.notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的消息内容
    
    NSNumber *badge = content.badge;  // 推送消息的角标
    NSString *body = content.body;    // 推送消息体
    UNNotificationSound *sound = content.sound;  // 推送消息的声音
    NSString *subtitle = content.subtitle;  // 推送消息的副标题
    NSString *title = content.title;  // 推送消息的标题
    
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
//        NSLog(@"iOS10 收到远程通知:%@", [self logDic:userInfo]);
//        [rootViewController addNotificationCount];
        
    }
    else {
        // 判断为本地通知
        NSLog(@"iOS10 收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo);
    }
    
    completionHandler();  // 系统要求执行这个方法
}

@end
