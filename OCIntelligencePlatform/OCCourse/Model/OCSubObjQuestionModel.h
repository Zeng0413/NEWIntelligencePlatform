//
//  OCSubObjQuestionModel.h
//  OCIntelligencePlatform
//
//  Created by Alan on 2019/8/23.
//  Copyright © 2019 OCZHKJ. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface OCSubObjQuestionModel : NSObject

@property (assign, nonatomic) NSInteger answer;
@property (assign, nonatomic) NSInteger ID;
@property (assign, nonatomic) NSInteger score;
@property (assign, nonatomic) NSInteger type;
@property (copy, nonatomic) NSString *headTitle;
@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *userAnswer;
@property (assign, nonatomic) NSInteger allowUpload;
@property (copy, nonatomic) NSString *answerContent;

@property (strong, nonatomic) NSArray *imgsList;
@property (strong, nonatomic) NSArray *optionList;
@end

NS_ASSUME_NONNULL_END
