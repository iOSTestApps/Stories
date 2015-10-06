//
//  NSDate+Utilities.h
//  Stories
//
//  Created by Alexandre Thomas on 06/10/15.
//  Copyright © 2015 athomas. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Utilities)

// Convert the given timestamp into a Data object.
+ (NSDate *)convertTimeStampToNSDate:(NSString *)timestamp;

// Add number of days to a date and returns the new calculated date.
+ (NSDate *)addDaysToDate:(NSDate *)startDate withDays:(int)daysToAdd;

// Convert the current date in millisecond
+ (NSNumber *)currentDateAsMillisecond;

@end
