//
//  NSDate+COAdditions.m
//  TripTracker
//
//  Created by Chris O'Neil on 11/5/14.
//
//

#import "NSDate+COAdditions.h"

@implementation NSDate (COAdditions)

- (NSDate *)co_localizedDate {
    return [self dateByAddingTimeInterval:[[NSTimeZone localTimeZone] secondsFromGMT]];
}

+ (NSString *)co_timeInWordsBetweenStartDate:(NSDate *)startDate andEndDate:(NSDate *)endDate {
    NSTimeInterval minutes = [endDate timeIntervalSinceDate:startDate] / 60.0;

    if (minutes < 60.0) {
        if (minutes < 1.0) {
            minutes = 1.0;
        }
        return [NSString stringWithFormat:@"%ldmin", (NSInteger)minutes];
    }

    NSTimeInterval hours = minutes / 60.0;
    if (hours < 24.0) {
        if (hours < 1.0) {
            hours = 1.0;
        }
        return [NSString stringWithFormat:@"%ldmins", (NSInteger)hours];
    }

    NSTimeInterval days = hours / 24.0;
    if (days < 1.0) {
        days = 1.0;
    }
    return [NSString stringWithFormat:@"%lddays", (NSInteger)days];
}

@end
