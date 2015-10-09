//
//  NSDate+NLAdditions.m
//  MyApp
//
//  Created by Nguyen Nang on 4/15/15.
//  Copyright (c) 2015 Nguyen Nang. All rights reserved.
//

#import "NSDate+FFAdditions.h"

static NSString *kNSDateHelperFormatFullDateWithTime    = @"MMM d, yyyy h:mm a";
static NSString *kNSDateHelperFormatFullDate            = @"MMM d, yyyy";
static NSString *kNSDateHelperFormatShortDateWithTime   = @"MMM d h:mm a";
static NSString *kNSDateHelperFormatShortDate           = @"MMM d";
static NSString *kNSDateHelperFormatWeekday             = @"EEEE";
static NSString *kNSDateHelperFormatWeekdayWithTime     = @"EEEE h:mm a";
static NSString *kNSDateHelperFormatTime                = @"h:mm a";
static NSString *kNSDateHelperFormatTimeWithPrefix      = @"'at' h:mm a";
static NSString *kNSDateHelperFormatSQLDate             = @"yyyy-MM-dd";
static NSString *kNSDateHelperFormatSQLTime             = @"HH:mm:ss";
static NSString *kNSDateHelperFormatSQLDateWithTime     = @"yyyy-MM-dd HH:mm:ss";

#define D_DAY		86400

static const unsigned componentFlags = (NSCalendarUnitYear| NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekOfYear |  NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitWeekday | NSCalendarUnitWeekdayOrdinal);

@implementation NSDate (FFAdditions)

@dynamic year;
@dynamic month;
@dynamic day;
@dynamic hour;
@dynamic minute;
@dynamic second;
@dynamic weekday;

static NSString * AZ_DefaultCalendarIdentifier = nil;
static NSLock * AZ_DefaultCalendarIdentifierLock = nil;
static dispatch_once_t AZ_DefaultCalendarIdentifierLock_onceToken;

#pragma mark - private
+ (NSCalendar *)AZ_currentCalendar {
    NSString *key = @"AZ_currentCalendar_";
    NSString *calendarIdentifier = [NSDate AZ_defaultCalendarIdentifier];
    if (calendarIdentifier) {
        key = [key stringByAppendingString:calendarIdentifier];
    }
    NSMutableDictionary *dictionary = [[NSThread currentThread] threadDictionary];
    NSCalendar *currentCalendar = [dictionary objectForKey:key];
    if (currentCalendar == nil) {
        if (calendarIdentifier == nil) {
            currentCalendar = [NSCalendar autoupdatingCurrentCalendar];
        } else {
            currentCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:calendarIdentifier];
            NSAssert(currentCalendar != nil, @"NSDate-Escort failed to create a calendar since the provided calendarIdentifier is invalid.");
        }
        [dictionary setObject:currentCalendar forKey:key];
    }
    return currentCalendar;
}

#pragma mark - Setting default calendar
+ (NSString *)AZ_defaultCalendarIdentifier {
    dispatch_once(&AZ_DefaultCalendarIdentifierLock_onceToken, ^{
        AZ_DefaultCalendarIdentifierLock = [[NSLock alloc] init];
    });
    NSString *string;
    [AZ_DefaultCalendarIdentifierLock lock];
    string = AZ_DefaultCalendarIdentifier;
    [AZ_DefaultCalendarIdentifierLock unlock];
    return string;
}
+ (void)AZ_setDefaultCalendarIdentifier:(NSString *)calendarIdentifier {
    dispatch_once(&AZ_DefaultCalendarIdentifierLock_onceToken, ^{
        AZ_DefaultCalendarIdentifierLock = [[NSLock alloc] init];
    });
    [AZ_DefaultCalendarIdentifierLock lock];
    AZ_DefaultCalendarIdentifier = calendarIdentifier;
    [AZ_DefaultCalendarIdentifierLock unlock];
}

- (NSInteger)year
{
    return [[NSDate AZ_currentCalendar] components:NSCalendarUnitYear
                                           fromDate:self].year;
}

- (NSInteger)month
{
    return [[NSDate AZ_currentCalendar] components:NSCalendarUnitMonth
                                           fromDate:self].month;
}

- (NSInteger)day
{
    return [[NSDate AZ_currentCalendar] components:NSCalendarUnitDay
                                           fromDate:self].day;
}

- (NSInteger)hour
{
    return [[NSDate AZ_currentCalendar] components:NSCalendarUnitHour
                                           fromDate:self].hour;
}

- (NSInteger)minute
{
    return [[NSDate AZ_currentCalendar] components:NSCalendarUnitMinute
                                           fromDate:self].minute;
}

- (NSInteger)second
{
    return [[NSDate AZ_currentCalendar] components:NSCalendarUnitSecond
                                           fromDate:self].second;
}

- (NSInteger)weekday
{
    return [[NSDate AZ_currentCalendar] components:NSCalendarUnitWeekday
                                           fromDate:self].weekday;
}

- (NSString *)stringWithDateFormat:(NSString *)format
{
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    return [dateFormatter stringFromDate:self];
}

- (NSString *)timeAgo
{
    NSTimeInterval delta = [[NSDate date] timeIntervalSinceDate:self];
    
    if (delta < 1 * MINUTE)
    {
        return @"phút trước";
    }
    else if (delta < 2 * MINUTE)
    {
        return @"1 phút trước";
    }
    else if (delta < 45 * MINUTE)
    {
        int minutes = floor((double)delta/MINUTE);
        return [NSString stringWithFormat:@"%d phút trước", minutes];
    }
    else if (delta < 90 * MINUTE)
    {
        return @"1 giờ trước";
    }
    else if (delta < 24 * HOUR)
    {
        int hours = floor((double)delta/HOUR);
        return [NSString stringWithFormat:@"%d giờ trước", hours];
    }
    else if (delta < 48 * HOUR)
    {
        return @"Ngày hôm qua";
    }
    else if (delta < 30 * DAY)
    {
        int days = floor((double)delta/DAY);
        return [NSString stringWithFormat:@"%d ngày trước", days];
    }
    else if (delta < 12 * MONTH)
    {
        int months = floor((double)delta/MONTH);
        return months <= 1 ? @"1 tháng trước" : [NSString stringWithFormat:@"%d tháng trước", months];
    }
    
    int years = floor((double)delta/MONTH/12.0);
    return years <= 1 ? @"1 năm trước" : [NSString stringWithFormat:@"%d năm trước", years];
}

- (NSString *)timeLeft
{
    long int delta = lround( [self timeIntervalSinceDate:[NSDate date]] );
    
    NSMutableString * result = [NSMutableString string];
    
    if ( delta >= YEAR )
    {
        NSInteger years = ( delta / YEAR );
        [result appendFormat:@"%ld年", (long)years];
        delta -= years * YEAR ;
    }
    
    if ( delta >= MONTH )
    {
        NSInteger months = ( delta / MONTH );
        [result appendFormat:@"%ld月", (long)months];
        delta -= months * MONTH ;
    }
    
    if ( delta >= DAY )
    {
        NSInteger days = ( delta / DAY );
        [result appendFormat:@"%ld天", (long)days];
        delta -= days * DAY ;
    }
    
    if ( delta >= HOUR )
    {
        NSInteger hours = ( delta / HOUR );
        [result appendFormat:@"%ld小时", (long)hours];
        delta -= hours * HOUR ;
    }
    
    if ( delta >= MINUTE )
    {
        NSInteger minutes = ( delta / MINUTE );
        [result appendFormat:@"%ld分钟", (long)minutes];
        delta -= minutes * MINUTE ;
    }
    
    NSInteger seconds = ( delta / SECOND );
    [result appendFormat:@"%ld秒", (long)seconds];
    
    return result;
}

+ (long long)timeStamp
{
    return (long long)[[NSDate date] timeIntervalSince1970];
}

+ (NSDate *)dateWithString:(NSString *)string
{
    return nil;
}

+ (NSDate *)now
{
    return [NSDate date];
}

+ (NSDate *)dateWithDaysFromNow:(NSInteger) days
{
    return [[NSDate date] dateByAddingDays:days];
}

+ (NSDate *)dateWithDaysBeforeNow:(NSInteger) days
{
    return [[NSDate date] dateBySubtractingDays:days];
}

+ (NSDate *)dateTomorrow
{
    return [NSDate dateWithDaysFromNow:1];
}

+ (NSDate *)dateYesterday
{
    return [NSDate dateWithDaysBeforeNow:1];
}

#pragma mark-
- (NSDate *)startOfDay
{
    NSDateComponents *components = [self dateComponents];
    components.hour = 0;
    components.minute = 0;
    components.second = 0;
    
    return [[NSDate AZ_currentCalendar] dateFromComponents:components];
}

- (NSDate *)endOfDay
{
    NSDateComponents *components = [self dateComponents];
    components.hour = 23;
    components.minute = 59;
    components.second = 59;
    
    return [[NSDate AZ_currentCalendar] dateFromComponents:components];
}

- (NSDate *)dateByAddingYears:(NSInteger) dYears {
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.year = dYears;
    NSCalendar *calendar = [NSDate AZ_currentCalendar];
    return [calendar dateByAddingComponents:components toDate:self options:0];
}

- (NSDate *)dateBySubtractingYears:(NSInteger) dYears {
    return [self dateByAddingYears:-dYears];
}

- (NSDate *)dateByAddingMonths:(NSInteger) dMonths {
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.month = dMonths;
    NSCalendar *calendar = [NSDate AZ_currentCalendar];
    return [calendar dateByAddingComponents:components toDate:self options:0];
}

- (NSDate *)dateBySubtractingMonths:(NSInteger) dMonths {
    return [self dateByAddingMonths:-dMonths];
}

- (NSDate *)dateByAddingDays:(NSInteger) dDays {
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.day = dDays;
    NSCalendar *calendar = [NSDate AZ_currentCalendar];
    return [calendar dateByAddingComponents:components toDate:self options:0];
}

- (NSDate *)dateBySubtractingDays:(NSInteger) dDays {
    return [self dateByAddingDays:-dDays];
}

- (BOOL)isEqualToDateIgnoringTime:(NSDate *) aDate
{
    NSDateComponents *components1 = [[NSDate AZ_currentCalendar] components:componentFlags fromDate:self];
    NSDateComponents *components2 = [[NSDate AZ_currentCalendar] components:componentFlags fromDate:aDate];
    return ((components1.year == components2.year) &&
            (components1.month == components2.month) &&
            (components1.day == components2.day));
}

- (BOOL)isToday
{
    return [self isEqualToDateIgnoringTime:[NSDate date]];
}

- (BOOL)isTomorrow
{
    return [self isEqualToDateIgnoringTime:[NSDate dateTomorrow]];
}

- (BOOL)isYesterday
{
    return [self isEqualToDateIgnoringTime:[NSDate dateYesterday]];
}

- (BOOL)isBeforeDate:(NSDate *)date
{
    if ([self compare:date] == NSOrderedAscending || [self compare:date] == NSOrderedSame)
        return YES;
    
    return NO;
}

- (BOOL)isAfterDate:(NSDate *)date
{
    if ([self compare:date] == NSOrderedDescending || [self compare:date] == NSOrderedSame)
        return YES;
    
    return NO;
}

- (BOOL)isInFuture
{
    return ([self isAfterDate:[NSDate date]]);
}

- (BOOL)isInPast
{
    return ([self isBeforeDate:[NSDate date]]);
}

- (NSInteger)daysAfterDate:(NSDate *)date
{
    NSTimeInterval ti = [self timeIntervalSinceDate:date];
    return (NSInteger) (ti / D_DAY);
}

- (NSInteger)daysBeforeDate:(NSDate *)date
{
    NSTimeInterval ti = [date timeIntervalSinceDate:self];
    return (NSInteger) (ti / D_DAY);
}

#pragma mark - https://github.com/billymeltdown/nsdate-helper/
+ (NSString *)dateFormatString {
    return kNSDateHelperFormatSQLDate;
}

+ (NSString *)timeFormatString {
    return kNSDateHelperFormatSQLTime;
}

+ (NSString *)timestampFormatString {
    return kNSDateHelperFormatSQLDateWithTime;
}

// preserving for compatibility
+ (NSString *)dbFormatString {
    return [NSDate timestampFormatString];
}

+ (NSDate *)dateFromString:(NSString *)string withFormat:(NSString *)format {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    NSDate *date = [formatter dateFromString:string];
    return date;
}

+ (NSString *)stringFromDate:(NSDate *)date withFormat:(NSString *)format {
    return [date stringWithFormat:format];
}

+ (NSString *)stringFromDate:(NSDate *)date {
    return [date string];
}

- (NSString *)stringWithFormat:(NSString *)format {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    NSString *timestamp_str = [formatter stringFromDate:self];
    return timestamp_str;
}

- (NSString *)string {
    return [self stringWithFormat:[NSDate dbFormatString]];
}

+ (NSDate *)dateWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day
{
    NSDateComponents *components = [self dateComponentsWith:year month:month day:day];
    return [[NSDate AZ_currentCalendar] dateFromComponents:components];
}

+ (NSDate *)dateWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day
                    hour:(NSInteger)hour minute:(NSInteger)minute second:(NSInteger)second
{
    NSDateComponents *components = [self dateComponentsWith:year month:month day:day];
    components.hour = hour;
    components.minute = minute;
    components.second = second;
    return [[NSDate AZ_currentCalendar] dateFromComponents:components];
}

#pragma mark - private

+ (NSDateComponents *)dateComponentsWith:(NSInteger)year month:(NSInteger)month day:(NSInteger)day
{
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.year = year;
    components.month = month;
    components.day = day;
    return components;
}

- (NSDateComponents *)dateComponents
{
    NSCalendar *calendar = [NSDate AZ_currentCalendar];
    NSDateComponents *dateComponents = [calendar components:componentFlags fromDate:self];
    return dateComponents;
}

@end
