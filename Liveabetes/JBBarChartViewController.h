//
//  JBBarChartViewController.h
//  JBChartViewDemo
//
//  Created by Terry Worona on 11/5/13.
//  Copyright (c) 2013 Jawbone. All rights reserved.
//

#import "JBBaseChartViewController.h"

@interface JBBarChartViewController : JBBaseChartViewController

- (id)initWithContext:(NSManagedObjectContext*)context;

@property (strong, nonatomic) NSManagedObjectContext *context;

@end
