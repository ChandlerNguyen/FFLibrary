//
//  FFFileHelper.h
//  MyApp
//
//  Created by Nguyen Nang on 6/25/15.
//  Copyright (c) 2015 Nguyen Nang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FFFileHelper : NSObject

+(NSString*)userDocumentPath;
+(NSString*)defaultApplicationStorePath;
+(NSString*)applicationPath;

+(BOOL) writeArrayToFile:(NSMutableArray*) arrToWrite fileToWrite:(NSString *)fname;
+(NSMutableArray *) readArrayFromFile:(NSString *)fname atPath:(NSString*)path;

@end
