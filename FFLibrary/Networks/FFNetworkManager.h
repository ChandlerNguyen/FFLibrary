//
//  FFNetworkManager.h
//  MyApp
//
//  Created by Nguyen Nang on 1/30/15.
//  Copyright (c) 2015 Nguyen Nang. All rights reserved.
//



@class AFHTTPRequestOperation;
@protocol AFMultipartFormData;

typedef void(^NLHTTPRequestSuccess)(AFHTTPRequestOperation *operation, id responseObject, bool apiSuccess);
typedef void(^NLHTTPRequestFailure)(AFHTTPRequestOperation *operation, NSError *error);
typedef void(^NLHTTPRequestMultipartFormData)(id <AFMultipartFormData> formData);
typedef void(^NLErrorObject)(NSDictionary *error);
typedef void(^NLArray)(NSArray *array);

@interface FFNetworkManager : NSObject

AS_SINGLETON( FFNetworkManager )

+ (void)cancelAllRunningNetworkOperations;

+ (AFHTTPRequestOperation *)executeHttpRequestWithUrl:(NSString *)url
                                            andMethod:(NSString *)method
                                        andParameters:(NSDictionary *)parameters
                                           andHeaders:(NSDictionary *)headers
                                   withSuccessHandler:(NLHTTPRequestSuccess)success
                                   withFailureHandler:(NLHTTPRequestFailure)failure;

+ (AFHTTPRequestOperation *)executePostWithUrl:(NSString *)url
             andParameters:(NSDictionary *)parameters
                andHeaders:(NSDictionary *)headers
andAuthorizationHeaderUser:(NSString *)user
        andAuthrozationHeaderPassword:(NSString *)password
        withSuccessHandler:(NLHTTPRequestSuccess)success
        withFailureHandler:(NLHTTPRequestFailure)failure
        withLoadingViewOn:(UIView *)parentView;

+ (AFHTTPRequestOperation *)executeDeleteWithUrl:(NSString *)url
               AndParameters:(NSDictionary *)parameters
                  AndHeaders:(NSDictionary *)headers
          withSuccessHandler:(NLHTTPRequestSuccess)success
          withFailureHandler:(NLHTTPRequestFailure)failure
           withLoadingViewOn:(UIView *)parentView;

+ (AFHTTPRequestOperation *)executePostWithUrl:(NSString *)url
             andParameters:(NSDictionary *)parameters
                andHeaders:(NSDictionary *)headers
 constructingBodyWithBlock:(NLHTTPRequestMultipartFormData)block
        withSuccessHandler:(NLHTTPRequestSuccess)success
        withFailureHandler:(NLHTTPRequestFailure)failure
         withLoadingViewOn:(UIView *)parentView;

+ (AFHTTPRequestOperation *)executePostWithUrl:(NSString *)url
             andParameters:(NSDictionary *)parameters
                andHeaders:(NSDictionary *)headers
        withSuccessHandler:(NLHTTPRequestSuccess)success
        withFailureHandler:(NLHTTPRequestFailure)failure
         withLoadingViewOn:(UIView *)parentView;

+ (AFHTTPRequestOperation *)executePutWithUrl:(NSString *)url
            andParameters:(NSDictionary *)parameters
               andHeaders:(NSDictionary *)headers
       withSuccessHandler:(NLHTTPRequestSuccess)success
       withFailureHandler:(NLHTTPRequestFailure)failure
        withLoadingViewOn:(UIView *)parentView;

+ (AFHTTPRequestOperation *)executeGetWithUrl:(NSString *)url ignoreReloadRequest:(BOOL)ignoreReloadRequest
            andParameters:(NSDictionary *)parameters
               andHeaders:(NSDictionary *)headers
       withSuccessHandler:(NLHTTPRequestSuccess)success
       withFailureHandler:(NLHTTPRequestFailure)failure
        withLoadingViewOn:(UIView *)parentView;

+ (AFHTTPRequestOperation *)executeGetWithUrl:(NSString *)url ignoreReloadRequest:(BOOL)ignoreReloadRequest
            andParameters:(NSDictionary *)parameters
               andHeaders:(NSDictionary *)headers
            andModelClass:(NSString *)modelClass
       withSuccessHandler:(NLHTTPRequestSuccess)success
       withFailureHandler:(NLHTTPRequestFailure)failure
        withLoadingViewOn:(UIView *)parentView;

+ (AFHTTPRequestOperation *)executePatchWithUrl:(NSString *)url
              andParameters:(NSDictionary *)parameters
                 andHeaders:(NSDictionary *)headers
         withSuccessHandler:(NLHTTPRequestSuccess)success
         withFailureHandler:(NLHTTPRequestFailure)failure
          withLoadingViewOn:(UIView *)parentView;

+ (id)getCacheFromUrlString:(NSString*)url modelClass:(NSString*)modelClass;

+ (BOOL) isEnableWIFI;
+ (BOOL) isEnable3G;
+ (BOOL) isEnableNetwork;

+ (void)handleErrorNetworkOrUnavailableServiceWithTarget:(id)target block:(NLErrorObject)block;
+ (void)handleErrorObject:(NSDictionary*)error;
@end
