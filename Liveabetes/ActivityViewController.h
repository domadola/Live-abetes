//
//  ActivityViewController.h
//  Liveabetes
//
//  Created by Dom Lamendola on 7/24/14.
//  Copyright (c) 2014 Lamendola. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ManagedObjectContextSingletonContainer.h"

@interface ActivityViewController : UIViewController

@property (strong, nonatomic) ManagedObjectContextSingletonContainer *contextContainer;
@property (strong, nonatomic) NSManagedObjectContext *context;

@end
