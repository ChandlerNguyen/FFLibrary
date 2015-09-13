//
//  FFCommonMacro.h
//  FFLibrary
//
//  Created by Nang Nguyen on 9/13/15.
//  Copyright (c) 2015 MCFF. All rights reserved.
//

#ifndef FFLibrary_FFCommonMacro_h
#define FFLibrary_FFCommonMacro_h

// Logging functions
#define FFInfo(fmt, ...) DDLogInfo((@"[Info]%s, Line %d: " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#define FFWarn(fmt, ...) DDLogWarn((@"[Warn]%s, Line %d: " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#define FFError(fmt, ...) DDLogError((@"[Error]%s, Line %d: " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#define FFVerbose(fmt, ...) DDLogVerbose((@"[Error]%s, Line %d: " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#define FFDebug(fmt, ...) DDLogDebug((@"[Debug]%s, Line %d: " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);

#define FFAssertAbstract() NSAssert(NO, @"Abstract method is called.");
#define FFAssertNotSupported() NSAssert(NO, @"Method is not supported.");

// Enable Dynamic Logging
#define  FFEnableDynamicLogging + (DDLogLevel)ddLogLevel { return ddLogLevel; } + (void)ddSetLogLevel:(DDLogLevel)logLevel{ ddLogLevel = logLevel;}

#define $safe(obj)  ((NSNull *)(obj) == [NSNull null] ? nil : (obj))
#define $bool(val)      [NSNumber numberWithBool:(val)]
#define $char(val)      [NSNumber numberWithChar:(val)]
#define $double(val)    [NSNumber numberWithDouble:(val)]
#define $float(val)     [NSNumber numberWithFloat:(val)]
#define $int(val)       [NSNumber numberWithInt:(val)]
#define $integer(val)   [NSNumber numberWithInteger:(val)]
#define $long(val)      [NSNumber numberWithLong:(val)]
#define $longlong(val)  [NSNumber numberWithLongLong:(val)]
#define $short(val)     [NSNumber numberWithShort:(val)]
#define $uchar(val)     [NSNumber numberWithUnsignedChar:(val)]
#define $uint(val)      [NSNumber numberWithUnsignedInt:(val)]
#define $uinteger(val)  [NSNumber numberWithUnsignedInteger:(val)]
#define $ulong(val)     [NSNumber numberWithUnsignedLong:(val)]
#define $ulonglong(val) [NSNumber numberWithUnsignedLongLong:(val)]
#define $ushort(val)    [NSNumber numberWithUnsignedShort:(val)]

#define DO_AT_MAIN(x) dispatch_async(dispatch_get_main_queue(), ^{ x; });

#define IOS8_OR_LATER		( [[[UIDevice currentDevice] systemVersion] compare:@"8.0"] != NSOrderedAscending )
#define IOS7_OR_LATER		( [[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending )
#define IOS6_OR_LATER		( [[[UIDevice currentDevice] systemVersion] compare:@"6.0"] != NSOrderedAscending )
#define IOS5_OR_LATER		( [[[UIDevice currentDevice] systemVersion] compare:@"5.0"] != NSOrderedAscending )
#define IOS4_OR_LATER		( [[[UIDevice currentDevice] systemVersion] compare:@"4.0"] != NSOrderedAscending )
#define IOS3_OR_LATER		( [[[UIDevice currentDevice] systemVersion] compare:@"3.0"] != NSOrderedAscending )

#define IOS7_OR_EARLIER		( !IOS8_OR_LATER )
#define IOS6_OR_EARLIER		( !IOS7_OR_LATER )
#define IOS5_OR_EARLIER		( !IOS6_OR_LATER )
#define IOS4_OR_EARLIER		( !IOS5_OR_LATER )
#define IOS3_OR_EARLIER		( !IOS4_OR_LATER )

#define CONTAINS(attrName, attrVal) [NSPredicate predicateWithFormat:@"self.%K CONTAINS %@", attrName, attrVal]
#define LIKE(attrName, attrVal) [NSPredicate predicateWithFormat:@"%K like %@", attrName, attrVal]
#define LIKE_C(attrName, attrVal) [NSPredicate predicateWithFormat:@"%K like[c] %@", attrName, attrVal]
#define IS(attrName, attrVal) [NSPredicate predicateWithFormat:@"%K == %@", attrName, attrVal]

#define START_LOG_TIME double startTime = CFAbsoluteTimeGetCurrent();
#define END_LOG_TIME FFInfo(@"%s %f", __PRETTY_FUNCTION__, CFAbsoluteTimeGetCurrent()-startTime);

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#undef	AS_SINGLETON
#define AS_SINGLETON

#undef	AS_SINGLETON
#define AS_SINGLETON( ... ) \
+ (instancetype)instance;


#undef	DEF_SINGLETON
#define DEF_SINGLETON( ... ) \
+ (instancetype)instance \
{ \
static dispatch_once_t once; \
static id __singleton__; \
dispatch_once( &once, ^{ __singleton__ = [[self alloc] init]; } ); \
return __singleton__; \
}

#undef	AS_STATIC_PROPERTY_INT
#define AS_STATIC_PROPERTY_INT( __name ) \
@property (nonatomic, readonly) NSInteger __name; \
+ (NSInteger)__name;

#undef	DEF_STATIC_PROPERTY_INT
#define DEF_STATIC_PROPERTY_INT( __name, __value ) \
@dynamic __name; \
+ (NSInteger)__name \
{ \
return __value; \
}

#undef	AS_INT
#define AS_INT	AS_STATIC_PROPERTY_INT

#undef	DEF_INT
#define DEF_INT	DEF_STATIC_PROPERTY_INT

typedef void(^NLSenderBlock)(id sender);
typedef void(^NLTimerBlock)(NSTimeInterval time);

// HTTP methods
static NSString* const kHttpMethodGet = @"GET";
static NSString* const kHttpMethodPut = @"PUT";
static NSString* const kHttpMethodPost = @"POST";
static NSString* const kHttpMethodDelete = @"DELETE";

#endif
