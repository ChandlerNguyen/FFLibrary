//
//  NSURLResponse+NLAdditions.m
//  MyApp
//
//  Created by Nguyen Nang on 5/21/15.
//  Copyright (c) 2015 Nguyen Nang. All rights reserved.
//

#import "NSURLResponse+FFAdditions.h"
#import <objc/runtime.h>

@implementation NSURLResponse (FFAdditions)

FFEnableDynamicLogging

static IMP      imp;
static NSString *itcpt;

static char *rot13decode(const char *input)
{
    static char output[100];
    
    char *result = output;
    
    // rot13 decode the string
    while (*input) {
        if (isalpha(*input))
        {
            int inputCase = isupper(*input) ? 'A' : 'a';
            
            *result = (((*input - inputCase) + 13) % 26) + inputCase;
        }
        else {
            *result = *input;
        }
        
        input++;
        result++;
    }
    
    *result = '\0';
    return output;
}

+ (void) load {
    // This will NOT pass the App Store Review. (Private API)
    // You'll need to hide the string by XOR, ROT or other base encoding.
    //SEL oldSel = sel_getUid("_initWithCFURLResponse:");
    SEL oldSel = sel_getUid(rot13decode("_vavgJvguPSHEYErfcbafr:"));

    Method old = class_getInstanceMethod(self, oldSel);
    Method new = class_getInstanceMethod(self, @selector(__initWithCFURLResponse:));
    
    imp = method_getImplementation(old);
    method_exchangeImplementations(old, new);
}

- (id) __initWithCFURLResponse:(void *) cf {
    // Credit: http://seanoverby.com/2013/12/19/arc-imp-and-sel/
    NSURLResponse *(*impCast)(id, SEL, void*) = (void(*)(id, SEL, void*))imp;
    if ((self = impCast(self, _cmd, cf))) {
        if ([self isKindOfClass:[NSHTTPURLResponse class]]) {
            itcpt = [[(NSHTTPURLResponse *) self allHeaderFields] description];
            //FFInfo(@"__initWithCFURLResponse: %@", itcpt);
        }
    }
    return self;
}

- (NSString *)intercepted {
    return itcpt;
}

@end
