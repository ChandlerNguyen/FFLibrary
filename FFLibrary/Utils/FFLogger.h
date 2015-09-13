//
//  FFLogger.h
//  FFLibrary
//
//  Created by Nang Nguyen on 9/13/15.
//  Copyright (c) 2015 MCFF. All rights reserved.
//

#import "DDLogMacros.h"

static DDLogLevel ddLogLevel;

/**
 * Log Level.
 */
@interface FFLogLevel : NSObject

/// DDLogLevel
@property (nonatomic, assign) DDLogLevel level;

/// label for UI.
@property (nonatomic, copy) NSString* label;

+ (instancetype)logLevelWithLevel:(DDLogLevel)level label:(NSString *)label;

@end

/**
 * Manage the log level data and UI.
 */
@interface FFLogLevelManager: NSObject

@property (nonatomic, strong) NSArray *logLevels;

+ (FFLogLevelManager *)instance;

- (NSString *) currentLogLevelDescription;

- (NSString *) labelForIndex:(NSUInteger) index;

//- (void) presentSelectorWithViewController:(UIViewController *) navigationController;

- (void) setDDLogLevel;

@end

@interface FFLogger : NSObject

/**
 * Initialize logger for the application.
 */
+ (void) initLogger;

/**
 * Full file path for the current log file.
 */
+ (NSString*) logFilePath;

/**
 * Log Data.
 */
+ (NSData *) logData;

@end
