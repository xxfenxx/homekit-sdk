//
//  AppDelegate.m
//  BlueToothDemo
//
//  Created by ly on 2018/9/14.
//  Copyright © 2018年 ly. All rights reserved.
//
/**
 Part one
 1. nlp: 语义理解
 
 2. tts: 语音合成
 
 3. 开发技能
    意图是什么：幸运数字是什么
    意图抽象成语料：穷举语料- 今天双鱼座的幸运数字是什么
 4. 设置槽：关键信息- {时间}{星座}的幸运数字是什么
                   {星座}{时间}的幸运数字是啥
 5. 实体：槽值的集合
 6. 对话：
 7. 不集成SDK：WebAPI 不支持流式音频上传，开发者需要在本地完成音频流的前后端点判断以及切割。

 Part two
 1. 创建应用
 2. 识别（支持配置方言）
 3. 识别率比较低：上传热词提高识别率- 燕京啤酒<->眼睛啤酒
 4. 流式识别pgs：识别过程中多次返回结果，显示纠正vad
 5. 自定义技能>自定义问答>开放问答>商店技能
    创建技能+设置词槽+添加实体
    通配实体：适用搜索技能果
    静态实体：所有App相同，可以穷举
    动态实体：每个App上传自己的实体，如联系人实体
 6. 后处理：将业务代码写在云端
 
 
 Part three
 1. https://aiui.xfyun.cn/docs/access_docs
 2. 用户隐私权限：麦克风、定位、联系人
 3. 是否开启日志
 4. 创建AIUIAgent
 5. 唤醒+开始录音=自动识别结果
 6.
 7. 
 
 **/

#import "AppDelegate.h"
#import "WFXFSetting.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    [WFXFSetting setting];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}


#pragma mark - Core Data stack

@synthesize persistentContainer = _persistentContainer;

- (NSPersistentContainer *)persistentContainer {
    // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"BlueToothDemo"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    
                    /*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                    */
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
            }];
        }
    }
    
    return _persistentContainer;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}

@end
