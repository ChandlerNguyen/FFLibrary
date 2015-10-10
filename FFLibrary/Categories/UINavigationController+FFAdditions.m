//
//  UINavigationController+NLAdditions.m
//  MyApp
//
//  Created by Nguyen Nang on 4/16/15.
//  Copyright (c) 2015 Nguyen Nang. All rights reserved.
//

#import "UINavigationController+FFAdditions.h"

@implementation UINavigationController (FFAdditions)

- (void)setBackgroundFromColor:(UIColor*)color titleColor:(UIColor*)titleColor colorOfBackButton:(UIColor*)backButtonColor {
    UINavigationBar *navBar = self.navigationBar;
    
    if (!IOS7_OR_LATER) {
        UIImage *bgImage = [UIImage createImageWithColor:color];
        [navBar setBackgroundImage:bgImage forBarMetrics:UIBarMetricsDefault];
        navBar.barStyle = UIBarStyleBlack;
        navBar.translucent = NO;
        navBar.opaque = YES;
    } else {
        navBar.barTintColor = color;
        navBar.tintColor = backButtonColor;
        navBar.titleTextAttributes = @{ NSForegroundColorAttributeName : titleColor };
    }
}

- (void)makeTransparent {
    [self.navigationBar setBackgroundImage:[UIImage new]
                             forBarMetrics:UIBarMetricsDefault];
    self.navigationBar.shadowImage = [UIImage new];
    self.navigationBar.translucent = YES;
}

- (UIViewController*)currentViewController {
    return [self.viewControllers lastObject];
}

@end
