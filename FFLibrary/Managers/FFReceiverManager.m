//
//  FFReceiverManager.m
//  MyApp
//
//  Created by Nguyen Nang on 1/30/15.
//  Copyright (c) 2015 Nguyen Nang. All rights reserved.
//

#import "FFReceiverManager.h"
#import "FFHandlerObject.h"

@interface FFReceiverManager ()
@property(nonatomic, strong) NSMutableDictionary *handlerList;
@end

@implementation FFReceiverManager

FFEnableDynamicLogging

DEF_SINGLETON( FFReceiverManager )

- (instancetype)init {

    self = [super init];
    if (self) {
        self.handlerList = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)unsubscribeForTarget:(id)target {

    //ILog(@"Unsubscriber: %@", NSStringFromClass([target class]));
    NSArray *allHandlers = [self.handlerList allValues];
    NSUInteger identifier = [target hash];
    //ILog(@"...identifier: %ld", identifier);

    for (NSMutableSet * handlers in allHandlers) {
        NSMutableSet *minusSet = [NSMutableSet set];
        for (FFHandlerObject *handler  in handlers) {
            if (handler.identifier == identifier) {
                [minusSet addObject:handler];
            }
        }
        [handlers minusSet:minusSet];
    }

//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SUBQUERY(self, $x, $x.identifier == %d).@count != 0", identifier];
//    NSArray *result = [allHandlers filteredArrayUsingPredicate:predicate];
//    ILog(@"...filted result: %@", result);
//    for (NSMutableSet *handlers in result) {
//
//        NSMutableSet *minusSet = [NSMutableSet set];
//
//        for (FFHandlerObject *handler in handlers) {
//
//            if (handler.identifier == identifier) {
//                [minusSet addObject:handler];
//            }
//        }
//
//        [handlers minusSet:minusSet];
//    }
}

- (void)subsribeWithTarget:(id)target selector:(SEL)selector block:(id)block {

    NSString *key = NSStringFromSelector(selector);
    NSMutableSet *handlers = self.handlerList[key];

    if (!handlers) {
        handlers = [NSMutableSet set];
    }

    FFHandlerObject *handler = [[FFHandlerObject alloc] init];
    handler.callback = [block copy];
    handler.target = target;
    handler.identifier = [target hash];
    handler.className = NSStringFromClass([target class]);
    handler.tcmd = key;

    FFInfo(@"Subscirbe (%@):%ld", [handler description], handler.identifier);
    [handlers addObject:handler];
    FFInfo(@"...%@", handlers);
    self.handlerList[key] = handlers;
}

- (void)executeBloksWithSelector:(SEL)selector enumerateBloks:(void(^)(id block))enumerateBloks {

    NSString *key = NSStringFromSelector(selector);

    NSMutableSet *toExecute = self.handlerList[key];

    for (FFHandlerObject *handler in toExecute) {
        if (handler.callback) {
            FFInfo(@"Send %@ notification to %@", key, handler.target);
            enumerateBloks(handler.callback);
        }
    }
}

@end
