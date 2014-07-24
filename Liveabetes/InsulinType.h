//
//  InsulinType.h
//  Liveabetes
//
//  Created by Dom Lamendola on 7/23/14.
//  Copyright (c) 2014 Lamendola. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Bolus;

@interface InsulinType : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *insulinType;
@end

@interface InsulinType (CoreDataGeneratedAccessors)

- (void)addInsulinTypeObject:(Bolus *)value;
- (void)removeInsulinTypeObject:(Bolus *)value;
- (void)addInsulinType:(NSSet *)values;
- (void)removeInsulinType:(NSSet *)values;

@end
