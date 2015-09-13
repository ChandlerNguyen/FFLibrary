//
//  FFFilterManager.m
//  MyApp
//
//  Created by Nguyen Nang on 6/5/15.
//  Copyright (c) 2015 Nguyen Nang. All rights reserved.
//

#import "FFFilterManager.h"

@interface FFFilterManager ()
@end

@implementation FFFilterManager

DEF_SINGLETON( FFFilterManager )

- (instancetype)init {
    
    self = [super init];
    if (self) {
        self.filterList = @[@".css",@".png",@".jpg",@".gif"];
    }
    return self;
}

- (BOOL)shouldBlockURL:(NSURL *)url{
    return [self shouldBlockURL:url filters:self.filterList];
}

- (BOOL)shouldBlockURL:(NSURL *)url filters:(NSArray *)filters{
    for(NSString *filter in filters){
        if ([[url absoluteString] rangeOfString:filter].location!=NSNotFound)
            return YES;
    }
    return NO;
}

- (BOOL)shouldIgnoreURL:(NSURL *)url {
    return [self shoulIgnoreURL:url ignoreFilters:self.exclusionList];
}

- (BOOL)shoulIgnoreURL:(NSURL *)url ignoreFilters:(NSArray *)ignoreFilters {
    for(NSString *ignore in ignoreFilters){
        if ([[url absoluteString] rangeOfString:ignore].location!=NSNotFound)
            return YES;
    }
    return NO;
}
@end
