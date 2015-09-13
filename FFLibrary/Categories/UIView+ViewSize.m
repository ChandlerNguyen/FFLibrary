//
//  UIView+ViewSize.m
//  MyApp
//
//  Created by Nguyen Nang on 4/17/15.
//  Copyright (c) 2015 Nguyen Nang. All rights reserved.
//

#import "UIView+ViewSize.h"

@implementation UIView (ViewSize)

- (CGSize)viewSize {
    return self.bounds.size;
}

- (CGFloat)viewWidth {
    return self.viewSize.width;
}

- (CGFloat)viewHeight {
    return self.viewSize.height;
}

- (CGFloat)left{
    return self.frame.origin.x;
}

- (CGFloat)top{
    return self.frame.origin.y;
}

- (CGFloat)right{
    return self.frame.origin.x + self.frame.size.width;
}

- (CGFloat)bottom{
    return self.frame.origin.y + self.frame.size.height;
}

- (CGFloat)width{
    return self.frame.size.width;
}

- (CGFloat)height{
    return self.frame.size.height;
}

@end
