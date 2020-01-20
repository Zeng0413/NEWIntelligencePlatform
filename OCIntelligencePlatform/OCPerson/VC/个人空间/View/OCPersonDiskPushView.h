//
//  OCPersonDiskPushView.h
//  OCIntelligencePlatform
//
//  Created by Alan on 2019/11/7.
//  Copyright © 2019 OCZHKJ. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface OCPersonDiskPushView : UIView
typedef void(^confirmBlock)(NSString *fileStr);
+(OCPersonDiskPushView *)creatPersonDiskPushView;
@property (copy, nonatomic) confirmBlock block;

@property (copy, nonatomic) NSString *titleStr;
@end
NS_ASSUME_NONNULL_END
