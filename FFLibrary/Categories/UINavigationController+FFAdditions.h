//
//  UINavigationController+NLAdditions.h
//  MyApp
//
//  Created by Nguyen Nang on 4/16/15.
//  Copyright (c) 2015 Nguyen Nang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (FFAdditions)

- (void)makeTransparent;
- (void)setBackgroundFromColor:(UIColor*)color titleColor:(UIColor*)titleColor colorOfBackButton:(UIColor*)backButtonColor;

@end
