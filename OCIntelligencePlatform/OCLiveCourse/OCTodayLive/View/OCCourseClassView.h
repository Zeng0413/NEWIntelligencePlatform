//
//  OCCourseClassView.h
//  OCIntelligencePlatform
//
//  Created by Alan on 2019/11/8.
//  Copyright © 2019 OCZHKJ. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^viewOperationBlock)(NSInteger type, NSInteger index);

@interface OCCourseClassView : UIView

-(instancetype)initWithFrame:(CGRect)frame withDataArray:(NSArray *)dataArr withSelectedIndex:(NSInteger)index;
@property (copy, nonatomic) viewOperationBlock block;

@end

NS_ASSUME_NONNULL_END
