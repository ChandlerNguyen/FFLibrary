//
//  AFHTTPRequestOperation+ITSError.m
//  MCFF
//
//  Created by Nguyen Nang on 5/19/15.
//  Copyright (c) 2015 MCFF. All rights reserved.
//

#import "AFHTTPRequestOperation+FFError.h"
#import "FFHttpStatus.h"

@implementation AFHTTPRequestOperation (FFError)

- (BOOL)isConnectionError {
    return self.error.code == NSURLErrorTimedOut ||
            self.error.code == NSURLErrorCannotFindHost ||
            self.error.code == NSURLErrorCannotConnectToHost ||
            self.error.code == NSURLErrorNetworkConnectionLost ||
            self.error.code == NSURLErrorDNSLookupFailed ||
            self.error.code == NSURLErrorNotConnectedToInternet;
}

- (BOOL)isNetworkErrorOrUnavailableService {
    BOOL isFatalError = self.response.statusCode == ITSHttpStatusCode501NotImplemented;
    BOOL isTemporaryError = self.response.statusCode == ITSHttpStatusCode503ServiceUnavailable ||
        self.response.statusCode == ITSHttpStatusCode500InternalServerError ||
        self.response.statusCode == ITSHttpStatusCode408RequestTimeout;
    BOOL isError = [self isConnectionError] || isFatalError || isTemporaryError;
    return isError;
}

- (NSDictionary*)errorMessage {
    NSString *titleError, *contentError;
    BOOL isFatalError = self.response.statusCode == ITSHttpStatusCode501NotImplemented;
    BOOL isTemporaryError = self.response.statusCode == ITSHttpStatusCode503ServiceUnavailable ||
        self.response.statusCode == ITSHttpStatusCode500InternalServerError ||
        self.response.statusCode == ITSHttpStatusCode408RequestTimeout;
    
    if(self.error && [self isConnectionError]){
        titleError = @"Connection Failed";
        //contentError = @"Please ensure that you are connected and try again.";
        contentError = @"Bạn vui lòng kiểm tra kết nối internet và sau đó thử lại.";
    } else if(isFatalError){
        titleError = @"Unknown Error";
        //contentError = @"Sorry! System could not complete your request. Please contact customer support for assistance.";
        contentError = @"Lỗi máy chủ. Bạn vui lòng quay lại tính năng này sau.";
    } else if (isTemporaryError) {
        titleError = @"Temporary Error";
        //contentError = @"System could not complete your request. Please try again in a few moments.";
        contentError = @"Máy chủ đang quá tải. Bạn vui lòng thử lại sau một ít phút nữa.";
    } else {
        titleError = @"Error";
        contentError = [FFHttpStatus descriptionForCode:self.response.statusCode];
    }
    
    return @{@"title" : titleError, @"message" : contentError, @"statusCode" : @(self.response.statusCode)/*, @"url" : self.response.URL*/};
}

@end
