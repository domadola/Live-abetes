//
//  OverviewTableViewController.h
//  Liveabetes
//
//  Created by Dom Lamendola on 7/27/14.
//  Copyright (c) 2014 Lamendola. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OverviewTableViewController : UITableViewController

@property (strong, nonatomic) NSManagedObjectContext *context;
@property (strong, nonatomic) NSDate *date;
@property BOOL dateNeedsUpdate;

- (IBAction)unwindToOverview:(UIStoryboardSegue*)segue;

@end
