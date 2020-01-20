//
//  OCClassModel.h
//  OCIntelligencePlatform
//
//  Created by Alan on 2019/8/22.
//  Copyright © 2019 OCZHKJ. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface OCClassModel : NSObject

@property (nonatomic, copy) NSString *clazzFullName;
@property (nonatomic, copy) NSString *clazzName;
@property (nonatomic, assign) NSInteger collegeId;
@property (nonatomic, copy) NSString *collegeName;
@property (nonatomic, assign) NSInteger ID;
@property (nonatomic, assign) NSInteger mark; // 是否允许自由注册（0.测试 1.正式）
@end

NS_ASSUME_NONNULL_END
