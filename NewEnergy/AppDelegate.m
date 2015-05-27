//
//  AppDelegate.m
//  APP01
//
//  Created by newenergy on 1/15/15.
//  Copyright (c) 2015 newenergy. All rights reserved.
//

#import "AppDelegate.h"
#import "DEMONavigationController.h"
#import "DEMOHomeViewController.h"
#import "DEMOMenuViewController.h"
#import "LoginViewController.h"
@interface AppDelegate ()<REFrostedViewControllerDelegate>
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    // Create content and menu controllers
    //
    //DEMONavigationController *navigationController = [[DEMONavigationController alloc] initWithRootViewController:[[DEMOHomeViewController alloc] init]];
    DEMONavigationController *navigationController = [[DEMONavigationController alloc] initWithRootViewController:[[LoginViewController alloc] init]];
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:0.219608 green:0.45098 blue:0.996078 alpha:1]];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    DEMOMenuViewController *menuController = [[DEMOMenuViewController alloc] initWithStyle:UITableViewStylePlain];
    
    // Create frosted view controller
    //
    REFrostedViewController *frostedViewController = [[REFrostedViewController alloc] initWithContentViewController:navigationController menuViewController:menuController];
    frostedViewController.direction = REFrostedViewControllerDirectionLeft;
    frostedViewController.liveBlurBackgroundStyle = REFrostedViewControllerLiveBackgroundStyleLight;
    frostedViewController.liveBlur = YES;
    frostedViewController.delegate = self;
    
    // Make it a root controller
    //
    self.window.rootViewController = frostedViewController;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)frostedViewController:(REFrostedViewController *)frostedViewController didRecognizePanGesture:(UIPanGestureRecognizer *)recognizer
{
    
}

- (void)frostedViewController:(REFrostedViewController *)frostedViewController willShowMenuViewController:(UIViewController *)menuViewController
{
    //NSLog(@"willShowMenuViewController");
}

- (void)frostedViewController:(REFrostedViewController *)frostedViewController didShowMenuViewController:(UIViewController *)menuViewController
{
    //NSLog(@"didShowMenuViewController");
}

- (void)frostedViewController:(REFrostedViewController *)frostedViewController willHideMenuViewController:(UIViewController *)menuViewController
{
    //NSLog(@"willHideMenuViewController");
}

- (void)frostedViewController:(REFrostedViewController *)frostedViewController didHideMenuViewController:(UIViewController *)menuViewController
{
    //NSLog(@"didHideMenuViewController");
}

@end
