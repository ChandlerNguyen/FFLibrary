//
//  FFFilteredWebCache.m
//  MyApp
//
//  Created by Nguyen Nang on 6/5/15.
//  Copyright (c) 2015 Nguyen Nang. All rights reserved.
//

#import "FFFilteredWebCache.h"
#import "FFFilterManager.h"

@implementation FFFilteredWebCache

FFEnableDynamicLogging

-(NSCachedURLResponse *)cachedResponseForRequest:(NSURLRequest *)request{
    NSURL *url = [request URL];
    BOOL blockURL = [[FFFilterManager instance] shouldBlockURL:url];
    if (blockURL) {
        FFInfo(@"blocked request url: %@", [[request URL] absoluteString]);
        NSURLResponse *response = [[NSURLResponse alloc] initWithURL:url
                                                            MIMEType:@"text/plain"
                                               expectedContentLength:1
                                                    textEncodingName:nil];


        NSCachedURLResponse *cachedResponse = [[NSCachedURLResponse alloc] initWithResponse:response
                                                                                       data:[NSData dataWithBytes:" " length:1]];


        [super storeCachedResponse:cachedResponse forRequest:request];
    }
    return [super cachedResponseForRequest:request];
}

+ (BOOL) createDiskDirectory:(NSString *)directoryPath{
    NSFileManager *fm = [NSFileManager defaultManager];
    if (![fm fileExistsAtPath:directoryPath]){
        NSError *error;
        BOOL result = [fm createDirectoryAtPath:directoryPath withIntermediateDirectories:true attributes:nil error:&error];
        if(result == false){
            NSLog(@"Failed to create cache directory: %@",[error localizedDescription]);
        }
        return result;
    }
    return true;
}

+ (NSString *) createCacheDirectory{
    NSString *cacheDirectory;
    NSString *diskCachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *CacheDirectory = [diskCachePath stringByAppendingPathComponent:@"Cache"];
    BOOL success = [CommonUtil createDiskDirectory:CacheDirectory];
    if ( success ) {
        cacheDirectory = CacheDirectory;

    }else{
        cacheDirectory = diskCachePath;

    }
    return cacheDirectory;
}

+(void)startFilterWebCache{
    NSString *cacheDirectory = [[self class] createCacheDirectory];

    NSUInteger discCapacity = 10*1024*1024;
    NSUInteger memoryCapacity = 512*1024;

    FFFilteredWebCache *cache =
            [[FFFilteredWebCache alloc] initWithMemoryCapacity: memoryCapacity
                                                diskCapacity: discCapacity diskPath:cacheDirectory];
    [NSURLCache setSharedURLCache:cache];
}
+(void)endFilterWebCache{
    NSURLCache *sharedCache = [[NSURLCache alloc] initWithMemoryCapacity:0
                                                            diskCapacity:0
                                                                diskPath:nil];
    [NSURLCache setSharedURLCache:sharedCache];
}

@end
