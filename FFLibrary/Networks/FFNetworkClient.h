//
//  FFNetworkClient.h
//  MyApp
//
//  Created by Nguyen Nang on 2/8/15.
//  Copyright (c) 2015 Nguyen Nang. All rights reserved.
//

// Lớp này là abstract cho các lớp mà thực hiện nhiệm vụ gọi các API endpoint và parse dữ liệu

#import "RACSignal.h"
#import "FFNetworkManager.h"

@interface FFNetworkClient : NSObject

- (RACSignal *)fetchJSONFromURLString:(NSString *)urlString andModelClass:(NSString *)modelClass;
- (void)fetchJSONFromURLString:(NSString*)urlString
            withSuccessHandler:(NLHTTPRequestSuccess)success
            withFailureHandler:(NLHTTPRequestFailure)failure
             withLoadingViewOn:(UIView *)parentView;

- (void)fetchJSONFromURLString:(NSString*)urlString andModelClass:(NSString*)modelClass
            withSuccessHandler:(NLHTTPRequestSuccess)success
            withFailureHandler:(NLHTTPRequestFailure)failure
             withLoadingViewOn:(UIView *)parentView;

- (void)fetchJSONFromURLString:(NSString*)urlString andModelClass:(NSString*)modelClass ignoreReloadRequest:(BOOL)ignoreReloadRequest
            withSuccessHandler:(NLHTTPRequestSuccess)success
            withFailureHandler:(NLHTTPRequestFailure)failure withLoadingViewOn:(UIView *)parentView;

@end
