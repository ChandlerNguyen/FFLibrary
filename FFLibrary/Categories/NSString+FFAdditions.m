//
//  NSString+FFAdditions.m
//  MyApp
//
//  Created by Nguyen Nang on 4/17/15.
//  Copyright (c) 2015 Nguyen Nang. All rights reserved.
//

#import "NSString+FFAdditions.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSMutableString(FFAdditions)

- (NSMutableStringAppendBlock)APPEND
{
    NSMutableStringAppendBlock block = ^ NSMutableString * ( id first, ... )
    {
        va_list args;
        va_start( args, first );
        
        NSString * append = [[NSString alloc] initWithFormat:first arguments:args];
        [self appendString:append];
        
        va_end( args );
        
        return self;
    };
    
    return block;
}

- (NSMutableStringAppendBlock)LINE
{
    NSMutableStringAppendBlock block = ^ NSMutableString * ( id first, ... )
    {
        if ( first )
        {
            va_list args;
            va_start( args, first );
            
            NSString * append = [[NSString alloc] initWithFormat:first arguments:args];
            [(NSMutableString *)self appendString:append];
            
            va_end( args );
        }
        
        [(NSMutableString *)self appendString:@"\n"];
        
        return self;
    };
    
    return block;
}

- (NSMutableStringReplaceBlock)REPLACE
{
    NSMutableStringReplaceBlock block = ^ NSMutableString * ( NSString * string1, NSString * string2 )
    {
        [self replaceOccurrencesOfString:string1
                              withString:string2
                                 options:NSCaseInsensitiveSearch
                                   range:NSMakeRange(0, self.length)];
        
        return self;
    };
    
    return block;
}

@end

@implementation NSString (FFAdditions)

- (NSStringAppendBlock)APPEND
{
    NSStringAppendBlock block = ^ NSString * ( id first, ... )
    {
        va_list args;
        va_start( args, first );
        
        NSString * append = [[NSString alloc] initWithFormat:first arguments:args];
        
        NSMutableString * copy = [self mutableCopy];
        [copy appendString:append];
        
        va_end( args );
        
        return copy;
    };
    
    return block;
}

- (NSStringAppendBlock)LINE
{
    NSStringAppendBlock block = ^ NSString * ( id first, ... )
    {
        NSMutableString * copy = [self mutableCopy];
        
        if ( first )
        {
            va_list args;
            va_start( args, first );
            
            NSString * append = [[NSString alloc] initWithFormat:first arguments:args];
            [copy appendString:append];
            
            va_end( args );
        }
        
        [copy appendString:@"\n"];
        
        return copy;
    };
    
    return block;
}

- (NSStringReplaceBlock)REPLACE
{
    NSStringReplaceBlock block = ^ NSString * ( NSString * string1, NSString * string2 )
    {
        return [self stringByReplacingOccurrencesOfString:string1 withString:string2];
    };
    
    return block;
}

- (NSData *)MD5Data
{
    //TODO: Implement ME
    return nil;
}

- (NSString *)SHA1
{
    const char *	cstr = [self cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *		data = [NSData dataWithBytes:cstr length:self.length];
    
    uint8_t			digest[CC_SHA1_DIGEST_LENGTH] = { 0 };
    CC_LONG			digestLength = (CC_LONG)data.length;
    
    CC_SHA1( data.bytes, digestLength, digest );
    
    NSMutableString * output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for ( int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++ )
    {
        [output appendFormat:@"%02x", digest[i]];
    }
    
    return output;
}

- (NSData *)data
{
    return [self dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
}

- (NSDate *)date
{
    NSTimeZone * local = [NSTimeZone localTimeZone];
    
    NSString * format = @"yyyy-MM-dd HH:mm:ss";
    NSString * text = [(NSString *)self substringToIndex:format.length];
    
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    
    return [NSDate dateWithTimeInterval:(3600 + [local secondsFromGMT])
                              sinceDate:[dateFormatter dateFromString:text]];
}

- (NSString *)stringByTrimingWhitespace {
    
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (BOOL)hasText {
    
    NSString *trimingStr = [self stringByTrimingWhitespace];
    BOOL hasText = trimingStr.length > 0;
    
    return hasText;
}

- (CGSize)usedSizeForWidth:(CGFloat)width font:(UIFont *)font withAttributes:(NSDictionary *)attributes {
    
    // NSString class method: boundingRectWithSize:options:attributes:context is
    // available only on ios7.0 sdk.
    CGRect frame = [self boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                                      options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading)
                                   attributes:@{NSFontAttributeName: font}
                                      context:nil];
    CGSize size = frame.size;
    size.height = ceilf(size.height) +1;
    size.width = ceilf(size.width);
    
    return size;
}

- (NSString *)MD5 {
    NSData * value;
    
    value = [NSData dataWithBytes:[self UTF8String] length:[self length]];
    value = [value MD5];
    
    if ( value )
    {
        char			tmp[16];
        unsigned char *	hex = (unsigned char *)malloc( 2048 + 1 );
        unsigned char *	bytes = (unsigned char *)[value bytes];
        unsigned long	length = [value length];
        
        hex[0] = '\0';
        
        for ( unsigned long i = 0; i < length; ++i )
        {
            sprintf( tmp, "%02X", bytes[i] );
            strcat( (char *)hex, tmp );
        }
        
        NSString * result = [NSString stringWithUTF8String:(const char *)hex];
        free( hex );
        return result;
    }
    else
    {
        return nil;
    }
}

- (NSString *)URLEncoding
{
    
    NSString * result = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes( kCFAllocatorDefault,
                                                                                              (CFStringRef)self,
                                                                                              NULL,
                                                                                              (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                              kCFStringEncodingUTF8 ));
    return result;
}

- (NSString *)URLDecoding
{
    
    NSMutableString * string = [NSMutableString stringWithString:self];
    [string replaceOccurrencesOfString:@"+"
                            withString:@" "
                               options:NSLiteralSearch
                                 range:NSMakeRange(0, [string length])];
    return [string stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

- (NSString *)urlByAppendingDict:(NSDictionary *)params
{
    return [self urlByAppendingDict:params encoding:YES];
}

- (NSString *)urlByAppendingDict:(NSDictionary *)params encoding:(BOOL)encoding
{
    NSURL * parsedURL = [NSURL URLWithString:self];
    NSString * queryPrefix = parsedURL.query ? @"&" : @"?";
    NSString * query = [NSString queryStringFromDictionary:params encoding:encoding];
    return [NSString stringWithFormat:@"%@%@%@", self, queryPrefix, query];
}

- (NSString *)urlByAppendingArray:(NSArray *)params
{
    return [self urlByAppendingArray:params encoding:YES];
}

- (NSString *)urlByAppendingArray:(NSArray *)params encoding:(BOOL)encoding
{
    NSURL * parsedURL = [NSURL URLWithString:self];
    NSString * queryPrefix = parsedURL.query ? @"&" : @"?";
    NSString * query = [NSString queryStringFromArray:params encoding:encoding];
    return [NSString stringWithFormat:@"%@%@%@", self, queryPrefix, query];
}

- (NSString *)urlByAppendingKeyValues:(id)first, ...
{
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    
    va_list args;
    va_start( args, first );
    
    for ( ;; )
    {
        NSObject<NSCopying> * key = [dict count] ? va_arg( args, NSObject * ) : first;
        if ( nil == key )
            break;
        
        NSObject * value = va_arg( args, NSObject * );
        if ( nil == value )
            break;
        
        [dict setObject:value forKey:key];
    }
    va_end( args );
    return [self urlByAppendingDict:dict];
}

- (BOOL)empty
{
    return [self length] > 0 ? NO : YES;
}

- (BOOL)notEmpty
{
    return [self length] > 0 ? YES : NO;
}

- (BOOL)eq:(NSString *)other
{
    return [self isEqualToString:other];
}

- (BOOL)equal:(NSString *)other
{
    return [self isEqualToString:other];
}

- (BOOL)is:(NSString *)other
{
    return [self isEqualToString:other];
}

- (BOOL)isNot:(NSString *)other
{
    return NO == [self isEqualToString:other];
}

- (NSArray *)split:(NSString *)aString {
    return [self componentsSeparatedByString:aString];
}

- (NSArray *)split {
    return [self componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSString *)trim
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSString *)unwrap
{
    if ( self.length >= 2 )
    {
        if ( [self hasPrefix:@"\""] && [self hasSuffix:@"\""] )
        {
            return [self substringWithRange:NSMakeRange(1, self.length - 2)];
        }
        
        if ( [self hasPrefix:@"'"] && [self hasSuffix:@"'"] )
        {
            return [self substringWithRange:NSMakeRange(1, self.length - 2)];
        }
    }
    
    return self;
}

- (NSString *)repeat:(NSUInteger)count
{
    if ( 0 == count )
        return @"";
    
    NSMutableString * text = [NSMutableString string];
    
    for ( NSUInteger i = 0; i < count; ++i )
    {
        [text appendString:self];
    }
    
    return text;
}

- (NSString *)normalize
{
    return [self stringByReplacingOccurrencesOfString:@"//" withString:@"/"];
}

- (BOOL)isUserName
{
    NSString *		regex = @"(^[A-Za-z0-9]{3,20}$)";
    NSPredicate *	pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    return [pred evaluateWithObject:self];
}

- (BOOL)isChineseUserName
{
    NSString *		regex = @"(^[A-Za-z0-9\u4e00-\u9fa5]{3,20}$)";
    NSPredicate *	pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    return [pred evaluateWithObject:self];
}

- (BOOL)isPassword
{
    NSString *		regex = @"(^[A-Za-z0-9]{6,20}$)";
    NSPredicate *	pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    return [pred evaluateWithObject:self];
}

- (BOOL)isEmail
{
    NSString *		regex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *	pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    return [pred evaluateWithObject:self];
}

- (BOOL)isUrl
{
    NSString *		regex = @"http(s)?:\\/\\/([\\w-]+\\.)+[\\w-]+(\\/[\\w- .\\/?%&=]*)?";
    NSPredicate *	pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    return [pred evaluateWithObject:self];
}

- (BOOL)isIPAddress
{
    NSArray *			components = [self componentsSeparatedByString:@"."];
    NSCharacterSet *	invalidCharacters = [[NSCharacterSet characterSetWithCharactersInString:@"1234567890"] invertedSet];
    
    if ( [components count] == 4 )
    {
        NSString *part1 = [components objectAtIndex:0];
        NSString *part2 = [components objectAtIndex:1];
        NSString *part3 = [components objectAtIndex:2];
        NSString *part4 = [components objectAtIndex:3];
        
        if ( [part1 rangeOfCharacterFromSet:invalidCharacters].location == NSNotFound &&
            [part2 rangeOfCharacterFromSet:invalidCharacters].location == NSNotFound &&
            [part3 rangeOfCharacterFromSet:invalidCharacters].location == NSNotFound &&
            [part4 rangeOfCharacterFromSet:invalidCharacters].location == NSNotFound )
        {
            if ( [part1 intValue] < 255 &&
                [part2 intValue] < 255 &&
                [part3 intValue] < 255 &&
                [part4 intValue] < 255 )
            {
                return YES;
            }
        }
    }
    
    return NO;
}

- (BOOL)isNormal
{
    NSString *		regex = @"([^%&',;=!~?$]+)";
    NSPredicate *	pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    return [pred evaluateWithObject:self];
}

- (BOOL)isTelephone
{
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    NSPredicate *regextestphs = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", PHS];
    
    return  [regextestmobile evaluateWithObject:self]   ||
    [regextestphs evaluateWithObject:self]      ||
    [regextestct evaluateWithObject:self]       ||
    [regextestcu evaluateWithObject:self]       ||
    [regextestcm evaluateWithObject:self];
}

- (BOOL)match:(NSString *)expression
{
    NSRegularExpression * regex = [NSRegularExpression regularExpressionWithPattern:expression
                                                                            options:NSRegularExpressionCaseInsensitive
                                                                              error:nil];
    if ( nil == regex )
        return NO;
    
    NSUInteger numberOfMatches = [regex numberOfMatchesInString:self
                                                        options:0
                                                          range:NSMakeRange(0, self.length)];
    if ( 0 == numberOfMatches )
        return NO;
    
    return YES;
}

- (BOOL)matchAnyOf:(NSArray *)array
{
    for ( NSString * str in array )
    {
        //if ( NSOrderedSame == [self compare:str options:NSCaseInsensitiveSearch] )
        //{
        //    return YES;
        //}
        if ([self match:str]) {
            return YES;
        }
    }
    
    return NO;
}

- (NSInteger)matchAnyOf2:(NSArray *)array
{
    for ( NSString * str in array )
    {
        if ([self match:str]) {
            return [array indexOfObject:str];
        }
    }
    
    return -1;
}

- (NSArray *)allURLs
{
    NSMutableArray * array = [NSMutableArray array];
    NSCharacterSet * charSet = [[NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789$-_.+!*'():/"] invertedSet];
    
    NSInteger stringIndex = 0;
    while ( stringIndex < self.length )
    {
        NSRange searchRange = NSMakeRange(stringIndex, self.length - stringIndex);
        NSRange httpRange = [self rangeOfString:@"http://" options:NSCaseInsensitiveSearch range:searchRange];
        NSRange httpsRange = [self rangeOfString:@"https://" options:NSCaseInsensitiveSearch range:searchRange];
        
        NSRange startRange;
        if ( httpRange.location == NSNotFound )
        {
            startRange = httpsRange;
        }
        else if ( httpsRange.location == NSNotFound )
        {
            startRange = httpRange;
        }
        else
        {
            startRange = (httpRange.location < httpsRange.location) ? httpRange : httpsRange;
        }
        
        if (startRange.location == NSNotFound)
        {
            break;
        }
        else
        {
            NSRange beforeRange = NSMakeRange( searchRange.location, startRange.location - searchRange.location );
            if ( beforeRange.length )
            {
                //				NSString * text = [string substringWithRange:beforeRange];
                //				[array addObject:text];
            }
            
            NSRange subSearchRange = NSMakeRange(startRange.location, self.length - startRange.location);
            //			NSRange endRange = [self rangeOfString:@" " options:NSCaseInsensitiveSearch range:subSearchRange];
            NSRange endRange = [self rangeOfCharacterFromSet:charSet options:NSCaseInsensitiveSearch range:subSearchRange];
            if ( endRange.location == NSNotFound)
            {
                NSString * url = [self substringWithRange:subSearchRange];
                [array addObject:url];
                break;
            }
            else
            {
                NSRange URLRange = NSMakeRange(startRange.location, endRange.location - startRange.location);
                NSString * url = [self substringWithRange:URLRange];
                [array addObject:url];
                
                stringIndex = endRange.location;
            }
        }
    }
    
    return array;
}

#pragma mark - Replace
- (NSString *)stringWithoutLinebreaks {
    return [self stringByReplacingMatchesOfPattern:@"[ \t]*[\r\n]+"
                                      withTemplate:@" "];
}

- (NSString *)stringByReplacingMatchesOfPattern:(NSString *)pattern withTemplate:(NSString *)replaceTemplate {
    NSError* error;
    NSRegularExpression* regex = [NSRegularExpression regularExpressionWithPattern:pattern
                                                                           options:0
                                                                             error:&error];
    NSString* newString = [regex stringByReplacingMatchesInString:self
                                                          options:0
                                                            range:NSMakeRange(0, self.length)
                                                     withTemplate:replaceTemplate];
    if (error != nil) {
        @throw [NSException exceptionWithName:error.domain
                                       reason:error.description
                                     userInfo:error.userInfo];
    }
    return newString;
}

#pragma mark -
+ (NSString *)fromResource:(NSString *)resName
{
    NSString *	extension = [resName pathExtension];
    NSString *	fullName = [resName substringToIndex:(resName.length - extension.length - 1)];
    
    NSString * path = [[NSBundle mainBundle] pathForResource:fullName ofType:extension];
    return [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:NULL];
}

+ (NSString *)queryStringFromDictionary:(NSDictionary *)dict
{
    return [self queryStringFromDictionary:dict encoding:YES];
}

+ (NSString *)queryStringFromDictionary:(NSDictionary *)arguments encoding:(BOOL)encoding
{
    NSMutableArray *argumentsArray = [NSMutableArray array];
    for (NSString *key in arguments) {
        NSString *value = [[arguments objectForKey:key] description];
        
        NSString *safeKey = [key stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
        NSString *safeValue = [value stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
        
        [argumentsArray addObject:[NSString stringWithFormat:@"%@=%@", safeKey, safeValue]];
    }
    NSString *argumentsString = [argumentsArray componentsJoinedByString:@"&"];
    return argumentsString;
}

+ (NSString *)queryStringFromArray:(NSArray *)array
{
    return [self queryStringFromArray:array encoding:YES];
}

+ (NSString *)queryStringFromArray:(NSArray *)array encoding:(BOOL)encoding
{
    NSMutableArray *pairs = [NSMutableArray array];
    
    for ( NSUInteger i = 0; i < [array count]; i += 2 )
    {
        NSObject * obj1 = [array objectAtIndex:i];
        NSObject * obj2 = [array objectAtIndex:i + 1];
        
        NSString * key = nil;
        NSString * value = nil;
        
        if ( [obj1 isKindOfClass:[NSNumber class]] )
        {
            key = [(NSNumber *)obj1 stringValue];
        }
        else if ( [obj1 isKindOfClass:[NSString class]] )
        {
            key = (NSString *)obj1;
        }
        else
        {
            continue;
        }
        
        if ( [obj2 isKindOfClass:[NSNumber class]] )
        {
            value = [(NSNumber *)obj2 stringValue];
        }
        else if ( [obj1 isKindOfClass:[NSString class]] )
        {
            value = (NSString *)obj2;
        }
        else
        {
            continue;
        }
        
        NSString * urlEncoding = encoding ? [value URLEncoding] : value;
        [pairs addObject:[NSString stringWithFormat:@"%@=%@", key, urlEncoding]];
    }
    
    return [pairs componentsJoinedByString:@"&"];
}

+ (NSString *)queryStringFromKeyValues:(id)first, ...
{
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    
    va_list args;
    va_start( args, first );
    
    for ( ;; )
    {
        NSObject<NSCopying> * key = [dict count] ? va_arg( args, NSObject * ) : first;
        if ( nil == key )
            break;
        
        NSObject * value = va_arg( args, NSObject * );
        if ( nil == value )
            break;
        
        [dict setObject:value forKey:key];
    }
    va_end( args );
    return [NSString queryStringFromDictionary:dict];
}


@end
