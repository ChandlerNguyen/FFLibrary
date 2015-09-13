//
//  UIColor+NLAdditions.m
//  MyApp
//
//  Created by Nguyen Nang on 4/17/15.
//  Copyright (c) 2015 Nguyen Nang. All rights reserved.
//

#import "UIColor+FFAdditions.h"

@implementation UIColor (FFAdditions)

+ (UIColor *)colorWithHexString:(NSString *)str {
    
    const char *cStr = [str cStringUsingEncoding:NSASCIIStringEncoding];
    long x = strtol(cStr+1, NULL, 16);
    
    return [UIColor colorWithHex:(UInt32)x];
}

+ (UIColor *)colorWithHex:(UInt32)col {
    
    unsigned char r, g, b;
    b = col & 0xFF;
    g = (col >> 8) & 0xFF;
    r = (col >> 16) & 0xFF;
    
    return [UIColor colorWithRed:(float)r/255.0f green:(float)g/255.0f blue:(float)b/255.0f alpha:1];
}

+ (UIColor *)randomColor
{
    CGFloat red =  (CGFloat)random()/(CGFloat)RAND_MAX;
    CGFloat blue = (CGFloat)random()/(CGFloat)RAND_MAX;
    CGFloat green = (CGFloat)random()/(CGFloat)RAND_MAX;
    return [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
}

@end
