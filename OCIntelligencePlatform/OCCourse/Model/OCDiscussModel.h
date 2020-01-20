//
//  OCDiscussModel.h
//  OCIntelligencePlatform
//
//  Created by Alan on 2019/8/26.
//  Copyright © 2019 OCZHKJ. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface OCDiscussModel : NSObject

@property (copy, nonatomic) NSString *headLine;
@property (assign, nonatomic) NSInteger discussCount;
@property (copy, nonatomic) NSString *title;
@property (assign, nonatomic) NSInteger ID;
@property (assign, nonatomic) NSInteger type;
@property (strong, nonatomic) NSArray *answerList;
@property (strong, nonatomic) NSArray *imgsList;

@end

NS_ASSUME_NONNULL_END
