//
//  OCAuthCodeManager.h
//  OCPhoenix
//
//  Created by Alan on 2019/4/10.
//  Copyright © 2019 OCZHKJ. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface OCAuthCodeManager : NSObject

+ (void)getVerifyCodeWithType:(NSString *)type
                       mobile:(NSString *)mobile
                       sender:(WGHCountDownButton *)sender
                      success:(nonnull void (^)(id _Nonnull))success;

@end

NS_ASSUME_NONNULL_END
