//
//  InsulinViewController.h
//  Liveabetes
//
//  Created by Dom Lamendola on 7/23/14.
//  Copyright (c) 2014 Lamendola. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BolusTableViewController.h"
#import "InsulinReminderTableViewController.h"
#import "ManagedObjectContextSingletonContainer.h"

@interface InsulinViewController : UIViewController <UIPageViewControllerDataSource>

@property UIPageViewController *pageViewController;

//@property (strong, nonatomic) BolusTableViewController *bolusController;
//@property (strong, nonatomic) InsulinReminderTableViewController *reminderController;
@property (strong, nonatomic) UINavigationController *bolusController;
@property (strong, nonatomic) UINavigationController *reminderController;
@property (strong, nonatomic) ManagedObjectContextSingletonContainer *contextContainer;

@end
