//
//  Bolus.h
//  Liveabetes
//
//  Created by Dom Lamendola on 7/24/14.
//  Copyright (c) 2014 Lamendola. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class InsulinType;

@interface Bolus : NSManagedObject

@property (nonatomic, retain) NSNumber * carbs;
@property (nonatomic, retain) NSNumber * insulinUnits;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) InsulinType *insulinType;

@end
