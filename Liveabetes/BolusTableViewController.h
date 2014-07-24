//
//  BolusTableViewController.h
//  Liveabetes
//
//  Created by Dom Lamendola on 7/22/14.
//  Copyright (c) 2014 Lamendola. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BolusTableViewController : UITableViewController

@property NSManagedObjectContext *context; // set this before loading

- (IBAction)unwindToBolusTable:(UIStoryboardSegue *)segue;

@end
