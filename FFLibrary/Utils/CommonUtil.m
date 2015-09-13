//
//  CommonUtil.m
//  MyApp
//
//  Created by Nguyen Nang on 2/8/15.
//  Copyright (c) 2015 Nguyen Nang. All rights reserved.
//

#import <SDWebImage/SDImageCache.h>
#import "CommonUtil.h"
#import "NSData+AES.h"
#import "Base64.h"
#import "ICUTemplateMatcher.h"
#import "WBErrorNoticeView.h"
#import "WBSuccessNoticeView.h"
#import "AFHTTPRequestOperation.h"

static NSString *const kCacheFolderString = @"Cache";
static NSString *const kCacheDomainString = @"com.nangnguyen.appios";
static bool isShowingHint;

@implementation CommonUtil

+ (NSString *) formatErrorWithOperation:(AFHTTPRequestOperation *)operation error:(NSError *)error{
//    NSString *errorStr ;
//    if(operation.response.statusCode != 200){
//        errorStr = [NSHTTPURLResponse localizedStringForStatusCode:operation.response.statusCode];
//    }else{
//        errorStr = error.localizedDescription;
//    }
    return error.localizedDescription;
}

+ (NSString *)generateUUID
{
    NSString *result = nil;
    
    CFUUIDRef uuid = CFUUIDCreate(NULL);
    if (uuid)
    {
        result = (__bridge_transfer NSString *)CFUUIDCreateString(NULL, uuid);
        CFRelease(uuid);
    }
    
    return result;
}

#pragma mark - Encrypt/Decrypt
+ (NSString*)aes256DecryptText:(NSString*)base64Text withKey:(NSString*)key
{
    NSData *cipherData;
    NSString *plainText;

    cipherData = [base64Text base64DecodedData];
    plainText  = [[NSString alloc] initWithData:[cipherData AES256DecryptWithKey:key] encoding:NSUTF8StringEncoding];
    return  plainText;
}

+ (NSString*)aes256EncryptText:(NSString*)plainText withKey:(NSString*)key
{
    NSData *cipherData;
    NSString *base64Text;

    cipherData = [[plainText dataUsingEncoding:NSUTF8StringEncoding] AES256EncryptWithKey:key];
    base64Text = [cipherData base64EncodedString];
    return base64Text;
}

#pragma mark - Cache Directory

+ (BOOL) createDiskDirectory:(NSString *)directoryPath{
    NSFileManager *fm = [NSFileManager defaultManager];
    if (![fm fileExistsAtPath:directoryPath]){
        NSError *error;
        BOOL result = [fm createDirectoryAtPath:directoryPath withIntermediateDirectories:true attributes:nil error:&error];
        if(result == false){
            NSLog(@"Failed to create cache directory: %@",[error localizedDescription]);
        }
        return result;
    }
    return true;
}

+ (NSString *) createCacheDirectory{
    NSString *cacheDirectory;
    NSString *diskCachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *CacheDirectory = [diskCachePath stringByAppendingPathComponent:kCacheFolderString];
    BOOL success = [CommonUtil createDiskDirectory:CacheDirectory];
    if ( success ) {
        cacheDirectory = CacheDirectory;

    }else{
        cacheDirectory = diskCachePath;

    }
    return cacheDirectory;
}

+ (NSString *) createDetailCacheDirectory:(NSString *)cachePathName{
    NSString *diskCachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *CacheDirectory = [diskCachePath stringByAppendingPathComponent:kCacheFolderString];
    NSString *detailCacheDir = [CacheDirectory stringByAppendingPathComponent:cachePathName];
    BOOL success = [CommonUtil createDiskDirectory:detailCacheDir];
    if ( success ) {
        return detailCacheDir;
    }else{
        return diskCachePath;
    }
}

+ (void) deleteCacheDirectory{
    NSString *CachePath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:kCacheFolderString];
    [[NSFileManager defaultManager] removeItemAtPath:CachePath error:nil];
}

+ (void) deleteURLCacheDirectory{
    NSString *URLCachePath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:kCacheDomainString];
    [[NSFileManager defaultManager] removeItemAtPath:URLCachePath error:nil];
}

+ (void)clearCache {
    [[SDImageCache sharedImageCache] clearDisk];
    [self deleteCacheDirectory];
    [self createCacheDirectory];
    [self deleteURLCacheDirectory];
}

+ (NSUInteger) getDiskCacheFileCount{
    NSUInteger count = [[SDImageCache sharedImageCache] getDiskCount];

    NSString *CachePath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:kCacheFolderString];
    NSString *URLCachePath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:kCacheDomainString];

    NSDirectoryEnumerator *fileEnumerator = [[NSFileManager defaultManager] enumeratorAtPath:CachePath];
    for (NSString *fileName in fileEnumerator){
        count += 1;
    }
    fileEnumerator = [[NSFileManager defaultManager] enumeratorAtPath:URLCachePath];
    for (NSString *fileName in fileEnumerator){
        count += 1;
    }
    return count;
}

+ (NSUInteger) getDiskCacheFileSize{
    NSUInteger size = [[SDImageCache sharedImageCache] getSize];

    NSString *CachePath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:kCacheFolderString];
    NSString *URLCachePath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:kCacheDomainString];

    size += [self recursiveDirectory:CachePath];
    NSDirectoryEnumerator *fileEnumerator = [[NSFileManager defaultManager] enumeratorAtPath:URLCachePath];
    for (NSString *fileName in fileEnumerator){
        NSString *filePath = [URLCachePath stringByAppendingPathComponent:fileName];
        NSDictionary *attrs = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];
        size += [attrs fileSize];
    }
    return size;
}

+ (int) recursiveDirectory:(NSString *) path{
    int size = 0;
    NSDirectoryEnumerator *fileEnumerator = [[NSFileManager defaultManager] enumeratorAtPath:path];
    for (NSString *fileName in fileEnumerator){
        NSString *filePath = [path stringByAppendingPathComponent:fileName];
        NSDictionary *attrs = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];
        if ([[attrs fileType] isEqualToString:NSFileTypeDirectory]) {
            size += [self recursiveDirectory:filePath];
        }else{
            size += [attrs fileSize];
        }

    }
    return size;
}

+ (NSArray *) getXmlTagAttrib:(NSString *)xmlStr andTag:(NSString *)tag andAttr:(NSString *)attr {
    NSString *regxpForTag = [[@"<\\s*" stringByAppendingString:tag] stringByAppendingString:@"\\s+([^>]*)\\s*/>"];
    NSString *regxpForTagAttrib = [attr stringByAppendingString:@"=\"([^\"]+)\""];
    
    NSRegularExpression *regex1 = [NSRegularExpression regularExpressionWithPattern:regxpForTag options:NSRegularExpressionCaseInsensitive error:nil];
    
    NSRegularExpression *regex2 = [NSRegularExpression regularExpressionWithPattern:regxpForTagAttrib options:NSRegularExpressionCaseInsensitive error:nil];
    
    NSArray *matches =    nil;
    NSMutableArray *retArray =[[NSMutableArray alloc] init];
    matches = [regex1 matchesInString:xmlStr options:0 range:NSMakeRange(0, [xmlStr length])];
    for (NSTextCheckingResult *match in matches) {
        NSRange range = [match range];
        NSString *subString = [xmlStr substringWithRange:range];
        NSTextCheckingResult *firstSubMatch = [regex2 firstMatchInString:subString options:0 range:NSMakeRange(0, [subString length])];
        NSRange subRange = [firstSubMatch rangeAtIndex:1];
        NSString *retString = [subString substringWithRange:subRange];
        [retArray addObject:retString];
    }
    return retArray;
}

+ (MGTemplateEngine *) sharedTemplateEngine{
    static MGTemplateEngine *_sharedEngine = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedEngine = [MGTemplateEngine templateEngine] ;
    });
    return _sharedEngine;
}

+ (NSString *) mergeToHTMLTemplateFromDictionary:(NSDictionary *)dictionary {
    MGTemplateEngine *engine = [[self class] sharedTemplateEngine];
    [engine setMatcher:[ICUTemplateMatcher matcherWithTemplateEngine:engine]];
    NSString *templatePath = [[NSBundle mainBundle] pathForResource:@"content_template" ofType:@"html"];
        
    NSMutableDictionary *variables = [[NSMutableDictionary alloc] init];
    [variables addEntriesFromDictionary:dictionary];
    
    return [engine processTemplateInFileAtPath:templatePath withVariables:variables];
}

+ (NSString *) mergeToHTMLTemplateFromDictionary:(NSDictionary *)dictionary template:(NSString*)templatePath {
    MGTemplateEngine *engine = [[self class] sharedTemplateEngine];
    [engine setMatcher:[ICUTemplateMatcher matcherWithTemplateEngine:engine]];
    
    NSMutableDictionary *variables = [[NSMutableDictionary alloc] init];
    [variables addEntriesFromDictionary:dictionary];
    
    return [engine processTemplateInFileAtPath:templatePath withVariables:variables];
}

+ (void) showHintHUD:(NSString *)content inView:(UIView *)view {
    [self showHintHUD:content inView:view withSlidingMode:WBNoticeViewSlidingModeDown];
}

+ (void) showHintHUD:(NSString *)content inView:(UIView *)view withSlidingMode:(WBNoticeViewSlidingMode)slidingMode{
    if (isShowingHint) {
        return;
    }
    
    WBErrorNoticeView *notice = [WBErrorNoticeView errorNoticeInView:view title:@"Thông báo lỗi:" message:content];
    notice.sticky = false;
    notice.alpha = 0.8;
    notice.slidingMode = slidingMode;
    [notice setDismissalBlock:^(BOOL dismissedInteractively) {
        isShowingHint = false;
    }];
    isShowingHint = true;
    [notice show];
}

+ (void) showHintHUD:(NSString *)content inView:(UIView *)view originY:(CGFloat) originY{
    if (isShowingHint) {
        return;
    }
    
    WBErrorNoticeView *notice = [WBErrorNoticeView errorNoticeInView:view title:@"Thông báo lỗi:" message:content];
    notice.sticky = false;
    notice.alpha = 0.8;
    notice.originY = originY;
    [notice setDismissalBlock:^(BOOL dismissedInteractively) {
        isShowingHint = false;
    }];
    isShowingHint = true;
    [notice show];
}

+ (void) showSuccessHUD:(NSString *)content inView:(UIView *)view withSlidingMode:(WBNoticeViewSlidingMode)slidingMode{
    if (isShowingHint) {
        return;
    }
    
    WBSuccessNoticeView *notice = [WBSuccessNoticeView successNoticeInView:view title:content];
    notice.sticky = false;
    notice.alpha = 0.8;
    notice.slidingMode = slidingMode;
    [notice setDismissalBlock:^(BOOL dismissedInteractively) {
        isShowingHint = false;
    }];
    isShowingHint = true;
    [notice show];
}

+ (void) showSuccessHUD:(NSString *)content inView:(UIView *)view{
    [self showSuccessHUD:content inView:view originY:0];
}

+ (void) showSuccessHUD:(NSString *)content inView:(UIView *)view originY:(CGFloat) originY{
    if (isShowingHint) {
        return;
    }
    
    WBSuccessNoticeView *notice = [WBSuccessNoticeView successNoticeInView:view title:content];
    notice.sticky = false;
    notice.alpha = 0.8;
    notice.originY = originY;
    [notice setDismissalBlock:^(BOOL dismissedInteractively) {
        isShowingHint = false;
    }];
    isShowingHint = true;
    [notice show];
}

+ (void)setGradientBackgroundForView:(UIView*)view darkColor:(UIColor*)darkColor lightColor:(UIColor*)lightColor
{
    // Create the gradient
    CAGradientLayer *gradient = [CAGradientLayer layer];
    
    // Set colors
    gradient.colors = @[(id)darkColor.CGColor,
                        (id)lightColor.CGColor];
    
    // Set bounds
    gradient.frame = view.bounds;
    
    // Add the gradient to the view
    [view.layer insertSublayer:gradient atIndex:0];
}

#pragma mark -
+ (int) intInRangeMinimum:(int)min andMaximum:(int)max {
    if (min > max) { return -1; }
    int adjustedMax = (max + 1) - min; // arc4random returns within the set {min, (max - 1)}
    int random = arc4random() % adjustedMax;
    int result = random + min;
    return result;
}

#pragma mark -
+ (NSMutableAttributedString*)getAttributedStringWithNewlinePrefix:(NSString*)prefix suffix:(NSString*)suffix
{
    NSString* message = [NSString stringWithFormat:@"%@ \n%@", prefix, suffix];
    //NSRange range = [message rangeOfString:suffix];

    NSRange prefixRange = [message rangeOfString:prefix];
    NSRange suffixRange = [message rangeOfString:suffix];

    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:message];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:prefixRange];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:14] range:prefixRange];
    //[attributedString addAttribute:NSUnderlineStyleAttributeName value:@1 range:prefixRange];

    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:suffixRange];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:suffixRange];
    return attributedString;
}

#pragma mark -
+ (BOOL)onSameDay:(NSDate *)date1 anotherDate:(NSDate *)date2
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps1 = [gregorian components:NSCalendarUnitDay|NSCalendarUnitMonth|NSCalendarUnitYear fromDate:date1];
    NSDateComponents *comps2 = [gregorian components:NSCalendarUnitDay|NSCalendarUnitMonth|NSCalendarUnitYear fromDate:date2];
    if (comps1.day == comps2.day && comps1.month == comps2.month && comps1.year == comps2.year)
        return YES;
    return NO;
}

+ (NSDate *)beginningOfTomorrow
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *now = [NSDate date];
    NSDate *tomorrow = [now dateByAddingTimeInterval:86400];
    NSDateComponents *comps = [gregorian components:NSCalendarUnitDay|NSCalendarUnitMonth|NSCalendarUnitYear fromDate:tomorrow];
    NSDate *beginning = [gregorian dateFromComponents:comps];
    return beginning;
}

+ (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return image;
}

+ (UIImage *)imageWithColor:(UIColor *)color roundedCorner:(CGFloat)cornerRadius
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f + cornerRadius * 2, 1.0f + cornerRadius + 2);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [[UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:cornerRadius] addClip];
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return [image resizableImageWithCapInsets:UIEdgeInsetsMake(cornerRadius, cornerRadius, cornerRadius, cornerRadius)];
}

+ (NSString *)getReadableTimeInterval:(NSTimeInterval)interval
{
    int absInterval = abs((int)interval);
    NSInteger day = absInterval / 86400;
    NSInteger hour = (absInterval % 86400) / 3600;
    NSInteger minute = (absInterval % 3600) / 60;
    NSInteger sec = (absInterval % 60);
    if (day > 0) {
        return [NSString stringWithFormat:@"%ld ngày %ld giờ", day, hour];
    } else if (hour > 0) {
        return [NSString stringWithFormat:@"%ld giờ %ld phút", hour, minute];
    } else if (minute > 0) {
        return [NSString stringWithFormat:@"%ld phút %ld giây", minute, sec];
    } else {
        return [NSString stringWithFormat:@"%ld giây", sec];
    }
}

+ (void)roundedCornerMask:(UIView *)view corners:(UIRectCorner)corners radius:(CGFloat)radius
{
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds
                                                   byRoundingCorners:corners
                                                         cornerRadii:CGSizeMake(radius, radius)];
    // Create the shape layer and set its path
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = view.bounds;
    maskLayer.path = maskPath.CGPath;
    // Set the newly created shape layer as the mask for the image view's layer
    view.layer.mask = maskLayer;
}

+ (void)dropShadow:(UIView *)view
{
    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:view.bounds];
    view.layer.masksToBounds = NO;
    view.layer.shadowColor = [UIColor blackColor].CGColor;
    view.layer.shadowOffset = CGSizeMake(0.0f, 1.0f);
    view.layer.shadowOpacity = 0.1f;
    view.layer.shadowPath = shadowPath.CGPath;
}

+ (void)dropShadow:(UIView *)view path:(UIBezierPath *)path
{
    view.layer.masksToBounds = NO;
    view.layer.shadowColor = [UIColor blackColor].CGColor;
    view.layer.shadowOffset = CGSizeMake(0.0f, 1.0f);
    view.layer.shadowOpacity = 0.1f;
    view.layer.shadowPath = path.CGPath;
}

+ (void)removeDropShadow:(UIView *)view
{
    view.layer.shadowColor = nil;
    view.layer.shadowOpacity = 0.0;
}

+ (BOOL)has31th:(NSInteger)month
{
    if (month == 1 || month == 3 || month == 5 || month == 7 || month == 8 || month == 10 || month == 12)
        return YES;
    return NO;
}

+ (NSInteger)lastDayOfMonth:(NSInteger)month year:(NSInteger)year
{
    switch (month) {
        case 1:
        case 3:
        case 5:
        case 7:
        case 8:
        case 10:
        case 12:
            return 31;
        case 4:
        case 6:
        case 9:
        case 11:
            return 30;
        case 2:
            if ([self isLeapYear:year])
                return 29;
            else
                return 28;
    }
    return 31;

}

+ (NSInteger)lastDayOfNextMonth:(NSInteger)month year:(NSInteger)year
{
    switch (month) {
        case 1:
            if ([self isLeapYear:year])
                return 29;
            else
                return 28;
        case 2:
        case 4:
        case 6:
        case 7:
        case 9:
        case 11:
        case 12:
            return 31;
        case 3:
        case 5:
        case 8:
        case 10:
            return 30;
    }
    return 31;
}

+ (NSInteger)next31th:(NSInteger)month
{
    switch (month) {
        case 1:
        case 2:
            return 3;
        case 3:
        case 4:
            return 5;
        case 5:
        case 6:
            return 7;
        case 7:
            return 8;
        case 8:
        case 9:
            return 10;
        case 10:
        case 11:
            return 12;
        case 12:
            return 1;
    }
    return 1;
}

+ (BOOL)isLeapYear:(NSInteger)year
{
    if (year % 400 == 0) {
        return YES;
    } else if (year % 100 == 0) {
        return NO;
    } else if (year % 4 == 0) {
        return YES;
    } else {
        return NO;
    }
}

+ (NSInteger)nextLeapYear:(NSInteger)year
{
    NSInteger next = year + (4 - year % 4);
    if (![self isLeapYear:next]) {
        next += 4;
    }
    return next;
}

@end
