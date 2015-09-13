//
//  FFConfigManager.m
//  FFLibrary
//
//  Created by Nang Nguyen on 9/13/15.
//  Copyright (c) 2015 MCFF. All rights reserved.
//

#import "FFConfigManager.h"

@implementation FFConfigManager

+ (instancetype)instance
{
    static FFConfigManager *_instance = nil;
    
    @synchronized(self) {
        if (_instance == nil) {
            _instance = [[self alloc] init];
        }
    }
    
    return  _instance;
}

- (NSBundle *)mainBundle
{
    return [NSBundle mainBundle];
}

@end
