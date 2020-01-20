//
//  OCCollegeSubject.h
//  OCIntelligencePlatform
//
//  Created by Alan on 2019/8/22.
//  Copyright © 2019 OCZHKJ. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BRAcademyModel : NSObject

@property (assign, nonatomic) NSInteger ID;
@property (strong, nonatomic) NSArray *list;
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *parentId;
@property (copy, nonatomic) NSString *schoolId;
/** 省的索引 */
@property (nonatomic, assign) NSInteger index;

@end

@interface BRSubjectModel : NSObject

@property (assign, nonatomic) NSInteger ID;
@property (strong, nonatomic) NSArray *list;
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *parentId;
@property (copy, nonatomic) NSString *schoolId;
/** 省的索引 */
@property (nonatomic, assign) NSInteger index;
@end

@interface BRProfessionModel : NSObject

@property (assign, nonatomic) NSInteger ID;
@property (strong, nonatomic) NSArray *list;
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *parentId;
@property (copy, nonatomic) NSString *schoolId;
/** 省的索引 */
@property (nonatomic, assign) NSInteger index;
@end

NS_ASSUME_NONNULL_END
