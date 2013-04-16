//
//  RBAppDelegate.m
//  SimpleMailbox
//
//  Created by Andrey Toropchin on 15.04.13.
//  Copyright (c) 2013 Andrey Toropchin. All rights reserved.
//

#import "RBAppDelegate.h"
#import "RBViewController.h"
#import "RBDataProvider.h"

@implementation RBAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window.frame = [UIScreen mainScreen].bounds;
    self.viewController = [[RBViewController alloc] initWithNibName:@"RBViewController" bundle:nil];
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];

    return YES;
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [[RBDataProvider sharedProvider] save];
}

@end
