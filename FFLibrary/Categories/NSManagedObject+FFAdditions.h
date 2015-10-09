//
//  NSManagedObject+FFAdditions.h
//  FFLibrary
//
//  Created by Nang Nguyen on 10/8/15.
//  Copyright © 2015 MCFF. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObject (FFAdditions)

+ (id)findOrCreateByAttribute:(NSString *)attribute withValue:(id)value;
+ (id)findOrCreateByAttribute:(NSString *)attribute withValue:(id)value inContext:(NSManagedObjectContext *)context;

@end
