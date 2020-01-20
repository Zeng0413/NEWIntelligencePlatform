//
//  OCVerticalLabel.h
//  OCElocutionSys_iOS
//
//  Created by Alan on 2018/11/19.
//  Copyright © 2018 OCZHKJ. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    OCVerticalAlignmentNone = 0,
    OCVerticalAlignmentCenter,
    OCVerticalAlignmentTop,
    OCVerticalAlignmentBottom
} OCVerticalAlignment;

@interface  OCVerticalLabel: UILabel

@property (nonatomic) UIEdgeInsets edgeInsets;
/**
 *  对齐方式
 */
@property (nonatomic) OCVerticalAlignment verticalAlignment;


@end

NS_ASSUME_NONNULL_END
