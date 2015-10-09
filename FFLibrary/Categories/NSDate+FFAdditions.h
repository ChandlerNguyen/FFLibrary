//
//  NSDate+NLAdditions.h
//  MyApp
//
//  Created by Nguyen Nang on 4/15/15.
//  Copyright (c) 2015 Nguyen Nang. All rights reserved.
//

#import <Foundation/Foundation.h>

#define SECOND	(1)
#define MINUTE	(60 * SECOND)
#define HOUR	(60 * MINUTE)
#define DAY		(24 * HOUR)
#define MONTH	(30 * DAY)
#define YEAR	(12 * MONTH)

@interface NSDate (FFAdditions)

@property (nonatomic, readonly) NSInteger	year;
@property (nonatomic, readonly) NSInteger	month;
@property (nonatomic, readonly) NSInteger	day;
@property (nonatomic, readonly) NSInteger	hour;
@property (nonatomic, readonly) NSInteger	minute;
@property (nonatomic, readonly) NSInteger	second;
@property (nonatomic, readonly) NSInteger	weekday;

- (NSString *)stringWithDateFormat:(NSString *)format;
- (NSString *)timeAgo;
- (NSString *)timeLeft;

+ (long long)timeStamp;
+ (NSDate *)dateWithString:(NSString *)string;
+ (NSDate *)now;
+ (NSDate *)dateYesterday;
+ (NSDate *)dateTomorrow;

// Adjusting dates
// https://github.com/azu/NSDate-Escort
- (NSDate *)dateByAddingYears:(NSInteger) dYears;
- (NSDate *)dateBySubtractingYears:(NSInteger) dYears;
- (NSDate *)dateByAddingMonths:(NSInteger) dMonths;
- (NSDate *)dateBySubtractingMonths:(NSInteger) dMonths;
- (NSDate *)dateByAddingDays:(NSInteger) dDays;
- (NSDate *)dateBySubtractingDays:(NSInteger) dDays;

- (BOOL)isToday;
- (BOOL)isTomorrow;
- (BOOL)isYesterday;

- (BOOL)isInFuture;
- (BOOL)isInPast;

- (BOOL)isBeforeDate:(NSDate *)date;
- (BOOL)isAfterDate:(NSDate *)date;

- (NSDate *)startOfDay;
- (NSDate *)endOfDay;

- (NSInteger)daysAfterDate:(NSDate *)date;
- (NSInteger)daysBeforeDate:(NSDate *)date;

+ (NSString *)dateFormatString;
+ (NSString *)timeFormatString;
+ (NSString *)timestampFormatString;
+ (NSString *)dbFormatString;
+ (NSDate *)dateFromString:(NSString *)string withFormat:(NSString *)format;
+ (NSString *)stringFromDate:(NSDate *)date withFormat:(NSString *)format;
- (NSString *)string;

//https://github.com/belkevich/nsdate-calendar
+ (NSDate *)dateWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day;
+ (NSDate *)dateWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day
                    hour:(NSInteger)hour minute:(NSInteger)minute second:(NSInteger)second;

@end
