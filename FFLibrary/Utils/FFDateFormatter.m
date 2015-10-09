//
//  FFDateFormatter.m
//  MCFF
//
//  Created by Nguyen Nang on 6/26/15.
//  Copyright (c) 2015 MCFF. All rights reserved.
//

#import "FFDateFormatter.h"

@interface FFDateFormatter ()

@property (nonatomic, strong) NSCache *loadedDateFormatters;

@end

@implementation FFDateFormatter

- (id)init {
    self = [super init];
    if (self) {
        self.loadedDateFormatters = [[NSCache alloc] init];
        self.loadedDateFormatters.countLimit = 10;
    }
    return self;
}

+ (FFDateFormatter *)instance {
    static FFDateFormatter *sharedInstance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedInstance = [[FFDateFormatter alloc] init];
    });
    
    return sharedInstance;
}

- (NSDateFormatter *)dateFormatterWithFormat:(NSString *)format andCalendar:(NSCalendar *)calendar andLocale:(NSLocale *)locale {
    @synchronized(self) {
        NSString *key = [NSString stringWithFormat:@"format:%@|locale:%@", format, locale.localeIdentifier];
        
        NSDateFormatter *dateFormatter = [self.loadedDateFormatters objectForKey:key];
        if (!dateFormatter) {
            dateFormatter = [[NSDateFormatter alloc] init];
            dateFormatter.dateFormat = [NSDateFormatter dateFormatFromTemplate:format options:0 locale:locale];;
            dateFormatter.locale = locale;
            dateFormatter.calendar = calendar;
            [self.loadedDateFormatters setObject:dateFormatter forKey:key];
        }
        
        return dateFormatter;
    }
}

- (NSDateFormatter *)dateFormatterWithFormat:(NSString *)format andLocale:(NSLocale *)locale {
    @synchronized(self) {
        NSString *key = [NSString stringWithFormat:@"format:%@|locale:%@", format, locale.localeIdentifier];
        
        NSDateFormatter *dateFormatter = [self.loadedDateFormatters objectForKey:key];
        if (!dateFormatter) {
            dateFormatter = [[NSDateFormatter alloc] init];
            dateFormatter.dateFormat = format;
            dateFormatter.locale = locale;
            [self.loadedDateFormatters setObject:dateFormatter forKey:key];
        }
        
        return dateFormatter;
    }
}

- (NSDateFormatter *)dateFormatterWithFormat:(NSString *)format andLocaleIdentifier:(NSString *)localeIdentifier {
    return [self dateFormatterWithFormat:format andLocale:[[NSLocale alloc] initWithLocaleIdentifier:localeIdentifier]];
}

- (NSDateFormatter *)dateFormatterWithFormat:(NSString *)format
{
    return [self dateFormatterWithFormat:format andLocale:[NSLocale currentLocale]];
}

- (NSDateFormatter *)dateFormatterWithDateStyle:(NSDateFormatterStyle)dateStyle timeStyle:(NSDateFormatterStyle)timeStyle andLocale:(NSLocale *)locale {
    @synchronized(self) {
        NSString *key = [NSString stringWithFormat:@"dateStyle:%lu|timeStyle:%lu|locale:%@", (unsigned long)dateStyle, (unsigned long)timeStyle, locale.localeIdentifier];
        
        NSDateFormatter *dateFormatter = [self.loadedDateFormatters objectForKey:key];
        if (!dateFormatter) {
            dateFormatter = [[NSDateFormatter alloc] init];
            dateFormatter.dateStyle = dateStyle;
            dateFormatter.timeStyle = timeStyle;
            dateFormatter.locale = locale;
            [self.loadedDateFormatters setObject:dateFormatter forKey:key];
        }
        
        return dateFormatter;
    }
    
}

- (NSDateFormatter *)dateFormatterWithDateStyle:(NSDateFormatterStyle)dateStyle timeStyle:(NSDateFormatterStyle)timeStyle andLocaleIdentifier:(NSString *)localeIdentifier {
    return [self dateFormatterWithDateStyle:dateStyle timeStyle:timeStyle andLocale:[[NSLocale alloc] initWithLocaleIdentifier:localeIdentifier]];
}

- (NSDateFormatter *)dateFormatterWithDateStyle:(NSDateFormatterStyle)dateStyle andTimeStyle:(NSDateFormatterStyle)timeStyle {
    return [self dateFormatterWithDateStyle:dateStyle timeStyle:timeStyle andLocale:[NSLocale currentLocale]];
}

- (NSString*) shortDateStringForDate:(NSDate*) date {
    return [[self dateFormatterWithDateStyle:NSDateFormatterShortStyle andTimeStyle:NSDateFormatterNoStyle] stringFromDate:date];
}

- (NSString*) shortDateStringForDate:(NSDate*) date andLocaleIdentifier:(NSString *)localeIdentifier {
    return [[self dateFormatterWithDateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterNoStyle andLocaleIdentifier:localeIdentifier] stringFromDate:date];
}

- (NSString *) longDateStringForDate:(NSDate*) date {
    return [[self dateFormatterWithDateStyle:NSDateFormatterLongStyle andTimeStyle:NSDateFormatterNoStyle] stringFromDate:date];
}

- (NSString *) longDateStringForDate:(NSDate*) date andLocaleIdentifier:(NSString *)localeIdentifier {
    return [[self dateFormatterWithDateStyle:NSDateFormatterLongStyle timeStyle:NSDateFormatterNoStyle andLocaleIdentifier:localeIdentifier] stringFromDate:date];
}

- (NSString *) shortDateTimeStringForDate:(NSDate *) date  {
    return [[self dateFormatterWithDateStyle:NSDateFormatterShortStyle andTimeStyle:NSDateFormatterShortStyle] stringFromDate:date];
}

- (NSString *) shortDateTimeStringForDate:(NSDate *) date andLocaleIdentifier:(NSString *)localeIdentifier {
    return [[self dateFormatterWithDateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterShortStyle andLocaleIdentifier:localeIdentifier] stringFromDate:date];
}

- (NSString *) longDateTimeStringForDate:(NSDate *) date {
    return [[self dateFormatterWithDateStyle:NSDateFormatterLongStyle andTimeStyle:NSDateFormatterLongStyle] stringFromDate:date];
}

- (NSString *) longDateTimeStringForDate:(NSDate *) date andLocaleIdentifier:(NSString *)localeIdentifier {
    return [[self dateFormatterWithDateStyle:NSDateFormatterLongStyle timeStyle:NSDateFormatterLongStyle andLocaleIdentifier:localeIdentifier] stringFromDate:date];
}

- (NSString *) dateTimeStringForDate:(NSDate *)date format:(NSString *)format {
    return  [[self dateFormatterWithFormat:format] stringFromDate:date];
}

@end
