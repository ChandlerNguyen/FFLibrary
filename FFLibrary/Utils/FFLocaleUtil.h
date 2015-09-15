//
//  FFLocaleUtil.h
//  MCFF
//
//  Created by Nguyen Nang on 7/23/15.
//  Copyright (c) 2015 MCFF. All rights reserved.
//

@interface FFLocaleUtil : NSObject

+ (NSString *)currentRegionCode;

+ (NSString *)currentLanguageCode;

+ (NSString *)currentLocaleIdentifier;

+ (NSString *)localeIdentifier:(NSLocale *)locale;

+ (NSString *)regionCode:(NSLocale *)locale;

+ (NSString *)languageCode:(NSLocale *)locale;
@end
