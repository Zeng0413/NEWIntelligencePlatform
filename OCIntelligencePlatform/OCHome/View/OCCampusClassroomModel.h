//
//  OCCampusClassroomModel.h
//  OCIntelligencePlatform
//
//  Created by Alan on 2019/9/23.
//  Copyright © 2019 OCZHKJ. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface OCCampusClassroomModel : NSObject


@property (copy, nonatomic) NSString *img;
@property (assign, nonatomic) NSInteger useCount; //授课教室统计
@property (assign, nonatomic) NSInteger totalCount; //总共教室数
@property (assign, nonatomic) NSInteger freeCount; //空闲教室
@property (assign, nonatomic) NSInteger floor; //楼层
@property (copy, nonatomic) NSString *buildName; //楼栋名
@property (copy, nonatomic) NSString *campus; //校区
@property (copy, nonatomic) NSString *buildType; //楼栋类型
@end

NS_ASSUME_NONNULL_END
