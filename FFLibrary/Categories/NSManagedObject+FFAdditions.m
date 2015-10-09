//
//  NSManagedObject+FFAdditions.m
//  FFLibrary
//
//  Created by Nang Nguyen on 10/8/15.
//  Copyright © 2015 MCFF. All rights reserved.
//

#import "NSManagedObject+FFAdditions.h"
#import "QMDBStorage.h"

@implementation NSManagedObject (FFAdditions)

+ (id)findOrCreateByAttribute:(NSString *)attribute withValue:(id)value
{
    return [self findOrCreateByAttribute:attribute
                               withValue:value
                               inContext:[NSManagedObjectContext QM_contextForCurrentThread]];
}

+ (id)findOrCreateByAttribute:(NSString *)attribute withValue:(id)value inContext:(NSManagedObjectContext *)context
{
    id object = [self QM_findFirstByAttribute:attribute withValue:value];
    
    if (nil == object)
    {
        object = [self QM_createInContext:context];
        [object setValue:value forKey:attribute];
    }
    
    return object;
}

@end
