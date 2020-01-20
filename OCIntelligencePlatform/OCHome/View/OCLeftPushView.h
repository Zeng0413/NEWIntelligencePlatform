//
//  OCLeftPushView.h
//  OCIntelligencePlatform
//
//  Created by Alan on 2019/8/21.
//  Copyright © 2019 OCZHKJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OCTermModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface OCLeftPushView : UIView
typedef void(^OCLeftPushViewClickBlock)(OCTermModel *model);

+(instancetype)showLeftPushViewWithDataArr:(NSArray *)dataArr withSelectedIndex:(NSInteger)index;

@property (copy, nonatomic) OCLeftPushViewClickBlock block;

@end

NS_ASSUME_NONNULL_END
