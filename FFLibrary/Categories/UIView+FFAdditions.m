//
//  UIView+FFAdditions.m
//  FFLibrary
//
//  Created by Nang Nguyen on 10/10/15.
//  Copyright © 2015 MCFF. All rights reserved.
//

#import "UIView+FFAdditions.h"

@interface UIView (FFAddtions)
- (id) traverseResponderChainForUIViewController;
@end

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

- (UIViewController *) firstAvailableUIViewController {
    // convenience function for casting and to "mask" the recursive function
    return (UIViewController *)[self traverseResponderChainForUIViewController];
}

- (id) traverseResponderChainForUIViewController {
    id nextResponder = [self nextResponder];
    if ([nextResponder isKindOfClass:[UIViewController class]]) {
        return nextResponder;
    } else if ([nextResponder isKindOfClass:[UIView class]]) {
        return [nextResponder traverseResponderChainForUIViewController];
    } else {
        return nil;
    }
}

@end
