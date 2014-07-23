//
//  AddA1cViewController.h
//  Liveabetes
//
//  Created by Dom Lamendola on 7/21/14.
//  Copyright (c) 2014 Lamendola. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "A1c.h"

@interface AddA1cViewController : UIViewController

@property (strong, nonatomic) NSManagedObjectContext *context;
@property (strong, nonatomic) A1c *a1c;

@end
