//
//  UIViewController+UINavigationBar.m
//  MyApp
//
//  Created by Nguyen Nang on 4/16/15.
//  Copyright (c) 2015 Nguyen Nang. All rights reserved.
//

#import "UIViewController+UINavigationBar.h"
#import "UIBarButtonItem+FFAdditions.h"
#import "UINavigationItem+Loading.h"
#import "UINavigationController+FFAdditions.h"
#import "UIButton+FFAdditions.h"

@implementation UINavigationBar (UINavigationBar)


@end

#pragma mark -
@implementation UIViewController (UINavigationBar)

- (void)showNavigationBarAnimated:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    if (self.tabBarController) {
        [self.tabBarController.navigationController setNavigationBarHidden:NO animated:animated];
    }
}

- (void)hideNavigationBarAnimated:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    if (self.tabBarController) {
        [self.tabBarController.navigationController setNavigationBarHidden:YES animated:animated];
    }
}

- (void)showBarButton:(NSInteger)position title:(NSString *)name performAction:(SEL)selector
{
    if (self.tabBarController) {
        if ( position == NLNavButtonBarPositionLeft ) {
            self.tabBarController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:name
                                                                                     style:UIBarButtonItemStylePlain
                                                                                    target:self
                                                                                    action:selector];
        } else {
            self.tabBarController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:name
                                                                                      style:UIBarButtonItemStylePlain
                                                                                     target:self
                                                                                     action:selector];
        }
    } else {
        if ( position == NLNavButtonBarPositionLeft ) {
            self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:name
                                                                                     style:UIBarButtonItemStylePlain
                                                                                    target:self
                                                                                    action:selector];
        } else {
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:name
                                                                                      style:UIBarButtonItemStylePlain
                                                                                     target:self
                                                                                     action:selector];
        }
    }
    
}

- (void)showBarButton:(NSInteger)position title:(NSString *)name performActionUsingBlock:(NLSenderBlock)block
{
    if (self.tabBarController) {
        if ( position == NLNavButtonBarPositionLeft ) {
            self.tabBarController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:name
                                                                                     style:UIBarButtonItemStylePlain
                                                                                   handler:block];
        } else {
            self.tabBarController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:name
                                                                                      style:UIBarButtonItemStylePlain
                                                                                    handler:block];
        }
    } else {
        if ( position == NLNavButtonBarPositionLeft ) {
            self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:name
                                                                                     style:UIBarButtonItemStylePlain
                                                                                   handler:block];
        } else {
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:name
                                                                                      style:UIBarButtonItemStylePlain
                                                                                    handler:block];
        }
    }
    
}

- (void)showBarButton:(NSInteger)position image:(UIImage *)image performAction:(SEL)selector
{
    UIButton * button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
    button.contentMode = UIViewContentModeScaleAspectFit;
    button.backgroundColor = [UIColor clearColor];
    [button setImage:image forState:UIControlStateNormal];
    
    if (self.tabBarController) {
        if ( position == NLNavButtonBarPositionLeft ) {
            [button addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
            self.tabBarController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
        } else {
            [button addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
            self.tabBarController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
        }
    } else {
        if ( position == NLNavButtonBarPositionLeft ) {
            [button addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
            self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
        } else {
            [button addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
        }
    }
    
}

- (void)showBarButton:(NSInteger)position image:(UIImage *)image performActionUsingBlock:(NLSenderBlock)block
{
    UIButton * button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height) handler:block];
    button.contentMode = UIViewContentModeScaleAspectFit;
    button.backgroundColor = [UIColor clearColor];
    [button setImage:image forState:UIControlStateNormal];
    
    if (self.tabBarController) {
        if (position == NLNavButtonBarPositionLeft ) {
            self.tabBarController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
        } else {
            self.tabBarController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
        }
    } else {
        if (position == NLNavButtonBarPositionLeft ) {
            self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
        } else {
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
        }
    }
    
}

- (void)showBarButton:(NSInteger)position system:(UIBarButtonSystemItem)index performAction:(SEL)selector
{
    if (self.tabBarController) {
        if ( position == NLNavButtonBarPositionLeft ) {
            self.tabBarController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:index
                                                                                                  target:self
                                                                                                  action:selector];
        } else {
            self.tabBarController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:index
                                                                                                   target:self
                                                                                                   action:selector];
        }
    } else {
        if ( position == NLNavButtonBarPositionLeft ) {
            self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:index
                                                                                                  target:self
                                                                                                  action:selector];
        } else {
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:index
                                                                                                   target:self
                                                                                                   action:selector];
        }
    }
    
}

- (void)showBarButton:(NSInteger)position system:(UIBarButtonSystemItem)index performActionUsingBlock:(NLSenderBlock)block
{
    if (self.tabBarController) {
        if ( position == NLNavButtonBarPositionLeft ) {
            self.tabBarController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:index handler:block];
        } else {
            self.tabBarController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:index handler:block];
        }
    } else {
        if ( position == NLNavButtonBarPositionLeft ) {
            self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:index handler:block];
        } else {
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:index handler:block];
        }
    }
    
}

- (void)navigationBarWithSegmentedControl:(UISegmentedControl*)segmentedControl {
    if (self.tabBarController) {
        self.tabBarController.navigationItem.titleView = segmentedControl;
    } else {
        self.navigationItem.titleView = segmentedControl;
    }
}

- (void)showBarButton:(NSInteger)position custom:(UIView *)view
{
    if (self.tabBarController) {
        if ( position == NLNavButtonBarPositionLeft ) {
            self.tabBarController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:view];
        } else {
            self.tabBarController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:view];
        }
    } else {
        if ( position == NLNavButtonBarPositionLeft ) {
            self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:view];
        } else {
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:view];
        }
    }
    
}

- (void)hideBarButton:(NSInteger)position
{
    if (self.tabBarController) {
        if ( position == NLNavButtonBarPositionLeft ) {
            self.tabBarController.navigationItem.leftBarButtonItem = nil;
        } else {
            self.tabBarController.navigationItem.rightBarButtonItem = nil;
        }
    } else {
        if ( position == NLNavButtonBarPositionLeft ) {
            self.navigationItem.leftBarButtonItem = nil;
        } else {
            self.navigationItem.rightBarButtonItem = nil;
        }
    }
    
}

- (void)showLoadingIndicatorOnNavigationBarAtPosition:(NSInteger)position {
    if (self.tabBarController) {
        if (position == NLNavButtonBarPositionLeft) {
            [self.tabBarController.navigationItem startAnimatingAt:ANNavBarLoaderPositionLeft];
        } else {
            [self.tabBarController.navigationItem startAnimatingAt:ANNavBarLoaderPositionRight];
        }
    } else {
        if (position == NLNavButtonBarPositionLeft) {
            [self.navigationItem startAnimatingAt:ANNavBarLoaderPositionLeft];
        } else {
            [self.navigationItem startAnimatingAt:ANNavBarLoaderPositionRight];
        }
    }
}

- (void)setColorsForNavigationBarWithBackground:(UIColor*)backgroundColor titleColor:(UIColor*)titleColor
                              colorOfBackButton:(UIColor*)tintColor {
    if (self.tabBarController) {
        [self.tabBarController.navigationController setBackgroundFromColor:backgroundColor titleColor:titleColor colorOfBackButton:tintColor];
    } else {
        [self.navigationController setBackgroundFromColor:backgroundColor titleColor:titleColor colorOfBackButton:tintColor];
    }
    
}

@end
