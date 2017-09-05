//
//  AppDelegate.m
//  ImageNotifcationsObjC
//
//  Created by Chandra Rao on 05/09/17.
//  Copyright © 2017 Chandra Rao. All rights reserved.
//

#import "AppDelegate.h"
#import <UserNotifications/UserNotifications.h>

@interface AppDelegate ()<UNUserNotificationCenterDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    application.applicationIconBadgeNumber = 0;
    [self registerPush];
    return YES;
}

- (void)registerPush {
    
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    center.delegate = self;
    
    [center requestAuthorizationWithOptions:(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge) completionHandler:^(BOOL granted, NSError * _Nullable error){
        if( !error ){
            [[UIApplication sharedApplication] registerForRemoteNotifications];
        }
    }];
}

# pragma mark UNNotificationCenter Delegate Methods

- (void)userNotificationCenter:(UNUserNotificationCenter *)center
       willPresentNotification:(UNNotification *)notification
         withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler {
    
    /**
     If your app is in the foreground when a notification arrives, the notification center calls this method to deliver the notification directly to your app. If you implement this method, you can take whatever actions are necessary to process the notification and update your app. When you finish, execute the completionHandler block and specify how you want the system to alert the user, if at all.
     
     If your delegate does not implement this method, the system silences alerts as if you had passed the UNNotificationPresentationOptionNone option to the completionHandler block. If you do not provide a delegate at all for the UNUserNotificationCenter object, the system uses the notification’s original options to alert the user.
     
     see https://developer.apple.com/reference/usernotifications/unusernotificationcenterdelegate/1649518-usernotificationcenter?language=objc
     
     **/
    
    NSLog(@"APPDELEGATE: willPresentNotification %@", notification.request.content.userInfo);
    [self loadCustomView:notification.request.content.userInfo];
    
}

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken{
    NSLog(@"======%@",deviceToken);
    
    NSString *device_Token = @"";
    
    NSString *strWithoutSpaces  = [NSString stringWithFormat:@"%@",deviceToken];
    strWithoutSpaces = [strWithoutSpaces stringByReplacingOccurrencesOfString:@" " withString:@""];
    strWithoutSpaces = [strWithoutSpaces stringByReplacingOccurrencesOfString:@"<" withString:@""];
    device_Token = [strWithoutSpaces stringByReplacingOccurrencesOfString:@">" withString:@""];
    NSLog(@"Push Token is: %@", device_Token);
    
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center
didReceiveNotificationResponse:(UNNotificationResponse *)response
         withCompletionHandler:(void (^)())completionHandler {
    
    /**
     Use this method to perform the tasks associated with your app’s custom actions. When the user responds to a notification, the system calls this method with the results. You use this method to perform the task associated with that action, if at all. At the end of your implementation, you must call the completionHandler block to let the system know that you are done processing the notification.
     
     You specify your app’s notification types and custom actions using UNNotificationCategory and UNNotificationAction objects. You create these objects at initialization time and register them with the user notification center. Even if you register custom actions, the action in the response parameter might indicate that the user dismissed the notification without performing any of your actions.
     
     If you do not implement this method, your app never responds to custom actions.
     
     see https://developer.apple.com/reference/usernotifications/unusernotificationcenterdelegate/1649501-usernotificationcenter?language=objc
     
     **/
    
    NSLog(@"APPDELEGATE: didReceiveNotificationResponse: withCompletionHandler %@", response.notification.request.content.userInfo);
        
    completionHandler();
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    NSLog(@"APPDELEGATE: didReceiveRemoteNotification %@", userInfo);
}


- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    NSLog(@"APPDELEGATE: didReceiveRemoteNotification:fetchCompletionHandler %@", userInfo);
    
    completionHandler(UIBackgroundFetchResultNoData);
    
}

- (BOOL)application:(UIApplication *)app
            openURL:(NSURL *)url
            options:(NSDictionary *)options {
    
    NSLog(@"APPDELEGATE: open url %@", url);
    return YES;
}

- (void)openURL:(NSURL*)url options:(NSDictionary<NSString *, id> *)options
completionHandler:(void (^ __nullable)(BOOL success))completion {
    NSLog(@"APPDELEGATE: openURL:options:completionHandler %@", url);
    if (completion) {
        completion(YES);
    }
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
}

- (void)loadCustomView:(NSDictionary *)dictInfo {
    
    NotificationView *notificationView = [[[NSBundle mainBundle]loadNibNamed:@"NotificationView" owner:self options:nil] objectAtIndex:0];
    
    [UIView animateWithDuration:.5 delay:2.0 options:UIViewAnimationOptionTransitionNone animations:^{
        notificationView.frame = CGRectMake(0, 0, self.window.frame.size.width, 100);
        NSString *txtNotificationtext = [[[dictInfo valueForKey:@"aps"] objectForKey:@"alert"] valueForKey:@"body"];
        notificationView.lblText.text = txtNotificationtext;
        [self.window addSubview:notificationView];
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:.5 delay:2.0 options:UIViewAnimationOptionTransitionNone animations:^{
            notificationView.frame = CGRectMake(0, -100, self.window.frame.size.width, 100);
            
        } completion:^(BOOL finished) {
            
        }];
    }];
    
    
}

@end
