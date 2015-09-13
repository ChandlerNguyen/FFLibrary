//
//  UIColor+NLAdditions.h
//  MyApp
//
//  Created by Nguyen Nang on 4/17/15.
//  Copyright (c) 2015 Nguyen Nang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (FFAdditions)
/**
 takes @"#123456"
 */
+ (UIColor *)colorWithHex:(UInt32)col;

/**
 takes 0x123456
 */
+ (UIColor *)colorWithHexString:(NSString *)str;

+ (UIColor *)randomColor;
@end
