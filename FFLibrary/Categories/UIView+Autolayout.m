//
//  UIView+Autolayout.m
//  MyApp
//
//  Created by Nguyen Nang on 5/15/15.
//  Copyright (c) 2015 Nguyen Nang. All rights reserved.
//

#import "UIView+Autolayout.h"

@implementation UIView (Autolayout)
+(id)autolayoutView
{
    UIView *view = [self new];
    view.translatesAutoresizingMaskIntoConstraints = NO;
    return view;
}
@end
