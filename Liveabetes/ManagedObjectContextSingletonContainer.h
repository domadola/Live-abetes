//
//  ManagedObjectContextSingletonContainer.h
//  Liveabetes
//
//  Created by Dom Lamendola on 7/13/14.
//  Copyright (c) 2014 Lamendola. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ManagedObjectContextSingletonContainer : NSObject

@property (strong, nonatomic) NSManagedObjectContext *context;

@end
