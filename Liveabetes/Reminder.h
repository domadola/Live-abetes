//
//  Reminder.h
//  Liveabetes
//
//  Created by Dom Lamendola on 7/24/14.
//  Copyright (c) 2014 Lamendola. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Reminder : NSManagedObject

@property (nonatomic, retain) NSDate * time;
@property (nonatomic, retain) NSNumber * repeatDaily;
@property (nonatomic, retain) NSNumber * isCheckBg;
@property (nonatomic, retain) NSString * notes;

@end
