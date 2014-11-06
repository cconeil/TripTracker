//
//  Trip.h
//  TripTracker
//
//  Created by Chris O'Neil on 11/4/14.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Trip : NSManagedObject

@property (nonatomic, retain) NSDate * startDate;
@property (nonatomic, retain) NSDate * endDate;
@property (nonatomic, retain) NSString * startLocation;
@property (nonatomic, retain) NSString * endLocation;

@property (nonatomic, assign) double startLongitude;
@property (nonatomic, assign) double startLatitude;
@property (nonatomic, assign) double endLongitude;
@property (nonatomic, assign) double endLatitude;

- (NSString *)route; // returns the route in readable text
- (NSString *)timeSpan; // returns the timeSpan in readable text

@end
