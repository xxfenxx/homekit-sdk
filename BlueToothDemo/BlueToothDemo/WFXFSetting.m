//
//  WFXFSetting.m
//  BlueToothDemo
//
//  Created by ly on 2018/9/17.
//  Copyright © 2018年 ly. All rights reserved.
//

#import "WFXFSetting.h"
#import "IFlyAIUI/IFlyAIUI.h"

@implementation WFXFSetting
+ (void)setting  {
    NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachePath = [paths objectAtIndex:0];
    cachePath = [cachePath stringByAppendingString:@"/"];
    
    NSLog(@"cachePath=%@",cachePath);
    
    [IFlyAIUISetting setSaveDataLog:NO];
    [IFlyAIUISetting setLogLevel:LV_INFO];
    [IFlyAIUISetting setAIUIDir:cachePath];
    [IFlyAIUISetting setMscDir:cachePath];
}
@end
