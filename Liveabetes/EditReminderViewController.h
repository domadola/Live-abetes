//
//  EditReminderViewController.h
//  Liveabetes
//
//  Created by Dom Lamendola on 7/24/14.
//  Copyright (c) 2014 Lamendola. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reminder.h"

@interface EditReminderViewController : UIViewController

@property (strong, nonatomic) NSManagedObjectContext *context;
@property Boolean isEditing; // else we are creating new
@property (strong, nonatomic) Reminder *reminder; // if we are editing, this is reminder to edit

@end
