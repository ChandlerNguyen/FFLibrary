//
//  UIViewController+ViewSize.m
//  MyApp
//
//  Created by Nguyen Nang on 4/17/15.
//  Copyright (c) 2015 Nguyen Nang. All rights reserved.
//

#import "UIViewController+ViewSize.h"

@implementation UIViewController (ViewSize)

- (CGSize)viewSize {
    return self.view.bounds.size;
}

- (CGFloat)viewWidth {
    return self.viewSize.width;
}

- (CGFloat)viewHeight {
    return self.viewSize.height;
}

@end
