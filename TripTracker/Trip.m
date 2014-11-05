//
//  Trip.m
//  TripTracker
//
//  Created by Chris O'Neil on 11/4/14.
//
//

#import "Trip.h"
#import "NSDate+COAdditions.h"

@implementation Trip

@dynamic startDate;
@dynamic endDate;
@dynamic startLocation;
@dynamic endLocation;

static NSDateFormatter *_dateFormatter = nil;

- (NSString *)route {
    return [NSString stringWithFormat:@"%@ > %@", self.startLocation, self.endLocation];
}

- (NSString *)timeSpan {
    NSDate *localStartDate = [self.startDate co_localizedDate];
    NSDate *localEndDate = [self.endDate co_localizedDate];

    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        [_dateFormatter setDateFormat:@"hh:mma"];
    }

    return [NSString stringWithFormat:@"%@-%@ (%@)", [[_dateFormatter stringFromDate:localStartDate] lowercaseString], [[_dateFormatter stringFromDate:localEndDate] lowercaseString], [NSDate co_timeInWordsBetweenStartDate:localStartDate andEndDate:localEndDate]];
}


@end
