//
//  AddGlucoseReadingViewController.h
//  Liveabetes
//
//  Created by Dom Lamendola on 7/9/14.
//  Copyright (c) 2014 Lamendola. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GlucoseInfo.h"
#import "GlucoseReading.h"

@interface AddGlucoseReadingViewController : UIViewController

@property (strong, nonatomic) NSManagedObjectContext *context; // must be passed to controller first
@property GlucoseReading *reading;
@property (strong, nonatomic) NSDateFormatter *timeFormatter;
@property (strong, nonatomic) NSDate *date; // date from parent view, need to change time components 

@end
