//
//  AppDelegate.m
//  Liveabetes
//
//  Created by Dom Lamendola on 7/2/14.
//  Copyright (c) 2014 Lamendola. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    UIPageControl *pageControl = [UIPageControl appearance];
    pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    pageControl.currentPageIndicatorTintColor = [UIColor blackColor];
    pageControl.backgroundColor = [UIColor whiteColor];
    // Override point for customization after application launch.
    [self initializeManagedDocument];
    
    NSDictionary *appDefaults = [NSDictionary
                                 dictionaryWithObjects:@[[NSNumber numberWithInt:120], [NSNumber numberWithInt:80], [NSNumber numberWithInt:60]] forKeys:@[@"TargetRangeHigh", @"TargetRangeLow", @"ActivityGoal"]];
    
    [[NSUserDefaults standardUserDefaults] registerDefaults:appDefaults];
    
    return YES;
}

- (void)initializeManagedDocument
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *documentsDirectory = [[fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] firstObject];
    NSString *documentName = @"LivabetesDataFile_1";
    NSURL *url = [documentsDirectory URLByAppendingPathComponent:documentName];
    self.documentURL = url;
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:[url path]];
    UIManagedDocument *managedDocument = [[UIManagedDocument alloc] initWithFileURL:url];
    if (fileExists) {
        [managedDocument openWithCompletionHandler:^(BOOL success) {
            self.document = managedDocument;
            NSLog(@"done opening document.");
            [self initializeManagedObjectContext]; }];
        NSLog(@"opening managed document.");
    } else {
        [managedDocument saveToURL:url forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success) {
            self.document = managedDocument;
            NSLog(@"done creating document.");
            [self initializeManagedObjectContext]; }];
        NSLog(@"creating managed document.");
    }
}

// assumes self.document has been initialized
- (void)initializeManagedObjectContext
{
    if (self.document.documentState == UIDocumentStateNormal) {
        self.context = self.document.managedObjectContext; // start doing Core Data stuff with context
        NSLog(@"NSManagedObjectContext created.");
    } else {
        NSLog(@"NSManagedObjectContext not created. Document State: %i", self.document.documentState);
    }
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    
    [self.document saveToURL:self.documentURL forSaveOperation:UIDocumentSaveForOverwriting completionHandler:nil];
    //TODO: remove this. only neccessary for running on simulator, otherwise autosaved.
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

- (void)application:(UIApplication *)application
didReceiveLocalNotification:(UILocalNotification *)notification
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                        message:notification.alertBody
                                                       delegate:self cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
    [alertView show];
}

@end
