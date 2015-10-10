//
//  UIView+FFAdditions.m
//  FFLibrary
//
//  Created by Nang Nguyen on 10/10/15.
//  Copyright © 2015 MCFF. All rights reserved.
//

#import "UIView+FFAdditions.h"

@implementation UIView (FFAdditions)

- (UIViewController *)currentTopViewController
{
    UIViewController *topVC = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
    while (topVC.presentedViewController)
    {
        topVC = topVC.presentedViewController;
    }
    return topVC;
}

@end
