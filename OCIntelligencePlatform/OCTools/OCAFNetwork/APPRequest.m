//
//  APPRequest.m
//  HSHShangcheng
//
//  Created by Alan on 2017/5/29.
//  Copyright © 2017年 luobao. All rights reserved.
//

#import "APPRequest.h"
#import "AFNetworking.h"
//#import "BGFMDB.h"

//#import "AFNetworkActivityIndicatorManager.h"

#define successCode 1000
#define tokenErrorCode 1014

NSMutableArray *_allSessionTask;
AFHTTPSessionManager *_sessionManager;

@implementation APPRequest

+ (void)initialize {
    _sessionManager = [AFHTTPSessionManager manager];
    _sessionManager.requestSerializer.timeoutInterval = 20.f;
    _sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
    _sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", @"text/json", @"text/plain", @"text/javascript", @"text/xml", @"image/*", nil];

    NSURLCache *urlCache = [[NSURLCache alloc] initWithMemoryCapacity:4 * 1024 * 1024 diskCapacity:20 * 1024 * 1024 diskPath:nil];
    [NSURLCache setSharedURLCache:urlCache];
    [_sessionManager.requestSerializer setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];

//    AFSecurityPolicy *securityPolicy =  [AFSecurityPolicy defaultPolicy];
//    securityPolicy.allowInvalidCertificates = YES;
//    securityPolicy.validatesDomainName = NO;
//    _sessionManager.securityPolicy = securityPolicy;
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

+ (NSMutableArray *)allSessionTask {
    if (!_allSessionTask) {
        _allSessionTask = [[NSMutableArray alloc] init];
    }
    return _allSessionTask;
}

//取消所有网络请求
+ (void)cancelAllRequest {
    //锁操作
    @synchronized (self) {
        [[self allSessionTask] enumerateObjectsUsingBlock:^(NSURLSessionTask *_Nonnull task, NSUInteger idx, BOOL *_Nonnull stop) {
            [task cancel];
        }];
        [[self allSessionTask] removeAllObjects];
    }
}

+ (void)currentNet:(void (^)(NSInteger type))success {
    __weak AFNetworkReachabilityManager *mgr = [AFNetworkReachabilityManager sharedManager];
    [mgr startMonitoring];
    [mgr setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                success(0);
                break;
            case AFNetworkReachabilityStatusNotReachable:
                success(1);
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                success(2);
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                success(3);
                break;
            default:
                break;
        }
        [mgr stopMonitoring];
    }];
}

//根据URL取消网络请求
+ (void)cancelRequestWithURL:(NSString *)URL {
    if (!URL) {return;}
    @synchronized (self) {
        [[self allSessionTask] enumerateObjectsUsingBlock:^(NSURLSessionTask *_Nonnull task, NSUInteger idx, BOOL *_Nonnull stop) {
            if ([task.currentRequest.URL.absoluteString hasPrefix:URL]) {
                [task cancel];
                [[self allSessionTask] removeObject:task];
                *stop = YES;
            }
        }];
    }
}

+ (void)postRequestWithUrl:(NSString *)url
                parameters:(NSDictionary *)parameters
                   success:(void (^)(id responseObject))success
                stateError:(void (^)(id responseObject))stateError
                   failure:(void (^)(NSError *error))failure
            viewController:(UIViewController *)controller {
    
    NSString *requestUrl = url;
    NSLog(@"***********network\n\n%@\n***************",requestUrl);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^() {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        });
        
        AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
        NSString *aToken = [kUserDefaults objectForKey:@"token"];
        NSString *userId = [kUserDefaults objectForKey:@"userId"];
        if (kStringIsEmpty(aToken)) {
            aToken = @"";
        }
        if (kStringIsEmpty(userId)) {
            userId = @"";
        }
        
        
        //设置请求头
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        
        [manager.requestSerializer requestWithMethod:@"POST" URLString:requestUrl parameters:parameters error:nil];
        [self congfigRequestSerializer:manager.requestSerializer];
        
        NSInteger contentType = [parameters[@"contentType"] integerValue];
        if (contentType == 1) {
            [manager.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        }
        
        //设置响应头
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", @"text/json", @"text/plain", @"text/javascript", @"text/xml", @"image/*", nil];
        
        NSURLCache *urlCache = [[NSURLCache alloc] initWithMemoryCapacity:4 * 1024 * 1024 diskCapacity:20 * 1024 * 1024 diskPath:nil];
        [NSURLCache setSharedURLCache:urlCache];
        [manager.requestSerializer setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
        
        NSURLSessionTask *sessionTask = [manager POST:requestUrl parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//            controller.navigationController.view.userInteractionEnabled = YES;
//            controller.view.userInteractionEnabled = YES;
            
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            
            [[self allSessionTask] removeObject:task];
            
            NSInteger code = [responseObject[@"code"] integerValue];
            
            id resultDic = responseObject[@"result"];
            
            if (code == tokenErrorCode) {
                [MBProgressHUD hideHUD];
//                if (SINGLE.userRole == OCUserRoleTypeVisitor) {
//                    [OCPublicMethodManager visitorGlobalQuitLogin];
//                }else {
//                    [OCPublicMethodManager globalQuitLogin];
//                }
                failure ? failure(nil) : nil;
                return;
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUD];
                if (code == successCode && ![resultDic isEqual:[NSNull null]]) {
                    success ? success(resultDic) : nil;
                } else {
                    [MBProgressHUD showError:responseObject[@"msg"]];
                    WGHLog(responseObject);
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        stateError ? stateError(responseObject) : nil;
                    });
                }
            });
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//            controller.navigationController.view.userInteractionEnabled = YES;
//            controller.view.userInteractionEnabled = YES;
            
            WGHLog2(@"❌请求失败--%@❌", error.localizedDescription);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUD];
            });
            [self requestErrorHandle:error task:task];
            
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            [[self allSessionTask] removeObject:task];
            failure ? failure(error) : nil;
        }];
        sessionTask ? [[self allSessionTask] addObject:sessionTask] : nil;
    });
}

+ (void)getRequestWithUrl:(NSString *)url
               parameters:(NSDictionary *)parameters
                  success:(void (^)(id responseObject))success
               stateError:(void (^)(id responseObject))stateError
                  failure:(void (^)(NSError *error))failure
           viewController:(UIViewController *)controller
                needCache:(BOOL)needCache {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^() {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        });
        NSString *requestUrl = url;
        NSLog(@"***********network\n\n%@\n***************",requestUrl);
        
        AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
        //设置请求头
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        [manager.requestSerializer requestWithMethod:@"GET" URLString:requestUrl parameters:parameters error:nil];
        [self congfigRequestSerializer:manager.requestSerializer];
        
        //设置响应头
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", @"text/json", @"text/plain", @"text/javascript", @"text/xml", @"image/*", nil];
        
        // Read eTag
        NSString *eTag = [[NSUserDefaults standardUserDefaults] objectForKey:url];
        // 发送 etag
        if (eTag.length > 0 && needCache) {
            [manager.requestSerializer setValue:eTag forHTTPHeaderField:@"If-None-Match"];
        }
        
        NSURLSessionTask *sessionTask = [manager GET:requestUrl parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if (needCache) {
                [APPRequest storeEtagWithKey:url andSessionTass:task];
//                [NSDictionary bg_setValue:responseObject forKey:url];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUD];
            });
            controller.navigationController.view.userInteractionEnabled = YES;
            controller.view.userInteractionEnabled = YES;
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            
            [[self allSessionTask] removeObject:task];
            
            NSInteger code = [responseObject[@"code"] integerValue];
            if (code == tokenErrorCode) {
                [MBProgressHUD hideHUD];
//                if (SINGLE.userRole == OCUserRoleTypeVisitor) {
//                    [OCPublicMethodManager visitorGlobalQuitLogin];
//                }else {
//                    [OCPublicMethodManager globalQuitLogin];
//                }
                failure ? failure(nil) : nil;
                return;
            }
            id resultDic;
            resultDic = responseObject[@"result"];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (code == successCode && ![resultDic isEqual:[NSNull null]]) {
                    if (success) {
                        success(resultDic);
                    }
                } else {
//                    [MBProgressHUD showText:responseObject[@"msg"]];
                    WGHLog(responseObject);
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        stateError(responseObject);
                    });
                }
            });
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            controller.navigationController.view.userInteractionEnabled = YES;
            controller.view.userInteractionEnabled = YES;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUD];
                NSInteger statusCode = [(NSHTTPURLResponse *)task.response statusCode];
                NSLog(@"%ld",statusCode);
                if ([(NSHTTPURLResponse *)task.response statusCode] == 304) {
//                    id responseObject = [NSDictionary bg_valueForKey:url];
//                    NSInteger code = [responseObject[@"code"] integerValue];
//                    if (code == tokenErrorCode) {
//                        [MBProgressHUD hideHUD];
////                        if (SINGLE.userRole == OCUserRoleTypeVisitor) {
////                            [OCPublicMethodManager visitorGlobalQuitLogin];
////                        }else {
////                            [OCPublicMethodManager globalQuitLogin];
////                        }
//                        failure ? failure(nil) : nil;
//                        return;
//                    }
//                    id resultDic;
//                    resultDic = responseObject[@"result"];
//
//                    if (code == successCode && ![resultDic isEqual:[NSNull null]]) {
//                        success ? success(resultDic) : nil;
//                    } else {
//                        WGHLog(responseObject);
//                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                            stateError(responseObject);
//                        });
//                    }
                }else {
                    NSLog(@"%@,❌请求失败--%@❌",requestUrl, error.localizedDescription);
                    failure ? failure(error) : nil;
                    [self requestErrorHandle:error task:task];
                }
            });
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            [[self allSessionTask] removeObject:task];
        }];
        sessionTask ? [[self allSessionTask] addObject:sessionTask] : nil;
    });
}

+ (void)putRequestWithUrl:(NSString *)urlStr
               parameters:(NSDictionary *)parameters
                  success:(void (^)(id responseObject))success
               stateError:(void (^)(id responseObject))stateError
                  failure:(void (^)(NSError *error))failure
           viewController:(UIViewController *)controller {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^() {
        NSString *requestUrl = urlStr;
        
        _sessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
        [_sessionManager.requestSerializer requestWithMethod:@"PUT" URLString:requestUrl parameters:parameters error:nil];
        [self congfigRequestSerializer:_sessionManager.requestSerializer];

        NSURLSessionTask *sessionTask = [_sessionManager PUT:requestUrl parameters:parameters success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            controller.view.userInteractionEnabled = YES;

            NSInteger code = [responseObject[@"code"] integerValue];
            
            if (code == tokenErrorCode) {
                [MBProgressHUD hideHUD];
                WGHLog(requestUrl);
//                if (SINGLE.userRole == OCUserRoleTypeVisitor) {
//                    [OCPublicMethodManager visitorGlobalQuitLogin];
//                }else {
//                    [OCPublicMethodManager globalQuitLogin];
//                }
                failure ? failure(nil) : nil;
                return;
            }else {
                id result = responseObject[@"result"];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD hideHUD];
                    if (code == successCode && ![result isEqual:[NSNull null]]) {
                        success(result);
                    } else {
//                        [MBProgressHUD showText:responseObject[@"msg"]];
                        WGHLog(responseObject);
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            stateError(responseObject);
                        });
                    }
                });
            }
            [[self allSessionTask] removeObject:task];
        } failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
            controller.navigationController.view.userInteractionEnabled = YES;
            controller.view.userInteractionEnabled = YES;
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUD];
            });
            WGHLog2(@"❌请求失败--%@❌", error.localizedDescription);
            NSInteger errorCode = [(NSHTTPURLResponse *)task.response statusCode];
            if (errorCode == 401) {
//                [OCPublicMethodManager visitorGlobalQuitLogin];
                failure ? failure(error) : nil;
                return;
            }

            [self requestErrorHandle:error task:task];
            
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            [[self allSessionTask] removeObject:task];
            failure ? failure(error) : nil;
        }];
        sessionTask ? [[self allSessionTask] addObject:sessionTask] : nil;
    });
}

+ (void)deleteRequestWithURLStr:(NSString *)urlStr
                       paramDic:(NSDictionary *)paramDic
                        success:(void (^)(id responseObject))success
                          error:(void (^)(id responseObject))error
                        failure:(void (^)(NSError *error))failure
                     controller:(UIViewController *)controller {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^() {
        NSString *requestUrl = urlStr;
        
        _sessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
        [self congfigRequestSerializer:_sessionManager.requestSerializer];
        NSError * wer = nil;
        [_sessionManager.requestSerializer requestWithMethod:@"DELETE" URLString:requestUrl parameters:paramDic error:&wer];
        _sessionManager.requestSerializer.HTTPMethodsEncodingParametersInURI = [NSSet setWithObjects:@"GET", @"HEAD", nil];
        
        NSLog(@"***********network\n\n%@\n***************",requestUrl);

        NSURLSessionTask *sessionTask = [_sessionManager DELETE:requestUrl parameters:paramDic success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            controller.view.userInteractionEnabled = YES;
            [MBProgressHUD hideHUD];
            NSInteger code = [responseObject[@"code"] integerValue];
            if (code == tokenErrorCode) {
//                if (SINGLE.userRole == OCUserRoleTypeVisitor) {
//                    [OCPublicMethodManager visitorGlobalQuitLogin];
//                }else {
//                    [OCPublicMethodManager globalQuitLogin];
//                }
                failure ? failure(nil) : nil;
                return;
            }else {
                id result = responseObject[@"result"];
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (code == successCode && ![result isEqual:[NSNull null]]) {
                        success(result);
                    } else {
                        WGHLog(responseObject);
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            error(responseObject);
                        });
                    }
                });
            }
            [[self allSessionTask] removeObject:task];
        } failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
            controller.navigationController.view.userInteractionEnabled = YES;
            controller.view.userInteractionEnabled = YES;

            WGHLog2(@"❌请求失败--%@❌", error.localizedDescription);
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUD];
            });

            [self requestErrorHandle:error task:task];

            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            [[self allSessionTask] removeObject:task];
            failure ? failure(error) : nil;
        }];
        sessionTask ? [[self allSessionTask] addObject:sessionTask] : nil;
    });
}



//上传图片
+ (void)postImageRequest:(NSString *)url
                fileName:(NSString *)fileName
               parameter:(NSDictionary *)parameter
          postImageArray:(NSArray *)imageArray
                 success:(void (^)(id responseObject))success
              stateError:(void (^)(id responseObject))stateError
                 failure:(void (^)(NSError *error))failure
              controller:(UIViewController *)controller {
    
    NSString *requestUrl = url;

    _sessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
    [_sessionManager.requestSerializer requestWithMethod:@"POST" URLString:requestUrl parameters:parameter error:nil];
    [self congfigRequestSerializer:_sessionManager.requestSerializer];
    
    NSURLSessionTask *sessionTask = [_sessionManager POST:requestUrl parameters:parameter constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        for (int i = 0; i < imageArray.count; i++) {
            [formData appendPartWithFileData:UIImagePNGRepresentation(imageArray[i]) name:@"file" fileName:fileName mimeType:@"image/jpeg"];
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [[self allSessionTask] removeObject:task];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUD];
        });
        
        NSInteger code = [responseObject[@"code"] integerValue];
        if (code == tokenErrorCode) {
            [MBProgressHUD hideHUD];
//            if (SINGLE.userRole == OCUserRoleTypeVisitor) {
//                [OCPublicMethodManager visitorGlobalQuitLogin];
//            }else {
//                WGHLog(requestUrl);
//                [OCPublicMethodManager globalQuitLogin];
//            }
            failure ? failure(nil) : nil;
            return;
        }
        
        id resultDic = responseObject[@"result"];
        if (code == successCode && ![resultDic isEqual:[NSNull null]]) {
            if ([resultDic isKindOfClass:[NSDictionary class]]) {
                NSMutableDictionary * muDic = [NSMutableDictionary dictionaryWithDictionary:resultDic];
                muDic[@"msg"] = NSStringFormat(@"%@",responseObject[@"msg"]);
                resultDic = muDic.copy;
            }
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                success ? success(resultDic) : nil;
            });
        } else {
            WGHLog(responseObject);
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                stateError(responseObject);
            });
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        controller.navigationController.view.userInteractionEnabled = YES;
        controller.view.userInteractionEnabled = YES;
        WGHLog2(@"❌请求失败--%@❌", error.localizedDescription);
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUD];
        });
        [self requestErrorHandle:error task:task];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        [[self allSessionTask] removeObject:task];
        failure ? failure(error) : nil;
    }];

    sessionTask ? [[self allSessionTask] addObject:sessionTask] : nil;
}

//上传文件
+ (void)postFileRequest:(NSString *)url
               fileName:(NSArray *)fileNameArray
              parameter:(NSDictionary *)parameter
       postFileUrlArray:(NSArray *)urlArray
               progress:(void (^)(NSString *count))progress
                success:(void (^)(id responseObject))success
             stateError:(void (^)(id responseObject))stateError
                failure:(void (^)(NSError *error))failure
             controller:(UIViewController *)controller {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^() {
        NSString *requestUrl = url;

        _sessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
        [_sessionManager.requestSerializer requestWithMethod:@"POST" URLString:requestUrl parameters:parameter error:nil];
        [self congfigRequestSerializer:_sessionManager.requestSerializer];
        
        NSLog(@"***********network\n\n%@\n***************",requestUrl);
        
        NSURLSessionTask *sessionTask = [_sessionManager POST:requestUrl parameters:parameter constructingBodyWithBlock:^(id <AFMultipartFormData> _Nonnull formData) {
            for (int i = 0; i < urlArray.count; i++) {
                NSData *data = [NSData dataWithContentsOfURL:urlArray[i]];
//                NSString * mimeType = [self mimeTypeForFileAtPath:urlArray[i]];
//                NSLog(@"%@",mimeType);
                [formData appendPartWithFileData:data name:@"file" fileName:fileNameArray[i] mimeType:@"multipart/form-data"];
            }
        } progress:^(NSProgress *_Nonnull uploadProgress) {
            NSInteger count = (uploadProgress.completedUnitCount / uploadProgress.totalUnitCount) * 100;
            WGHLog(uploadProgress.completedUnitCount);
            WGHLog(uploadProgress.totalUnitCount);

            dispatch_async(dispatch_get_main_queue(), ^{
                progress(NSStringFormat(@"%ld", count));
            });
//            NSLog(@"上传量：%ld")
//            [uploadProgress addObserver:controller forKeyPath:@"fractionCompleted" options:NSKeyValueObservingOptionNew context:nil];
        } success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
            [[self allSessionTask] removeObject:task];
            
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            NSInteger code = [responseObject[@"code"] integerValue];
            if (code == tokenErrorCode) {
                [MBProgressHUD hideHUD];
//                if (SINGLE.userRole == OCUserRoleTypeVisitor) {
//                    [OCPublicMethodManager visitorGlobalQuitLogin];
//                }else {
//                    WGHLog(requestUrl);
//                    [OCPublicMethodManager globalQuitLogin];
//                }
                failure ? failure(nil) : nil;
                return;
            }
            id resultDic = responseObject[@"result"];
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUD];
                if (code == successCode && ![resultDic isEqual:[NSNull null]]) {
                    success ? success(responseObject[@"result"]) : nil;
                } else {
                    WGHLog(responseObject);
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        stateError(responseObject);
                    });
                }
            });
        } failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
            controller.navigationController.view.userInteractionEnabled = YES;
            controller.view.userInteractionEnabled = YES;
            WGHLog2(@"❌文件上传失败--%@❌", error.localizedDescription);
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUD];
            });
            [self requestErrorHandle:error task:task];
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            [[self allSessionTask] removeObject:task];
            failure ? failure(error) : nil;
        }];
        sessionTask ? [[self allSessionTask] addObject:sessionTask] : nil;
    });
}

+ (void)congfigRequestSerializer:(AFHTTPRequestSerializer *)serializer {
    NSString *aToken = [kUserDefaults objectForKey:@"token"];
    NSString *userId = [kUserDefaults objectForKey:@"userId"];
//    NSString * userRole = @"2";
    //游客的token和userID为空
    if (kStringIsEmpty(aToken)) {
        aToken = @"";
//        userRole = @"2";
    }
    if (kStringIsEmpty(userId)) {
        userId = @"";
    }
    
    serializer.timeoutInterval = 60.f;
    [serializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [serializer setValue:aToken forHTTPHeaderField:@"x-user-token"];
    [serializer setValue:userId forHTTPHeaderField:@"x-user-id"];
//    [serializer setValue:userRole forHTTPHeaderField:@"x-user-role"];
    [serializer setValue:@"2" forHTTPHeaderField:@"x-user-terminal"];//2代表iOS端
}

+ (void)requestErrorHandle:(NSError *)error task:(NSURLSessionDataTask *)task{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t) (0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (error.code != -999) {
            NSInteger statusCode = [(NSHTTPURLResponse *)task.response statusCode];
            if (statusCode == 401) {
//                [OCUserModel clearUserData];
//                SINGLE.refreshPersonal = YES;
//                [OCPublicMethodManager visitorGlobalQuitLogin];
            }else {
                
                [MBProgressHUD showText:[NSString stringWithFormat:@"网络请求错误！"]];
            }
        }
    });
}

+(void)downloadFileWithFileName:(NSString *)fileName filePath:(NSString *)filePath requestUrlStr:(NSString *)needUrlStr success:(void (^)(id responseObject))success{
    /* 创建网络下载对象 */
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSString *urlString = needUrlStr;
    
    //    urlString = [urlString stringByAppendingString:fileName];
    /* 下载地址 */
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    /* 下载路径 */
    NSString *path = [NSHomeDirectory() stringByAppendingString:@"/Documents"];
    NSString *filePath1 = [path stringByAppendingPathComponent:url.lastPathComponent];
    
    /* 开始请求下载 */
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        
        NSLog(@"下载量：%.0f％", downloadProgress.fractionCompleted * 100);
        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        
        /* 设定下载到的位置 */
        return [NSURL fileURLWithPath:filePath1];
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        
        NSLog(@"下载完成");
        NSLog(@"%@",filePath);
        NSString *name = [filePath path];
        
        success ? success(name) : nil;
        //        [self openFileWithPath:name];
    }];
    [downloadTask resume];
}


// Returen Status Code
+ (NSInteger)storeEtagWithKey:(NSString *)url andSessionTass:(NSURLSessionDataTask *)task {
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) task.response;
    NSInteger statusCode = httpResponse.statusCode;
    [[NSUserDefaults standardUserDefaults] setValue:httpResponse.allHeaderFields[@"ETag"] forKey:url];
    return statusCode;
}

+ (NSDictionary *)compareCapitalAndSmallWith:(NSDictionary *)dic {
    NSMutableDictionary *postDic = [NSMutableDictionary dictionaryWithDictionary:dic];
    //    [postDic setObject:[[WGHLanguageTool sharedInstance] getLanguageFlag] forKey:@"lang"];
    NSArray *keys = [postDic allKeys];

    NSArray *sortedArray = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2 options:NSLiteralSearch];
    }];

    NSMutableArray *newArr = [NSMutableArray array];

    for (NSInteger index = 0; index < sortedArray.count; index++) {
        [newArr addObject:postDic[NSStringFormat(@"%@", sortedArray[index])]];
    }
//    NSString *time = [OCTimeManager getTimeStamp];
//    [newArr addObject:time];
    //    [newArr addObject:NSStringFormat(@"%@",USER.token ? USER.token : @"")];
    //    [newArr addObject:kAPIKey];

    NSMutableString *parameterString = [NSMutableString string];

    for (NSInteger index = 0; index < newArr.count; index++) {
        [parameterString appendString:NSStringFormat(@"%@", newArr[index])];
    }
    NSString *sign = [NSString md5for32:parameterString];
    NSMutableDictionary *parametersDic = [NSMutableDictionary dictionaryWithDictionary:dic];

    //    [parametersDic setValue:[[WGHLanguageTool sharedInstance] getLanguageFlag] forKey:@"lang"];
    //    [parametersDic setValue:NSStringFormat(@"%@",USER.token ? USER.token : @"") forKey:@"token"];

//    [parametersDic setValue:time forKey:@"time"];
    [parametersDic setValue:sign forKey:@"sign"];

    return parametersDic;
}

+ (NSString *)setUrlHeaderWith:(NSString *)url {
    NSString * first = NSStringFormat(@"oczhkj123456%@",url);
    
    first = [first sha1String];
    
    NSString * second = NSStringFormat(@"%@&ios_%@&%@",first,[self getCurrentVersionCode],@{});
//    second = [OCPublicMethodManager changeUrlForIllegalityStr:second];
    
    return [second encodeBase64];
}

+ (NSString *)toJSONData:(id)theData{
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:theData
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    
    if ([jsonData length] > 0 && error == nil){
        return  [[NSString alloc] initWithData:jsonData
                                                             encoding:NSUTF8StringEncoding];;
    }else{
        return @"";
    }
}

+ (NSString *)getCurrentVersionCode {
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString * app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSString * version = NSStringFormat(@"%@V%@",kEnv,app_Version);
    return version;
}


+ (NSString *)mimeTypeForFileAtPath:(NSString *)path {
    if (![[[NSFileManager alloc] init] fileExistsAtPath:path]) {
        return nil;
    }
    
    CFStringRef UTI = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, (__bridge CFStringRef)[path pathExtension], NULL);
    CFStringRef MIMEType = UTTypeCopyPreferredTagWithClass (UTI, kUTTagClassMIMEType);
    CFRelease(UTI);
    if (!MIMEType) {
        return @"application/octet-stream";
    }
    return (__bridge NSString *)(MIMEType);
}

@end
