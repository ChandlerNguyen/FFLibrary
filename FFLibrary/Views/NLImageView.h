//
//  NLImageView.h
//  MyApp
//
//  Created by Nguyen Nang on 2/1/15.
//  Copyright (c) 2015 Nguyen Nang. All rights reserved.
//

#import "SDWebImageManager.h"

typedef NS_ENUM(NSUInteger, NLImageViewType) {
    NLImageViewTypeNone,
    NLImageViewTypeCircle,
    NLImageViewTypeSquare
};

@interface NLImageView : UIImageView

/**
Default QMUserImageViewType QMUserImageViewTypeNone
*/
@property (assign, nonatomic) NLImageViewType imageViewType;

- (void)sd_setImage:(UIImage *)image withKey:(NSString *)key;
- (void)setImageWithURL:(NSURL *)url
            placeholder:(UIImage *)placehoder
                options:(SDWebImageOptions)options
               progress:(SDWebImageDownloaderProgressBlock)progress
         completedBlock:(SDWebImageCompletionBlock)completedBlock;

@end
