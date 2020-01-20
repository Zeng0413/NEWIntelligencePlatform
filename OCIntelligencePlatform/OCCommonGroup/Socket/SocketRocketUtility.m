//
//  SocketRocketUtility.m
//  OCIntelligencePlatform
//
//  Created by Alan on 2019/8/13.
//  Copyright © 2019 OCZHKJ. All rights reserved.
//

#import "SocketRocketUtility.h"
#import "GCDAsyncSocket.h"
#import "AFNetworking.h"
@interface SocketRocketUtility ()<GCDAsyncSocketDelegate>

@property (strong, nonatomic) NSTimer *heartBeat;
@property (strong, nonatomic) GCDAsyncSocket *socket;
@property (nonatomic, assign) BOOL connected;

@end

@implementation SocketRocketUtility

+(SocketRocketUtility *)instance{
    static SocketRocketUtility *Instance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        Instance = [[SocketRocketUtility alloc] init];
    });
    return Instance;
}

-(void)networkMonitoring{
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    //要监控网络连接状态，必须要先调用单例的startMonitoring方法
    [manager startMonitoring];
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        //status:
        //AFNetworkReachabilityStatusUnknown          = -1,  未知
        //AFNetworkReachabilityStatusNotReachable     = 0,   未连接
        //AFNetworkReachabilityStatusReachableViaWWAN = 1,   3G
        //AFNetworkReachabilityStatusReachableViaWiFi = 2,   无线连接
        
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                [self SRSocketOpen];
                //                MELog(@"未知网络");
                break;
            case AFNetworkReachabilityStatusNotReachable:
                //                MELog(@"无网络");
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                [self SRSocketOpen];
                //                MELog(@"2G/3G/4G网络");
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                [self SRSocketOpen];
                //                MELog(@"wifi连接");
                break;
                
            default:
                break;
        }
    }];
}

// 添加定时器 ，心跳
-(void)addTimer{
    
    dispatch_main_async_safe(^{
        [self destoryHeartBeat];
        // 长连接定时器
        self.heartBeat = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(longConnectToSocket) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.heartBeat forMode:NSRunLoopCommonModes];
    })
    
}

//取消心跳
- (void)destoryHeartBeat
{
    dispatch_main_async_safe(^{
        if (self.heartBeat) {
            if ([self.heartBeat respondsToSelector:@selector(isValid)]){
                if ([self.heartBeat isValid]){
                    [self.heartBeat invalidate];
                    self.heartBeat = nil;
                }
            }
        }
    })
}
// 心跳连接
-(void)longConnectToSocket{
    NSString *userId = [kUserDefaults valueForKey:@"userId"];
    NSDictionary *dict = @{@"type":@"3", @"role":@"1", @"user_id":userId};
    NSString *dataStr = [NSString convertToJsonData:dict];
    [self sendData:dataStr];
//
//    [self.socket writeData:nil withTimeout:-1 tag:0];
}

-(void)SRSocketOpen{
    
    if (!self.connected) {
        self.socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
        
        NSError *error = nil;
        
        [self.socket connectToHost:kChatUrl onPort:kChatPort viaInterface:nil withTimeout:-1 error:&error];
        
        
        if (error) {
            NSLog(@"%@",error);
        }
    }
    
    
}

#pragma mark - socket delegate

-(void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port{
    NSLog(@"%s",__func__);
    
    
    // 连接成功开启定时器
    [self addTimer];
    // 连接后,可读取服务器端的数据
    [self.socket readDataWithTimeout:-1 tag:0];
    self.connected = YES;
    
//    [self networkMonitoring];
}

-(void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err{
    if (err) {
        self.socket.delegate = nil;
        //    [self.clientSocket disconnect];
        self.socket = nil;
        self.connected = NO;
        [self.heartBeat invalidate];
        
        [self SRSocketOpen];
//        self.connected = NO;
        NSLog(@"连接失败");
    }else{
        NSLog(@"正常连接");
    }
}

// 发送数据
- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag {
    
    NSLog(@"%s",__func__);
    
    //发送完数据手动读取，-1不设置超时
//    [sock readDataWithTimeout:-1
//                          tag:tag];
}

// 读取数据
-(void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data
      withTag:(long)tag {
    
    unsigned int totalLength = (int)data.length;
    NSData *contenData = [data subdataWithRange:NSMakeRange(4, totalLength-4)];
    
    NSError *error;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:contenData options:NSJSONReadingMutableContainers error:&error];
    
    NSString *userId = [kUserDefaults valueForKey:@"userId"];
    if ([dic[@"type"] integerValue] == 1) {
        NSDictionary *dict = @{@"type":@"1", @"role":@"1", @"user_id":userId};
        NSString *dataStr = [NSString convertToJsonData:dict];
        [self sendData:dataStr];
    }else{
        [kNotificationCenter postNotificationName:@"socktReceiveMessageNotification" object:nil userInfo:dic];
    }
    
  
    
    // 读取到服务端数据值后,能再次读取
    [self.socket readDataWithTimeout:-1 tag:0];
}

-(void)sendData:(id)data{
    NSString *str = data;
    NSData *strData = [str dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableData *mData = [[NSMutableData alloc] init];
    
    unsigned int totalSize = (int)strData.length;
    NSData *totalSizeData = [NSData dataWithBytes:&totalSize length:4];
    [mData appendData:totalSizeData];
    [mData appendData:strData];
    
    // withTimeout -1 : 无穷大,一直等
    
    // tag : 消息标记
    [self.socket writeData:mData withTimeout:-1 tag:0];
}

-(void)SRSocketClose{
    [self.socket disconnect];
    self.socket.delegate = nil;
    self.socket = nil;
    self.connected = NO;
    [self.heartBeat invalidate];
}
@end
