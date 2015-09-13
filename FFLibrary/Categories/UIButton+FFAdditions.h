//
//  UIButton+NLAdditions.h
//  MyApp
//
//  Created by Nguyen Nang on 4/16/15.
//  Copyright (c) 2015 Nguyen Nang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (FFAdditions)
- (instancetype)initWithFrame:(CGRect)frame handler:(NLSenderBlock)action;
@end
