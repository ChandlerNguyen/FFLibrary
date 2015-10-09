//
//  UISegmentedControl+FFActionBlock.h
//  FFLibrary
//
//  Created by Nang Nguyen on 9/19/15.
//  Copyright © 2015 MCFF. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UISegmentedControl (FFActionBlock)

@property (nonatomic, copy) void (^action)(NSInteger);
- (void)setAction:(void (^)(NSInteger segment))action;

@end
