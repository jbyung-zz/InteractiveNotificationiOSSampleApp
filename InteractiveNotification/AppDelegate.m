//
//  AppDelegate.m
//  InteractiveNotification
//
//  Created by JB Yung on 2015-10-20.
//  Copyright © 2015 JB Yung. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
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

- (void)application:(UIApplication *)application didReceiveLocalNotification:(nonnull UILocalNotification *)notification {
    NSDictionary *userInfo = notification.userInfo;
    NSNumber *reminderHandled = [userInfo objectForKey:kReminderHandled];
    if (reminderHandled) {
        BOOL handled = [reminderHandled boolValue];
        if (handled) {
            // Noop
        } else {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@""
                                                                                     message:@""
                                                                              preferredStyle:UIAlertControllerStyleActionSheet];
            UIAlertAction *skipAction = [UIAlertAction actionWithTitle:@"Skip Medication" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self presentConfirmationAlert:@"Medication skipped"];
            }];
            UIAlertAction *postponseAction = [UIAlertAction actionWithTitle:@"Postpone" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self presentConfirmationAlert:@"Medication postpone. TODO: Show postpone UI"];
            }];
            UIAlertAction *takeAction = [UIAlertAction actionWithTitle:@"Take Now" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self presentConfirmationAlert:@"Medication taken"];
            }];
            [alertController addAction:skipAction];
            [alertController addAction:postponseAction];
            [alertController addAction:takeAction];
            [[[UIApplication sharedApplication].delegate window].rootViewController presentViewController:alertController
                                                                                                animated:YES
                                                                                               completion:nil];
        }
    }
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(nullable NSString *)identifier forLocalNotification:(nonnull UILocalNotification *)notification completionHandler:(nonnull void (^)())completionHandler {
    NSLog(@"First Method - Identifier : %@", identifier);
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(nullable NSString *)identifier forLocalNotification:(nonnull UILocalNotification *)notification withResponseInfo:(nonnull NSDictionary *)responseInfo completionHandler:(nonnull void (^)())completionHandler {

    // Random API endpint used in order to test the
    NSURL *url = [NSURL URLWithString:@"http://api.randomuser.me/?results=1"];
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    request.HTTPMethod = @"GET";
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error"
                                                                                         message:@"Internet/Server Error. Try again later by killing and relaunching the app."
                                                                                  preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK"
                                                                 style:UIAlertActionStyleDefault
                                                               handler:nil];
                [alertController addAction:action];
                [[[UIApplication sharedApplication].delegate window].rootViewController presentViewController:alertController
                                                                                                     animated:YES
                                                                                                   completion:nil];
                completionHandler();
            });
        } else if (data) {
            NSLog(@"Data Successfully Received");
            [self handleNotificationAction:identifier
                                  withInfo:(NSDictionary *)responseInfo];
            completionHandler();
        }
    }];
    [dataTask resume];
}

- (void)presentConfirmationAlert:(NSString *)msg {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@""
                                                                             message:msg
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:action];
    [[[UIApplication sharedApplication].delegate window].rootViewController presentViewController:alertController
                                                                                         animated:YES
                                                                                       completion:nil];
}

- (void)handleNotificationAction:(NSString *)identifier withInfo:(NSDictionary *)info {
    dispatch_async(dispatch_get_main_queue(), ^{
        UILocalNotification *confirmation = [[UILocalNotification alloc] init];
        if ([identifier isEqualToString:kReminderSkipActionKey]) {
            confirmation.alertBody = @"Medication skipped";
        } else if ([identifier isEqualToString:kReminderTakeActionKey]) {
            confirmation.alertBody = @"Mediation successfully taken";
        } else {
            confirmation.alertBody = @"Error occurred";
        }
        confirmation.userInfo = @{ kReminderHandled : @YES };
        confirmation.fireDate = [NSDate dateWithTimeIntervalSinceNow:0];
        confirmation.hasAction = NO;
        [[UIApplication sharedApplication] scheduleLocalNotification:confirmation];        
    });
}

@end
