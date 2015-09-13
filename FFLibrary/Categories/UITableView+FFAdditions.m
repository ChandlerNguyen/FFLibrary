//
//  UITableView+NLAdditions.m
//  MyApp
//
//  Created by Nguyen Nang on 4/18/15.
//  Copyright (c) 2015 Nguyen Nang. All rights reserved.
//

#import "UITableView+FFAdditions.h"
#import "SVPullToRefresh.h"

@implementation UITableView (FFAdditions)

- (void)zeroSeparatorInset
{
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000
    if ([self respondsToSelector:@selector(setLayoutMargins:)])
        self.layoutMargins = UIEdgeInsetsZero;
#endif
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
    if ([self respondsToSelector: @selector(setSeparatorInset:)])
        self.separatorInset = UIEdgeInsetsZero;
#endif
}

- (void)showSeparatorLine:(BOOL)isShow {
    if (isShow) {
        self.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    } else {
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
}

- (void)refreshWithActionHandler:(void (^)(void))actionHandler {
    [self addPullToRefreshWithActionHandler:actionHandler];
}

- (void)stopRefreshAnimation {
    [self.pullToRefreshView stopAnimating];
}

- (void)loadMoreWithActionHander:(void (^)(void))actionHandler {
    [self addInfiniteScrollingWithActionHandler:actionHandler];
}

- (void)stopLoadMoreAnimation {
    [self.infiniteScrollingView stopAnimating];
}

- (void)disableLoadMoreData {
    [self.infiniteScrollingView setEnabled:NO];
}

- (void)enableLoadMoreData {
    [self.infiniteScrollingView setEnabled:YES];
}

@end
