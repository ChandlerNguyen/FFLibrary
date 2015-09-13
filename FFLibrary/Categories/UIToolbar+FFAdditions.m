//
//  UIToolbar+NLAdditions.m
//  MyApp
//
//  Created by Nguyen Nang on 4/22/15.
//  Copyright (c) 2015 Nguyen Nang. All rights reserved.
//

#import "UIToolbar+FFAdditions.h"

@implementation UIToolbar (FFAdditions)

- (void)makeTransparent {
    [self setBackgroundImage:[UIImage new]
           forToolbarPosition:UIBarPositionAny
                   barMetrics:UIBarMetricsDefault];
    [self setShadowImage:[UIImage new]
       forToolbarPosition:UIToolbarPositionAny];
}

- (void)setColorForBackground:(UIColor*)color {
    self.translucent=NO;
    self.barTintColor=color;
}

@end
