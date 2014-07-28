//
//  AppDelegate.h
//  Liveabetes
//
//  Created by Dom Lamendola on 7/2/14.
//  Copyright (c) 2014 Lamendola. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UIManagedDocument *document;
@property (strong, nonatomic) NSURL *documentURL;
@property (strong, nonatomic) NSManagedObjectContext *context;
@property BOOL contextLoaded;

@end
