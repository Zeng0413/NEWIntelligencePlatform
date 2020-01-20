//
//  SocketRocketUtility.h
//  OCIntelligencePlatform
//
//  Created by Alan on 2019/8/13.
//  Copyright © 2019 OCZHKJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SocketRocket.h>
NS_ASSUME_NONNULL_BEGIN

@interface SocketRocketUtility : NSObject

@property (assign, nonatomic) SRReadyState socketReadyState;

+ (SocketRocketUtility *)instance;

-(void)SRSocketOpen;//开启连接
-(void)SRSocketClose;//关闭连接
- (void)sendData:(id)data;//发送数据

@end

NS_ASSUME_NONNULL_END
