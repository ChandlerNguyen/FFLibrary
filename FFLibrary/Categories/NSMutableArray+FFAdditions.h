//
//  NSMutableArray+NLAdditions.h
//  MyApp
//
//  Created by Nguyen Nang on 5/1/15.
//  Copyright (c) 2015 Nguyen Nang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (FFAdditions)

- (NSMutableArray *)append:(NSArray *)other;
- (NSMutableArray *)addObjects:(NSObject *)firstArg, ... NS_REQUIRES_NIL_TERMINATION;
- (NSMutableArray *)push:(id)object;
- (id)pop;
- (void)reverse;

@end
