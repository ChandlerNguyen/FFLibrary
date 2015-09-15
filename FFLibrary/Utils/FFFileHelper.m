//
//  FFFileHelper.m
//  MyApp
//
//  Created by Nguyen Nang on 6/25/15.
//  Copyright (c) 2015 Nguyen Nang. All rights reserved.
//

#import "FFFileHelper.h"

@implementation FFFileHelper
FFEnableDynamicLogging

+(NSString*)userDocumentPath {
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES) firstObject];
    return documentPath;
}

+(NSString*)applicationPath {
    return [[NSBundle mainBundle] resourcePath];
}

+(NSString*)defaultApplicationStorePath {
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES) firstObject];
    NSString *applicationName = [[[NSBundle mainBundle] infoDictionary] valueForKey:(id)kCFBundleNameKey];
    NSString *applicationStorePath = [documentPath stringByAppendingPathComponent:applicationName];
    
    return applicationStorePath;
}

// Lưu vào thư mục document
+(BOOL) writeArrayToFile:(NSMutableArray*) arrToWrite fileToWrite:(NSString *)fname {
    NSString *pathToSave = [[[self class] userDocumentPath] stringByAppendingPathComponent:fname];
    FFInfo(@"WRITE %@ TO %@", fname, pathToSave);
    BOOL success = [NSKeyedArchiver archiveRootObject:arrToWrite toFile:pathToSave];
    if (! success ) {
        return NO;
    }
    return YES;
    
}

+(NSMutableArray *) readArrayFromFile:(NSString *)fname atPath:(NSString*)path {
    NSString *pathToRead = [path stringByAppendingPathComponent:fname];
    //NSString *pathToRead = [[NSBundle mainBundle] pathForResource:@"danhngon" ofType:@"dat"];
    FFInfo(@"READ %@ FROM %@", fname, pathToRead);
    return [NSKeyedUnarchiver unarchiveObjectWithFile:pathToRead];
}

@end
