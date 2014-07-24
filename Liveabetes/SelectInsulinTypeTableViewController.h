//
//  SelectInsulinTypeTableViewController.h
//  Liveabetes
//
//  Created by Dom Lamendola on 7/23/14.
//  Copyright (c) 2014 Lamendola. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InsulinType.h"

@interface SelectInsulinTypeTableViewController : UITableViewController

@property (strong, nonatomic) NSManagedObjectContext *context;
@property (strong, nonatomic) InsulinType *selectedInsulinType;

- (IBAction)unwindToSelectInsulinTypeTable:(UIStoryboardSegue *)segue;

@end
