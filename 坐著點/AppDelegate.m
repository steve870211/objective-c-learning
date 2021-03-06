//
//  AppDelegate.m
//  坐著點
//
//  Created by 許佳航 on 2016/3/8.
//  Copyright © 2016年 許佳航. All rights reserved.
//

#import "AppDelegate.h"
#import "Order.h"
#import <AudioToolbox/AudioToolbox.h>

@interface AppDelegate ()

@property (nonatomic) BOOL isLogined;

@end

@implementation AppDelegate

-(BOOL) isLogined {
    return _isLogined;
}

-(void) login {
    self.isLogined = true;
}

-(void) logout {
    self.isLogined = false;
}

-(void)prepareSound:(NSString *)name {
    SystemSoundID click;
    NSURL *sound = [[NSBundle mainBundle]URLForResource:name withExtension:@"mp3"];
    AudioServicesCreateSystemSoundID((CFURLRef)CFBridgingRetain(sound),&click);
    AudioServicesPlaySystemSound(click);
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    NSFileManager *fm = [[NSFileManager alloc]init];
    
    // 取得AccountSave.plist的路徑
    NSString *src = [[NSBundle mainBundle]pathForResource:@"AccountSave" ofType:@"plist"];
    // 取得要複製到的位置
    NSString *dst = [NSString stringWithFormat:@"%@/Documents/AccountSave.plist",NSHomeDirectory()];
    // 檢查目的路徑的檔案是否存在，不存在則複製檔案
    if (![fm fileExistsAtPath:dst]) {
        [fm copyItemAtPath:src toPath:dst error:nil];
    }
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
