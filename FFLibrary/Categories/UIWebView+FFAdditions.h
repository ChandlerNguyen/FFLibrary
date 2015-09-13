//
//  UIWebView+NLAdditions.h
//  MyApp
//
//  Created by Nguyen Nang on 4/19/15.
//  Copyright (c) 2015 Nguyen Nang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIWebView (FFAdditions)

-(void) removeShadow;
-(void) makeTransparent;
-(void) makeTransparentAndRemoveShadow;

//-------------------------------------------------------------------
//  UIWebViewWithPost
//       using UIWebview With some post parameters
//-------------------------------------------------------------------
-(void) postRequestURLString:(NSString*)urlString params:(NSMutableArray *)params;
@end
