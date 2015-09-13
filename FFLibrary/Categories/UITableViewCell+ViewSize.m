//
//  UITableViewCell+ViewSize.m
//  MyApp
//
//  Created by Nguyen Nang on 4/17/15.
//  Copyright (c) 2015 Nguyen Nang. All rights reserved.
//

#import "UITableViewCell+ViewSize.h"

@implementation UITableViewCell (ViewSize)

- (CGSize)viewSize {
    return self.contentView.bounds.size;
}


- (CGFloat)viewWidth {
    return self.viewSize.width;
}


- (CGFloat)viewHeight {
    return self.viewSize.height;
}

@end
