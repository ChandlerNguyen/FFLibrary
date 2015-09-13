//
//  NSTimer+NLAdditions.h
//  MyApp
//
//  Created by Nguyen Nang on 4/18/15.
//  Copyright (c) 2015 Nguyen Nang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (FFAdditions)

+(id)scheduledTimerWithTimeInterval:(NSTimeInterval)inTimeInterval actionHandler:(void (^)())inBlock repeats:(BOOL)inRepeats;
+(id)timerWithTimeInterval:(NSTimeInterval)inTimeInterval actionHandler:(void (^)())inBlock repeats:(BOOL)inRepeats;

@end
