//
//  APPRequest.h
//  HSHShangcheng
//
//  Created by Alan on 2017/5/29.
//  Copyright © 2017年 luobao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APPRequest : NSObject

+ (void)postRequestWithUrl:(NSString *)url
                parameters:(NSDictionary *)parameters
                   success:(void (^)(id responseObject))success
                stateError:(void (^)(id responseObject))stateError
                   failure:(void (^)(NSError *error))failure
            viewController:(UIViewController *)controller;

+ (void)getRequestWithUrl:(NSString *)url
               parameters:(NSDictionary *)parameters
                  success:(void (^)(id responseObject))success
               stateError:(void (^)(id responseObject))stateError
                  failure:(void (^)(NSError *error))failure
           viewController:(UIViewController *)controller
                needCache:(BOOL)needCache;

+ (void)deleteRequestWithURLStr:(NSString *)urlStr
                       paramDic:(NSDictionary *)paramDic
                        success:(void(^)(id responseObject))success
                          error:(void(^)(id responseObject))error
                        failure:(void(^)(NSError * error))failure
                     controller:(UIViewController *)controller;

+ (void)putRequestWithUrl:(NSString *)urlStr
                 parameters:(NSDictionary *)parameters
                  success:(void(^)(id responseObject))success
                    stateError:(void(^)(id responseObject))stateError
                  failure:(void(^)(NSError * error))failure
               viewController:(UIViewController *)controller;


//上传图片
+ (void)postImageRequest:(NSString *)url
                fileName:(NSString *)fileName
               parameter:(NSDictionary *)parameter
          postImageArray:(NSArray *)imageArray
                 success:(void (^)(id responseObject))success
              stateError:(void (^)(id responseObject))stateError
                 failure:(void (^)(NSError *error))failure
              controller:(UIViewController *)controller;

//上传文件
+ (void)postFileRequest:(NSString *)url
               fileName:(NSArray *)fileNameArray
              parameter:(NSDictionary *)parameter
       postFileUrlArray:(NSArray *)urlArray
               progress:(void (^)(NSString * count))progress
                success:(void (^)(id responseObject))success
             stateError:(void (^)(id responseObject))stateError
                failure:(void (^)(NSError *error))failure
             controller:(UIViewController *)controller ;

/**
 下载文件
 
 @param filePath 文件路径
 @param fileName 文件名
 @param needUrlStr 地址
 */
+(void)downloadFileWithFileName:(NSString *)fileName filePath:(NSString *)filePath requestUrlStr:(NSString *)needUrlStr success:(void (^)(id responseObject))success;

//取消所有网络请求
+ (void)cancelAllRequest;

//根据URL取消网络请求
+ (void)cancelRequestWithURL:(NSString *)URL;

//当前网络状态
+ (void)currentNet:(void (^)(NSInteger type))success;

//
+ (NSString *)setUrlHeaderWith:(NSString *)url;

+ (NSString *)mimeTypeForFileAtPath:(NSString *)path;

@end
