//
//  UIImage+NLAdditions.h
//  MyApp
//
//  Created by Nguyen Nang on 4/16/15.
//  Copyright (c) 2015 Nguyen Nang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (FFAdditions)
/*
 * create color to image
 */
+(UIImage*) createImageWithColor:(UIColor*)color;

/*
 * convert base64string to image
 */
-(NSString *) imageBase64String;
+(UIImage *) dataFromBase64String:(NSString *)string;

- (UIImage *)tintImageWithColor:(UIColor *)maskColor;
- (UIImage *)tintImageWithColor:(UIColor *)maskColor resizableImageWithCapInsets:(UIEdgeInsets)capInsets NS_AVAILABLE_IOS(5_0);

@end
