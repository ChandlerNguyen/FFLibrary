//
//  FFHandlerObject.m
//  MyApp
//
//  Created by Nguyen Nang on 1/30/15.
//  Copyright (c) 2015 Nguyen Nang. All rights reserved.
//

#import "FFHandlerObject.h"

@interface FFHandlerObject ()

@end

@implementation FFHandlerObject

FFEnableDynamicLogging

- (void)dealloc {
    FFInfo(@"%@ %@", self.description, NSStringFromSelector(_cmd));
}

- (NSString *)description {

    return [NSString stringWithFormat:
            @"cmd - %@, callback - %@, identifier - %lu, targetClass - %@",
            self.tcmd, self.callback, (unsigned long)self.identifier, self.className];
}

- (BOOL)isEqual:(FFHandlerObject *)other {

    if(other == self || [super isEqual:other] || [self.target isEqual:other.target] || self.identifier == other.identifier){
        return YES;
    }
    return NO;
}

- (NSUInteger)hash {
    return self.identifier;
}

@end
