//
//  UITableViewCell+NLAdditions.m
//  MyApp
//
//  Created by Nguyen Nang on 4/18/15.
//  Copyright (c) 2015 Nguyen Nang. All rights reserved.
//

#import "UITableViewCell+FFAdditions.h"

@implementation UITableViewCell (FFAdditions)

- (void)zeroSeparatorInset
{
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000
    if ([self respondsToSelector:@selector(setLayoutMargins:)])
        self.layoutMargins = UIEdgeInsetsZero;
#endif
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
    if ([self respondsToSelector: @selector(setSeparatorInset:)])
        self.separatorInset = UIEdgeInsetsZero;
#endif
}

@end
