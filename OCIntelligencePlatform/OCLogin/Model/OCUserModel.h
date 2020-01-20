//
//  OCUserModel.h
//  OCIntelligencePlatform
//
//  Created by Alan on 2019/8/21.
//  Copyright © 2019 OCZHKJ. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface OCUserModel : NSObject

@property (copy, nonatomic) NSString *phone;
@property (copy, nonatomic) NSString *school;
@property (copy, nonatomic) NSString *schoolId;
@property (assign, nonatomic) NSInteger collegeId;
@property (assign, nonatomic) NSInteger type;

@property (copy, nonatomic) NSString *userId;
@property (copy, nonatomic) NSString *userName;
@property (copy, nonatomic) NSString *userNumber;
@property (copy, nonatomic) NSString *token;
@property (copy, nonatomic) NSString *isNewUser; //新用户(0.否 1.是)
@property (copy, nonatomic) NSString *headImg;
@property (assign, nonatomic) NSInteger leader;
@property (assign, nonatomic) NSInteger score;

@property (copy, nonatomic) NSString *majorName;
@property (assign, nonatomic) NSInteger majorId;

@property (copy, nonatomic) NSString *time;

@property (copy, nonatomic) NSString *clazzName;
@property (assign, nonatomic) NSInteger clazzId;

@property (assign, nonatomic) NSInteger enrollmentYear;

@property (copy, nonatomic) NSString *userRole;

@property (copy, nonatomic) NSString *bm;

@property (strong, nonatomic) NSArray *permissionList;

@property (strong, nonatomic) NSArray *roleList;

/*
 *登录数据处理
 */
+ (void)handleLoginData:(NSDictionary *)responseObject;

/*
 *清除登录数据
 */
+ (void)clearUserData;

@end

NS_ASSUME_NONNULL_END
