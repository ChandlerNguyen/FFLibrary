//
//  UIBarButtonItem+NLAdditions.m
//  MyApp
//
//  Created by Nguyen Nang on 4/16/15.
//  Copyright (c) 2015 Nguyen Nang. All rights reserved.
//

#import "UIBarButtonItem+FFAdditions.h"

static char kBarButtonItemBlockKey;

@interface UIBarButtonItem (ExtensionPrivate)
- (void)_handleAction:(UIBarButtonItem *)sender;
@end

@implementation UIBarButtonItem (FFAdditions)

- (instancetype)initWithBarButtonSystemItem:(UIBarButtonSystemItem)systemItem handler:(NLSenderBlock)action {
    self = [self initWithBarButtonSystemItem:systemItem target:self action:@selector(_handleAction:)];
    [self associateCopyOfValue:action withKey:&kBarButtonItemBlockKey];
    return self;
}

- (instancetype)initWithImage:(UIImage *)image style:(UIBarButtonItemStyle)style handler:(NLSenderBlock)action {
    self = [self initWithImage:image style:style target:self action:@selector(_handleAction:)];
    [self associateCopyOfValue:action withKey:&kBarButtonItemBlockKey];
    return self;
}

- (instancetype)initWithTitle:(NSString *)title style:(UIBarButtonItemStyle)style handler:(NLSenderBlock)action {
    self = [self initWithTitle:title style:style target:self action:@selector(_handleAction:)];
    [self associateCopyOfValue:action withKey:&kBarButtonItemBlockKey];
    return self;
}

- (void)_handleAction:(UIBarButtonItem *)sender {
    NLSenderBlock block = [self associatedValueForKey:&kBarButtonItemBlockKey];
    if (block) block(self);
}

@end
