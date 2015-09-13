//
//  NSArray+NLAdditions.h
//  MyApp
//
//  Created by Nguyen Nang on 4/28/15.
//  Copyright (c) 2015 Nguyen Nang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (FFAdditions)
- (id)safeObjectAtIndex:(NSInteger)index;
- (NSArray*)shuffle;
@end
