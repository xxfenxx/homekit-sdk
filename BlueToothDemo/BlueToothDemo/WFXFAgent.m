//
//  XFAgent.m
//  BlueToothDemo
//
//  Created by ly on 2018/9/17.
//  Copyright © 2018年 ly. All rights reserved.
//

/**
 唤醒:
 状态说明:https://aiui.xfyun.cn/access_docs/aiui-sdk/smart_doc/AIUI状态.html
 离线命令:https://aiui.xfyun.cn/access_docs/aiui-sdk/mobile_doc/离线命令词.html
 流式识别:
 1. 创建代理(控制对象)
 2. 唤醒
 3. 录音
 4. ...
 5. 停止
 **/

#import "WFXFAgent.h"
#import <iflyAIUI/IFlyAIUI.h>

@interface WFXFAgent()
@property (nonatomic, strong) IFlyAIUIAgent *aiuiAgent;
@end

@implementation WFXFAgent

- (instancetype)init  {
    self = [super init];
    
    if (self) {
        // 创建
        [self createAgent];
    }
    
    return self;
}

- (void)updateShiTi:(NSArray *)st {
    /**
     1. 构建实体数组
     2. 实体数组base64
     3. 构建上传参数
     4. 同步数据
     5. 生效使用
     **/
}

/// 等待变成working状态
- (void)createAgent {
    // 读取aiui.cfg配置文件
    NSString *cfgFilePath = [[NSBundle mainBundle] pathForResource:@"aiui" ofType:@"cfg"];
    NSString *cfg = [NSString stringWithContentsOfFile:cfgFilePath encoding:NSUTF8StringEncoding error:nil];
    
    //创建AIUIAgent：连接服务器
    _aiuiAgent = [IFlyAIUIAgent createAgent:cfg withListener:self];
    
    //发送唤醒消息
    [self wekeup];
}

- (void)destory {
    [self stopRecord];
    [_aiuiAgent destroy];
}

- (void)start {
    //启动: idle->start->wakeup->working->record
    IFlyAIUIMessage *startMsg = [[IFlyAIUIMessage alloc]init];
    startMsg.msgType = CMD_START;
    [_aiuiAgent sendMessage:startMsg];
}

- (void)wekeup {
    //发送唤醒消息:wakeup->working->record
    IFlyAIUIMessage *wakeuMsg = [[IFlyAIUIMessage alloc]init];
    wakeuMsg.msgType = CMD_WAKEUP;
    [_aiuiAgent sendMessage:wakeuMsg];
}

- (void)stopRecord {
    // 变成idle状态
    IFlyAIUIMessage *msg = [[IFlyAIUIMessage alloc] init];
    msg.msgType = CMD_STOP_RECORD;
    [_aiuiAgent sendMessage:msg];
}


// 必须是working状态+发送开始录音消息
- (void)record {
    
    // 判断服务器是否连接
    if (self.serverStatus == WFXFAgentServerStatusDisconnected) {
        [self start];
        [self wekeup];
        return;
    }
    
    // 判断sdk状态：是不是正在休眠或预备状态
    if (self.aiuiStatus == WFXFAgentAIUIStatusIDLE) {
        [self start];
        [self wekeup];
        return;
    }
    
    // 判断是不是唤醒状态
    if (self.eventStatus == WFXFAgentEventStatusSleep) {
        [self wekeup];
        return;
    }
    
    // READ 状态等待唤醒
    if (self.aiuiStatus == WFXFAgentAIUIStatusREADY) {
        [self wekeup];
        return;
    }
    
    // 判断是否已经唤醒
    IFlyAIUIMessage *msg = [[IFlyAIUIMessage alloc] init];
    msg.msgType = CMD_START_RECORD;
    [_aiuiAgent sendMessage:msg];
}



- (void)onEvent:(IFlyAIUIEvent *) event {
    /**
     1. 服务器状态
     2. 录音状态
     3. AIUI运行状态
     4. 处理结果
     **/
    switch (event.eventType) {
            
        case EVENT_CONNECTED_TO_SERVER:
        {
            //服务器连接成功事件
            NSLog(@"CONNECT TO SERVER");
            [self.vc message:@"服务器连接成功事件"];
            
            self.serverStatus = WFXFAgentServerStatusConnected;
           
        } break;
            
        case EVENT_SERVER_DISCONNECTED:
        {
            //服务器连接断开事件
            NSLog(@"DISCONNECT TO SERVER");
            [self.vc message:@"服务器连接断开事件"];
            
             self.serverStatus = WFXFAgentServerStatusDisconnected;
        } break;
            
            
        case EVENT_START_RECORD:
        {
            //开始录音事件
            NSLog(@"EVENT_START_RECORD");
            [self.vc message:@"开始录音事件"];
            self.recordStatus = WFXFAgentRecordStatusStart;
        } break;
            
        case EVENT_STOP_RECORD:
        {
            //停止录音事件
            NSLog(@"EVENT_STOP_RECORD");
            [self.vc message:@"停止录音事件"];
            self.recordStatus = WFXFAgentRecordStatusStop;
        } break;
            
            
        case EVENT_STATE:
        {
            //AIUI运行状态事件
            switch (event.arg1)
            {
                case STATE_IDLE:
                {
                    NSLog(@"EVENT_STATE: %s", "IDLE");
                    [self.vc message:@"休眠"];
                    self.aiuiStatus = WFXFAgentAIUIStatusIDLE;
                } break;
                    
                case STATE_READY:
                {
                    NSLog(@"EVENT_STATE: %s", "READY");
                    [self.vc message:@"准备阶段"];
                    self.aiuiStatus = WFXFAgentAIUIStatusREADY;
                } break;
                    
                case STATE_WORKING:
                {
                    NSLog(@"EVENT_STATE: %s", "WORKING");
                    [self.vc message:@"正在工作"];
                    self.aiuiStatus = WFXFAgentAIUIStatusWORKING;
                } break;
            }
        } break;
            
            
            
        case EVENT_WAKEUP:
        {
            //唤醒事件
            NSLog(@"EVENT_WAKEUP");
            [self.vc message:@"唤醒事件"];
            self.eventStatus = WFXFAgentEventStatusWakeup;
        } break;
            
        case EVENT_SLEEP:
        {
            //休眠事件
            NSLog(@"EVENT_SLEEP");
            [self.vc message:@"休眠事件"];
            self.eventStatus = WFXFAgentEventStatusSleep;
        } break;
            
            
        // VAD
        case EVENT_VAD:
        {
            switch (event.arg1)
            {
                case VAD_BOS:
                {
                    //前端点事件
                    NSLog(@"EVENT_VAD_BOS");
                    [self.vc message:@"前端点事件"];
                    self.voiceStatus = WFXFAgentVoiceStatusBOS;
                } break;
                    
                case VAD_EOS:
                {
                    //后端点事件
                    NSLog(@"EVENT_VAD_EOS");
                    [self.vc message:@"后端点事件"];
                    self.voiceStatus = WFXFAgentVoiceStatusEOS;
                } break;
                    
                case VAD_VOL:
                {
                    //音量事件
                    NSLog(@"vol: %d", event.arg2);
                    [self.vc message:@"音量事件"];
                    self.voiceStatus = WFXFAgentVoiceStatusVOL;
                } break;
            }
        } break;
            
            
        // 处理结果
        case EVENT_RESULT:
        {
            NSLog(@"EVENT_RESULT");
            [self.vc message:@"EVENT_RESULT"];
            [self processResult:event];
        } break;
            
        case EVENT_CMD_RETURN:
        {
            NSLog(@"EVENT_CMD_RETURN");
            [self.vc message:@"EVENT_CMD_RETURN"];
        } break;
            
        case EVENT_ERROR:
        {
            NSString *error = [[NSString alloc] initWithFormat:@"Error Message：%@\nError Code：%d",event.info,event.arg1];
            NSLog(@"EVENT_ERROR: %@",error);
            [self.vc message:[NSString stringWithFormat:@"EVENT_ERROR:%@", error]];
        } break;
    }
}


//处理结果
- (void)processResult:(IFlyAIUIEvent *)event{
    
    NSString *info = event.info;
    NSData *infoData = [info dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *infoDic = [NSJSONSerialization JSONObjectWithData:infoData options:NSJSONReadingMutableContainers error:&err];
    if(!infoDic){
        NSLog(@"parse error! %@", info);
        [self.vc message:[NSString stringWithFormat:@"parse error: %@",info]];
        return;
    }
    
    NSLog(@"infoDic = %@", infoDic);
    
    NSDictionary *data = [((NSArray *)[infoDic objectForKey:@"data"]) objectAtIndex:0];
    NSDictionary *params = [data objectForKey:@"params"];
    NSDictionary *content = [(NSArray *)[data objectForKey:@"content"] objectAtIndex:0];
    NSString *sub = [params objectForKey:@"sub"];
    
    // 语义识别
    if([sub isEqualToString:@"nlp"]){
        
        NSString *cnt_id = [content objectForKey:@"cnt_id"];
        if(!cnt_id){
            NSLog(@"Content Id is empty");
            [self.vc message:@"内容为空"];
            return;
        }
        
        NSData *rltData = [event.data objectForKey:cnt_id];
        if(rltData){
            NSString *rltStr = [[NSString alloc]initWithData:rltData encoding:NSUTF8StringEncoding];
            [self.vc message:rltStr];
            
            
            [self handleResult:rltStr];
        }
    }
}

- (void)handleResult:(NSString *)res {
    NSData *data = [res dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *infoDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&err];
    if(!infoDic){
        NSLog(@"parse error! %@", res);
        return;
    }
    
    NSLog(@"infoDic = %@", infoDic);
    
}

@end
