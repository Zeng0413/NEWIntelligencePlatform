//
//  OCLessonGroupModel.h
//  OCIntelligencePlatform
//
//  Created by Alan on 2019/8/23.
//  Copyright © 2019 OCZHKJ. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface OCLessonGroupModel : NSObject
@property (assign, nonatomic) NSInteger ID;
@property (copy, nonatomic) NSString *name;
@property (assign, nonatomic) NSInteger score;
@property (strong, nonatomic) NSArray *userList;

@end

NS_ASSUME_NONNULL_END
