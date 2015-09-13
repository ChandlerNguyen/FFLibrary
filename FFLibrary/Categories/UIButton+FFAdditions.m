//
//  UIButton+NLAdditions.m
//  MyApp
//
//  Created by Nguyen Nang on 4/16/15.
//  Copyright (c) 2015 Nguyen Nang. All rights reserved.
//

#import "UIButton+FFAdditions.h"
#import "NSObject+FFAdditions.h"

static char kButtonItemBlockKey;

@interface UIBarButtonItem (ExtensionPrivate)
- (void)_handleAction:(id)sender;
@end

@implementation UIButton (FFAdditions)
- (instancetype)initWithFrame:(CGRect)frame handler:(NLSenderBlock)action
{
    self = [self initWithFrame:frame];
    [self associateCopyOfValue:action withKey:&kButtonItemBlockKey];
    [self addTarget:self action:@selector(_handleAction:) forControlEvents:UIControlEventTouchUpInside];
    return self;
}

- (void)_handleAction:(id)sender {
    NLSenderBlock block = [self associatedValueForKey:&kButtonItemBlockKey];
    if (block) block(self);
}
@end
