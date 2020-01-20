//
//  OCHasNetwork.h
//  OCIntelligencePlatform
//
//  Created by Alan on 2019/11/21.
//  Copyright © 2019 OCZHKJ. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface OCHasNetwork : NSObject

+ (void)ysy_hasNetwork:(void(^)(bool has))hasNet;

@end

NS_ASSUME_NONNULL_END
