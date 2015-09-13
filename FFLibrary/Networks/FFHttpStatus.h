//
//  FFHttpStatus.h
//  MCFF
//
//  Created by Nguyen Nang on 5/19/15.
//  Copyright (c) 2015 MCFF. All rights reserved.
//

/**
 * The list of Http status codes
 * http://en.wikipedia.org/wiki/List_of_HTTP_status_codes
 */

typedef NS_ENUM(NSUInteger, ITSHttpStatusCode) {
    // Informational
    ITSHttpStatusCode1XXInformationalUnknown = 1,
    ITSHttpStatusCode100Continue = 100,
    ITSHttpStatusCode101SwitchingProtocols = 101,
    ITSHttpStatusCode102Processing = 102,
    
    // Success
    ITSHttpStatusCode2XXSuccessUnknown = 2,
    ITSHttpStatusCode200OK = 200,
    ITSHttpStatusCode201Created = 201,
    ITSHttpStatusCode202Accepted = 202,
    ITSHttpStatusCode203NonAuthoritativeInformation = 203,
    ITSHttpStatusCode204NoContent = 204,
    ITSHttpStatusCode205ResetContent = 205,
    ITSHttpStatusCode206PartialContent = 206,
    ITSHttpStatusCode207MultiStatus = 207,
    ITSHttpStatusCode208AlreadyReported = 208,
    ITSHttpStatusCode209IMUsed = 209,
    
    // Redirection
    ITSHttpStatusCode3XXSuccessUnknown = 3,
    ITSHttpStatusCode300MultipleChoices = 300,
    ITSHttpStatusCode301MovedPermanently = 301,
    ITSHttpStatusCode302Found = 302,
    ITSHttpStatusCode303SeeOther = 303,
    ITSHttpStatusCode304NotModified = 304,
    ITSHttpStatusCode305UseProxy = 305,
    ITSHttpStatusCode306SwitchProxy = 306,
    ITSHttpStatusCode307TemporaryRedirect = 307,
    ITSHttpStatusCode308PermanentRedirect = 308,
    
    // Client error
    ITSHttpStatusCode4XXSuccessUnknown = 4,
    ITSHttpStatusCode400BadRequest = 400,
    ITSHttpStatusCode401Unauthorised = 401,
    ITSHttpStatusCode402PaymentRequired = 402,
    ITSHttpStatusCode403Forbidden = 403,
    ITSHttpStatusCode404NotFound = 404,
    ITSHttpStatusCode405MethodNotAllowed = 405,
    ITSHttpStatusCode406NotAcceptable = 406,
    ITSHttpStatusCode407ProxyAuthenticationRequired = 407,
    ITSHttpStatusCode408RequestTimeout = 408,
    ITSHttpStatusCode409Conflict = 409,
    ITSHttpStatusCode410Gone = 410,
    ITSHttpStatusCode411LengthRequired = 411,
    ITSHttpStatusCode412PreconditionFailed = 412,
    ITSHttpStatusCode413RequestEntityTooLarge = 413,
    ITSHttpStatusCode414RequestURITooLong = 414,
    ITSHttpStatusCode415UnsupportedMediaType = 415,
    ITSHttpStatusCode416RequestedRangeNotSatisfiable = 416,
    ITSHttpStatusCode417ExpectationFailed = 417,
    ITSHttpStatusCode418IamATeapot = 418,
    ITSHttpStatusCode419AuthenticationTimeout = 419,
    ITSHttpStatusCode420MethodFailureSpringFramework = 420,
    ITSHttpStatusCode420EnhanceYourCalmTwitter = 4200,
    ITSHttpStatusCode422UnprocessableEntity = 422,
    ITSHttpStatusCode423Locked = 423,
    ITSHttpStatusCode424FailedDependency = 424,
    ITSHttpStatusCode424MethodFailureWebDaw = 4240,
    ITSHttpStatusCode425UnorderedCollection = 425,
    ITSHttpStatusCode426UpgradeRequired = 426,
    ITSHttpStatusCode428PreconditionRequired = 428,
    ITSHttpStatusCode429TooManyRequests = 429,
    ITSHttpStatusCode431RequestHeaderFieldsTooLarge = 431,
    ITSHttpStatusCode444NoResponseNginx = 444,
    ITSHttpStatusCode449RetryWithMicrosoft = 449,
    ITSHttpStatusCode450BlockedByWindowsParentalControls = 450,
    ITSHttpStatusCode451RedirectMicrosoft = 451,
    ITSHttpStatusCode451UnavailableForLegalReasons = 4510,
    ITSHttpStatusCode494RequestHeaderTooLargeNginx = 494,
    ITSHttpStatusCode495CertErrorNginx = 495,
    ITSHttpStatusCode496NoCertNginx = 496,
    ITSHttpStatusCode497HTTPToHTTPSNginx = 497,
    ITSHttpStatusCode499ClientClosedRequestNginx = 499,
    
    
    // Server error
    ITSHttpStatusCode5XXSuccessUnknown = 5,
    ITSHttpStatusCode500InternalServerError = 500,
    ITSHttpStatusCode501NotImplemented = 501,
    ITSHttpStatusCode502BadGateway = 502,
    ITSHttpStatusCode503ServiceUnavailable = 503,
    ITSHttpStatusCode504GatewayTimeout = 504,
    ITSHttpStatusCode505HTTPVersionNotSupported = 505,
    ITSHttpStatusCode506VariantAlsoNegotiates = 506,
    ITSHttpStatusCode507InsufficientStorage = 507,
    ITSHttpStatusCode508LoopDetected = 508,
    ITSHttpStatusCode509BandwidthLimitExceeded = 509,
    ITSHttpStatusCode510NotExtended = 510,
    ITSHttpStatusCode511NetworkAuthenticationRequired = 511,
    ITSHttpStatusCode522ConnectionTimedOut = 522,
    ITSHttpStatusCode598NetworkReadTimeoutErrorUnknown = 598,
    ITSHttpStatusCode599NetworkConnectTimeoutErrorUnknown = 599
};

@interface FFHttpStatus : NSObject

/**
 *  Return description for a specific HTTP status code
 *
 */
+ (NSString *)descriptionForCode:(ITSHttpStatusCode)code;
@end
