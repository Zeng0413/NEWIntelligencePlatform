//
//  OCVideoControlBGView.h
//  OCPhoenix
//
//  Created by Alan on 2019/5/5.
//  Copyright © 2019 OCZHKJ. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <ZFPlayer/ZFPlayerMediaControl.h>
#import <ZFPlayer/ZFPlayer.h>
#import "OCLiveVideoModel.h"
#import "OCCourseVideoListModel.h"

@interface OCVideoControlBGView : UIView <ZFPlayerMediaControl>

- (instancetype)initWithFrame:(CGRect)frame withLiveModel:(OCLiveVideoModel *)liveModel;

@property (strong, nonatomic) OCLiveVideoModel *liveModel;
@property (strong, nonatomic) OCCourseVideoListModel *videoModel;

@property (strong, nonatomic) NSDictionary *dataDict;


-(void)stopVideo;
@end

