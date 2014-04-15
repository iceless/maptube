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

#import "MTFirstViewController.h"
#import "MTHomeViewController.h"
#import "MTProfileViewController.h"
#import "MTAddPlaceViewController.h"
#import "MTRootTabBarController.h"
#import "MTPlace.h"

@implementation MTAppDelegate
#define AVOSCloudAppID  @"ni8qovqmlwvnsck9zfk5c4yaj88yku6kpdfz7aah0ip5wqh4"
#define AVOSCloudAppKey @"9ttfy96pnup3gsbb902frx1hkyhy81mwwboye3emp74gkipd"

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    [self initAVOSCloudWithLaunchOptions:launchOptions];
    [self initFoursquare];
    [self initViewControllers];
   
    
    return YES;
}

- (void)initViewControllers
{
    MTHomeViewController *homeVC = [[MTHomeViewController alloc] init];
    homeVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Home" image:[UIImage imageNamed:@"home.png"] selectedImage:nil];
    UINavigationController *homeNAV = [[UINavigationController alloc] initWithRootViewController:homeVC];
    
    
    
    MTProfileViewController *profileVC = [[MTProfileViewController alloc] init];
    profileVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Profile" image:[UIImage imageNamed:@"profile.png"] selectedImage:nil];
    UINavigationController *profileNAV = [[UINavigationController alloc] initWithRootViewController:profileVC];
    
    MTAddPlaceViewController *addPlaceVC = [[MTAddPlaceViewController alloc] init];
    addPlaceVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Add" image:[UIImage imageNamed:@"place.png"] selectedImage:nil];
    UINavigationController *addPlaceNAV = [[UINavigationController alloc] initWithRootViewController:addPlaceVC];
    
    MTRootTabBarController *tabVC = [[MTRootTabBarController alloc] init];
    tabVC.viewControllers = @[homeNAV, addPlaceNAV,profileNAV];
    
    UINavigationController *rootNAV = [[UINavigationController alloc] initWithRootViewController:tabVC];
    rootNAV.navigationBarHidden = YES;
    self.window.rootViewController = rootNAV;
    
}

- (void)initAVOSCloudWithLaunchOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    //设置AVOSCloud
    [AVOSCloud setApplicationId:AVOSCloudAppID
                      clientKey:AVOSCloudAppKey];
    
    
    //统计应用启动情况
    [AVAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    //[MTPlace registerSubclass];
}

- (void)initFoursquare
{
    [Foursquare2 setupFoursquareWithClientId:@"XNXP3PLBA3LDVIT3OFQVWYQWMTHKIJHFWWSKRZJMVLXIJPUJ"
                                      secret:@"GYZFXWJVXBB1B2BFOQDKWJAQ4JXA5QIJNKHOJJHCRYRC0KWZ"
                                 callbackURL:@"www.mapgis.com"];
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
