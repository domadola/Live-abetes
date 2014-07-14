//
//  ManagedObjectContextSingletonContainer.m
//  Liveabetes
//
//  Created by Dom Lamendola on 7/13/14.
//  Copyright (c) 2014 Lamendola. All rights reserved.
//

#import "ManagedObjectContextSingletonContainer.h"
#import "AppDelegate.h"

@implementation ManagedObjectContextSingletonContainer

- (NSManagedObjectContext *) context
{
    if (_context != nil) {
        return _context;
    }
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    _context = appDelegate.context;
    return _context;
}

@end
