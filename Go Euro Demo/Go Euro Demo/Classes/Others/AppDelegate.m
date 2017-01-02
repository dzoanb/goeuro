//
//  AppDelegate.m
//  Go Euro Demo
//
//  Created by Joanna Bednarz (PGS Software).
//  Copyright © 2017 Joanna Bednarz (PGS Software). All rights reserved.
//

#import "AppDelegate.h"

#import "CoreDataStackController.h"
#import "TransportationViewController.h"

@interface AppDelegate ()

@property (readwrite, strong, nonatomic, nonnull) CoreDataStackController *stackController;

@end

@implementation AppDelegate

#pragma mark - Application Delegate
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.stackController = [[CoreDataStackController alloc] initWithCallback:^{
        [self completeUserInterface];
    }];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    [self.stackController save];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [self.stackController save];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [self.stackController save];
}

#pragma mark - Helpers
- (void)completeUserInterface
{
    UINavigationController *mainNavigationController = (UINavigationController *)[self.window rootViewController];
    TransportationViewController *transportationViewController = (TransportationViewController *)[mainNavigationController topViewController];
    transportationViewController.stackController = self.stackController;
}

@end
