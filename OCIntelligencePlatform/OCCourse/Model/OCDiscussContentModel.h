//
//  OCDiscussContentModel.h
//  OCIntelligencePlatform
//
//  Created by Alan on 2019/8/26.
//  Copyright © 2019 OCZHKJ. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface OCDiscussContentModel : NSObject

@property (copy, nonatomic) NSString *content;
@property (copy, nonatomic) NSString *groupName;
@property (copy, nonatomic) NSString *headImg;
@property (copy, nonatomic) NSString *userName;
@property (assign, nonatomic) NSInteger groupId;
@property (assign, nonatomic) NSInteger userId;
@property (assign, nonatomic) NSInteger type;

@end

NS_ASSUME_NONNULL_END
