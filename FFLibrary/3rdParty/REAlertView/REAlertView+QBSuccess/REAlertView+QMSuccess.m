//
//  REAlertView+QMSuccess.m
//  Qmunicate
//
//  Created by Andrey Ivanov on 30.06.14.
//  Copyright (c) 2014 Quickblox. All rights reserved.
//

#import "REAlertView+QMSuccess.h"

@implementation REAlertView (QMSuccess)

+ (void)showAlertWithMessage:(NSString *)messageString actionSuccess:(BOOL)success {
    
    [REAlertView presentAlertViewWithConfiguration:^(REAlertView *alertView) {
        alertView.title = success ? @"Ok" : @"Thông báo";
        alertView.message = messageString;
        [alertView addButtonWithTitle:@"OK" andActionBlock:^{}];
    }];
}

@end
