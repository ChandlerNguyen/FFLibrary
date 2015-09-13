//
//  CommonUtil.h
//  MyApp
//
//  Created by Nguyen Nang on 2/8/15.
//  Copyright (c) 2015 Nguyen Nang. All rights reserved.
//
#import "WBNoticeView.h"

@class AFHTTPRequestOperation;

typedef NS_ENUM(NSUInteger , NLDateFormatType) {
    NLDateFormatTypeYMD,
    NLDateFormatTypeMD,
    NLDateFormatTypeYMDHM,
    NLDateFormatTypeYMDHMS,
    NLDateFormatTypeMDHM
};

@interface CommonUtil : NSObject

+ (NSString *)generateUUID;
+ (NSString *) formatErrorWithOperation:(AFHTTPRequestOperation *)operation error:(NSError *)error;

// Encrypt/Decrypt text
+ (NSString *)aes256DecryptText:(NSString*)base64Text withKey:(NSString*)key;
+ (NSString *)aes256EncryptText:(NSString*)plainText withKey:(NSString*)key;

// Cache folder
+ (BOOL)createDiskDirectory:(NSString *)directoryPath;
+ (NSString *)createDetailCacheDirectory:(NSString *)cachePathName;
+ (NSString *)createCacheDirectory;
+ (void)deleteCacheDirectory;
+ (void)deleteURLCacheDirectory;
+ (NSUInteger)getDiskCacheFileCount;
+ (NSUInteger)getDiskCacheFileSize;
+ (void)clearCache;

+ (NSArray *)getXmlTagAttrib:(NSString *) xmlStr andTag:(NSString *) tag andAttr:(NSString *) attr;
+ (NSString *)mergeToHTMLTemplateFromDictionary:(NSDictionary *)dictionary;
+ (NSString *)mergeToHTMLTemplateFromDictionary:(NSDictionary *)dictionary template:(NSString*)templatePath;

+ (void) showHintHUD:(NSString *)content inView:(UIView *)view;
+ (void) showHintHUD:(NSString *)content inView:(UIView *)view withSlidingMode:(WBNoticeViewSlidingMode)slidingMode;
+ (void) showHintHUD:(NSString *)content inView:(UIView *)view originY:(CGFloat) originY;
+ (void) showSuccessHUD:(NSString *)content inView:(UIView *)view;
+ (void) showSuccessHUD:(NSString *)content inView:(UIView *)view originY:(CGFloat) originY;
+ (void) showSuccessHUD:(NSString *)content inView:(UIView *)view withSlidingMode:(WBNoticeViewSlidingMode)slidingMode;

+ (void)setGradientBackgroundForView:(UIView*)view darkColor:(UIColor*)darkColor lightColor:(UIColor*)lightColor;

+ (int) intInRangeMinimum:(int)min andMaximum:(int)max;

+ (NSMutableAttributedString *)getAttributedStringWithNewlinePrefix:(NSString *)prefix suffix:(NSString *)suffix;

+ (BOOL)onSameDay:(NSDate *)date1 anotherDate:(NSDate *)date2;
+ (NSDate *)beginningOfTomorrow;
+ (UIImage *)imageWithColor:(UIColor *)color;
+ (UIImage *)imageWithColor:(UIColor *)color roundedCorner:(CGFloat)cornerRadius;
+ (NSString *)getReadableTimeInterval:(NSTimeInterval)interval;
+ (void)roundedCornerMask:(UIView *)view corners:(UIRectCorner)corners radius:(CGFloat)radius;
+ (void)dropShadow:(UIView *)view;
+ (void)dropShadow:(UIView *)view path:(UIBezierPath *)path;
+ (void)removeDropShadow:(UIView *)view;
+ (BOOL)has31th:(NSInteger)month;
+ (NSInteger)lastDayOfMonth:(NSInteger)month year:(NSInteger)year;
+ (NSInteger)lastDayOfNextMonth:(NSInteger)month year:(NSInteger)year;
+ (NSInteger)next31th:(NSInteger)month;
+ (BOOL)isLeapYear:(NSInteger)year;
+ (NSInteger)nextLeapYear:(NSInteger)year;

@end
