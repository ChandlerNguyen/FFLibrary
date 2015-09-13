//
//  NLBorderdLabel.m
//  MyApp
//
//  Created by Nguyen Nang on 6/10/15.
//  Copyright (c) 2015 Nguyen Nang. All rights reserved.
//

#import "NLBorderdLabel.h"

// http://mtmurdockblog.com/2012/04/05/bordered-uilabel/

@implementation NLBorderdLabel

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _borderColor = [UIColor whiteColor];
        _borderSize = 1;
    }
    
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _borderColor = [UIColor whiteColor];
    _borderSize = 1;
}


- (void)drawTextInRect:(CGRect)rect {
    
    CGSize shadowOffset = self.shadowOffset;
    UIColor *textColor = self.textColor;
    
    CGContextRef c = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(c, self.borderSize);
    
    CGContextSetLineJoin(c, kCGLineJoinRound);
    CGContextSetTextDrawingMode(c, kCGTextStroke);
    self.textColor = self.borderColor;
    [super drawTextInRect:rect];
    
    CGContextSetTextDrawingMode(c, kCGTextFill);
    self.textColor = textColor;
    self.shadowOffset = CGSizeMake(0, 0);
    [super drawTextInRect:rect];
    
    self.shadowOffset = shadowOffset;
}

@end
