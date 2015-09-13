//
//  AFHTTPRequestOperation+ITSError.h
//  MCFF
//
//  Created by Nguyen Nang on 5/19/15.
//  Copyright (c) 2015 MCFF. All rights reserved.
//

#import "AFHTTPRequestOperation.h"

@interface AFHTTPRequestOperation (FFError)

/**
 * Returns the error object if the request failed.
 * The type of error object is NSDictionary as following:
 * {
 *      title = "Temporary Error";
 *      message = @"System could not complete your request. Please try again in a few moments.";
 *      statusCode = 404
 *      url = @""
 * }
 */
- (NSDictionary*)errorMessage;

- (BOOL)isNetworkErrorOrUnavailableService;

@end
