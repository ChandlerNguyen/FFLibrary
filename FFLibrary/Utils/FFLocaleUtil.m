//
//  FFLocaleUtil.m
//  MCFF
//
//  Created by Nguyen Nang on 7/23/15.
//  Copyright (c) 2015 MCFF. All rights reserved.
//

#import "FFLocaleUtil.h"

@implementation FFLocaleUtil

+ (NSString *)currentRegionCode {
    return [FFLocaleUtil regionCode:[NSLocale currentLocale]];
}

+ (NSString *)currentLanguageCode {
    return [FFLocaleUtil languageCode:[NSLocale currentLocale]];
}

+ (NSString *)currentLocaleIdentifier {
    return [FFLocaleUtil localeIdentifier:[NSLocale currentLocale]];
}

+ (NSString *)localeIdentifier:(NSLocale *)locale {
    NSString *localeCode = [locale objectForKey: NSLocaleIdentifier];
    return localeCode;
}

+ (NSString *)regionCode:(NSLocale *)locale {
    NSString *regionCode = [locale objectForKey: NSLocaleCountryCode];
    return regionCode;
}

+ (NSString *)languageCode:(NSLocale *)locale {
    NSString *languageCode = [locale objectForKey: NSLocaleLanguageCode];
    return languageCode;
}

@end
