//
//  NSString+NLJson.m
//  MyApp
//
//  Created by Nguyen Nang on 4/15/15.
//  Copyright (c) 2015 Nguyen Nang. All rights reserved.
//

#import "NSString+FFJson.h"

@implementation NSString (FFJson)

FFEnableDynamicLogging

-(NSDictionary*) jsonDictionary
{
    NSError *jsonError;
    NSData *objectData = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:objectData
                                                         options:NSJSONReadingMutableContainers
                                                           error:&jsonError];
    if (jsonError) {
        FFError(@"error converting string to NSDictionary: %@", jsonError.localizedDescription);
    }
    
    return (jsonError ? nil : json);
}
@end
