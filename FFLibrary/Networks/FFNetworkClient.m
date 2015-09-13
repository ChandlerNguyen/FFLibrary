//
//  FFNetworkClient.m
//  MyApp
//
//  Created by Nguyen Nang on 2/8/15.
//  Copyright (c) 2015 Nguyen Nang. All rights reserved.
//

#import <ReactiveCocoa/RACDisposable.h>
#import "FFNetworkClient.h"
#import "RACSubscriber.h"
#import "AFHTTPRequestOperation.h"
#import "FFNetworkManager.h"
#import "RACSignal+Operations.h"

@implementation FFNetworkClient

FFEnableDynamicLogging

- (RACSignal *)fetchJSONFromURLString:(NSString *)urlString andModelClass:(NSString *)modelClass {
    FFInfo(@"Fetching: %@",urlString);

    return [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        AFHTTPRequestOperation *dataTask =
                [FFNetworkManager executeGetWithUrl:urlString ignoreReloadRequest:NO
                                        andParameters:nil andHeaders:nil andModelClass:modelClass
                                   withSuccessHandler:^(AFHTTPRequestOperation *operation, id responseObject, bool apiSuccess) {
                                       [subscriber sendNext:responseObject];
                                       [subscriber sendCompleted];
                                   }
                                   withFailureHandler:^(AFHTTPRequestOperation *operation, NSError *error) {
                                       [subscriber sendError:error];
                                       [subscriber sendCompleted];
                                   } withLoadingViewOn:nil];

        return [RACDisposable disposableWithBlock:^{
            [dataTask cancel];
        }];
    }] doError:^(NSError *error) {
        FFInfo(@"%@",error);
    }];
}

- (void)fetchJSONFromURLString:(NSString*)urlString
            withSuccessHandler:(NLHTTPRequestSuccess)success
            withFailureHandler:(NLHTTPRequestFailure)failure withLoadingViewOn:(UIView *)parentView {
    FFInfo(@"Fetching: %@", urlString);
    [FFNetworkManager executeGetWithUrl:urlString ignoreReloadRequest:YES
                            andParameters:nil andHeaders:nil withSuccessHandler:success withFailureHandler:failure withLoadingViewOn:parentView];
}

- (void)fetchJSONFromURLString:(NSString*)urlString andModelClass:(NSString*)modelClass
            withSuccessHandler:(NLHTTPRequestSuccess)success
            withFailureHandler:(NLHTTPRequestFailure)failure withLoadingViewOn:(UIView *)parentView {
    FFInfo(@"Fetching: %@",urlString);
    [FFNetworkManager executeGetWithUrl:urlString ignoreReloadRequest:YES
                            andParameters:nil andHeaders:nil andModelClass:modelClass withSuccessHandler:success withFailureHandler:failure withLoadingViewOn:parentView];
}

- (void)fetchJSONFromURLString:(NSString*)urlString andModelClass:(NSString*)modelClass ignoreReloadRequest:(BOOL)ignoreReloadRequest
            withSuccessHandler:(NLHTTPRequestSuccess)success
            withFailureHandler:(NLHTTPRequestFailure)failure withLoadingViewOn:(UIView *)parentView {
    FFInfo(@"Fetching: %@",urlString);
    [FFNetworkManager executeGetWithUrl:urlString ignoreReloadRequest:ignoreReloadRequest
                            andParameters:nil andHeaders:nil andModelClass:modelClass withSuccessHandler:success withFailureHandler:failure withLoadingViewOn:parentView];
}

@end
