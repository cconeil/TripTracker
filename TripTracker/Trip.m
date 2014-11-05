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
@dynamic startLatitude;
@dynamic startLongitude;
@dynamic endLatitude;
@dynamic endLongitude;

static NSDateFormatter *_dateFormatter = nil;

- (NSString *)route {
    return [NSString stringWithFormat:@"%@ > %@", self.startLocation, self.endLocation];
}

- (NSString *)timeSpan {
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        [_dateFormatter setDateFormat:@"hh:mma"];
    }

    return [NSString stringWithFormat:@"%@-%@ (%@)", [[_dateFormatter stringFromDate:self.startDate] lowercaseString], [[_dateFormatter stringFromDate:self.endDate] lowercaseString], [NSDate co_timeInWordsBetweenStartDate:self.startDate andEndDate:self.endDate]];
}

@end
