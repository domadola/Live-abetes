//
//  InsulinReminderTableViewController.h
//  Liveabetes
//
//  Created by Dom Lamendola on 7/22/14.
//  Copyright (c) 2014 Lamendola. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InsulinReminderTableViewController : UITableViewController

@property (strong, nonatomic) NSManagedObjectContext *context;

- (IBAction)unwindToReminderTable:(UIStoryboardSegue*)segue;

@end
