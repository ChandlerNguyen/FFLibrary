//
// Created by Nang Nguyen on 9/12/15.
// Copyright (c) 2015 MCFF. All rights reserved.
//

#import "FFAppDelegate.h"

@interface FFAppDelegate()

@end

@implementation FFAppDelegate {

}

FFEnableDynamicLogging

#pragma mark - UIApplicationDelegate methods

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [FFLogger initLogger];
    FFInfo(@"After initLogger: %@", self.class);
    
    [self customizingApplication];
    [self configWindow];

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
// TODO
//    [[ITSUserManager instance] isAuthenticatedWithHandler:^(ITSServiceResult *result) {
//        if (!result.boolResult) {
//            [self.appConfigMgr.navigationManager gotoWelcome];
//        }
//    }];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
// TODO
//    ITSWarn(@"");
//    [[NSNotificationCenter defaultCenter] postNotificationName:kITSNotificationMemoryWarning object:nil];
}

#pragma mark - public methods that may be overridden by subclasses

- (void) configWindow
{
//    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
//    // TODO
////    [[ITSUserManager instance] isAuthenticatedWithHandler:^(ITSServiceResult *result) {
////        UIViewController *nextController = result.boolResult ?
////                self.appConfigMgr.navigationManager.mainViewController :
////                self.appConfigMgr.navigationManager.welcomeViewController;
////        self.window.rootViewController = [[ITSNavigationController alloc] initWithRootViewController:nextController];
////        [self.window makeKeyAndVisible];
////    }];
//    self.window.backgroundColor = [UIColor whiteColor];
}

- (void) customizingApplication
{
    //TODO
    FFAssertAbstract();
}

@end