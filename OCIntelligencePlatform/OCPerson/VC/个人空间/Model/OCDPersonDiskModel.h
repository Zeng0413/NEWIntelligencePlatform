//
//  OCDPersonDiskModel.h
//  OCIntelligencePlatform
//
//  Created by Alan on 2019/10/31.
//  Copyright © 2019 OCZHKJ. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface OCDPersonDiskModel : NSObject

@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *parentId;
@property (copy, nonatomic) NSString *url;
@property (copy, nonatomic) NSString *ID;
@property (copy, nonatomic) NSString *coverImg;
@property (copy, nonatomic) NSString *userId;
@property (copy, nonatomic) NSString *size;
@property (copy, nonatomic) NSString *fileType;

@property (assign, nonatomic) NSInteger type;
@property (assign, nonatomic) NSInteger createTime;

@property (assign, nonatomic) BOOL isSelected;

@end

NS_ASSUME_NONNULL_END
