//
//  NSMutableArray+NLAdditions.m
//  MyApp
//
//  Created by Nguyen Nang on 5/1/15.
//  Copyright (c) 2015 Nguyen Nang. All rights reserved.
//

#import "NSMutableArray+FFAdditions.h"

@implementation NSMutableArray (FFAdditions)
- (NSMutableArray *)append:(NSArray *)other {
    [self addObjectsFromArray:other];
    return self;
}

- (NSMutableArray *)addObjects:(NSObject *)firstArg, ... NS_REQUIRES_NIL_TERMINATION {
    va_list args;
    va_start(args, firstArg);
    for (NSObject* arg=firstArg; arg != nil; arg=va_arg(args, NSObject*)) {
        [self addObject:arg];
    }
    va_end(args);
    return self;
}

- (NSMutableArray *)push:(id)object {
    [self addObject:object];
    return self;
}

- (id)pop {
    id lastObject = [self lastObject];
    [self removeLastObject];
    return lastObject;
}

// link: http://stackoverflow.com/a/586483
- (void)reverse {
    if ([self count] <= 1) {
        return;
    }
    NSUInteger i = 0;
    NSUInteger j = self.count - 1;
    while (i < j) {
        [self exchangeObjectAtIndex:i
                  withObjectAtIndex:j];
        
        i++;
        j--;
    }
}
@end
