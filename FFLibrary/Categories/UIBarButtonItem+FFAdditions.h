//
//  UIBarButtonItem+NLAdditions.h
//  MyApp
//
//  Created by Nguyen Nang on 4/16/15.
//  Copyright (c) 2015 Nguyen Nang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (FFAdditions)

- (instancetype)initWithTitle:(NSString *)title style:(UIBarButtonItemStyle)style handler:(NLSenderBlock)action;
- (instancetype)initWithImage:(UIImage *)image style:(UIBarButtonItemStyle)style handler:(NLSenderBlock)action;
- (instancetype)initWithBarButtonSystemItem:(UIBarButtonSystemItem)systemItem handler:(NLSenderBlock)action;

@end
