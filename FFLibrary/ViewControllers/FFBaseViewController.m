//
//  FFBaseViewController.m
//  FFLibrary
//
//  Created by Nang Nguyen on 9/13/15.
//  Copyright (c) 2015 MCFF. All rights reserved.
//

#import "FFBaseViewController.h"

@interface FFBaseViewController ()

@end

@implementation FFBaseViewController

FFEnableDynamicLogging

- (void)dealloc {
    FFInfo(@"%@ - %@",  NSStringFromSelector(_cmd), self);
}
- (NSString*) screenTitle
{
    return nil;
}

@end
