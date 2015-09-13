//
//  NSObject+NLAdditions.m
//  MyApp
//
//  Created by Nguyen Nang on 4/16/15.
//  Copyright (c) 2015 Nguyen Nang. All rights reserved.
//

#import "NSObject+FFAdditions.h"
#import <objc/runtime.h>

@implementation NSObject (FFAdditions)

+ (id)allocByClass:(Class)clazz
{
    if ( nil == clazz )
        return nil;
    
    return [clazz alloc];
}

+ (id)allocByClassName:(NSString *)clazzName
{
    if ( nil == clazzName || 0 == [clazzName length] )
        return nil;
    
    Class clazz = NSClassFromString( clazzName );
    if ( nil == clazz )
        return nil;
    
    return [clazz alloc];
}

- (void)associateCopyOfValue:(id)value withKey:(const void *)key {
    objc_setAssociatedObject(self, key, value, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (id)associatedValueForKey:(const void *)key {
    return objc_getAssociatedObject(self, key);
}

@end
