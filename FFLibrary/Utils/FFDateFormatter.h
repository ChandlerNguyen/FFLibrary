//
//  FFDateFormatter.h
//  MCFF
//
//  Created by Nguyen Nang on 6/26/15.
//  Copyright (c) 2015 MCFF. All rights reserved.
//

@interface FFDateFormatter : NSObject

+ (FFDateFormatter *)instance;

- (NSDateFormatter *)dateFormatterWithFormat:(NSString *)format andLocale:(NSLocale *)locale;
- (NSDateFormatter *)dateFormatterWithFormat:(NSString *)format andLocaleIdentifier:(NSString *)localeIdentifier;
- (NSDateFormatter *)dateFormatterWithFormat:(NSString *)format;
- (NSDateFormatter *)dateFormatterWithFormat:(NSString *)format andCalendar:(NSCalendar *)calendar andLocale:(NSLocale *)locale;

- (NSDateFormatter *)dateFormatterWithDateStyle:(NSDateFormatterStyle)dateStyle timeStyle:(NSDateFormatterStyle)timeStyle andLocale:(NSLocale *)locale;
- (NSDateFormatter *)dateFormatterWithDateStyle:(NSDateFormatterStyle)dateStyle timeStyle:(NSDateFormatterStyle)timeStyle andLocaleIdentifier:(NSString *)localeIdentifier;
- (NSDateFormatter *)dateFormatterWithDateStyle:(NSDateFormatterStyle)dateStyle andTimeStyle:(NSDateFormatterStyle)timeStyle;

- (NSString *)shortDateStringForDate:(NSDate *)date;

- (NSString *)shortDateStringForDate:(NSDate *)date andLocaleIdentifier:(NSString *)localeIdentifier;

- (NSString *)longDateStringForDate:(NSDate *)date;

- (NSString *)longDateStringForDate:(NSDate *)date andLocaleIdentifier:(NSString *)localeIdentifier;

- (NSString *)shortDateTimeStringForDate:(NSDate *)date;

- (NSString *)shortDateTimeStringForDate:(NSDate *)date andLocaleIdentifier:(NSString *)localeIdentifier;

- (NSString *)longDateTimeStringForDate:(NSDate *)date;

- (NSString *)longDateTimeStringForDate:(NSDate *)date andLocaleIdentifier:(NSString *)localeIdentifier;

- (NSString *)dateTimeStringForDate:(NSDate *)date format:(NSString *)format;
@end
