//
//  OCClassroomBorrowModel.h
//  OCIntelligencePlatform
//
//  Created by Alan on 2019/10/21.
//  Copyright © 2019 OCZHKJ. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface OCClassroomBorrowModel : NSObject

@property (assign, nonatomic) NSInteger borrowTime;
@property (copy, nonatomic) NSString *borrowId;
@property (copy, nonatomic) NSString *buildName;
@property (copy, nonatomic) NSString *campus;
@property (assign, nonatomic) NSInteger expires; //0.未过期1.已过期
@property (copy, nonatomic) NSString *roomCode;
@property (copy, nonatomic) NSString *time;
@property (assign, nonatomic) NSInteger state; //1.等待审批2.已通过3.已决绝

@property (copy, nonatomic) NSString *borrowReason; // 申请事由
@property (copy, nonatomic) NSString *borrowSection; // 借用节次
@property (copy, nonatomic) NSString *department; // 院系
@property (copy, nonatomic) NSString *name; // 讲座名称
@property (copy, nonatomic) NSString *refuseReason; // 拒绝原因
@property (assign, nonatomic) NSInteger type; // 1.普通申请2.讲座申请
@property (copy, nonatomic) NSString *userName;
@property (assign, nonatomic) NSInteger userType; // 1.学生2.老师

@property (assign, nonatomic) BOOL isSelected;

@end

NS_ASSUME_NONNULL_END
