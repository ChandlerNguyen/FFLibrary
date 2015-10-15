//
//  UIView+FFAdditions.h
//  FFLibrary
//
//  Created by Nang Nguyen on 10/10/15.
//  Copyright © 2015 MCFF. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (FFAdditions)

- (UIViewController *)currentTopViewController;
- (UIViewController *)firstAvailableUIViewController;
- (UIViewController *)viewController;
@end
