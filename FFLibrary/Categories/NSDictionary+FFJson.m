//
//  NSDictionary+NLJson.m
//  MyApp
//
//  Created by Nguyen Nang on 4/15/15.
//  Copyright (c) 2015 Nguyen Nang. All rights reserved.
//

#import "NSDictionary+FFJson.h"

@implementation NSDictionary (FFJson)

FFEnableDynamicLogging

- (NSString*) jsonString
{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self
                                                       options:0 // or NSJSONWritingPrettyPrinted
                                                         error:&error];
    if (!jsonData) {
        FFError(@"Error serializing JSON: %@", error);
        return nil;
    } else {
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
}
@end
