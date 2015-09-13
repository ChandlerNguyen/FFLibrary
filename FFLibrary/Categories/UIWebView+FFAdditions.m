//
//  UIWebView+NLAdditions.m
//  MyApp
//
//  Created by Nguyen Nang on 4/19/15.
//  Copyright (c) 2015 Nguyen Nang. All rights reserved.
//

#import "UIWebView+FFAdditions.h"

@implementation UIWebView (FFAdditions)

-(void) removeShadow
{
    //Remove that dang shadow.from the UIWebView
    for(UIScrollView* webScrollView in [self subviews])
    {
        if ([webScrollView isKindOfClass:[UIScrollView class]])
        {
            for(UIView* subview in [webScrollView subviews])
            {
                if ([subview isKindOfClass:[UIImageView class]])
                {
                    ((UIImageView*)subview).image = nil;
                    subview.backgroundColor = [UIColor clearColor];
                }
            }
        }
    }
}

-(void) makeTransparent
{
    self.backgroundColor = [UIColor clearColor];
    self.opaque = NO;
}

-(void) makeTransparentAndRemoveShadow
{
    [self makeTransparent];
    [self removeShadow];
}

-(void) postRequestURLString:(NSString*)urlString params:(NSMutableArray *)params {
    NSMutableString *s = [NSMutableString stringWithCapacity:0];
    [s appendString: [NSString stringWithFormat:@"<html><body onload=\"document.forms[0].submit()\">"
                      "<form method=\"post\" action=\"%@\">", urlString]];
    if([params count] % 2 == 1) { NSLog(@"UIWebViewWithPost error: params don't seem right"); return; }
    for (int i=0; i < [params count] / 2; i++) {
        [s appendString: [NSString stringWithFormat:@"<input type=\"hidden\" name=\"%@\" value=\"%@\" >\n", [params objectAtIndex:i*2], [params objectAtIndex:(i*2)+1]]];
    }
    [s appendString: @"</input></form></body></html>"];
    [self loadHTMLString:s baseURL:nil];
}
@end
