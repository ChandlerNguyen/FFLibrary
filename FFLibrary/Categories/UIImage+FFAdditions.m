//
//  UIImage+NLAdditions.m
//  MyApp
//
//  Created by Nguyen Nang on 4/16/15.
//  Copyright (c) 2015 Nguyen Nang. All rights reserved.
//

#import "UIImage+FFAdditions.h"
#import <objc/runtime.h>

@implementation UIImage (FFAdditions)

+(UIImage*)createImageWithColor:(UIColor*)color {
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context=UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *theImage=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

-(NSString *) imageBase64String {
    NSData* pictureData = UIImageJPEGRepresentation(self,0.3);//进行图片压缩从0.0到1.0（0.0表示最大压缩，质量最低);
    NSString* pictureDataString = [pictureData base64EncodedString];//图片转码成为base64Encoding，
    return pictureDataString;
}

+(UIImage *) dataFromBase64String:(NSString *)string {
    UIImage *image = [UIImage imageWithData:[NSData dataWithBase64EncodedString:string]];
    return image;
}

- (UIImage *)tintImageWithColor:(UIColor *)maskColor resizableImageWithCapInsets:(UIEdgeInsets)capInsets {
    
    UIImage *tintImg = [self tintImageWithColor:maskColor];
    return [tintImg resizableImageWithCapInsets:capInsets];
}

- (UIImage *)tintImageWithColor:(UIColor *)maskColor {
    
    NSParameterAssert(maskColor != nil);
    
    CGRect imageRect = CGRectMake(0.0f, 0.0f, self.size.width, self.size.height);
    
    UIGraphicsBeginImageContextWithOptions(imageRect.size, NO, self.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextScaleCTM(context, 1.0f, -1.0f);
    CGContextTranslateCTM(context, 0.0f, -(imageRect.size.height));
    
    CGContextClipToMask(context, imageRect, self.CGImage);
    CGContextSetFillColorWithColor(context, maskColor.CGColor);
    CGContextFillRect(context, imageRect);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

#pragma mark - h568 (http://angelolloqui.com/blog/20-iPhone5-568h-image-loading)
+ (void)load {
    if  ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) &&
         ([UIScreen mainScreen].bounds.size.height > 480.0f)) {
        
        //Exchange XIB loading implementation
        Method m1 = class_getInstanceMethod(NSClassFromString(@"UIImageNibPlaceholder"), @selector(initWithCoder:));
        Method m2 = class_getInstanceMethod(self, @selector(initWithCoderH568:));
        method_exchangeImplementations(m1, m2);
        
        //Exchange imageNamed: implementation
        method_exchangeImplementations(class_getClassMethod(self, @selector(imageNamed:)),
                                       class_getClassMethod(self, @selector(imageNamedH568:)));
    }
}

+ (UIImage *)imageNamedH568:(NSString *)imageName {
    return [UIImage imageNamedH568:[self renameImageNameForH568:imageName]];
}

- (id)initWithCoderH568:(NSCoder *)aDecoder {
    NSString *resourceName = [aDecoder decodeObjectForKey:@"UIResourceName"];
    NSString *resourceH568 = [UIImage renameImageNameForH568:resourceName];
    
    //If no 568h version, load as default
    if ([resourceName isEqualToString:resourceH568]) {
        return [self initWithCoderH568:aDecoder];
    }
    //If 568h exists, load with [UIImage imageNamed:]
    else {
        return [UIImage imageNamedH568:resourceH568];
    }
}

+ (NSString *)renameImageNameForH568:(NSString *)imageName {
    
    NSMutableString *imageNameMutable = [imageName mutableCopy];
    
    //Delete png extension
    NSRange extension = [imageName rangeOfString:@".png" options:NSBackwardsSearch | NSAnchoredSearch];
    if (extension.location != NSNotFound) {
        [imageNameMutable deleteCharactersInRange:extension];
    }
    
    //Look for @2x to introduce -568h string
    NSRange retinaAtSymbol = [imageName rangeOfString:@"@2x"];
    if (retinaAtSymbol.location != NSNotFound) {
        [imageNameMutable insertString:@"-568h" atIndex:retinaAtSymbol.location];
    } else {
        [imageNameMutable appendString:@"-568h@2x"];
    }
    
    //Check if the image exists and load the new 568 if so or the original name if not
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:imageNameMutable ofType:@"png"];
    if (imagePath) {
        //Remove the @2x to load with the correct scale 2.0
        [imageNameMutable replaceOccurrencesOfString:@"@2x" withString:@"" options:NSBackwardsSearch range:NSMakeRange(0, [imageNameMutable length])];
        return imageNameMutable;
    } else {
        return imageName;
    }
}



@end
