//
//  NSDate+COAdditions.m
//  TripTracker
//
//  Created by Chris O'Neil on 11/5/14.
//
//

#import "NSDate+COAdditions.h"

@implementation NSDate (COAdditions)

+ (NSString *)co_timeInWordsBetweenStartDate:(NSDate *)startDate andEndDate:(NSDate *)endDate {
    NSTimeInterval seconds = [endDate timeIntervalSinceDate:startDate];
    NSTimeInterval minutes = seconds / 60.0;
    NSTimeInterval hours = minutes / 60.0;


    BOOL includeHours = NO, includeHoursPlural = NO;
    if (hours > 1.0) {
        includeHours = YES;
        if (hours > 2.0) {
            includeHoursPlural = YES;
        }
    }

    BOOL includeMinutes = NO, includeMinutesPlural = NO;
    if (minutes > 1.0) {
        includeMinutes = YES;
        if (minutes > 2.0) {
            includeMinutesPlural = YES;
        }
    }

    BOOL includeSeconds = NO, includeSecondsPlural = NO;
    if (seconds > 1.0) {
        includeSeconds = YES;
        if (seconds > 2.0) {
            includeSecondsPlural = YES;
        }
    }

    NSString *hourDescriptor = includeHoursPlural ? NSLocalizedString(@"hrs", nil) : NSLocalizedString(@"hr", nil);
    NSString *minutesDescriptor = includeMinutesPlural ? NSLocalizedString(@"mins", nil) : NSLocalizedString(@"min", nil);
    NSString *secondsDescriptor = includeSecondsPlural ? NSLocalizedString(@"secs", nil) : NSLocalizedString(@"sec", nil);

    int h = (int)hours;
    int m = (int)minutes % 60;
    int s = (int)seconds % 60;

    // Always include everyting less than the highest form of time
    if (includeHours) {
        return [NSString stringWithFormat:@"%d%@, %d%@, %d%@", h, hourDescriptor, m, minutesDescriptor, s, secondsDescriptor];
    } else if (includeMinutes) {
        return [NSString stringWithFormat:@"%d%@, %d%@", m, minutesDescriptor, s, secondsDescriptor];
    } else {
        return [NSString stringWithFormat:@"%d%@", s, secondsDescriptor];
    }
}

@end
