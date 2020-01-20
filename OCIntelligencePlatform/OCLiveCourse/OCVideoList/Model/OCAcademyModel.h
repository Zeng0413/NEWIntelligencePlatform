//
//  OCAcademyModel.h
//  OCIntelligencePlatform
//
//  Created by Alan on 2019/9/26.
//  Copyright © 2019 OCZHKJ. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface OCAcademyModel : NSObject

@property (assign, nonatomic) NSInteger ID;
@property (copy, nonatomic) NSString *name;
@property (strong, nonatomic) NSArray *categories;

@end

NS_ASSUME_NONNULL_END
