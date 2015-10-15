//
//  UIImageView+FFAdditions.m
//  FFLibrary
//
//  Created by Nang Nguyen on 10/12/15.
//  Copyright © 2015 MCFF. All rights reserved.
//

#import "UIImageView+FFAdditions.h"

@implementation UIImageView (FFAdditions)

+ (UIImageView *)imageViewWithImageName:(NSString *)imageName
{
    UIImage *image = [UIImage imageNamed:imageName];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.contentMode = UIViewContentModeCenter;
    return imageView;
}

@end
