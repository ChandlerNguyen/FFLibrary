//
//  NLStatusView.m
//  MyApp
//
//  Created by Nguyen Nang on 5/21/15.
//  Copyright (c) 2015 Nguyen Nang. All rights reserved.
//

#import "NLStatusView.h"
#import "Parus.h"

static char kRetryNetworkBlockKey;

@interface NLStatusView()

@property (nonatomic,strong) UIActivityIndicatorView *activityIndicator;
@property (nonatomic,strong) UIImageView *retryView;
@property (nonatomic,strong) UILabel *message;

@end

@implementation NLStatusView

- (instancetype)init {
    
    self = [super init];
    if (self) {
        [self createUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.activityIndicator.translatesAutoresizingMaskIntoConstraints = NO;
    [self.activityIndicator sizeToFit];
    [self addSubview:self.activityIndicator];
    
    //[self.activityIndicator startAnimating];
    
    self.retryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"btn_refresh"]];
    self.retryView.translatesAutoresizingMaskIntoConstraints = NO;
    self.retryView.contentMode = UIViewContentModeScaleAspectFit;
    self.retryView.userInteractionEnabled = true;
    self.retryView.hidden = YES;
    [self.retryView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onRetryClicked)]];
    [self addSubview:self.retryView];
    
    self.message = [[UILabel alloc] init];
    self.message.translatesAutoresizingMaskIntoConstraints = NO;
    self.message.hidden = YES;
    self.message.text = @"Thử lại";
    [self addSubview:self.message];
    
    
    [self addConstraints:@[PVCenterXOf(self.retryView).equalTo.centerXOf(self).asConstraint,
                           PVCenterYOf(self.retryView).equalTo.centerYOf(self).asConstraint,
                           
                           PVCenterXOf(self.activityIndicator).equalTo.centerXOf(self).asConstraint,
                           PVCenterYOf(self.activityIndicator).equalTo.centerYOf(self).asConstraint,
                           
                           PVCenterXOf(self.message).equalTo.centerXOf(self).asConstraint,
                           PVBottomOf(self.message).equalTo.topOf(self.retryView).minus(5).asConstraint
                           ]];
    
    [self setBackgroundColor:UIColorFromRGB(0xf0f0f0)];
}

- (void) onRetryClicked{
    self.status = NLStatusViewTypeLoading;
    NLSenderBlock block = [self associatedValueForKey:&kRetryNetworkBlockKey];
    if (block) block(self);
}

- (void)clickedOnRetryWithActionHandler:(void (^)(id sender))actionHandler {
    [self associateCopyOfValue:actionHandler withKey:&kRetryNetworkBlockKey];
}

- (void) setStatus:(NLStatusViewType)status{
    _status = status;
    switch (status) {
        case NLStatusViewTypeNormal:
            self.hidden = YES;
            break;
        case NLStatusViewTypeNoNetwork:
            self.hidden = NO;
            break;
        case NLStatusViewTypeLogo:
            self.hidden = NO;
            self.activityIndicator.hidden = YES;
            break;
        case NLStatusViewTypeLoading:
            self.hidden = NO;
            self.activityIndicator.hidden = NO;
            self.retryView.hidden = YES;
            self.message.hidden = YES;
            break;
        case NLStatusViewTypeRetry:
            self.hidden = NO;
            self.retryView.hidden = NO;
            self.message.hidden = NO;
            break;
    }
    if(status == NLStatusViewTypeLoading){
        [self.activityIndicator startAnimating];
    }else{
        [self.activityIndicator stopAnimating];
    }
}

@end
