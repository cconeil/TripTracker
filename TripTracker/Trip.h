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

- (NSString *)route;
- (NSString *)timeSpan;

@end
