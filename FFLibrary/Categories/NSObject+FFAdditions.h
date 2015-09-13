//
//  NSObject+NLAdditions.h
//  MyApp
//
//  Created by Nguyen Nang on 4/16/15.
//  Copyright (c) 2015 Nguyen Nang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (FFAdditions)

+ (id)allocByClass:(Class)clazz;
+ (id)allocByClassName:(NSString *)clazzName;

/** Associates a copy of an object with the reciever.
 
 The associated value is copied as if it were a property
 synthesized with `nonatomic` and `copy`.
 
 Using copied association is recommended for a block or
 otherwise `NSCopying`-compliant instances like NSString.
 
 @param value Any object, pointer, or value.
 @param key A unique key pointer.
 */
- (void)associateCopyOfValue:(id)value withKey:(const void *)key;

/** Returns the associated value for a key on the reciever.
 
 @param key A unique key pointer.
 @return The object associated with the key, or `nil` if not found.
 */
- (id)associatedValueForKey:(const void *)key;

@end
