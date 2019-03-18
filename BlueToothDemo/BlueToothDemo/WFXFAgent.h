//
//  XFAgent.h
//  BlueToothDemo
//
//  Created by ly on 2018/9/17.
//  Copyright © 2018年 ly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ViewController.h"

/// XF服务器状态
typedef NS_ENUM(NSInteger, WFXFAgentServerStatus) {
    WFXFAgentServerStatusUnknown = 0,
    WFXFAgentServerStatusDisconnected = 1,
    WFXFAgentServerStatusConnected    = 2,
};

/// 录音状态
typedef NS_ENUM(NSInteger, WFXFAgentRecordStatus) {
    WFXFAgentRecordStatusUnknown = 0,
    WFXFAgentRecordStatusStop = 1,
    WFXFAgentRecordStatusStart = 2,
};

/// AIUI状态
typedef NS_ENUM(NSInteger, WFXFAgentAIUIStatus) {
    WFXFAgentAIUIStatusUnknown = 0,
    WFXFAgentAIUIStatusIDLE = 1,
    WFXFAgentAIUIStatusREADY = 2,
    WFXFAgentAIUIStatusWORKING = 3,
};

/// 音频监控事件
typedef NS_ENUM(NSInteger, WFXFAgentEventStatus) {
    WFXFAgentEventStatusUnknown = 0,
    WFXFAgentEventStatusWakeup= 1,
    WFXFAgentEventStatusSleep = 2,
};

/// 声音状态事件
typedef NS_ENUM(NSInteger, WFXFAgentVoiceStatus) {
    WFXFAgentVoiceStatusUnknown = 0,
    WFXFAgentVoiceStatusBOS = 1,
    WFXFAgentVoiceStatusEOS = 2,
    WFXFAgentVoiceStatusVOL = 3,
};


@interface WFXFAgent : NSObject
@property (nonatomic, strong) ViewController*vc;
@property (nonatomic, assign) WFXFAgentServerStatus serverStatus;
@property (nonatomic, assign) WFXFAgentRecordStatus recordStatus;
@property (nonatomic, assign) WFXFAgentAIUIStatus aiuiStatus;
@property (nonatomic, assign) WFXFAgentEventStatus eventStatus;
@property (nonatomic, assign) WFXFAgentVoiceStatus voiceStatus;
- (void)record;
- (void)stopRecord;
@end
