//
//  OCClassroomPickView.h
//  OCIntelligencePlatform
//
//  Created by Alan on 2019/10/16.
//  Copyright © 2019 OCZHKJ. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface xqModel : NSObject
@property (copy, nonatomic) NSString *campus;
@property (strong, nonatomic) NSArray *buildings;
/** 省的索引 */
@property (nonatomic, assign) NSInteger index;

@end

@interface jxlModel : NSObject

@property (copy, nonatomic) NSString *buildingName;
@property (strong, nonatomic) NSArray *roomList;
/** 省的索引 */
@property (nonatomic, assign) NSInteger index;
@end

@interface jsModel : NSObject

@property (copy, nonatomic) NSString *jsName;
/** 省的索引 */
@property (nonatomic, assign) NSInteger index;

@end

NS_ASSUME_NONNULL_END
