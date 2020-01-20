//
//  OCCommonTopChooseView.h
//  OCIntelligencePlatform
//
//  Created by Alan on 2019/10/9.
//  Copyright © 2019 OCZHKJ. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface OCCommonTopChooseView : UIView

typedef void(^topChooseViewBlock)(NSInteger tag);

-(instancetype)initWithTopViewFrame:(CGRect)frame titleName:(NSArray *)titles aveWidth:(NSInteger)ave;

@property (copy, nonatomic) topChooseViewBlock block;

-(void)selectedWithIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
