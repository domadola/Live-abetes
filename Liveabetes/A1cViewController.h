//
//  A1cViewController.h
//  Liveabetes
//
//  Created by Dom Lamendola on 7/16/14.
//  Copyright (c) 2014 Lamendola. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JBBaseChartViewController.h"

@interface A1cViewController : JBBaseChartViewController

@property (strong, nonatomic) NSManagedObjectContext *context;

- (IBAction)unwindToA1CView:(UIStoryboardSegue *)segue;

@end
