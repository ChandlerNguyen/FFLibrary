//
//  NSURLResponse+NLAdditions.h
//  MyApp
//
//  Created by Nguyen Nang on 5/21/15.
//  Copyright (c) 2015 Nguyen Nang. All rights reserved.
//

#import <Foundation/Foundation.h>

/// http://stackoverflow.com/questions/15476539/uiwebview-capturing-the-response-headers
/// https://github.com/x43x61x69/Postman/tree/9b29ec9552f3536dfcea9bac35964b6f2998c020
@interface NSURLResponse (FFAdditions)
@property (readonly) NSString *intercepted;
@end
