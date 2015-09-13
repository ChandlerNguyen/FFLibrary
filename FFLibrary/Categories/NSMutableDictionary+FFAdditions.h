//
//  NSMutableDictionary+NLAdditions.h
//  MyApp
//
//  Created by Nguyen Nang on 5/1/15.
//  Copyright (c) 2015 Nguyen Nang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableDictionary (FFAdditions)

- (NSMutableDictionary *)appendDictionary:(NSDictionary *)other;
- (NSMutableDictionary *)appendArray:(NSArray *)other;
- (void)addEntriesFromArray:(NSArray *)array;
- (NSMutableDictionary *)addObjects:(NSObject *)firstArg, ... NS_REQUIRES_NIL_TERMINATION;
- (NSMutableDictionary *)addObjectsAndKeys:(NSObject *)firstArg, ... NS_REQUIRES_NIL_TERMINATION;

+ (NSMutableDictionary *)dictionaryWithObjects:(NSObject *)firstArg, ... NS_REQUIRES_NIL_TERMINATION;

@end
