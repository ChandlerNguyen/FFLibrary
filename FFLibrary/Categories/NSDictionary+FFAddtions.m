//
//  NSDictionary+NLAddtions.m
//  MyApp
//
//  Created by Nguyen Nang on 4/21/15.
//  Copyright (c) 2015 Nguyen Nang. All rights reserved.
//

#import "NSDictionary+FFAddtions.h"

@implementation NSDictionary (FFAddtions)

//- (NSDictionaryAppendBlock)APPEND
//{
//    NSDictionaryAppendBlock block = ^ NSDictionary * ( NSString * key, id value )
//    {
//        if ( key && value )
//        {
//            NSString * className = [[self class] description];
//            
//            if ( [self isKindOfClass:[NSMutableDictionary class]] || [className isEqualToString:@"NSMutableDictionary"] || [className isEqualToString:@"__NSDictionaryM"] )
//            {
//                [(NSMutableDictionary *)self setObject:value atPath:key];
//                return self;
//            }
//            else
//            {
//                NSMutableDictionary * dict = [NSMutableDictionary dictionaryWithDictionary:self];
//                [dict setObject:value atPath:key];
//                return dict;
//            }
//        }
//        
//        return self;
//    };
//    
//    return [[block copy] autorelease];
//}
//
//- (BOOL)setObject:(NSObject *)obj atPath:(NSString *)path
//{
//    return [self setObject:obj atPath:path separator:nil];
//}
//
//- (BOOL)setObject:(NSObject *)obj atPath:(NSString *)path separator:(NSString *)separator
//{
//    if ( 0 == [path length] )
//        return NO;
//    
//    if ( nil == separator )
//    {
//        path = [path stringByReplacingOccurrencesOfString:@"." withString:@"/"];
//        separator = @"/";
//    }
//    
//    NSArray * array = [path componentsSeparatedByString:separator];
//    if ( 0 == [array count] )
//    {
//        [self setObject:obj forKey:path];
//        return YES;
//    }
//    
//    NSMutableDictionary *	upperDict = self;
//    NSDictionary *			dict = nil;
//    NSString *				subPath = nil;
//    
//    for ( subPath in array )
//    {
//        if ( 0 == [subPath length] )
//            continue;
//        
//        if ( [array lastObject] == subPath )
//            break;
//        
//        dict = [upperDict objectForKey:subPath];
//        if ( nil == dict )
//        {
//            dict = [NSMutableDictionary dictionary];
//            [upperDict setObject:dict forKey:subPath];
//        }
//        else
//        {
//            if ( NO == [dict isKindOfClass:[NSDictionary class]] )
//                return NO;
//            
//            if ( NO == [dict isKindOfClass:[NSMutableDictionary class]] )
//            {
//                dict = [NSMutableDictionary dictionaryWithDictionary:dict];
//                [upperDict setObject:dict forKey:subPath];
//            }
//        }
//        
//        upperDict = (NSMutableDictionary *)dict;
//    }
//    
//    [upperDict setObject:obj forKey:subPath];
//    return YES;
//}

@end
