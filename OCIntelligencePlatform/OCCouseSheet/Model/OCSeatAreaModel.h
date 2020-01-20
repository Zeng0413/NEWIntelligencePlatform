//
//  OCSeatAreaModel.h
//  OCIntelligencePlatform
//
//  Created by Alan on 2020/1/9.
//  Copyright © 2020 OCZHKJ. All rights reserved.
//

#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN

@interface OCSeatAreaModel : NSObject

@property (copy, nonatomic) NSString *name;

@property (strong, nonatomic) NSArray *seatList;

@end

NS_ASSUME_NONNULL_END
