//
//  NSArray+NLAdditions.m
//  MyApp
//
//  Created by Nguyen Nang on 4/28/15.
//  Copyright (c) 2015 Nguyen Nang. All rights reserved.
//

#import "NSArray+FFAdditions.h"

@implementation NSArray (FFAdditions)

- (id)safeObjectAtIndex:(NSInteger)index
{
    if ( index < 0 )
        return nil;
    
    if ( index >= self.count )
        return nil;
    
    return [self objectAtIndex:index];
}

- (NSArray*)shuffle {
    NSMutableArray *temp = [[NSMutableArray alloc] initWithArray:self];
    
    for(NSUInteger i = [self count]; i > 1; i--) {
        NSUInteger j = arc4random_uniform((uint32_t)i);
        [temp exchangeObjectAtIndex:i-1 withObjectAtIndex:j];
    }
    
    return [NSArray arrayWithArray:temp];
}
@end
