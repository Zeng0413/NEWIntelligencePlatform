//
//  OCCourseLessonModel.h
//  OCIntelligencePlatform
//
//  Created by Alan on 2019/8/27.
//  Copyright © 2019 OCZHKJ. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface OCCourseLessonModel : NSObject
@property (assign, nonatomic) NSInteger ID;
@property (copy, nonatomic) NSString *name;
@property (assign, nonatomic) NSInteger taught;
@property (copy, nonatomic) NSString *takeTime;
@property (copy, nonatomic) NSString *clazzId;
@end

NS_ASSUME_NONNULL_END
