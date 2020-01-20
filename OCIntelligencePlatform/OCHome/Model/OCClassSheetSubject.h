//
//  OCClassSheetSubject.h
//  OCIntelligencePlatform
//
//  Created by Alan on 2019/9/24.
//  Copyright © 2019 OCZHKJ. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface OCClassSheetSubject : NSObject
@property (copy, nonatomic) NSString *lessonCode;
@property (copy, nonatomic) NSString *lessonName;
@property (copy, nonatomic) NSString *mergeSection;
@property (copy, nonatomic) NSString *oldLocation;
@property (copy, nonatomic) NSString *roomCode;
@property (copy, nonatomic) NSString *roomName;
@property (copy, nonatomic) NSString *section;
@property (assign, nonatomic) NSInteger isLive;
@property (copy, nonatomic) NSString *teacher;
@property (copy, nonatomic) NSString *time;
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *weeks;
@property (copy, nonatomic) NSString *equipmentId;

@end

NS_ASSUME_NONNULL_END
