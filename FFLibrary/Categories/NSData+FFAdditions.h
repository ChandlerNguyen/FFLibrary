//
//  NSData+NLAdditions.h
//  MyApp
//
//  Created by Nguyen Nang on 4/21/15.
//  Copyright (c) 2015 Nguyen Nang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (FFAdditions)

@property (nonatomic, readonly) NSData *	MD5;
@property (nonatomic, readonly) NSString *	MD5String;

+ (NSData *)fromResource:(NSString *)resName;

@end
