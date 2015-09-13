//
//  FFReceiverManager.h
//  MyApp
//
//  Created by Nguyen Nang on 1/30/15.
//  Copyright (c) 2015 Nguyen Nang. All rights reserved.
//

@interface FFReceiverManager : NSObject

AS_SINGLETON( FFReceiverManager )

- (void)unsubscribeForTarget:(id)target;
- (void)subsribeWithTarget:(id)target selector:(SEL)selector block:(id)block;
- (void)executeBloksWithSelector:(SEL)selector enumerateBloks:(void(^)(id block))enumerateBloks;

@end
