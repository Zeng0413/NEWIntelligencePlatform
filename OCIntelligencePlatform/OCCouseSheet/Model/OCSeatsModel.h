//
//  OCSeatsModel.h
//  OCIntelligencePlatform
//
//  Created by Alan on 2020/1/9.
//  Copyright © 2020 OCZHKJ. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface OCSeatsModel : NSObject

@property (copy, nonatomic) NSString *code;

@property (copy, nonatomic) NSString *ID;

@property (copy, nonatomic) NSString *area;

@property (copy, nonatomic) NSString *name;

@property (assign, nonatomic) NSInteger status;

@end

NS_ASSUME_NONNULL_END
