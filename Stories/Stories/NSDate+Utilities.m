//
//  NSDate+Utilities.m
//  Stories
//
//  Created by Alexandre Thomas on 06/10/15.
//  Copyright © 2015 athomas. All rights reserved.
//

#import "NSDate+Utilities.h"

@implementation NSDate (Utilities)

+ (NSDate *)convertTimeStampToNSDate:(NSString *)timestamp
{
    double timestampValue = [timestamp floatValue] / 1000.0;
    return [NSDate dateWithTimeIntervalSince1970:(NSTimeInterval)timestampValue];
}

+ (NSDate *)addDaysToDate:(NSDate *)startDate withDays:(int)daysToAdd
{
    return [startDate dateByAddingTimeInterval:60 * 60 * 24 * daysToAdd];
}

+ (NSNumber *)currentDateAsMillisecond
{
    long long interval = [NSDate timeIntervalSinceReferenceDate] * 1000;
    return [NSNumber numberWithLongLong:interval];
}

@end
