//
//  OCInfoMessagePushView.h
//  OCIntelligencePlatform
//
//  Created by Alan on 2020/1/13.
//  Copyright © 2020 OCZHKJ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^OCInfoMessagePushViewCancelBlock)(void);

typedef void(^OCInfoMessagePushViewBtnBlock)(NSInteger type);

NS_ASSUME_NONNULL_BEGIN

@interface OCInfoMessagePushView : UIView

-(instancetype)initWithPushViewFrame:(CGRect)frame withAllStr:(NSString *)allStr withPointStr:(NSString *)pointStr withPointStrColor:(UIColor *)strColor withBtnCount:(NSInteger)count withBtn1Str:(NSString *)btn1Str withBtn2Str:(NSString *)btn2Str;

-(instancetype)initWithPushViewFrame:(CGRect)frame withImg:(UIImage *)image;

@property (copy, nonatomic) OCInfoMessagePushViewCancelBlock cancelBlock;

@property (copy, nonatomic) OCInfoMessagePushViewBtnBlock btnBlock;

@end

NS_ASSUME_NONNULL_END
