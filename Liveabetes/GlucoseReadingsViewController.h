//
//  GlucoseReadingsViewController.h
//  Liveabetes
//
//  Created by Dom Lamendola on 7/9/14.
//  Copyright (c) 2014 Lamendola. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GlucoseReadingsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSManagedObjectContext *context;
@property (strong, nonatomic) NSDateFormatter *timeFormatter;
@property (strong, nonatomic) NSDateFormatter *dateFormatter;
@property BOOL needToUpdateTable; // if target range changes in settings

- (IBAction)unwindToList:(UIStoryboardSegue *)segue;

@end
