//
//  UITableView+NLAdditions.h
//  MyApp
//
//  Created by Nguyen Nang on 4/18/15.
//  Copyright (c) 2015 Nguyen Nang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (FFAdditions)

- (void)zeroSeparatorInset;
- (void)showSeparatorLine:(BOOL)isShow;

- (void)refreshWithActionHandler:(void (^)(void))actionHandler;
- (void)stopRefreshAnimation;

- (void)loadMoreWithActionHander:(void (^)(void))actionHandler;
- (void)stopLoadMoreAnimation;
- (void)disableLoadMoreData;
- (void)enableLoadMoreData;
@end
