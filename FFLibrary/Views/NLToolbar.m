//
//  NLToolbar.m
//  MyApp
//
//  Created by Nguyen Nang on 4/22/15.
//  Copyright (c) 2015 Nguyen Nang. All rights reserved.
//

#import "NLToolbar.h"

@implementation NLToolbar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGContextRef c = UIGraphicsGetCurrentContext();
    UIImage *image = [UIImage createImageWithColor:[UIColor clearColor]];
    //UIImage *image = [UIImage createImageWithColor:[UIColor redColor]];
    CGContextDrawImage(c, rect, image.CGImage);
}

@end
