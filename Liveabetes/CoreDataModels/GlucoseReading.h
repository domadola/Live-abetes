//
//  GlucoseReading.h
//  Liveabetes
//
//  Created by Dom Lamendola on 7/13/14.
//  Copyright (c) 2014 Lamendola. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface GlucoseReading : NSManagedObject

@property (nonatomic, retain) NSNumber * mgdl;
@property (nonatomic, retain) NSDate * date;

@end
