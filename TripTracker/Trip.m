//
//  Trip.m
//  TripTracker
//
//  Created by Chris O'Neil on 11/4/14.
//
//

#import "Trip.h"


@implementation Trip

@dynamic startDate;
@dynamic endDate;
@dynamic startLocation;
@dynamic endLocation;

- (NSString *)route {
    return [NSString stringWithFormat:@"%@ > %@", self.startLocation, self.endLocation];
}

- (NSString *)timeSpan {
    return @"random time span";
}

@end
