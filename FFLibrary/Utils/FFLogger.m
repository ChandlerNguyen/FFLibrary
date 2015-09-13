//
//  FFLogger.m
//  FFLibrary
//
//  Created by Nang Nguyen on 9/13/15.
//  Copyright (c) 2015 MCFF. All rights reserved.
//

#import "FFLogger.h"
#import "DDASLLogger.h"
#import "DDTTYLogger.h"
#import "DDFileLogger.h"

@implementation FFLogLevel
- (instancetype)initWithLevel:(DDLogLevel)level label:(NSString *)label
{
    self = [super init];
    if (self) {
        self.level = level;
        self.label = label;
    }
    
    return self;
}

+ (instancetype)logLevelWithLevel:(DDLogLevel)level label:(NSString *)label
{
    return [[self alloc] initWithLevel:level label:label];
}

@end

@implementation FFLogLevelManager

+ (FFLogLevelManager *)instance
{
    static FFLogLevelManager *_instance = nil;
    
    @synchronized (self) {
        if (_instance == nil) {
            _instance = [[self alloc] init];
        }
    }
    
    return _instance;
}

- (void) setDDLogLevel
{
    ddLogLevel = self.currentLogLevel.level;
    FFInfo(@"ddLogLevel: %@", self.currentLogLevel.label);
    
    NSArray *dynamicLogClasses = [DDLog registeredClasses];
    for (Class classForLog in dynamicLogClasses) {
        [DDLog setLevel:ddLogLevel forClass:classForLog];
    }
    
}

+ (DDLogLevel)ddLogLevel {
    return ddLogLevel;
}

+ (void)ddSetLogLevel:(DDLogLevel)logLevel {
    ddLogLevel = logLevel;
}

- (NSArray *)logLevels
{
    if (!_logLevels) {
        _logLevels = @[
                       [FFLogLevel logLevelWithLevel:DDLogLevelInfo label:@"Info"],
                       [FFLogLevel logLevelWithLevel:DDLogLevelDebug label:@"Debug"],
                       [FFLogLevel logLevelWithLevel:DDLogLevelError label:@"Error"],
                       [FFLogLevel logLevelWithLevel:DDLogLevelWarning label:@"Warning"],
                       [FFLogLevel logLevelWithLevel:DDLogLevelVerbose label:@"Verbose"],
                       [FFLogLevel logLevelWithLevel:DDLogLevelOff label:@"Off"]
                       ];
    }
    return _logLevels;
}

- (NSString *) labelForIndex:(NSUInteger) index
{
    if (index >= [self.logLevels count]) index = 0;
    FFLogLevel* level = self.logLevels[index];
    return level.label;
}

- (NSUInteger) currentLogLevelIndex
{
    //TODO
    //return (NSUInteger) [FFConfigManager instance].globalConfig.logLevel.integerValue;
    return 4;   //Verbose
}

- (FFLogLevel *) currentLogLevel
{
    return self.logLevels[self.currentLogLevelIndex];
}

- (NSString *) currentLogLevelDescription
{
    return [NSString stringWithFormat:@"Log Level: %@", self.currentLogLevel.label];
}

//- (void) presentSelectorWithViewController:(UIViewController *) navigationController
//{
//    
//    UIAlertController *logLevelSelector = [UIAlertController alertControllerWithTitle:@"Select Log Level"
//                                                                              message:@""
//                                                                       preferredStyle:UIAlertControllerStyleActionSheet];
//    
//    //for (NSUInteger index = 0; index < self.logLevels)
//    NSUInteger index = 0;
//    for (FFLogLevel *level in self.logLevels) {
//        NSString *label = level.label;
//        if (index == [[FFConfigManager instance].globalConfig.logLevel intValue]) {
//            label = [NSString stringWithFormat:@"%@*", label];
//        }
//        
//        UIAlertAction *levelAction = [UIAlertAction
//                                      actionWithTitle:label
//                                      style:UIAlertActionStyleDefault
//                                      handler:^(UIAlertAction *action) {
//                                          [self updateLogLevel:index];
//                                          [logLevelSelector dismissViewControllerAnimated:YES completion:nil];
//                                      }];
//        [logLevelSelector addAction:levelAction];
//        index++;
//    }
//    UIAlertAction *cancelAction = [UIAlertAction
//                                   actionWithTitle:@"Cancel"
//                                   style:UIAlertActionStyleDefault
//                                   handler:^(UIAlertAction *action) {
//                                       [logLevelSelector dismissViewControllerAnimated:YES completion:nil];
//                                   }];
//    [logLevelSelector addAction:cancelAction];
//    
//    [navigationController presentViewController:logLevelSelector animated:YES completion:nil];
//    
//}
//
//
//- (void) updateLogLevel:(NSUInteger) level
//{
//    [FFConfigManager instance].globalConfig.logLevel = @(level);
//    [[FFConfigManager instance].globalConfig saveToStore];
//    [self setDDLogLevel];
//}

@end

@implementation FFLogger

+ (void) initLogger
{
    // Log to the Console.app and the Xcode console
    [DDLog addLogger:[DDASLLogger sharedInstance]];
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    
    // Initialized file log and keep the log for a week
    DDFileLogger* fileLogger = [[DDFileLogger alloc] init];
    fileLogger.rollingFrequency = 60 * 60 * 24; // 24 hour rolling
    fileLogger.logFileManager.maximumNumberOfLogFiles = 7;
    
    [DDLog addLogger:fileLogger];
    
    DDLogFileInfo * logFileInfo = fileLogger.currentLogFileInfo;
    FFInfo(@"Log is saved at %@/%@", logFileInfo.filePath, logFileInfo.fileName);
    [[FFLogLevelManager instance] setDDLogLevel];
    
    // Just to get ride of the warning
    __unused DDColor* dummyColor = DDMakeColor(1.0, 1.0, 1.0);
    
}

+ (NSString*) logFilePath
{
    NSArray *allLoggers = [DDLog allLoggers];
    for (NSObject *logger in allLoggers) {
        if ([logger isKindOfClass:[DDFileLogger class]]) {
            DDLogFileInfo * logFileInfo = ((DDFileLogger*)logger).currentLogFileInfo;
            return logFileInfo.filePath;
        }
    }
    return nil;
}

+ (NSData *) logData
{
    return [NSData dataWithContentsOfFile:FFLogger.logFilePath];
}

@end
