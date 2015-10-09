//
//  UISegmentedControl+FFActionBlock.m
//  FFLibrary
//
//  Created by Nang Nguyen on 9/19/15.
//  Copyright © 2015 MCFF. All rights reserved.
//

#import "UISegmentedControl+FFActionBlock.h"
#import <objc/message.h>

static void *actionKey = &actionKey;

@implementation UISegmentedControl (FFActionBlock)

- (void)setup {
    [self addTarget:self action:@selector(action:) forControlEvents:UIControlEventValueChanged];
}

- (void)action:(UISegmentedControl *)sender {
    if (sender.action) {
        sender.action(sender.selectedSegmentIndex);
    }
}

- (void)setAction:(void (^)(NSInteger))action {
    objc_setAssociatedObject(self, actionKey, action, OBJC_ASSOCIATION_RETAIN);
    [self setup];
}

- (void (^)(NSInteger))action {
    id act = objc_getAssociatedObject(self, actionKey);
    return act;
}


@end
