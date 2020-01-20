//
//  OCVideoTopView.h
//  OCIntelligencePlatform
//
//  Created by Alan on 2019/9/20.
//  Copyright © 2019 OCZHKJ. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface OCVideoTopView : UIView

typedef void(^videoTopBlock)(NSInteger tag);

-(instancetype)initWithTopViewFrame:(CGRect)frame titleName:(NSArray *)titles;
@property (copy, nonatomic) videoTopBlock block;

-(void)selectedWithIndex:(NSInteger)index;

-(void)autoScollViewPoint;
@end

NS_ASSUME_NONNULL_END
