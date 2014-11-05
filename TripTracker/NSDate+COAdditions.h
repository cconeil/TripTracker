//
//  NSDate+COAdditions.h
//  TripTracker
//
//  Created by Chris O'Neil on 11/5/14.
//
//

#import <Foundation/Foundation.h>

@interface NSDate (COAdditions)

- (NSDate *)co_localizedDate;
+ (NSString *)co_timeInWordsBetweenStartDate:(NSDate *)startDate andEndDate:(NSDate *)endDate;

@end
