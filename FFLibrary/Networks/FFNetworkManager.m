//
//  FFNetworkManager.m
//  MyApp
//
//  Created by Nguyen Nang on 1/30/15.
//  Copyright (c) 2015 Nguyen Nang. All rights reserved.
//

#import <Mantle/MTLJSONAdapter.h>
#import <LinqToObjectiveC/NSArray+LinqExtensions.h>
#import "FFNetworkManager.h"
#import "AFHTTPRequestOperation.h"
#import "AFHTTPRequestOperationManager.h"
#import "MBProgressHUD.h"
#import "AFNetworkReachabilityManager.h"
#import "AFHTTPRequestOperation+FFError.h"
#import "NSObject+FFAdditions.h"

#define TIME_CACHING_REQUEST    (10)    // minute

NSString *const kMessageLoading = @"Loading";

static void handleSuccessRequestWithOperation(AFHTTPRequestOperation *operation, id responseObject, NLHTTPRequestSuccess success) {
    if ([operation isCancelled]) {
        return;
    }
    if (success) {
        dispatch_async( dispatch_get_main_queue(), ^{
            success(operation, responseObject, YES);
        });
    }
}

static void handleFailureRequestWithOperation(AFHTTPRequestOperation *operation, NLHTTPRequestFailure failure, NSError *error) {
    if ([operation isCancelled]) {
        return;
    }
    if (![operation isEqual:nil] & ![error isEqual:nil]) {
        @try {
            if (failure) {
                FFInfo(@"Error Object: %@", operation.errorMessage);
                if (operation.isNetworkErrorOrUnavailableService) {
                    [FFNetworkManager handleErrorObject:operation.errorMessage];
//                    [[FFReceiverManager instance] executeBloksWithSelector:_cmd enumerateBloks:^(NLErrorObject block) {
//                        if (block) {
//                            block(operation.errorMessage);
//                        }
//                    }];
                } else {
                    dispatch_async( dispatch_get_main_queue(), ^{
                        failure(operation, error);
                    });
                }
            }
        }
        @catch (NSException *exception) {
            FFInfo(@"exception handling timeout %@", exception);
        }
    }
}

static AFHTTPRequestOperationManager *settingHeaders(NSDictionary *headers) {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setRequestSerializer:[AFJSONRequestSerializer serializer]];
    [manager setResponseSerializer:[AFJSONResponseSerializer serializer]];
    [[manager requestSerializer] setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    //[[manager requestSerializer] setValue:@"text/plain" forHTTPHeaderField:@"Content-Type"];
    
    // hack to allow 'text/plain' content-type to work
    NSMutableSet *contentTypes = [NSMutableSet setWithSet:manager.responseSerializer.acceptableContentTypes];
    [contentTypes addObject:@"text/plain"];
    manager.responseSerializer.acceptableContentTypes = contentTypes;
    
    // check if custom headers are present and add them
    if (headers != nil) {
        [headers enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            [[manager requestSerializer] setValue:obj forHTTPHeaderField:key];
        }];
    }
    
    return manager;
}

@interface FFNetworkManager ()
@property(nonatomic, strong) NSMutableArray *networkQueue;
@property(nonatomic, copy) NSString *cachePath;
@end

@implementation FFNetworkManager

DEF_SINGLETON( FFNetworkManager )

- (instancetype)init {

    self = [super init];
    if (self) {
        self.networkQueue = [NSMutableArray new];
        self.cachePath = [CommonUtil createCacheDirectory];
    }
    return self;
}

+ (void)cancelAllRunningNetworkOperations {
    for (AFHTTPRequestOperation *operation in [[FFNetworkManager instance] networkQueue]){
        @try {
            [operation cancel];
            [[[FFNetworkManager instance] networkQueue] removeObject:operation];
        }
        @catch (NSException *exception) {
            FFInfo(@"Error while cancelling the operation");
        }
        @finally {

        }
    }
}

+ (AFHTTPRequestOperation *)executeHttpRequestWithUrl:(NSString *)url
                                            andMethod:(NSString *)method
                                        andParameters:(NSDictionary *)parameters
                                           andHeaders:(NSDictionary *)headers
                                   withSuccessHandler:(NLHTTPRequestSuccess)success
                                   withFailureHandler:(NLHTTPRequestFailure)failure {
    AFHTTPRequestOperationManager *manager = settingHeaders(headers);
    AFHTTPRequestOperation *operationRequest = nil;
    
    if ([method isEqualToString:kHttpMethodDelete]) {
        operationRequest = [manager DELETE:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            handleSuccessRequestWithOperation(operation, responseObject, success);
        }                                           failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            handleFailureRequestWithOperation(operation, failure, error);
        }];
    } else if ([method isEqualToString:kHttpMethodGet]) {
        operationRequest = [manager GET:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            handleSuccessRequestWithOperation(operation, responseObject, success);
        }                                           failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            handleFailureRequestWithOperation(operation, failure, error);
        }];
    } else if ([method isEqualToString:kHttpMethodPut]) {
        operationRequest = [manager PUT:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            handleSuccessRequestWithOperation(operation, responseObject, success);
        }                                           failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            handleFailureRequestWithOperation(operation, failure, error);
        }];
    } else if ([method isEqualToString:kHttpMethodPost]) {
        operationRequest = [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            handleSuccessRequestWithOperation(operation, responseObject, success);
        }                                           failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            handleFailureRequestWithOperation(operation, failure, error);
        }];
    }
    
    return operationRequest;
}

+ (AFHTTPRequestOperation *)executePostWithUrl:(NSString *)url
             andParameters:(NSDictionary *)parameters
                andHeaders:(NSDictionary *)headers
andAuthorizationHeaderUser:(NSString *)user
        andAuthrozationHeaderPassword:(NSString *)password
        withSuccessHandler:(NLHTTPRequestSuccess)success
        withFailureHandler:(NLHTTPRequestFailure)failure
        withLoadingViewOn:(UIView *)parentView
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setRequestSerializer:[AFJSONRequestSerializer serializer]];
    [[manager securityPolicy] setAllowInvalidCertificates:YES];
    [[manager requestSerializer] setAuthorizationHeaderFieldWithUsername:user password:password];
    [manager setResponseSerializer:[AFJSONResponseSerializer serializer]];

    [[manager requestSerializer] setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    // check if custom headers are present and add them
    if (headers != nil) {
        [headers enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            [[manager requestSerializer] setValue:obj forHTTPHeaderField:key];
        }];
    }
    AFHTTPRequestOperation *operation;
    if (parentView == nil) {
        operation = [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            handleSuccessRequestWithOperation(operation, responseObject, success);
            [[[FFNetworkManager instance] networkQueue] removeObject:operation];
        }     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            handleFailureRequestWithOperation(operation, failure, error);
            [[[FFNetworkManager instance] networkQueue] removeObject:operation];
        }];
    }
    else {
        [MBProgressHUD showHUDAddedTo:parentView animated:YES];
        operation = [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            handleSuccessRequestWithOperation(operation, responseObject, success);
            [[[FFNetworkManager instance] networkQueue] removeObject:operation];
        }     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [MBProgressHUD hideAllHUDsForView:parentView animated:YES];
            handleFailureRequestWithOperation(operation, failure, error);
            [[[FFNetworkManager instance] networkQueue] removeObject:operation];
        }];
    }
    [[[FFNetworkManager instance] networkQueue] addObject:operation];

    return operation;
}

+ (AFHTTPRequestOperation *) executeDeleteWithUrl:(NSString *)url
                AndParameters:(NSDictionary *)parameters 
                   AndHeaders:(NSDictionary *)headers 
           withSuccessHandler:(NLHTTPRequestSuccess)success
           withFailureHandler:(NLHTTPRequestFailure)failure
            withLoadingViewOn:(UIView *)parentView {

    AFHTTPRequestOperationManager *manager = settingHeaders(headers);
    
    AFHTTPRequestOperation *operation;
    if (parentView == nil) {
        operation = [manager DELETE:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            handleSuccessRequestWithOperation(operation, responseObject, success);
            [[[FFNetworkManager instance] networkQueue] removeObject:operation];
        }     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            handleFailureRequestWithOperation(operation, failure, error);
            [[[FFNetworkManager instance] networkQueue] removeObject:operation];
        }];
    }
    else {

        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:parentView animated:YES];
        [hud setLabelText:kMessageLoading];
        operation = [manager DELETE:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [MBProgressHUD hideAllHUDsForView:parentView animated:YES];
            handleSuccessRequestWithOperation(operation, responseObject, success);
            [[[FFNetworkManager instance] networkQueue] removeObject:operation];
        }     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [MBProgressHUD hideAllHUDsForView:parentView animated:YES];
            handleFailureRequestWithOperation(operation, failure, error);
            [[[FFNetworkManager instance] networkQueue] removeObject:operation];
        }];
    }
    [[[FFNetworkManager instance] networkQueue] addObject:operation];

    return operation;
}

+ (AFHTTPRequestOperation *)executePostWithUrl:(NSString *)url
             andParameters:(NSDictionary *)parameters 
                andHeaders:(NSDictionary *)headers 
 constructingBodyWithBlock:(NLHTTPRequestMultipartFormData)block
        withSuccessHandler:(NLHTTPRequestSuccess)success
        withFailureHandler:(NLHTTPRequestFailure)failure
         withLoadingViewOn:(UIView *)parentView {
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setRequestSerializer:[AFJSONRequestSerializer serializer]];
    [manager setResponseSerializer:[AFJSONResponseSerializer serializer]];
    [[manager requestSerializer] setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    // hack to allow 'text/plain' content-type to work
    NSMutableSet *contentTypes = [NSMutableSet setWithSet:manager.responseSerializer.acceptableContentTypes];
    [contentTypes addObject:@"text/plain"];
    manager.responseSerializer.acceptableContentTypes = contentTypes;
    
    // check if custom headers are present and add them
    if (headers != nil) {
        [headers enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            [[manager requestSerializer] setValue:obj forHTTPHeaderField:key];
        }];
    }
    
    AFHTTPRequestOperation *operation;
    if (parentView == nil) {
        operation = [manager POST:url parameters:parameters constructingBodyWithBlock:block success:^(AFHTTPRequestOperation *operation, id responseObject) {
            handleSuccessRequestWithOperation(operation, responseObject, success);
            [[[FFNetworkManager instance] networkQueue] removeObject:operation];
        }     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            handleFailureRequestWithOperation(operation, failure, error);
            [[[FFNetworkManager instance] networkQueue] removeObject:operation];
        }];
    }
    else {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:parentView animated:YES];
        [hud setLabelText:kMessageLoading];
        operation = [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [MBProgressHUD hideAllHUDsForView:parentView animated:YES];
            handleSuccessRequestWithOperation(operation, responseObject, success);
            [[[FFNetworkManager instance] networkQueue] removeObject:operation];
        }     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [MBProgressHUD hideAllHUDsForView:parentView animated:YES];
            handleFailureRequestWithOperation(operation, failure, error);
            [[[FFNetworkManager instance] networkQueue] removeObject:operation];
        }];
    }
    [[[FFNetworkManager instance] networkQueue] addObject:operation];

    return operation;
}

+ (AFHTTPRequestOperation *)executePostWithUrl:(NSString *)url
             andParameters:(NSDictionary *)parameters
                andHeaders:(NSDictionary *)headers
        withSuccessHandler:(NLHTTPRequestSuccess)success
        withFailureHandler:(NLHTTPRequestFailure)failure
         withLoadingViewOn:(UIView *)parentView {

    AFHTTPRequestOperationManager *manager = settingHeaders(headers);
    
    AFHTTPRequestOperation *operation;
    if (parentView == nil) {
        operation = [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            handleSuccessRequestWithOperation(operation, responseObject, success);
            [[[FFNetworkManager instance] networkQueue] removeObject:operation];
        }     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            handleFailureRequestWithOperation(operation, failure, error);
            [[[FFNetworkManager instance] networkQueue] removeObject:operation];
        }];
    }
    else {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:parentView animated:YES];
        [hud setLabelText:kMessageLoading];
        operation = [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [MBProgressHUD hideAllHUDsForView:parentView animated:YES];
            handleSuccessRequestWithOperation(operation, responseObject, success);
            [[[FFNetworkManager instance] networkQueue] removeObject:operation];
        }     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [MBProgressHUD hideAllHUDsForView:parentView animated:YES];
            handleFailureRequestWithOperation(operation, failure, error);
            [[[FFNetworkManager instance] networkQueue] removeObject:operation];
        }];
    }
    [[[FFNetworkManager instance] networkQueue] addObject:operation];

    return operation;
}

+ (AFHTTPRequestOperation *)executePutWithUrl:(NSString *)url
            andParameters:(NSDictionary *)parameters 
               andHeaders:(NSDictionary *)headers 
       withSuccessHandler:(NLHTTPRequestSuccess)success 
       withFailureHandler:(NLHTTPRequestFailure)failure 
        withLoadingViewOn:(UIView *)parentView {
    
    AFHTTPRequestOperationManager *manager = settingHeaders(headers);
    
    AFHTTPRequestOperation *operation;
    if (parentView == nil) {
        operation = [manager PUT:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            handleSuccessRequestWithOperation(operation, responseObject, success);
            [[[FFNetworkManager instance] networkQueue] removeObject:operation];
        }    failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            handleFailureRequestWithOperation(operation, failure, error);
            [[[FFNetworkManager instance] networkQueue] removeObject:operation];
        }];
    }
    else {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:parentView animated:YES];
        [hud setLabelText:kMessageLoading];
        operation = [manager PUT:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [MBProgressHUD hideAllHUDsForView:parentView animated:YES];
            handleSuccessRequestWithOperation(operation, responseObject, success);
            [[[FFNetworkManager instance] networkQueue] removeObject:operation];
        }    failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [MBProgressHUD hideAllHUDsForView:parentView animated:YES];
            handleFailureRequestWithOperation(operation, failure, error);
            [[[FFNetworkManager instance] networkQueue] removeObject:operation];
        }];
    }
    [[[FFNetworkManager instance] networkQueue] addObject:operation];

    return operation;
}

+ (AFHTTPRequestOperation *)executeGetWithUrl:(NSString *)url ignoreReloadRequest:(BOOL)ignoreReloadRequest
                                andParameters:(NSDictionary *)parameters
                                   andHeaders:(NSDictionary *)headers
                           withSuccessHandler:(NLHTTPRequestSuccess)success
                           withFailureHandler:(NLHTTPRequestFailure)failure
                            withLoadingViewOn:(UIView *)parentView {
    AFHTTPRequestOperationManager *manager = settingHeaders(headers);

    id cachedObject = [NSKeyedUnarchiver unarchiveObjectWithFile:[[FFNetworkManager instance].cachePath stringByAppendingPathComponent:[url MD5]]];
    if (cachedObject) {
        //FFInfo(@"CACHED OBJ: %@", cachedObject);
        id cachedResponse = cachedObject[@"response"];
        double lastUpdateTime = [cachedObject[@"timestamp"] doubleValue];
        handleSuccessRequestWithOperation(nil, cachedResponse, success);
        // Nếu request đã cập nhật quá TIME_CACHING_REQUEST phút thì reload Data từ Network, ngược lại thì lấy từ cache
        if(([[NSDate date] timeIntervalSince1970] - lastUpdateTime < TIME_CACHING_REQUEST*60) || ignoreReloadRequest){
            FFInfo(@"load request from caching: %@", url);
            return nil;
        }
    }
    
    // if failure is nil then its an indication to handle it with default flow that is showing message
    // in alert dialog
    AFHTTPRequestOperation *operation;
    if (parentView == nil) {
        operation = [manager GET:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            // Save response to local cache
            NSMutableDictionary *responseDic = [[NSMutableDictionary alloc] init];
            [responseDic setObject:responseObject forKey:@"response"];
            [responseDic setObject:[NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]] forKey:@"timestamp"];
            [NSKeyedArchiver archiveRootObject:responseDic toFile:[[FFNetworkManager instance].cachePath stringByAppendingPathComponent:[operation.request.URL.absoluteString MD5]]];
            
            handleSuccessRequestWithOperation(operation, responseObject, success);
            [[[FFNetworkManager instance] networkQueue] removeObject:operation];
        }    failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            handleFailureRequestWithOperation(operation, failure, error);
            [[[FFNetworkManager instance] networkQueue] removeObject:operation];
        }];
    }
    else {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:parentView animated:YES];
        [hud setLabelText:kMessageLoading];
        operation = [manager GET:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            // Save response to local cache
            NSMutableDictionary *responseDic = [[NSMutableDictionary alloc] init];
            [responseDic setObject:responseObject forKey:@"response"];
            [responseDic setObject:[NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]] forKey:@"timestamp"];
            [NSKeyedArchiver archiveRootObject:responseDic toFile:[[FFNetworkManager instance].cachePath stringByAppendingPathComponent:[operation.request.URL.absoluteString MD5]]];
            
            [MBProgressHUD hideAllHUDsForView:parentView animated:YES];
            handleSuccessRequestWithOperation(operation, responseObject, success);
            [[[FFNetworkManager instance] networkQueue] removeObject:operation];
        }    failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [MBProgressHUD hideAllHUDsForView:parentView animated:YES];
            handleFailureRequestWithOperation(operation, failure, error);
            [[[FFNetworkManager instance] networkQueue] removeObject:operation];
        }];
    }
    [[[FFNetworkManager instance] networkQueue] addObject:operation];

    return operation;
}

+ (id)getCacheFromUrlString:(NSString*)url modelClass:(NSString*)modelClass {
    id cachedObject = [NSKeyedUnarchiver unarchiveObjectWithFile:[[FFNetworkManager instance].cachePath stringByAppendingPathComponent:[url MD5]]];
    if (cachedObject) {
        id cachedResponse = cachedObject[@"response"];
        if (modelClass == nil) {
            return cachedResponse;
        } else {
            Class _modelClass = NSClassFromString(modelClass);
            if([cachedResponse isKindOfClass:[NSArray class]]){
                NSArray *result = cachedResponse;
                NSArray *objList = [result linq_select:^id(id obj) {
                    return [MTLJSONAdapter modelOfClass:_modelClass fromJSONDictionary:obj error:nil];
                }];
                return objList;
            }else if([cachedResponse isKindOfClass:[NSDictionary class]]){
                id obj = [MTLJSONAdapter modelOfClass:_modelClass fromJSONDictionary:cachedResponse error:nil];
                return obj;
            }else{
                return cachedResponse;
            }
        }
        
    }
    return nil;
}

+ (AFHTTPRequestOperation *)executeGetWithUrl:(NSString *)url ignoreReloadRequest:(BOOL)ignoreReloadRequest
                                andParameters:(NSDictionary *)parameters
                                   andHeaders:(NSDictionary *)headers
                                andModelClass:(NSString *)modelClass
                           withSuccessHandler:(NLHTTPRequestSuccess)success
                           withFailureHandler:(NLHTTPRequestFailure)failure
                            withLoadingViewOn:(UIView *)parentView {
    AFHTTPRequestOperationManager *manager = settingHeaders(headers);
    
    id cachedObject = [NSKeyedUnarchiver unarchiveObjectWithFile:[[FFNetworkManager instance].cachePath stringByAppendingPathComponent:[url MD5]]];
    if (cachedObject) {
        //FFInfo(@"CACHED OBJ: %@", cachedObject);
        id cachedResponse = cachedObject[@"response"];
        double lastUpdateTime = [cachedObject[@"timestamp"] doubleValue];
        if (modelClass == nil) {
            dispatch_async( dispatch_get_main_queue(), ^{
                success(nil, cachedResponse, YES);
            });
        } else {
            Class _modelClass = NSClassFromString(modelClass);
            if([cachedResponse isKindOfClass:[NSArray class]]){
                NSArray *result = cachedResponse;
                NSArray *objList = [result linq_select:^id(id obj) {
                    return [MTLJSONAdapter modelOfClass:_modelClass fromJSONDictionary:obj error:nil];
                }];
                dispatch_async( dispatch_get_main_queue(), ^{
                    success(nil, objList, YES);
                });
            }else if([cachedResponse isKindOfClass:[NSDictionary class]]){
                id obj = [MTLJSONAdapter modelOfClass:_modelClass fromJSONDictionary:cachedResponse error:nil];
                dispatch_async( dispatch_get_main_queue(), ^{
                    success(nil, obj, YES);
                });
            }else{
                FFInfo(@"Unknown Json data types");
                dispatch_async( dispatch_get_main_queue(), ^{
                    success(nil, cachedResponse, YES);
                });
            }
        }
        // Nếu request đã cập nhật quá TIME_CACHING_REQUEST phút thì reload Data từ Network, ngược lại thì lấy từ cache
        if(([[NSDate date] timeIntervalSince1970] - lastUpdateTime < TIME_CACHING_REQUEST*60) || ignoreReloadRequest){
            FFInfo(@"load request from caching: %@", url);
            return nil;
        }
    }
    
    // if failure is nil then its an indication to handle it with default flow that is showing message
    // in alert dialog
    AFHTTPRequestOperation *operation;
    if (parentView == nil) {
        operation = [manager GET:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if ([operation isCancelled]){
                return;
            }
            
            // Save response to local cache
            NSMutableDictionary *responseDic = [[NSMutableDictionary alloc] init];
            [responseDic setObject:responseObject forKey:@"response"];
            [responseDic setObject:[NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]] forKey:@"timestamp"];
            [NSKeyedArchiver archiveRootObject:responseDic toFile:[[FFNetworkManager instance].cachePath stringByAppendingPathComponent:[operation.request.URL.absoluteString MD5]]];
            
            [[[FFNetworkManager instance] networkQueue] removeObject:operation];
            if (success) {
                if (modelClass == nil) {
                    dispatch_async( dispatch_get_main_queue(), ^{
                        success(operation, responseObject, YES);
                    });
                } else {
                    Class _modelClass = NSClassFromString(modelClass);
                    if([responseObject isKindOfClass:[NSArray class]]){
                        NSArray *result = responseObject;
                        NSArray *objList = [result linq_select:^id(id obj) {
                            return [MTLJSONAdapter modelOfClass:_modelClass fromJSONDictionary:obj error:nil];
                        }];
                        dispatch_async( dispatch_get_main_queue(), ^{
                            success(operation, objList, YES);
                        });
                    }else if([responseObject isKindOfClass:[NSDictionary class]]){
                        id obj = [MTLJSONAdapter modelOfClass:_modelClass fromJSONDictionary:responseObject error:nil];
                        dispatch_async( dispatch_get_main_queue(), ^{
                            success(operation, obj, YES);
                        });
                    }else{
                        FFInfo(@"Unknown Json data types");
                        dispatch_async( dispatch_get_main_queue(), ^{
                            success(operation, responseObject, YES);
                        });
                    }
                }
            }

        }    failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            handleFailureRequestWithOperation(operation, failure, error);
            [[[FFNetworkManager instance] networkQueue] removeObject:operation];
        }];
    }
    else {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:parentView animated:YES];
        [hud setLabelText:kMessageLoading];
        operation = [manager GET:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [MBProgressHUD hideAllHUDsForView:parentView animated:YES];
            if ([operation isCancelled]){
                return;
            }
            
            // Save response to local cache
            NSMutableDictionary *responseDic = [[NSMutableDictionary alloc] init];
            [responseDic setObject:responseObject forKey:@"response"];
            [responseDic setObject:[NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]] forKey:@"timestamp"];
            [NSKeyedArchiver archiveRootObject:responseDic toFile:[[FFNetworkManager instance].cachePath stringByAppendingPathComponent:[operation.request.URL.absoluteString MD5]]];
            
            [[[FFNetworkManager instance] networkQueue] removeObject:operation];
            //FFInfo(@"success %@ - %@", operation, responseObject);
            if (success) {
                if (modelClass == nil) {
                    dispatch_async( dispatch_get_main_queue(), ^{
                        success(operation, responseObject, YES);
                    });
                    
                } else {
                    Class _modelClass = NSClassFromString(modelClass);
                    if([responseObject isKindOfClass:[NSArray class]]){
                        NSArray *result = responseObject;
                        NSArray *objList = [result linq_select:^id(id obj) {
                            return [MTLJSONAdapter modelOfClass:_modelClass fromJSONDictionary:obj error:nil];;
                        }];
                        dispatch_async( dispatch_get_main_queue(), ^{
                            success(operation, objList, YES);
                        });
                        
                    }else if([responseObject isKindOfClass:[NSDictionary class]]){
                        id obj = [MTLJSONAdapter modelOfClass:_modelClass fromJSONDictionary:responseObject error:nil];
                        dispatch_async( dispatch_get_main_queue(), ^{
                            success(operation, obj, YES);
                        });
                    }else{
                        FFInfo(@"Unknown Json data types");
                        dispatch_async( dispatch_get_main_queue(), ^{
                            success(operation, responseObject, YES);
                        });
                    }
                }
            }
        }    failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [MBProgressHUD hideAllHUDsForView:parentView animated:YES];
            handleFailureRequestWithOperation(operation, failure, error);
            [[[FFNetworkManager instance] networkQueue] removeObject:operation];
        }];
    }
    [[[FFNetworkManager instance] networkQueue] addObject:operation];

    return operation;
}

+ (AFHTTPRequestOperation *)executePatchWithUrl:(NSString *)url
              andParameters:(NSDictionary *)parameters 
                 andHeaders:(NSDictionary *)headers 
         withSuccessHandler:(NLHTTPRequestSuccess)success 
         withFailureHandler:(NLHTTPRequestFailure)failure 
          withLoadingViewOn:(UIView *)parentView {
    
    AFHTTPRequestOperationManager *manager = settingHeaders(headers);
    
    AFHTTPRequestOperation *operation;
    if (parentView == nil) {

        operation = [manager PATCH:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            handleSuccessRequestWithOperation(operation, responseObject, success);
            [[[FFNetworkManager instance] networkQueue] removeObject:operation];
        }    failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            handleFailureRequestWithOperation(operation, failure, error);
            [[[FFNetworkManager instance] networkQueue] removeObject:operation];
        }];
    }
    else {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:parentView animated:YES];
        [hud setLabelText:kMessageLoading];
        operation = [manager PATCH:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [MBProgressHUD hideAllHUDsForView:parentView animated:YES];
            handleSuccessRequestWithOperation(operation, responseObject, success);
            [[[FFNetworkManager instance] networkQueue] removeObject:operation];
            
        }    failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [MBProgressHUD hideAllHUDsForView:parentView animated:YES];
            handleFailureRequestWithOperation(operation, failure, error);
            [[[FFNetworkManager instance] networkQueue] removeObject:operation];
        }];
    }
    [[[FFNetworkManager instance] networkQueue] addObject:operation];

    return operation;
}

+ (BOOL) isEnableWIFI {
    return ([[AFNetworkReachabilityManager sharedManager] networkReachabilityStatus] == AFNetworkReachabilityStatusReachableViaWiFi);
}

+ (BOOL) isEnable3G {
    AFNetworkReachabilityStatus status = [[AFNetworkReachabilityManager sharedManager] networkReachabilityStatus];
    return status == AFNetworkReachabilityStatusReachableViaWWAN;
}

+ (BOOL) isEnableNetwork {
    return [self isEnableWIFI] || [self isEnable3G];
}

#pragma mark -
+ (void)handleErrorNetworkOrUnavailableServiceWithTarget:(id)target block:(NLErrorObject)block {
    [[FFReceiverManager instance] subsribeWithTarget:target selector:@selector(handleErrorObject:) block:block];
}

+ (void)handleErrorObject:(NSDictionary*)error {
    [[FFReceiverManager instance] executeBloksWithSelector:_cmd enumerateBloks:^(NLErrorObject block) {
        if (block) {
            block(error);
        }
    }];
}

@end
