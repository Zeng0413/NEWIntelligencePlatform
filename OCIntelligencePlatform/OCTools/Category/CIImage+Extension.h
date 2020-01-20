//
//  CIImage+Extension.h
//  OCIntelligencePlatform
//
//  Created by Alan on 2020/1/14.
//  Copyright © 2020 OCZHKJ. All rights reserved.
//


#import <CoreImage/CoreImage.h>

NS_ASSUME_NONNULL_BEGIN

@interface CIImage (Extension)

- (UIImage *)createNonInterpolatedWithSize:(CGFloat)size;

@end

NS_ASSUME_NONNULL_END
