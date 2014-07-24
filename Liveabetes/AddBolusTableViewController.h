//
//  AddBolusTableViewController.h
//  Liveabetes
//
//  Created by Dom Lamendola on 7/23/14.
//  Copyright (c) 2014 Lamendola. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Bolus.h"

@interface AddBolusTableViewController : UITableViewController

@property (strong, nonatomic) NSManagedObjectContext *context;
@property (strong, nonatomic) Bolus *createdBolus;

- (IBAction)unwindToAddBolusTable:(UIStoryboardSegue *)segue;

@end
