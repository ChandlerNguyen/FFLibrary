//
//  UIViewController+UINavigationBar.h
//  MyApp
//
//  Created by Nguyen Nang on 4/16/15.
//  Copyright (c) 2015 Nguyen Nang. All rights reserved.
//

#import <UIKit/UIKit.h>

#pragma mark -

/**
 *  Position to show UIButtonBar in a navigation bar
 */
typedef NS_ENUM(NSUInteger, NLNavButtonBarPosition){
    NLNavButtonBarPositionCenter = 0,
    NLNavButtonBarPositionLeft,
    NLNavButtonBarPositionRight
};

@interface UINavigationBar (UINavigationBar)

@end

#pragma mark -

@interface UIViewController (UINavigationBar)

- (void)showNavigationBarAnimated:(BOOL)animated;
- (void)hideNavigationBarAnimated:(BOOL)animated;

- (void)showBarButton:(NSInteger)position title:(NSString *)name performAction:(SEL)selector;
- (void)showBarButton:(NSInteger)position title:(NSString *)name performActionUsingBlock:(NLSenderBlock)block;

- (void)showBarButton:(NSInteger)position image:(UIImage *)image performAction:(SEL)selector;
- (void)showBarButton:(NSInteger)position image:(UIImage *)image performActionUsingBlock:(NLSenderBlock)block;

- (void)showBarButton:(NSInteger)position system:(UIBarButtonSystemItem)index performAction:(SEL)selector;
- (void)showBarButton:(NSInteger)position system:(UIBarButtonSystemItem)index performActionUsingBlock:(NLSenderBlock)block;

- (void)showBarButton:(NSInteger)position custom:(UIView *)view;
- (void)navigationBarWithSegmentedControl:(UISegmentedControl*)segmentedControl;

- (void)hideBarButton:(NSInteger)position;

- (void)showLoadingIndicatorOnNavigationBarAtPosition:(NSInteger)position;

- (void)setColorsForNavigationBarWithBackground:(UIColor*)backgroundColor titleColor:(UIColor*)titleColor
                              colorOfBackButton:(UIColor*)tintColor;
@end
