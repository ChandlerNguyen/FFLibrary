//
//  FFConfigManager.h
//  FFLibrary
//
//  Created by Nang Nguyen on 9/13/15.
//  Copyright (c) 2015 MCFF. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FFConfigManager : NSObject

+ (instancetype)instance;
- (NSBundle *) mainBundle;
@end
