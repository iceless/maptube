//
//  MTAppDelegate.m
//  Maptube
//
//  Created by Bing W on 12/23/13.
//  Copyright (c) 2013 Bing W. All rights reserved.
//


#import <AVOSCloud/AVOSCloud.h>
//#import <AVOSCloudSNS/AVOSCloudSNS.h>
#import "MTAppDelegate.h"
#import "Foursquare2.h"

@implementation MTAppDelegate
#define AVOSCloudAppID  @"866uv3tezwybhrzi272qh71vrmqhi51uscntnc9y8er4j2tq"
#define AVOSCloudAppKey @"5q7r8ouyao6nvym71r2pmeq42dqz5cwc6duqh8c2yuzz3vl7"

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    //设置AVOSCloud
    
    [AVOSCloud setApplicationId:AVOSCloudAppID
                      clientKey:AVOSCloudAppKey];
    
    
    //统计应用启动情况
    [AVAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    
    
    
     

    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
