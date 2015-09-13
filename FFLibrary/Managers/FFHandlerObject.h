//
//  FFHandlerObject.h
//  MyApp
//
//  Created by Nguyen Nang on 1/30/15.
//  Copyright (c) 2015 Nguyen Nang. All rights reserved.
//

@interface FFHandlerObject : NSObject

@property(nonatomic, weak) id target;
@property(nonatomic, strong) id callback;
@property(nonatomic, assign) NSUInteger identifier;
@property(nonatomic, strong) NSString *className;
@property(nonatomic, strong) NSString *tcmd;

@end
