//
//  NLStatusView.h
//  MyApp
//
//  Created by Nguyen Nang on 5/21/15.
//  Copyright (c) 2015 Nguyen Nang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, NLStatusViewType) {
    NLStatusViewTypeNormal = 0,
    NLStatusViewTypeNoNetwork,
    NLStatusViewTypeLogo,         //Initialization page (website Logo)
    NLStatusViewTypeLoading,      //View Loading
    NLStatusViewTypeRetry,        //Server error, click Retry
};

@interface NLStatusView : UIView

@property (nonatomic,assign) NLStatusViewType status;


- (void)clickedOnRetryWithActionHandler:(void (^)(id sender))actionHandler;
@end
