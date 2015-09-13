//
//  NSMutableDictionary+NLAdditions.m
//  MyApp
//
//  Created by Nguyen Nang on 5/1/15.
//  Copyright (c) 2015 Nguyen Nang. All rights reserved.
//

#import "NSMutableDictionary+FFAdditions.h"

@implementation NSMutableDictionary (FFAdditions)
- (NSMutableDictionary *)appendDictionary:(NSDictionary *)other {
    [self addEntriesFromDictionary:other];
    return self;
}

- (NSMutableDictionary *)appendArray:(NSArray *)other {
    [self addEntriesFromArray:other];
    return self;
}

- (void)addEntriesFromArray:(NSArray *)array {
    for (NSObject* elem in array) {
        NSAssert([elem conformsToProtocol:@protocol(NSCopying)], @"Value of class %@ must conform to NSCopying, when append to a dictionary without a key.", elem.class);
        [self setObject:elem forKey:(id<NSCopying>)elem];
    }
}

- (NSMutableDictionary *)addObjects:(NSString *)firstArg, ... NS_REQUIRES_NIL_TERMINATION {
    va_list args;
    va_start(args, firstArg);
    [self fillWithObject:firstArg andObjects:args];
    va_end(args);
    return self;
}

- (NSMutableDictionary *)addObjectsAndKeys:(NSObject *)firstArg, ... NS_REQUIRES_NIL_TERMINATION {
    va_list args;
    va_start(args, firstArg);
    id<NSCopying> key;
    for (id arg=firstArg; arg != nil; arg=va_arg(args, NSObject*)) {
        if (key == nil) {
            key = (id<NSCopying>)arg;
        } else {
            [self setObject:arg forKey:key];
            key = nil;
        }
    }
    va_end(args);
    return self;
}

+ (NSMutableDictionary *)dictionaryWithObjects:(NSObject *)firstArg, ... NS_REQUIRES_NIL_TERMINATION {
    va_list args;
    va_start(args, firstArg);
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    [dict fillWithObject:firstArg andObjects:args];
    va_end(args);
    return dict;
}

- (void)fillWithObject:(NSObject *)firstArg andObjects:(va_list)args {
    for (NSObject* arg=firstArg; arg != nil; arg=va_arg(args, NSString*)) {
        NSAssert([arg conformsToProtocol:@protocol(NSCopying)], @"Value of class %@ must conform to NSCopying, when append to a dictionary without a key.", arg.class);
        [self setObject:arg forKey:(id<NSCopying>)arg];
    }
}
@end
