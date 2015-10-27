//
//  ViewController.m
//  InteractiveNotification
//
//  Created by JB Yung on 2015-10-20.
//  Copyright © 2015 JB Yung. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Take Action
    UIMutableUserNotificationAction *takeAction = [[UIMutableUserNotificationAction alloc] init];
    takeAction.identifier = kReminderTakeActionKey;
    takeAction.title = NSLocalizedString(@"Take", @"Title of the take action within the notification");
    takeAction.activationMode = UIUserNotificationActivationModeBackground;
    takeAction.authenticationRequired = YES;
    
    // Skip Action
    UIMutableUserNotificationAction *skipAction = [[UIMutableUserNotificationAction alloc] init];
    skipAction.identifier = kReminderSkipActionKey;
    skipAction.title = NSLocalizedString(@"Skip", @"Title of the skip action within the notification");
    skipAction.activationMode = UIUserNotificationActivationModeBackground;
    skipAction.authenticationRequired = YES;
    
    // PostPone
    UIMutableUserNotificationAction *postponeAction = [[UIMutableUserNotificationAction alloc] init];
    postponeAction.identifier = kReminderPostponeActionKey;
    postponeAction.title = NSLocalizedString(@"postpone", @"Title of the postpone action within the notification");
    postponeAction.activationMode = UIUserNotificationActivationModeBackground;
    postponeAction.authenticationRequired = YES;
    
    UIMutableUserNotificationCategory *notificationCategory = [[UIMutableUserNotificationCategory alloc] init];
    notificationCategory.identifier = @"reminder_notification_category";
    [notificationCategory setActions:@[ takeAction, skipAction, postponeAction ] forContext:UIUserNotificationActionContextDefault];
    [notificationCategory setActions:@[ takeAction, skipAction, postponeAction ] forContext:UIUserNotificationActionContextMinimal];
    UIUserNotificationType types = UIUserNotificationTypeAlert |
                                    UIUserNotificationTypeBadge |
                                    UIUserNotificationTypeSound;
    UIUserNotificationSettings *notificationSettings = [UIUserNotificationSettings settingsForTypes:types
                                                                                         categories:[NSSet setWithObject:notificationCategory]];
    [[UIApplication sharedApplication] registerUserNotificationSettings:notificationSettings];
    
    
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.alertBody = @"This is the body";
    notification.userInfo = @{ kReminderHandled : @NO };
    notification.fireDate = [NSDate dateWithTimeIntervalSinceNow:10];
    notification.category = @"reminder_notification_category";
    notification.timeZone = [NSTimeZone defaultTimeZone];
    
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}

@end
