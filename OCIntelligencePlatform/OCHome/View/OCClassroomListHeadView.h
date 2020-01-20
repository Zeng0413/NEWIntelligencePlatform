//
//  OCClassroomListHeadView.h
//  OCIntelligencePlatform
//
//  Created by Alan on 2020/1/13.
//  Copyright © 2020 OCZHKJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol OCClassroomListHeadViewDelegate <NSObject>

-(void)topViewBtnClickWithType:(NSInteger)typeIndex;

@end

NS_ASSUME_NONNULL_BEGIN

@interface OCClassroomListHeadView : UICollectionReusableView

@property (weak, nonatomic) id<OCClassroomListHeadViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
