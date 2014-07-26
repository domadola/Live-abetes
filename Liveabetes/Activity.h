//
//  Activity.h
//  Liveabetes
//
//  Created by Dom Lamendola on 7/25/14.
//  Copyright (c) 2014 Lamendola. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Activity : NSManagedObject

@property (nonatomic, retain) NSNumber * minutes;
@property (nonatomic, retain) NSDate * date;

@end
