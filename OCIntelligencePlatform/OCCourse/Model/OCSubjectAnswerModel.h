//
//  OCSubjectAnswerModel.h
//  OCIntelligencePlatform
//
//  Created by Alan on 2019/8/17.
//  Copyright © 2019 OCZHKJ. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface OCSubjectAnswerModel : NSObject

@property (copy, nonatomic) NSString *key;
@property (copy, nonatomic) NSString *value;
@property (copy, nonatomic) NSString *isCorrect;
@property (copy, nonatomic) NSString *isSelected;

@end

NS_ASSUME_NONNULL_END
