//
//  FFFilterManager.h
//  MyApp
//
//  Created by Nguyen Nang on 6/5/15.
//  Copyright (c) 2015 Nguyen Nang. All rights reserved.
//


@interface FFFilterManager : NSObject
AS_SINGLETON( FFFilterManager )

@property(nonatomic, strong) NSArray *filterList;
@property(nonatomic, strong) NSArray *exclusionList;

- (BOOL)shouldBlockURL:(NSURL *)url;

- (BOOL)shouldBlockURL:(NSURL *)url filters:(NSArray *)filters;

- (BOOL)shouldIgnoreURL:(NSURL *)url;

- (BOOL)shoulIgnoreURL:(NSURL *)url ignoreFilters:(NSArray *)ignoreFilters;
@end
